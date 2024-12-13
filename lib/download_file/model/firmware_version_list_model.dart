import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:health_gauge/repository/firmware/model/get_firmware_version_list_result.dart';

class FirmwareVersionListModel {
  bool? result;
  List<FirmwareVersionModel>? data;

  FirmwareVersionListModel({this.result, this.data});

  FirmwareVersionListModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data!.add(FirmwareVersionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static FirmwareVersionListModel mapper(GetFirmwareVersionListResult obj) {
    var model = FirmwareVersionListModel();
    model
      ..result = obj.result
      ..data = obj.data != null
          ? List<FirmwareVersionModel>.from(
              obj.data!.map((e) => FirmwareVersionModel()
                ..iD = e.iD
                ..userID = e.userID
                ..pageNumber = e.pageNumber
                ..pageSize = e.pageSize
                ..dateOfUploading = e.dateofuploading
                ..description = e.description
                ..downloadUrl = e.downloadurl
                ..firmwareType = e.firmwareType
                ..fkFirmwareTypeId = e.fkFirmwareTypeId
                ..totalRecords = e.totalRecords
                ..versionName = e.versionname
                ..versionNo = e.versionNo))
          : [];

    return model;
  }
}

class FirmwareVersionModel {
  int? iD;
  String? versionNo;
  String? versionName;
  String? dateOfUploading;
  String? description;
  String? downloadUrl;
  int? fkFirmwareTypeId;
  int? userID;
  int? pageNumber;
  int? pageSize;
  int? totalRecords;
  Null searchValue;
  String? firmwareType;
  String? taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  FirmwareVersionModel(
      {this.iD,
      this.versionNo,
      this.versionName,
      this.dateOfUploading,
      this.description,
      this.downloadUrl,
      this.fkFirmwareTypeId,
      this.userID,
      this.pageNumber,
      this.pageSize,
      this.totalRecords,
      this.searchValue,
      this.firmwareType});

  FirmwareVersionModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    versionNo = json['VersionNo'];
    versionName = json['Versionname'];
    dateOfUploading = json['Dateofuploading'];
    description = json['Description'];
    downloadUrl = json['Downloadurl'];
    fkFirmwareTypeId = json['fk_FirmwareTypeId'];
    userID = json['UserID'];
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    totalRecords = json['TotalRecords'];
    searchValue = json['SearchValue'];
    firmwareType = json['FirmwareType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['VersionNo'] = versionNo;
    data['Versionname'] = versionName;
    data['Dateofuploading'] = dateOfUploading;
    data['Description'] = description;
    data['Downloadurl'] = downloadUrl;
    data['fk_FirmwareTypeId'] = fkFirmwareTypeId;
    data['UserID'] = userID;
    data['PageNumber'] = pageNumber;
    data['PageSize'] = pageSize;
    data['TotalRecords'] = totalRecords;
    data['SearchValue'] = searchValue;
    data['FirmwareType'] = firmwareType;
    return data;
  }
}
