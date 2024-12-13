import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/RepositoryDB/email_data.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/repository/contact/contact_repository.dart';
import 'package:health_gauge/repository/contact/request/load_contact_list_request.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';

class ComposeBloc extends Bloc<InboxEvents, InboxState> {
  final draftsRepo = EmailData();
  final dbHelper = DatabaseHelper.instance;

  ComposeBloc() : super(InitialSearchState());

  @override
  Stream<InboxState> mapEventToState(InboxEvents event) async* {
    yield LoadingSearchState();
    if (event is AddDrafts) {
      try {
        var result = draftsRepo.insertDraft(event.draft!);
        yield DraftsAddSucessState();
      }  on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }
    if (event is LoadContactList) {
      print('LoadContactList');
      var date = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      if (preferences?.getString(Constants.synchronizationKey) != null) {
        var storedDate = preferences!.getString(Constants.synchronizationKey)!;
        date = DateTime.parse(storedDate);
      }
      dbHelper.database;
      var dbResult = await dbHelper.getContactsList(event.userId!);
      yield LoadedContactList(
          response: UserListModel(data: dbResult, response: 200, result: true));
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
              for (var v in result.data!) {
                v.isRejected ??= false;
                await dbHelper.insertContactsData(v.toJsonToInsertInDb(
                    v.isAccepted! ? 1 : 0, v.isRejected! ? 1 : 0, 0));
              }
            } else {
              for (var j = 0; j < result.data!.length; j++) {
                var isInList = false;
                for (var i = 0; i < dbResult.length; i++) {
                  if (dbResult[i].contactID == result.data![j].contactID) {
                    isInList = true;
                    break;
                  }
                }
                if (!isInList) {
                  await dbHelper.insertContactsData(result.data![j]
                      .toJsonToInsertInDb(result.data![j].isAccepted! ? 1 : 0,
                          result.data![j].isRejected! ? 1 : 0, 0));
                }
              }
            }
          } else {}
        }
        dbResult = await dbHelper.getContactsList(event.userId!);

        yield LoadedContactList(
            response:
                UserListModel(data: dbResult, response: 200, result: true));
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }
  }
}
