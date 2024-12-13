import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_third_party_data_type_request.g.dart';

@JsonSerializable()
class SaveThirdPartyDataTypeRequest extends Object {
  @JsonKey(name: 'user_id')
  String? userId;

  @JsonKey(name: 'typeName')
  String? typeName;

  @JsonKey(name: 'value')
  String? value;

  @JsonKey(name: 'startTime')
  String? startTime;

  @JsonKey(name: 'endTime')
  String? endTime;

  @JsonKey(name: 'valueId')
  String? valueId;

  @JsonKey(name: 'isGoogleFitData')
  int? isGoogleFitData;

  SaveThirdPartyDataTypeRequest({
    this.userId,
    this.typeName,
    this.value,
    this.startTime,
    this.endTime,
    this.valueId,
    this.isGoogleFitData,
  });

  factory SaveThirdPartyDataTypeRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SaveThirdPartyDataTypeRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveThirdPartyDataTypeRequestToJson(this);

  factory SaveThirdPartyDataTypeRequest.fromHealthKitOrGoogleFitModel(
      String userId, bool isGoogleFitData, HealthKitOrGoogleFitModel model) {
    return SaveThirdPartyDataTypeRequest(
      userId: userId,
      typeName: model.typeName,
      value: model.value.toString(),
      startTime: model.startTime!.toUtc().millisecondsSinceEpoch.toString(),
      endTime: model.endTime!.toUtc().millisecondsSinceEpoch.toString(),
      valueId: model.valueId,
      isGoogleFitData: isGoogleFitData ? 1 : 0,
    );
  }
}
