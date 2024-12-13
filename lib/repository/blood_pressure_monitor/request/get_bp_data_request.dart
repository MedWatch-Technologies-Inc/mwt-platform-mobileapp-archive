import 'package:json_annotation/json_annotation.dart'; 
  
part 'get_bp_data_request.g.dart';


@JsonSerializable()
  class GetBPDataRequest extends Object {

  @JsonKey(name: 'userId')
  int? userId;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  GetBPDataRequest({this.userId,this.fromDateStamp,this.toDateStamp,this.pageIndex,this.pageSize,this.iDs,});

  factory GetBPDataRequest.fromJson(Map<String, dynamic> srcJson) => _$GetBPDataRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetBPDataRequestToJson(this);

}

  
