import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
class CustomToggleContainer extends StatefulWidget {
 final int selectedUnit;
 final String 
 unitText1;
 final String unitText2;
 final double width;
 final GestureTapCallback unit1Selected;
 final GestureTapCallback unit2Selected;

 CustomToggleContainer({
   required this.selectedUnit,
   required this.unitText1,
   required this.unitText2,
   required this.unit1Selected,
   required this.unit2Selected,
   required this.width,
});
  @override
  _CustomToggleContainerState createState() => _CustomToggleContainerState();
}

class _CustomToggleContainerState extends State<CustomToggleContainer> {

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
      return Container(
        width: widget.width,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: widget.unit1Selected,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.selectedUnit == 0
                        ? null
                        : Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                  ),
                  child: Container(
                     key:Key('saveButtonUnitScreen'),
                    decoration: widget.selectedUnit == 1
                        ? ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.h),
                                bottomLeft: Radius.circular(10.h))),
                        depression: 3,
                        colors: [
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.8)
                              : HexColor.fromHex("#9F2DBC")
                              .withOpacity(0.2),
                          Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : Colors.white,
                        ])
                        : BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.h),
                          bottomLeft: Radius.circular(10.h)),
                      color: HexColor.fromHex("#62CBC9"),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(-2, -2),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex("#9F2DBC")
                              .withOpacity(0.20),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      key:Key('profileScreenKg') ,
                      child: toggleText(widget.unitText1, widget.selectedUnit == 0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: widget.unit2Selected,
                child: Container(
                  color: widget.selectedUnit == 1
                      ? null
                      : Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : AppColor.backgroundColor,
                  child: Container(
                    decoration: widget.selectedUnit == 0
                        ? ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.h),
                                bottomRight: Radius.circular(10.h))),
                        depression: 2,
                        colors: [
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.8)
                              : HexColor.fromHex("#9F2DBC")
                              .withOpacity(0.2),
                          Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : Colors.white,
                        ])
                        : BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.h),
                          bottomRight: Radius.circular(10.h)),
                      color: HexColor.fromHex("#62CBC9"),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(-2, -2),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex("#9F2DBC")
                              .withOpacity(0.15),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      key: Key('profileScreenMile'),
                      child: toggleText(widget.unitText2, widget.selectedUnit == 1),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

  Widget toggleText(String text, bool isSelected) {
    return AutoSizeText(
      text,
      style: TextStyle(
          color: isSelected
              ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColor.color384341
              : Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.38)
              : HexColor.fromHex("#7F8D8C"),
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      maxLines: 1,
      minFontSize: 8,
    );
//    return FittedTitleText(
//      text: text,
//      color: isSelected
//          ? Colors.white
//          : Theme.of(context).brightness == Brightness.dark
//              ? Colors.white.withOpacity(0.50)
//              : HexColor.fromHex("#384341"),
//      fontSize: 14.sp,
//      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//      // maxLine: 1,
//    );
  }
}

