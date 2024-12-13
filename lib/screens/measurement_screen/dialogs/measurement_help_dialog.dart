
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_screen/dialogs/discalimer.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class MeasurementHelpDialog extends StatelessWidget {
  final bool? showDismissButton;
  const MeasurementHelpDialog({Key? key, required this.showDismissButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Dialog(
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
              ]),
          padding: EdgeInsets.only(top: 27.h, left: 26.w, right: 26.w),
          width: 309.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TitleText(
                text:
                stringLocalization.getText(StringLocalization.instruction),
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.white87
                    : AppColor.color384341,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 13.h,
              ),
              Image.asset('asset/help_measurement.png', height: 210.h),
              SizedBox(height: 10.h),
              Container(
                width: 120.w,
                child: Body1AutoText(
                    text:
                    stringLocalization.getText(StringLocalization.holdHand),
                    align: TextAlign.justify,
                    maxLine: 6,
                    minFontSize: 6,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341')),
              ),
             Disclaimer(),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                        alignment:  showDismissButton == null ?   Alignment.centerLeft : Alignment.centerRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                if (context != null) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }
                              },
                              child: Container(
                                height: 30.h,
                                width: 55.w,
                                child: Center(
                                  child: Align(
                                    alignment:showDismissButton == null ?   Alignment.centerLeft : Alignment.centerRight,
                                    child: Body1AutoText(
                                      text: stringLocalization
                                          .getText(StringLocalization.ok)
                                          .toUpperCase(),
                                      color: AppColor.primaryColor,
                                      fontSize: 16.sp,
                                      minFontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )),
                        )),
                  ),
                  showDismissButton == null
                      ? Expanded(
                    flex: 2,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            if (context != null) {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            }
                            preferences!.setBool(
                                Constants
                                    .doNotAskMeAgainForMeasurementDialog,
                                true);
                          },
                          child: Container(
                            height: 30.h,
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerRight ,
                                child: Body1AutoText(
                                  text: stringLocalization.getText(
                                      StringLocalization.doNotAskAgain),
                                  color: AppColor.primaryColor,
                                  fontSize: 16.sp,
                                  minFontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                  )
                      : Container(),

                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ));
  }
}
