import 'package:json_annotation/json_annotation.dart';

part 'save_third_party_data_type_result.g.dart';

@JsonSerializable()
class SaveThirdPartyDataTypeResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  SaveThirdPartyDataTypeResult({
    this.result,
    this.response,
    this.message,
  });

  factory SaveThirdPartyDataTypeResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SaveThirdPartyDataTypeResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveThirdPartyDataTypeResultToJson(this);
}
