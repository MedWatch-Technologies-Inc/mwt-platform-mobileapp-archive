import 'package:flutter/material.dart';
import 'package:health_gauge/services/theme/theme.dart';
import 'package:health_gauge/services/theme/theme_bloc.dart';

class ChangeThemeState {
  final ThemeData themeData;
  final ThemeType? type;
  bool? isDarkTheme;

  ChangeThemeState({required this.themeData, this.type}) {
    isDarkTheme = themeData.brightness == Brightness.dark;
  }

  factory ChangeThemeState.lightTheme(
      {ThemeType? type}) {

    return ChangeThemeState(
      themeData: AppLightTheme().themeData,
      type: type,
    );
  }

  factory ChangeThemeState.darkTheme(
      {ThemeType? type}) {
    return ChangeThemeState(
      themeData: AppDarkTheme().themeData,
      type: type,
    );
  }
}
