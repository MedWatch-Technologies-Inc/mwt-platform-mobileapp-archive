import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/collect_ecg_model.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/background_paint.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';


class CollectEcgScreen extends StatefulWidget {
  const CollectEcgScreen({Key? key}) : super(key: key);

  @override
  _CollectEcgScreenState createState() => _CollectEcgScreenState();
}

class _CollectEcgScreenState extends State<CollectEcgScreen> {
  LineChartController? controllerForEcgGraph;
  ValueNotifier refreshGraph = ValueNotifier(null);

  @override
  void initState() {
    initGraphController();
    setGraphColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex('#384341').withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if(Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      'asset/dark_leftArrow.png',
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              stringLocalization.getText(StringLocalization.ecgFromWatch),
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex('62CBC9'),
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FutureBuilder(
        future: connections.collectECG(),
        builder:
            (BuildContext context, AsyncSnapshot<CollectEcgModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            setDataToEcgGraph(snapshot.data);
          }
          return Container(
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
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.2))),
                    child: CustomPaint(
                      painter: BackgroundPaint(),
                      size: Size(
                        MediaQuery.of(context).size.width - 13.w,
                        MediaQuery.of(context).size.height - kTextTabBarHeight,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: snapshot.connectionState == ConnectionState.done,
                  child: SizedBox(
                    height: 150.h,
                    child: ValueListenableBuilder(
                        valueListenable: refreshGraph,
                        builder: (BuildContext context, value, Widget? child) {
                          return LineChart(controllerForEcgGraph!);
                        },
                    ),
                  ),
                ),
                Visibility(
                  visible: snapshot.connectionState != ConnectionState.done,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void initGraphController() {
    var desc = Description()..enabled = false;
    controllerForEcgGraph = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..textColor = (Colors.transparent);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..textColor = (Colors.transparent);
      },
      legendSettingFunction: (legend, controller) {
        legend.enabled = (false);
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..setLabelCount2(4, true);
      },
      drawGridBackground: false,
      gridBackColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      dragXEnabled: true,
      dragYEnabled: false,
      scaleXEnabled: true,
      scaleYEnabled: false,
      description: desc,
      infoTextSize: 16.sp,
      pinchZoomEnabled: true,
      doubleTapToZoomEnabled: true,
      noDataText: '',
      highlightPerDragEnabled: false,
      highLightPerTapEnabled: false,
      infoTextColor: Colors.transparent,
    );
  }

  void setGraphColors() {
    controllerForEcgGraph?.axisLeft?.enabled = false;
    controllerForEcgGraph?.axisRight?.enabled = false;
    controllerForEcgGraph?.xAxis?.textColor = Colors.transparent;
    controllerForEcgGraph?.infoBgColor = Colors.transparent;
    controllerForEcgGraph?.backgroundColor = Colors.transparent;
    controllerForEcgGraph?.highLightPerTapEnabled = false;
  }

  void setDataToEcgGraph(CollectEcgModel? ecgPoints) {
    var valuesForEcgGraph = <Entry>[];
    for (var i = 0; i < (ecgPoints?.ecgData?.length ?? 0); i++) {
      valuesForEcgGraph.add(Entry(
        x: i.toDouble(),
        y: ecgPoints?.ecgData?.elementAt(i)?.toDouble() ?? 0,
      ));
    }
    var ecgDataSet = LineDataSet(valuesForEcgGraph, 'EcgDataSet 1');
    ecgDataSet.setColor1(HexColor.fromHex('ff6159'));
    ecgDataSet.setLineWidth(2);
    ecgDataSet.setDrawValues(false);
    ecgDataSet.setDrawCircles(false);
    ecgDataSet.setMode(Mode.LINEAR);
    ecgDataSet.setDrawFilled(false);

    try {
      if (ecgDataSet.values == null) {
        ecgDataSet.setValues(valuesForEcgGraph);
      }
    } catch (e) {
      debugPrint('Error $e');
    }

    setGraphColors();

    controllerForEcgGraph?.data = LineData.fromList([]..addAll([ecgDataSet]));

    Future.delayed(Duration(milliseconds: 500)).then((value) {
      controllerForEcgGraph?.setVisibleXRangeMaximum(200);
      controllerForEcgGraph?.setVisibleXRangeMinimum(200);
      refreshGraph.value = controllerForEcgGraph;
      if(mounted){
        // setState(() {});
      }
    });

  }
}