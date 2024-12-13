import 'package:charts_flutter/flutter.dart' as chart;

import 'package:flutter/material.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import '../graph_item_data.dart';

class CustomLineChart extends StatefulWidget {
  final List<GraphItemData> list;
  final bool isInterpolationEnable;
  final List<GraphTypeModel> selectedGraphTypeList;
  final DateTime selectedDate;
  final GraphTab graphTab;

  const CustomLineChart({
    required this.list,
    required this.isInterpolationEnable,
    required this.selectedGraphTypeList,
    required this.selectedDate,
    required this.graphTab,
  });

  @override
  _CustomLineChartState createState() => _CustomLineChartState(list,
      isInterpolationEnable, selectedGraphTypeList, selectedDate, graphTab);
}

class _CustomLineChartState extends State<CustomLineChart> {
  final List<GraphItemData> list;
  final bool isInterpolationEnable;
  final List<GraphTypeModel> selectedGraphTypeList;
  final DateTime selectedDate;
  final GraphTab graphTab;

  _CustomLineChartState(this.list, this.isInterpolationEnable,
      this.selectedGraphTypeList, this.selectedDate, this.graphTab){
    print('$list');
  }

  @override
  Widget build(BuildContext context) {
    var series = generateLineChartLabelWise(list, graphTab.index + 1, []);
    if(series.length > 1) {
      series[1]
        ..setAttribute(
          chart.measureAxisIdKey,
          chart.Axis.secondaryMeasureAxisId,
        );
    }
    return chart.LineChart(
        series,
        animate: true,
        customSeriesRenderers:
          selectedGraphTypeList.length == 1 ? [
            chart.LineRendererConfig(customRendererId: selectedGraphTypeList[0].fieldName,
            includeArea: false,
            stacked: true,
            includePoints: true,
            includeLine: true,
            roundEndCaps: true,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ) ]: List.generate(selectedGraphTypeList.length, (index) {
            return chart.LineRendererConfig(customRendererId: selectedGraphTypeList[index].fieldName,
              includeArea: false,
              stacked: true,
              includePoints: true,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 1.0,
              strokeWidthPx: 1.0,
            );
          },
          ),
        /*customSeriesRenderers:
            List.generate(selectedGraphTypeList.length, (index) {
          return chart.LineRendererConfig(customRendererId: selectedGraphTypeList[0].fieldName,
            includeArea: false,
            stacked: true,
            includePoints: true,
            includeLine: true,
            roundEndCaps: true,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          );
        },
            ),*/
        secondaryMeasureAxis: new chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: new chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
        ),
        primaryMeasureAxis: new chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
              fontSize: 10,
              color: Theme.of(context).brightness == Brightness.dark
                  ? chart.MaterialPalette.white
                  : chart.MaterialPalette.black,
            ),
          ),
          tickProviderSpec: new chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
        ),
        domainAxis: new chart.NumericAxisSpec(
          tickProviderSpec: new chart.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredMinTickCount: xAxisCountForLineChart(),
            desiredMaxTickCount: xAxisCountForLineChart(),
            dataIsInWholeNumbers: true,
            desiredTickCount: xAxisCountForLineChart(),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec((val) {
            if(graphTab == GraphTab.week){
              return getDayNameFromWeekDay(val!.toInt());
            }
            try {
              if(val!.toInt() %2 ==0){
                return '';
              }
              return '${val.toInt()}';
            } catch (e) {
              print(e);
            }
            return '${val!.toInt()}';
          }),
        )

    );
  }

  List<chart.Series<GraphItemData, num>>  generateLineChartLabelWise(List<GraphItemData> list, int graphTabType, List<chart.Series<GraphItemData, num>> seriesReference) {
    try {
      List<GraphItemData> listOfData = list.map((e) => GraphItemData.clone(e)).toList();
      if (graphTabType == 1) {
        List<GraphItemData> newDataList = [];
        var distinctList = <GraphItemData>[];
        GraphItemData? firstValueModel;

        //region filter list and sort list
        listOfData.removeWhere((element) => element.date == null || (isInterpolationEnable && element.yValue == 0));
        if(listOfData.length < 1){
          return [];
        }
        listOfData.forEach((element) {
          try {
            int day = DateTime.parse(element.date!).hour;
            bool exist = distinctList.any((e) => DateTime.parse(e.date!).hour == day && e.label == element.label);
            if (!exist) {
              distinctList.add(element);
            }
          } catch (e) {
            print('Exception in generateLineChartLabelWise $e');
            distinctList.add(element);
          }
        });
        listOfData = distinctList;
        try {
          listOfData.sort((a, b) =>
              DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
        } catch (e) {
          print('Exception in generateLineChartLabelWise $e');
        }
        //endregion

        for (int a = 0; a < selectedGraphTypeList.length; a++) {
          newDataList.clear();
          GraphTypeModel graphTypeModel = selectedGraphTypeList[a];
          GraphItemData? firstValueModelForSelectedType;
          int index = listOfData.indexWhere((element) => element != null && element.label == graphTypeModel.fieldName);
          if (index > -1) {
            firstValueModelForSelectedType = listOfData[index];
          }
          for (int i = 1; i <= 24; i++) {
            int index = listOfData.indexWhere((element) =>
                DateTime.parse(element.date!).hour == i &&
                element.label == graphTypeModel.fieldName);
            if (index > -1) {
              GraphItemData model = GraphItemData.clone(listOfData[index]);
              newDataList.add(model);
            } else if (i == 1 && firstValueModelForSelectedType != null) {
              if (isInterpolationEnable) {
                var model = GraphItemData.clone(firstValueModelForSelectedType);
                model.xValue = i.toDouble();
                newDataList.add(model);
              } else {
                var item = GraphItemData(
                    yValue: 0,
                    xValue: i.toDouble(),
                    xValueStr: i.toString(),
                    colorCode: "#99D9D9",
                    label: i.toString(),
                    date: firstValueModelForSelectedType.date);
                newDataList.add(item);
              }
            }
          }

          Color? color;
          try {
            if(firstValueModel != null) color = HexColor.fromHex(firstValueModel.colorCode!);
          } catch (e) {
            print('Exception while parsing color $e');
          }

          color ??= AppColor.primaryColor;

          chart.Series<GraphItemData, num> seriesModel = new chart.Series<GraphItemData, num>(
            id: firstValueModel?.type ?? DateTime.now().toString(),
            colorFn: (_, __) => chart.Color(
              a: color!.alpha,
              r: color.red,
              g: color.green,
              b: color.blue,
            ),
            domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
            measureFn: (GraphItemData sales, _) => sales.yValue,
            data: newDataList,
          )..setAttribute(chart.rendererIdKey, firstValueModelForSelectedType?.label ?? '');
          seriesReference.add(seriesModel);
        }
/*
        //region single type
        int index = listOfData.indexWhere((element) => element != null);
        if (index > -1) {
          firstValueModel = listOfData[index];
        }
        for (int i = 1; i < 24; i++) {
          int index = listOfData.indexWhere((element) => DateTime.parse(element.date).hour == i);
          if (index > -1) {
            GraphItemData model = listOfData[index];
            newDataList.add(model);
          } else if (i == 1 && firstValueModel != null) {
            if (isInterpolationEnable) {
              var model = GraphItemData.clone(firstValueModel);
              model.xValue = i.toDouble();
              newDataList.add(model);
            } else {
              var item = GraphItemData(
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toString(),
                  colorCode: "#99D9D9",
                  label: i.toString(),
                  date: firstValueModel.date);
              newDataList.add(item);
            }
          }
        }
        //endregion




        Color color;
        try {
          if (listOfData.length > 0) {
            int i = selectedGraphTypeList.indexWhere((element) => element.fieldName == listOfData.first.label);
            if (i > -1) {
              String code = selectedGraphTypeList[i]?.color;
              color = HexColor.fromHex(code);
            }
          }
        } catch (e) {
          print('Exception at graphTypeModel $e');
        }
        color ??= AppColor.primaryColor;
        var seriesModel = new chart.Series<GraphItemData, num>(
          id: firstValueModel?.type ?? DateTime.now().toString(),
          colorFn: (_, __) => chart.Color(
            a: color.alpha,
            r: color.red,
            g: color.green,
            b: color.blue,
          ),
          domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
          measureFn: (GraphItemData sales, _) => sales.yValue,
          data: newDataList,
        )..setAttribute(chart.rendererIdKey, firstValueModel?.label ?? '');

        seriesReference ??= [];

        seriesReference?.add(seriesModel);*/
        return seriesReference;
      }
      else if (graphTabType == 2) {
        List<GraphItemData> newDataList = [];
        var distinctList = <GraphItemData>[];
        GraphItemData? firstValueModel;

        listOfData.removeWhere((element) =>
            element.date!.isNotEmpty ||
            (isInterpolationEnable && element.yValue == 0));
        listOfData.forEach((element) {
          try {
            int day = DateTime.parse(element.date!).hour;
            bool exist =
                distinctList.any((e) => DateTime.parse(e.date!).hour == day);
            if (!exist) {
              distinctList.add(element);
            }
          } catch (e) {
            print('Exception in generateLineChartLabelWise $e');
            distinctList.add(element);
          }
        });
        listOfData = distinctList;
        try {
          listOfData.sort((a, b) =>
              DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
        } catch (e) {
          print('Exception in generateLineChartLabelWise $e');
        }
        int index = listOfData.indexWhere((element) => element != null);
        if (index > -1) {
          firstValueModel = listOfData[index];
        }
        for (int i = 1; i < 8; i++) {
          int index = listOfData.indexWhere(
              (element) => DateTime.parse(element.date!).weekday == i);
          if (index > -1) {
            GraphItemData model = listOfData[index];
            newDataList.add(model);
          } else if (i == 1 && firstValueModel != null) {
            if (isInterpolationEnable) {
              var model = GraphItemData.clone(firstValueModel);
              model.xValue = i.toDouble();
              newDataList.add(model);
            } else {
              var item = GraphItemData(
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toString(),
                  colorCode: "#99D9D9",
                  label: i.toString(),
                  date: firstValueModel.date);
              newDataList.add(item);
            }
          }
        }
        Color? color;
        try {
          if (listOfData.length > 0) {
            int i = selectedGraphTypeList.indexWhere(
                (element) => element.fieldName == listOfData.first.label);
            if (i > -1) {
              String code = selectedGraphTypeList[i].color;
              color = HexColor.fromHex(code);
            }
          }
        } catch (e) {
          print('Exception at graphTypeModel $e');
        }
        color ??= AppColor.primaryColor;
        var seriesModel = new chart.Series<GraphItemData, num>(
          id: firstValueModel?.type ?? DateTime.now().toString(),
          colorFn: (_, __) => chart.Color(
            a: color!.alpha,
            r: color.red,
            g: color.green,
            b: color.blue,
          ),
          domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
          measureFn: (GraphItemData sales, _) => sales.yValue,
          data: newDataList,
        )..setAttribute(chart.rendererIdKey, firstValueModel?.label ?? '');

        seriesReference.add(seriesModel);
        return seriesReference;
      } else if (graphTabType == 3) {
        List<GraphItemData> newDataList = [];
        var distinctList = <GraphItemData>[];
        GraphItemData? firstValueModel;

        listOfData.removeWhere((element) =>
            element.date!.isNotEmpty ||
            (isInterpolationEnable && element.yValue == 0));
        listOfData.forEach((element) {
          try {
            int day = DateTime.parse(element.date!).hour;
            bool exist =
                distinctList.any((e) => DateTime.parse(e.date!).hour == day);
            if (!exist) {
              distinctList.add(element);
            }
          } catch (e) {
            print('Exception in generateLineChartLabelWise $e');
            distinctList.add(element);
          }
        });
        listOfData = distinctList;
        try {
          listOfData.sort((a, b) =>
              DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
        } catch (e) {
          print('Exception in generateLineChartLabelWise $e');
        }
        int index = listOfData.indexWhere((element) => element != null);
        if (index > -1) {
          firstValueModel = listOfData[index];
        }
        int totalDays = DateUtil()
            .daysInMonth(selectedDate.month, selectedDate.year);
        for (int i = 1; i <= totalDays; i++) {
          int index = listOfData
              .indexWhere((element) => DateTime.parse(element.date!).day == i);
          if (index > -1) {
            GraphItemData model = listOfData[index];
            newDataList.add(model);
          } else if (i == 1 && firstValueModel != null) {
            if (isInterpolationEnable) {
              var model = GraphItemData.clone(firstValueModel);
              model.xValue = i.toDouble();
              newDataList.add(model);
            } else {
              var item = GraphItemData(
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toString(),
                  colorCode: "#99D9D9",
                  label: i.toString(),
                  date: firstValueModel.date);
              newDataList.add(item);
            }
          }
        }
        Color? color;
        try {
          if (listOfData.length > 0) {
            int i = selectedGraphTypeList.indexWhere(
                (element) => element.fieldName == listOfData.first.label);
            if (i > -1) {
              String code = selectedGraphTypeList[i].color;
              color = HexColor.fromHex(code);
            }
          }
        } catch (e) {
          print('Exception at graphTypeModel $e');
        }
        color ??= AppColor.primaryColor;
        var seriesModel = new chart.Series<GraphItemData, num>(
          id: firstValueModel?.type ?? DateTime.now().toString(),
          colorFn: (_, __) => chart.Color(
            a: color!.alpha,
            r: color.red,
            g: color.green,
            b: color.blue,
          ),
          domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
          measureFn: (GraphItemData sales, _) => sales.yValue,
          data: newDataList,
        )..setAttribute(chart.rendererIdKey, firstValueModel?.label ?? '');

        seriesReference.add(seriesModel);
        return seriesReference;
      }
    } catch (e) {
      print('Exception at generate line chart $e');
    }
    return [];
  }

  getDayNameFromWeekDay(val) {
    switch (val) {
      case 1:
        return 'Mon';
        break;
      case 2:
        return 'Tue';
        break;
      case 3:
        return 'Wed';
        break;
      case 4:
        return 'Thus';
        break;
      case 5:
        return 'Fri';
        break;
      case 6:
        return 'Sat';
        break;
      case 7:
        return 'Sun';
        break;
    }
    return '';
  }


  int xAxisCountForLineChart() {
    int totalDays =
        DateUtil().daysInMonth(selectedDate.month, selectedDate.year);
    switch (graphTab.index) {
      case 0:
        return 24;
      case 1:
        return 7;
      case 2:
        return totalDays;
      default:
        return 24;
    }
  }
}
