import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/bar_line_scatter_candle_bubble_controller.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SportActivityScreen extends StatefulWidget {
  final String selectedWidget;

  const SportActivityScreen(this.selectedWidget, {Key? key}) : super(key: key);

  @override
  _SportActivityScreenState createState() => _SportActivityScreenState();
}

class _SportActivityScreenState extends State<SportActivityScreen> {
  int currentIndex = 0;

  DateTime selectedDate = DateTime.now();

//  DateTime selectedDateForWeek = DateTime.now();
//  DateTime selectedDateForMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  DateTime firstDateOfWeek = DateTime.now();
  DateTime lastDateOfWeek = DateTime.now();

  String? userId;

  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<MotionInfoModel> motionInfoListForDay = [];

  List<MotionInfoModel> motionInfoListForWeek = [];

  List<MotionInfoModel> motionInfoListForMonth = [];

  //region week controllers
  BarLineScatterCandleBubbleController? stepsGraphControllerWeek;
  BarLineScatterCandleBubbleController? caloriesGraphControllerWeek;
  BarLineScatterCandleBubbleController? mileGraphControllerWeek;

  //endregion

  //region month controllers
  BarLineScatterCandleBubbleController? stepsGraphControllerMonth;
  BarLineScatterCandleBubbleController? caloriesGraphControllerMonth;
  BarLineScatterCandleBubbleController? mileGraphControllerMonth;

  //endregion

  double targetSteps = 8000;
  double targetDistance = 5000;

  List<charts.Series<LinearSales, int>> seriesListForStep = [];
  List<charts.Series<LinearSales, int>> seriesListForCalories = [];
  List<charts.Series<LinearSales, int>> seriesListForDistance = [];

