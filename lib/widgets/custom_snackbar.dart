import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar._();
  static buildSnackbar(BuildContext context, String text, int duration) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          duration: Duration(seconds: duration),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static CurrentBuildSnackBar(
      BuildContext context, String text,
      {int duration = 1}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        duration: Duration(seconds: duration),
      ),
    );
  }
}

// class CurrentCustomSnackBar {
//   CurrentCustomSnackBar._();

// }
