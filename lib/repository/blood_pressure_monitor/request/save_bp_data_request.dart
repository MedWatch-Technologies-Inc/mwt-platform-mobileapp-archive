import 'package:json_annotation/json_annotation.dart'; 
  
part 'save_bp_data_request.g.dart';


@JsonSerializable()
  class SaveBPDataRequest extends Object {

  @JsonKey(name: 'userId')
  int userId = 0;

  @JsonKey(name: 'bpData')
  List<BpData> bpData = [];

  SaveBPDataRequest(this.userId,this.bpData,);

  factory SaveBPDataRequest.fromJson(Map<String, dynamic> srcJson) => _$SaveBPDataRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveBPDataRequestToJson(this);

  List<Map<String, dynamic>> toMapToInsertInDb() {
    return bpData.map((e) => {
      'userId': userId,
      'bloodSBP': e.sys,
      'bloodDBP': e.dia,
      'date': e.date,
    }).toList();
  }

  SaveBPDataRequest.toObjectFromJson(List<Map<String, dynamic>> mapList)  {
    userId = int.parse(mapList.first['userId']);
    bpData.addAll(mapList.map((e) => BpData(e['date'],e['bloodSBP'].toInt(),e['bloodDBP'].toInt())).toList());
  }

}

  
@JsonSerializable()
  class BpData extends Object {

  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'sys')
  int sys;

  @JsonKey(name: 'dia')
  int dia;

  BpData(this.date,this.sys,this.dia,);

  factory BpData.fromJson(Map<String, dynamic> srcJson) => _$BpDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BpDataToJson(this);

}

  
