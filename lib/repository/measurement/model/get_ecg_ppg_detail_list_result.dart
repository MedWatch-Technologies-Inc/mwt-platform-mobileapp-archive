import 'package:json_annotation/json_annotation.dart';

part 'get_ecg_ppg_detail_list_result.g.dart';


@JsonSerializable()
class GetEcgPpgDetailListResult extends Object {

  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  EcgPpgHistoryModel ecgPpgHistoryModel;

  GetEcgPpgDetailListResult(this.result,this.response,this.ecgPpgHistoryModel,);

  factory GetEcgPpgDetailListResult.fromJson(Map<String, dynamic> srcJson) => _$GetEcgPpgDetailListResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetEcgPpgDetailListResultToJson(this);

}


@JsonSerializable()
class EcgPpgHistoryModel extends Object {

  @JsonKey(name: 'ID')
  int iD;

  @JsonKey(name: 'UserID')
  int userID;

  @JsonKey(name: 'FileName')
  String fileName;

  @JsonKey(name: 'DataStoreServer')
  String dataStoreServer;

  @JsonKey(name: 'filteredEcgPoints')
  List<String> filteredEcgPoints;

  @JsonKey(name: 'filteredPpgPoints')
  List<String> filteredPpgPoints;

  @JsonKey(name: 'ecg_elapsed_time')
  List<String> ecgElapsedTime;

  @JsonKey(name: 'ppg_elapsed_time')
  List<String> ppgElapsedTime;

  EcgPpgHistoryModel(this.iD,this.userID,this.fileName,this.dataStoreServer,this.filteredEcgPoints,this.filteredPpgPoints,this.ecgElapsedTime,this.ppgElapsedTime,);

  factory EcgPpgHistoryModel.fromJson(Map<String, dynamic> srcJson) => _$EcgPpgHistoryModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EcgPpgHistoryModelToJson(this);

}


