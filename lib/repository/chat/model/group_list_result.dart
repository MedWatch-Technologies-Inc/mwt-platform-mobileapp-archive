import 'package:json_annotation/json_annotation.dart';

part 'group_list_result.g.dart';

@JsonSerializable()
class GroupListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<GroupListData>? data;

  GroupListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GroupListResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GroupListResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GroupListResultToJson(this);
}

@JsonSerializable()
class GroupListData extends Object {
  @JsonKey(name: 'Id')
  int? id;

  @JsonKey(name: 'GroupName')
  String? groupName;

  @JsonKey(name: 'GroupParticipants')
  String? groupParticipants;

  @JsonKey(name: 'MaskedGroupName')
  String? maskedGroupName;

  @JsonKey(name: 'GroupFirstLetter')
  String? groupFirstLetter;

  @JsonKey(name: 'LastSentMessageGroup')
  String? lastSentMessageGroup;

  @JsonKey(name: 'LastSentDateGroup')
  String? lastSentDateGroup;

  @JsonKey(name: 'LastMessageandDateGroup')
  String? lastMessageAndDateGroup;

  GroupListData(
      {this.id,
      this.groupName,
      this.groupParticipants,
      this.maskedGroupName,
      this.groupFirstLetter,
      this.lastMessageAndDateGroup,
      this.lastSentDateGroup,
      this.lastSentMessageGroup});

  factory GroupListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GroupListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GroupListDataToJson(this);
}
