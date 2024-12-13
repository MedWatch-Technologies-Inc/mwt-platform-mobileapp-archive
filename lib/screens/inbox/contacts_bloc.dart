import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/delete_user_model.dart';
import 'package:health_gauge/models/contact_models/get_invitation_list_model.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/repository/contact/contact_repository.dart';
import 'package:health_gauge/repository/contact/request/delete_contact_request.dart';
import 'package:health_gauge/repository/contact/request/get_invitation_list_event_request.dart';
import 'package:health_gauge/repository/contact/request/load_contact_list_request.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import '../../utils/gloabals.dart';
import 'inbox_events.dart';
import 'inbox_states.dart';

class ContactsBloc extends Bloc<InboxEvents, InboxState> {
  final dbHelper = DatabaseHelper.instance;

  ContactsBloc() : super(InitialSearchState());

  @override
  Stream<InboxState> mapEventToState(InboxEvents event) async* {
    yield LoadingSearchState();
    if (event is SearchContactListEvents) {
      var userData = event.userData!;
      var query = event.query!;
      var searchResult = <UserData>[];
      for (var data in userData) {
        if (data.firstName!.toLowerCase().contains(query.toLowerCase()) ||
            data.lastName!.toLowerCase().contains(query.toLowerCase()) ||
            '${data.firstName}'.toLowerCase().contains(query.toLowerCase())) {
          searchResult.add(data);
        }
      }

      if (searchResult.isNotEmpty) {
        yield ContactSearchSuccessState(searchResult);
      } else {
        yield ContactSearchEmptyState();
      }
    }
    if (event is LoadContactList) {
      var date = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      if (preferences?.getString(Constants.synchronizationKey) != null) {
        var storedDate = preferences!.getString(Constants.synchronizationKey)!;
        date = DateTime.parse(storedDate);
      }
      dbHelper.database;
      var dbResult = await dbHelper.getContactsList(event.userId!);

      yield LoadedContactList(
          response: UserListModel(
              data: dbResult, response: 200, result: true, isFromDb: true));
      try {
        var isInternet = await Constants.isInternetAvailable();
        if (isInternet) {
          // var result = await GetUserListApi().callApi(event.userId!, 1, 50);
          var map = {
            'LoggedinUserID': event.userId!,
            'PageSize': 1,
            'PageNo': 50
          };
          final estimatedResult =
              await ContactRepository().getContactList(LoadContactListRequest(
            userID: event.userId!.toString(),
            pageIndex: 1,
            pageSize: 50,
            iDs: [],
            // fromDateStamp: date.millisecondsSinceEpoch.toString(),
            // toDateStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          ));
          if (estimatedResult.hasData) {
            var result = UserListModel(
                result: estimatedResult.getData!.result,
                response: estimatedResult.getData!.response,
                data: estimatedResult.getData!.data != null
                    ? estimatedResult.getData!.data!
                        .map((e) => UserData.fromJson(e.toJson()))
                        .toList()
                    : [],
                isFromDb: false);
            if (dbResult.isEmpty) {
              if (result.data != null) {
                var mapData = <String, dynamic>{};
                for (var v in result.data!) {
                  print("Inser Dataaa ${v.toJson().toString()}");
                  v.isRejected ??= false;
                  mapData = v.toJsonToInsertInDb(
                      v.isAccepted! ? 1 : 0, v.isRejected! ? 1 : 0, 0);
                  await dbHelper.insertContactsData(mapData);
                }
      // print("Inser Data ${mapData.toString()}");

              }
            } else {
              if (result.data != null) {
                for (var j = 0; j < result.data!.length; j++) {
                  var isInList = false;
                  for (var i = 0; i < dbResult.length; i++) {
                    if (dbResult[i].contactID == result.data![j].contactID) {
                      dbHelper.updateContactData(
                          dbResult[i].id!,
                          result.data![j].toJsonToInsertInDb(
                              result.data![j].isAccepted! ? 1 : 0,
                              result.data![j].isRejected == null
                                  ? 0
                                  : result.data![j].isRejected!
                                      ? 1
                                      : 0,
                              0));
                      isInList = true;
                      break;
                    }
                  }
                  if (!isInList) {
                    try {
                      await dbHelper.insertContactsData(
                          result.data![j].toJsonToInsertInDb(
                              result.data![j].isAccepted! ? 1 : 0,
                              result.data![j].isRejected == null
                                  ? 0
                                  : result.data![j].isRejected!
                                      ? 1
                                      : 0,
                              0));
                    } on Exception catch (e) {
                      print(
                          'error while inserting contacts in the database $e');
                    }
                  }
                }
              }
            }
          } else {}

          dbResult = await dbHelper.getContactsList(event.userId!);
          yield LoadedContactList(
              response: UserListModel(
                  data: dbResult,
                  response: 200,
                  result: true,
                  isFromDb: false));
        } else {
          yield LoadedContactList(
              response: UserListModel(
                  data: dbResult,
                  response: 200,
                  result: true,
                  isFromDb: false));
        }
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    } else if (event is DeleteContact) {
      dbHelper.database;
      dbHelper.updateContact(event.id!, 1);
      var isInternet = await Constants.isInternetAvailable();
      if (isInternet) {
        try {
          var map = {
            'ContactFromUserID': '${event.fromUserId!}',
            'ContactToUserId': '${event.toUserId!}',
          };
          final estimatedResult = await ContactRepository()
              .deleteContactByUserId(DeleteContactRequest(
            contactToUserId: '${event.toUserId!}',
            contactFromUserID: '${event.fromUserId!}',
          ));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result!) {
              dbHelper.deleteContact(event.id!);
            }
            yield DeletedContact(
              response: DeleteUserModel(
                  result: estimatedResult.getData!.result!,
                  response: estimatedResult.getData!.response!,
                  message: estimatedResult.getData!.message!),
            );
          } else {
            yield SearchApiErrorState(null);
          }
          // var result = await DeleteContactFromGroup().callApi(
          //   event.fromUserId!,
          //   event.toUserId!,
          // );
          // if (result?.result ?? false) dbHelper.deleteContact(event.id!);
          //
          // yield DeletedContact(response: result!);
        } on Exception catch (e) {
          yield SearchApiErrorState(null);
        }
      }
    }
  }
}

class GetInvitationListBloc extends Bloc<InboxEvents, InboxState> {
  GetInvitationListBloc() : super(InitialSearchState());

