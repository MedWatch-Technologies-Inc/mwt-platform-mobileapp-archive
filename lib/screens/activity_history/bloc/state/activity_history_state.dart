import 'package:equatable/equatable.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';

abstract class ActivityHistoryState extends Equatable {
  const ActivityHistoryState();
}

class HistoryPageLoadingState extends ActivityHistoryState {
  @override
  List<Object> get props => [];
}

class HistoryPageLoadedState extends ActivityHistoryState {
  final List<ActivityModel>? model;

  const HistoryPageLoadedState({this.model});

  @override
  List<Object> get props => [model!];
}
