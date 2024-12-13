import 'package:json_annotation/json_annotation.dart'; 
  
part 'save_hr_data_response.g.dart';


@JsonSerializable()
  class SaveHrDataResponse extends Object {

  @JsonKey(name: 'Result')
  bool result;


  @JsonKey(name: 'ID')
  List iD;

  @JsonKey(name: 'Message')
  String message;

  SaveHrDataResponse(this.result,this.iD,this.message,);

  factory SaveHrDataResponse.fromJson(Map<String, dynamic> srcJson) => _$SaveHrDataResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveHrDataResponseToJson(this);

}

  
