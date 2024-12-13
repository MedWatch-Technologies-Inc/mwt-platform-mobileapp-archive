import 'package:dio/dio.dart';
import 'package:health_gauge/repository/chat/model/access_chatted_with_result.dart';
import 'package:health_gauge/repository/chat/model/access_create_chat_group_result.dart';
import 'package:health_gauge/repository/chat/model/access_group_participant_result.dart';
import 'package:health_gauge/repository/chat/model/access_history_with_two_user_result.dart';
import 'package:health_gauge/repository/chat/model/access_send_group_result.dart';
import 'package:health_gauge/repository/chat/model/group_list_result.dart';
import 'package:health_gauge/repository/chat/model/group_remove_result.dart';
import 'package:health_gauge/repository/chat/model/remove_group_participant_result.dart';
import 'package:health_gauge/repository/chat/request/access_chat_history_two_users_request.dart';
import 'package:health_gauge/repository/chat/request/access_chatted_with_request.dart';
import 'package:health_gauge/repository/chat/request/add_group_participant_event_request.dart';
import 'package:health_gauge/repository/chat/request/chat_group_history_event_request.dart';
import 'package:health_gauge/repository/chat/request/create_group_event_request.dart';
import 'package:health_gauge/repository/chat/request/fetch_group_participant_event_request.dart';
import 'package:health_gauge/repository/chat/request/group_listing_event_request.dart';
import 'package:health_gauge/repository/chat/request/group_remove_event_request.dart';
import 'package:health_gauge/repository/chat/request/remove_group_participant_event_request.dart';
import 'package:health_gauge/repository/chat/request/send_group_message_event_request.dart';
import 'package:health_gauge/repository/chat/retrofit/chat_client.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

import 'model/access_chat_history_group_result.dart';
import 'model/add_group_participant_result.dart';

class ChatRepository {
  late ChatClient _chatClient;
  String? baseUrl;

  ChatRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _chatClient = ChatClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<AccessChattedWithModel>> getAccessChattedWith(
      AccessChattedWithRequest request) async {
    var response = ApiResponseWrapper<AccessChattedWithModel>();
    try {
      var result = await _chatClient.getAccessChattedWith(
          '${Constants.authToken}', request.fromUserId!);
      return response..setData(AccessChattedWithModel.map(result));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AccessHistoryWithTwoUserResult>>
      getAccessChatHistoryTwoUsers(
          AccessChatHistoryTwoUsersRequest request) async {
    var response = ApiResponseWrapper<AccessHistoryWithTwoUserResult>();
    try {
      return response
        ..setData(await _chatClient.getAccessChatHistoryTwoUsers(
            '${Constants.authToken}', request.fromUserId!, request.toUserId!));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AccessCreateChatGroupResult>> accessCreateChatGroup(
      CreateGroupEventRequest request) async {
    var response = ApiResponseWrapper<AccessCreateChatGroupResult>();
    try {
      return response
        ..setData(await _chatClient.accessCreateChatGroup(
            '${Constants.authToken}', request.groupName!, request.memberIds!));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AccessChatHistoryGroupResult>>
      accessGroupChatHistory(ChatGroupHistoryEventRequest request) async {
    var response = ApiResponseWrapper<AccessChatHistoryGroupResult>();
    try {
      return response
        ..setData(await _chatClient.accessGroupChatHistory(
          '${Constants.authToken}',
          request.groupName!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AccessGroupParticipantResult>>
      accessGroupParticipants(FetchGroupParticipantEventRequest request) async {
    var response = ApiResponseWrapper<AccessGroupParticipantResult>();
    try {
      return response
        ..setData(await _chatClient.accessGroupParticipants(
          '${Constants.authToken}',
          request.groupName!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AccessSendGroupResult>> accessSendGroup(
      SendGroupMessageEventRequest request) async {
    var response = ApiResponseWrapper<AccessSendGroupResult>();
    try {
      return response
        ..setData(await _chatClient.accessSendGroup(
          '${Constants.authToken}',
          request,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GroupListResult>> accessGetMyGroupList(
      GroupListingEventRequest request) async {
    var response = ApiResponseWrapper<GroupListResult>();
    try {
      return response
        ..setData(await _chatClient.accessGetMyGroupList(
          '${Constants.authToken}',
          request.userID!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GroupRemoveResult>> accessDeleteChatGroup(
      GroupRemoveEventRequest request) async {
    var response = ApiResponseWrapper<GroupRemoveResult>();
    try {
      return response
        ..setData(await _chatClient.accessDeleteChatGroup(
          '${Constants.authToken}',
          request.groupName!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AddGroupParticipantResult>> accessAddParticipant(
      AddGroupParticipantEventRequest request) async {
    var response = ApiResponseWrapper<AddGroupParticipantResult>();
    try {
      return response
        ..setData(await _chatClient.accessAddParticipant(
            '${Constants.authToken}', request.groupName!, request.membersIDs!));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<RemoveGroupParticipantResult>>
      accessRemoveParticipant(
          RemoveGroupParticipantEventRequest request) async {
    var response = ApiResponseWrapper<RemoveGroupParticipantResult>();
    try {
      return response
        ..setData(await _chatClient.accessRemoveParticipant(
            '${Constants.authToken}', request.groupName!, request.membersIDs!));
    } on DioError catch (error, stacktrace) {
      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}
