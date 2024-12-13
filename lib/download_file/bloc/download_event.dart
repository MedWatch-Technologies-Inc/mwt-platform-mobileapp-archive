

import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
abstract class DownloadEvent extends Equatable{
  const DownloadEvent();
}


class GetEvent extends DownloadEvent {

  @override
  List<Object> get props => [];
}

class GenerateTaskEvent extends DownloadEvent{
  final String link;
  final String name;

  GenerateTaskEvent({required this.link, required this.name});

  @override
  List<Object> get props => [];
}

class PauseEvent extends DownloadEvent{
  final String taskId;
  PauseEvent({required this.taskId});

  @override
  List<Object> get props => [];
}

class RetryEvent extends DownloadEvent{
  final String taskId;
  RetryEvent({required this.taskId});

@override
List<Object> get props => [];
}

class DeleteEvent extends DownloadEvent{
  final String taskId;
  DeleteEvent({required this.taskId});

  @override
  List<Object> get props => [];
}

class ResumeEvent extends DownloadEvent{
  final String taskId;
  ResumeEvent({required this.taskId});

  @override
  List<Object> get props => [];
}

class CancelEvent extends DownloadEvent{
  final String taskId;
  CancelEvent({required this.taskId});

  @override
  List<Object> get props => [];
}

class SendProgressEvent extends DownloadEvent{
  final String taskId;
  final int progress;
  final DownloadTaskStatus status;
  SendProgressEvent({required this.taskId, required this.progress, required this.status});

  @override
  List<Object> get props => [];
}

class UpdateTaskEvent extends DownloadEvent {
  final String oldTaskId;
  final String newTaskId;

  UpdateTaskEvent({required this.newTaskId, required this.oldTaskId});

  @override
  List<Object> get props => [];
}

class SelectFileEvent extends DownloadEvent {
  final String name;
  final String path;
  final int size;

  SelectFileEvent({required this.name, required this.path, required this.size});

  @override
  List<Object> get props => [];
}

class GetFirmwareVersionEvent extends DownloadEvent {
  GetFirmwareVersionEvent();

  @override
  List<Object> get props => [];
}