import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class AIDialogs extends StatelessWidget {
  final GestureTapCallback? onClickOk;

  const AIDialogs({
    required this.onClickOk,
    Key? key,
  }) : super(key: key);

  bool get isOSM => preferences?.getBool(Constants.isOscillometricEnableKey) ?? false;

  bool get isEST => preferences?.getBool(Constants.isEstimatingEnableKey) ?? false;

  @override
  Widget build(BuildContext context) {
    print('AIDialog :: $isEST :: $isOSM');
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          elevation: 0,
          backgroundColor:
              isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
          child: Container(
            decoration: BoxDecoration(
                color:
                    isDarkMode(context) ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#000000').withOpacity(0.75)
                        : HexColor.fromHex('#384341').withOpacity(0.9),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ]),
            padding: EdgeInsets.only(top: 27.h, left: 20.w, right: 20.w),
            width: 309.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                  child: AutoSizeText(
                    'Data Source',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode(context)
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  height: 25,
                  child: AutoSizeText(
                    'Please choose the source of data.',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode(context)
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                  ),
                ),
                SizedBox(height: 26.0.h),
                Container(
                  alignment: Alignment.topLeft,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isAISelected,
                    builder: (context, value, child) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: isTflSelected,
                        builder: (context, tflValue, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isOSM && !isEST) ...[
                                Expanded(
                                  child: Container(
                                    height: 28.h,
                                    child: customRadio(
                                      context,
                                      index: 0,
                                      color: !value && !tflValue
                                          ? HexColor.fromHex('FF6259')
                                          : Colors.transparent,
                                      unitText: 'Device',
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: Container(
                                    height: 28.h,
                                    child: customRadio(
                                      context,
                                      index: 1,
                                      color:
                                          value ? HexColor.fromHex('FF6259') : Colors.transparent,
                                      unitText: 'Cloud AI',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 28.h,
                                    child: customRadio(
                                      context,
                                      index: 2,
                                      color: tflValue
                                          ? HexColor.fromHex('FF6259')
                                          : Colors.transparent,
                                      unitText: 'Edge AI',
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 29.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: onClickOk,
                    child: Container(
                      margin: EdgeInsets.only(right: 7.w),
                      height: 25.h,
                      child: AutoSizeText(
                        stringLocalization.getText(StringLocalization.ok).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: HexColor.fromHex('#00AFAA'),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget customRadio(BuildContext context,
      {required int index, required Color color, required String unitText}) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          isTflSelected.value = false;
          isAISelected.value = false;
          return;
        }
        if (index == 1) {
          isAISelected.value = true;
          isTflSelected.value = false;
          return;
        }
        if (index == 2) {
          isTflSelected.value = true;
          isAISelected.value = false;
        }
      },
      child: Container(
        height: 28.h,
        child: Row(
          children: [
            Container(
              height: 28.h,
              width: 28.h,
              decoration: ConcaveDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
                  depression: 4,
                  colors: [
                    isDarkMode(context)
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex('#D1D9E6'),
                    isDarkMode(context)
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                  ]),
              child: Container(
                margin: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode(context)
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: isDarkMode(context)
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(3, 3),
                      ),
                    ]),
                child: Container(
                    margin: EdgeInsets.all(3.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    )),
              ),
            ),
            SizedBox(
              width: 9.w,
            ),
            unitText != ''
                ? Flexible(
                    child: SizedBox(
                      height: 23.h,
                      child: Body1AutoText(
                        overflow: TextOverflow.ellipsis,
                        text: unitText,
                        fontSize: 16.sp,
                        minFontSize: 10,
                        color: isDarkMode(context)
                            ? Colors.white.withOpacity(0.6)
                            : HexColor.fromHex('#5D6A68'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
