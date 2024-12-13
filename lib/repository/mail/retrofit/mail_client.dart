import 'package:dio/dio.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/repository/mail/model/empty_messages_from_trash_result.dart';
import 'package:health_gauge/repository/mail/model/mark_as_read_by_message_id_result.dart';
import 'package:health_gauge/repository/mail/model/mark_as_read_by_message_type_id_result.dart';
import 'package:health_gauge/repository/mail/model/multiple_message_delete_from_trash_result.dart';
import 'package:health_gauge/repository/mail/model/send_message_result.dart';
import 'package:health_gauge/repository/mail/model/send_response_by_message_id_and_type_id_result.dart';
import 'package:health_gauge/repository/mail/request/get_list_event_request.dart';
import 'package:health_gauge/repository/mail/request/multiple_trash_message_delete_event_request.dart';
import 'package:health_gauge/repository/mail/request/send_message_event_request.dart';
import 'package:health_gauge/repository/mail/request/send_response_message_event_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'mail_client.g.dart';

@RestApi()
abstract class MailClient {
  factory MailClient(Dio dio, {String baseUrl}) = _MailClient;

  @POST(ApiConstants.getMessageDetailByMessageId)
  Future<MessageDetailListModel> getMessageDetailByMessageId(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.messageID) int messageId,
      @Query(ApiConstants.loggedInEmailID) String loggedInEmailId);

  @POST(ApiConstants.sendResponseByMessageIDAndTypeID)
  Future<SendResponseByMessageIdAndTypeIdResult>
      sendResponseByMessageIDAndTypeID(
          @Header(ApiConstants.headerAuthorization)
              String authToken,
          @Body()
              SendResponseMessageEventRequest sendResponseMessageEventRequest);

  @POST(ApiConstants.emptyMessagesFromTrash)
  Future<EmptyMessagesFromTrashResult> emptyMessagesFromTrash(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userID) int userId,
  );

  @POST(ApiConstants.markAsReadByMessageTypeID)
  Future<MarkAsReadByMessageTypeIdResult> markAsReadByMessageTypeID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userID) int userId,
    @Query(ApiConstants.messageTypeId) int messageTypeId,
  );

  @POST(ApiConstants.markAsReadByMessageID)
  Future<MarkAsReadByMessageIdResult> markAsReadByMessageID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.messageId) String messageId,
  );

  @POST(ApiConstants.multipleMessageDeleteFromTrash)
  Future<MultipleMessageDeleteFromTrashResult> multipleMessageDeleteFromTrash(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body()
        MultipleTrashMessageDeleteEventRequest
            multipleTrashMessageDeleteEventRequest,
  );

  @POST(ApiConstants.multipleDeleteMessages)
  Future<MultipleMessageDeleteFromTrashResult> multipleDeleteMessages(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body()
        MultipleTrashMessageDeleteEventRequest
            multipleTrashMessageDeleteEventRequest,
  );

  @POST(ApiConstants.deleteMessageById)
  Future<MultipleMessageDeleteFromTrashResult> deleteMessageById(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.messageID) String messageId,
  );

  @POST(ApiConstants.restoreMessageByID)
  Future<MultipleMessageDeleteFromTrashResult> restoreMessageByID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.messageID) int messageId,
    @Query(ApiConstants.userID) int userId,
  );

  @POST(ApiConstants.sendMessage)
  Future<SendMessageResult> sendMessage(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() SendMessageEventRequest sendMessageEventRequest);

  @POST(ApiConstants.getMessageListByMessageTypeId)
  Future<MessageListModel> getMessageListByMessageTypeId(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetListEventRequest sendMessageEventRequest);
}
