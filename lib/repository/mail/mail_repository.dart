import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/repository/mail/model/empty_messages_from_trash_result.dart';
import 'package:health_gauge/repository/mail/model/mark_as_read_by_message_id_result.dart';
import 'package:health_gauge/repository/mail/model/mark_as_read_by_message_type_id_result.dart';
import 'package:health_gauge/repository/mail/model/multiple_message_delete_from_trash_result.dart';
import 'package:health_gauge/repository/mail/model/send_message_result.dart';
import 'package:health_gauge/repository/mail/model/send_response_by_message_id_and_type_id_result.dart';
import 'package:health_gauge/repository/mail/request/get_list_event_request.dart';
import 'package:health_gauge/repository/mail/request/get_message_detail_event_request.dart';
import 'package:health_gauge/repository/mail/request/mark_as_read_all_list_event_request.dart';
import 'package:health_gauge/repository/mail/request/message_restore_event_request.dart';
import 'package:health_gauge/repository/mail/request/multiple_trash_message_delete_event_request.dart';
import 'package:health_gauge/repository/mail/request/send_message_event_request.dart';
import 'package:health_gauge/repository/mail/request/send_response_message_event_request.dart';
import 'package:health_gauge/repository/mail/retrofit/mail_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class MailRepository {
  late MailClient _mailClient;

  MailRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _mailClient = MailClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<MessageDetailListModel>>
      getMessageDetailByMessageId(GetMessageDetailEventRequest request) async {
    var response = ApiResponseWrapper<MessageDetailListModel>();
    try {
      return response
        ..setData(await _mailClient.getMessageDetailByMessageId(
          '${Constants.authToken}',
          request.messageID!,
          request.loggedInEmailID!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SendResponseByMessageIdAndTypeIdResult>>
      sendResponseByMessageIDAndTypeID(
          SendResponseMessageEventRequest request) async {
    var response = ApiResponseWrapper<SendResponseByMessageIdAndTypeIdResult>();
    try {
      return response
        ..setData(await _mailClient.sendResponseByMessageIDAndTypeID(
          '${Constants.authToken}',
          request,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<EmptyMessagesFromTrashResult>>
      emptyMessagesFromTrash(int userId) async {
    var response = ApiResponseWrapper<EmptyMessagesFromTrashResult>();
    try {
      return response
        ..setData(await _mailClient.emptyMessagesFromTrash(
          '${Constants.authToken}',
          userId,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MarkAsReadByMessageTypeIdResult>>
      markAsReadByMessageTypeID(MarkAsReadAllListEventRequest request) async {
    var response = ApiResponseWrapper<MarkAsReadByMessageTypeIdResult>();
    try {
      return response
        ..setData(await _mailClient.markAsReadByMessageTypeID(
          '${Constants.authToken}',
          request.userID!,
          request.messageTypeId!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MarkAsReadByMessageIdResult>> markAsReadByMessageID(
      String messageId) async {
    var response = ApiResponseWrapper<MarkAsReadByMessageIdResult>();
    try {
      return response
        ..setData(await _mailClient.markAsReadByMessageID(
          '${Constants.authToken}',
          messageId,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>>
      multipleMessageDeleteFromTrash(
          MultipleTrashMessageDeleteEventRequest messageId) async {
    var response = ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>();
    try {
      return response
        ..setData(await _mailClient.multipleMessageDeleteFromTrash(
          '${Constants.authToken}',
          messageId,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>>
      multipleDeleteMessages(
          MultipleTrashMessageDeleteEventRequest messageId) async {
    var response = ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>();
    try {
      return response
        ..setData(await _mailClient.multipleDeleteMessages(
          '${Constants.authToken}',
          messageId,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>>
      deleteMessageById(String messageId) async {
    var response = ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>();
    try {
      return response
        ..setData(await _mailClient.deleteMessageById(
          '${Constants.authToken}',
          messageId,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>>
      restoreMessageByID(MessageRestoreEventRequest request) async {
    var response = ApiResponseWrapper<MultipleMessageDeleteFromTrashResult>();
    try {
      return response
        ..setData(await _mailClient.restoreMessageByID(
          '${Constants.authToken}',
          request.messageID!,
          request.userId!,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SendMessageResult>> sendMessage(
      SendMessageEventRequest request) async {
    var response = ApiResponseWrapper<SendMessageResult>();
    try {
      return response
        ..setData(await _mailClient.sendMessage(
          '${Constants.authToken}',
          request,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MessageListModel>> getMessageListByMessageTypeId(
      GetListEventRequest request) async {
    var response = ApiResponseWrapper<MessageListModel>();
    try {
      log('getEmailRequest ${request.toJson()}');
      return response
        ..setData(await _mailClient.getMessageListByMessageTypeId(
          '${Constants.authToken}',
          request,
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}
