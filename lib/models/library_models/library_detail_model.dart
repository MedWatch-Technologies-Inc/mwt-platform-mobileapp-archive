import 'package:health_gauge/repository/library/model/fetch_library_event_result.dart';

import 'library_list.dart';

class LibraryDetailModel {
  bool? result;
  int? response;
  List<LibraryList>? data;

  LibraryDetailModel({this.result, this.response, this.data});

  LibraryDetailModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <LibraryList>[];
      json['Data'].forEach((v) {
        data?.add(LibraryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    data['Response'] = response;
    if (this.data != null) {
      data['Data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static LibraryDetailModel mapper(FetchLibraryEventResult obj) {
    var model = LibraryDetailModel();
    model
      ..response = obj.response
      ..result = obj.result
      ..data = obj.data != null
          ? List<LibraryList>.from(obj.data!.map((e) => LibraryList()
            ..createdDateTimeStamp = e.createdDateTimeStamp
            ..createdDateTime = e.createdDateTime
            ..libraryID = e.libraryID
            ..fileSize = e.fileSize
            ..isFolder = e.isFolder
            ..parentID = e.parentID
            ..physicalFilePath = e.physicalFilePath
            ..virtualFilePath = e.virtualFilePath))
          : [];
    return model;
  }
}
