import 'package:health_gauge/models/calendar_models/cal_db_model.dart';
import 'package:health_gauge/models/calendar_models/get_event_list_data_model.dart';
import 'package:health_gauge/utils/database_helper.dart';

class CalendarDataRepo {
  final dbHelper = DatabaseHelper.instance;


  Future<List<CalendarData>> getCalendarEventList(int userId) async {
    List<CalendarData> eventList = <CalendarData>[];
    eventList = await dbHelper.getCalendarList(userId);
    return eventList;
  }


  Future insertCalendarData(CalendarDbData data) =>
    dbHelper.insertCalendarData(data.toJsonToInsertInDb());


  Future<int> deleteCalendarData(int userId,int eventId) async{
    int x = await dbHelper.deleteCalendarEvent(userId, eventId);
    return x;
  }

}

