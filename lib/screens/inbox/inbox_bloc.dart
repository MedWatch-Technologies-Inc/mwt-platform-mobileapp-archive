import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/RepositoryDB/email_data.dart';
import 'package:health_gauge/models/inbox_models/delete_message_model.dart';
import 'package:health_gauge/models/inbox_models/mark_as_read_all_messages_model.dart';
import 'package:health_gauge/models/inbox_models/mark_read_model.dart';
import 'package:health_gauge/models/inbox_models/multiple_delete_message_model.dart';
import 'package:health_gauge/models/inbox_models/restore_message_model.dart';
import 'package:health_gauge/models/inbox_models/send_message_model.dart';
import 'package:health_gauge/models/inbox_models/send_response_message_model.dart';
import 'package:health_gauge/models/inbox_models/trash_all_messages_model.dart';
import 'package:health_gauge/repository/mail/mail_repository.dart';
import 'package:health_gauge/repository/mail/request/get_list_event_request.dart';
import 'package:health_gauge/repository/mail/request/get_message_detail_event_request.dart';
import 'package:health_gauge/repository/mail/request/mark_as_read_all_list_event_request.dart';
import 'package:health_gauge/repository/mail/request/message_restore_event_request.dart';
import 'package:health_gauge/repository/mail/request/multiple_trash_message_delete_event_request.dart';
import 'package:health_gauge/repository/mail/request/send_message_event_request.dart';
import 'package:health_gauge/repository/mail/request/send_response_message_event_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/constants.dart';

/// Added by: Akhil
/// Added on: June/29/2020
/// This is the Bloc class for the email feature which is used to handle the api calls for email feature

class InboxBloc extends Bloc<InboxEvents, InboxState> {
  final draftsRepo = EmailData();
  bool? isInternetAvailable;

  InboxBloc() : super(InitialSearchState());

