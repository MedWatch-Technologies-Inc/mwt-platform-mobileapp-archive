class LibraryList {
  int? libraryID;
  String? virtualFilePath;
  String? physicalFilePath;
  String? createdDateTime;
  int? parentID;
  String? fileSize;
  bool? isFolder;
  String? createdDateTimeStamp;

  LibraryList(
      {this.libraryID,
      this.virtualFilePath,
      this.physicalFilePath,
      this.createdDateTime,
      this.parentID,
      this.fileSize,
      this.isFolder});

  LibraryList.fromJson(Map<String, dynamic> json) {
    libraryID = json['LibraryID'];
    virtualFilePath = json['VirtualFilePath'];
    physicalFilePath = json['PhysicalFilePath'];
    createdDateTime = json['CreatedDateTime'];
    parentID = json['ParentID'];
    fileSize = json['FileSize'];
    isFolder = json['IsFolder'];
    createdDateTimeStamp = json['CreatedDateTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final data = new Map<String, dynamic>();
    data['LibraryID'] = libraryID;
    data['VirtualFilePath'] = virtualFilePath;
    data['PhysicalFilePath'] = physicalFilePath;
    data['CreatedDateTime'] = createdDateTime;
    data['ParentID'] = parentID;
    data['FileSize'] = fileSize;
    data['IsFolder'] = isFolder;
    data['CreatedDateTimeStamp'] = createdDateTimeStamp;
    return data;
  }
}