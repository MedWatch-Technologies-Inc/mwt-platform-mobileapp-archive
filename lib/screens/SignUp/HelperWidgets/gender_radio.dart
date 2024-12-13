import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';

import '../../measurement_screen/cards/progress_card.dart';

class GenderRadio extends StatelessWidget {
  const GenderRadio({
    required this.value,
    required this.title,
    required this.iconAsset,
    this.selectedValue = 0,
    this.iconSize,
    this.onChange,
    super.key,
  });

  final int value;
  final int selectedValue;
  final String title;
  final String iconAsset;
  final Function(int value)? onChange;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(onChange!=null){
          onChange!(value);
        }
      },
      child: Container(
        height: 50.h,
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              height: iconSize ?? 22.h,
              color: AppColor.colorFF9E99,
            ),
            SizedBox(
              width: 15.w,
            ),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
