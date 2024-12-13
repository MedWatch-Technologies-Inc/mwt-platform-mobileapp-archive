import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/services/bloc/bloc_common_state.dart';

class ActivityHistoryState extends ApiState {
  ActivityHistoryState.loading(String? message) : super.loading(message);

  ActivityHistoryState.completed(data) : super.completed(data);

  ActivityHistoryState.error(error) : super.error(error);
}

class ActivityHistoryPageState extends ActivityHistoryState {
  List<ActivityModel>? model;
  bool isFirstFetch = false;

  ActivityHistoryPageState.completed(data, {required this.model})
      : super.completed(data);

  ActivityHistoryPageState.loading(data,
      {this.model, this.isFirstFetch = false})
      : super.loading(data);

  ActivityHistoryPageState.error(data, {required this.model})
      : super.error(data);
}

class ActivityHistoryInitialState extends ActivityHistoryState {
  ActivityHistoryInitialState.loading(String? message) : super.loading(message);
}

// class HistoryPageLoadedState extends ActivityHistoryState {
//   final List<ActivityModel>? model;
//
//   const HistoryPageLoadedState({this.model});
// }
