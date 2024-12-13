import 'package:json_annotation/json_annotation.dart';

part 'get_user_vital_status_request.g.dart';


@JsonSerializable()
class GetUserVitalStatusRequest extends Object {

  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  GetUserVitalStatusRequest({this.userID,this.pageIndex,this.pageSize,this.iDs,this.fromDateStamp,this.toDateStamp,});

  factory GetUserVitalStatusRequest.fromJson(Map<String, dynamic> srcJson) => _$GetUserVitalStatusRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetUserVitalStatusRequestToJson(this);

}
