import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/contact_models/user_list_model.dart';


///Use [SurveyState] class if there are no [props]
///because if there is no props change in
///state the [BlocBuilder] will run only once
///and on next state emit it will consider it same as previous.


abstract class ShareSurveyState {
  const ShareSurveyState();
}

///Use [SurveyStateEquatable] this class if
///you have [props] and they change every
///time with new state.

abstract class ShareSurveyStateEquatable extends Equatable implements ShareSurveyState{
  const ShareSurveyStateEquatable();
}

class InitialShareSurveyState extends ShareSurveyState{
  const InitialShareSurveyState();

}


class LoadedContactList extends ShareSurveyStateEquatable {
  late final UserListModel response;
  LoadedContactList({required this.response});
  @override
  List<Object> get props => [response];
}

class ShareSurveyErrorState extends ShareSurveyState{
  const ShareSurveyErrorState();
}

class LoadingSearchState extends ShareSurveyStateEquatable {
  const LoadingSearchState();

@override
List<Object> get props => [];
}

class ShareSurveySucessState extends ShareSurveyStateEquatable {
  const ShareSurveySucessState();

  @override
  List<Object> get props => [];
}

class LoadingShareSurveyState extends ShareSurveyStateEquatable {
  const LoadingShareSurveyState();

  @override
  List<Object> get props => [];
}

class SearchApiErrorState extends ShareSurveyStateEquatable {
  final dynamic? error;

  const SearchApiErrorState(this.error);

  @override
  List<Object> get props => [error];
}

