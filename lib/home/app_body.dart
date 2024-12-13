import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/services/core_util/app_init_logs.dart';
import 'package:health_gauge/services/navigator/helpers/navigator_service_widget.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'app_service.dart';
import 'bloc/app_body_bloc.dart';
import 'bloc/app_body_states.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final String _tag = 'AppBody';

  Future<void> _init() async {
    var isInitialised = await AppService.getInstance.preInit(context);
    if (isInitialised) {
      AppInitLogs.instance.log('preInit-Initialised');
      appBodyBloc.authenticationFlow();
    } else {
      /// We are here means,
      /// There must be something wrong while initialising services,
      /// Which can be App update, should show alert
      _showAppUpdateDialog();
    }
  }


  Future<void> _showAppUpdateDialog() async {
    // Show Dialog for update

    //App Store code
    // Future<void> openAppStore() async {
    //   if (Platform.isIOS) {
    //     var appId = '123456';
    //     await launch('itms-beta://beta.itunes.apple.com/v1/app/$appId');
    //   } else if (Platform.isAndroid) {
    //     await launch(
    //         'https://play.google.com/store/apps/details?id=${SystemInfoHelpers.getInstance.appId}');
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    stringLocalization = StringLocalization.of(context);
    AppInitLogs.instance.log('$_tag-build');
    return Stack(
      children: [
        BlocConsumer<AppBodyBloc, AppBodyState>(
          bloc: appBodyBloc,
          listener: (BuildContext context, AppBodyState state) {
            if (state is MainInitServicesState) {
              _init();
            }
          },
          buildWhen: (previousState, currentState) {
            return !(currentState is AppBodyIdealState) &&
                ((currentState is ShowHomeState) ||
                    (currentState is ShowOnBoardingState) ||
                    (currentState is AuthenticationState));
          },
          builder: (BuildContext context, AppBodyState state) {
            switch (state.runtimeType) {
              case ShowOnBoardingState:
                return _tempWidget('ShowOnBoardingState');
              case ShowHomeState:
                return _tempWidget('Home Body');
              case AuthenticationState:
                return _tempWidget('AuthenticationState');
            }
            return _tempWidget('default');
          },
        ),
        StreamBuilder<bool>(
          stream: AppService.getInstance.isTutorialVisible,
          builder: (_, snapshot) {
            if (snapshot.data ?? false) {
              //TODO add Tutorial Screen to show how the feature works
              return Container();
            }

            return Container();
          },
        )
      ],
    );
  }

  Widget _tempWidget(String text) {
    return Scaffold(
        body: SafeArea(
            child: Text(
      text,
      style: TextStyle(color: Colors.red),
    )));
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  Widget build(BuildContext context) {
    AppInitLogs.instance.log('homebody');
    return NavigatorServiceBase();
  }
}
