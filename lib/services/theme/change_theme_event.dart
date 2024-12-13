import 'package:health_gauge/services/theme/theme_bloc.dart';

abstract class ChangeThemeEvent {
  ThemeType? themeType;
  bool isUserSetTheme;

  ChangeThemeEvent(this.themeType, {this.isUserSetTheme = false});
}

class DecideTheme extends ChangeThemeEvent {
  DecideTheme(ThemeType? themeType, {bool isUserSetTheme = false})
      : super(themeType, isUserSetTheme: isUserSetTheme);
}

class LightTheme extends ChangeThemeEvent {
  LightTheme(ThemeType themeType, {bool isUserSetTheme = false})
      : super(themeType, isUserSetTheme: isUserSetTheme);

  @override
  String toString() => 'LightTheme';
}

class DarkTheme extends ChangeThemeEvent {
  DarkTheme(ThemeType themeType, {bool isUserSetTheme = false})
      : super(themeType, isUserSetTheme: isUserSetTheme);

  @override
  String toString() => 'DarkTheme';
}
