
abstract class SurveyHomeEvents{
  const SurveyHomeEvents();
}
class MoveToCreateSurveyEvent extends SurveyHomeEvents{
  const MoveToCreateSurveyEvent();
}

class MoveToSharedSurveyEvent extends SurveyHomeEvents{
  const MoveToSharedSurveyEvent();
}

class MoveToSavedSurveyEvent extends SurveyHomeEvents{
  const MoveToSavedSurveyEvent();
}