import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/services/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_theme_event.dart';
import 'change_theme_state.dart';

ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()..onDecideThemeChange();

enum ThemeType { dark, light }

extension ThemeTypeExtension on ThemeType {
  static const values = {
    0: ThemeType.dark,
    1: ThemeType.light,
  };

  ThemeType? get value => values[this as int];
}

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  static ChangeThemeBloc of(BuildContext context) =>
      BlocProvider.of<ChangeThemeBloc>(context);

  ChangeThemeBloc({ThemeType? themeType})
      : super(ChangeThemeState(
            themeData: themeType != null && themeType == ThemeType.dark
                ? AppDarkTheme().themeData
                : AppLightTheme().themeData));

  void onLightThemeChange({bool isUserSetTheme = false}) {
    add(LightTheme(ThemeType.light, isUserSetTheme: isUserSetTheme));
  }

  void onDarkThemeChange({bool isUserSetTheme = false}) {
    add(DarkTheme(ThemeType.dark, isUserSetTheme: isUserSetTheme));
  }

  void onDecideThemeChange(
      {bool isUserSetTheme = false, ThemeType? themeType}) {
    add(DecideTheme(themeType, isUserSetTheme: isUserSetTheme));
  }

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    if (event is DecideTheme) {
      var optionValue = await getOption();
      if (event.themeType != null) {
        optionValue = event.themeType == ThemeType.dark ? 0 : 1;
      }
      if (optionValue == 0) {
        yield ChangeThemeState.darkTheme();
      } else if (optionValue == 1) {
        yield ChangeThemeState.lightTheme();
      }
    }
    if (event is LightTheme) {
      yield ChangeThemeState.lightTheme();
      try {
        // Don't save for the interim theme
        if (!event.isUserSetTheme) {
          await _saveOptionValue(1);
        }
      } on Exception catch (_) {
        throw Exception('Could not persist change');
      }
    }

    if (event is DarkTheme) {
      yield ChangeThemeState.darkTheme();
      try {
        // Don't save for the interim theme
        if (!event.isUserSetTheme) {
          await _saveOptionValue(0);
        }
      } on Exception catch (_) {
        throw Exception('Could not persist change');
      }
    }
  }

  Future<void> _saveOptionValue(int optionValue) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt('theme_option', optionValue);
  }

  Future<int> getOption() async {
    var preferences = await SharedPreferences.getInstance();
    var option = preferences.get('theme_option') as int? ?? 0;
    return option;
  }

  Future<ThemeType> getThemeType() async {
    var option = await getOption();
    return ThemeType.values[option];
  }
}
