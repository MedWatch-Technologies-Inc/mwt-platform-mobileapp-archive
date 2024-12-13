import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/calendar/custom_alert.dart';
import 'package:health_gauge/screens/calendar/select_week_days.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class CustomAlertScreen extends StatefulWidget {
  @override
  _CustomAlertScreenState createState() => _CustomAlertScreenState();
}

class _CustomAlertScreenState extends State<CustomAlertScreen> {
  List dayList = List<int>.generate(30, (i) => i + 1);
  List<String> dayWeekMonthList = ['days', 'weeks', 'months', 'years'];
  String dayWeekMonthValue = 'days';
  int defaultValue = 1;
  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#7F8D8C')
          : HexColor.fromHex('#384341'),
      body: Padding(
        padding: EdgeInsets.only(top: 50.0.h),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.h),
                  topRight: Radius.circular(20.h))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 16.w, top: 26.h),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Theme.of(context).brightness == Brightness.dark
                              ? Image.asset(
                                  'asset/dark_leftArrow.png',
                                  width: 13,
                                  height: 22,
                                )
                              : Image.asset(
                                  'asset/leftArrow.png',
                                  width: 13,
                                  height: 22,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 27.w,
                      ),
                      Text(
                        'Custom',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 13.w),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: HexColor.fromHex('#00AFAA'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 15.0.h, left: 66.w),
                child: Text(
                  'Every $selectedValue $dayWeekMonthValue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                  ),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 18.h),
                  height: 35.h,
                  width: 259.w,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 2.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, -2.h),
                    ),
                  ]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : HexColor.fromHex('#F2F2F2'),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#212D2B')
                                : HexColor.fromHex('#FFFFFF'),
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                          ]),
                    ),
                    height: 35.h,
                    width: 259.w,
                    child: RotatedBox(
                      quarterTurns: 135,
                      child: CustomCupertinoPicker(
                        backgroundColor: Colors.transparent,
                        scrollController: FixedExtentScrollController(
                            initialItem: dayList.indexOf(1)),
                        itemExtent: 40.w,
                        children: List.generate(dayList.length, (index) {
                          return RotatedBox(
                            quarterTurns: 45,
                            child: Container(
                              child: Center(
                                child: TitleText(
                                  text: dayList[index]
                                      // .toStringAsFixed(2)
                                      .toInt()
                                      .toString(),
                                  // .replaceAll(regex, ''),
                                  color: defaultValue == dayList[index]
                                      ? Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.87)
                                          : HexColor.fromHex('#384341')
                                              .withOpacity(0.87)
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.6)
                                          : HexColor.fromHex('#5D6A68'),
                                  fontWeight: defaultValue == dayList[index]
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          );
                        }),
                        onSelectedItemChanged: (int value) {
                          selectedValue = dayList[value];
                          print('=================$selectedValue');
                          defaultValue = dayList[value];
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 27.h,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 18.h),
                  height: 35.h,
                  width: 259.w,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 2.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, -2.h),
                    ),
                  ]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : HexColor.fromHex('#F2F2F2'),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#212D2B')
                                : HexColor.fromHex('#FFFFFF'),
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : HexColor.fromHex('#E7EBF2'),
                          ]),
                    ),
                    height: 35.h,
                    width: 259.w,
                    child: RotatedBox(
                      quarterTurns: 135,
                      child: CustomCupertinoPicker(
                        backgroundColor: Colors.transparent,
                        scrollController: FixedExtentScrollController(
                            initialItem: dayWeekMonthList.indexOf('days') ),
                        itemExtent: 80.w,
                        children: List.generate(dayWeekMonthList.length, (index) {
                          return RotatedBox(
                            quarterTurns: 45,
                            child: Container(
                              child: Center(
                                child: TitleText(
                                  text: dayWeekMonthList[index]
                                  // .toStringAsFixed(2)
                                  ,
                                  // .replaceAll(regex, ''),
                                  color: dayWeekMonthValue == dayWeekMonthList[index]
                                      ? Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.87)
                                          : HexColor.fromHex('#384341')
                                              .withOpacity(0.87)
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.6)
                                          : HexColor.fromHex('#5D6A68'),
                                  fontWeight:
                                      dayWeekMonthValue == dayWeekMonthList[index]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          );
                        }),
                        onSelectedItemChanged: (int value) {
                          // selectedValue = dayWeekMonthList[value];
                          print('=================$selectedValue');
                          dayWeekMonthValue = dayWeekMonthList[value];
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 41.h,),
              dayWeekMonthValue == 'weeks' ? Padding(
                padding: EdgeInsets.only(left: 66.w),
                child: InkWell(
                  onTap: (){
                    Constants.navigatePush( SelectWeekDayScreen(), context);
                  },
                  child: Text(
                    'On Fridays',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                  ),
                ),
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
