import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class TDetailItem extends StatelessWidget {
  const TDetailItem({
    required this.title,
    this.isLast = false,
    super.key,
  });

  final String title;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 25.h),
      decoration: BoxDecoration(
        borderRadius: isLast
            ? BorderRadius.only(
          bottomLeft: Radius.circular(10.h),
          bottomRight: Radius.circular(10.h),
        )
            : BorderRadius.circular(0.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Body1AutoText(
            text: 'Value',
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.8)
                : HexColor.fromHex('#384341'),
            fontSize: 14.sp,
            minFontSize: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Body1AutoText(
              text: title,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.8)
                  : HexColor.fromHex('#384341'),
              fontSize: 14.sp,
              minFontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
