import 'package:dio/dio.dart';
import 'package:health_gauge/repository/contact/model/accept_or_reject_invitation_result.dart';
import 'package:health_gauge/repository/contact/model/delete_contact_by_user_id_result.dart';
import 'package:health_gauge/repository/contact/model/get_contact_list_result.dart';
import 'package:health_gauge/repository/contact/model/get_pending_invitation_list_result.dart';
import 'package:health_gauge/repository/contact/model/get_sending_invitation_list_result.dart';
import 'package:health_gauge/repository/contact/model/search_leads_result.dart';
import 'package:health_gauge/repository/contact/model/send_invitation_result.dart';
import 'package:health_gauge/repository/contact/request/accept_reject_invitation_request.dart';
import 'package:health_gauge/repository/contact/request/delete_contact_request.dart';
import 'package:health_gauge/repository/contact/request/get_invitation_list_event_request.dart';
import 'package:health_gauge/repository/contact/request/get_invitation_request.dart';
import 'package:health_gauge/repository/contact/request/load_contact_list_request.dart';
import 'package:health_gauge/repository/contact/request/search_contact_list_event_request.dart';
import 'package:health_gauge/repository/contact/request/send_invitation_event_request.dart';
import 'package:health_gauge/repository/contact/retrofit/contact_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class ContactRepository {
  late ContactClient _contactClient;

  ContactRepository() {
    var dio = ServiceManager.get().getDioClient();
    _contactClient = ContactClient(dio, baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetContactListResult>> getContactList(
      LoadContactListRequest request) async {
    var response = ApiResponseWrapper<GetContactListResult>();
    try {
      return response
        ..setData(await _contactClient.getContactList(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GetSendingInvitationListResult>>
      getSendingInvitationList(GetInvitationListEventRequest request) async {
    var response = ApiResponseWrapper<GetSendingInvitationListResult>();
    try {
      return response
        ..setData(await _contactClient.getSendingInvitationList(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<DeleteContactByUserIdResult>> deleteContactByUserId(
      DeleteContactRequest request) async {
    var response = ApiResponseWrapper<DeleteContactByUserIdResult>();
    try {
      return response
        ..setData(await _contactClient.deleteContactByUserId(
            '${Constants.authToken}',
            request.contactFromUserID!,
            request.contactToUserId!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GetPendingInvitationListResult>>
      getPendingInvitationList(GetInvitationRequest request) async {
    var response = ApiResponseWrapper<GetPendingInvitationListResult>();
    try {
      return response
        ..setData(await _contactClient.getPendingInvitationList(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<AcceptOrRejectInvitationResult>>
      acceptOrRejectInvitation(AcceptRejectInvitationRequest request) async {
    var response = ApiResponseWrapper<AcceptOrRejectInvitationResult>();
    try {
      return response
        ..setData(await _contactClient.acceptOrRejectInvitation(
            '${Constants.authToken}', request.contactID!, request.isAccepted!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SearchLeadsResult>> searchLeads(
      SearchContactListEventRequest request) async {
    var response = ApiResponseWrapper<SearchLeadsResult>();
    try {
      return response
        ..setData(await _contactClient.searchLeads('${Constants.authToken}',
            request.loggedInUserID!, request.searchText!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SendInvitationResult>> sendInvitation(
      SendInvitationEventRequest request) async {
    var response = ApiResponseWrapper<SendInvitationResult>();
    try {
      return response
        ..setData(await _contactClient.sendInvitation('${Constants.authToken}',
            request.loggedInUserID!, request.inviteeUserID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}
