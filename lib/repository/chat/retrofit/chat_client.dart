import 'package:dio/dio.dart';
import 'package:health_gauge/repository/chat/model/access_chat_history_group_result.dart';
import 'package:health_gauge/repository/chat/model/access_chatted_with_result.dart';
import 'package:health_gauge/repository/chat/model/access_create_chat_group_result.dart';
import 'package:health_gauge/repository/chat/model/access_group_participant_result.dart';
import 'package:health_gauge/repository/chat/model/access_history_with_two_user_result.dart';
import 'package:health_gauge/repository/chat/model/access_send_group_result.dart';
import 'package:health_gauge/repository/chat/model/add_group_participant_result.dart';
import 'package:health_gauge/repository/chat/model/group_list_result.dart';
import 'package:health_gauge/repository/chat/model/group_remove_result.dart';
import 'package:health_gauge/repository/chat/model/remove_group_participant_result.dart';
import 'package:health_gauge/repository/chat/request/send_group_message_event_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_client.g.dart';

@RestApi()
abstract class ChatClient {
  factory ChatClient(Dio dio, {String baseUrl}) = _ChatClient;

  @POST(ApiConstants.accessChattedWith)
  Future<AccessChattedWithResult> getAccessChattedWith(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.fromUserId) String accessChattedWithRequest);

  @POST(ApiConstants.accessChatHistoryTwoUsers)
  Future<AccessHistoryWithTwoUserResult> getAccessChatHistoryTwoUsers(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.fromUserId) String fromUserId,
      @Query(ApiConstants.toUserId) String toUserId);

  @POST(ApiConstants.accessCreateChatGroup)
  Future<AccessCreateChatGroupResult> accessCreateChatGroup(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.groupName) String groupName,
      @Query(ApiConstants.memberIds) String memberIds);

  @POST(ApiConstants.accessChatHistoryGroup)
  Future<AccessChatHistoryGroupResult> accessGroupChatHistory(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.groupName) String groupName);

  @POST(ApiConstants.accessGroupParticipants)
  Future<AccessGroupParticipantResult> accessGroupParticipants(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.groupName) String groupName);

  @POST(ApiConstants.accessSendGroup)
  Future<AccessSendGroupResult> accessSendGroup(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() SendGroupMessageEventRequest sendGroupMessageEventRequest);

  @POST(ApiConstants.accessGetMyGroupList)
  Future<GroupListResult> accessGetMyGroupList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId);

  @POST(ApiConstants.accessDeleteChatGroup)
  Future<GroupRemoveResult> accessDeleteChatGroup(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.groupName) String groupName);

  @POST(ApiConstants.accessAddParticipant)
  Future<AddGroupParticipantResult> accessAddParticipant(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.groupName,encoded: true) String groupName,
    @Query(ApiConstants.membersIDs,encoded: true) String memberIds,
  );

  @POST(ApiConstants.accessRemoveParticipant)
  Future<RemoveGroupParticipantResult> accessRemoveParticipant(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.groupName,encoded: true) String groupName,
    @Query(ApiConstants.membersIDs,encoded: true) String memberIds,
  );
}
