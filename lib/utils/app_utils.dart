import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class AppUtils {
  AppUtils._internal();

  static final AppUtils _instance = AppUtils._internal();

  factory AppUtils() {
    return _instance;
  }

  Future<dynamic> consentDialog(BuildContext context) async {
    var isConsent = ValueNotifier<bool>(false);
    var isError = ValueNotifier<bool>(false);
    isConsent.value = preferences!.getBool(Constants.prefConsentKey) ?? false;
    var result = await appDialog(

      context: context,
      title: Body1Text(
        text: StringLocalization.of(context).getText(StringLocalization.consentTitle),
        fontSize: 12.sp,
        align: TextAlign.justify,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
            : HexColor.fromHex('#384341'),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cInfoTitle),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                // maxLine: 1,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cInfoData),
                fontSize: 12.sp,
                align: TextAlign.justify,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cNoMedTitle),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                // maxLine: 1,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cNoMedData),
                fontSize: 12.sp,
                align: TextAlign.justify,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cConsultTitle),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                // maxLine: 1,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cConsultData),
                fontSize: 12.sp,
                align: TextAlign.justify,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cNoSubTitle),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                // maxLine: 1,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cNoSubData),
                fontSize: 12.sp,
                align: TextAlign.justify,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cIndividualTitle),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                // maxLine: 1,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.cIndividualData),
                fontSize: 12.sp,
                align: TextAlign.justify,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              SizedBox(
                height: 15.0,
              ),
              Body1Text(
                text: StringLocalization.of(context).getText(StringLocalization.consentEnd),
                fontSize: 14.sp,
                align: TextAlign.justify,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              )
            ],
          ),
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: isError,
                    builder: (BuildContext context, bool isErrorValue, Widget? child) {
                      return ValueListenableBuilder(
                        valueListenable: isConsent,
                        builder: (BuildContext context, bool consentValue, Widget? child) {
                          return Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(2.0),
                            child: Checkbox(
                              value: consentValue,
                              side: BorderSide(
                                color: isErrorValue ? Colors.red : HexColor.fromHex('#00AFAA'),
                                width: 2.0,
                              ),
                              onChanged: (checked) async {
                                isError.value = false;
                                if (checked != null) {
                                  isConsent.value = checked;
                                }
                              },
                              activeColor: HexColor.fromHex('#00AFAA'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: isError,
                      builder: (BuildContext context, bool isErrorValue, Widget? child) {
                        return Body1Text(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.cCheckMessage),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? isErrorValue
                                  ? Colors.red
                                  : HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : isErrorValue
                                  ? Colors.red
                                  : HexColor.fromHex('#384341'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await preferences!.setBool(Constants.prefConsentKey, isConsent.value);
                    if (!isConsent.value) {
                      isError.value = true;
                    }else{
                      Navigator.of(context,rootNavigator: true).pop();
                    }
                  },
                  child: Text(
                    StringLocalization.of(context).getText(StringLocalization.accept),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: HexColor.fromHex('#00AFAA'),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await preferences!.setBool(Constants.prefConsentKey, false);
                    Navigator.of(context,rootNavigator: true).pop();
                  },
                  child: Text(
                    StringLocalization.of(context).getText(StringLocalization.decline),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: HexColor.fromHex('#00AFAA'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
    return result;
  }

  Future<void> appDialog({
    required BuildContext context,
    required Widget child,
    required Widget title,
    List<Widget> actions = const [],
  }) async {
    dynamic result = await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.h),
              ),
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              insetPadding: EdgeInsets.all(10.0),
              title: title,
              content: child,
              actions: actions,
              actionsAlignment: MainAxisAlignment.start,
              actionsPadding: EdgeInsets.symmetric(horizontal: 10.0),
            );
          },
        );
      },
    );

    return result;
  }

  bool iOSVersionCompare(String? version) {
    if (version != null) {
      String tempVersion = version.split(".")[0];
      if (double.parse(tempVersion) >= 14.0) return true;
    }
    return false;
  }
}
