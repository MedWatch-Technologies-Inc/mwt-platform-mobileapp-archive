import 'package:json_annotation/json_annotation.dart';

part 'store_tag_record_detail_request.g.dart';

@JsonSerializable()
class StoreTagRecordDetailRequest extends Object {
  @JsonKey(name: 'date')
  String? date;

  @JsonKey(name: 'note')
  String? note;

  @JsonKey(name: 'time')
  String? time;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'Location')
  String? location;

  @JsonKey(name: 'value')
  double? value;

  @JsonKey(name: 'UnitSelectedType')
  String? unitSelectedType;

  @JsonKey(name: 'AttachFile')
  List<String>? attachFile;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  StoreTagRecordDetailRequest({
    this.date,
    this.note,
    this.time,
    this.type,
    this.userId,
    this.location,
    this.value,
    this.unitSelectedType,
    this.attachFile,
    this.createdDateTimeStamp,
  });

  factory StoreTagRecordDetailRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreTagRecordDetailRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreTagRecordDetailRequestToJson(this);
}