  Widget stepChartForDayWidget = Container();
  Widget caloriesChartDayWidget = Container();
  Widget distanceChartDayWidget = Container();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100)).then((value) => initChart());
    initDateVariables();
    getPreference();
    screen = Constants.activityDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex("#384341").withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
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
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            title: Text(
              StringLocalization.of(context)
                  .getText(StringLocalization.activity),
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex('62CBC9'),
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: layout(),
    );
  }

  Widget layout() {
    try {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  tabLayout(),
                  dateChooserLayout(),
                  stepCompilation(),
                  legendsForAllGraph(),
                ],
              ),
            ),
            SizedBox(height: 10.0.h),
            displayData(),
            //          SizedBox(height: 10.0),
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Container();
    }
  }

  Widget tabLayout() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? Colors.blueGrey[900]
                      : Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Body1AutoText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.day),
                  color: currentIndex == 0 ? Colors.white : Colors.black,
                  align: TextAlign.center,
                  maxLine: 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () {
                currentIndex = 0;
                screen = Constants.activityDay;
                getDataFromDb();
                //  setState(() {});
              },
            ),
          ),
          currentIndex == 2
              ? Container(
                  width: 1.w,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white,
                )
              : Container(),
          Expanded(
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 1
                        ? Colors.blueGrey[900]
                        : Colors.grey[400],
                  ),
                  child: Body1AutoText(
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.week),
                    color: currentIndex == 1 ? Colors.white : Colors.black,
                    align: TextAlign.center,
                    maxLine: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  )),
              onTap: () {
                currentIndex = 1;
                screen = Constants.activityWeekly;
                // setState(() {});
                getDataFromDb();
              },
            ),
          ),
          currentIndex == 0
              ? Container(
                  width: 1.w,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white,
                )
              : Container(),
          Expanded(
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 2
                        ? Colors.blueGrey[900]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Body1AutoText(
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.month),
                    color: currentIndex == 2 ? Colors.white : Colors.black,
                    align: TextAlign.center,
                    maxLine: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  )),
              onTap: () {
                currentIndex = 2;
                screen = Constants.activityWeekly;
                getDataFromDb();
                // setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dateChooserLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            onClickBefore();
          },
        ),
        Expanded(
          child: Container(
            // width: currentIndex == 1 ? 200 : 120,
            child: Center(
              // child: AutoSizeText(
              //   selectedValueText(),
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              //   minFontSize: 10,
              //   maxLines: 1,
              // ),
              child: Body1AutoText(
                text: selectedValueText(),
                fontSize: 16,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
                maxLine: 1,
                // maxLine: 1,
              ),
            ),
          ),
        ),
        nextBtn(),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            this.selectedDate =
                await Date().selectDate(context, this.selectedDate);
            selectWeek(this.selectedDate);
            // await getDayData();
            // await getWeekData();
            // await getMonthData();
            // setState(() {});
            getDataFromDb();
          },
        ),
      ],
    );
  }

  IconButton nextBtn() {
    bool isEnable = true;
    if (currentIndex == 0 &&
        this.selectedDate.difference(DateTime.now()).inDays == 0) {
      isEnable = false;
    }
    if (currentIndex == 1 &&
        this.selectedDate.difference(DateTime.now()).inDays == 0) {
      isEnable = false;
    }
    if (currentIndex == 2 &&
        this.selectedDate.month == DateTime.now().month &&
        this.selectedDate.year == DateTime.now().year) {
      isEnable = false;
    }
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: isEnable
          ? () {
              onClickNext();
            }
          : null,
    );
  }

  displayData() {
    if (currentIndex == 0) {
      if (motionInfoListForDay != null && motionInfoListForDay.length > 0) {
        MotionInfoModel model = motionInfoListForDay.first;
        if (model.step == 0 && model.distance == 0 && model.calories == 0) {
          return Container(
            child: Center(
              child: Text(StringLocalization.of(context)
                  .getText(StringLocalization.noDataFound)),
            ),
          );
        }
        return Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: stepChartForDayWidget,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        );
      } else {
        return Container(
          child: Center(
            child: Text(StringLocalization.of(context)
                .getText(StringLocalization.noDataFound)),
          ),
        );
      }
    } else if (currentIndex == 1) {
      if (motionInfoListForWeek != null && motionInfoListForWeek.length > 0) {
        return graphLayout(stepsGraphControllerWeek,
            caloriesGraphControllerWeek, mileGraphControllerWeek);
      } else {
        return Container(
          child: Center(
            child: Text(StringLocalization.of(context)
                .getText(StringLocalization.noDataFound)),
          ),
        );
      }
    } else if (currentIndex == 2) {
      if (motionInfoListForMonth != null && motionInfoListForMonth.length > 0) {
        return graphLayout(stepsGraphControllerMonth,
            caloriesGraphControllerMonth, mileGraphControllerMonth);
      } else {
        return Container(
          child: Center(
            child: Text(StringLocalization.of(context)
                .getText(StringLocalization.noDataFound)),
          ),
        );
      }
    }

    return Container(
      child: Center(
        child: Text(StringLocalization.of(context)
            .getText(StringLocalization.noDataFound)),
      ),
    );
  }

  Widget dayLineChart(List<charts.Series<LinearSales, int>> series) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: charts.LineChart(
        series,
        animate: false,
        customSeriesRenderers: [
          new charts.LineRendererConfig(
            customRendererId: 'customArea',
            includeArea: false,
            stacked: true,
            includePoints: true,
            includeLine: true,
            roundEndCaps: true,
            radiusPx: 2.0,
            strokeWidthPx: 1.0,
          ),
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? charts.MaterialPalette.white
                      : charts.MaterialPalette.black)),
          tickProviderSpec: new charts.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: false),
        ),
        domainAxis: new charts.NumericAxisSpec(
          tickProviderSpec: new charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 24,
          ),
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
            _formaterYear,
          ),
          renderSpec: charts.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 12,
            labelStyle: charts.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? charts.MaterialPalette.white
                    : charts.MaterialPalette.black),
          ),
          viewport: new charts.NumericExtents(1.0, 24.0),
        ),
      ),
    );
  }

  String _formaterYear(num? year) {
    int value = year!.toInt();
    if (value % 2 == 0) {
      return "";
    }
    return '$value';
  }

  Widget graphLayout(stepController, caloriesController, distanceController) {
    setColorInGraph(stepController, caloriesController, distanceController);
    return Column(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0.h,
            child: getLineChart(stepController),
          ),
        ),
        SizedBox(height: 10.0.h),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            child: getLineChart(caloriesController),
          ),
        ),
        SizedBox(height: 10.0.h),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0.h,
            child: getLineChart(distanceController),
          ),
        ),
        SizedBox(height: 10.0.h),
      ],
    );
  }

  void setColorInGraph(stepController, caloriesController, distanceController) {
    if (stepController != null) {
      if (stepController.xAxis != null &&
          stepController.xAxis.textColor != null) {
        stepController.xAxis.textColor =
            Theme.of(context).textTheme.bodyLarge!.color;
      }
      if (stepController.axisLeft != null &&
          stepController.axisLeft.textColor != null) {
        stepController.axisLeft.textColor =
            Theme.of(context).textTheme.bodyLarge!.color;
      }
    }
    if (caloriesController != null) {
      if (caloriesController.xAxis != null &&
          caloriesController.xAxis.textColor != null) {
        caloriesController.xAxis.textColor =
            Theme.of(context).textTheme.bodyLarge!.color;
      }
      if (caloriesController.axisLeft != null &&
          caloriesController.axisLeft.textColor != null) {
        caloriesController.axisLeft.textColor =
            Theme.of(context).textTheme.bodyLarge!.color;
      }
    }
    if (distanceController != null) {
      if (distanceController.xAxis != null &&
          distanceController.xAxis.textColor != null) {
        distanceController.xAxis.textColor =
            Theme.of(context).textTheme.bodyLarge!.color;
      }
      if (distanceController.axisLeft != null &&
          distanceController.axisLeft.textColor != null) {
        distanceController.axisLeft.textColor =
            Theme.of(context).textTheme.bodyLarge!.color;
      }
    }
  }

  LineChart getLineChart(LineChartController controller) {
    controller.infoBgColor = Theme.of(context).cardColor;
    controller.backgroundColor = Theme.of(context).cardColor;
    var lineChart = LineChart(controller);
    controller.animator!
      ..reset()
      ..animateX1(750);
    return lineChart;
  }

  //this method calculate total and average of data
  Widget legendsForAllGraph() {
    List<MotionInfoModel> list = [];

    switch (currentIndex) {
      case 0:
        list = motionInfoListForDay;
        break;
      case 1:
        list = motionInfoListForWeek;
        break;
      case 2:
        list = motionInfoListForMonth;
        break;
    }

    if (list.length == 0) {
      return Container();
    }

    int stepsTotal = 0;
    int caloriesTotal = 0;
    double kmTotal = 0;

    int stepsAvg = 0;
    int caloriesAvg = 0;
    double kmAvg = 0;

    if (list != null) {
      if (currentIndex == 0) {
        MotionInfoModel model = list.first;

        stepsAvg += model.step?.round() ??
            0; //(model.step/motionInfoListForWeek.length).round().toString();
        caloriesAvg += model.calories?.round() ??
            0; //(model.calories/motionInfoListForWeek.length).round().toString();
        kmAvg += ((model.distance ?? 0) * 1000).round(); //(model.dis
      } else {
        for (MotionInfoModel model in list) {
          if (model != null &&
              model.step != null &&
              model.calories != null &&
              model.distance != null) {
            stepsTotal += model.step!
                .round(); //(model.step/motionInfoListForWeek.length).round().toString();
            caloriesTotal += model.calories!
                .round(); //(model.calories/motionInfoListForWeek.length).round().toString();
            kmTotal += (model.distance! *
                1000); //(model.distance/motionInfoListForWeek.length).round().toString();
          }
        }
        if (list.length > 0) {
          stepsAvg = stepsTotal; //(stepsTotal / list.length).round();
          caloriesAvg = caloriesTotal; //(caloriesTotal / list.length).round();
          kmAvg = kmTotal; //(kmTotal / list.length).round();
        }
      }
    }

    if (stepsAvg == 0 && caloriesAvg == 0 && kmAvg == 0) {
      return Container();
    }

    String kmAvgStr =
        StringLocalization.of(context).getText(StringLocalization.distance) +
            "\n($kmAvg m)";
    String distanceUnitString = '';

    if (distanceUnit == 1) {
      kmAvg = (kmAvg / 1609);
      kmAvg = double.parse(kmAvg.toStringAsFixed(2).padLeft(2, "0"));
      kmAvgStr =
          StringLocalization.of(context).getText(StringLocalization.distance) +
              "\n($kmAvg ${kmAvg > 1 ? "miles" : "mile"})";
      distanceUnitString = kmAvg > 1 ? "miles" : "mile";
    } else {
      kmAvg = (kmAvg / 1000);
      kmAvg = double.parse(kmAvg.toStringAsFixed(2).padLeft(2, "0"));
      kmAvgStr =
          StringLocalization.of(context).getText(StringLocalization.distance) +
              "\n($kmAvg km)";
      distanceUnitString = 'km';
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color:
                        // currentIndex == 0 ? Colors.red :
                        AppColor.red,
                  ),
                  SizedBox(width: 5.0.w),
                  Flexible(
                      child: Column(
                    children: [
                      Body1AutoText(
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.steps),
                        maxLine: 1,
                        minFontSize: 16,
                        align: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Body1AutoText(
                        text: "($stepsAvg)",
                        maxLine: 1,
                        align: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color:
                        // currentIndex == 0 ? Colors.green :
                        AppColor.orangeColor,
                  ),
                  SizedBox(width: 5.0.w),
                  Flexible(
                      child: Column(
                    children: [
                      Body1AutoText(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.calories),
                          maxLine: 1,
                          minFontSize: 16,
                          align: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                      Body1AutoText(
                          text: "($caloriesAvg)",
                          maxLine: 1,
                          align: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color:
                        // currentIndex == 0 ? Colors.cyan :
                        AppColor.green,
                  ),
                  SizedBox(width: 5.0.w),
                  Flexible(
                      child: Column(
                    children: [
                      Body1AutoText(
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.distance),
                        maxLine: 1,
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        align: TextAlign.center,
                      ),
                      Body1AutoText(
                        text: kmAvg.toString() + distanceUnitString,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        align: TextAlign.center,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stepCompilation() {
    if (currentIndex != 0) {
      return Container();
    }
    if (motionInfoListForDay == null || motionInfoListForDay.length == 0) {
      return Container();
    }
    var list = motionInfoListForDay;

    num stepsTotal = list.first.step ?? 0;
    var caloriesTotal = list.first.calories ?? 0;
    var kmTotal = list.first.distance ?? 0;

    if (stepsTotal == 0 && caloriesTotal == 0 && kmTotal == 0) {
      return Container();
    }

    double percent = 0;

    percent = (stepsTotal) / targetSteps;

    if (percent < 0) {
      percent = 0;
    }
    if (percent > 1) {
      percent = 1;
    }

    double distancePercent = 0;
    if (targetDistance < (kmTotal * 1000)) {
      distancePercent = 1.0;
    } else {
      distancePercent = (kmTotal * 1000) / targetDistance;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: CircularPercentIndicator(
        radius: 100.0,
        lineWidth: 10.0.w,
        percent: widget.selectedWidget == 'step' ? percent : distancePercent,
        //stepsAvg / targetSteps,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Body1AutoText(
              text: widget.selectedWidget == 'step'
                  ? '${(stepsTotal * 100 ~/ targetSteps)}%'
                  : '${((kmTotal * 1000) * 100 ~/ targetDistance)}%',
              align: TextAlign.center,
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.0.h),
            Image.asset(
              widget.selectedWidget == 'step'
                  ? 'asset/footprint1.png'
                  : 'asset/weight_route_icon.png',
              height: IconTheme.of(context).size,
              width: IconTheme.of(context).size,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        progressColor:
            widget.selectedWidget == 'step' ? AppColor.red : Colors.cyan,
      ),
    );
  }

  onClickNext() async {
    switch (currentIndex) {
      case 0:
        this.selectedDate = DateTime(this.selectedDate.year,
            this.selectedDate.month, this.selectedDate.day + 1);
        break;
      case 1:
        this.selectedDate = DateTime(this.selectedDate.year,
            this.selectedDate.month, this.selectedDate.day + 7);
        break;
      case 2:
        this.selectedDate = DateTime(this.selectedDate.year,
            this.selectedDate.month + 1, this.selectedDate.day);
        break;
    }
    selectWeek(this.selectedDate);
    // await getDayData();
    // await getWeekData();
    // await getMonthData();
    //setState(() {});
    getDataFromDb();
  }

  onClickBefore() async {
    switch (currentIndex) {
      case 0:
        this.selectedDate = DateTime(this.selectedDate.year,
            this.selectedDate.month, this.selectedDate.day - 1);

        break;
      case 1:
        this.selectedDate = DateTime(this.selectedDate.year,
            this.selectedDate.month, this.selectedDate.day - 7);

        break;
      case 2:
        this.selectedDate = DateTime(this.selectedDate.year,
            this.selectedDate.month - 1, this.selectedDate.day);

        break;
    }
    selectWeek(this.selectedDate);
    // await getDayData();
    // await getWeekData();
    // await getMonthData();
    // setState(() {});
    getDataFromDb();
  }

  selectedValueText() {
    if (currentIndex == 0) {
      return txtSelectedDate();
    } else if (currentIndex == 1) {
      String first = DateFormat(DateUtil.ddMMyyyy).format(firstDateOfWeek);
      String last = DateFormat(DateUtil.ddMMyyyy).format(lastDateOfWeek);
      return "$first   to   $last";
    } else if (currentIndex == 2) {
      String date = DateFormat(DateUtil.MMMMyyyy).format(this.selectedDate);
      String year = date.split(' ')[1];
      date = Date().getSelectedMonthLocalization(date) + ' $year';
      return "$date";
    }
  }

  String txtSelectedDate() {
    String title =
        DateFormat(DateUtil.ddMMyyyyDashed).format(this.selectedDate);

    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final selected = DateTime(
        this.selectedDate.year, this.selectedDate.month, this.selectedDate.day);

    if (selected == today) {
      title = StringLocalization.of(context).getText(StringLocalization.today);
    } else if (selected == yesterday) {
      title =
          StringLocalization.of(context).getText(StringLocalization.yesterday);
    } else if (selected == tomorrow) {
      title =
          StringLocalization.of(context).getText(StringLocalization.tomorrow);
    }
    return "$title";
  }

  void initChart() {
    DateTime first =
        DateTime(this.selectedDate.year, this.selectedDate.month, 1);
    DateTime last =
        DateTime(this.selectedDate.year, this.selectedDate.month + 1, 0);

    var desc = Description()..enabled = false;

    stepsGraphControllerWeek = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
          ..axisValueFormatter = YValueFormatter(stepsGraphControllerWeek)
          ..setLabelCount2(5, true)
//          ..setAxisMaxValue(500)
          ..setAxisMinimum(1);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight..enabled = false;
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
          ..position = (XAxisPosition.BOTTOM)
          ..drawGridLines = (false)
          ..setLabelCount2(7, true)
          ..setAxisMaximum(6)
          ..axisValueFormatter = XValueFormatter(
              stepsGraphControllerWeek, firstDateOfWeek, lastDateOfWeek)
          ..drawAxisLine = (true);
      },
      legendSettingFunction: (legend, controller) {
        legend..enabled = false;
      },
      drawGridBackground: false,
      dragXEnabled: true,
      dragYEnabled: true,
      scaleXEnabled: true,
      scaleYEnabled: true,
      description: desc,
    );
    caloriesGraphControllerWeek = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
          ..axisValueFormatter = YValueFormatter(stepsGraphControllerWeek)
          ..setLabelCount2(5, true)
//          ..setAxisMaxValue(500)
          ..setAxisMinimum(1);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight..enabled = false;
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
          ..position = (XAxisPosition.BOTTOM)
          ..drawGridLines = (false)
          ..setLabelCount2(7, true)
          ..setAxisMaximum(6)
          ..axisValueFormatter = XValueFormatter(
              stepsGraphControllerWeek, firstDateOfWeek, lastDateOfWeek)
          ..drawAxisLine = (true);
      },
      legendSettingFunction: (legend, controller) {
        legend..enabled = false;
      },
      drawGridBackground: false,
      dragXEnabled: true,
      dragYEnabled: true,
      scaleXEnabled: true,
      scaleYEnabled: true,
      description: desc,
    );
    mileGraphControllerWeek = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
          ..axisValueFormatter = YValueFormatter(stepsGraphControllerWeek,
              unit: distanceUnit, isDistance: true)
          ..setLabelCount2(5, true)
//          ..setAxisMaxValue(500)
          ..setAxisMinimum(1);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight..enabled = false;
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
          ..position = (XAxisPosition.BOTTOM)
          ..drawGridLines = (false)
          ..setLabelCount2(7, true)
          ..setAxisMaximum(6)
          ..axisValueFormatter = XValueFormatter(
              stepsGraphControllerWeek, firstDateOfWeek, lastDateOfWeek)
          ..drawAxisLine = (true);
      },
      legendSettingFunction: (legend, controller) {
        legend..enabled = false;
      },
      drawGridBackground: false,
      dragXEnabled: true,
      dragYEnabled: true,
      scaleXEnabled: true,
      scaleYEnabled: true,
      description: desc,
    );

//    stepsGraphControllerMonth = LineChartController(
//      axisLeftSettingFunction: (axisLeft, controller) {
//        axisLeft
//          ..textColor = Theme.of(context).textTheme.bodyLarge.color
//          ..setLabelCount2(5, true)
//          ..axisValueFormatter = YValueFormatter(stepsGraphControllerMonth)
//          //..setAxisMaxValue(500)
//          ..setAxisMinimum(1);
//      },
//      axisRightSettingFunction: (axisRight, controller) {
//        axisRight..enabled = false;
//      },
//      xAxisSettingFunction: (xAxis, controller) {
//        xAxis
//          ..position = (XAxisPosition.BOTTOM)
//          ..drawGridLines = (false)
//          ..setLabelCount2(31, true)
//          ..setAxisMinimum(1)
//          ..axisValueFormatter =
//              MonthXValueFormatter(stepsGraphControllerMonth, first, last)
//          ..drawAxisLine = (true);
//      },
//      legendSettingFunction: (legend, controller) {
//        legend..enabled = false;
//      },
//      drawGridBackground: false,
//      dragXEnabled: true,
//      dragYEnabled: true,
//      scaleXEnabled: true,
//      scaleYEnabled: true,
//      description: desc,
//    );
//    caloriesGraphControllerMonth = LineChartController(
//      axisLeftSettingFunction: (axisLeft, controller) {
//        axisLeft
//          ..textColor = Theme.of(context).textTheme.bodyLarge.color
//          ..setLabelCount2(5, true)
//          ..axisValueFormatter = YValueFormatter(caloriesGraphControllerMonth)
//          //..setAxisMaxValue(500)
//          ..setAxisMinimum(1);
//      },
//      axisRightSettingFunction: (axisRight, controller) {
//        axisRight..enabled = false;
//      },
//      xAxisSettingFunction: (xAxis, controller) {
//        xAxis
//          ..textColor = Theme.of(context).textTheme.bodyLarge.color
//          ..position = (XAxisPosition.BOTTOM)
//          ..drawGridLines = (false)
//          ..setLabelCount2(31, true)
//          ..setAxisMinimum(1)
//          ..axisValueFormatter =
//              MonthXValueFormatter(caloriesGraphControllerMonth, first, last)
//          ..drawAxisLine = (true);
//      },
//      legendSettingFunction: (legend, controller) {
//        legend..enabled = false;
//      },
//      drawGridBackground: false,
//      dragXEnabled: true,
//      dragYEnabled: true,
//      scaleXEnabled: true,
//      scaleYEnabled: true,
//      description: desc,
//    );
//
//    mileGraphControllerMonth = LineChartController(
//      axisLeftSettingFunction: (axisLeft, controller) {
//        axisLeft
//          ..textColor = Theme.of(context).textTheme.bodyLarge.color
//          ..setLabelCount2(5, true)
//          ..axisValueFormatter = YValueFormatter(mileGraphControllerMonth)
//          //..setAxisMaxValue(500)
//          ..setAxisMinimum(1);
//      },
//      axisRightSettingFunction: (axisRight, controller) {
//        axisRight..enabled = false;
//      },
//      xAxisSettingFunction: (xAxis, controller) {
//        xAxis
//          ..textColor = Theme.of(context).textTheme.bodyLarge.color
//          ..position = (XAxisPosition.BOTTOM)
//          ..drawGridLines = (false)
//          ..setLabelCount2(31, true)
//          ..setAxisMinimum(1)
//          ..axisValueFormatter =
//              MonthXValueFormatter(mileGraphControllerMonth, first, last)
//          ..drawAxisLine = (true);
//      },
//      legendSettingFunction: (legend, controller) {
//        legend..enabled = false;
//      },
//      drawGridBackground: false,
//      dragXEnabled: true,
//      dragYEnabled: true,
//      scaleXEnabled: true,
//      scaleYEnabled: true,
//      description: desc,
//    );
  }

  void initDateVariables() async {
    if (userId == null) {
      await getPreference();
    }
    this.selectedDate = DateTime.now();
    selectWeek(this.selectedDate);
//   this.selectedDateForMonth = DateTime.now();
//   this.selectedDateForWeek = DateTime.now();
    Future.delayed(Duration(milliseconds: 500)).then((_) async {
      // await getDayData();
      // await getWeekData();
      // await getMonthData();
      // setState(() {});
      getDataFromDb();
    });
  }

  getDayData() async {
    try {
      DateTime nextDay = DateTime(this.selectedDate.year,
          this.selectedDate.month, this.selectedDate.day + 1);
      String last = DateFormat(DateUtil.yyyyMMdd).format(nextDay);
      String first = DateFormat(DateUtil.yyyyMMdd).format(this.selectedDate);
      motionInfoListForDay =
          await databaseHelper.getActivityDataDateWise(first, last, userId!);

      List<LinearSales> stepsValuesDay = [];
      List<LinearSales> caloriesValuesDay = [];
      List<LinearSales> distanceValuesDay = [];

      for (int k = 1; k <= 24; k++) {
        stepsValuesDay.add(new LinearSales("$k h", k, 0));
        caloriesValuesDay.add(new LinearSales("$k h", k, 0));
        distanceValuesDay.add(new LinearSales("$k h", k, 0));
      }

      /* for (int i = 0; i < motionInfoListForDay.length; i++) {
        MotionInfoModel model = motionInfoListForDay[i];
        if (model != null) {
          DateTime dateTime = DateTime.parse(model.date);
          int index = stepsValuesDay.indexWhere((set) => set.x == dateTime.hour);
          if (index > -1) {
            stepsValuesDay[index].y = model.step;
            caloriesValuesDay[index].y = model.calories.toInt();
            distanceValuesDay[index].y = (model.distance * 1000).toInt();
          }
        }
      }
*/
      try {
        for (int i = 0; i < motionInfoListForDay.first.data!.length; i++) {
          stepsValuesDay[i].y = motionInfoListForDay.first.data![i];
        }
      } catch (e) {
        print(e);
      }

      seriesListForStep = [
        new charts.Series<LinearSales, int>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.x,
          measureFn: (LinearSales sales, _) => sales.y,
          data: stepsValuesDay,
        )..setAttribute(charts.rendererIdKey, 'customArea'),
      ];
      seriesListForCalories = [
        new charts.Series<LinearSales, int>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.x,
          measureFn: (LinearSales sales, _) => sales.y,
          data: caloriesValuesDay,
        )..setAttribute(charts.rendererIdKey, 'customArea'),
      ];
      seriesListForDistance = [
        new charts.Series<LinearSales, int>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.x,
          measureFn: (LinearSales sales, _) => sales.y,
          data: distanceValuesDay,
        )..setAttribute(charts.rendererIdKey, 'customArea'),
      ];
      stepChartForDayWidget = dayLineChart(seriesListForStep);
      // caloriesChartDayWidget = dayLineChart(seriesListForCalories);
      // distanceChartDayWidget = dayLineChart(seriesListForDistance);

      // Future.delayed(Duration(milliseconds: 500)).then((_) {
      //   setState(() {});
      // });
    } catch (e) {
      print(e);
    }
  }

  getWeekData() async {
    try {
      DateTime first = DateTime(
          firstDateOfWeek.year, firstDateOfWeek.month, firstDateOfWeek.day);
      DateTime last = DateTime(
          lastDateOfWeek.year, lastDateOfWeek.month, lastDateOfWeek.day + 1);
      String strFirst = DateFormat(DateUtil.yyyyMMdd).format(first);
      String strLast = DateFormat(DateUtil.yyyyMMdd).format(last);
      motionInfoListForWeek = await databaseHelper.getActivityDataDateWise(
          strFirst, strLast, userId!);
      List dateList = motionInfoListForWeek
          .map((e) => DateFormat(DateUtil.yyyyMMdd)
              .parse(e.date!)
              .millisecondsSinceEpoch)
          .toSet()
          .toList();
      List<MotionInfoModel> distinctDayList = [];
      dateList.forEach((element) {
        try {
          var model = motionInfoListForWeek.firstWhere((e) =>
              DateFormat(DateUtil.yyyyMMdd)
                  .parse(e.date!)
                  .millisecondsSinceEpoch ==
              element);
          if (!distinctDayList.contains(model)) {
            distinctDayList.add(model);
          }
        } catch (e) {
          print(e);
        }
      });
      motionInfoListForWeek = distinctDayList;
      print("Week $motionInfoListForWeek");

      List<Entry> stepsValues = [];
      List<Entry> caloriesValues = [];
      List<Entry> milesValues = [];

      int loopDay = first.day;
      for (int i = 0; i < 7; i++) {
        if (i > 0) {
          loopDay = DateTime(first.year, first.month, loopDay + 1).day;
        }
        MotionInfoModel? model;
        List<MotionInfoModel> listMotion = [];

        try {
          listMotion = motionInfoListForWeek.where((MotionInfoModel model) {
            DateTime dateTime =
                DateFormat(DateUtil.yyyyMMdd).parse(model.date!);
            print("${dateTime.day} == $loopDay :${dateTime.day == loopDay}");
            return dateTime.day == loopDay;
          }).toList();

          for (int j = 0; j < listMotion.length; j++) {
            MotionInfoModel localModel = MotionInfoModel.clone(listMotion[j]);
            if (j == 0) {
              model = MotionInfoModel.clone(localModel);
              model.step = 0;
              model.calories = 0;
              model.distance = 0;
            }
            model?.step = model.step! + localModel.step!;
            model?.calories = model.calories! + localModel.calories!;
            model?.distance = model.distance! + (localModel.distance! * 1000);
          }
        } catch (e) {
          print(e);
        }

        Entry stayUp = new Entry(x: i + 0.0, y: 0.0);
        Entry lightSleep = new Entry(x: i + 0.0, y: 0.0);
        Entry deepSleep = new Entry(x: i + 0.0, y: 0.0);

        if (model != null) {
          stayUp =
              new Entry(x: i + 0.0, y: (model.step! / listMotion.length) + 0.0);
          lightSleep = new Entry(
              x: i + 0.0, y: (model.calories! / listMotion.length) + 0.0);
          deepSleep = new Entry(
              x: i + 0.0, y: (model.distance! / listMotion.length) + 0.0);
        }

        stepsValues.add(stayUp);
        caloriesValues.add(lightSleep);
        milesValues.add(deepSleep);
      }

      //region sets
      LineDataSet stayUpDataSet = LineDataSet(stepsValues,
          StringLocalization.of(context).getText(StringLocalization.steps));
      stayUpDataSet.setLineWidth(1);
      stayUpDataSet.setCircleRadius(2);
      stayUpDataSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
      stayUpDataSet.setColor1(AppColor.red);
      stayUpDataSet.setCircleColor(AppColor.red);
      stayUpDataSet.setDrawValues(false);

      LineDataSet lightSleepSet = LineDataSet(caloriesValues,
          StringLocalization.of(context).getText(StringLocalization.calories));
      lightSleepSet.setLineWidth(1);
      lightSleepSet.setCircleRadius(2);
      lightSleepSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
      lightSleepSet.setColor1(AppColor.orangeColor);
      lightSleepSet.setCircleColor(AppColor.orangeColor);
      lightSleepSet.setDrawValues(false);

      LineDataSet deepSleepSet = LineDataSet(milesValues,
          StringLocalization.of(context).getText(StringLocalization.km));
      deepSleepSet.setLineWidth(1);
      deepSleepSet.setCircleRadius(2);
      deepSleepSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
      deepSleepSet.setColor1(AppColor.green);
      deepSleepSet.setCircleColor(AppColor.green);
      deepSleepSet.setDrawValues(false);

      //endregion

      stepsGraphControllerWeek!.data = LineData.fromList([stayUpDataSet]);
      caloriesGraphControllerWeek!.data = LineData.fromList([lightSleepSet]);
      mileGraphControllerWeek!.data = LineData.fromList([deepSleepSet]);

      setColorInGraph(stepsGraphControllerWeek, caloriesGraphControllerWeek,
          mileGraphControllerWeek);

      // setState(() {});
    } catch (e) {
      print(e);
    }
  }

  getMonthData() async {
    try {
      DateTime first =
          DateTime(this.selectedDate.year, this.selectedDate.month, 1);
      DateTime last =
          DateTime(this.selectedDate.year, this.selectedDate.month + 1, 0);
      String strFirst = DateFormat(DateUtil.yyyyMMdd).format(first);
      String strLast = DateFormat(DateUtil.yyyyMMdd).format(last);
      motionInfoListForMonth = await databaseHelper.getActivityDataDateWise(
          strFirst, strLast, userId!);
      List dateList = motionInfoListForMonth
          .map((e) => DateFormat(DateUtil.yyyyMMdd)
              .parse(e.date!)
              .millisecondsSinceEpoch)
          .toSet()
          .toList();
      List<MotionInfoModel> distinctDayList = [];
      dateList.forEach((element) {
        try {
          var model = motionInfoListForMonth.firstWhere((e) =>
              DateFormat(DateUtil.yyyyMMdd)
                  .parse(e.date!)
                  .millisecondsSinceEpoch ==
              element);
          if (!distinctDayList.contains(model)) {
            distinctDayList.add(model);
          }
        } catch (e) {
          print(e);
        }
      });
      motionInfoListForMonth = distinctDayList;
      print("month $motionInfoListForMonth");
      int xAxisCount = 30;
      if (last.day == 28 || last.day == 29) {
        xAxisCount = last.day;
      } else if (last.day % 2 == 0) {
        xAxisCount = 30;
      } else {
        xAxisCount = 31;
      }
      var desc = Description()..enabled = false;
      stepsGraphControllerMonth = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
            ..setLabelCount2(5, true)
            ..axisValueFormatter = YValueFormatter(stepsGraphControllerMonth)
            //          //..setAxisMaxValue(500)
            ..setAxisMinimum(1);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight..enabled = false;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
            ..position = (XAxisPosition.BOTTOM)
            ..drawGridLines = (false)
            ..setLabelCount2(xAxisCount, true)
            ..setAxisMinimum(0)
            ..setAxisMaximum(30)
            ..axisValueFormatter =
                MonthXValueFormatter(stepsGraphControllerMonth, first, last)
            ..drawAxisLine = (true);
        },
        legendSettingFunction: (legend, controller) {
          legend..enabled = false;
        },
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        description: desc,
      );
      caloriesGraphControllerMonth = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
            ..setLabelCount2(5, true)
            ..axisValueFormatter = YValueFormatter(caloriesGraphControllerMonth)
            //..setAxisMaxValue(500)
            ..setAxisMinimum(1);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight..enabled = false;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
            ..position = (XAxisPosition.BOTTOM)
            ..drawGridLines = (false)
            ..setLabelCount2(xAxisCount, true)
            ..setAxisMinimum(0)
            ..setAxisMaximum(30)
            ..axisValueFormatter =
                MonthXValueFormatter(caloriesGraphControllerMonth, first, last)
            ..drawAxisLine = (true);
        },
        legendSettingFunction: (legend, controller) {
          legend..enabled = false;
        },
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        description: desc,
      );
      mileGraphControllerMonth = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
            ..setLabelCount2(5, true)
            ..axisValueFormatter = YValueFormatter(mileGraphControllerMonth,
                unit: distanceUnit, isDistance: true)
            //..setAxisMaxValue(500)
            ..setAxisMinimum(1);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight..enabled = false;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..textColor = Theme.of(context).textTheme.bodyLarge!.color!
            ..position = (XAxisPosition.BOTTOM)
            ..drawGridLines = (false)
            ..setLabelCount2(xAxisCount, true)
            ..setAxisMinimum(0)
            ..setAxisMaximum(30)
            ..axisValueFormatter =
                MonthXValueFormatter(mileGraphControllerMonth, first, last)
            ..drawAxisLine = (true);
        },
        legendSettingFunction: (legend, controller) {
          legend..enabled = false;
        },
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        description: desc,
      );

      List<Entry> stepsValues = [];
      List<Entry> caloriesValues = [];
      List<Entry> milesValues = [];

      int daysOfMonth = last.difference(first).inDays + 1;

      int loopDay = first.day;
      for (int i = 0; i < daysOfMonth; i++) {
        if (i > 0) {
          loopDay = DateTime(first.year, first.month, loopDay + 1).day;
        }
        MotionInfoModel? model;
        List<MotionInfoModel> listMotion = [];

        try {
          listMotion = motionInfoListForMonth.where((MotionInfoModel? model) {
            DateTime dateTime =
                DateFormat(DateUtil.yyyyMMdd).parse(model!.date!);
            print("${dateTime.day} == $loopDay :${dateTime.day == loopDay}");
            return dateTime.day == loopDay;
          }).toList();

          for (int j = 0; j < listMotion.length; j++) {
            MotionInfoModel localModel = MotionInfoModel.clone(listMotion[j]);
            if (j == 0) {
              model = MotionInfoModel.clone(localModel);
              model.step = 0;
              model.calories = 0;
              model.distance = 0;
            }
            model!.step = model.step! + localModel.step!;
            model.calories = model.calories! + (localModel.calories!);
            model.distance = model.distance! + (localModel.distance! * 1000);
          }
        } catch (e) {
          print(e);
        }

        Entry stayUp = new Entry(x: i + 0.0, y: 0.0);
        Entry lightSleep = new Entry(x: i + 0.0, y: 0.0);
        Entry deepSleep = new Entry(x: i + 0.0, y: 0.0);

        if (model != null) {
          stayUp =
              new Entry(x: i + 0.0, y: (model.step! / listMotion.length) + 0.0);
          lightSleep = new Entry(
              x: i + 0.0, y: (model.calories! / listMotion.length) + 0.0);
          deepSleep = new Entry(
              x: i + 0.0, y: (model.distance! / listMotion.length) + 0.0);
        }

        stepsValues.add(stayUp);
        caloriesValues.add(lightSleep);
        milesValues.add(deepSleep);
      }

      //region sets
      LineDataSet stayUpDataSet = LineDataSet(stepsValues,
          StringLocalization.of(context).getText(StringLocalization.steps));
      stayUpDataSet.setLineWidth(1);
      stayUpDataSet.setCircleRadius(2);
      stayUpDataSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
      stayUpDataSet.setColor1(AppColor.red);
      stayUpDataSet.setCircleColor(AppColor.red);
      stayUpDataSet.setDrawValues(false);

      LineDataSet lightSleepSet = LineDataSet(caloriesValues,
          StringLocalization.of(context).getText(StringLocalization.calories));
      lightSleepSet.setLineWidth(1);
      lightSleepSet.setCircleRadius(2);
      lightSleepSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
      lightSleepSet.setColor1(AppColor.orangeColor);
      lightSleepSet.setCircleColor(AppColor.orangeColor);
      lightSleepSet.setDrawValues(false);

      LineDataSet deepSleepSet = LineDataSet(milesValues,
          StringLocalization.of(context).getText(StringLocalization.km));
      deepSleepSet.setLineWidth(1);
      deepSleepSet.setCircleRadius(2);
      deepSleepSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
      deepSleepSet.setColor1(AppColor.green);
      deepSleepSet.setCircleColor(AppColor.green);
      deepSleepSet.setDrawValues(false);

      //endregion

      stepsGraphControllerMonth!.data = LineData.fromList([stayUpDataSet]);
      caloriesGraphControllerMonth!.data = LineData.fromList([lightSleepSet]);
      mileGraphControllerMonth!.data = LineData.fromList([deepSleepSet]);

      setColorInGraph(stepsGraphControllerMonth, caloriesGraphControllerMonth,
          mileGraphControllerMonth);

      // setState(() {});
    } catch (e) {
      print(e);
    }
  }

  selectWeek(DateTime selectedDateWeek) {
    firstDateOfWeek = getDate(
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1)));
    lastDateOfWeek = getDate(selectedDate
        .add(Duration(days: DateTime.daysPerWeek - selectedDate.weekday)));
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future getPreference() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    String strJsonForStep =
        preferences?.getString(Constants.prefSavedStepTarget) ?? '';
    if (strJsonForStep != null && strJsonForStep.isNotEmpty) {
      Map map = jsonDecode(strJsonForStep);
      if (map != null && map.containsKey("userId")) {
        if (map["userId"] == userId) {
          if (map.containsKey("step") && map["step"] > 0) {
            targetSteps = map["step"].toDouble();
          } else {
            targetSteps = await connections.getStepTarget() + 0.0;
          }
        }
      } else {
        targetSteps = await connections.getStepTarget() + 0.0;
      }
    }
    String strJsonForDistance =
        preferences?.getString(Constants.prefSavedDistanceTarget) ?? '';
    if (strJsonForDistance != null && strJsonForDistance.isNotEmpty) {
      Map map = jsonDecode(strJsonForDistance);
      if (map != null && map.containsKey("userId")) {
        if (map["userId"] == userId) {
          if (map.containsKey("distance") && map["distance"] > 0) {
            targetDistance = map["distance"].toDouble();
          } else {
            targetDistance = await connections.getStepTarget() + 0.0;
          }
        }
      } else {
        targetDistance = await connections.getStepTarget() + 0.0;
      }
    }
  }

  getDataFromDb() async {
    switch (currentIndex) {
      case 0:
        await getDayData();
        break;
      case 1:
        await getWeekData();
        break;
      case 2:
        await getMonthData();
        break;
      default:
        await getDayData();
        await getWeekData();
        await getMonthData();
        break;
    }
    setState(() {});
  }
}

