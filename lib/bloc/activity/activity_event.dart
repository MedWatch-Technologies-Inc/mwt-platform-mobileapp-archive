import 'package:health_gauge/repository/activity_tracker/request/store_recognition_activity_request.dart';

abstract class ActivityEvent {}

class SendActivityDataEvent extends ActivityEvent {
  Map<String, dynamic> request;
  String userId;
  String date;
  StoreRecognitionActivityRequest? reqObject;

  SendActivityDataEvent(
      {required this.request,
      required this.userId,
      required this.date,
      this.reqObject});
}

class GetActivityDataEvent extends ActivityEvent {
  String userId;

  GetActivityDataEvent({required this.userId});
}
