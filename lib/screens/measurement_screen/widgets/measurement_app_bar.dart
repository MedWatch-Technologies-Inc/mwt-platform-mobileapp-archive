import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_home.dart';
import 'package:health_gauge/screens/history/measurement_history.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/screens/measurement_screen/dialogs/measurement_help_dialog.dart';
import 'package:health_gauge/utils/constants.dart';

import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeasurementAppBar extends StatefulWidget {
  final ValueNotifier<int> measurementType;
  final MeasurementHistoryModel? measurementHistoryModel;
  final Function generateSampleDataAndGraph;
  final bool isCalibration;
  final GestureTapCallback onPressedSettings;
  final GestureTapCallback onPressedCalibration;

  const MeasurementAppBar(
      {Key? key,
      required this.measurementType,
      required this.measurementHistoryModel,
      required this.generateSampleDataAndGraph,
      required this.isCalibration,
      required this.onPressedSettings,
      required this.onPressedCalibration})
      : super(key: key);

  @override
  _MeasurementAppBarState createState() => _MeasurementAppBarState();
}

class _MeasurementAppBarState extends State<MeasurementAppBar> {
  @override
  Widget build(BuildContext context) {
    showMeasurementHelpDialog({bool? showDismissButton}) async {
      var dialog = MeasurementHelpDialog(showDismissButton: showDismissButton);
      showDialog(context: context, builder: (context) => dialog, useRootNavigator: true);
    }

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: isDarkMode(context)
              ? Colors.black.withOpacity(0.5)
              : HexColor.fromHex('#384341').withOpacity(0.2),
          offset: Offset(0, 2.0),
          blurRadius: 4.0,
        )
      ]),
      child: ValueListenableBuilder(
          valueListenable: widget.measurementType,
          builder: (context, value, child) {
            return AppBar(
              elevation: 0,
              leading: widget.measurementHistoryModel != null
                  ? IconButton(
                      key: Key('clickonBackbuttonfromMeasuremetScreen'),
                      padding: EdgeInsets.only(left: 15.w),
                      icon: Image.asset(
                        isDarkMode(context) ? 'asset/dark_leftArrow.png' : 'asset/leftArrow.png',
                        width: 13,
                        height: 22,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : widget.measurementType.value == 2 && Platform.isIOS
                      ? Container()
                      : IconButton(
                          padding: EdgeInsets.only(left: 15.w),
                          icon: Image.asset(
                            isDarkMode(context) ? 'asset/info_dark.png' : 'asset/info.png',
                            height: 33.h,
                            width: 33.h,
                          ),
                          onPressed: () {
                            showMeasurementHelpDialog(showDismissButton: true);
                          },
                        ),
              backgroundColor:
                  isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
              title: Row(
                children: [
                  widget.measurementType.value == 2 && Platform.isIOS
                      ? Container()
                      : IconButton(
                          padding: EdgeInsets.only(right: 15.w),
                          icon: Image.asset(
                            isDarkMode(context) ? 'asset/history_dark.png' : 'asset/history.png',
                            height: 33.h,
                            width: 33.h,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MHistoryHome(),
                                settings: RouteSettings(
                                  name: 'MHistoryHome',
                                ),
                              ),
                            );
                          },
                        ),
                  Expanded(
                    child: Center(
                      child: Body1AutoText(
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.measurementHistory),
                        fontSize: 18.sp,
                        color: HexColor.fromHex('62CBC9'),
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        minFontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                widget.measurementHistoryModel != null
                    ? SizedBox(
                        width: 33.h,
                      )
                    : IconButton(
                        padding: EdgeInsets.only(right: 18.w),
                        icon: Image.asset(
                          widget.measurementType.value == 2 && Platform.isIOS
                              ? isDarkMode(context)
                                  ? 'asset/refresh_dark.png'
                                  : 'asset/refresh.png'
                              : isDarkMode(context)
                                  ? 'asset/calibration_dark.png'
                                  : 'asset/calibration_icon.png',
                          height: 33.h,
                          width: 33.h,
                        ),
                        onPressed: widget.onPressedCalibration,
                      ),
                widget.measurementType.value == 1 || Platform.isAndroid
                    ? IconButton(
                        padding: EdgeInsets.only(right: 18.w),
                        icon: Image.asset(
                          isDarkMode(context) ? 'asset/settings_dark.png' : 'asset/settings.png',
                          height: 33.h,
                          width: 33.h,
                        ),
                        onPressed: widget.onPressedSettings)
                    : Container(),
              ],
            );
          }),
    );
  }
}
