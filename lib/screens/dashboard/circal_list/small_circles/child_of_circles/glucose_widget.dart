import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class GlucoseWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final GestureTapCallback onClickGlucoseWidget;
  final ValueNotifier<UserModel?> userModelNotifier;
  final ValueNotifier<WeightMeasurementModel?> weightModelNotifier;
  final ValueNotifier<num?> targetWeightNotifier;

  const GlucoseWidget({
    Key? key,
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.onClickGlucoseWidget,
    required this.userModelNotifier,
    required this.weightModelNotifier,
    required this.targetWeightNotifier,
  }) : super(key: key);

  @override
  _GlucoseWidgetState createState() => _GlucoseWidgetState();
}

class _GlucoseWidgetState extends State<GlucoseWidget> {
  String strTargetWeight = '0 kg';
  String strWeight = '0 kg';
  String lastWeightMeasurementDetail = '';

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return ValueListenableBuilder(
      valueListenable: widget.weightModelNotifier,
      builder: (BuildContext context, WeightMeasurementModel? value, Widget? child) {
        num weight = 50.0;
        if (value != null && value.weightSum != null) {
          weight = value.weightSum!;
        } else {
          weight = double.tryParse(globalUser?.weight ?? '50') ?? 50.0;
          // double.parse('${widget.userModelNotifier?.value?.weight ?? 0}');
        }
        try {
          lastWeightMeasurementDetail =
              DateUtil().getDateDifference(value?.date ?? DateTime.now());
        } catch (e) {
          print('Exceptions in GlucoseWidget $e');
        }

        weightUnit = preferences!.getInt(Constants.wightUnitKey) ?? UnitTypeEnum.metric.getValue();
        if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
          // strTargetWeight = (widget.targetWeightNotifier.value! * 2.205)
          //     .toStringAsFixed(2)
          //     .padLeft(2, '0');
          strTargetWeight = (widget.targetWeightNotifier.value! * 2.20462)
              .toStringAsFixed(2)
              .padLeft(2, '0');
          strTargetWeight = removeTrailingZero(strTargetWeight);
          strTargetWeight = strTargetWeight +
              ' ${stringLocalization.getText(StringLocalization.lb).toUpperCase()}';

          // strWeight = weight == 0.0
          //     ? (1).toStringAsFixed(2).padLeft(2, '0')
          //     : (weight * 2.205).toStringAsFixed(2).padLeft(2, '0');
          strWeight = weight == 0.0
              ? (1).toStringAsFixed(2).padLeft(2, '0')
              : (weight * 2.20462).toStringAsFixed(2).padLeft(2, '0');
          strWeight = removeTrailingZero(strWeight);
          strWeight = strWeight +
              ' ${stringLocalization.getText(StringLocalization.lb).toUpperCase()}';
        } else {
          strTargetWeight = (widget.targetWeightNotifier.value)!.toStringAsFixed(2).padLeft(2, '0');
          strTargetWeight = removeTrailingZero(strTargetWeight);
          strTargetWeight = strTargetWeight +
              ' ${stringLocalization.getText(StringLocalization.kg).toUpperCase()}';

          strWeight = weight == 0.0
              ? (1).toStringAsFixed(2).padLeft(2, '0')
              : (weight).toStringAsFixed(2).padLeft(2, '0');
          strWeight = removeTrailingZero(strWeight);
          strWeight = strWeight +
              ' ${stringLocalization.getText(StringLocalization.kg).toUpperCase()}';
        }
        if (strWeight.isEmpty) {
          strWeight = '${widget.userModelNotifier.value?.weight ?? ''}';
        }
        return GestureDetector(
          key: Key('GlucoseWidget'),
          onTap: widget.onClickGlucoseWidget,
          child: ValueListenableBuilder(
            valueListenable: widget.isAnimatingNotifier,
            builder: (BuildContext context, bool? value, Widget? child) {
              return Visibility(
                visible: !(value ?? false),
                child: child??Container(),
              );
            },
            child: Container(
              height: 180.h,
              width: 155.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: widget.selectedWidgetNotifier.value == 'bloodGlucose'
                        ? 55.h
                        : 50.h,
                    width: widget.selectedWidgetNotifier.value == 'bloodGlucose'
                        ? 55.h
                        : 50.h,
                    child: Image.asset(
                      'asset/ecg_icon_selected.png',
                      height: widget.selectedWidgetNotifier.value == 'bloodGlucose'
                          ? 55.h
                          : 50.h,
                      width: widget.selectedWidgetNotifier.value == 'bloodGlucose'
                          ? 55.h
                          : 50.h,
                      gaplessPlayback: true,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Container(
                    width: 120.w,
                    height: 23.h,
                    child: Center(
                      child: HeadlineText(
                        text:
                        '${stringLocalization.getText(StringLocalization.bloodGlucose).toUpperCase()} ',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 16.sp,
                        maxLine: 1,
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                  /*Container(
                    width: 110.w,
                    height: 30.h,
                    child: Center(
                      child: AutoSizeText(
                        '$strWeight',
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
                  ),*/
                  SizedBox(height: 5.h),
                  Container(
                    height:
                    (lastWeightMeasurementDetail.trim().isEmpty)
                        ? 0
                        : 17.h,
                    width: 80.w,
                    child: Center(
                      child: AutoSizeText(
                        '$lastWeightMeasurementDetail',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                        ),
                        maxLines: 1,
                        minFontSize: 6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
