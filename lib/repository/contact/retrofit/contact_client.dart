import 'package:dio/dio.dart';
import 'package:health_gauge/repository/contact/model/accept_or_reject_invitation_result.dart';
import 'package:health_gauge/repository/contact/model/delete_contact_by_user_id_result.dart';
import 'package:health_gauge/repository/contact/model/get_contact_list_result.dart';
import 'package:health_gauge/repository/contact/model/get_pending_invitation_list_result.dart';
import 'package:health_gauge/repository/contact/model/get_sending_invitation_list_result.dart';
import 'package:health_gauge/repository/contact/model/search_leads_result.dart';
import 'package:health_gauge/repository/contact/model/send_invitation_result.dart';
import 'package:health_gauge/repository/contact/request/get_invitation_list_event_request.dart';
import 'package:health_gauge/repository/contact/request/get_invitation_request.dart';
import 'package:health_gauge/repository/contact/request/load_contact_list_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'contact_client.g.dart';

@RestApi()
abstract class ContactClient {
  factory ContactClient(Dio dio, {String baseUrl}) = _ContactClient;

  @POST(ApiConstants.getContactList)
  Future<GetContactListResult> getContactList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() LoadContactListRequest loadContactListRequest);

  @POST(ApiConstants.deleteContactByUserId)
  Future<DeleteContactByUserIdResult> deleteContactByUserId(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.contactFromUserID) String contactFromUserId,
      @Query(ApiConstants.contactToUserId) String contactToUserId);

  @POST(ApiConstants.getSendingInvitationList)
  Future<GetSendingInvitationListResult> getSendingInvitationList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetInvitationListEventRequest getInvitationListEventRequest);

  @POST(ApiConstants.getPendingInvitationList)
  Future<GetPendingInvitationListResult> getPendingInvitationList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetInvitationRequest getInvitationRequest);

  @POST(ApiConstants.acceptOrRejectInvitation)
  Future<AcceptOrRejectInvitationResult> acceptOrRejectInvitation(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.contactID) String contactId,
      @Query(ApiConstants.isAccepted) String isAccepted);

  @POST(ApiConstants.searchLeads)
  Future<SearchLeadsResult> searchLeads(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.loggedInUserID) String loggedInUserId,
      @Query(ApiConstants.searchText) String searchText);

  @POST(ApiConstants.sendInvitation)
  Future<SendInvitationResult> sendInvitation(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.loggedInUserID) String loggedInUserId,
      @Query(ApiConstants.inviteeUserID) String inviteeUserId);
}
