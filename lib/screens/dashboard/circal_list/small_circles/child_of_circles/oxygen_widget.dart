import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class OxygenWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<num?> oxygenNotifier;
  final GestureTapCallback onClickOxygen;

  const OxygenWidget({
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.oxygenNotifier,
    required this.onClickOxygen,
    Key? key,
  }) : super(key: key);

  @override
  _OxygenWidgetState createState() => _OxygenWidgetState();
}

class _OxygenWidgetState extends State<OxygenWidget> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return ValueListenableBuilder(
      valueListenable: widget.oxygenNotifier,
      builder: (BuildContext context, num? oxygenValue, Widget? child) {
        return InkWell(
          onTap: widget.onClickOxygen,
          child: ValueListenableBuilder(
            valueListenable: widget.isAnimatingNotifier,
            builder: (BuildContext context, bool? value, Widget? child) {
              return Visibility(
                visible: !(value ?? false),
                child: child ?? Container(),
              );
            },
            child: Container(
              width: 155.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: widget.selectedWidgetNotifier.value == 'oxygen' ? 55.h : 50.h,
                    width: widget.selectedWidgetNotifier.value == 'oxygen' ? 55.h : 50.h,
                    child: Image.asset(
                      'asset/oxygen_55.png',
                      height: widget.selectedWidgetNotifier.value == 'oxygen' ? 55.h : 50.h,
                      width: widget.selectedWidgetNotifier.value == 'oxygen' ? 55.h : 50.h,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 120.h,
                    child: Center(
                      child: HeadlineText(
                        text: 'SPO2',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 16.sp,
                        maxLine: 1,
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    width: 110.h,
                    child: Center(
                      child: AutoSizeText(
                        oxygenValue!=null && oxygenValue > 0 ? '$oxygenValue %' : 'No Data',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                        minFontSize: 12,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
