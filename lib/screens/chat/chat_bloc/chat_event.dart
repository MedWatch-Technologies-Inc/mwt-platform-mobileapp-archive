import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/models/group_list_model.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class GetAccessChattedWith extends ChatEvent {
  final int? userID;
  const GetAccessChattedWith({this.userID});
  @override
  List<Object> get props => [];
}

class GetAccessHistoryTwoUsers extends ChatEvent {
  final int? fromUserId;
  final int? toUserId;

  @override
  List<Object> get props => [];

  GetAccessHistoryTwoUsers({this.fromUserId, this.toUserId});
}

class SearchChatList extends ChatEvent {
  final String? query;
  late final List<ChatUserData> userData;
  SearchChatList({required this.userData, this.query});

  @override
  List<Object> get props => [];
}

class SearchGroupList extends ChatEvent {
  final String? query;
  late final List<Data> userData;
  SearchGroupList({required this.userData, this.query});

  @override
  List<Object> get props => [];
}

class DisposeEvent extends ChatEvent {
  @override
  List<Object> get props => [];
}

class CreateGroupEvent extends ChatEvent {
  final String? groupName;
  final String? userIds;
  // final String response;
  CreateGroupEvent({this.groupName, this.userIds});

  @override
  List<Object> get props => [];
}

class ChatGroupHistoryEvent extends ChatEvent {
  final String? groupName;
  final int? pageIndex;
  final int? pageSize;

  ChatGroupHistoryEvent({this.groupName, this.pageIndex, this.pageSize});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchGroupParticipantsEvent extends ChatEvent {
  final String? groupName;
  FetchGroupParticipantsEvent({this.groupName});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendGroupMessageEvent extends ChatEvent {
  final String? maskedGroupName;
  final String? message;
  final String? senderUserName;
  SendGroupMessageEvent(
      {this.maskedGroupName, this.message, this.senderUserName});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GroupListingEvent extends ChatEvent {
  final int? userId;
  GroupListingEvent({this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GroupRemoveEvent extends ChatEvent {
  final String? groupName;
  GroupRemoveEvent({this.groupName});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddGroupParticipantEvent extends ChatEvent {
  final String? memberIds;
  final String? groupName;
  AddGroupParticipantEvent({
    @required this.memberIds,
    @required this.groupName,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveGroupParticipantEvent extends ChatEvent {
  final String? memberIds;
  final String? groupName;
  final int? index;
  RemoveGroupParticipantEvent({
    @required this.memberIds,
    @required this.groupName,
    @required this.index,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

// class GetNonParticipantsListEvent extends ChatEvent {
//   final ContactsBloc contactsBloc;
//   GetNonParticipantsListEvent(this.contactsBloc);
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [];
// }
