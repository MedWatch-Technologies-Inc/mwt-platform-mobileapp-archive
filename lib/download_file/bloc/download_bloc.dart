import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:health_gauge/download_file/api/firmware_version_list_api.dart';
import 'package:health_gauge/download_file/bloc/download_event.dart';
import 'package:health_gauge/download_file/bloc/download_state.dart';
import 'package:health_gauge/download_file/model/firmware_version_list_model.dart';
import 'package:health_gauge/repository/firmware/firmware_repository.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  @override
  DownloadState get initialState => EmptyState();

  String? localPath;
  bool? _permissionReady;
  ReceivePort _port = ReceivePort();

  DownloadBloc() : super(EmptyState()) {
    _prepare();
    getLocalDirectory();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _prepare() {}

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) send.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print(data);
      add(SendProgressEvent(taskId: id, status: status, progress: progress));
    });
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String?> _findLocalPath() async {
    try {
      final localDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      if (localDir != null) return localDir.path;
    } catch (e) {
      print(e);
    }
  }

  getLocalDirectory() async {
    _permissionReady = await _checkPermission();
    localPath = (await _findLocalPath())! + Platform.pathSeparator + 'Download';
    // uncomment when you want to change the folder to download
    // String newLocalPath = '/storage/emulated/0'+ Platform.pathSeparator + 'Download';
    // final newSavedDir = Directory(newLocalPath);
    // bool exist = await newSavedDir.exists();
    // if(!exist){
    //   newSavedDir.create();
    //   print('not exist');
    // }
    // localPath = newLocalPath;
    // uncomment till here
    final savedDir = Directory(localPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  dynamic generateTask(String link) async {
    final taskId = await FlutterDownloader.enqueue(
      url: link,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: localPath!,
      showNotification: true,
      openFileFromNotification: true,
    );
    return taskId;
  }

  void _cancelDownload(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
  }

  void _pauseDownload(String taskId) async {
    await FlutterDownloader.pause(taskId: taskId);
  }

  void _resumeDownload(String taskId) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: taskId);
    if (newTaskId != null)
      add(UpdateTaskEvent(oldTaskId: taskId, newTaskId: newTaskId));
  }

  void _delete(String taskId) async {
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
  }

  void _retryDownload(String taskId) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: taskId);
    if (newTaskId != null)
      add(UpdateTaskEvent(oldTaskId: taskId, newTaskId: newTaskId));
  }

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    if (event is GenerateTaskEvent) {
      yield TaskGeneratedSuccessState(
          taskID: await generateTask(event.link), link: event.link);
    }
    if (event is PauseEvent) {
      _pauseDownload(event.taskId);
      yield PauseSuccessState(taskId: event.taskId);
    }
    if (event is ResumeEvent) {
      _resumeDownload(event.taskId);
    }
    if (event is RetryEvent) {
      _retryDownload(event.taskId);
    }
    if (event is SendProgressEvent) {
      yield ProgressPercentState(
          progress: event.progress, taskId: event.taskId, status: event.status);
    }
    if (event is CancelEvent) {
      _cancelDownload(event.taskId);
      yield CancelSuccessState(taskId: event.taskId);
    }
    if (event is UpdateTaskEvent) {
      yield UpdateTaskSuccessState(
          newTaskId: event.newTaskId, oldTaskId: event.oldTaskId);
    }
    if (event is DeleteEvent) {
      _delete(event.taskId);
      yield DeleteSuccessState(taskId: event.taskId);
    }
    if (event is SelectFileEvent) {
      yield FileSelectedState(
          name: event.name, path: event.path, size: event.size);
    }
    if (event is GetFirmwareVersionEvent) {
      var result = await FirmwareRepository().getFirmwareVersionList(1, 10);
      if (result.hasData) {
        if (result.getData!.result!) {
          var model = FirmwareVersionListModel(
              data: result.getData!.data != null && result.getData!.data != ''
                  ? result.getData!.data!
                      .map((e) => FirmwareVersionModel.fromJson(e.toJson()))
                      .toList()
                  : [],
              result: result.getData!.result!);
          final tasks = await FlutterDownloader.loadTasks();
          tasks?.forEach((task) {
            print(task.filename);
            for (var data in model.data ?? []) {
              if (data.downloadUrl == task.url) {
                data.taskId = task.taskId;
                data.status = task.status;
                data.progress = task.progress;
              }
            }
          });
          yield FirmwareVersionSuccessState(model: model);
        }
      } else {
        yield FirmwareVersionSuccessState(
            model: FirmwareVersionListModel(result: false, data: []));
      }
      // FirmwareVersionListModel model = await FirmwareVersionListApi().callApi(
      //     Constants.baseUrl + 'GetFirmwareVersionList?PageNumber=1&PageSize=10',
      //     '');
      // print(model);
      // if (model.result != null && model.result!) {
      //   final tasks = await FlutterDownloader.loadTasks();
      //   tasks?.forEach((task) {
      //     print(task.filename);
      //     for (var data in model.data ?? [])
      //       if (data.downloadUrl == task.url) {
      //         data.taskId = task.taskId;
      //         data.status = task.status;
      //         data.progress = task.progress;
      //       }
      //   });
      //   yield FirmwareVersionSuccessState(model: model);
      // }
    }
  }
}
