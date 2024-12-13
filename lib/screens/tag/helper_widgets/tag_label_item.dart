import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class TagLabelItem extends StatelessWidget {
  const TagLabelItem({required this.tagItem, required this.onTap, super.key});

  final TagLabel tagItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      height: 119.h,
      child: Column(
        children: [
          InkWell(
            key: Key('icon_${tagItem.iD}'),
            onTap: onTap,
            child: Container(
              height: 85.w,
              width: 85.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white.withOpacity(0.7),
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
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: tagIcon(context),
              ),
            ),
          ),
          SizedBox(height: 6.0.h),
          Expanded(
            child: SizedBox(
              height: 23.w,
              width: 85.w,
              child: Body1Text(
                text: StringLocalization.of(context).getTextFromEnglish(tagItem.labelName ?? ''),
                maxLine: 1,
                align: TextAlign.center,
                fontSize: 14.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                    : HexColor.fromHex('#5D6A68'),
                fontWeight: FontWeight.w700,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tagIcon(BuildContext context) {
    try {
      if (tagItem.imageName.isNotEmpty) {
        if (tagItem.imageName.contains('asset')) {
          return Image.asset(
            'asset/strees_icon.png',
            height: 40.0.h,
          );
        }
        return Image.network(
          tagItem.imageName,
          color:
              Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#00AFAA') : null,
          height: 40.0.h,
        );
      }
    } catch (e) {
      print(e);
    }
    return Image.asset(
      'asset/placeholder.png',
      height: 40.0.h,
    );
  }
}
