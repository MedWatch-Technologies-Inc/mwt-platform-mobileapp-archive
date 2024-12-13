import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_home_bloc/survey_home_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_home_bloc/survey_home_states.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class SurveyHomeBloc extends Bloc<SurveyHomeEvents,SurveyHomeStates>{
  SurveyHomeBloc(): super(ChangeHomeScreenWidget(StringLocalization.savedSurvey)){
    on<SurveyHomeEvents>(_surveyHomeScreenNavigation);
  }

  void _surveyHomeScreenNavigation(SurveyHomeEvents events,Emitter<SurveyHomeStates> emit){
    if(events is MoveToCreateSurveyEvent){
      emit(ChangeHomeScreenWidget(StringLocalization.create));
    }else if(events is MoveToSavedSurveyEvent){
      emit(ChangeHomeScreenWidget(StringLocalization.savedSurvey));
    }else if(events is MoveToSharedSurveyEvent){
      emit(ChangeHomeScreenWidget(StringLocalization.sharedSurvey));
    }
  }

}