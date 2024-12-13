import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/measurement/health_kit_model.dart';
import 'package:health_gauge/screens/measurement_screen/cards/ecg_card.dart';
import 'package:health_gauge/utils/app_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';

class BPCard extends StatelessWidget {
  final List<HealthKitModel> sysList;
  final List<HealthKitModel> diaList;
  final List<HealthKitModel> hrList;
  final List<HealthKitModel> hrvList;
  final Widget lineChartWidgetForHr;
  final Widget lineChartWidgetForBp;
  final Widget lineChartWidgetForHrv;
  final IosDeviceInfo? iosInfo;
  final ecgPointList;
  final ValueNotifier<List<Entry>> valuesForEcgGraph;
  final ValueNotifier<int> ecgLength;
  final ValueNotifier<int> measurementType;
  final ValueNotifier<num> zoomLevelECG;
  final controllerForEcgGraph;
  final Function setZoom;
  const BPCard(
      {Key? key,
      required this.sysList,
      required this.diaList,
      required this.hrList,
      required this.hrvList,
      required this.lineChartWidgetForHr,
      required this.lineChartWidgetForBp,
      required this.lineChartWidgetForHrv,
      required this.iosInfo,
      required this.ecgPointList,
      required this.valuesForEcgGraph,
      required this.ecgLength,
      required this.measurementType,
      required this.zoomLevelECG,
      required this.controllerForEcgGraph,
      required this.setZoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15.h,
        ),
        Container(
            padding: EdgeInsets.all(15),
            height: 220.h,
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
            child: Column(
              children: [
                Body1AutoText(
                  text: 'Heart Rate',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex('#FF9E99'),
                ),
                Container(height: 150.h, child: lineChartWidgetForHr),
              ],
            )),
        SizedBox(
          height: 15.h,
        ),
        Container(
            height: 240.h,
            padding: EdgeInsets.all(15),
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
            child: Column(
              children: [
                Body1AutoText(
                  text: 'BP',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex('#FF9E99'),
                ),
                sysList.isEmpty && diaList.isEmpty
                    ? Container()
                    : Container(
                        height: 25.h,
                        child: Row(
                          children: [
                            Body1AutoText(
                              text: 'Sys',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: HexColor.fromHex('#009C92'),
                            ),
                            Spacer(),
                            Body1AutoText(
                              text: 'Dia',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: HexColor.fromHex('#0058cc'),
                            )
                          ],
                        ),
                      ),
                Container(height: 150.h, child: lineChartWidgetForBp),
              ],
            )),
        SizedBox(
          height: 15.h,
        ),
        Container(
            height: 220.h,
            padding: EdgeInsets.all(15),
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
            child: Column(
              children: [
                Body1AutoText(
                  text: 'HRV',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex('#FF9E99'),
                ),
                Container(height: 150.h, child: lineChartWidgetForHrv),
              ],
            )),
        SizedBox(
          height: 15.h,
        ),
        AppUtils().iOSVersionCompare(iosInfo?.systemVersion)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ECGCard(
                      zoomLevelECG: zoomLevelECG,
                      ecgPointList: ecgPointList,
                      measurementType: measurementType,
                      controllerForEcgGraph: controllerForEcgGraph,
                      setZoom: setZoom,
                      valuesForEcgGraph: valuesForEcgGraph,
                      ecgLength: ecgLength),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
