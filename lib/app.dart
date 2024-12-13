import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library_changes/models/library_share_model.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_bloc.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_day_data_provider.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_history_provider.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_day_data_provider.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_history_provider.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_month_data_provider.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_week_data_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_day_data_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_history_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_month_data_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_week_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_day_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_history_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_month_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_week_data_provider.dart';
import 'package:health_gauge/screens/inbox/compose_bloc.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_bloc.dart';
import 'package:health_gauge/screens/inbox/invitation_bloc.dart';
import 'package:health_gauge/screens/inbox/invitation_search_bloc.dart';
import 'package:health_gauge/screens/inbox/mail_detail_bloc.dart';
import 'package:health_gauge/screens/inbox/search_contact_bloc.dart';
import 'package:health_gauge/screens/localization/inherited_data.dart';
import 'package:health_gauge/screens/map_screen/providers/history_detail_provider.dart';
import 'package:health_gauge/screens/map_screen/providers/history_list_provider.dart';
import 'package:health_gauge/screens/map_screen/providers/location_track_provider.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/screens/sign_in_screen.dart';
import 'package:health_gauge/screens/survey/bloc/share_survey_bloc/share_survey_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_home_bloc/survey_home_bloc.dart';
import 'package:health_gauge/speech_to_text/api/nlp_api_repository.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_provider.dart';
import 'package:health_gauge/speech_to_text/model/speech_text_model.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/value/string_localization_support/strings_localization_delegates.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/chat/chat_bloc/chat_bloc.dart';
import 'screens/chat/chat_bloc/chat_state.dart';
import 'screens/history/blood_pressure_history/providers/blood_pressure_month_data_provider.dart';
import 'screens/history/blood_pressure_history/providers/blood_pressure_week_data_provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;
  String firebaseToken = '';
  final _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future _fetchLocale() async {
    preferences ??= await SharedPreferences.getInstance();

    if (preferences!.getString('languageCode') == null) {
      locale = null;
    } else if (mounted) {
      locale = Locale(
        preferences!.getString('languageCode') ?? '',
      );
      setState(() {});
    }
    // } else
    //   locale = null;
  }

  void setLocale(Locale newLocale) {
    locale = newLocale;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// notification method call
    initLocalNotification();
    setupInteractedMessage();
    if (preferences == null) {
      SharedPreferences.getInstance().then((value) => preferences = value);
    }
    var loc = preferences?.getString('languageCode');
    if (loc == null) {
      preferences?.setString('languageCode', 'en');
    }
    _fetchLocale();
    super.initState();
  }

  void initLocalNotification() async {
    await requestNotificationPermission();
    const initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        debugPrint('notification payload: $payload');
      },
      onDidReceiveBackgroundNotificationResponse: (payload) async {
        debugPrint('notification payload: $payload');
      },
    );
  }

  Future<bool> requestNotificationPermission() async {
    var _notificationsEnabled = false;
    if (Platform.isIOS) {
      _notificationsEnabled = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ??
          false;
    } else if (Platform.isAndroid) {
      final androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      _notificationsEnabled =
          await androidImplementation?.requestNotificationsPermission() ?? false;
    }
    return _notificationsEnabled;
  }

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// method for show noatification
  void showNotification(RemoteMessage message) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'com.healthgauge.app', 'HealthGauge',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// method for firebase notification setup for android and ios (updated code with new library)
  Future<void> setupInteractedMessage() async {
    // RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    _firebaseMessaging.getToken().then((value) {
      print('Your FCM token:- $value');
    });
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print(
            'notification payload: Initial Firebase Message : ${message.notification!.title} : ${message.notification!.body}');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'notification payload: Firebase Message : ${message.notification!.title} : ${message.notification!.body}');
      // connections.getAllWatchHistory();
      showNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375.0, 812.0),
      builder: (BuildContext, Widget) {
        return GestureDetector(
          onTap: () {
            var currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: LocaleSetter(
            setLocale: setLocale,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => LocationTrackProvider()),
                ChangeNotifierProvider(create: (_) => HistoryListProvider()),
                ChangeNotifierProvider(create: (_) => HistoryDetailProvider()),
                ChangeNotifierProvider(create: (_) => SaveActivityScreenModel()),
                ChangeNotifierProvider(create: (_) => SpeechTextModel()),
                ChangeNotifierProvider(create: (_) => TempHistoryProvider()),
                ChangeNotifierProvider(create: (_) => TempDayDataProvider()),
                ChangeNotifierProvider(create: (_) => TempWeekDataProvider()),
                ChangeNotifierProvider(create: (_) => TempMonthDataProvider()),
                ChangeNotifierProvider(create: (_) => OxygenHistoryProvider()),
                ChangeNotifierProvider(create: (_) => OxygenDayDataProvider()),
                ChangeNotifierProvider(create: (_) => OxygenWeekDataProvider()),
                ChangeNotifierProvider(create: (_) => OxygenMonthDataProvider()),
                ChangeNotifierProvider(create: (_) => HeartRateHistoryProvider()),
                ChangeNotifierProvider(create: (_) => HeartRateDayDataProvider()),
                ChangeNotifierProvider(create: (_) => HeartRateWeekDataProvider()),
                ChangeNotifierProvider(create: (_) => HeartRateMonthDataProvider()),
                ChangeNotifierProvider(create: (_) => BloodPressureHistoryProvider()),
                ChangeNotifierProvider(create: (_) => BloodPressureDayDataProvider()),
                ChangeNotifierProvider(create: (_) => BloodPressureWeekDataProvider()),
                ChangeNotifierProvider(create: (_) => BloodPressureMonthDataProvider()),
                ChangeNotifierProvider(create: (_) => LibraryShareModel())
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => InboxBloc(),
                  ),
                  BlocProvider(create: (context) => ComposeBloc()),
                  BlocProvider(create: (context) => ContactsBloc()),
                  BlocProvider(create: (context) => InvitationBloc()),
                  BlocProvider(create: (context) => SearchContactToInviteBloc()),
                  BlocProvider(create: (context) => InvitationSearchBloc()),
                  BlocProvider(create: (context) => GetInvitationListBloc()),
                  BlocProvider(create: (context) => MailDetailBloc()),
                  BlocProvider(create: (context) => CalendarBloc()),
                  BlocProvider(create: (context) => ChatBloc(ChatLoading())),
                  BlocProvider(
                    create: (context) => NlpEventBloc(NlpApiRepository()),
                  ),
                  BlocProvider(
                    create: (context) => LibraryBloc(),
                  ),
                  BlocProvider(create: (create) => SurveyHomeBloc()),
                  BlocProvider(create: (create) => SurveyBloc()),
                  BlocProvider(create: (create) => ShareSurveyBloc()),
                  // BlocProvider(create: (context) => DownloadBloc()),
                ],
                child: ValueListenableBuilder(
                  valueListenable: enableDarkModeNotifier,
                  builder: (BuildContext, bool? value, Widget) {
                    return MaterialApp(
                      routes: {
                        '/signInScreen': (context) => SignInScreen(),
                      },
                      builder: (context, child) {
                        // ScreenUtil.setContext(context);
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                          child: child ?? Container(),
                        );
                      },
                      debugShowCheckedModeBanner: false,
                      title: Strings().appName,
                      themeMode: value == null
                          ? ThemeMode.system
                          : value
                              ? ThemeMode.dark
                              : ThemeMode.light,
                      theme: ThemeData(
                        brightness: Brightness.light,
                        primaryColor: AppColor.primaryColor,
                        colorScheme: ColorScheme.light(
                          brightness: Brightness.light,
                          secondary: AppColor.primaryColor,
                          primary: AppColor.primaryColor,
                        ),
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
                        colorScheme: ColorScheme.dark(
                          brightness: Brightness.dark,
                          secondary: AppColor.primaryColor,
                          primary: AppColor.primaryColor,
                        ),
                        fontFamily: 'Nunito',
                        appBarTheme: Theme.of(context).appBarTheme,
                      ),
                      home: SignInScreen(
                        token: firebaseToken,
                      ),
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
                      locale: locale,
                      navigatorKey: navigatorKey,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
