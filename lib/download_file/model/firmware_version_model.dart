import 'package:flutter_downloader/flutter_downloader.dart';

class FirmwareVersionModel {
  bool? result;
  Data? data;

  FirmwareVersionModel({this.result, this.data});

  FirmwareVersionModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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
  int? progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['VersionNo'] = this.versionNo;
    data['Versionname'] = this.versionName;
    data['Dateofuploading'] = this.dateOfUploading;
    data['Description'] = this.description;
    data['Downloadurl'] = this.downloadUrl;
    data['fk_FirmwareTypeId'] = this.fkFirmwareTypeId;
    data['UserID'] = this.userID;
    data['PageNumber'] = this.pageNumber;
    data['PageSize'] = this.pageSize;
    data['TotalRecords'] = this.totalRecords;
    data['SearchValue'] = this.searchValue;
    data['FirmwareType'] = this.firmwareType;
    return data;
  }
}
