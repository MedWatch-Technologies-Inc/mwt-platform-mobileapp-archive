import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/resources/theme/app_theme.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/value/string_localization_support/strings_localization_delegates.dart';

import 'app_page.dart';

class BaseApp extends StatelessWidget {
  static final navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return _BaseProviders(
      child: ValueListenableBuilder(
        valueListenable: enableDarkModeNotifier,
        builder: (BuildContext context, bool? value, Widget? child) {
          AppTheme.changeTheme(
              isDark: SchedulerBinding.instance!.window.platformBrightness ==
                  Brightness.dark);
          return ScreenUtilInit(
            designSize: Size(375.0, 812.0),
            builder: (_, Widget) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navKey,
                title: Strings().appName,
                themeMode: value == null
                    ? ThemeMode.system
                    : value
                        ? ThemeMode.dark
                        : ThemeMode.light,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: AppColor.primaryColor,
                  appBarTheme: AppBarTheme(
                    color: AppColor.backgroundColor,
                    iconTheme: Theme.of(context)
                        .iconTheme
                        .copyWith(color: Theme.of(context).iconTheme.color),
                  ),
                  fontFamily: 'Nunito',
                  // appBarTheme: Theme.of(context).appBarTheme.copyWith(brightness: Brightness.light),
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: AppColor.primaryColor,

                  fontFamily: 'Nunito',
                ),
                home: AppPage(),
                // home: MyHomePage(title: '',),
                localizationsDelegates: [
                  // A class which loads the translations
                  const StringsLocalizationDelegate(),
                  // Built-in localization of basic text for Material widgets
                  GlobalMaterialLocalizations.delegate,
                  // Built-in localization for text direction LTR/RTL
                  GlobalWidgetsLocalizations.delegate,
                  // Built-in localization of basic text for Cupertino widgets
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale(StringLocalization.kLanguageEnglish),
                  const Locale(StringLocalization.kLanguageHindi),
                  const Locale(StringLocalization.kLanguageFrench)
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _BaseProviders extends StatelessWidget {
  final Widget child;

  const _BaseProviders({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
    // return MultiProvider(
    //   providers: [],
    //   child: MultiBlocProvider(
    //     providers: [],
    //     child: child,
    //   ),
    // );
  }
}
