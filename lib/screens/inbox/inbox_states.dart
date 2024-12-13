import 'package:equatable/equatable.dart';
import 'package:health_gauge/models/contact_models/get_invitation_list_model.dart';
import 'package:health_gauge/models/contact_models/accept_reject_invitation_model.dart';
import 'package:health_gauge/models/contact_models/delete_user_model.dart';
import 'package:health_gauge/models/contact_models/pending_invitation_model.dart';
import 'package:health_gauge/models/contact_models/search_contact_list.dart';
import 'package:health_gauge/models/contact_models/send_invitation_model.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/models/inbox_models/delete_message_model.dart';
import 'package:health_gauge/models/inbox_models/mark_as_read_all_messages_model.dart';
import 'package:health_gauge/models/inbox_models/mark_read_model.dart';
import 'package:health_gauge/models/inbox_models/message_detail_model.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/models/inbox_models/multiple_delete_message_model.dart';
import 'package:health_gauge/models/inbox_models/restore_message_model.dart';
import 'package:health_gauge/models/inbox_models/send_message_model.dart';
import 'package:health_gauge/models/inbox_models/send_response_message_model.dart';
import 'package:health_gauge/models/inbox_models/trash_all_messages_model.dart';
import 'package:health_gauge/screens/chat/models/contact_model.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

/// Added by: Akhil
/// Added on: July/01/2020
/// this is class for different states used in email and contact feature
abstract class InboxState extends Equatable {
  const InboxState();
}

/// Added by: Akhil
/// Added on: July/01/2020
/// Initial state of Inbox feature
class InitialSearchState extends InboxState {
  const InitialSearchState();

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// Loading state of Inbox feature
class LoadingSearchState extends InboxState {
  const LoadingSearchState();

  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// Loaded state of Inbox feature
class LoadedSearchState extends InboxState {
  final MessageListModel searchResponse;

  const LoadedSearchState(this.searchResponse);

  @override
  List<Object> get props => [searchResponse];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when data from database is loaded
class DatabaseLoadedState extends InboxState {
  final List<InboxData> list;

  const DatabaseLoadedState(this.list);

  @override
  List<Object> get props => [list];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when error is thrown by api
class SearchApiErrorState extends InboxState {
  final  error;

  const SearchApiErrorState(this.error);

  @override
  List<Object> get props => [error];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when message is deleted from inbox or sent
class MessageDeletedSuccessState extends InboxState {
  final DeleteMessageModel deleteMessageModel;
  final int messageId;
  const MessageDeletedSuccessState(this.deleteMessageModel, this.messageId);
  @override
  List<Object> get props => [deleteMessageModel, messageId];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when message is sent
class SendMessageSuccessState extends InboxState {
  final SendMessageModel sendMessageModel;
  const SendMessageSuccessState(this.sendMessageModel);
  @override
  List<Object> get props => [sendMessageModel];
}

/// Added by: Akhil
/// Added on: Aug/20/2020
/// This state is yield when we click on markAsRead icon
class MarkAsReadAllMessageSuccessState extends InboxState {
  final MarkAsReadAllMessageModel markAsReadAllMessageModel;
  const MarkAsReadAllMessageSuccessState(this.markAsReadAllMessageModel);
  @override
  List<Object> get props => [markAsReadAllMessageModel];
}

/// Added by: Akhil
/// Added on: Aug/20/2020
/// This state is yield when we get the response from empty trash Api
class TrashAllMessageSuccessState extends InboxState {
  final TrashAllMessageModel trashAllMessageModel;
  const TrashAllMessageSuccessState(this.trashAllMessageModel);
  @override
  List<Object> get props => [trashAllMessageModel];
}

/// Added by: Akhil
/// Added on: Aug/21/2020
/// This state is yield when we get the response from send respond by msg id Api
class SendResponseMessageSuccessState extends InboxState {
  final SendResponseMessageModel sendResponseMessageModel;
  const SendResponseMessageSuccessState(this.sendResponseMessageModel);
  @override
  List<Object> get props => [sendResponseMessageModel];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when data from message detail api is received
class MessageDetailSuccessState extends InboxState {
  final MessageDetailModel messageDetailModel;
  const MessageDetailSuccessState(this.messageDetailModel);
  @override
  List<Object> get props => [messageDetailModel];
}

/// Added by: Akhil
/// Added on: Aug/21/2020
/// This state is yield when data from message detail List api is received
class MessageDetailListSuccessState extends InboxState {
  final MessageDetailListModel messageDetailListModel;
  const MessageDetailListSuccessState(this.messageDetailListModel);
  @override
  List<Object> get props => [messageDetailListModel];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when user pops the screen
class DisposeState extends InboxState {
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when drafts from the database is loaded
class LoadedDraftsState extends InboxState {
  late final List<InboxData> response;

