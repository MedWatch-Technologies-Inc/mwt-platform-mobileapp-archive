import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/utils/Synchronisation/watch_sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class WeightWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final GestureTapCallback onClickWeightWidget;
  final ValueNotifier<num?> weightNotifier;

  const WeightWidget({
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.onClickWeightWidget,
    required this.weightNotifier,
    Key? key,
  }) : super(key: key);

  @override
  _WeightWidgetState createState() => _WeightWidgetState();
}

class _WeightWidgetState extends State<WeightWidget> {
  String strUnit = UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
      ? 'kg'
      : stringLocalization.getText(StringLocalization.lb);

  String weight = '__.__';

  @override
  void initState() {
    try {
      var tempWeight = num.tryParse(globalUser!.weight.toString()) ?? 0.0;
      var tempWeightUnit = (num.tryParse(globalUser!.weightUnit.toString()) ?? 1.0).toInt();
      if (tempWeight != null) {
        if (UnitExtension.getUnitType(tempWeightUnit) == UnitTypeEnum.imperial) {
          weight = (tempWeight * 2.20462).toStringAsFixed(1);
        } else {
          weight = (tempWeight).toStringAsFixed(1);
        }
      }
      strUnit = UnitExtension.getUnitType(tempWeightUnit) == UnitTypeEnum.metric
          ? 'kg'
          : stringLocalization.getText(StringLocalization.lb);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      var tempWeight = num.tryParse(globalUser!.weight.toString()) ?? 0.0;
      var tempWeightUnit = (num.tryParse(globalUser!.weightUnit.toString()) ?? 1.0).toInt();
      if (tempWeight != null) {
        if (UnitExtension.getUnitType(tempWeightUnit) == UnitTypeEnum.imperial) {
          // weight = (tempWeight * 2.205).toStringAsFixed(1);
          weight = (tempWeight * 2.20462).toStringAsFixed(1);
        } else {
          weight = (tempWeight).toStringAsFixed(1);
        }
      }
      strUnit = UnitExtension.getUnitType(tempWeightUnit) == UnitTypeEnum.metric
          ? 'kg'
          : stringLocalization.getText(StringLocalization.lb);
    } catch (e) {
      print(e);
    }
    return GestureDetector(
      key: Key('weightWidget'),
      onTap: widget.onClickWeightWidget,
      child: ValueListenableBuilder(
        valueListenable: widget.isAnimatingNotifier,
        builder: (BuildContext context, bool? value, Widget? child) {
          return Visibility(
            visible: !(value ?? false),
            child: child ?? Container(),
          );
        },
        child: Container(
          height: 180.h,
          width: 155.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: widget.selectedWidgetNotifier.value == 'weight' ? 55.h : 50.h,
                width: widget.selectedWidgetNotifier.value == 'weight' ? 55.h : 50.h,
                child: Image.asset(
                  'asset/weight_55.png',
                  height: widget.selectedWidgetNotifier.value == 'weight' ? 55.h : 50.h,
                  width: widget.selectedWidgetNotifier.value == 'weight' ? 55.h : 50.h,
                  gaplessPlayback: true,
                ),
              ),
              SizedBox(height: 9.h),
              AutoSizeText(
                'Weight',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
                minFontSize: 8,
                maxLines: 1,
              ),
              Container(
                width: 110.w,
                height: 30.h,
                child: Center(
                  child: AutoSizeText(
                    '$weight $strUnit',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                    minFontSize: 12,
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
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
