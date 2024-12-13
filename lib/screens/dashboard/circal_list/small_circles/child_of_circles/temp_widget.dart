import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/utils/gloabals.dart';

class TempWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<TempModel?> temperatureNotifier;
  final GestureTapCallback onClickTemp;
  const TempWidget({
    Key? key,
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.temperatureNotifier,
    required this.onClickTemp,
  }) : super(key: key);

  @override
  _TempWidgetState createState() => _TempWidgetState();
}

class _TempWidgetState extends State<TempWidget> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return ValueListenableBuilder(
      valueListenable: widget.temperatureNotifier,
      builder: (BuildContext context, TempModel? model, Widget? child) {
        String strTemp = '';
        try {
          num tempNum;
          if(model?.tempInt != null && model?.tempInt != 0){
            tempNum = num.parse('${model?.tempInt}.${model?.tempDouble}');
          } else if(model?.realTemp is num) {
            tempNum = (model!.realTemp as num).toInt();
          } else {
            tempNum = num.parse('${model?.temperature}');
          }
          if(tempNum != 0.15) {
            if (tempUnit == 1) {
              var temp = (tempNum * 9 / 5) + 32;
              strTemp = '${removeTrailingZero(temp.toStringAsFixed(2))} °F';
            } else {
              strTemp = '$tempNum °C';
            }
          }else{
            connections.getTempData();
          }
        } catch (e) {
          print('Exception at temperatureNotifier $e');
        }


        return InkWell(
          onTap: widget.onClickTemp,
          child: ValueListenableBuilder(
            valueListenable: widget.isAnimatingNotifier,
            builder: (BuildContext context, bool? value, Widget? child) {
              return Visibility(
                visible: !(value??false),
                child: child??Container(),
              );
            },
            child: Container(
              width: 155.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: widget.selectedWidgetNotifier.value == 'temperature'
                        ? 55.h
                        : 50.h,
                    width: widget.selectedWidgetNotifier.value == 'temperature'
                        ? 55.h
                        : 50.h,
                    child: Image.asset(
                      'asset/temperature_55.png',
                      height:
                          widget.selectedWidgetNotifier.value == 'temperature'
                              ? 55.h
                              : 50.h,
                      width: widget.selectedWidgetNotifier.value == 'temperature'
                          ? 55.h
                          : 50.h,
                      //  color: AppColor.darkRed,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 120.h,
                    child: Center(
                      child: HeadlineText(
                        text: 'Temperature',
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
                        '$strTemp',
                        // '${(model?.tempInt) ?? '0'}.${(model?.tempDouble) ?? '0'}',
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

  String removeTrailingZero(String string) {
    if (!string.contains('.')) {
      return string;
    }
    string = string.replaceAll(RegExp(r'0*$'), '');
    if (string.endsWith('.')) {
      string = string.substring(0, string.length - 1);
    }
    return string;
  }
}
