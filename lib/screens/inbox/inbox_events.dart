import 'package:equatable/equatable.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';

/// Added by: Akhil
/// Added on: June/30/2020
/// This is the Event class for the email feature (all the events added from UI is listed in this class)
abstract class InboxEvents extends Equatable {
  const InboxEvents();
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to get list of inbox, sent and trash messages
class GetListEvent extends InboxEvents {
  final int? userID;
  final int? pageSize;
  final int? pageNumber;
  final int? messageTypeid;
  const GetListEvent(
      {this.userID, this.pageSize, this.pageNumber, this.messageTypeid});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to send message to the contact
class SendMessageEvent extends InboxEvents {
  final String? messageFrom;
  final String? messageTo;
  final String? messageCc;
  final String? messageSubject;
  final String? messageBody;
  final String? requestType;
//  final List<String> userFile;
//  final List<String> fileExtension;
  final String? userFile;
  final String? fileExtension;
  const SendMessageEvent(
      {this.messageFrom,
      this.messageTo,
      this.messageCc,
      this.messageSubject,
      this.messageBody,
      this.userFile,
      this.fileExtension,
      this.requestType});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to delete message from inbox and sent
class DeleteMessageEvent extends InboxEvents {
  final int? messageId;
  final int? lastInboxMessageId;
  const DeleteMessageEvent({this.lastInboxMessageId, this.messageId});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to get list of inbox, sent and trash messages
class GetMessageDetailEvent extends InboxEvents {
  final int? messageId;
  final String? logedInEmailID;
  const GetMessageDetailEvent({this.messageId, this.logedInEmailID});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to dispose the objects from memory when the inbox screen pops
class DisposeEvent extends InboxEvents {
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to get list of drafts from local database
class GetDraftsList extends InboxEvents {
  final int? userId;
  const GetDraftsList({
    this.userId,
  });
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to save drafts to the local database
class AddDrafts extends InboxEvents {
  final InboxData? draft;
  const AddDrafts({this.draft});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to delete draft from local database
class DeleteDrafts extends InboxEvents {
  final int? id;
  const DeleteDrafts({this.id});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to get list of mails in outbox from local database
class GetOutBoxList extends InboxEvents {
  final int? userId;
  const GetOutBoxList({
    this.userId,
  });
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to add mail in outbox in local database.
class AddOutbox extends InboxEvents {
  final InboxData? outBox;
  const AddOutbox({this.outBox});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to delete outbox mail from local database.
class DeleteOutbox extends InboxEvents {
  final int? id;
  const DeleteOutbox({this.id});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to mark mail as read .
class MarkReadEvent extends InboxEvents {
  final int? id;
  const MarkReadEvent({this.id});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to restore mails from trash to sent and inbox
class MessageRestoreEvent extends InboxEvents {
  final int? messageId;
  final int? userId;
  const MessageRestoreEvent({this.messageId, this.userId});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to delete multiple messages from inbox and sent.
class MultipleMessageDeleteEvent extends InboxEvents {
  final List<int>? messageIds;
  const MultipleMessageDeleteEvent({this.messageIds});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to delete multiple messages from trash.
class MultipleTrashMessageDeleteEvent extends InboxEvents {
  final List<int>? messageIds;
  const MultipleTrashMessageDeleteEvent({this.messageIds});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to get list of contacts.
class LoadContactList extends InboxEvents {
  final int? userId;
  const LoadContactList({required this.userId});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to delete contact from contact list.
class DeleteContact extends InboxEvents {
  final int? fromUserId;
  final int? toUserId;
  final int? id;

  const DeleteContact(
      {required this.fromUserId, required this.toUserId, required this.id});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to get list of pending invitations.
class GetInvitations extends InboxEvents {
  final int? userId;
  const GetInvitations({this.userId});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to search contact to send invitation.
class SearchContactListEvent extends InboxEvents {
  final int? userId;
  final String? Query;
  const SearchContactListEvent({required this.userId, required this.Query});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to send invitation to any user.
class SendInvitationEvent extends InboxEvents {
  final int? loggedInUserId;
  final int? inviteeUserId;
  final int? index;
  const SendInvitationEvent(
      {this.loggedInUserId, this.inviteeUserId, this.index});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: June/30/2020
/// Event to accept or reject any pending invitation.
class AcceptRejectInvitation extends InboxEvents {
  final int? contactId;
  final bool? isAccepted;
  AcceptRejectInvitation({this.contactId, this.isAccepted});
  @override
  List<Object> get props => [];
}

class GetInvitationListEvent extends InboxEvents {
  final int? userId;
  GetInvitationListEvent({this.userId});
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: Aug/20/2020
/// Event to mark as read the list of inbox
class MarkAsReadAllListEvent extends InboxEvents {
  final int? userID;
  final int? messageTypeid;
  const MarkAsReadAllListEvent({this.userID, this.messageTypeid});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: Aug/20/2020
/// Event to empty the list of trash
class EmptyTrashListEvent extends InboxEvents {
  final int? userID;
  const EmptyTrashListEvent({this.userID});

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: Aug/20/2020
/// Event to response list of inbox
class SendResponseMessageEvent extends InboxEvents {
  final int? messageId;
  final int? messageResponseTypeId;
  final String? messageFrom;
  final String? messageTo;
  final String? messageCc;
  final String? messageSubject;
  final String? messageBody;
  final String? parentGUIID;
//  final List<String> userFile;
//  final List<String> fileExtension;
  final String? userFile;
  final String? fileExtension;
  const SendResponseMessageEvent(
      {this.messageId,
      this.messageResponseTypeId,
      this.messageFrom,
      this.messageTo,
      this.messageCc,
      this.messageSubject,
      this.messageBody,
      this.userFile,
      this.fileExtension,
      this.parentGUIID});

  @override
  List<Object> get props => [];
}

class SearchContactListEvents extends InboxEvents {
  final String? query;
  final List<UserData>? userData;

  SearchContactListEvents({required this.userData, required this.query});

  @override
  List<Object> get props => [];
}
