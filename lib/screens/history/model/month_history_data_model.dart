import 'package:charts_flutter/flutter.dart' as chart;
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/get_hr_data_response.dart';
import 'package:health_gauge/screens/history/week_and_month_history_data.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';

class MonthHistoryDataModel<T> {
  DateTime startDate;
  DateTime endDate;
  List<T> data;
  DefaultGraphItem fieldName;

  List<GraphItemData> graphItemDataList = [];
  List<GraphTypeModel> graphTypeList = [];
  List<GraphTypeModel> selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> graphDataLineSeries = [];

  MonthHistoryDataModel({
    required this.startDate,
    required this.endDate,
    required this.data,
    required this.fieldName,
  });

  Future<void> initializeData() async {
    if (data.isNotEmpty) {
      graphTypeList = await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
      if (graphTypeList.isNotEmpty) {
        if (fieldName.fieldName == DefaultGraphItem.hr.fieldName) {
          selectedGraphTypeList = [
            graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.hr.fieldName),
            // graphTypeList.firstWhere((element) =>
            //     element.fieldName ==
            //     DefaultGraphItem.healthKitHeartRate.fieldName),
            // graphTypeList.firstWhere((element) =>
            //     element.fieldName == DefaultGraphItem.healthKitSleep.fieldName),
            graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.allSleep.fieldName),
          ];
        } else {
          selectedGraphTypeList = [
            graphTypeList.firstWhere(
                (element) => element.fieldName == fieldName.fieldName)
          ];
        }

        if (selectedGraphTypeList.isNotEmpty) {
          await getHeartGraphData();

          graphDataLineSeries = LineGraphData(
                  graphItemList: graphItemDataList,
                  graphList: selectedGraphTypeList)
              .getLineGraphData();
        }
      }
    }
  }

  Future<void> getHeartGraphData() async {
    var date = startDate;
    graphItemDataList.clear();
    var _hrListTemp = <GraphItemData>[];
    while (date.isBefore(endDate.add(Duration(days: 1)))) {
      _hrListTemp.addAll(await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: date,
          endDate: date.add(Duration(days: 1)),
          selectedGraphTypes: selectedGraphTypeList,
          isEnableNormalize: false,
          unitType: 1));
      date = date.add(Duration(days: 1));
    }
    _hrListTemp.removeWhere((element) => element.yValue == 0);
    var temp = <GraphItemData>[];
    for (var element in _hrListTemp) {
      if (element.label == "approxHr" || element.label == "HeartRate") {


          var colorCode = '#ff9e99';

          temp.add(
            GraphItemData(
                yValue: element.yValue,
                xValue: element.xValue,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.date,
                edate: element.edate,
                type: element.type,
                colorCode: colorCode),
          );

        // return temp;
      } else if (element.label == "Sleep") {
        var sleepColorCode = '#121211';

        // toString().split(':')[0]
        var graphDateTemp = DateTime.parse(element.edate.toString());
        var graphDate = DateTime(
            graphDateTemp.year, graphDateTemp.month, graphDateTemp.day);

        var hours = int.parse(element.edate
            .toString()
            .split(" ")[1]
            .toString()
            .split(":")[0]
            .toString());
        var min = int.parse(element.edate
            .toString()
            .split(" ")[1]
            .toString()
            .split(":")[1]
            .toString());
        var xV = hours + min / 60;
        print(hours);
        print(min);
        print(xV);

        if (graphDate.isBefore(startDate)) {
          print(
              'The startDate is in the Past. ${graphDate.toString()} ${startDate.toString()}');
          temp.add(
            GraphItemData(
                yValue: 1,
                xValue: 1,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.edate,
                type: element.type,
                edate: element.date,
                colorCode: sleepColorCode
                // colorCode: element.colorCode
                ),
          );
          temp.add(
            GraphItemData(
                yValue: 1,
                xValue: element.xValue,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.date,
                type: element.type,
                edate: element.edate,
                colorCode: sleepColorCode),
          );
        } else if (graphDate.isAfter(startDate)) {
          temp.add(
            GraphItemData(
                yValue: 1,
                xValue: xV,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.edate,
                type: element.type,
                edate: element.date,
                colorCode: sleepColorCode),
          );

          temp.add(
            GraphItemData(
                yValue: 1,
                xValue: element.xValue,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.date,
                type: element.type,
                edate: element.edate,
                colorCode: sleepColorCode),
          );
          print(
              'The startDate is in the future. ${graphDate.toString()} ${startDate.toString()}');
        } else {
          print(
              'The startDate is in the Present. ${graphDate.toString()} ${startDate.toString()}');
          print(
              'The startDate is in the Present. ${element.edate.toString()} ${element.date.toString()}');

          temp.add(
            GraphItemData(
                yValue: 1,
                xValue: xV,
                // xValue: 1,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.edate,
                type: element.type,
                edate: element.date,
                colorCode: sleepColorCode),
          );

          temp.add(
            GraphItemData(
                // yValue: 1,
                // xValue: 7.15,
                yValue: 1,
                xValue: element.xValue,
                label: element.label,
                xValueStr: element.xValueStr,
                date: element.date,
                type: element.type,
                edate: element.edate,
                colorCode: sleepColorCode),
          );
        }

        // return temp;
      } else {
        print(element.label);
        temp.add(
          GraphItemData(
            yValue: element.yValue,
            xValue: element.xValue,
            label: element.label,
            xValueStr: element.xValueStr,
            date: element.date,
            type: element.type,
            edate: element.edate,
            // colorCode: element.colorCode,
            colorCode: '#ff9e99',
          ),
        );
        // return temp;
      }
    }
    graphItemDataList = temp;
  }

  List<chart.Series<GraphItemData, num>> getGraphLineSeries(
      DateTime startDate, DateTime endDate) {
    // var selectedGraphTypeList = getSelectedGraphTypeList();
    var graphItemList = getSpecificGraphData(startDate);
    return LineGraphData(
            graphItemList: graphItemList, graphList: selectedGraphTypeList)
        .getLineGraphData();
  }

  List<GraphTypeModel> getSelectedGraphTypeList() {
    return [
      graphTypeList
          .firstWhere((element) => element.fieldName == fieldName.fieldName),

      graphTypeList.firstWhere((element) =>
          element.fieldName == DefaultGraphItem.healthKitHeartRate.fieldName),
      graphTypeList.firstWhere((element) =>
          element.fieldName == DefaultGraphItem.healthKitSleep.fieldName),
      // graphTypeList.firstWhere((element) =>
      // element.fieldName == 'Zone 1'),
      // graphTypeList.firstWhere((element) =>
      // element.fieldName == 'Zone 2'),
      // graphTypeList.firstWhere((element) =>
      // element.fieldName == 'Zone 3'),
      // graphTypeList.firstWhere((element) =>
      // element.fieldName == 'Zone 4'),
      // graphTypeList.firstWhere((element) =>
      // element.fieldName == 'Zone 5'),
    ];
  }

  int? findAverage(List<List> list, DateTime date) {
    int? average;
    if (data is List<TempModel> ||
        data is List<BPModel> ||
        data is List<HrDataModel>) {
      if (list.isNotEmpty) {
        for (var l in list) {
          if (l.isNotEmpty) {
            var date1;
            if (data is List<TempModel>) {
              date1 = getDate((l[0] as TempModel).date);
            }
            if (data is List<BPModel>) {
              date1 = getDate((l[0] as BPModel).date);
            }
            if (data is List<HrDataModel>) {
              date1 = getDate((l[0] as HrDataModel).date);
            }
            if (date1 != null &&
                date1.year == date.year &&
                date1.month == date.month &&
                date1.day == date.day) {
              var count = 0;
              average = 0;
              for (var element in l) {
                num? avg;
                if (data is List<TempModel>) {
                  if (fieldName == DefaultGraphItem.oxygen) {
                    avg = (element as TempModel).oxygen;
                  } else {
                    avg = (element as TempModel).temperature;
                  }
                }
                if (data is List<BPModel>) {
                  avg = (element as BPModel).bloodDBP;
                }
                if (data is List<HrDataModel>) {
                  avg = (element as HrDataModel).hr;
                }
                if (avg != null && avg != 0) {
                  average = average! + avg.toInt();
                  count++;
                }
              }
              average = average! ~/ (count != 0 ? count : 1);
              break;
            }
          }
        }
      }
    }
    return average;
  }

  int? findSBPAverage(List<List> list, DateTime date) {
    int? average;
    if (data is List<TempModel> ||
        data is List<BPModel> ||
        data is List<HrDataModel>) {
      if (list.isNotEmpty) {
        for (var l in list) {
          if (l.isNotEmpty) {
            var date1;
            if (data is List<TempModel>) {
              date1 = getDate((l[0] as TempModel).date);
            }
            if (data is List<BPModel>) {
              date1 = getDate((l[0] as BPModel).date);
            }
            if (data is List<HrDataModel>) {
              date1 = getDate((l[0] as HrDataModel).date);
            }
            if (date1 != null &&
                date1.year == date.year &&
                date1.month == date.month &&
                date1.day == date.day) {
              var count = 0;
              average = 0;
              for (var element in l) {
                num? avg;
                if (data is List<TempModel>) {
                  if (fieldName == DefaultGraphItem.oxygen) {
                    avg = (element as TempModel).oxygen;
                  } else {
                    avg = (element as TempModel).temperature;
                  }
                }
                if (data is List<BPModel>) {
                  avg = (element as BPModel).bloodSBP;
                }
                if (data is List<HrDataModel>) {
                  avg = (element as HrDataModel).hr;
                }
                if (avg != null && avg != 0) {
                  average = average! + avg.toInt();
                  count++;
                }
              }
              average = average! ~/ (count != 0 ? count : 1);
              break;
            }
          }
        }
      }
    }
    return average;
  }

  List<GraphItemData> getSpecificGraphData(DateTime date) {
    List<GraphItemData> graphItemList = [];
    for (var element in graphItemDataList) {
      if (element.date != null && DateTime.tryParse(element.date!) != null) {
        var date1 = DateTime.parse(element.date!);
        if (date1.year == date.year &&
            date1.month == date.month &&
            date1.day == date.day) {
          graphItemList.add(element);
        } else if (element.label.contains("Zone ") && fieldName.fieldName == DefaultGraphItem.hr.fieldName) {

          String colorCode = "#008000";
          if (element.label == "Zone 1") {
            colorCode = "#008000";
          } else if (element.label == "Zone 2") {
            colorCode = "#90EE90";
          } else if (element.label == "Zone 3") {
            colorCode = "#FFFF00";
          } else if (element.label == "Zone 4") {
            colorCode = "#FFA500";
          } else if (element.label == "Zone 5") {
            colorCode = "#FF0000";
          }
          // GraphItemData _temp = GraphItemData(yValue: element.yValue,);
          element.colorCode = colorCode;
          graphItemList.add(element);
        }
      }
    }
    return graphItemList;
  }

  List<List> distinctList(var dataList) {
    var distinctList = [];
    try {
      dataList.removeWhere((element) {
        if (data is List<TempModel>) {
          if (fieldName == DefaultGraphItem.oxygen) {
            if ((element as TempModel).oxygen != null && element.oxygen == 0) {
              return true;
            }
          } else {
            if ((element as TempModel).temperature != null &&
                element.temperature == 0) {
              return true;
            }
          }
        }
        if (data is List<BPModel>) {
          if ((element as BPModel).bloodDBP != null && element.bloodDBP == 0) {
            return true;
          }
        }
        if (data is List<HrDataModel>) {
          if ((element as HrDataModel).hr != null && element.hr == 0) {
            return true;
          }
        }
        return false;
      });
    } catch (e) {
      LoggingService().printLog(message: e.toString());
    }
    try {
      dataList.forEach((var element) {
        if (element.date != null) {
          var date = DateFormat(DateUtil.yyyyMMddhhmm)
              .format(DateTime.parse(element.date!));
          var isExist = distinctList.any((e) {
            var dt;
            if (data is List<TempModel>) {
              dt = (e as TempModel).date;
            }
            if (data is List<BPModel>) {
              dt = (e as BPModel).date;
            }
            if (data is List<HrDataModel>) {
              dt = (e as HrDataModel).date;
            }
            if (dt != null) {
              var dateE =
                  DateFormat(DateUtil.yyyyMMddhhmm).format(DateTime.parse(dt!));
              return date == dateE;
            }
            return false;
          });
          if (!isExist) {
            if (data is List<TempModel>) {
              distinctList.add(TempModel.clone(element));
            }
            if (data is List<BPModel>) {
              distinctList.add(BPModel.clone(element));
            }
            if (data is List<HrDataModel>) {
              distinctList.add(HrDataModel.clone(element));
            }
          }
        }
      });
    } catch (e) {
      print('Exception at distinct list in temp $e');
    }
    var list = <List>[];
    try {
      if (data is List<TempModel>) {
        list = WeekAndMonthHistoryData(distinctList: distinctList)
            .getOxygenAndTempData();
      }
      if (data is List<BPModel>) {
        list = WeekAndMonthHistoryData(distinctList: distinctList).getBPData();
      }
      if (data is List<HrDataModel>) {
        list = WeekAndMonthHistoryData(distinctList: distinctList).getHRData();
      }
    } catch (e) {
      LoggingService()
          .printLog(tag: 'month history screen', message: e.toString());
    }
    return list;
  }

  DateTime? getDate(String? date) {
    if (date != null) {
      if (DateTime.tryParse(date) != null) {
        return DateTime.parse(date);
      }
    }
    return null;
  }
}
