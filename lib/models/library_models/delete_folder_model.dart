import 'package:health_gauge/repository/library/model/save_and_update_shared_with_result.dart';

class DeleteFolderModel {
  bool? result;
  int? iD;
  int? response;
  String? message;

  DeleteFolderModel({this.result, this.iD, this.response, this.message});

  DeleteFolderModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'];
    response = json['Response'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    data['ID'] = iD;
    data['Response'] = response;
    data['Message'] = message;
    return data;
  }

  static DeleteFolderModel mapper(SaveAndUpdateSharedWithResult obj) {
    var model = DeleteFolderModel();
    model
      ..result = obj.result
      ..response = obj.response
      ..iD = obj.iD
      ..message = obj.message;
    return model;
  }
}
