import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagResponse/tag_record_model.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';

class TagResponse {
  bool result;
  int response;
  List<TagRecordModel> data;

  TagResponse({
    required this.result,
    required this.response,
    required this.data,
  });

  factory TagResponse.fromJson(Map<String, dynamic> json) {
    return TagResponse(
      result: JsonSerializableUtils.instance.checkBool(json['Result']),
      response: JsonSerializableUtils.instance.checkInt(json['Response']),
      data: json['Data'] is String
          ? []
          : (json['Data'] as List<dynamic>)
          .map((e) => TagRecordModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}