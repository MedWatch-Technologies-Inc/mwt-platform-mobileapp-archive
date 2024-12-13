import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';

class SelectListItem extends StatelessWidget {
   final String title;
   final bool isSelected;
   final VoidCallback onTap;
   final bool? isColor;
   final Color? color;
   SelectListItem({
     required this.title,
     required this.isSelected,
     required this.onTap,
     this.isColor,
     this.color
   });

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35.h,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 6.h),
        child: Row(
          children: [
            isColor != null && isColor! ? Container(
              margin: EdgeInsets.only(left : 11.w),
              height: 16.h,
              width: 16.h,
              decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle
              )
            )
                : Container(),
            Padding(
              padding:  EdgeInsets.only(left: isColor != null && isColor! ? 23.w : 50.w),
              child: Text(
                this.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.white87
                      : AppColor.color384341
                ),
              ),
            ),
            Spacer(),
            this.isSelected ? Image.asset(
              'asset/check_icon.png',
              width: 33.h,
              height: 33.h,
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

