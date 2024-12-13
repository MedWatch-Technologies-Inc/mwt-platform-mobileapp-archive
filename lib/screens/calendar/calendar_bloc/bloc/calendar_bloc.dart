
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/offline_api_request.dart';
import 'package:health_gauge/repository/calendar/calendar_repository.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/ApiWrapper/add_calendar_event_api.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_event.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_state.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  bool isInternetAvailable = false;

  CalendarBloc() : super(CalendarLoadingState());

  bool isEdit = false;


  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if (event is CreateCalendarEvent) {
      try {
        var data = {
          'Information': event.information,
          'StartDate': event.startDate,
          'EndDate': event.endDate,
          'StartTime': event.startTime,
          'EndTime': event.endTime,
          'UserID': event.userId,
          'Location': event.location,
          'url': event.url,
          'AllDayCheck': event.allDayCheck,
          'AlertId': event.alertId,
          'RepeatId': event.repeatId,
          'InvitedIds': event.invitedIds,
          'notes': event.notes,
          'Color': event.color,
          'StartDateTimeStamp': event.startDateTimeStamp,
          'EndDateTimeStamp': event.endDateTimeStamp,
        };
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          var url = Constants.baseUrl + 'CalendarEventData';
          // final result = await CalendarRepository(baseUrl: Constants.baseUrl)
          //     .calendarEventData(CalendarEventDataRequest.fromJson(data));
          final accessCalendarEventModel =
              await AddCalendarEventApi().callApi(url, data);
          if (accessCalendarEventModel.result ?? false) {
            yield CreatedCalendarEventSuccessState(accessCalendarEventModel);
          }
        }
      } on Exception catch (e) {
        yield CalendarErrorState();
      }
    }
    if (event is GetCalendarEvent) {
      try {
        yield CalendarLoadingState();
        Map data = {'UserID': event.userId};
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          var url = Constants.baseUrl + 'GetEventListByUserID';
          final result = await CalendarRepository(baseUrl: Constants.baseUrl)
              .getEventListByUserID(event.userId);
          if (result.hasData) {
            if (result.getData!.result!) {
              yield GetCalendarEventSuccessState(result.getData!);
              // yield GetCalendarEventSuccessState(AccessGetCalendarEventModel(
              //     response: result.getData!.response!,
              //     result: result.getData!.result!,
              //     data: result.getData!.data != null
              //         ? result.getData!.data!
              //             .map((e) => Data.fromJson(e.toJson()))
              //             .toList()
              //         : []));
            } else {
              yield CalendarErrorState();
            }
          } else {
            yield CalendarErrorState();
          }
          // final AccessGetCalendarEventModel accessGetCalendarEventModel =
          //     await GetCalendarEventApi().callApi(url, data);
          // if (accessGetCalendarEventModel.result ?? false) {
          //   yield GetCalendarEventSuccessState(accessGetCalendarEventModel);
          // }
        }
      } on Exception catch (e) {
        print(e);
        yield CalendarErrorState();
      }
    }
    if (event is GetCalendarEventDetails) {
      try {
        yield CalendarLoadingState();
        var data = {'UserID': event.userId, 'EventID': event.eventId};
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          var url = Constants.baseUrl + 'GetEventDetailsByUserIDAndEventID';
          final result = await CalendarRepository()
              .getEventDetailsByUserIDAndEventID(event.userId, event.eventId);
          if (result.hasData) {
            if (result.getData!.result!) {

              yield GetCalendarEventDetailSuccessState(
                  result.getData!);
              // yield GetCalendarEventSuccessState(AccessGetCalendarEventModel(
              //     response: result.getData!.response!,
              //     result: result.getData!.result!,
              //     data: result.getData!.data != null
              //         ? result.getData!.data!
              //             .map((e) => Data.fromJson(e.toJson()))
              //             .toList()
              //         : []));
            } else {
              yield CalendarErrorState();
            }
          } else {
            yield CalendarErrorState();
          }
          // final accessGetCalendarEventModel =
          //     await GetCalendarEventApi().callApi(url, data);
          // if (result.getData!.result ?? false) {

          // }
        }
      } on Exception catch (e) {
        print(e);
        yield CalendarErrorState();
      }
    }

    if (event is EditCalendarEvent) {
      try {
        yield CalendarLoadingState();
        var data = {
          'Information': event.information,
          'StartDate': event.startDate,
          'EndDate': event.endDate,
          'StartTime': event.startTime,
          'EndTime': event.endTime,
          'UserID': event.userId,
          'Location': event.location,
          'url': event.url,
          'AllDayCheck': event.allDayCheck,
          'AlertId': event.alertId,
          'RepeatId': event.repeatId,
          'InvitedIds': event.invitedIds,
          'notes': event.notes,
          'Color': event.color,
          'StartDateTimeStamp': event.startDateTimeStamp,
          'EndDateTimeStamp': event.endDateTimeStamp,
          'SetReminderID':event.reminderId
        };
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
          var url = Constants.baseUrl + 'CalendarEventData';
          // final result = await CalendarRepository(baseUrl: Constants.baseUrl)
          //     .calendarEventData(CalendarEventDataRequest.fromJson(data));
          final accessCalendarEventModel =
          await AddCalendarEventApi().callApi(url, data);
          if (accessCalendarEventModel.result ?? false) {
             isEdit  = !isEdit;
            yield EditCalendarEventSuccessState(accessCalendarEventModel);
          }
        }
      } on Exception catch (e) {
        yield CalendarErrorState();
      }
    }

    if (event is DeleteCalendarEvent) {
      try {
        yield CalendarLoadingState();
        // var data = {
        //   'EventID': event.eventId,
        // };
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable) {
         // var url = Constants.baseUrl + 'DeleteEventByEventID';
          // final result = await CalendarRepository(baseUrl: Constants.baseUrl)
          //     .calendarEventData(CalendarEventDataRequest.fromJson(data));
          final deleteCalendarEventModel =
          await CalendarRepository()
              .deleteEventByEventID(event.eventId.toString());
          if (deleteCalendarEventModel.getData?.result ?? false) {
            yield DeleteCalendarSuccessState();
          }
        }else {
          var databaseHelper = DatabaseHelper.instance;
          var request = OfflineAPIRequest(
              reqData: {}, url:ApiConstants.deleteEventByEventID);
          databaseHelper.addUpdateOfflineAPIRequest(request);
          return;
        }
      } on Exception catch (e) {
        yield CalendarDeleteErrorState();
      }
    }

  }
}
