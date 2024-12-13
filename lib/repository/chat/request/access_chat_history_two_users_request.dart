import 'package:json_annotation/json_annotation.dart';

part 'access_chat_history_two_users_request.g.dart';

@JsonSerializable()
class AccessChatHistoryTwoUsersRequest extends Object {
  @JsonKey(name: 'fromuserId')
  String? fromUserId;

  @JsonKey(name: 'touserId')
  String? toUserId;

  AccessChatHistoryTwoUsersRequest({
    this.fromUserId,
    this.toUserId,
  });

  factory AccessChatHistoryTwoUsersRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$AccessChatHistoryTwoUsersRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$AccessChatHistoryTwoUsersRequestToJson(this);
}
