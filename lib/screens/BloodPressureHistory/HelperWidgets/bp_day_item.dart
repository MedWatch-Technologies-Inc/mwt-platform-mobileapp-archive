import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/day_detail_item.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class BPDayItem extends StatelessWidget {
  BPDayItem({
    required this.bpHistoryModel,
    required this.sizeDifference,
    this.isDay = false,
    super.key,
  });

  final BPHistoryModel bpHistoryModel;
  final double sizeDifference;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
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
                          text: isDay ? bpHistoryModel.getDate : bpHistoryModel.getTime,
                          fontSize: 16.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('384341'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: bpHistoryModel.showDetails,
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
              bpHistoryModel.isShowDetails = !bpHistoryModel.isShowDetails;
            },
          ),
          ValueListenableBuilder(
            valueListenable: bpHistoryModel.showDetails,
            builder: (BuildContext context, bool value, Widget? child) {
              if (!value) {
                return SizedBox();
              }
              return Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  if (bpHistoryModel.sys > 0) ...[
                    DayDetailItem(
                      iconPath: 'asset/Wellness/bloodpressure_icon.png',
                      title: 'Systolic',
                      value: bpHistoryModel.sys.toStringAsFixed(1),
                    ),
                  ],
                  if (bpHistoryModel.dia > 0) ...[
                    DayDetailItem(
                      iconPath: 'asset/Wellness/bloodpressure_icon.png',
                      title: 'Diastolic',
                      value: bpHistoryModel.dia.toStringAsFixed(1),
                    ),
                  ],
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
}
