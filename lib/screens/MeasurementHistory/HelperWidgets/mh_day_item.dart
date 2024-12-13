import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/day_detail_item.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class MHDayItem extends StatelessWidget {
  MHDayItem({
    required this.mHistoryModel,
    required this.sizeDifference,
    this.isDay = false,
    super.key,
  }){
    print(mHistoryModel.toJson());
  }

  final MHistoryModel mHistoryModel;
  final double sizeDifference;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    print(mHistoryModel.mHistoryBean.toJson());
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10.h - sizeDifference),
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
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 56.h - sizeDifference,
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
                          text: isDay ? mHistoryModel.getDate : mHistoryModel.getTime,
                          fontSize: 16.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('384341'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: mHistoryModel.showDetails,
                      builder: (BuildContext context, bool value, Widget? child) {
                        return Padding(
                          padding: EdgeInsets.only(right: 14.w),
                          child: Image.asset(
                            value ? 'asset/up_icon_small.png' : 'asset/down_icon_small.png',
                            height: 26.h,
                            width: 26.h,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              mHistoryModel.isShowDetails = !mHistoryModel.isShowDetails;
            },
          ),
          ValueListenableBuilder(
            valueListenable: mHistoryModel.showDetails,
            builder: (BuildContext context, bool value, Widget? child) {
              if (!value) {
                return SizedBox();
              }
              return Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  if ((mHistoryModel.mHistoryBean.sysDevice.isNotEmpty &&
                          mHistoryModel.mHistoryBean.diasDevice.isNotEmpty) ||
                      (mHistoryModel.mHistoryBean.aiSYS > 0 &&
                          mHistoryModel.mHistoryBean.aiDIAS > 0)) ...[
                    DayDetailItem(
                      iconPath: 'asset/Wellness/bloodpressure_icon.png',
                      title: 'Blood Pressure',
                      value: bpTitle,
                    ),
                  ],
                  if (mHistoryModel.mHistoryBean.hrDevice.isNotEmpty) ...[
                    DayDetailItem(
                      iconPath: 'asset/Wellness/hr_icon.png',
                      title: 'Heart Rate',
                      value: '${mHistoryModel.mHistoryBean.hrDevice}',
                    ),
                  ],
                  if (mHistoryModel.mHistoryBean.hrvDevice.isNotEmpty) ...[
                    DayDetailItem(
                      iconPath: 'asset/stress_icon.png',
                      title: 'Heart Rate Variability',
                      value: '${mHistoryModel.mHistoryBean.hrvDevice}',
                    ),
                  ],
                  // if (mHistoryModel.mHistoryBean.bg > 0 || mHistoryModel.mHistoryBean.bg1 > 0) ...[
                  //   DayDetailItem(
                  //     iconPath: 'asset/blood_glucose.png',
                  //     title: 'Blood Glucose',
                  //     value: mHistoryModel.mHistoryBean.bg > 0
                  //         ? '${mHistoryModel.mHistoryBean.bg.toStringAsFixed(2)}'
                  //         : '${mHistoryModel.mHistoryBean.bg1.toStringAsFixed(2)}',
                  //   ),
                  // ],
                  // if (mHistoryModel.mHistoryBean.measurementClass.isNotEmpty) ...[
                  //   DayDetailItem(
                  //     iconPath: 'asset/blood_glucose.png',
                  //     title: 'Glucose Level',
                  //     value: mHistoryModel.mHistoryBean.measurementClass,
                  //   ),
                  // ],
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String get bpTitle => '${mHistoryModel.getAISys.toStringAsFixed(0)}/${mHistoryModel.getAIDias.toStringAsFixed(0)}';
}
