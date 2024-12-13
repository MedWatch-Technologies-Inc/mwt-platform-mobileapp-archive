import 'package:flutter/material.dart';
import 'package:health_gauge/main.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline, size: 50),
          SizedBox(height: 20.0),
          Display1Text(text: StringLocalization.of(context).getText(StringLocalization.oops), color: Colors.red),
          SizedBox(height: 10.0),
          Body1AutoText(text: StringLocalization.of(context).getText(StringLocalization.somethingWentWrong)),
        ],
      ),
    );
  }
}
