import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocObserver {
  //var _logTag = 'SimpleBlocDelegate';

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('[INFO] ${bloc.runtimeType}: $event dispatched');
    // LoggingService.getInstance
    //     .logMessage('$_logTag: onEvent called for $bloc and $event dispatched');
    /*LogUtil().printLog(
        tag: '$_logTag',
        message: 'onEvent called for $bloc and $event dispatched');*/
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // LoggingService.getInstance.logMessage(
    //     '$_logTag: transition called for $bloc and event: ${transition?.event} and currentState: ${transition?.currentState} &&  and nextState: ${transition?.nextState}');
    /*LogUtil().printLog(
        tag: '$_logTag',
        message:
            'transition called for $bloc and event: ${transition?.event} and currentState: ${transition?.currentState} &&  and nextState: ${transition?.nextState}');*/
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('[Error] ${bloc.runtimeType}: ${stackTrace.toString()}');
  }
}
