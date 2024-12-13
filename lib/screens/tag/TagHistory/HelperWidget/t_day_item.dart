import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/day_detail_item.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/tag/TagHistory/HelperWidget/t_detail_item.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagResponse/tag_record_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class TDayItem extends StatelessWidget {
  TDayItem({
    required this.tagRecordModel,
    required this.sizeDifference,
    this.isDay = false,
    super.key,
  });

  final TagRecordModel tagRecordModel;
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
                    SizedBox(
                      width: 15.h,
                    ),
                    SizedBox(
                      height: 28,
                      width: 28,
                      child: imageWidget(tagRecordModel.tagImage.trim(), context),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Body1Text(
                          text: tagRecordModel.typeName.replaceAllMapped(
                              RegExp(r'\b\w'), (match) => match.group(0)!.toUpperCase()),
                          fontSize: 16.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('384341'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Body1Text(
                        text: isDay ? tagRecordModel.getDate : tagRecordModel.getTime,
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.87)
                            : HexColor.fromHex('384341'),
                      ),
                    ),
                    SizedBox(
                      width: 15.h,
                    ),
                    ValueListenableBuilder(
                      valueListenable: tagRecordModel.showDetails,
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
              tagRecordModel.isShowDetails = !tagRecordModel.isShowDetails;
            },
          ),
          ValueListenableBuilder(
            valueListenable: tagRecordModel.showDetails,
            builder: (BuildContext context, bool value, Widget? child) {
              if (!value) {
                return SizedBox();
              }
              return Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  TDetailItem(
                    title: tagRecordModel.tagValue.toStringAsFixed(2),
                  ),
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

  Widget imageWidget(String imageName, BuildContext context) {
    if (imageName.isEmpty) {
      imageName = 'asset/placeholder.png';
    }
    if (imageName.contains('asset')) {
      return Image.asset(
        imageName,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#62CBC9')
            : HexColor.fromHex('00AFAA'),
      );
    }
    if (imageName.contains('https') || imageName.contains('http')) {
      return Image.network(
        imageName,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#62CBC9')
            : HexColor.fromHex('00AFAA'),
      );
    }
    return Image.memory(
      base64Decode(imageName),
      color: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#62CBC9')
          : HexColor.fromHex('00AFAA'),
      gaplessPlayback: true,
    );
  }
}
