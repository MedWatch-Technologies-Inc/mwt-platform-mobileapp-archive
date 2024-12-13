import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/repository/chat/chat_repository.dart';
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
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/models/access_create_group_chat_model.dart';
import 'package:health_gauge/screens/chat/models/access_group_chat_history_model.dart';
import 'package:health_gauge/screens/chat/models/access_history_with_two_user_model.dart';
import 'package:health_gauge/screens/chat/models/access_send_group_model.dart';
import 'package:health_gauge/screens/chat/models/group_list_model.dart';
import 'package:health_gauge/screens/chat/models/group_remove_model.dart';
import 'package:health_gauge/screens/chat/models/list_of_group_participants.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  bool isInternetAvailable = false;

  ChatBloc(ChatState initialState) : super(initialState);
  // ChatBloc(ChatState initialState) : super(initialState){
  //   print("chat event mapEventToState222sssss:  ");
  //   on<GetAccessChattedWith>((event, emit) async*  {
  //     print("chat event mapEventToState222sssss: ${event.toString()} ");
  //     try {
  //       var data = <String, dynamic>{
  //         'fromuserId': '${event.userID}',
  //       };
  //
  //       var userData = await dbHelper.getChatList(event.userID);
  //       yield DatabaseLoadedState(AccessChattedWithModel(
  //           result: true, response: 200, data: userData));
  //       isInternetAvailable = await Constants.isInternetAvailable();
  //       if (isInternetAvailable) {
  //         final estimatedResult = await ChatRepository()
  //             .getAccessChattedWith(AccessChattedWithRequest.fromJson(data));
  //         if (estimatedResult.hasData) {
  //           if (estimatedResult.getData!.result! && estimatedResult.getData!.data!.isNotEmpty) {
  //             // var chatUserData = estimatedResult.getData!.data != null
  //             //     ? estimatedResult.getData!.data!
  //             //         .map((e) => ChatUserData.fromJson(e.toJson()))
  //             //         .toList()
  //             //     : <ChatUserData>[];
  //             // var accessChattedWithModel = AccessChattedWithModel(
  //             //     result: estimatedResult.getData!.result,
  //             //     response: estimatedResult.getData!.response,
  //             //     data: chatUserData);
  //             yield AccessChattedWithSuccessState(estimatedResult.getData!);
  //           }else{
  //             yield ChatSearchEmptyState();
  //           }
  //         } else if (estimatedResult.hasException) {
  //           yield ChatErrorState();
  //         }
  //         // var url = Constants.inboxBaseUrl + "AccessChattedWith";
  //         // final accessChattedWithModel =
  //         //     await GetAccessChattedWithCall().callApi(url, data);
  //         // if (accessChattedWithModel!.result!) {
  //         //   yield AccessChattedWithSuccessState(accessChattedWithModel);
  //         // }
  //       }
  //     } on Exception catch (e) {
  //       yield ChatErrorState();
  //     }
  //   });
  // }

  @override
  ChatState get initialState => ChatLoading();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    print("chat event mapEventToStatesssss: ${event.toString()} ");
    if (event is GetAccessChattedWith) {
      try {
        var data = <String, dynamic>{
          'fromuserId': '${event.userID}',
        };
        var userData = await dbHelper.getChatList(event.userID);
        yield DatabaseLoadedState(AccessChattedWithModel(
            result: true, response: 200, data: userData));
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          final estimatedResult = await ChatRepository()
              .getAccessChattedWith(AccessChattedWithRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.data!.isNotEmpty) {
              // var chatUserData = estimatedResult.getData!.data != null
              //     ? estimatedResult.getData!.data!
              //         .map((e) => ChatUserData.fromJson(e.toJson()))
              //         .toList()
              //     : <ChatUserData>[];
              // var accessChattedWithModel = AccessChattedWithModel(
              //     result: estimatedResult.getData!.result,
              //     response: estimatedResult.getData!.response,
              //     data: chatUserData);
              yield AccessChattedWithSuccessState(estimatedResult.getData!);
            } else {
              yield ChatSearchEmptyState();
            }
          } else if (estimatedResult.hasException) {
            yield ChatErrorState();
          }
          // var url = Constants.inboxBaseUrl + "AccessChattedWith";
          // final accessChattedWithModel =
          //     await GetAccessChattedWithCall().callApi(url, data);
          // if (accessChattedWithModel!.result!) {
          //   yield AccessChattedWithSuccessState(accessChattedWithModel);
          // }
        }
      } on Exception catch (e) {
        yield ChatErrorState();
      }
    }

    bool isInDb(GroupChatMessageData data) {
      return false;
    }

    if (event is GetAccessHistoryTwoUsers) {
      try {
        var data = <String, dynamic>{
          'fromuserId': '${event.fromUserId}',
          'touserId': '${event.toUserId}',
        };
        yield ChatListIsLoadingState();
        isInternetAvailable = await Constants.isInternetAvailable();
        var messageData =
            await dbHelper.getChatDetail(event.fromUserId, event.toUserId);
        yield DatabaseChatHistoryLoadedState(AccessHistoryWithTwoUserModel(
            result: true, response: 200, data: messageData));
        if (isInternetAvailable) {
          yield ChatListIsLoadingState();
          print("ChatListIsLoadingState");
          final estimatedResult = await ChatRepository()
              .getAccessChatHistoryTwoUsers(
                  AccessChatHistoryTwoUsersRequest.fromJson(data));
          if (estimatedResult.hasData) {
            print("estimatedResult.hasData");
            if (estimatedResult.getData!.result!) {
              yield AccessHistoryWithTwoUserSuccessState(
                  AccessHistoryWithTwoUserModel(
                      result: estimatedResult.getData!.result!,
                      response: estimatedResult.getData!.response!,
                      data: estimatedResult.getData!.data != null
                          ? estimatedResult.getData!.data!
                              .map((e) => ChatMessageData.fromJson(e.toJson()))
                              .toList()
                          : []));
            } else {
              yield ChatErrorState();
            }
          } else if (estimatedResult.hasException) {
            yield ChatErrorState();
          }
          // var url = Constants.inboxBaseUrl + "AccessChatHistoryTwoUsers";
          // // yield ChatListIsLoadingState();
          // final accessHistoryWithTwoUserModel =
          //     await GetAccessChatHistoryTwoUserCall().callApi(url, data);
          // if (accessHistoryWithTwoUserModel!.result) {
          //   yield AccessHistoryWithTwoUserSuccessState(
          //       accessHistoryWithTwoUserModel);
          // }
        }
      } on Exception catch (e) {
        yield ChatErrorState();
      }
    }

    if (event is SearchChatList) {
      late List<ChatUserData> userData;
      userData = event.userData;
      String? query;
      query = event.query;
      var searchResult = <ChatUserData>[];
      for (var data in userData) {
        if (data.firstName!.toLowerCase().contains(query!.toLowerCase()) ||
            data.firstName!.toLowerCase().contains(query.toLowerCase()) ||
            '${data.firstName} ${data.lastName}'
                .toLowerCase()
                .contains(query.toLowerCase())) {
          searchResult.add(data);
        }
      }

      if (searchResult.isNotEmpty) {
        yield ChatSearchSuccessState(searchResult);
      } else {
        yield ChatSearchEmptyState();
      }
    }

    if (event is SearchGroupList) {
      late List<Data> userData;
      userData = event.userData;
      String? query;
      query = event.query;
      var searchResult = <Data>[];
      for (var data in userData) {
        if (data.groupName!.toLowerCase().contains(query!.toLowerCase()) ||
            // data.groupName.toLowerCase().contains(query.toLowerCase()) ||
            '${data.groupName}'.toLowerCase().contains(query.toLowerCase())) {
          searchResult.add(data);
        }
      }

      if (searchResult.isNotEmpty) {
        yield GroupChatSearchSuccessState(searchResult);
      } else {
        yield GroupChatSearchEmptyState();
      }
    }

    if (event is DisposeEvent) {
      yield ChatLoading();
    }

    if (event is CreateGroupEvent) {
      try {
        var data = {
          'groupName': '${event.groupName}',
          'memberIds': '${event.userIds}'
        };
        yield ChatLoading();
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          // String url = Constants.chatUrl + 'AccessCreateChatGroup';
          final estimatedResult = await ChatRepository()
              .accessCreateChatGroup(CreateGroupEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 300) {
              yield CreateGroupAlreadyExistState(AccessCreateChatGroupModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                message: estimatedResult.getData!.message!,
              ));
            } else if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 201) {
              yield CreateGroupSuccessState(AccessCreateChatGroupModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                message: estimatedResult.getData!.message!,
              ));
            }
          } else {
            yield CreateGroupErrorState();
          }
          // final groupAccessCreateChatModel =
          //     await AccessCreateChatGroup().callApi(url, data);
          // if (groupAccessCreateChatModel!.result &&
          //     groupAccessCreateChatModel.response == 300) {
          //   yield CreateGroupAlreadyExistState(groupAccessCreateChatModel);
          // }
          // // yield CreateGroupSuccessState();
          // if (groupAccessCreateChatModel.result &&
          //     groupAccessCreateChatModel.response == 201) {
          //   yield CreateGroupSuccessState(groupAccessCreateChatModel);
          // }
        }

        // yield CreateGroupFailState();
      } on Exception catch (e) {
        yield CreateGroupErrorState();
      }
    }

    if (event is ChatGroupHistoryEvent) {
      try {
        var data = <String, dynamic>{
          'groupName': '${event.groupName}',
          // 'pageIndex': '${event.pageIndex}',
          // 'pageSize':'${event.pageSize}'
        };
        yield GroupChatListIsLoadingState();

        //todo
        // List<GroupChatMessageData> messageData =
        //     await dbHelper.getGroupChatDetail(event.groupName);
        // yield DatabaseGroupChatHistoryLoadedState(GroupAccessChatHistoryModel(
        //     result: true, response: 200, data: messageData));
        isInternetAvailable = await Constants.isInternetAvailable();

        if (isInternetAvailable) {
          // String url = Constants.chatUrl + 'AccessChatHistoryGroup';
          final estimatedResult = await ChatRepository().accessGroupChatHistory(
              ChatGroupHistoryEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            var groupAccessChatHistoryModel = GroupAccessChatHistoryModel(
                response: estimatedResult.getData!.response!,
                result: estimatedResult.getData!.result!,
                data: estimatedResult.getData?.data!
                        .map((e) => GroupChatMessageData.fromJson(e.toJson()))
                        .toList() ??
                    []);
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response! == 200) {
              yield GroupChatHistorySuccessState(groupAccessChatHistoryModel);
              //todo insert msg into db
              groupAccessChatHistoryModel.data.forEach((element) {
                if (!isInDb(element)) {
                  var dbData = <String, dynamic>{
                    'GroupName': '${event.groupName}',
                    'Message': '${element.message}',
                    'DateSent': element.dateSent,
                    'FromUserName': '${element.fromUsername}',
                    'IsSent': 1,
                  };
                  dbData['MessageKey'] =
                      dbData['FromUserName'] + dbData['DateSent'];
                  dbHelper.insertGroupChatDetail(dbData);
                }
              });
            } else if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response! == 204) {
              yield GroupChatHistoryNoDataState(groupAccessChatHistoryModel);
            }
          } else {
            yield GroupChatHistoryErrorState();
          }
          // final groupAccessChatHistoryModel =
          //     await AccessChatHistoryGroup().callApi(url, data);
          // if (groupAccessChatHistoryModel!.result &&
          //     groupAccessChatHistoryModel.response == 200) {
          //   yield GroupChatHistorySuccessState(groupAccessChatHistoryModel);
          //   //todo insert msg into db
          //   groupAccessChatHistoryModel.data.forEach((element) {
          //     if (!isInDb(element)) {
          //       var dbData = <String, dynamic>{
          //         'GroupName': '${event.groupName}',
          //         'Message': '${element.message}',
          //         'DateSent': element.dateSent,
          //         'FromUserName': '${element.fromUsername}',
          //         'IsSent': 1,
          //       };
          //       dbData['MessageKey'] =
          //           dbData['FromUserName'] + dbData['DateSent'];
          //       dbHelper.insertGroupChatDetail(dbData);
          //     }
          //   });
          // }
          // if (groupAccessChatHistoryModel.result &&
          //     groupAccessChatHistoryModel.response == 204) {
          //   yield GroupChatHistoryNoDataState(groupAccessChatHistoryModel);
          // }
        }
      } on Exception catch (e) {
        yield GroupChatHistoryErrorState();
      }
    }

    if (event is FetchGroupParticipantsEvent) {
      try {
        yield FetchGroupParticipantsLoadingState();
        var data = <String, dynamic>{
          'groupName': '${event.groupName}',
        };
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          final estimatedResult = await ChatRepository()
              .accessGroupParticipants(
                  FetchGroupParticipantEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 200) {
              yield FetchGroupParticipantsSuccessState(
                  ListOfGroupParticipantsModel(
                      response: estimatedResult.getData!.response!,
                      result: estimatedResult.getData!.result!,
                      data: estimatedResult.getData!.data!
                          .map(
                              (e) => GroupParticipantsData.fromJson(e.toJson()))
                          .toList()));
            } else if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 204) {
              yield FetchGroupParticipantsNoDataState(
                  ListOfGroupParticipantsModel(
                      response: estimatedResult.getData!.response!,
                      result: estimatedResult.getData!.result!,
                      data: estimatedResult.getData?.data!
                              .map((e) =>
                                  GroupParticipantsData.fromJson(e.toJson()))
                              .toList() ??
                          []));
            }
          } else {
            yield FetchGroupParticipantsErrorState(
                exception: estimatedResult.getException!.errorMessage);
          }
          // final listOfGroupParticipantsModel =
          //     await AccessParticipantsGroup().callApi(url, data);
          // if (listOfGroupParticipantsModel!.result &&
          //     listOfGroupParticipantsModel.response == 200) {
          //   yield FetchGroupParticipantsSuccessState(
          //       listOfGroupParticipantsModel);
          // }
          // if (listOfGroupParticipantsModel.result &&
          //     listOfGroupParticipantsModel.response == 204) {
          //   yield FetchGroupParticipantsNoDataState(
          //       listOfGroupParticipantsModel);
          // }
        } else {
          yield FetchGroupParticipantsErrorState(
              exception: Exception('Internet not available'));
        }
      } on Exception catch (e) {
        yield FetchGroupParticipantsErrorState(exception: e);
      }
    }

    if (event is SendGroupMessageEvent) {
      try {
        var data = {
          'groupName': '${event.maskedGroupName}',
          'message': '${event.message}',
          'senderUserName': '${event.senderUserName}',
        };

        var dbData = <String, dynamic>{
          'GroupName': '${event.maskedGroupName}',
          'Message': '${event.message}',
          'DateSent': DateTime.now().toIso8601String(),
          'FromUserName': '${event.senderUserName}',
          'IsSent': 0,
        };
        dbData['MessageKey'] = dbData['FromUserName'] + dbData['DateSent'];

        var id = await dbHelper.insertGroupChatDetail(dbData);
        // yield GroupChatDatabaseLoadedState(
        //     AccessSendGroupModel(result: true, message: messageData));
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          // String url = Constants.chatUrl + 'AccessSendGroup';
          final estimatedResult = await ChatRepository()
              .accessSendGroup(SendGroupMessageEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result!) {
              yield SendGroupMessageSuccessState(AccessSendGroupModel(
                  result: estimatedResult.getData!.result!,
                  groupName: estimatedResult.getData!.groupName!,
                  senderUserName: estimatedResult.getData!.senderUserName!,
                  message: estimatedResult.getData!.message!));
              //Mark as sent, set IsSent to 1
              dbHelper.updateGroupChatDetail({'id': id, 'IsSent': 1});
            }
          } else if (estimatedResult.hasException) {
            yield SendGroupMessageErrorState();
          }
          // final accessSendGroupModel =
          //     await AccessSendGroup().callApi(url, data);
          // if (accessSendGroupModel!.result) {
          //   yield SendGroupMessageSuccessState(accessSendGroupModel);
          //   //Mark as sent, set IsSent to 1
          //   dbHelper.updateGroupChatDetail({'id': id, 'IsSent': 1});
          // }
        }
      } on Exception catch (e) {
        print(e);
        yield SendGroupMessageErrorState();
      }
    }

    if (event is GroupListingEvent) {
      try {
        var data = <String, dynamic>{'UserID': '${event.userId}'};
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          var url = '${Constants.baseUrl}AccessGetMyGroupList';
          final estimatedResult = await ChatRepository()
              .accessGetMyGroupList(GroupListingEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.data!.isNotEmpty) {
              yield GroupListingSuccessState(GroupListModel(
                  response: estimatedResult.getData!.response!,
                  result: estimatedResult.getData!.result!,
                  data: estimatedResult.getData!.data != null
                      ? estimatedResult.getData!.data!
                          .map((e) => Data.fromJson(e.toJson()))
                          .toList()
                      : []));
            } else {
              yield GroupChatSearchEmptyState();
            }
          } else {
            yield GroupListingErrorState();
          }
          // final groupListModel = await AccessGroupListing().callApi(url, data);
          // if (groupListModel!.result) {
          //   yield GroupListingSuccessState(groupListModel);
          // }
        }
      } on Exception catch (e) {
        print(e);
        yield GroupListingErrorState();
      }
    }

    if (event is GroupRemoveEvent) {
      try {
        var data = {'groupName': '${event.groupName}'};
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          final estimatedResult = await ChatRepository()
              .accessDeleteChatGroup(GroupRemoveEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 201) {
              yield GroupRemoveSuccessState(GroupRemoveModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                message: estimatedResult.getData!.message!,
              ));
            } else if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 300) {
              yield GroupRemoveDoesNotExistState(GroupRemoveModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                message: estimatedResult.getData!.message!,
              ));
            }
          } else {
            yield GroupRemoveErrorState();
          }
          // final groupRemoveModel = await AccessGroupRemove().callApi(url, data);
          // if (groupRemoveModel!.result && groupRemoveModel.response == 201) {
          //   yield GroupRemoveSuccessState(groupRemoveModel);
          // } else if (groupRemoveModel.result &&
          //     groupRemoveModel.response == 300) {
          //   yield GroupRemoveDoesNotExistState(groupRemoveModel);
          // }
        }
      } on Exception catch (e) {
        print(e);
        yield GroupRemoveErrorState();
      }
    }

    if (event is AddGroupParticipantEvent) {
      try {
        yield AddGroupParticipantLoadingState();
        var data = {
          'groupName': '${event.groupName}',
          'MembersIDs': '${event.memberIds}'
        };
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          final estimatedResult = await ChatRepository().accessAddParticipant(
              AddGroupParticipantEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 200) {
              yield AddGroupParticipantSuccessState();
            } else if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 204) {
              yield AddGroupParticipantFailureState();
            }
          } else {
            yield AddGroupParticipantErrorState(
                exception: estimatedResult.getException!.errorMessage);
          }
          // final addGroupParticipantModel =
          //     await AddGroupParticipant().callApi(url, data);
          // if (addGroupParticipantModel!.result &&
          //     addGroupParticipantModel.response == 200) {
          //   yield AddGroupParticipantSuccessState();
          //   // addGroupParticipantModel);
          // }
          // if (addGroupParticipantModel.result &&
          //     addGroupParticipantModel.response == 204) {
          //   yield AddGroupParticipantFailureState();
          // }
        } else {
          yield AddGroupParticipantFailureState();
        }
      } on Exception catch (e) {
        yield AddGroupParticipantErrorState(exception: e);
      }
    }

    if (event is RemoveGroupParticipantEvent) {
      try {
        yield RemoveGroupParticipantLoadingState();
        var data = {
          'groupName': '${event.groupName}',
          'MembersIDs': '${event.memberIds}'
        };
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          final estimatedResult = await ChatRepository()
              .accessRemoveParticipant(
                  RemoveGroupParticipantEventRequest.fromJson(data));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 200) {
              yield RemoveGroupParticipantSuccessState(index: event.index);
            } else if (estimatedResult.getData!.result! &&
                estimatedResult.getData!.response == 204) {
              yield RemoveGroupParticipantFailureState();
            }
          } else {
            yield RemoveGroupParticipantErrorState(
                exception: estimatedResult.getException!.errorMessage);
          }
          // final removeGroupParticipantModel =
          //     await RemoveGroupParticipant().callApi(url, data);
          // if (removeGroupParticipantModel!.result &&
          //     removeGroupParticipantModel.response == 200) {
          //   yield RemoveGroupParticipantSuccessState(index: event.index);
          //   // RemoveGroupParticipantModel);
          // }
          // if (removeGroupParticipantModel.result &&
          //     removeGroupParticipantModel.response == 204) {
          //   yield RemoveGroupParticipantFailureState();
          // }
        } else {
          yield RemoveGroupParticipantFailureState();
        }
      } on Exception catch (e) {
        yield RemoveGroupParticipantErrorState(exception: e);
      }
    }
  }
}
