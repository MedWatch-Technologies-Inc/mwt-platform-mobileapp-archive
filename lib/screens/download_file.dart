import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/download_file/bloc/download_bloc.dart';
import 'package:health_gauge/download_file/bloc/download_event.dart';
import 'package:health_gauge/download_file/bloc/download_state.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class DownloadFile extends StatefulWidget {
  const DownloadFile({Key? key}) : super(key: key);

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  List<_TaskInfo> _tasks = [];
  List<_ItemHolder> _items = [];
  final _documents = [
    // {
    //   'name': 'Learning Android Studio',
    //   'link':
    //       'http://barbra-coco.dyndns.org/student/learning_android_studio.pdf'
    // },
    // {
    //   'name': 'Android Programming Cookbook',
    //   'link':
    //       'http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf'
    // },
  ];

  final _images = [
    // {
    //   'name': 'Arches National Park',
    //   'link':
    //       'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg'
    // },
    {
      'name': 'Canyonlands National Park',
      'link':
          'https://upload.wikimedia.org/wikipedia/commons/7/78/Canyonlands_National_Park%E2%80%A6Needles_area_%286294480744%29.jpg'
    },
  ];

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  late DownloadBloc downloadBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadBloc = BlocProvider.of<DownloadBloc>(context);
    _prepare();
  }

  @override
  void dispose() {
    super.dispose();
    downloadBloc.close();
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    // _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name']!, link: image['link']!)));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: isDarkMode()
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex('#384341').withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: isDarkMode()
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: isDarkMode()
                  ? Image.asset(
                      'asset/dark_leftArrow.png',
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
            ),
            title: SizedBox(
              height: 28.h,
              child: AutoSizeText(
                stringLocalization.getText(StringLocalization.updateFirmware),
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocConsumer<DownloadBloc, DownloadState>(
            bloc: downloadBloc,
            listener: (context, state) {
              if (state is TaskGeneratedSuccessState) {
                _TaskInfo task =
                    _tasks.firstWhere((element) => element.link == state.link);
                task.taskId = state.taskID;
              }
              if (state is PauseSuccessState) {
                _TaskInfo task = _tasks
                    .firstWhere((element) => element.taskId == state.taskId);
                task.taskId = state.taskId;
              }
              if (state is ProgressPercentState) {
                _TaskInfo task = _tasks
                    .firstWhere((element) => element.taskId == state.taskId);
                task.taskId = state.taskId;
                task.status = state.status;
                task.progress = state.progress;
              }
              if (state is CancelSuccessState) {
                _TaskInfo task = _tasks
                    .firstWhere((element) => element.taskId == state.taskId);
                task.taskId = state.taskId;
              }
              if (state is UpdateTaskSuccessState) {
                _TaskInfo task = _tasks
                    .firstWhere((element) => element.taskId == state.oldTaskId);
                task.taskId = state.newTaskId;
              }
              if (state is DeleteSuccessState) {
                _TaskInfo task = _tasks
                    .firstWhere((element) => element.taskId == state.taskId);
                task.taskId = state.taskId;
              }
            },
            builder: (context, state) {
              if (state is DeleteSuccessState) {
                _prepare();
              }
              if (state is FileSelectedState) {
                return _buildDownloadList(
                    picking: true, name: state.name, size: state.size);
              }
              return _buildDownloadList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            File file = File(result.files.single.path!);
            downloadBloc.add(SelectFileEvent(
                name: result.files.single.name,
                path: result.files.single.path!,
                size: result.files.single.size));
            // Scaffold.of(context).showSnackBar(SnackBar(content: Text('${result.files.single}')));
          } else {
            // User canceled the picker
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildListSection(String title) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18.0),
        ),
      );

  Widget _buildDownloadList({bool picking = false, String? name, int? size}) =>
      Container(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: _items
                  .map((item) => item.task == null
                      ? _buildListSection(item.name)
                      : DownloadItem(
                          data: item,
                          onItemClick: (task) {
                            // _openDownloadedFile(task).then((success) {
                            //   if (!success) {
                            //     Scaffold.of(context).showSnackBar(SnackBar(
                            //         content: Text('Cannot open this file')));
                            //   }
                            // });
                          },
                          onAtionClick: (task) {
                            if (task.status == DownloadTaskStatus.undefined) {
                              downloadBloc.add(GenerateTaskEvent(
                                  link: task.link, name: task.name));
                              // _requestDownload(task);
                            } else if (task.status ==
                                DownloadTaskStatus.running) {
                              downloadBloc
                                  .add(PauseEvent(taskId: task.taskId!));
                            } else if (task.status ==
                                DownloadTaskStatus.paused) {
                              downloadBloc
                                  .add(ResumeEvent(taskId: task.taskId!));
                            } else if (task.status ==
                                DownloadTaskStatus.complete) {
                              // _delete(task);
                              downloadBloc
                                  .add(DeleteEvent(taskId: task.taskId!));
                            } else if (task.status ==
                                DownloadTaskStatus.failed) {
                              downloadBloc
                                  .add(RetryEvent(taskId: task.taskId!));
                            }
                          },
                        ))
                  .toList() +
              (picking
                  ? [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Picked File', style: TextStyle(fontSize: 18)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name :',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '$name',
                                  maxLines: 2,
                                  style: TextStyle(),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Size :',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '${size! / 1024} KB',
                                  style: TextStyle(),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ]
                  : []),
        ),
      );
}

class DownloadItem extends StatelessWidget {
  final _ItemHolder data;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo)? onAtionClick;

  DownloadItem(
      {required this.data, required this.onItemClick, this.onAtionClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: InkWell(
        onTap: data.task!.status == DownloadTaskStatus.complete
            ? () {
                onItemClick(data.task!);
              }
            : null,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 64.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      data.name,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildActionForTask(data.task!),
                  ),
                ],
              ),
            ),
            data.task!.status == DownloadTaskStatus.running ||
                    data.task!.status == DownloadTaskStatus.paused
                ? Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: LinearProgressIndicator(
                      value: data.task!.progress / 100,
                    ),
                  )
                : Container()
          ].where((child) => child != null).toList(),
        ),
      ),
    );
  }

  Widget? _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick!(task);
        },
        child: Icon(Icons.file_download),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick!(task);
        },
        child: Icon(
          Icons.pause,
          color: Colors.red,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick!(task);
        },
        child: Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Ready',
            style: TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              onAtionClick!(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              onAtionClick!(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String? taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({required this.name, required this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo? task;

  _ItemHolder({required this.name, this.task});
}
