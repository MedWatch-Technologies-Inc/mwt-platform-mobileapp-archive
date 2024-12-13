import 'package:health_gauge/services/bloc/bloc_common_state.dart';

class ActivityState extends ApiState {
  ActivityState.completed(data) : super.completed(data);

  ActivityState.loading(data) : super.loading(data);

  ActivityState.error(data) : super.error(data);
}

class ActivityInitialState extends ActivityState {
  ActivityInitialState.loading(data) : super.loading(data);
}

class SendActivityDataState extends ActivityState {
  SendActivityDataState.completed(data) : super.completed(data);

  SendActivityDataState.error(data) : super.error(data);
}

class GetActivityDataState extends ActivityState {
  GetActivityDataState.completed(data) : super.completed(data);

  GetActivityDataState.error(data) : super.error(data);
}
