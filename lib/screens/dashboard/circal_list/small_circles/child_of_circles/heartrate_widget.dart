import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';

import '../../../../../utils/date_utils.dart';

class HeartRateWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<LineChartController?> hrGraphNotifier;
  final ValueNotifier<num?> currentHr;
  final ValueNotifier<int?> measurementDurationNotifier;
  final String lastHrDate;

  final DeviceModel? connectedDevice;

  const HeartRateWidget({
    Key? key,
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.hrGraphNotifier,
    required this.currentHr,
    required this.measurementDurationNotifier,
    required this.connectedDevice,
    required this.lastHrDate,
  }) : super(key: key);

  @override
  _HeartRateWidgetState createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget> {
  String hrValue = '0';

  String lastHrDetail = '';
  bool isHrMeasured = false;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
      valueListenable: widget.isAnimatingNotifier,
      builder: (BuildContext context, bool? value, Widget? child) {
        return Visibility(
          visible: !(value ?? false),
          child: child ?? Container(),
        );
      },
      child: ValueListenableBuilder(
        valueListenable: widget.hrGraphNotifier,
        builder:
            (BuildContext context, LineChartController? value, Widget? child) {
          var strHr = stringLocalization.getText(StringLocalization.hr);
          try {
            hrValue = '${(widget.currentHr.value ?? 0)}';
          } catch (e) {
            debugPrint('exception in heart rate widget $e');
          }
          if (widget.lastHrDate.isNotEmpty) {
            var date = DateTime.parse(widget.lastHrDate);
            lastHrDetail =
                DateUtil().getDateDifference(date, show24Hours: true);
          }
          return Center(
            child: Container(
              height: 180.h,
              width: 160.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25.h),
                        child: Image.asset(
                          'asset/heart_rate_55.png',
                          height:
                              widget.selectedWidgetNotifier.value == 'heartRate'
                                  ? 55.h
                                  : 50.h,
                          width:
                              widget.selectedWidgetNotifier.value == 'heartRate'
                                  ? 55.h
                                  : 50.h,
                          // color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#CC0A00'):getSelectedItemIndex() == 0 ? AppColor.selectedItemColor:null,
                          //  color: AppColor.darkRed,
                        ),
                      ),
                      Visibility(
                        visible: !(dashBoardGlobalKey.currentState
                                ?.heartRateSecondsTimer?.isActive ??
                            false),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 9.05.h),
                            SizedBox(
                              width: 120.w,
                              child: AutoSizeText(
                                strHr.toUpperCase(),
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF')
                                            .withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: 16.sp),
                                textAlign: TextAlign.center,
                                minFontSize: 5,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value != null
                          ? Visibility(
                              visible: (dashBoardGlobalKey.currentState
                                          ?.heartRateSecondsTimer?.isActive ??
                                      false) &&
                                  !isLeadOff(),
                              child: Container(
                                height: 90.h,
                                width: MediaQuery.of(context).size.width,
                                child: LineChart(value),
                              ),
                            )
                          : Container(),
                      (value != null && widget.connectedDevice != null)
                          ? Visibility(
                              visible: !(dashBoardGlobalKey.currentState
                                      ?.heartRateSecondsTimer?.isActive ??
                                  false),
                              child: HrText(
                                measurementDurationNotifier:
                                    widget.measurementDurationNotifier,
                                connectedDevice: widget.connectedDevice,
                                value: value,
                                hrValue: hrValue,
                              ),
                            )
                          : HrText(
                              measurementDurationNotifier:
                                  widget.measurementDurationNotifier,
                              value: value,
                              hrValue: hrValue,
                            ),
                      Visibility(
                        visible: isLeadOff(),
                        child: SizedBox(
                          width: 90.w,
                          height: 90.h,
                          child: Center(
                            child: AutoSizeText(
                              stringLocalization
                                  .getText(StringLocalization.touchElectrod),
                              style: TextStyle(
                                  color: textColorForLeadOff(context),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              minFontSize: 8,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color textColorForLeadOff(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (checkLength()) {
      return isDarkMode
          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
          : HexColor.fromHex('#384341');
    }
    return AppColor.selectedItemColor;
  }

  bool isLeadOff() {
    var now = DateTime.now();
    DateTime then =
        (dashBoardGlobalKey.currentState?.lastRecordDate) ?? DateTime.now();
    var isTimerActive =
        dashBoardGlobalKey.currentState?.heartRateSecondsTimer?.isActive ??
            false;
    debugPrint('------------ ${checkLength()}');
    return isTimerActive &&
        (now.difference(then).inSeconds > 5 || checkLength());
  }

  bool checkLength() =>
      (dashBoardGlobalKey.currentState?.ecgAvgList.length ?? 0) < 200;
}

class HrText extends StatefulWidget {
  final ValueNotifier<int?> measurementDurationNotifier;
  final DeviceModel? connectedDevice;
  final LineChartController? value;
  final String hrValue;

  const HrText({
    Key? key,
    required this.measurementDurationNotifier,
    this.connectedDevice,
    required this.value,
    required this.hrValue,
  }) : super(key: key);

  @override
  _HrTextState createState() => _HrTextState();
}

class _HrTextState extends State<HrText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAndGetConnectedDevice(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return SizedBox(
          width: 80.w,
          child: AutoSizeText(
            widget.hrValue.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                fontSize: 24.sp,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            minFontSize: 8,
            maxLines: 1,
          ),
        );
      },
    );
  }

  checkAndGetConnectedDevice() async {
    var measurementType = preferences!.getInt(Constants.measurementType) ?? 1;
    if (measurementType == 2 && Platform.isIOS) {
      return Constants.e66;
    }

    var value =
        preferences!.getString(Constants.connectedDeviceAddressPrefKey) ?? '';
    if (value.isNotEmpty) {
      var val = jsonDecode(value);
      if (val is Map) {
        var connectedDevice = DeviceModel.fromMap(val);
        return connectedDevice.sdkType;
      }
    }
    return Constants.e66;
  }
}
