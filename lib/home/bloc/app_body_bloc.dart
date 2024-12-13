import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/home/app_service.dart';
import 'package:health_gauge/services/core_util/prefrences_util.dart';

import 'app_body_events.dart';
import 'app_body_states.dart';

enum AppStateEnum { foreground, background }

AppBodyBloc appBodyBloc = AppBodyBloc()..startServiceInitialisation();

class AppBodyBloc extends Bloc<AppBodyEvent, AppBodyState> {
  final String _onBoardingKey = 'MainTutorialScreen';
  AppStateEnum? _appState;
  bool onBoardingStarted = false;

  AppBodyBloc() : super(AppBodyIdealState());

  void startServiceInitialisation() {
    add(MainInitServicesEvent(DateTime.now()));
  }

  void showHome() {
    add(ShowHomeEvent());
  }

  void authenticationFlow() {
    add(AuthenticationEvent());
  }

  void logoutUser() {
    add(LogoutEvent());
  }

  set appStateValue(AppStateEnum appState) {
    _appState = appState;
  }

  AppStateEnum get appStateValue => _appState ?? AppStateEnum.foreground;

  @override
  Stream<AppBodyState> mapEventToState(AppBodyEvent event) async* {
    print('event_type ${event.runtimeType}');
    switch (event.runtimeType) {
      case CheckForOnBoardingEvent:
        yield* _checkOnBoarding();
        break;
      case OnBoardingCompletedEvent:
        _handleOnBoardingCompleted();
        yield* _checkOnBoarding();
        break;
      case MainInitServicesEvent:
        yield MainInitServicesState((event as MainInitServicesEvent).dateTime);
        break;
      case AuthenticationEvent:
        var isUserLoggedIn = await AppService.getInstance.isUserLoggedIn();
        if(!isUserLoggedIn) {
          yield AuthenticationState();
        } else {
          showHome();
        }
        break;
      case ShowHomeEvent:
        yield ShowHomeState();
        break;
      case LogoutEvent:
        await AppService.getInstance.logoutUser();
        authenticationFlow();
        break;
    }
  }

  Stream<AppBodyState> _checkOnBoarding() async* {
    if (await PreferencesUtil().getBool(_onBoardingKey, defaultValue: false)) {
      // as user already seen On-Boarding screen, so we will request bloc to initiate services.
      add(ShowHomeEvent());
    } else {
      // as user has not been shown On-Boarding screen, so we will request bloc to initiate it.
      yield ShowOnBoardingState();
    }
  }

  void _handleOnBoardingCompleted() {
    PreferencesUtil().setBool(_onBoardingKey, value: true);
  }
}
