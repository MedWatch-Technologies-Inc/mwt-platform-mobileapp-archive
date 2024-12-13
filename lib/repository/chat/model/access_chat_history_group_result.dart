import 'package:json_annotation/json_annotation.dart';

part 'access_chat_history_group_result.g.dart';

@JsonSerializable()
class AccessChatHistoryGroupResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<AccessChatHistoryData>? data;

  AccessChatHistoryGroupResult({
    this.result,
    this.response,
    this.data,
  });

  factory AccessChatHistoryGroupResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$AccessChatHistoryGroupResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$AccessChatHistoryGroupResultToJson(this);
}

@JsonSerializable()
class AccessChatHistoryData extends Object {
  @JsonKey(name: 'MessageId')
  int? messageId;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'DateSent')
  String? dateSent;

  @JsonKey(name: 'FromUsername')
  String? fromUsername;

  @JsonKey(name: 'DateSentString')
  String? dateSentString;

  @JsonKey(name: 'ToUsername')
  String? toUsername;

  AccessChatHistoryData(
      {this.messageId,
      this.message,
      this.dateSent,
      this.fromUsername,
      this.dateSentString,
      this.toUsername});

  factory AccessChatHistoryData.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessChatHistoryDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessChatHistoryDataToJson(this);
}
