import 'package:json_annotation/json_annotation.dart';

import '../../../utils/date_utils.dart';

part 'get_bp_data_response.g.dart';

@JsonSerializable()
class GetBPDataResponse extends Object {
  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  List<BpDataModel> data;

  GetBPDataResponse(
    this.result,
    this.response,
    this.data,
  );

  factory GetBPDataResponse.fromJson(Map<String, dynamic> srcJson)
  {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetBPDataResponseFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetBPDataResponseToJson(this);
}

@JsonSerializable()
class BpDataModel extends Object {
  @JsonKey(name: 'ID')
  int iD;

  @JsonKey(name: 'userId')
  int userId;

  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'sys')
  int sys;

  @JsonKey(name: 'dia')
  int dia;

  BpDataModel(
    this.iD,
    this.userId,
    this.date,
    this.sys,
    this.dia,
  );

  factory BpDataModel.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$BpDataModelFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$BpDataModelToJson(this);

  Map<String, dynamic> toMapToInsertInDb() {
    return {
      'userId': userId.toString(),
      'bloodSBP': sys,
      'bloodDBP': dia,
      'date': DateUtil.parse(int.parse(date)).toString(),
      'idForApi': iD
    };
  }
}
