import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:health_gauge/download_file/model/firmware_version_list_model.dart';
import 'package:health_gauge/download_file/model/firmware_version_model.dart';

abstract class DownloadState extends Equatable{
  const DownloadState();
}

class FirmwareVersionSuccessState extends DownloadState {
  final FirmwareVersionListModel model;

  FirmwareVersionSuccessState({required this.model});

  @override
  List<Object> get props => [model];
}

class EmptyState extends DownloadState{
  const EmptyState();

  @override
  List<Object> get props=>[];
}

class PauseSuccessState extends DownloadState{
  final String taskId;
   PauseSuccessState({required this.taskId});

  @override
  List<Object> get props=>[taskId];
}

class DeleteSuccessState extends DownloadState{
  final String taskId;
  DeleteSuccessState({required this.taskId});

  @override
  List<Object> get props=>[taskId];
}

class CancelSuccessState extends DownloadState{
  final String taskId;
  CancelSuccessState({required this.taskId});

  @override
  List<Object> get props=>[taskId];
}

class TaskGeneratedSuccessState extends DownloadState{
  final String taskID;
  final String link;
  TaskGeneratedSuccessState({required this.taskID, required this.link});

  @override
  List<Object> get props=>[this.taskID];
}

class TaskPauseSuccessState extends DownloadState{
  final String taskID;
  TaskPauseSuccessState({required this.taskID});

  @override
  List<Object> get props=>[this.taskID];
}

class TaskResetSuccessState extends DownloadState{
  final String taskID;
  TaskResetSuccessState({required this.taskID});

  @override
  List<Object> get props=>[this.taskID];
}

class ProgressPercentState extends DownloadState{
  final String taskId;
  final int progress;
  final DownloadTaskStatus status;
  ProgressPercentState({required this.taskId, required this.progress, required this.status});

  @override
  List<Object> get props => [status,progress,taskId];
}

class UpdateTaskSuccessState extends DownloadState {
  final String oldTaskId;
  final String newTaskId;

  UpdateTaskSuccessState({required this.oldTaskId, required this.newTaskId});

  @override
  List<Object> get props => [oldTaskId, newTaskId];
}

class FileSelectedState extends DownloadState {
  final String path;
  final String name;
  final int size;

  FileSelectedState({required this.path, required this.name, required this.size});

  @override
  List<Object> get props => [path, name, size];
}