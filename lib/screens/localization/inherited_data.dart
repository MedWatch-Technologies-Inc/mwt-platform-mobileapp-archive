import 'package:flutter/material.dart';


/// Added by: Akhil
/// Added on: May/28/2020
/// Inherited widget to notify the main.dart that the app's language is changed
class LocaleSetter extends InheritedWidget {
  const LocaleSetter({
    Key? key,
    required this.setLocale,
    required Widget child,
  }) : assert(setLocale != null),
        assert(child != null),
        super(key: key, child: child);

   final Function setLocale;

  static LocaleSetter? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleSetter>();
  }

  @override
  bool updateShouldNotify(LocaleSetter old) => setLocale != old.setLocale;
}