import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/BloodPressureHistory/bp_history_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_detail_page.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_history_helper.dart';
import 'package:health_gauge/screens/tag/TagHistory/tag_history_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class OTWeekItem extends StatelessWidget {
  const OTWeekItem({
    required this.otDateDisplay,
    required this.onChange,
    super.key,
  });

  final OTDateDisplay otDateDisplay;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10.h),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                : Colors.white,
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(-4, -4),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.75)
                : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(otDateDisplay.isShowDetails ? 0.h : 10.h),
                  bottomRight: Radius.circular(otDateDisplay.isShowDetails ? 0.h : 10.h),
                  topLeft: Radius.circular(10.h),
                  topRight: Radius.circular(10.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10.h),
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            HexColor.fromHex('#CC0A00').withOpacity(0.15),
                            HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            HexColor.fromHex('#FF9E99').withOpacity(0.1),
                            HexColor.fromHex('#9F2DBC').withOpacity(0.023),
                          ],
                        ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Body1Text(
                          text: otDateDisplay.title,
                          fontSize: 16.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('384341'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: GestureDetector(
                        onTap: otDateDisplay.isPastDay
                            ? () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('No Data Available'),
                            duration: Duration(milliseconds: 500),
                          ));
                        }
                            : () async {
                          if (OTHistoryHelper().currentTab.value == HTab.week) {
                            OTHistoryHelper().selectedWeek.value =
                                DateFormat(DateUtil.ddMMMMyyyy).parse(otDateDisplay.title);
                          } else {
                            OTHistoryHelper().selectedMonth.value =
                                DateFormat(DateUtil.ddMMMMyyyy).parse(otDateDisplay.title);
                          }
                          await OTHistoryHelper().gayData();
                          Constants.navigatePush(OTDetailPage(), context);
                        },
                        child: Image.asset(
                          'asset/oxygen_55.png',
                          height: 24.h,
                          width: 24.h,
                          color: otDateDisplay.isPastDay ? Colors.blueGrey : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: onChange,
          ),
        ],
      ),
    );
  }
}
