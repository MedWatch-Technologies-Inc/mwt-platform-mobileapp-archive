import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/user_data.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class EstimateDialog extends StatelessWidget {
  final int? SBP;
  final int? DBP;
  final int? HR;

  final Map<dynamic, dynamic>? result;
  final bool isOs;
  final bool isResearcher;
  final bool isTFLData;
  final bool isAIData;
  final bool isTrainingEnable;
  final TextEditingController hrCalibrationTextEditController;
  final TextEditingController sbpCalibrationTextEditController;
  final TextEditingController dbpCalibrationTextEditController;

  final Function? onOkClick;

  const EstimateDialog({
    required this.SBP,
    required this.DBP,
    required this.HR,
    required this.result,
    required this.isResearcher,
    required this.isTFLData,
    required this.isAIData,
    required this.isOs,
    required this.hrCalibrationTextEditController,
    required this.sbpCalibrationTextEditController,
    required this.dbpCalibrationTextEditController,
    required this.isTrainingEnable,
    this.onOkClick,
    Key? key,
  }) : super(key: key);

  bool get isOSM =>
      (preferences?.getBool(Constants.isOscillometricEnableKey) ?? false) ||
      (preferences?.getBool(Constants.isOscillometricEnableKey1) ?? false);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          padding: EdgeInsets.only(top: 27.h, left: 20.w, right: 10.w),
          width: 309.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: 25.h,
                    child: TitleText(
                      text: 'Result',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                  ),
                ),
                SizedBox(height: 15.0.h),
                if (!isAIData && !isTFLData) ...[
                  SizedBox(
                    height: 25.h,
                    child: TitleText(
                      text: 'Device data',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      maxLine: 1,
                    ),
                  ),
                  SizedBox(height: 15.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 25.h,
                        child: TitleText(
                          text: 'HR : $HR',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                        child: TitleText(
                          text: 'Sys: $SBP',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                        child: TitleText(
                          text: 'Dia: $DBP',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                        ),
                      ),
                    ],
                  ),
                ],
                if (isOSM) ...[
                  SizedBox(height: 15.0.h),
                  UserData(
                    hrCalibrationTextEditController: TextEditingController(
                        text: hrCalibrationTextEditController.text.toString().isEmpty
                            ? '--'
                            : hrCalibrationTextEditController.text.toString()),
                    sbpCalibrationTextEditController: TextEditingController(
                        text: sbpCalibrationTextEditController.text.toString().isEmpty
                            ? '--'
                            : sbpCalibrationTextEditController.text.toString()),
                    dbpCalibrationTextEditController: TextEditingController(
                        text: dbpCalibrationTextEditController.text.toString().isEmpty
                            ? '--'
                            : dbpCalibrationTextEditController.text.toString()),
                  ),
                ],
                if (isAIData) ...[AIData(result!, context)],
                if (isTFLData) ...[tflData(result!, context)],
                // !isTflData ? AIData(result!, context) : Container(),
                // IsResearcher ? glucoseData(result!, context) : Container(),
                // isTflData ? tflData(result!, context) : Container(),
                SizedBox(height: 15.0.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    key: Key('clickonOkButton'),
                    onTap: () {
                      hrCalibrationTextEditController.clear();
                      sbpCalibrationTextEditController.clear();
                      dbpCalibrationTextEditController.clear();
                      Navigator.of(context, rootNavigator: true).pop();
                      Future.delayed(Duration(milliseconds: 100), () {
                        if (onOkClick != null) {
                          onOkClick!();
                        }
                      });
                    },
                    child: Container(
                      height: 25.h,
                      width: 50.w,
                      child: TitleText(
                        text: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: HexColor.fromHex('#00AFAA'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                )
              ],
            ),
          ),
        ));
  }

  Widget glucoseData(Map<dynamic, dynamic> result, BuildContext context) {
    var bloodglucose =
        result['Class'].toString().isEmpty ? '' : '(${result['BG1']} ${result['Unit1']})';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 25.h,
          child: TitleText(
            text: 'AI Glucose data',
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                : HexColor.fromHex('#384341'),
            maxLine: 1,
          ),
        ),
        SizedBox(height: 15.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 25.h,
              child: TitleText(
                text: 'BG: ${result['BG']} ${result['Unit']} $bloodglucose',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0.h),
        result['Class'] == null || result['Class'].toString().isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 25.h,
                    child: TitleText(
                      text: 'Class: ${result['Class']}',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget AIData(Map<dynamic, dynamic> result, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.0.h),
        SizedBox(
          height: 25.h,
          child: TitleText(
            text: 'Cloud AI Estimation',
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
        ),
        SizedBox(height: 15.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 25.h,
              child: TitleText(
                text: 'Sys: ${result['Sys']}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
            SizedBox(
              height: 25.h,
              child: TitleText(
                text: 'Dia: ${result['Dia']}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0.h)
      ],
    );
  }

  Widget tflData(Map<dynamic, dynamic> result, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.0.h),
        SizedBox(
          height: 25.h,
          child: TitleText(
            text: 'Edge AI Estimation',
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                : HexColor.fromHex('#384341'),
            maxLine: 1,
          ),
        ),
        SizedBox(height: 15.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 25.h,
              child: TitleText(
                text:
                    'Sys: ${double.parse(result['Sys Predication'].toString().contains("-") ? result['Sys Predication'].toString().replaceAll('-', '') : result['Sys Predication'].toString()).toStringAsFixed(0)}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
            SizedBox(
              height: 25.h,
              child: TitleText(
                text:
                    'Dia: ${double.parse(result['Dias Predication'].toString().contains("-") ? result['Dias Predication'].toString().replaceAll('-', '') : result['Dias Predication'].toString()).toStringAsFixed(0)}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
