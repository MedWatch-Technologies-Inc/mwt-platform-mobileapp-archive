import 'package:flutter/cupertino.dart';

import '../../model/create_survey_model.dart';

abstract class SurveyEvent{
  const SurveyEvent();
}

class FetchSurveyListByUserIdEvent extends SurveyEvent{
  final int pageNumber;
  const FetchSurveyListByUserIdEvent({ this.pageNumber = 1});
}
class FetchSurveyListSharedWithMe extends SurveyEvent{
  final int pageNumber;
  const FetchSurveyListSharedWithMe({ this.pageNumber = 1});
}

class GetSurveyDetailBySurveyIDEvent extends SurveyEvent{
  final int surveyId;
  const GetSurveyDetailBySurveyIDEvent(this.surveyId);
}

abstract class AddSurveyEvents extends SurveyEvent{
  const AddSurveyEvents();
}
///Add when the collection of survey data is completed.
class SaveSurveyEvent extends AddSurveyEvents{
  const SaveSurveyEvent();
}
class SetSurveyName extends AddSurveyEvents{
  String name;
  SetSurveyName(this.name);
}

class AddQuestionEvent extends AddSurveyEvents{
  LstQuestion question;
  AddQuestionEvent(this.question);
}

class RemoveQuestion extends AddSurveyEvents{
  int position;
  RemoveQuestion(this.position);
}

class EditQuestionEvent extends AddSurveyEvents{
  int position;
  LstQuestion question;
  EditQuestionEvent(this.position,this.question);
}
class SaveQuestionDataEvent extends AddSurveyEvents{
  int position;
  LstQuestion question;
  SaveQuestionDataEvent(this.position,this.question);
}

class UpdateSurveyStartDateEvent extends AddSurveyEvents{

  final DateTime startDate;
  const UpdateSurveyStartDateEvent(this.startDate);
}

class UpdateSurveyEndDateEvent extends AddSurveyEvents{

 final DateTime endDate;
  const UpdateSurveyEndDateEvent(this.endDate);
}

/// Use [CreateSurveyNavigationEvents] class for navigation of [PageView] in create survey.
abstract class CreateSurveyNavigationEvents extends SurveyEvent{
  const CreateSurveyNavigationEvents();
}

class MoveToSurveyNameScreenEvent extends CreateSurveyNavigationEvents{
  const MoveToSurveyNameScreenEvent();
}

class MoveToAddSurveyQuestionScreenEvent extends CreateSurveyNavigationEvents{
  const MoveToAddSurveyQuestionScreenEvent();
}

class MoveToViewSurveySummeryScreenEvent extends CreateSurveyNavigationEvents{
  const MoveToViewSurveySummeryScreenEvent();
}

