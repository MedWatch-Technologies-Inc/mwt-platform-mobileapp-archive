import 'package:json_annotation/json_annotation.dart';

part 'save_and_update_shared_with_result.g.dart';

@JsonSerializable()
class SaveAndUpdateSharedWithResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'ID')
  int? iD;

  SaveAndUpdateSharedWithResult({
    this.result,
    this.response,
    this.message,
    this.iD,
  });

  factory SaveAndUpdateSharedWithResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SaveAndUpdateSharedWithResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveAndUpdateSharedWithResultToJson(this);
}
