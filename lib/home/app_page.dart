import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/home/app_body.dart';
import 'package:health_gauge/services/core_util/app_init_logs.dart';
import 'package:health_gauge/services/core_util/snackbar_overlay.dart';
import 'package:health_gauge/services/core_util/status_bar_util.dart';
import 'package:health_gauge/services/firebase/firebase_cloud_messaging.dart';
import 'package:health_gauge/services/navigator/helpers/navigator_utils.dart';
import 'package:health_gauge/services/navigator/system_navigator_service.dart';
import 'package:health_gauge/services/theme/change_theme_state.dart';
import 'package:health_gauge/services/theme/theme_bloc.dart';

import 'bloc/app_body_bloc.dart';
import 'bloc/app_body_states.dart';

typedef localNotificationHandlerPayload = void Function(dynamic payload);

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with WidgetsBindingObserver {
  DateTime? _currentBackPressTime;

  SnackbarOverlayHandler? snackbarOverlayHandler;

  @override
  void initState() {
    super.initState();
    AppInitLogs.instance.log('common-init');
    snackbarOverlayHandler = SnackbarOverlayHandler(context: context);
    appBodyBloc.stream.listen((state) {
      if (state is FirebaseCredentialsFetchedState) {
        // TODO: Firbase init

      }
    });

    WidgetsBinding.instance!.addObserver(this);
  }

  ///
  /// Perform the firebase init operation
  ///
  Future _initFirebase() async {
    await FirebaseCloudMessaging.getInstance.init();
    //Set the Environment values for IOS notification native code.
    if (Platform.isIOS) {
      // Need to handle something for IOS

    }
    _localNotificationHandlerSubscription((payload) {
      // Need to handle Payload to show notification
    });
  }

  static const localNotificationHandlerEventChannel =
  EventChannel('local_notification_handler');

  void _localNotificationHandlerSubscription(
      localNotificationHandlerPayload payload) {
    localNotificationHandlerEventChannel
        .receiveBroadcastStream('local_notification_handler_listner')
        .listen(payload);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     // TODO: Handle this case. foreground
    //     break;
    //   case AppLifecycleState.inactive:
    //     // TODO: Handle this case. background
    //     break;
    //   case AppLifecycleState.paused:
    //     // TODO: Handle this case. background
    //     break;
    //   case AppLifecycleState.detached:
    //     // TODO: Handle this case. ??
    //     break;
    //   case AppLifecycleState.detached:fl
    //   // TODO: Handle this case. App is hidden (e.g., on a different screen)
    //     break;
    // }
  }

  Future<bool> onWillPop() {
    if(NavigatorService().currentPageIntent != EnumPageIntent.homePage) {
      return Future.value(false);
    } else {
      var now = DateTime.now();
      if (_currentBackPressTime == null ||
          now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
        _currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press again to close');
        return Future.value(false);
      }
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Wrap widget in bloc if handling secure data from firebase or want to disable app
    //during internet lost, locale handling etc
    AppInitLogs.instance.log('common-build');
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Status bar handling
            // Positioned.fill(child: _BodyBackground()),
            // App Body
            AppBody(),
          ],
        ),
      ),
    );
  }
}

class _BodyBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      buildWhen: (ChangeThemeState previous, ChangeThemeState curr) {
        return previous != curr;
      },
      builder: (BuildContext ctx, ChangeThemeState themeState) {
        if (themeState.isDarkTheme!) {
          StatusBarUtil.instance.darkThemeStatusBar();
        } else {
          StatusBarUtil.instance.lightThemeStatusBar();
        }
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          color: themeState.themeData.colorScheme.background,
        );
      },
    );
  }
}
