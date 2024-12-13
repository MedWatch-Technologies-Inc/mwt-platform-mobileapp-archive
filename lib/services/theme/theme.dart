import 'dart:ui';

import 'package:flutter/material.dart';

abstract class BaseTheme {
  Brightness get brightness;

  Color get primaryColor;

  Color get darkPrimaryColor;

  Color get accentColor;

  Color get darkAccentColor;

  ThemeData get themeData;
}


class AppDarkTheme extends BaseTheme {
  static final AppDarkTheme _instance = AppDarkTheme._();

  AppDarkTheme._();

  factory AppDarkTheme() => _instance;

  @override
  // TODO: implement accentColor
  Color get accentColor => throw UnimplementedError();

  @override
  // TODO: implement brightness
  Brightness get brightness => throw UnimplementedError();

  @override
  // TODO: implement darkAccentColor
  Color get darkAccentColor => throw UnimplementedError();

  @override
  // TODO: implement darkPrimaryColor
  Color get darkPrimaryColor => throw UnimplementedError();

  @override
  // TODO: implement primaryColor
  Color get primaryColor => throw UnimplementedError();

  @override
  // TODO: implement themeData
  ThemeData get themeData => throw UnimplementedError();


}


class AppLightTheme extends BaseTheme {
  static final AppLightTheme _instance = AppLightTheme._();

  AppLightTheme._();

  factory AppLightTheme() => _instance;

  @override
  // TODO: implement accentColor
  Color get accentColor => throw UnimplementedError();

  @override
  // TODO: implement brightness
  Brightness get brightness => throw UnimplementedError();

  @override
  // TODO: implement darkAccentColor
  Color get darkAccentColor => throw UnimplementedError();

  @override
  // TODO: implement darkPrimaryColor
  Color get darkPrimaryColor => throw UnimplementedError();

  @override
  // TODO: implement primaryColor
  Color get primaryColor => throw UnimplementedError();

  @override
  // TODO: implement themeData
  ThemeData get themeData => throw UnimplementedError();

}
