import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_history/event/activity_history_event.dart';
import 'package:health_gauge/bloc/activity/activity_history/state/activity_history_state.dart';
import 'package:health_gauge/repository/activity_tracker/activity_tracker_repository.dart';
import 'package:health_gauge/repository/activity_tracker/request/get_recognition_activity_list_request.dart';
import 'package:health_gauge/resources/db/app_preferences_handler.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/services/bloc/app_error.dart';
import 'package:health_gauge/services/bloc/bloc_common_state.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';

class ActivityHistoryBloc
    extends Bloc<ActivityHistoryEvent, ActivityHistoryState> {
  bool isInternetAvailable = false;
  int pageSize = 3;
  int pageIndex = 1;
  DateTime toDate = DateTime.now();
  DateTime fromDate =
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
  bool allFetched = false;
  AppPreferencesHandler preferenceHandler = AppPreferencesHandler();

  ActivityHistoryBloc() : super(ActivityHistoryInitialState.loading(''));

  @override
  Stream<ActivityHistoryState> mapEventToState(
      ActivityHistoryEvent event) async* {
    // Future<List<ActivityModel>> getHistoryData() async {
    //   var historyList = <ActivityModel>[];
    //   var lstDocument;
    //   try {
    //     historyList.clear();
    //     var userId = preferences!.getString(Constants.prefUserIdKeyInt);
    //     Query query = FirebaseFirestore.instance
    //         .collection('$userId')
    //         .where('endTime', isNotEqualTo: null);
    //     try {
    //       historyList.removeWhere((element) => element.id == null);
    //       for (var element in historyList) {
    //         query.where('Id', isNotEqualTo: element.id);
    //       }
    //     } catch (e) {
    //       print('Exception at getHistoryData $e');
    //     }
    //     query.orderBy('endTime', descending: true);
    //     if (lstDocument != null) {
    //       query = FirebaseFirestore.instance
    //           .collection('$userId')
    //           .where('endTime', isNotEqualTo: null)
    //           .orderBy('endTime', descending: true);
    //     }
    //     await query.get().then((value) {
    //       if (value.docs != null) {
    //         var list = value.docs.map((e) =>
    //             ActivityModel.fromJson(e.data() as Map<String, dynamic>));
    //         historyList.addAll(list);
    //         var index =
    //             historyList.indexWhere((element) => element.endTime == null);
    //         if (index > -1) {
    //           historyList.removeAt(index);
    //         }
    //         if (value.docs.isNotEmpty) {
    //           lstDocument = value.docs.last;
    //         }
    //       }
    //       var distinctList = <ActivityModel>[];
    //
    //       for (var element in historyList) {
    //         var isExists =
    //             distinctList.any((e) => e.endTime == element.endTime);
    //         if (!isExists) {
    //           distinctList.add(element);
    //         }
    //       }
    //       historyList = distinctList;
    //     }).catchError((onError) {
    //       print('Exception at getHistoryData $onError');
    //     });
    //   } catch (e) {
    //     historyList = [];
    //     print(e);
    //   }
    //   return historyList;
    // }
    if (preferences?.getString(Constants.synchronizationKey) != null) {
      var storedDate = preferences!.getString(Constants.synchronizationKey)!;
      fromDate = DateTime.parse(storedDate);
    }

    if (event is GetHistoryListEvent) {
      final currentState = state;
      var oldActivity = <ActivityModel>[];
      if (currentState is ActivityHistoryPageState) {
        if (currentState.status == Status.completed) {
          oldActivity = currentState.model ?? [];
        }
      }
      yield ActivityHistoryPageState.loading('',
          model: oldActivity, isFirstFetch: pageIndex == 1);

      var result = await ActivityTrackerRepository().getRecognitionActivityList(
          GetRecognitionActivityListRequest(
              userID: int.parse(globalUser!.userId!),
          pageIndex: pageIndex,
          pageSize: pageSize,
          fromDate: DateFormat(DateUtil.yyyyMMdd).format(fromDate),
          toDate: DateFormat(DateUtil.yyyyMMdd).format(toDate),
          fromDateStamp: fromDate.millisecondsSinceEpoch.toString(),
          toDateStamp: toDate.millisecondsSinceEpoch.toString(),
          iDs: []));
      if (result.hasData) {
        pageIndex += 1;
        var mod = result.getData!.data!.map(ActivityModel.mapper).toList();
        // sorting location data for all items
        if (mod.isNotEmpty) {
          for (var i = 0; i < mod.length; i++) {
            var model = mod[i];
            if (model.locationList != null && model.locationList!.isNotEmpty) {
              model.locationList!
                  .sort((a, b) => a.time!.toInt().compareTo(b.time!.toInt()));
            }
          }
        }
        if (mod.length < pageSize) {
          allFetched = true;
        }
        oldActivity.addAll(mod);
        yield ActivityHistoryPageState.completed('Completed',
            model: oldActivity);
      } else {
        yield ActivityHistoryPageState.error(AppError.defaultError(),
            model: oldActivity);
      }
      // var model = await getHistoryData();
      // yield ActivityHistoryPageState.completed('Completed', model: model);
    }
  }
}
