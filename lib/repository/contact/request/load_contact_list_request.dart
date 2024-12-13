import 'package:json_annotation/json_annotation.dart';

part 'load_contact_list_request.g.dart';

@JsonSerializable()
class LoadContactListRequest extends Object {

  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  // @JsonKey(name: 'FromDateStamp')
  // String? fromDateStamp;
  //
  // @JsonKey(name: 'ToDateStamp')
  // String? toDateStamp;

  LoadContactListRequest({this.userID,this.pageIndex,this.pageSize,this.iDs});

  factory LoadContactListRequest.fromJson(Map<String, dynamic> srcJson) => _$LoadContactListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoadContactListRequestToJson(this);

}


