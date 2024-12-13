import 'package:flutter/material.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/expandable_text.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../disclaimer_screen.dart';

class Disclaimer extends StatefulWidget {
  const Disclaimer({Key? key}) : super(key: key);

  @override
  _DisclaimerState createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  @override
  Widget build(BuildContext context) {
  return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: ExpandableText(
        '${stringLocalization.getText(StringLocalization.disclaimer)} : ${stringLocalization.getText(StringLocalization.disclaimerInfo)}',
        trimLines: 3,
        callback: () {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          Constants.navigatePush(DisclaimerScreen(), context);
        },
      ),
    );
  }
}
