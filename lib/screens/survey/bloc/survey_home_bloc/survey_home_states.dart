import 'package:equatable/equatable.dart';

abstract class SurveyHomeStates extends Equatable{
  const SurveyHomeStates();
}

class ChangeHomeScreenWidget extends SurveyHomeStates{
  final String screenName;
  const ChangeHomeScreenWidget(this.screenName);
  @override
  List<Object?> get props => [screenName];
}