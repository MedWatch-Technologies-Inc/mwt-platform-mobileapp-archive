import 'package:health_gauge/apis/api_wrapper/api_wrapper.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/models/get_events.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/models/send_event_model.dart';
import 'package:health_gauge/services/logging/logging_service.dart';

class AddCalendarEventApi extends ApiCall {
  Future<AccessCalendarEventModel> callApi(url, jsonData) async {
    var response = await postData(url, jsonData);
    if (response.containsKey('Result') && response['Result']) {
      AccessCalendarEventModel getDataModel =
          AccessCalendarEventModel.fromJson(response);
      return getDataModel;
    } else {

      throw Exception();
    }
  }
}

// class GetCalendarEventApi extends ApiCall {
//   Future<AccessGetCalendarEventModel> callApi(url, jsonData) async {
//
//     try {
//       var response = await postData(url, jsonData);
//       if (response.containsKey('Result') && response['Result']) {
//         AccessGetCalendarEventModel getDataModel = AccessGetCalendarEventModel.fromJson(response);
//         print('abc');
//         return getDataModel;
//       } else {
//         throw Exception();
//       }
//     } on Exception catch (e) {
//       LoggingService().printLog(message: e.toString(), tag: 'Class GetCalendarEventApi');
//       throw Exception();
//     }
//
//
//   }
// }
