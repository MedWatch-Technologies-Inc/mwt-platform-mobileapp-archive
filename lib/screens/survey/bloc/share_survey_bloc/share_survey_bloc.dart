import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/repository/survey/survey_repository.dart';
import 'package:health_gauge/screens/survey/bloc/share_survey_bloc/share_survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/share_survey_bloc/share_survey_state.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/screens/survey/model/create_survey_model.dart';

import '../../../../models/contact_models/user_list_model.dart';
import '../../../../repository/contact/contact_repository.dart';
import '../../../../repository/contact/request/load_contact_list_request.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/database_helper.dart';
import '../../../../utils/gloabals.dart';

class ShareSurveyBloc extends Bloc<ShareSurveyEvent, ShareSurveyState> {
  late SurveyRepository _repository;
  final dbHelper = DatabaseHelper.instance;
  ShareSurveyBloc() : super(InitialShareSurveyState()){
    _repository = SurveyRepository();
  }

  @override
  Stream<ShareSurveyState> mapEventToState(ShareSurveyEvent event) async* {
    yield LoadingSearchState();
    if (event is LoadingContactList) {
      print('LoadContactList');
      var date = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      if (preferences?.getString(Constants.synchronizationKey) != null) {
        var storedDate = preferences!.getString(Constants.synchronizationKey)!;
        date = DateTime.parse(storedDate);
      }
      dbHelper.database;
      var dbResult = await dbHelper.getContactsList(event.userId!);
      emit(LoadedContactList(
          response:
              UserListModel(data: dbResult, response: 200, result: true)));
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

        emit(LoadedContactList(
            response:
                UserListModel(data: dbResult, response: 200, result: true)));
      }on Exception catch (e) {
        emit(SearchApiErrorState(null));
      }
    }

    if(event is MakeShareSurveyEvent){
      yield LoadingShareSurveyState();

      var map;
      String userList = "";
      for(int i=0;i<event.contactData!.length;i++){
        userList = userList+event.contactData![i].fKReceiverUserID.toString()+',';
      }
      if ((userList != null) && (userList.length > 0)) {
        userList = userList.substring(0, userList.length - 1);
      }
      map = {
        "FKUserID" : int.parse(globalUser!.userId??''),
        "SurveyID" : event.surveyDetail.surveyID ,
        "ShredUserIDList" : userList,
        "PhysicalUrl" :  event.surveyDetail.physicalUrl??'',
        "StartDateTimeStamp" : DateTime.parse(event.surveyDetail.createdDatetime).millisecondsSinceEpoch.toString()
      };
      try {
        var isInternet = await Constants.isInternetAvailable();
        if (isInternet) {
          var response = await _repository.shareSurveyWithContacts(map);
          if (response.hasData && response.getData!.response == 200) {
            yield ShareSurveySucessState();
          } else {
            yield ShareSurveyErrorState();
          }
        }
      }catch (e){
        yield ShareSurveyErrorState();
      }

      }

  }
}