  /// Added by: Akhil
  /// Added on: June/29/2020
  /// This function is used for mapping event to state i.e. yielding different states for particular event
  /// @paramete : event - particular event is defined for particular api hit
  @override
  Stream<InboxState> mapEventToState(InboxEvents event) async* {
    //  yield LoadingSearchState();
    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for getting list of inbox, sent and trash emails from api and local database
    if (event is GetListEvent) {
      yield LoadingSearchState();
      final messageList =
      await draftsRepo.getMessageList(event.messageTypeid!, event.userID!);
      print(messageList);
      yield DatabaseLoadedState(messageList);
      try {
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable ?? false) {
          var getMessageData = {
            'UserID': event.userID,
            'pageSize': event.pageSize,
            'pageNumber': event.pageNumber,
            'MessageTypeid': event.messageTypeid,
          };
          final result = await MailRepository()
              .getMessageListByMessageTypeId(GetListEventRequest(
            userID: event.userID,
            pageSize: event.pageSize,
            pageNumber: event.pageNumber,
            messageTypeId: event.messageTypeid,
          ));
          if (result.hasData) {
            if (result.getData!.data == null) {
              yield SearchErrorState(result.getData!.result!);
            } else {
              if (result.getData!.data!.isNotEmpty) {
                result.getData!.data!.first.messageType = event.messageTypeid;
              }
              yield LoadedSearchState(result.getData!);
            }
          } else {}
          // final messageList = await GetListApi().callApi(
          //     Constants.inboxBaseUrl + "GetMessagelistByMessageTypeid",
          //     jsonEncode(getMessageData));
          //
          // if (messageList.data == null) {
          //   yield SearchErrorState(messageList.result!);
          // } else {
          //   yield LoadedSearchState(messageList);
          // }
        } else {
          if (messageList.isEmpty) {
            yield NoInternetState();
          }
        }
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for getting draft list from local database
    else if (event is GetDraftsList) {
      try {
        yield LoadingSearchState();
        final messageList = await draftsRepo.viewDrafts(event.userId!);
        print('messageList of draft');

        yield LoadedDraftsState(response: messageList);
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for deleting email from api .
    else if (event is DeleteMessageEvent) {
      try {
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable ?? false) {
          var deleteMessageData = {
            'MessageID': event.lastInboxMessageId.toString()
          };
          final result = await MailRepository()
              .deleteMessageById(event.messageId.toString());
          if (result.hasData) {
            if (result.getData!.message == null ||
                result.getData!.result == false) {
              yield SearchErrorState(result.getData!.result!);
            } else {
              yield MessageDeletedSuccessState(
                  DeleteMessageModel(
                      message: result.getData!.message!,
                      result: result.getData!.result!),
                  event.messageId!);
            }
          } else {
            yield SearchApiErrorState(null);
          }
          // final deleteMessageModel = await DeleteMessage().callApi(
          //     Constants.inboxBaseUrl + "DeleteMessagebyId", deleteMessageData);
          // if (deleteMessageModel?.message == null ||
          //     deleteMessageModel?.result == false) {
          //   print("false");
          //   yield SearchErrorState(deleteMessageModel!.result!);
          // } else {
          //   yield MessageDeletedSuccessState(
          //       deleteMessageModel!, event.messageId!);
          // }
        }
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for deleting draft from local database
    else if (event is DeleteDrafts) {
      try {
        await draftsRepo.deleteDrafts(event.id!);
        yield DraftsDeleteState();
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for deleting multiple emails of Inbox and Sent from api as well as local database
    else if (event is MultipleMessageDeleteEvent) {
      try {
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable ?? false) {
          var multipleDeleteData = {'MessagesIds': event.messageIds};
          final result = await MailRepository()
              .multipleDeleteMessages(MultipleTrashMessageDeleteEventRequest(
            messagesIds: event.messageIds,
          ));
          if (result.hasData) {
            if (result.getData!.result!) {
              for (var id in event.messageIds!) {
                draftsRepo.updateIsSync(id);
              }
              yield MultipleMessageDeleteSucessState(
                  response: MultipleMessageDeleteMessageModel(
                      result: result.getData!.result!,
                      response: result.getData!.response!,
                      message: result.getData!.message!));
            }
          } else {
            yield SearchApiErrorState(null);
          }
          // var response = await MultipleMessageDelete().callApi(
          //     Constants.inboxBaseUrl + "MultipleDeleteMessages",
          //     jsonEncode(multipleDeleteData));
          // if (response.result!) {
          //   for (var id in event.messageIds!) {
          //     draftsRepo.updateIsSync(id);
          //   }
          // }
          // print('Mulitple message deleted successfully');
          // yield MultipleMessageDeleteSucessState(response: response);
        }
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for deleting multiple trash messages
    else if (event is MultipleTrashMessageDeleteEvent) {
      try {
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable ?? false) {
          var multipleDeleteTrashData = {'MessagesIds': event.messageIds};
          final result = await MailRepository().multipleMessageDeleteFromTrash(
              MultipleTrashMessageDeleteEventRequest.fromJson(
                  multipleDeleteTrashData));
          if (result.hasData) {
            if (result.getData!.result!) {
              for (var id in event.messageIds!) {
                draftsRepo.deleteTrashEmail(id);
              }
              yield MultipleTrashMessageDeleteSucessState(
                  response: MultipleMessageDeleteMessageModel(
                      result: result.getData!.result!,
                      response: result.getData!.response!,
                      message: result.getData!.message!));
            }
          } else {
            yield SearchApiErrorState(null);
          }
          // var response = await MultipleMessageDeleteTrash().callApi(
          //     Constants.inboxBaseUrl + "MultipleMessageDeleteFromTrash",
          //     jsonEncode(multipleDeleteTrashData));
          // if (response.result!) {
          //   for (var id in event.messageIds!) {
          //     draftsRepo.deleteTrashEmail(id);
          //   }
          // }
          // yield MultipleTrashMessageDeleteSucessState(response: response);
        }
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for getting detail of particular message or email .
    else if (event is GetMessageDetailEvent) {
      try {
        var userMessage = <String, dynamic>{
          'MessageID': event.messageId,
          'LogedInEmailID': event.logedInEmailID
        };
        print(event.messageId);
        final result = await MailRepository()
            .getMessageDetailByMessageId(GetMessageDetailEventRequest(
          messageID: event.messageId,
          loggedInEmailID: event.logedInEmailID,
        ));
        if (result.hasData) {
          if (result.getData!.data == null) {
            yield SearchErrorState(result.getData!.result!);
          } else {
            yield MessageDetailListSuccessState(result.getData!);
          }
        } else {
          yield SearchApiErrorState(null);
        }
//         var url = Constants.inboxBaseUrl + "GetMessagedetlsByMessageid";
//         final messageDetailListModel =
//             await GetMessageDetail().callApi(url, userMessage);
//         print("getting data again 1");
//         if (messageDetailListModel.data == null) {
//           yield SearchErrorState(messageDetailListModel.result!);
//         } else {
// //          yield MessageDetailListSuccessState(messageDetailListModel);
//           print("getting data again 2");
//           yield MessageDetailListSuccessState(messageDetailListModel);
//           print("yielding data again 3");
//         }
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event of poping the screen.
    else if (event is DisposeEvent) {
      yield InitialSearchState();
    } else if (event is GetOutBoxList) {
      try {
        yield LoadingSearchState();
        final messageList = await draftsRepo.viewOutBox(event.userId!);

        yield LoadedOutboxState(response: messageList);
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for Marking particular message as read
    else if (event is MarkReadEvent) {
      try {
        var markReadData = {'MessageId': event.id.toString()};
        final result =
        await MailRepository().markAsReadByMessageID(event.id.toString());
        if (result.hasData) {
          if (result.getData!.result!) {
            yield MessageReadSuccessState(
                markReadModel: MarkReadModel(
                    result: result.getData!.result!,
                    message: result.getData!.message!));
          } else {
            yield SearchApiErrorState(null);
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // final markRead = await MarkReadApi().callApi(
        //     Constants.inboxBaseUrl + "MarkAsReadByMessageID", markReadData);
        //
        // yield MessageReadSuccessState(markReadModel: markRead);
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for restoring the messages from trash.
    else if (event is MessageRestoreEvent) {
      try {
        var messageRestoreData = {
          'MessageID': event.messageId,
          'UserId': event.userId
        };
        final result = await MailRepository()
            .restoreMessageByID(MessageRestoreEventRequest(
          messageID: event.messageId,
          userId: event.userId,
        ));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield MessageRestoreSuccessState(
                restoreMessageModel: RestoreMessageModel(
                  result: result.getData!.result!,
                  message: result.getData!.message!,
                ),
                messageId: event.messageId!);
          } else {
            yield SearchApiErrorState(null);
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // final restoreMessageModel = await RestoreMessageApi().callApi(
        //     Constants.inboxBaseUrl + "RestoreMessageByID",
        //     jsonEncode(messageRestoreData));
        //
        // yield MessageRestoreSuccessState(
        //     restoreMessageModel: restoreMessageModel,
        //     messageId: event.messageId!);
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: June/29/2020
    /// This is the event for sending messages to contacts.
    else if (event is SendMessageEvent) {
      try {
        var sendMessageData = {
          'MessageFrom': event.messageFrom,
          'MessageTo': event.messageTo,
          'MessageCc': event.messageCc,
          'MessageSubject': event.messageSubject,
          'MessageBody': event.messageBody,
          'FileExtension': event.fileExtension,
          'UserFile': event.userFile
        };
        print(sendMessageData);
        final result = await MailRepository().sendMessage(
            SendMessageEventRequest(
                messageFrom: event.messageFrom,
                messageTo: event.messageTo,
                messageCc: event.messageCc,
                messageSubject: event.messageSubject,
                messageBody: event.messageBody,
                fileExtension: event.fileExtension,
                userFile: event.userFile,
                createdDateTimeStamp:
                DateTime.now().millisecondsSinceEpoch.toString()));
        if (result.hasData) {
          if (result.getData!.message == null) {
            yield SearchErrorState(result.getData!.result!);
          } else {
            yield SendMessageSuccessState(SendMessageModel(
              message: result.getData!.message!,
              result: result.getData!.result!,
              response: result.getData!.response!,
              iD: result.getData!.iD!,
            ));
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // final sendMessageModel = await SendMesaage().callApi(
        //     Constants.inboxBaseUrl + "Sendmessage",
        //     jsonEncode(sendMessageData));
        // print(sendMessageModel.message);
        // if (sendMessageModel.message == null) {
        //   yield SearchErrorState(sendMessageModel.result!);
        // } else {
        //   yield SendMessageSuccessState(sendMessageModel);
        // }
      } catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: Aug/20/2020
    /// This is the event for marking all the messages as already read.
    else if (event is MarkAsReadAllListEvent) {
      try {
        var sendUserData = {
          'UserID': event.userID,
          'MessageTypeid': event.messageTypeid
        };
        final estimatedResult = await MailRepository()
            .markAsReadByMessageTypeID(MarkAsReadAllListEventRequest(
          userID: event.userID,
          messageTypeId: event.messageTypeid,
        ));
        if (estimatedResult.hasData) {
          if (estimatedResult.getData!.message == null) {
            yield SearchErrorState(estimatedResult.getData!.result!);
          } else {
            yield MarkAsReadAllMessageSuccessState(MarkAsReadAllMessageModel(
                response: estimatedResult.getData!.response!,
                result: estimatedResult.getData!.result!,
                message: estimatedResult.getData!.message!));
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // final markAsReadAllMessageModel = await MarkAsReadAllMessageApi()
        //     .callApi(Constants.inboxBaseUrl + "MarkAsReadByMessageTypeID",
        //         jsonEncode(sendUserData));
        // if (markAsReadAllMessageModel.message == null) {
        //   yield SearchErrorState(markAsReadAllMessageModel.result!);
        // } else {
        //   yield MarkAsReadAllMessageSuccessState(markAsReadAllMessageModel);
        // }
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: Aug/20/2020
    /// This is the event for removing all the messages from Trash.
    else if (event is EmptyTrashListEvent) {
      try {
        var sendUserData = {
          'UserID': event.userID,
        };
        final estimatedResult =
        await MailRepository().emptyMessagesFromTrash(event.userID!);
        if (estimatedResult.hasData) {
          if (estimatedResult.getData!.message == null ||
              estimatedResult.getData!.result == false) {
            yield SearchErrorState(estimatedResult.getData!.result!);
          } else {
            yield TrashAllMessageSuccessState(TrashAllMessageModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                message: estimatedResult.getData!.message!));
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // final trashAllMessageModel = await TrashAllMessageApi().callApi(
        //     Constants.inboxBaseUrl + "EmptyMessagesFromTrash",
        //     jsonEncode(sendUserData));
        // if (trashAllMessageModel.message == null ||
        //     trashAllMessageModel.result == false) {
        //   yield SearchErrorState(trashAllMessageModel.result!);
        // } else {
        //   yield TrashAllMessageSuccessState(trashAllMessageModel);
        // }
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: Aug/20/2020
    /// This is the event for reply, reply all and forward.
    else if (event is SendResponseMessageEvent) {
      yield LoadingSearchState();
      try {
        var sendMessageData = {
          'MessageID': event.messageId,
          'MsgResponseTypeID': event.messageResponseTypeId,
          'MessageFrom': event.messageFrom,
          'MessageTo': event.messageTo,
          'MessageCc': event.messageCc,
          'MessageSubject': event.messageSubject,
          'MessageBody': event.messageBody,
          'FileExtension': event.fileExtension,
          'UserFile': event.userFile,
          'ParentGUIID': event.parentGUIID
        };
        final estimatedResult =
        await MailRepository().sendResponseByMessageIDAndTypeID(
          SendResponseMessageEventRequest(
            messageID: event.messageId,
            msgResponseTypeID: event.messageResponseTypeId,
            messageFrom: event.messageFrom,
            messageTo: event.messageTo,
            messageCc: event.messageCc,
            messageSubject: event.messageSubject,
            messageBody: event.messageBody,
            fileExtension: event.fileExtension,
            userFile: event.userFile,
            parentGUIID: event.parentGUIID,
            createdDateTimeStamp:
            DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          ),
        );
        if (estimatedResult.hasData) {
          if (estimatedResult.getData!.message == null) {
            yield SearchErrorState(estimatedResult.getData!.result!);
          } else {
            yield SendResponseMessageSuccessState(SendResponseMessageModel(
                result: estimatedResult.getData!.result,
                iD: estimatedResult.getData!.iD,
                message: estimatedResult.getData!.message));
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // final SendResponseMessageModel sendResponseMessageModel =
        //     await SendResponseMessageApi().callApi(
        //         Constants.inboxBaseUrl + "SendResponseByMessageIDAndTypeID",
        //         jsonEncode(sendMessageData));
        // if (sendResponseMessageModel.message == null) {
        //   yield SearchErrorState(sendResponseMessageModel.result!);
        // } else {
        //   yield SendResponseMessageSuccessState(sendResponseMessageModel);
        // }
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }
  }
}