  @override
  InboxState get initialState => InitialSearchState();

  @override
  Stream<InboxState> mapEventToState(InboxEvents event) async* {
    yield LoadingSearchState();
    if (event is GetInvitationListEvent) {
      try {
        var isInternet = await Constants.isInternetAvailable();
        if (isInternet) {
          var map = {
            'UserID': event.userId!,
            'PageIndex': 1,
            'PageSize': 10,
            'IDs': []
          };
          final estimatedResult = await ContactRepository()
              .getSendingInvitationList(GetInvitationListEventRequest(
            userID: event.userId!,
            pageSize: 10,
            pageIndex: 1,
            iDs: [],
          ));
          if (estimatedResult.hasData) {
            yield GetInvitationListState(
              response: GetInvitationListModel(
                response: estimatedResult.getData!.response!,
                result: estimatedResult.getData!.result!,
                data: estimatedResult.getData!.data != null
                    ? estimatedResult.getData!.data!
                        .map((e) => Data.fromJson(e.toJson()))
                        .toList()
                    : [],
              ),
            );
          } else {
            yield SearchApiErrorState(null);
          }
          // var response = await GetInvitationList().callApi(event.userId!);
          // yield GetInvitationListState(response: response!);
        } else {
          yield NoInternetState();
        }
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }
  }
}