class XValueFormatter extends ValueFormatter {
  BarLineScatterCandleBubbleController? _controller;
  DateTime? firstDate;
  DateTime? lastDate;

  XValueFormatter(BarLineScatterCandleBubbleController? controller,
      this.firstDate, this.lastDate) {
    this._controller = controller;
  }

  @override
  String getFormattedValue1(double? value) {
    // print("value ${value.ceil()}");
    if (value != null) {
      DateTime day = DateTime(
          firstDate!.year, firstDate!.month, firstDate!.day + value.ceil());
      return "\n${DateFormat(DateUtil.EEE).format(day)}";
    }
    return '';
  }
}

class XValueFormatterForDay extends ValueFormatter {
  BarLineScatterCandleBubbleController? _controller;

  XValueFormatterForDay(BarLineScatterCandleBubbleController controller) {
    this._controller = controller;
  }

  @override
  String getFormattedValue1(double? v) {
    print("--- $v");
    String value = "";

    if (v != null &&
        (v.ceil() == 0 || v.ceil() % 5 == 0 || v.ceil() % 10 == 0)) {
      value = v.ceil().toString();
    }

    return "\n$value";
  }
}

class YValueFormatter extends ValueFormatter {
  BarLineScatterCandleBubbleController? _controller;
  bool? _isDistance = false;
  int? _unit = 0;

