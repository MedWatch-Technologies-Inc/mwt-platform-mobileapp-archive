import 'package:equatable/equatable.dart';

abstract class ActivityHistoryEvent extends Equatable {
  const ActivityHistoryEvent();
}

class GetHistoryListEvent extends ActivityHistoryEvent {
  const GetHistoryListEvent();

  @override
  List<Object> get props => [];
}