   LoadedDraftsState({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when draft is saved in the local database
class DraftsAddSucessState extends InboxState {
  const DraftsAddSucessState();
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when draft is deleted from the local database
class DraftsDeleteState extends InboxState {
  const DraftsDeleteState();
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when error is received
class SearchErrorState extends InboxState {
  final bool error;

  const SearchErrorState(this.error);

  @override
  List<Object> get props => [error];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when outbox is saved in local database
class OutboxAddSucessState extends InboxState {
  const OutboxAddSucessState();
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when outbox is deleted from the local database
class OutboxDeleteState extends InboxState {
  const OutboxDeleteState();
  @override
  List<Object> get props => [];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when outbox mails are loaded from local database
class LoadedOutboxState extends InboxState {
  late final List<InboxData> response;

   LoadedOutboxState({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield  when read message api is hit successfully
class MessageReadSuccessState extends InboxState {
  final MarkReadModel markReadModel;
  const MessageReadSuccessState({required this.markReadModel});
  @override
  List<Object> get props => [markReadModel];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when trash message is restored to inbox or sent
class MessageRestoreSuccessState extends InboxState {
  late final RestoreMessageModel restoreMessageModel;
  late final int messageId;
   MessageRestoreSuccessState({required this.restoreMessageModel, required this.messageId});
  @override
  List<Object> get props => [restoreMessageModel, messageId];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when multiple messages from inbox or sent is deleted successfully
class MultipleMessageDeleteSucessState extends InboxState {
 late final MultipleMessageDeleteMessageModel response;
   MultipleMessageDeleteSucessState({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when multiple messages from trash are deleted successfully
class MultipleTrashMessageDeleteSucessState extends InboxState {
  late final MultipleMessageDeleteMessageModel response;
   MultipleTrashMessageDeleteSucessState({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when user contact list is loaded
class LoadedContactList extends InboxState {
  late final UserListModel response;
   LoadedContactList({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when contact is deleted from the contact list
class DeletedContact extends InboxState {
  final DeleteUserModel response;
  const DeletedContact({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when pending invitations are loaded
class LoadedInvitations extends InboxState {
  final PendingInvitationModel response;
  const LoadedInvitations({required this.response});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield after getting response from search contact api.
class SearchContactListState extends InboxState {
  final SearchContactList response;
  const SearchContactListState({required this.response});
  @override
  List<Object> get props => [response];
}

class SearchContactListOffline extends InboxState {
  SearchContactListOffline();

  @override
  List<Object> get props => [];
}

class SendingInvitationState extends InboxState {
  final int index;
  final int userId;
  const SendingInvitationState({required this.index, required this.userId});
  @override
  List<Object> get props => [index, userId];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when invitation is sent successfully
class SendInvitationSucessfulState extends InboxState {
  final SendInvitationModel response;
  final int index;
  final int userId;
  const SendInvitationSucessfulState({required this.response, required this.index,required this.userId});
  @override
  List<Object> get props => [response];
}

/// Added by: Akhil
/// Added on: July/01/2020
/// This state is yield when event is either accepted or rejected
class AcceptRejectInvitationSucessState extends InboxState {
  final AcceptOrRejectInvitationModel response;
  AcceptRejectInvitationSucessState({required this.response});
  @override
  List<Object> get props => [response];
}

class GetInvitationListState extends InboxState {
  final GetInvitationListModel response;
  GetInvitationListState({required this.response});
  @override
  List<Object> get props => [response];
}

class NoInternetState extends InboxState {
  @override
  List<Object> get props => [];
}

class ContactSearchSuccessState extends InboxState {
  final List<UserData> searchData;
  ContactSearchSuccessState(this.searchData);

  @override
  List<Object> get props => [searchData];
}

class ContactSearchEmptyState extends InboxState {
  @override
  List<Object> get props => [];
}
