import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
// import 'package:flutter_screenutil/size_extension.dart';

import 'package:health_gauge/widgets/text_utils.dart';

class GradientButton extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;
  final double borderRadius;
  final List<Color> insideShadowColor;
  final String text;
  final double fontsize;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final Color? fontColor;
  final Function()? onTapCallback;

  GradientButton(
      {required this.height,
      required this.width,
      this.margin,
      required this.alignment,
      required this.borderRadius,
      required this.insideShadowColor,
      required this.text,
      required this.fontsize,
      required this.fontWeight,
      required this.backgroundColor,
      this.fontColor,
      required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : Colors.white,
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(-5, -5),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex("#D1D9E6"),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(5, 5),
            ),
          ]),
      child: Container(
        margin: margin,
        alignment: alignment,
        decoration: ConcaveDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            depression: 11,
            colors: insideShadowColor),
        child: TextButton(
          onPressed: onTapCallback,
          // child: FittedBox(
          //   fit: BoxFit.scaleDown,
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     StringLocalization.of(context).getText(text).toUpperCase(),
          //     style: TextStyle(
          //       fontSize: fontsize,
          //       fontWeight: fontWeight,
          //     ),
          //   ),
          // ),
          child: TitleText(
            text: StringLocalization.of(context).getText(text).toUpperCase(),
            fontSize: fontsize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
    /*Container(
     margin: margin,
     width: width,
     alignment: alignment,
     height: height,
     decoration: ConcaveDecoration(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(borderRadius),
         ),
         depression: 11,
         colors: colors),
     child: AutoSizeText(
       StringLocalization.of(context)
           .getText(text)
           .toUpperCase(),
       style: TextStyle(
         fontSize: fontsize,
         fontWeight: fontWeight,
         color: Theme.of(context).brightness ==
             Brightness.dark
             ? HexColor.fromHex("#111B1A")
             : Colors.white,
       ),
     ),
   );*/
  }
}
