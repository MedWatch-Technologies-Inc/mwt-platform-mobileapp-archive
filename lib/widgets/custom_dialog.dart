import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'text_utils.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String subTitle;
  final GestureTapCallback onClickYes;
  final GestureTapCallback onClickNo;
  final int? maxLine;
  final String? primaryButton;
  final String? secondaryButton;
  final bool showSecondary;

  // final Color bkgColor;

  const CustomDialog({
    this.title,
    required this.subTitle,
    required this.onClickYes,
    required this.onClickNo,
    this.maxLine = 2,
    this.primaryButton,
    this.secondaryButton,
    this.showSecondary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(-5, -5),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#000000').withOpacity(0.75)
                  : HexColor.fromHex('#384341').withOpacity(0.9),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(5, 5),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 27, left: 10,right: 10),
        // height: 188,
        // width: 309,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: title != null
                  ? Container(
                      // height: 25,
                      child: Body1AutoText(
                        text: title!,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        maxLine: 5,
                        minFontSize: 20,
                      ),
                    )
                  : Container(),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      child: Body1AutoText(
                        // text: Text(subTitle),
                        text: subTitle,
                        maxLine: maxLine,
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        minFontSize: 16,
                        align: TextAlign.justify,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter ,
                        child: TextButton(
                          key: Key('dialogYes'),
                          onPressed: onClickYes,
                          child: SizedBox(
                            height: 23,
                            child: Body1AutoText(
                              text: primaryButton == null
                                  ? stringLocalization.getText(StringLocalization.confirm).toUpperCase()
                                  : primaryButton!.toUpperCase(),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: HexColor.fromHex('#00AFAA'),
                              maxLine: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      if(showSecondary)...[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            key: Key('dialogCancel'),
                            onPressed: onClickNo,
                            child: SizedBox(
                              height: 23,
                              child: Body1AutoText(
                                text: secondaryButton == null
                                    ? stringLocalization
                                    .getText(StringLocalization.cancel)
                                    .toUpperCase()
                                    : secondaryButton!.toUpperCase(),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: HexColor.fromHex('#00AFAA'),
                                maxLine: 1,
                                minFontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      ],

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomChildDialog extends StatelessWidget {
  final Widget child;

  // final Color bkgColor;

  const CustomChildDialog({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(-5, -5),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#000000').withOpacity(0.75)
                  : HexColor.fromHex('#384341').withOpacity(0.9),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(5, 5),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 27, right: 16, left: 16),
        // height: 188,
        // width: 309,
        child: child,
      ),
    );
  }
}

class CustomInfoDialog extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final GestureTapCallback onClickYes;

  // final GestureTapCallback onClickNo;
  final String? primaryButton;
  final int? maxLine;

  // final Color bkgColor;

  const CustomInfoDialog(
      {this.title,
      this.subTitle,
      required this.onClickYes,
      this.primaryButton,
      // this.onClickNo,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 27, left: 16, right: 10),
            // height: 188,
            width: 309,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: title != null
                        ? Container(
                            // height: 25,
                            child: Body1AutoText(
                              text: title!,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                              maxLine: 2,
                              minFontSize: 20,
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subTitle != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: SizedBox(
                                    height: 55,
                                    child: Body1AutoText(
                                        // text: Text(subTitle),
                                        text: subTitle!,
                                        maxLine: maxLine,
                                        fontSize: 16,
                                        minFontSize: 16,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                            : HexColor.fromHex('#384341')),
                                  ),
                                )
                              : Container(),
                          subTitle != null
                              ? SizedBox(
                                  height: 15,
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  key: Key('errorOk'),
                                  onPressed: onClickYes,
                                  child: SizedBox(
                                    height: 23,
                                    child: Body1AutoText(
                                      text: primaryButton == null
                                          ? stringLocalization
                                              .getText(StringLocalization.yes)
                                              .toUpperCase()
                                          : primaryButton!,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: HexColor.fromHex('#00AFAA'),
                                      maxLine: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                ])));
  }
}

class SingleLineCustomDialog extends StatelessWidget {
  final String? text;
  final GestureTapCallback onClickYes;
  final String? primaryButton;

  // final int maxLine;

  // final Color bkgColor;

  const SingleLineCustomDialog({
    this.text,
    required this.onClickYes,
    this.primaryButton,
    // this.onClickNo,
    // this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 27.h, left: 16.w, right: 10.w),
            // height: 188,
            width: 309.w,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text != null
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                          child: Body1AutoText(
                              // text: Text(subTitle),
                              text: text!,
                              maxLine: 1,
                              fontSize: 16,
                              minFontSize: 16,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                  : HexColor.fromHex('#384341')),
                        )
                      : Container(),
                  text != null
                      ? SizedBox(
                          height: 15.h,
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: onClickYes,
                          child: SizedBox(
                            height: 23.h,
                            child: Body1AutoText(
                              text: primaryButton == null
                                  ? stringLocalization.getText(StringLocalization.yes).toUpperCase()
                                  : primaryButton!,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: HexColor.fromHex('#00AFAA'),
                              maxLine: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ])));
  }
}
