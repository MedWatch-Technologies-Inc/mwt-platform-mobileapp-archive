import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_gauge/value/app_color.dart';

class ChildOfCircleView extends StatefulWidget {
  final int index;
  final String image;
  final Widget widget;
  final String widgetName;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<bool?> isAnimatingNotifier;

  const ChildOfCircleView({
    Key? key,
    required this.index,
    required this.image,
    required this.widget,
    required this.widgetName,
    required this.selectedWidgetNotifier,
    required this.isAnimatingNotifier,
  }) : super(key: key);

  @override
  _ChildOfCircleViewState createState() => _ChildOfCircleViewState();
}

class _ChildOfCircleViewState extends State<ChildOfCircleView> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? selectedWidget, Widget? child) {
        if ((selectedWidget == widget.widgetName && !(widget.isAnimatingNotifier.value??false))) {
          return widget;
        }
        if (widget.image.contains('svg')) {
          return Center(
            child: SizedBox(
              height: 25.h,
              width: 25.h,
              child: SvgPicture.asset(
                widget.image,
                height: 25.h,
                width: 25.h,
                color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('FF9E99') : AppColor.unSelectedItemColor,
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.zero,

          key:widget.image=='asset/stress_butt_off.png'?Key('smallHrvCircle'):Key('someelsekey'),

          child: Tooltip(
            message: (""),

            child: Padding(
              padding: EdgeInsets.zero,
              key:widget.image=='asset/temperature_butt_off.png'?Key('smallTempCircle'):Key('someelsekey'),
                  
                      child: Padding(
                        padding:EdgeInsets.all(0),
                        key:widget.image == 'asset/hr_butt_off.png' ?Key('smallHeartcircle'):Key('someElseWidget'),
                                          child: Padding(
                key:widget.image=='asset/distance_butt_off.png'?Key('smallDistanceCircle'):Key('someElseWidget'),
                padding: const EdgeInsets.all(0),
                child: Center(
                  key: widget.image == 'asset/weight_butt_off.png'
                        ? Key('smallWeightCircle')
                        :Key('someElseWidget'),
                  child: Image.asset(
                    widget.image,
                    height: 64.h,
                    width: 64.h,
                    fit: BoxFit.contain,
                    // color: AppColor.unSelectedItemColor,
                  ),
                ),
              ),
                      ),
            ),
          ),
        );
      },
    );
  }
}
