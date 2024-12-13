import 'package:equatable/equatable.dart';
import 'package:health_gauge/models/library_models/delete_folder_model.dart';
import 'package:health_gauge/models/library_models/library_detail_model.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();
}

class LibraryIsLoadingState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryIsLoadedState extends LibraryState {
  final LibraryDetailModel? libraryDetailModel;

  LibraryIsLoadedState({this.libraryDetailModel});
  @override
  // TODO: implement props
  List<Object> get props => [libraryDetailModel!];
}

class LibraryFolderDeleteSuccessState extends LibraryState {
  final DeleteFolderModel deleteFolderModel;

  LibraryFolderDeleteSuccessState(this.deleteFolderModel);
  @override
  // TODO: implement props
  List<Object> get props => [deleteFolderModel];
}

class LibraryFolderDeleteUnsuccessfulState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryFolderCreateSuccessState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryFolderCreateUnSuccessfulState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryFolderUploadSuccessfulState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LibraryFolderUploadUnsuccessfulState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LinkAccessChangedState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RestoredSuccessState extends LibraryState {
  final DeleteFolderModel deleteFolderModel;

  RestoredSuccessState(this.deleteFolderModel);

  @override
  List<Object> get props => [deleteFolderModel];
}

class SaveAndUpdateSharedWithSuccessState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SaveAndUpdateSharedWithUnSuccessState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SharingWithUserState extends LibraryState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
