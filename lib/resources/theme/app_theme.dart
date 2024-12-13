import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/services/theme/change_theme_state.dart';
import 'package:health_gauge/services/theme/theme_bloc.dart';

final ChangeThemeBloc _changeThemeBloc = ChangeThemeBloc();

class AppThemeWidget extends StatefulWidget {
  final Widget child;
  final bool setUiOverlayStyle;

  const AppThemeWidget(
      {required this.child, this.setUiOverlayStyle = false, Key? key})
      : super(key: key);

  @override
  _AppThemeWidgetState createState() => _AppThemeWidgetState();
}

class _AppThemeWidgetState extends State<AppThemeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
        bloc: _changeThemeBloc,
        builder: (context, themeState) {
          AppTheme.changeTheme(
            isDark: themeState.isDarkTheme ?? true,
            themeState: themeState,
          );
          if (widget.setUiOverlayStyle) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                // For Android.
                statusBarIconBrightness: AppTheme().statusBarIconBrightness,
                // For iOS.
                statusBarBrightness: AppTheme().statusBarBrightness,
              ),
              child: widget.child,
            );
          } else {
            return widget.child;
          }
        });
  }
}

class AppTheme {
  final bool isDarkTheme;
  final Brightness statusBarIconBrightness;
  final Brightness statusBarBrightness;
  final Color backgroundColor;
  final Color primaryColor;
  final Color textColorOne;
  final Color normalTextColor;
  final Color textColorTwo;
  final Color decorationColorRadioOne;
  final Color decorationColorRadioTwo;
  final Color shadowColorRadioOne;
  final Color shadowColorRadioTwo;
  final Color containerDecorationColorOne;
  final Color buttonTextColor;
  final Color concaveDecorationColorOne;
  final Color concaveDecorationColorTwo;
  final Color secondaryTextColor;
  final Color radioButtonColorActive;
  final Color radioButtonColorInactive;
  final Color checkCorrect;
  final Color checkIncorrect;
  final Color appBarTitleColor;
  final Color appBarShadow;
  final Color hintColorNormal;
  final Color hintColorError;

  static AppTheme? _appTheme;

  static void changeTheme({
    ChangeThemeState? themeState,
    bool isDark = true,
  }) {
    if (_appTheme == null || _appTheme!.isDarkTheme != isDark) {
      _appTheme = isDark ? AppTheme._dark() : AppTheme._light();
      _themeState = themeState;
    }
  }

  static ChangeThemeState? _themeState;

  ChangeThemeState getThemeState() {
    return _themeState ??= ChangeThemeState.darkTheme();
  }

  ThemeData getThemeData() {
    return getThemeState().themeData;
  }

  factory AppTheme() {
    return _appTheme ??= AppTheme._dark();
  }

  const AppTheme._light({
    this.isDarkTheme = false,
    this.statusBarIconBrightness = Brightness.dark,
    this.statusBarBrightness = Brightness.light,
    this.backgroundColor = AppThemeColor.lightBg,
    this.primaryColor = AppThemeColor.primaryColor,
    this.textColorOne = AppThemeColor.primaryTextColor,
    this.normalTextColor = AppThemeColor.normalTextColor,
    this.textColorTwo = AppThemeColor.primaryTextColor,
    this.decorationColorRadioOne = AppThemeColor.decorationColorRadioOne,
    this.decorationColorRadioTwo = AppThemeColor.white,
    this.shadowColorRadioOne = AppThemeColor.white,
    this.shadowColorRadioTwo = AppThemeColor.shadowColorTwo,
    this.containerDecorationColorOne = AppThemeColor.persianGreenOpacity80,
    this.buttonTextColor = AppThemeColor.white,
    this.concaveDecorationColorOne = AppThemeColor.concaveDecorationColorOne,
    this.concaveDecorationColorTwo = AppThemeColor.white,
    this.secondaryTextColor = AppThemeColor.secondaryTextColor,
    this.radioButtonColorActive = AppThemeColor.radioButtonColor,
    this.radioButtonColorInactive = AppThemeColor.transparent,
    this.checkIncorrect = AppThemeColor.radioButtonColor,
    this.checkCorrect = AppThemeColor.primaryColor,
    this.appBarTitleColor = AppThemeColor.appBarTitleColor,
    this.appBarShadow = AppThemeColor.appBarShadow,
    this.hintColorError = AppThemeColor.hintColorError,
    this.hintColorNormal = AppThemeColor.hintColorNormal,
  });

