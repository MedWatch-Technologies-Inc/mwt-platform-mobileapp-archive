import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class DayDetailItem extends StatelessWidget {
  const DayDetailItem({
    required this.iconPath,
    required this.title,
    required this.value,
    this.isLast = false,
    super.key,
  });

  final String iconPath;
  final String title;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: isLast
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10.h),
                bottomRight: Radius.circular(10.h),
              )
            : BorderRadius.circular(0.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              iconPath,
              height: 24.h,
              width: 24.h,
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 2.5.w),
              child: Body1AutoText(
                text: title,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.8)
                    : HexColor.fromHex('#384341'),
                fontSize: 14.sp,
                minFontSize: 10,
              ),
            ),
            flex: 5,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 25.w),
              child: Body1AutoText(
                text: value,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.8)
                    : HexColor.fromHex('#384341'),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                align: TextAlign.right,
                minFontSize: 6,
              ),
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }
}
