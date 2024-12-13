import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/child_of_circles/blood_pressure_widget.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/child_of_circles/heartrate_widget.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/child_of_circles/hrv_widget.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/child_of_circles/oxygen_widget.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/child_of_circles/weight_widget.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/small_circle.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/small_circle_fixed.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';

class CircularList extends StatefulWidget {
  final ValueNotifier<UserModel?> userNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<int?> measurementDurationNotifier;

  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<LineChartController?> hrGraphNotifier;

  // final ValueNotifier<MeasurementHistoryModel?> ecgInfoReadingModelNotifier;

  final ValueNotifier<num?> currentHrNotifier;
  final ValueNotifier<num?> currentSysNotifier;
  final ValueNotifier<num?> currentDiaNotifier;
  final ValueNotifier<num?> currentHRVNotifier;
  final ValueNotifier<num?> currentWeightNotifier;
  final ValueNotifier<num?> currentOxygenNotifier;

  final GestureTapCallback onClickBloodPressureWidget;
  final GestureTapCallback onClickHRV;
  final GestureTapCallback onClickWeightWidget;
  final GestureTapCallback onClickHRWidget;
  final GestureTapCallback onClickOxygenWidget;
  final ValueChanged onClickHRSmallCircle;
  final DeviceModel? connectedDevice;
  final bool isAiModeSelected;

  const CircularList({
    required this.userNotifier,
    required this.selectedWidgetNotifier,
    required this.measurementDurationNotifier,
    required this.isAnimatingNotifier,
    required this.hrGraphNotifier,
    required this.currentHrNotifier,
    required this.onClickBloodPressureWidget,
    required this.onClickHRV,
    required this.onClickHRWidget,
    required this.onClickHRSmallCircle,
    required this.onClickWeightWidget,
    required this.onClickOxygenWidget,
    required this.connectedDevice,
    required this.isAiModeSelected,
    required this.currentSysNotifier,
    required this.currentDiaNotifier,
    required this.currentHRVNotifier,
    required this.currentWeightNotifier,
    required this.currentOxygenNotifier,
    Key? key,
    // required this.ecgInfoReadingModelNotifier,
  }) : super(key: key);

  @override
  _CircularListState createState() => _CircularListState();
}

class _CircularListState extends State<CircularList> {
  late List<String> homeScreenItems;
  List<double> listOfAngle = [260, 220, 180, 140, 100];
  int tick = 0;
  int callValue = 0;