  const AppTheme._dark({
    this.isDarkTheme = true,
    this.statusBarIconBrightness = Brightness.light,
    this.statusBarBrightness = Brightness.dark,
    this.backgroundColor = AppThemeColor.darkBg,
    this.primaryColor = AppThemeColor.primaryColor,
    this.textColorOne = AppThemeColor.white90,
    this.normalTextColor = AppThemeColor.white60,
    this.textColorTwo = AppThemeColor.white87,
    this.decorationColorRadioOne = AppThemeColor.black80,
    this.decorationColorRadioTwo = AppThemeColor.decorationColorRadioTwo,
    this.shadowColorRadioOne = AppThemeColor.shadowColorOne,
    this.shadowColorRadioTwo = AppThemeColor.black75,
    this.containerDecorationColorOne = AppThemeColor.persianGreen,
    this.buttonTextColor = AppThemeColor.darkBg,
    this.concaveDecorationColorOne = AppThemeColor.black50,
    this.concaveDecorationColorTwo = AppThemeColor.concaveDecorationColorTwo,
    this.secondaryTextColor = AppThemeColor.secondaryTextColor,
    this.radioButtonColorActive = AppThemeColor.radioButtonColor,
    this.radioButtonColorInactive = AppThemeColor.transparent,
    this.checkIncorrect = AppThemeColor.radioButtonColor,
    this.checkCorrect = AppThemeColor.primaryColor,
    this.appBarTitleColor = AppThemeColor.appBarTitleColor,
    this.appBarShadow = AppThemeColor.black50,
    this.hintColorError = AppThemeColor.hintColorError,
    this.hintColorNormal = AppThemeColor.hintColorNormal,
  });
}

class AppThemeColor {
  static const Color primaryColor = Color(0xFF009C92); // #009C92
  static const Color lightBg = zircon;

  static const Color darkBg = blackPearl;

  static const Color primaryTextColor = corduroy;
  static const Color secondaryTextColor = persianGreen;
  static const Color normalTextColor = nevadaGray;

  static const Color decorationColorRadioOne = periwinkle;
  static const Color decorationColorRadioTwo = periwinkleOpacity10;

  static const Color shadowColorOne = periwinkleOpacity10;
  static const Color shadowColorTwo = periwinkle;
  static const Color radioButtonColor = bitterSweet;
  static const Color transparent = Colors.transparent;
  static const Color containerDecorationColorOne = persianGreen;
  static const Color containerDecorationColorTwo = persianGreenOpacity80;
  static const Color concaveDecorationColorOne = periwinkle;
  static const Color concaveDecorationColorTwo = periwinkleOpacity7;
  static const Color appBarTitleColor = downy;
  static const Color appBarShadow = corduroyOpacity20;
  static const Color hintColorNormal = osloGrey;
  static const Color hintColorError = bitterSweet;

  //Color Shades determined from https://www.color-blindness.com/color-name-hue/

  // shade of gray
  static const Color nevadaGray = Color.fromRGBO(93, 106, 104, 1); // #5D6A68
  static const Color zircon = Color.fromRGBO(238, 241, 241, 1); // #EEF1F1
  static const Color osloGrey = Color.fromRGBO(127, 141, 140, 1); // #7F8D8C

  static const Color blackPearl = Color.fromRGBO(17, 27, 26, 1); // #111B1A

  // shade of green
  static const Color corduroy = Color.fromRGBO(56, 67, 65, 1); // #384341
  static const Color corduroyOpacity20 =
      Color.fromRGBO(56, 67, 65, 0.2); // ##384341
  static const Color persianGreen = Color.fromRGBO(0, 175, 170, 1); // #00AFAA
  static const Color persianGreenOpacity80 = Color.fromRGBO(0, 175, 170, 0.8);
  static const Color downy = Color.fromRGBO(98, 203, 201, 1); // #62CBC9

  // shade of blue
  static const Color periwinkle = Color.fromRGBO(209, 217, 230, 1); // #D1D9E6
  static const Color periwinkleOpacity10 = Color.fromRGBO(209, 217, 230, 0.1);
  static const Color periwinkleOpacity7 = Color.fromRGBO(209, 217, 230, 0.07);

  // shade of orange
  static const Color bitterSweet = Color.fromRGBO(255, 98, 89, 1); // #FF6259

// shade of white
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color white90 = Color.fromRGBO(255, 255, 255, 0.90);
  static const Color white87 = Color.fromRGBO(255, 255, 255, 0.87);
  static const Color white60 = Color.fromRGBO(255, 255, 255, 0.60);
  static const Color white38 = Color.fromRGBO(255, 255, 255, 0.38);
  static const Color white15 = Color.fromRGBO(255, 255, 255, 0.15);

  // shade of black
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color black80 = Color.fromRGBO(0, 0, 0, 0.80);
  static const Color black75 = Color.fromRGBO(0, 0, 0, 0.75);
  static const Color black50 = Color.fromRGBO(0, 0, 0, 0.50);
}
