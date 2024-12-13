import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/webview_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import 'package:http/http.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HealthKitScreen extends StatefulWidget {
  final String? title;

  HealthKitScreen({Key? key, this.title}) : super(key: key);

  @override
  HealthKitScreenState createState() => HealthKitScreenState();
}

class HealthKitScreenState extends State<HealthKitScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(HealthKitScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : HexColor.fromHex('#384341').withOpacity(0.2),
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                )
              ]),
              child: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkBackgroundColor
                    : AppColor.backgroundColor,
                title: TitleText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.help),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex('62CBC9'),
                ),
                centerTitle: true,
              ),
            )),
        body: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
        ));
  }
}
