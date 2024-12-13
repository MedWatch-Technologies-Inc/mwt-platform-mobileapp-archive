import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/text_utils.dart';

import 'home/home_screeen.dart';

class DisclaimerScreen extends StatefulWidget {
  @override
  _DisclaimerScreenState createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex("#384341").withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      "asset/dark_leftArrow.png",
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      "asset/leftArrow.png",
                      width: 13,
                      height: 22,
                    ),
            ),
            title: SizedBox(
                height: 28.h,
                child: TitleText(
                    text: stringLocalization
                        .getText(StringLocalization.disclaimer),
                    color: HexColor.fromHex("62CBC9"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(child: dataLayout()),
    );
  }

  Widget dataLayout() {
    return Column(children: [
      SizedBox(height: 50.h),
      Image.asset(
        "asset/appLogo.png",
        height: 119.h,
      ),
      SizedBox(height: 60.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 33.w),
        child: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.disclaimerInfo),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex("#384341"),
          fontSize: 10.sp,
          minFontSize: 10,
          maxLine: 45,
        ),
      ),
      button(),
    ]);
  }

  Widget button() {
    return GestureDetector(
        child: Container(
          margin:
              EdgeInsets.only(bottom: 25.h, top: 28.h, left: 33.w, right: 33.w),
          // width: 100.w,
          height: 40.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: HexColor.fromHex("#00AFAA"),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex("#D1D9E6"),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          child: Container(
            key: Key("disclaimerOK"),
            decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.h),
                ),
                depression: 10,
                colors: [
                  Colors.white,
                  HexColor.fromHex("#D1D9E6"),
                ]),
            child: Center(
              child: Text(
                stringLocalization.getText(StringLocalization.ok).toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#111B1A")
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pop(true);
        });
  }
}
