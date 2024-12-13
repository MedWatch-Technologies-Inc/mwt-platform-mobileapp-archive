import 'package:equatable/equatable.dart';

abstract class AppBodyEvent extends Equatable {
  const AppBodyEvent();
}

class CheckForOnBoardingEvent extends AppBodyEvent {
  @override
  List<Object> get props => [];
}
class OnBoardingCompletedEvent extends AppBodyEvent {
  @override
  List<Object> get props => [];
}

class MainInitServicesEvent extends AppBodyEvent {
  final DateTime dateTime;

  const MainInitServicesEvent(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}


class ShowHomeEvent extends AppBodyEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationEvent extends AppBodyEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends AppBodyEvent {
  @override
  List<Object> get props => [];
}
