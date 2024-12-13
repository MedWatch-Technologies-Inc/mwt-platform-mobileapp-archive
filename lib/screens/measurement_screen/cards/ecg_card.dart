import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/background_paint.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';

import '../measurement_screen.dart';

class ECGCard extends StatelessWidget {
  final ValueNotifier<int> ecgLength;
  final ValueNotifier<List<Entry>> valuesForEcgGraph;
  final ValueNotifier<num> zoomLevelECG;
  final ecgPointList;
  final ValueNotifier<int> measurementType;
  final LineChartController? controllerForEcgGraph;
  final Function setZoom;

  const ECGCard({
    required this.zoomLevelECG,
    required this.ecgPointList,
    required this.measurementType,
    required this.controllerForEcgGraph,
    required this.setZoom,
    required this.valuesForEcgGraph,
    required this.ecgLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<num>(
      valueListenable: zoomLevelECG,
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.only(top: 15.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h),
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#FFFFFF'),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(-4, -4),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(4, 4),
                ),
              ]),
          height: 150.h,
          //width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.h),
                child: SizedBox(
                  height: 25.h,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Body1AutoText(
                          text: StringLocalization.of(context).getText(StringLocalization.ecg),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex('#ff6159'),
                        ),
                      ),
                      Visibility(
                        visible: measurementType.value != 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    if (zoomLevelECG.value > 1) {
                                      if (zoomLevelECG.value > 1) {
                                        zoomLevelECG.value--;
                                      }
                                      setZoom(zoomLevelECG.value.toInt(),
                                          zoomBtn: true, fromType: 0);
                                    }
                                  },
                                  icon: Image.asset(
                                    zoomLevelECG.value == 1
                                        ? 'asset/down_off.png'
                                        : 'asset/down_on.png',
                                    height: 18.h,
                                    width: 18.h,
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    if (zoomLevelECG.value <= 9) {
                                      zoomLevelECG.value++;
                                      setZoom(zoomLevelECG.value.toInt(),
                                          zoomBtn: true, fromType: 0);
                                    }
                                  },
                                  icon: Image.asset(
                                    zoomLevelECG.value >= 9
                                        ? 'asset/up_off.png'
                                        : 'asset/up_on.png',
                                    height: 18.h,
                                    width: 18.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ecgPointList == null || ecgPointList.length == 0 || controllerForEcgGraph == null
                  ? Container(
                      height: 110.h,
                      child: Center(
                        child: SizedBox(
                          height: 30.h,
                          child: Body1AutoText(
                            text: stringLocalization
                                .getText(StringLocalization.ppgNoChartDataAvailable),
                            maxLine: 1,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                      height: 110.h,
                      width: MediaQuery.of(context).size.width - 13.w,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: (ecgPointList.length) > 1,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                child: CustomPaint(
                                  painter: BackgroundPaint(),
                                  size: Size(
                                    MediaQuery.of(context).size.width - 13.w,
                                    110.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          LineChart(controllerForEcgGraph!),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
