import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/repository/survey/survey_repository.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/screens/survey/model/create_survey_model.dart';

import '../../../../utils/gloabals.dart';


class SurveyBloc extends Bloc<SurveyEvent,SurveyState>{
  late SurveyRepository _repository;
  CreateSurveyModel? _createSurveyModel;

  CreateSurveyModel? get surveyModel => _createSurveyModel;

  set surveyModel(CreateSurveyModel? value){
    _createSurveyModel = value;
  }
  SurveyBloc() : super(InitialSurveyState()){
    _repository = SurveyRepository();
    on<FetchSurveyListByUserIdEvent>(_getSurveyListByUserId);
    on<FetchSurveyListSharedWithMe>(_getSurveyListSharedWithMe);
    on<GetSurveyDetailBySurveyIDEvent>(_getSurveyDetailBySurveyId);
    on<AddSurveyEvents>(_createSurvey);
    on<CreateSurveyNavigationEvents>(_createSurveyNavigation);
  }

  void _createSurveyNavigation(CreateSurveyNavigationEvents event,Emitter<SurveyState> emit){
    if(event is MoveToAddSurveyQuestionScreenEvent){
      emit(MoveToAddSurveyQuestionScreenState());
    }else if(event is MoveToViewSurveySummeryScreenEvent){
      emit(MoveToViewSurveySummeryScreenState());
    }else if(event is MoveToSurveyNameScreenEvent){
      emit(MoveToSurveyNameScreenState());
    }
  }
  void _getSurveyListByUserId(FetchSurveyListByUserIdEvent event,Emitter emit)async{
    emit(LoadingSurveyState());
    var response = await _repository.getSurveyListByUserId(event.pageNumber);
    if(response.hasData && response.getData!.response==204){
      print('response.getData!.response ${response.getData!.response}');
      emit(NoSurveyFoundState());
    }
      if(response.hasData && (response.getData!.response==200)){
        if(response.getData != null){
          emit(LoadSurveyListByUserIdState(response.getData!));
        }
      }else{
        emit(SurveyErrorState());
      }


  }

  void _getSurveyDetailBySurveyId(GetSurveyDetailBySurveyIDEvent event,Emitter emit)async{
    emit(LoadingSurveyState());
    try {
      var response = await _repository.getSurveyDetailBySurveyID(
          event.surveyId);
      if (response.hasData && (response.getData!.response == 200 ||
          response.getData!.response == 204)) {
        if(response.getData!.data.lstQuestion.length>0) {
          emit(LoadSurveyDetailBySurveyIdState(response.getData!));
        }
        else{
          emit(SurveyDetailEmptyState());
        }
      } else {
        emit(SurveyDetailErrorState());
      }
    }
    catch(e){
      emit(SurveyDetailErrorState());
    }
  }

  void _getSurveyListSharedWithMe(FetchSurveyListSharedWithMe event,Emitter emit)async{
    emit(LoadingSurveyState());
    var response = await _repository.getSurveySharedWithMe(event.pageNumber);
    if(response.hasData && response.getData!.response == 204){
      print("data_sharedWithme");
      emit(NoSurveyFoundState());
    }else{
      if(response.hasData && (response.getData!.response==200)){
        if(response.getData != null){
          emit(LoadSurveyListSharedWithMeState(response.getData!));
        }
      }else{
        emit(SurveyErrorState());
      }
    }
  }



  void _createSurvey(AddSurveyEvents event,Emitter<SurveyState> emit)async{
    if(event is UpdateSurveyStartDateEvent){
      _createSurveyModel?.startDateTimeStamp = event.startDate.millisecondsSinceEpoch.toString();
      emit(UpdatedSurveyStartDateState());
    }
    else if(event is UpdateSurveyEndDateEvent){
      _createSurveyModel?.endDateTimeStamp = event.endDate.millisecondsSinceEpoch.toString();
      emit(UpdatedSurveyEndDateState());
    }
    else if(event is SetSurveyName){
        if(event.name.isNotEmpty){
          _createSurveyModel!.surveyName = event.name;
        }
      }else if(event is AddQuestionEvent){
        if(_createSurveyModel!.lstQuestion==null){
          _createSurveyModel!.lstQuestion = [];
        }
          _createSurveyModel!.lstQuestion!.add(event.question);
        final state = AddedSurveyQuestionState(List.unmodifiable(_createSurveyModel!.lstQuestion!));
        emit(state);
      }else if(event is RemoveQuestion){
        if( _createSurveyModel!.lstQuestion!.length>1 && event.position < _createSurveyModel!.lstQuestion!.length){
          _createSurveyModel!.lstQuestion!.removeAt(event.position);
        }
        emit(RemovedSurveyQuestionState(_createSurveyModel!.lstQuestion!.length));
      }else if(event is EditQuestionEvent){
        if(_createSurveyModel!.lstQuestion!.isNotEmpty && event.position < _createSurveyModel!.lstQuestion!.length){
          _createSurveyModel!.lstQuestion![event.position] = event.question;
        }
        emit(UpdatedSurveyQuestionState());
      }else if(event is SaveSurveyEvent){
        emit(LoadingSurveyState());
        _createSurveyModel!.fKUserID = int.parse(globalUser!.userId!);
        var response = await _repository.createSurvey(_createSurveyModel!);
        if(response.hasData && response.getData!.response==200){
          emit(SurveyCreationSuccessState(response.getData!));
        }else{
          emit(SurveyErrorState());
        }
        _createSurveyModel=null;
      }else if(event is SaveQuestionDataEvent){
        if(_createSurveyModel!.lstQuestion!.isNotEmpty && event.position < _createSurveyModel!.lstQuestion!.length){
          _createSurveyModel!.lstQuestion![event.position] = event.question;
        }
        emit(SavedSurveyQuestionDataState());
      }

  }

}