  @override
  Widget build(BuildContext context) {
    listOfAngle = [260, 220, 180, 140, 100];
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? selected, Widget? child) {
        var bloodPressureProgressColor = AppColor.purpleColor;
        var heightOfDevice = MediaQuery.of(context).size.height.round();

        homeScreenItems = [
          'bloodPressure',
          'heartRate',
          'hrv',
          'oxygen',
          'weight',
        ];
        if (!homeScreenItems.contains(widget.selectedWidgetNotifier.value) &&
            widget.selectedWidgetNotifier.value != 'a') {
          Future.delayed(Duration(milliseconds: 100)).then((value) {
            widget.selectedWidgetNotifier.value = homeScreenItems.first;
          });
        }

        return Stack(
          children: [
            //region fixed view
            AspectRatio(
              aspectRatio: heightOfDevice > 750 ? 0.8 : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  homeScreenItems.contains('bloodPressure')
                      ? SmallCircleFixed(
                          selectedWidgetNotifier: widget.selectedWidgetNotifier,
                          index: homeScreenItems.indexOf('bloodPressure') + 1,
                          widgetName: 'bloodPressure',
                          listOfPercentage: [1],
                          image: isDarkMode()
                              ? 'asset/dark_bp_butt_on.png'
                              : 'asset/blood_pressure_butt_on.png',
                          colorsOfIndicators: [bloodPressureProgressColor],
                          currentDiaNotifier: widget.currentDiaNotifier,
                          currentSysNotifier: widget.currentSysNotifier,
                          angle: listOfAngle[0],
                          onClickSmallCircle: () {
                            onClickSmallCircle('bloodPressure');
                          },
                          onEndAnimation: () {
                            widget.isAnimatingNotifier.value = false;
                          },
                          isAiModeSelected: widget.isAiModeSelected,
                        )
                      : Container(),
                  homeScreenItems.contains('heartRate')
                      ? SmallCircleFixed(
                          selectedWidgetNotifier: widget.selectedWidgetNotifier,
                          index: homeScreenItems.indexOf('heartRate') + 1,
                          widgetName: 'heartRate',
                          listOfPercentage: [1],
                          image:
                              isDarkMode() ? 'asset/dark_hr_butt_on.png' : 'asset/hr_butt_on.png',
                          currentDiaNotifier: widget.currentDiaNotifier,
                          currentSysNotifier: widget.currentSysNotifier,
                          colorsOfIndicators: [AppColor.progressColor],
                          angle: listOfAngle[1],
                          onClickSmallCircle: () {
                            onClickSmallCircle('heartRate');
                          },
                          onEndAnimation: () {
                            widget.isAnimatingNotifier.value = false;
                          },
                        )
                      : Container(),
                  homeScreenItems.contains('hrv')
                      ? SmallCircleFixed(
                          selectedWidgetNotifier: widget.selectedWidgetNotifier,
                          index: homeScreenItems.indexOf('hrv') + 1,
                          widgetName: 'hrv',
                          listOfPercentage: [1],
                          image: isDarkMode()
                              ? 'asset/dark_stress_butt_on.png'
                              : 'asset/stress_butt_on.png',
                          currentDiaNotifier: widget.currentDiaNotifier,
                          currentSysNotifier: widget.currentSysNotifier,
                          colorsOfIndicators: [AppColor.progressColor],
                          angle: listOfAngle[2],
                          onClickSmallCircle: () {
                            onClickSmallCircle('hrv');
                          },
                          onEndAnimation: () {
                            widget.isAnimatingNotifier.value = false;
                          },
                        )
                      : Container(),
                  homeScreenItems.contains('oxygen')
                      ? SmallCircleFixed(
                          selectedWidgetNotifier: widget.selectedWidgetNotifier,
                          index: homeScreenItems.indexOf('oxygen') + 1,
                          widgetName: 'oxygen',
                          listOfPercentage: [1],
                          image: isDarkMode()
                              ? 'asset/dark_oxygen_butt_on.png'
                              : 'asset/oxygen_butt_on.png',
                          currentDiaNotifier: widget.currentDiaNotifier,
                          currentSysNotifier: widget.currentSysNotifier,
                          colorsOfIndicators: [AppColor.progressColor],
                          angle: listOfAngle[3],
                          onClickSmallCircle: () {
                            onClickSmallCircle('oxygen');
                          },
                          onEndAnimation: () {
                            widget.isAnimatingNotifier.value = false;
                          },
                        )
                      : Container(),
                  homeScreenItems.contains('weight')
                      ? SmallCircleFixed(
                          selectedWidgetNotifier: widget.selectedWidgetNotifier,
                          index: homeScreenItems.indexOf('weight') + 1,
                          widgetName: 'weight',
                          listOfPercentage: [1],
                          image: isDarkMode()
                              ? 'asset/dark_weight_butt_on.png'
                              : 'asset/weight_butt_on.png',
                          currentDiaNotifier: widget.currentDiaNotifier,
                          currentSysNotifier: widget.currentSysNotifier,
                          colorsOfIndicators: [AppColor.progressColor],
                          angle: listOfAngle[4],
                          onClickSmallCircle: () {
                            onClickSmallCircle('weight');
                          },
                          onEndAnimation: () {
                            widget.isAnimatingNotifier.value = false;
                          },
                        )
                      : Container(),
                ],
              ),
            ),
            //endregion

            //region not fixed
            AspectRatio(
              aspectRatio: heightOfDevice > 750 ? 0.8 : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  homeScreenItems.contains('bloodPressure')
                      ? ValueListenableBuilder(
                          valueListenable: widget.currentSysNotifier,
                          builder: (BuildContext context, num? value, Widget? child) {
                            callValue = callValue + 1;
                            return SmallCircles(
                              currentSysNotifier: widget.currentSysNotifier,
                              currentDiaNotifier: widget.currentDiaNotifier,
                              selectedWidgetNotifier: widget.selectedWidgetNotifier,
                              index: homeScreenItems.indexOf('bloodPressure') + 1,
                              widgetName: 'bloodPressure',
                              image: isDarkMode()
                                  ? 'asset/dark_bp_butt_off.png'
                                  : 'asset/bp_butt_off.png',
                              listOfPercentage: [1],
                              colorsOfIndicators: [bloodPressureProgressColor],
                              angle: listOfAngle[0],
                              onClickSmallCircle: () {
                                onClickSmallCircle('bloodPressure');
                              },
                              onEndAnimation: () {
                                widget.isAnimatingNotifier.value = false;
                              },
                              isAiModeSelected: widget.isAiModeSelected,
                              widget: BloodPressureWidget(
                                selectedWidgetNotifier: widget.selectedWidgetNotifier,
                                onClickBloodPressureWidget: widget.onClickBloodPressureWidget,
                                isAnimatingNotifier: widget.isAnimatingNotifier,
                                isAiModeSelected: widget.isAiModeSelected,
                                currentDiaNotifier: widget.currentDiaNotifier,
                                currentSysNotifier: widget.currentSysNotifier,
                              ),
                              isAnimatingNotifier: widget.isAnimatingNotifier,
                            );
                          },
                        )
                      : Container(),

                  homeScreenItems.contains('heartRate')
                      ? SmallCircles(
                          currentDiaNotifier: widget.currentDiaNotifier,
                          currentSysNotifier: widget.currentSysNotifier,
                          selectedWidgetNotifier: widget.selectedWidgetNotifier,
                          index: homeScreenItems.indexOf('heartRate') + 1,
                          widgetName: 'heartRate',
                          image:
                              isDarkMode() ? 'asset/dark_hr_butt_off.png' : 'asset/hr_butt_off.png',
                          listOfPercentage: [1],
                          colorsOfIndicators: [
                            tick.isOdd
                                ? AppColor.progressColor.withOpacity(0.5)
                                : AppColor.progressColor
                          ],
                          angle: listOfAngle[1],
                          onClickSmallCircle: () {
                            onClickSmallCircle('heartRate');
                          },
                          onEndAnimation: () {
                            widget.isAnimatingNotifier.value = false;
                          },
                          isAnimatingNotifier: widget.isAnimatingNotifier,
                          widget: HeartRateWidget(
                            selectedWidgetNotifier: widget.selectedWidgetNotifier,
                            isAnimatingNotifier: widget.isAnimatingNotifier,
                            currentHr: widget.currentHrNotifier,
                            hrGraphNotifier: widget.hrGraphNotifier,
                            measurementDurationNotifier: widget.measurementDurationNotifier,
                            connectedDevice: widget.connectedDevice,
                            lastHrDate: '',
                          ),
                        )
                      : Container(),

                  homeScreenItems.contains('hrv')
                      ? ValueListenableBuilder(
                          valueListenable: widget.currentHRVNotifier,
                          builder: (BuildContext context, num? value, Widget? child) {
                            return SmallCircles(
                              selectedWidgetNotifier: widget.selectedWidgetNotifier,
                              index: homeScreenItems.indexOf('hrv') + 1,
                              widgetName: 'hrv',
                              image: isDarkMode()
                                  ? 'asset/dark_stress_butt_off.png'
                                  : 'asset/stress_butt_off.png',
                              listOfPercentage: [1],
                              colorsOfIndicators: [AppColor.progressColor],
                              angle: listOfAngle[2],
                              onClickSmallCircle: () {
                                onClickSmallCircle('hrv');
                              },
                              onEndAnimation: () {
                                widget.isAnimatingNotifier.value = false;
                              },
                              isAnimatingNotifier: widget.isAnimatingNotifier,
                              currentDiaNotifier: widget.currentDiaNotifier,
                              currentSysNotifier: widget.currentSysNotifier,
                              widget: HrvWidget(
                                selectedWidgetNotifier: widget.selectedWidgetNotifier,
                                isAnimatingNotifier: widget.isAnimatingNotifier,
                                currentHRVNotifier: widget.currentHRVNotifier,
                                onClickHRVWidget: widget.onClickBloodPressureWidget,
                              ),
                            );
                          },
                        )
                      : Container(),

                  homeScreenItems.contains('oxygen')
                      ? ValueListenableBuilder(
                          valueListenable: widget.currentWeightNotifier,
                          builder: (BuildContext context, num? value, Widget? child) {
                            return SmallCircles(
                              selectedWidgetNotifier: widget.selectedWidgetNotifier,
                              index: homeScreenItems.indexOf('oxygen') + 1,
                              widgetName: 'oxygen',
                              image: isDarkMode()
                                  ? 'asset/dark_oxygen_butt_off.png'
                                  : 'asset/oxygen_butt_off.png',
                              listOfPercentage: [1],
                              colorsOfIndicators: [AppColor.progressColor],
                              angle: listOfAngle[3],
                              onClickSmallCircle: () {
                                onClickSmallCircle('oxygen');
                              },
                              onEndAnimation: () {
                                widget.isAnimatingNotifier.value = false;
                              },
                              isAnimatingNotifier: widget.isAnimatingNotifier,
                              currentDiaNotifier: widget.currentDiaNotifier,
                              currentSysNotifier: widget.currentSysNotifier,
                              widget: OxygenWidget(
                                selectedWidgetNotifier: widget.selectedWidgetNotifier,
                                isAnimatingNotifier: widget.isAnimatingNotifier,
                                oxygenNotifier: widget.currentOxygenNotifier,
                                onClickOxygen: widget.onClickOxygenWidget,
                              ),
                            );
                          },
                        )
                      : Container(),

                  homeScreenItems.contains('weight')
                      ? ValueListenableBuilder(
                          valueListenable: widget.currentWeightNotifier,
                          builder: (BuildContext context, num? value, Widget? child) {
                            return SmallCircles(
                              selectedWidgetNotifier: widget.selectedWidgetNotifier,
                              index: homeScreenItems.indexOf('weight') + 1,
                              widgetName: 'weight',
                              image: isDarkMode()
                                  ? 'asset/dark_weight_butt_off.png'
                                  : 'asset/weight_butt_off.png',
                              listOfPercentage: [1],
                              colorsOfIndicators: [AppColor.progressColor],
                              angle: listOfAngle[4],
                              onClickSmallCircle: () {
                                onClickSmallCircle('weight');
                              },
                              onEndAnimation: () {
                                widget.isAnimatingNotifier.value = false;
                              },
                              isAnimatingNotifier: widget.isAnimatingNotifier,
                              currentDiaNotifier: widget.currentDiaNotifier,
                              currentSysNotifier: widget.currentSysNotifier,
                              widget: WeightWidget(
                                selectedWidgetNotifier: widget.selectedWidgetNotifier,
                                isAnimatingNotifier: widget.isAnimatingNotifier,
                                weightNotifier: widget.currentWeightNotifier,
                                onClickWeightWidget: widget.onClickWeightWidget,
                              ),
                            );
                          },
                        )
                      : Container(),
                  //endregion
                ],
              ),
            ),
            //endregion
          ],
        );
      },
    );
  }

  void onClickSmallCircle(String widgetName) {
    if (widget.selectedWidgetNotifier.value == widgetName) {
      return;
    }
    Future.delayed(Duration(milliseconds: (Constants.homeScreenAnimationMilliseconds + 20))).then(
      (value) {
        widget.isAnimatingNotifier.value = true;
        widget.selectedWidgetNotifier.value = widgetName;
      },
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}
