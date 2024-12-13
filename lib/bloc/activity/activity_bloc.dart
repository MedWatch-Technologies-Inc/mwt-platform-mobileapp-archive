import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_event.dart';
import 'package:health_gauge/bloc/activity/activity_state.dart';
import 'package:health_gauge/models/offline_api_request.dart';
import 'package:health_gauge/repository/activity_tracker/activity_tracker_repository.dart';
import 'package:health_gauge/repository/activity_tracker/request/store_recognition_activity_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/services/bloc/app_error.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitialState.loading(''));

  @override
  Stream<ActivityState> mapEventToState(ActivityEvent event) async* {
    if (event is SendActivityDataEvent) {
      if (!await Constants.isInternetAvailable()) {
        var databaseHelper = DatabaseHelper.instance;
        var request = OfflineAPIRequest(
            reqData: event.request, url: ApiConstants.storeRecognitionActivity);
        databaseHelper.addUpdateOfflineAPIRequest(request);
        return;
      }
      try {
        var result = await ActivityTrackerRepository().storeRecognitionActivity(
            StoreRecognitionActivityRequest.fromJson(event.request));
        if (result.hasData) {
          yield SendActivityDataState.completed(result.getData!);
        } else {
          yield SendActivityDataState.error(
              AppError.defaultError(displayMessage: 'Error Sending data!'));
        }
        var val = false;
        await FirebaseFirestore.instance
            .collection('${event.userId}')
            .doc('${event.date}')
            .set(event.request)
            .whenComplete(() {})
            .then((value) {
          val = true;
        }).catchError((onError) {
          print(onError);
          val = false;
        });
        // if (val) {
        //   yield SendActivityDataState.completed(val);
        // } else {
        //   yield SendActivityDataState.error(
        //       AppError.defaultError(displayMessage: 'Error Sending data!'));
        // }
      } catch (e) {
        LoggingService().logMessage(e.toString());
        yield SendActivityDataState.error(
            AppError.defaultError(displayMessage: 'Error Sending data!'));
      }
    } else if (event is GetActivityDataEvent) {
      try {
        Query query = FirebaseFirestore.instance
            .collection('${event.userId}')
            .where('endTime', isNotEqualTo: null)
            .orderBy('endTime', descending: true);
        await query
            .get()
            .then((value) {
              var list = value.docs
                  .map((e) =>
                      ActivityModel.fromJson(e.data() as Map<String, dynamic>))
                  .toList();
              var index = list.indexWhere((element) => element.endTime == null);
              var distinctList = <ActivityModel>[];

              for (var element in list) {
                var isExists =
                    distinctList.any((e) => e.endTime == element.endTime);
                if (!isExists) {
                  distinctList.add(element);
                }
              }
              list = distinctList;
            })
            .catchError((onError) {})
            .whenComplete(() {});
      } on Exception catch (e) {}
    }
  }
}
