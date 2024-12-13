//import 'dart:html';
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();
}

class FetchLibraryEvent extends LibraryEvent {
  final String? userId;
  final int? libraryId;
  final int? pageId;
  FetchLibraryEvent({
    this.userId,
    this.libraryId,
    this.pageId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryCreateFolderEvent extends LibraryEvent {
  final String? userId;
  final int? libraryId;
  final String? folderName;
  final String? folderPath;

  LibraryCreateFolderEvent({
    this.userId,
    this.libraryId,
    this.folderName,
    this.folderPath,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryUploadFolderEvent extends LibraryEvent {
  final List<File>? filePath;
  final String? userId;
  final String? folderPath;
  final int? libraryId;
  LibraryUploadFolderEvent({
    this.filePath,
    this.folderPath,
    this.userId,
    this.libraryId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryDeleteFolderEvent extends LibraryEvent {
  final String? userId;
  final int? deleteLibraryId;
  final int? libraryId;
  LibraryDeleteFolderEvent({
    this.libraryId,
    this.userId,
    this.deleteLibraryId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryDeleteFolderPermanentlyEvent extends LibraryEvent {
  final String? userId;
  final int? deleteLibraryId;
  final int? libraryId;
  LibraryDeleteFolderPermanentlyEvent({
    this.deleteLibraryId,
    this.userId,
    this.libraryId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryShareFolderEvent extends LibraryEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryChangeLinkAccessSpecifier extends LibraryEvent {
  final int? userId;
  final int? libraryId;
  final int? accessSpecifier;

  LibraryChangeLinkAccessSpecifier(
      {this.libraryId, this.userId, this.accessSpecifier});

  @override
  List<Object> get props => [];
}

class LibraryRestoreEvent extends LibraryEvent {
  final int? userId;
  final int? libraryId;

  LibraryRestoreEvent({this.userId, this.libraryId});

  @override
  List<Object> get props => [];
}

class DeleteSharedEvent extends LibraryEvent {
  final String? userId;
  final int? deleteLibraryId;
  final int? libraryId;
  DeleteSharedEvent({
    this.deleteLibraryId,
    this.userId,
    this.libraryId,
  });
  @override
  List<Object> get props => [];
}

class SaveAndUpdateSharedWith extends LibraryEvent {
  final String? sharedMessage;
  final int? userID;
  final int? fKLirabaryID;
  final List<int>? fKSharedUserID;
  final int? accessspicefire;
  final List<int>? savedAccessID;
  final List<int>? savedAccessChanged;

  SaveAndUpdateSharedWith(
      {this.userID,
      this.accessspicefire,
      this.fKLirabaryID,
      this.fKSharedUserID,
      this.savedAccessChanged,
      this.savedAccessID,
      this.sharedMessage});
  @override
  List<Object> get props => [];
}
