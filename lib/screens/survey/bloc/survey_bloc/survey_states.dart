import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/create_and_save_survey_response_model.dart';
import '../../model/create_survey_model.dart' as create_survey;
import '../../model/survey_detail.dart';
import '../../model/surveys.dart';

///Use [SurveyState] class if there are no [props]
///because if there is no props change in
///state the [BlocBuilder] will run only once
///and on next state emit it will consider it same as previous.


abstract class SurveyState {
  const SurveyState();
}

///Use [SurveyStateEquatable] this class if
///you have [props] and they change every
///time with new state.

abstract class SurveyStateEquatable extends Equatable implements SurveyState{
  const SurveyStateEquatable();
}

class InitialSurveyState extends SurveyState{
  const InitialSurveyState();

}

class SurveyCreationSuccessState extends SurveyStateEquatable{
  final CreateAndSaveSurveyResponseModel data;
  const SurveyCreationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class SurveyErrorState extends SurveyState{
  const SurveyErrorState();
}


class SurveyDetailErrorState extends SurveyState{
  const SurveyDetailErrorState();
}
class SurveyDetailEmptyState extends SurveyState{
  const SurveyDetailEmptyState();
}

class NoSurveyFoundState extends SurveyState{
  const NoSurveyFoundState();
}

class LoadSurveyListByUserIdState extends SurveyStateEquatable{
 final Surveys data;
  const LoadSurveyListByUserIdState(this.data);

  @override
  List<Object?> get props => [data,data.toJson()];
}

class LoadSurveyDetailBySurveyIdState extends SurveyStateEquatable{
  final SurveyDetail data;
  const LoadSurveyDetailBySurveyIdState(this.data);

  @override
  List<Object?> get props => [data];
}


class LoadSurveyListSharedWithMeState extends SurveyStateEquatable{
 final Surveys data;
  const LoadSurveyListSharedWithMeState(this.data);

  @override
  List<Object?> get props => [data];
}
class NoDataShareWithMeSate extends  SurveyStateEquatable{

  const NoDataShareWithMeSate();

  @override
  List<Object?> get props => [];
}



class LoadingSurveyState extends SurveyState{
  const LoadingSurveyState();
}

class AddedSurveyNameState extends SurveyState{
  const AddedSurveyNameState();

}

class AddedSurveyQuestionState extends SurveyStateEquatable{
  final List<create_survey.LstQuestion> questions;
  const AddedSurveyQuestionState(this.questions);
  @override
  List<Object?> get props => [questions];
}

class UpdatedSurveyQuestionState extends SurveyState{
  const UpdatedSurveyQuestionState();
}

class UpdatedSurveyStartDateState extends SurveyState{
  const UpdatedSurveyStartDateState();
}
class UpdatedSurveyEndDateState extends SurveyState{
  const UpdatedSurveyEndDateState();
}

class SavedSurveyQuestionDataState extends SurveyState{
  const SavedSurveyQuestionDataState();
}

class RemovedSurveyQuestionState extends SurveyStateEquatable{
  final int queLength;
  const RemovedSurveyQuestionState(this.queLength);

  @override
  List<Object?> get props => [queLength];
}


// States for navigation while creating survey.
abstract class CreateSurveyNavigationState extends SurveyState{
  const CreateSurveyNavigationState();
}

class MoveToSurveyNameScreenState extends CreateSurveyNavigationState{
  const MoveToSurveyNameScreenState();
}

class MoveToAddSurveyQuestionScreenState extends CreateSurveyNavigationState{

  const MoveToAddSurveyQuestionScreenState();

}

class MoveToViewSurveySummeryScreenState extends CreateSurveyNavigationState{
  const MoveToViewSurveySummeryScreenState();
}
