
import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class CreateCalendarEvent extends CalendarEvent {
  final String? information;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final int? userId;
  final String? location;
  final String? url;
  final int? allDayCheck;
  final int? alertId;
  final int? repeatId;
  final List? invitedIds;
  final String? notes;
  final String? color;
  final String? startDateTimeStamp;
  final String? endDateTimeStamp;

  CreateCalendarEvent({
    this.information,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.userId,
    this.location,
    this.url,
    this.allDayCheck,
    this.alertId,
    this.repeatId,
    this.invitedIds,
    this.notes,
    this.color,
    this.endDateTimeStamp,
    this.startDateTimeStamp,
  });
  @override
  List<Object> get props => [];
}

class GetCalendarEvent extends CalendarEvent {
  final int userId;

  GetCalendarEvent(this.userId);

  @override
  List<Object> get props => [];
}



class DeleteCalendarEvent extends CalendarEvent {
  final int eventId;

  DeleteCalendarEvent(this.eventId);

  @override
  List<Object> get props => [];
}


class GetCalendarEventDetails extends CalendarEvent {
  final int userId;
  final int eventId;
  GetCalendarEventDetails({required this.userId, required this.eventId});

  @override
  List<Object> get props => [];
}

class EditCalendarEvent extends CalendarEvent {
  final String? information;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final int? userId;
  final String? location;
  final String? url;
  final int? allDayCheck;
  final int? alertId;
  final int? repeatId;
  final List? invitedIds;
  final String? notes;
  final String? color;
  final String? startDateTimeStamp;
  final String? endDateTimeStamp;
  final int? reminderId;

  EditCalendarEvent({
    this.information,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.userId,
    this.location,
    this.url,
    this.allDayCheck,
    this.alertId,
    this.repeatId,
    this.invitedIds,
    this.notes,
    this.color,
    this.endDateTimeStamp,
    this.startDateTimeStamp,
    this.reminderId
  });
  @override
  List<Object> get props => [];
}