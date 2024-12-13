import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:health_gauge/screens/chat/models/access_group_chat_history_model.dart';

import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/models/access_create_group_chat_model.dart';
import 'package:health_gauge/screens/chat/models/access_history_with_two_user_model.dart';
import 'package:health_gauge/screens/chat/models/access_send_group_model.dart';
import 'package:health_gauge/screens/chat/models/group_list_model.dart';
import 'package:health_gauge/screens/chat/models/group_remove_model.dart';
import 'package:health_gauge/screens/chat/models/list_of_group_participants.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatLoading extends ChatState {
  @override
  List<Object> get props => [];
}

class AccessChattedWithSuccessState extends ChatState {
  final AccessChattedWithModel dataModel;
  const AccessChattedWithSuccessState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class AccessHistoryWithTwoUserSuccessState extends ChatState {
  final AccessHistoryWithTwoUserModel dataModel;
  const AccessHistoryWithTwoUserSuccessState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class ChatErrorState extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatSearchSuccessState extends ChatState {
  final List<ChatUserData> searchData;
  ChatSearchSuccessState(this.searchData);

  @override
  List<Object> get props => [searchData];
}

class ChatSearchEmptyState extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatListIsLoadingState extends ChatState {
  @override
  List<Object> get props => [];
}

class GroupChatSearchSuccessState extends ChatState {
  final List<Data> searchData;
  GroupChatSearchSuccessState(this.searchData);

  @override
  List<Object> get props => [searchData];
}

class GroupChatSearchEmptyState extends ChatState {
  @override
  List<Object> get props => [];
}

class DatabaseLoadedState extends ChatState {
  final AccessChattedWithModel dataModel;
  const DatabaseLoadedState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class DatabaseChatHistoryLoadedState extends ChatState {
  final AccessHistoryWithTwoUserModel dataModel;
  const DatabaseChatHistoryLoadedState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class CreateGroupSuccessState extends ChatState {
  final AccessCreateChatGroupModel dataModel;
  CreateGroupSuccessState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class CreateGroupAlreadyExistState extends ChatState {
  final AccessCreateChatGroupModel dataModel;
  CreateGroupAlreadyExistState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class CreateGroupErrorState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GroupChatListIsLoadingState extends ChatState {
  @override
  List<Object> get props => [];
}

class GroupChatHistorySuccessState extends ChatState {
  final GroupAccessChatHistoryModel dataModel;

  GroupChatHistorySuccessState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class GroupChatHistoryNoDataState extends ChatState {
  final GroupAccessChatHistoryModel dataModel;
  GroupChatHistoryNoDataState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class GroupChatHistoryErrorState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChatGroupListDatabaseLoadedState extends ChatState {
  final AccessSendGroupModel dataModel;
  const ChatGroupListDatabaseLoadedState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class DatabaseGroupChatHistoryLoadedState extends ChatState {
  final GroupAccessChatHistoryModel dataModel;
  const DatabaseGroupChatHistoryLoadedState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class FetchGroupParticipantsLoadingState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchGroupParticipantsSuccessState extends ChatState {
  final ListOfGroupParticipantsModel dataModel;
  FetchGroupParticipantsSuccessState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class FetchGroupParticipantsNoDataState extends ChatState {
  final ListOfGroupParticipantsModel dataModel;
  FetchGroupParticipantsNoDataState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class FetchGroupParticipantsErrorState extends ChatState {
  late final Object exception;
  FetchGroupParticipantsErrorState({required this.exception});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendGroupMessageSuccessState extends ChatState {
  final AccessSendGroupModel dataModel;
  SendGroupMessageSuccessState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class SendGroupMessageErrorState extends ChatState {
  // final AccessSendGroupModel dataModel;
  SendGroupMessageErrorState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GroupListingSuccessState extends ChatState {
  final GroupListModel dataModel;
  GroupListingSuccessState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class GroupListingNoDataState extends ChatState {
  final GroupListModel dataModel;
  GroupListingNoDataState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class GroupListingErrorState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GroupRemoveSuccessState extends ChatState {
  final GroupRemoveModel dataModel;

  GroupRemoveSuccessState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class GroupRemoveDoesNotExistState extends ChatState {
  final GroupRemoveModel dataModel;
  GroupRemoveDoesNotExistState(this.dataModel);

  @override
  // TODO: implement props
  List<Object> get props => [dataModel];
}

class GroupRemoveErrorState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddGroupParticipantLoadingState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddGroupParticipantSuccessState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddGroupParticipantFailureState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddGroupParticipantErrorState extends ChatState {
  late final Object exception;
  AddGroupParticipantErrorState({required this.exception});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveGroupParticipantLoadingState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveGroupParticipantSuccessState extends ChatState {
  final int? index;
  RemoveGroupParticipantSuccessState({this.index});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveGroupParticipantFailureState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveGroupParticipantErrorState extends ChatState {
  late final Object exception;
  RemoveGroupParticipantErrorState({required this.exception});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
