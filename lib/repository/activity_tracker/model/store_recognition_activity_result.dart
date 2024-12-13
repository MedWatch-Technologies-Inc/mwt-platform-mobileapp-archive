import 'package:json_annotation/json_annotation.dart';

part 'store_recognition_activity_result.g.dart';

@JsonSerializable()
class StoreRecognitionActivityResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  int? message;

  StoreRecognitionActivityResult({
    this.result,
    this.response,
    this.message,
  });

  factory StoreRecognitionActivityResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$StoreRecognitionActivityResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreRecognitionActivityResultToJson(this);
}
