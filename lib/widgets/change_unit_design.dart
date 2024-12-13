import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';

import 'package:health_gauge/widgets/text_utils.dart';

class ChangeUnitDesign extends StatelessWidget {
  final double? height;
  final List<Color>? insideShadowColor;
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function? onTapUpCallback;
  final Function? onTapDownCallback;
  final int? textContainerFlex;
  final int? arrowContainerFlex;
  ChangeUnitDesign(
      {
         this.height,
         this.text,
         this.fontWeight,
         this.fontSize,
         this.insideShadowColor,
         this.onTapDownCallback,
         this.onTapUpCallback,
         this.arrowContainerFlex,
         this.textContainerFlex
      });

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Row(
      children: [
        Expanded(

          flex: textContainerFlex?? 1,
          child: Container(
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.h),
                    bottomLeft: Radius.circular(10.h))),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: ConcaveDecoration(
                  depression: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.h),
                          bottomLeft: Radius.circular(10.h))),
                  colors: insideShadowColor),
              child: Center(
                key: Key('${text}UnitText'),

                // child: FittedBox(
                //   fit: BoxFit.scaleDown,
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     text,
                //     style: TextStyle(
                //       color: Theme.of(context).brightness == Brightness.dark
                //           ? Colors.white
                //           : HexColor.fromHex("#384341"),
                //       fontSize: fontSize,
                //     ),
                //     maxLines: 1,
                //     //  minFontSize: 8,
                //   ),
                // ),
                child: TitleText(
                  text: text!,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : HexColor.fromHex("#384341"),
                  fontSize: fontSize,
                  // maxLine: 1,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: arrowContainerFlex!,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.h),
                  bottomRight: Radius.circular(10.h)),
              color: HexColor.fromHex("#62CBC9"),
            ),
            child: Column(
              children: [
                GestureDetector(
                  key: Key('${text}ArrowUp'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.h),
                          bottomRight: Radius.circular(10.h)),
                    ),
                    height: height !/ 2,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        key: Key('arrowUp'),
                        child: Image.asset(
                      "asset/up_arrow.png",
                      width: 8.w,
                      height: 10.5.h,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : HexColor.fromHex("#E7EBF2"),
                    )),
                  ),
                  onTap: onTapUpCallback!(),
                ),
                GestureDetector(
                  key: Key('${text}ArrowDown'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.h),
                          bottomRight: Radius.circular(10.h)),
                    ),
                    height: height !/ 2,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Image.asset(
                      "asset/down_arrow.png",
                      width: 8.w,
                      height: 10.5.h,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : HexColor.fromHex("#E7EBF2"),
                    )),
                  ),
                  onTap: onTapDownCallback!(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
