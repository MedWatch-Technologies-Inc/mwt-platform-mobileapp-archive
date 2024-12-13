import 'package:equatable/equatable.dart';

class AppBodyState extends Equatable {
  const AppBodyState();

  @override
  List<Object> get props => [];
}

class AppBodyIdealState extends AppBodyState {
  @override
  List<Object> get props => [];
}

class MainInitServicesState extends AppBodyState {
  final DateTime dateTime;

  const MainInitServicesState(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class ShowOnBoardingState extends AppBodyState {
  @override
  List<Object> get props => [];
}

class ShowHomeState extends AppBodyState {
  @override
  List<Object> get props => [];
}

class AuthenticationState extends AppBodyState {
  @override
  List<Object> get props => [];
}

class FirebaseCredentialsFetchedState extends AppBodyState {
  @override
  List<Object> get props => [];
}