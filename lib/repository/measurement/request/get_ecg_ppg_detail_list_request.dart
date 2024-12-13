import 'package:json_annotation/json_annotation.dart';

part 'get_ecg_ppg_detail_list_request.g.dart';

@JsonSerializable()
class GetEcgPpgDetailListRequest extends Object {
  @JsonKey(name: 'ID')
  String? id;


  GetEcgPpgDetailListRequest({
    this.id,
  });

  factory GetEcgPpgDetailListRequest.fromJson(
      Map<String, dynamic> srcJson) =>
      _$GetEcgPpgDetailListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetEcgPpgDetailListRequestToJson(this);
}
