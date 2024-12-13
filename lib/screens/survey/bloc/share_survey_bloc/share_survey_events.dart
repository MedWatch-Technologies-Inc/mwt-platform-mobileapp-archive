import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart'
as userContact;

import '../../model/surveys.dart';

abstract class ShareSurveyEvent{
  const ShareSurveyEvent();
}


class LoadingContactList extends ShareSurveyEvent {
  final int? userId;
  const LoadingContactList({required this.userId});
  @override
  List<Object> get props => [];
}

class MakeShareSurveyEvent extends ShareSurveyEvent {
  final List<userContact.UserData>? contactData;
  final Data surveyDetail;
  const MakeShareSurveyEvent({required this.contactData, required this.surveyDetail});
  @override
  List<Object> get props => [];
}

