import 'package:equatable/equatable.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/models/get_events.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/models/send_event_model.dart';

import '../../../../repository/calendar/model/get_event_detail_by_user_id_and_event_id_result.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarErrorState extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarDeleteErrorState extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoadingState extends CalendarState {
  @override
  List<Object> get props => [];
}

class CreatedCalendarEventSuccessState extends CalendarState {
  final AccessCalendarEventModel dataModel;
  CreatedCalendarEventSuccessState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class EditCalendarEventSuccessState extends CalendarState {
  final AccessCalendarEventModel dataModel;
  EditCalendarEventSuccessState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class GetCalendarEventSuccessState extends CalendarState {
  final AccessGetCalendarEventModel dataModel;

  GetCalendarEventSuccessState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class GetCalendarEventDetailSuccessState extends CalendarState {
  final GetEventDetailByUserIdAndEventIdResult dataModel;

  GetCalendarEventDetailSuccessState(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}


class DeleteCalendarState extends CalendarState {

  @override
  List<Object> get props => [];
}

class DeleteCalendarSuccessState extends CalendarState {

  @override
  List<Object> get props => [];
}




