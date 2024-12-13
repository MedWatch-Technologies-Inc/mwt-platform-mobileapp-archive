import 'package:json_annotation/json_annotation.dart';

part 'get_hr_data_request.g.dart';


@JsonSerializable()
class GetHrDataRequest extends Object {

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
  List<dynamic>? ids;

  GetHrDataRequest({this.userId,this.pageIndex,this.pageSize,this.ids, this.fromDateStamp, this.toDateStamp});
  // GetHrDataRequest({this.userId,this.fromDateStamp,this.toDateStamp,this.pageIndex,this.pageSize,this.ids});

  factory GetHrDataRequest.fromJson(Map<String, dynamic> srcJson) => _$GetHrDataRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetHrDataRequestToJson(this);

}

  