  YValueFormatter(BarLineScatterCandleBubbleController? controller,
      {unit = 0, isDistance = false}) {
    this._controller = controller!;
    this._isDistance = isDistance;
    this._unit = unit;
  }

  @override
  String getFormattedValue1(double? value) {
    if (value != null) {
      if (_isDistance!) {
        if (_unit == 1) {
          return '${(value.ceil() / 1609).toStringAsFixed(2)}      ';
        }
        return '${(value.ceil() / 1000).toStringAsFixed(2)}      ';
      }
      return "${value.ceil()}  .";
    }
    return '';
  }
}

class MonthXValueFormatter extends ValueFormatter {
  late BarLineScatterCandleBubbleController _controller;
  late DateTime firstDate;
  late DateTime lastDate;

  MonthXValueFormatter(BarLineScatterCandleBubbleController? controller,
      DateTime firstDate, DateTime lastDate) {
    this._controller = controller!;
    this.firstDate = firstDate;
    this.lastDate = lastDate;
    print("ddd = > ${this.firstDate} ${this.lastDate}");
  }

  @override
  String getFormattedValue1(double? value) {
    // int nValue;
    // if(value.ceil() == 0){
    //   nValue = value.ceil();
    // }else{
    //   nValue = value.ceil() - 1;
    // }
    if (value != null) {
      DateTime day = DateTime(
          firstDate.year, firstDate.month, firstDate.day + value.ceil());
      print("day ${day.day}");
      if (day.day % 5 != 0) {
        return "";
      }
      return "\n${day.day}";
    }
    return '';
  }
}

class LinearSales {
  String strX;
  int x;
  int y;

  LinearSales(this.strX, this.x, this.y);
}
