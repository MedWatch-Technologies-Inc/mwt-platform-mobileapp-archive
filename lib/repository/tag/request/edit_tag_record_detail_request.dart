import 'package:json_annotation/json_annotation.dart';

part 'edit_tag_record_detail_request.g.dart';

@JsonSerializable()
class EditTagRecordDetailRequest extends Object {
  @JsonKey(name: 'id')
  String? id;

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

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  @JsonKey(name: 'AttachFile')
  List<String>? attachFile;

  EditTagRecordDetailRequest({
    this.id,
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

  factory EditTagRecordDetailRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$EditTagRecordDetailRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EditTagRecordDetailRequestToJson(this);
}
