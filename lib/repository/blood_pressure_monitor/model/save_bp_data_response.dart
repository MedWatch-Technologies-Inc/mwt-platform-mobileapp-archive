import 'package:json_annotation/json_annotation.dart'; 
  
part 'save_bp_data_response.g.dart';


@JsonSerializable()
  class SaveBPDataResponse extends Object {

  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'ID')
  List<int> iD;

  @JsonKey(name: 'Message')
  String message;

  SaveBPDataResponse(this.result,this.iD,this.message,);

  factory SaveBPDataResponse.fromJson(Map<String, dynamic> srcJson) => _$SaveBPDataResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveBPDataResponseToJson(this);

}

  
