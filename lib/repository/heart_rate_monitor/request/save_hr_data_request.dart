import 'package:json_annotation/json_annotation.dart'; 
  
part 'save_hr_data_request.g.dart';


@JsonSerializable()
  class SaveHrDataRequest extends Object {

  @JsonKey(name: 'userId')
  int userId = 0;

  @JsonKey(name: 'hrData')
  List<HrData> hrData = [];

  SaveHrDataRequest(this.userId, this.hrData,);

  factory SaveHrDataRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$SaveHrDataRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveHrDataRequestToJson(this);

  List<Map<String, dynamic>> toMapToInsertInDb() {
    return hrData.map((e) => {
      'userId': userId,
      'approxHr': e.hr,
      'date': e.date,
      'ZoneID': e.ZoneID,
    }).toList();
  }

   SaveHrDataRequest.toObjectFromJson(List<Map<String, dynamic>> mapList)  {
     userId = int.parse(mapList.first['userId']);
     hrData.addAll(mapList.map((e) => HrData(e['approxHr'], e['date'], e['ZoneID'])).toList());
  }

}

  
@JsonSerializable()
  class HrData extends Object {

  @JsonKey(name: 'hr')
  int hr;

  @JsonKey(name: 'date')
  String date;

   @JsonKey(name: 'ZoneID')
  int ZoneID;

  HrData(this.hr,this.date,this.ZoneID);

  factory HrData.fromJson(Map<String, dynamic> srcJson) => _$HrDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HrDataToJson(this);



}

  
