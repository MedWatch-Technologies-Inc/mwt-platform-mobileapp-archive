import 'dart:developer';

import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_history_provider.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../repository/heart_rate_monitor/model/get_hr_data_response.dart';

class HeartRateDayDataProvider extends ChangeNotifier {
  List<HrDataModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool isAllFetched = false;

  int _avgHeartRate = 0;
  List<GraphItemData> _hrList = [];
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphTypeModel> _selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> _hrLineSeries = [];
  DateTime? _dateTime;
  DateTime? _startDate;
  DateTime? _endDate;

  set modelList(List<HrDataModel> value) {
    _modelList = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set isLoading(bool value) {
    _isLoading = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set isPageLoading(bool value) {
    _isPageLoading = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;

  bool get isPageLoading => _isPageLoading;

  List<HrDataModel> get modelList => _modelList;

  int get avgHeartRate => _avgHeartRate;

  set avgHeartRate(int value) {
    _avgHeartRate = value;
  }

  List<GraphItemData> get hrList => _hrList;


  set hrList(List<GraphItemData> value) {
    _hrList = value;
  }

  List<GraphTypeModel> get graphTypeList => _graphTypeList;

  set graphTypeList(List<GraphTypeModel> value) {
    _graphTypeList = value;
  }

  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;

  set selectedGraphTypeList(List<GraphTypeModel> value) {
    _selectedGraphTypeList = value;
  }

  List<chart.Series<GraphItemData, num>> get hrLineSeries => _hrLineSeries;

  set hrLineSeries(List<chart.Series<GraphItemData, num>> value) {
    _hrLineSeries = value;
  }

  DateTime get dateTime => _dateTime ?? DateTime.now();

  set dateTime(DateTime value) {
    _dateTime = value;
  }

  DateTime get startDate => _startDate ?? DateTime.now();

  set startDate(DateTime value) {
    _startDate = value;
  }

  DateTime get endDate => _endDate ?? DateTime.now();

  set endDate(DateTime value) {
    _endDate = value;
  }

  Future<List<HrDataModel>> getHistoryData(context) async {
    assert(context != null);
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider =
        Provider.of<HeartRateHistoryProvider>(context, listen: false);

    if (isLoading) {
      modelList.clear();
    }

    var startDate = provider.selectedDate;
    var endDate = provider.selectedDate.add(Duration(days: 1));
    var strStart = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strEnd = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();

    _dateTime = startDate;
    _startDate = DateTime.parse(strStart);
    _endDate = endDate;
    //var data = await dbHelper.getHrMonitoringTableData(userId!, strStart, strEnd, ids);
    List<HrDataModel> data =
        await dbHelper.getHrMonitoringTableData(userId!, strStart, strEnd, ids);
    if (data.length == 0) {
      isAllFetched = true;
    } else {
      isAllFetched = false;
    }
    // data = distinctList(data);
    modelList.addAll(data);

    await initializeData();
    isLoading = false;
    isPageLoading = false;

    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
    return Future.value(modelList);
  }

  DateTime getDate(String? date) {
    if (date != null) {
      if (DateTime.tryParse(date) != null) {
        return DateTime.parse(date);
      }
    }
    return DateTime.now();
  }

  Future<void> initializeData() async {
    // if (modelList.isNotEmpty) {
    if (true) {
      findAvgHeartRate();
      graphTypeList = await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
      if (graphTypeList.isNotEmpty) {
        _selectedGraphTypeList = [
          _graphTypeList.firstWhere(
              (element) => element.fieldName == DefaultGraphItem.hr.fieldName),

          // _graphTypeList.firstWhere((element) =>
          //     element.fieldName ==
          //     DefaultGraphItem.healthKitHeartRate.fieldName),
          // _graphTypeList.firstWhere((element) =>
          //     element.fieldName == DefaultGraphItem.healthKitSleep.fieldName),
          _graphTypeList.firstWhere((element) =>
              element.fieldName == DefaultGraphItem.allSleep.fieldName)
        ];
        print("dsfdsf1");
        print(_selectedGraphTypeList.map((e) => e.fieldName));
        print(_selectedGraphTypeList.map((e) => e.tableName));
        if (_selectedGraphTypeList.isNotEmpty) {

          await getHeartGraphData(startDate, endDate);

          _hrListNoData.clear();
          for (var element in _hrList) {
            _hrListNoData.add(element);
          }

          _hrLineSeries = LineGraphData(
                  graphItemList: _hrList, graphList: _selectedGraphTypeList)
              .getLineGraphData();
        }
      }
    }
  }
  List<GraphItemData> _hrListNoData = [];
  List<GraphItemData> get hrListNo => _hrListNoData;


  set hrListNo(List<GraphItemData> value) {
    _hrListNoData = value;
  }


  int findAvgHeartRate() {
    List<GraphItemData> temp = [];
    temp = _hrList;
    temp.removeWhere((element) =>
        element.label != "approxHr" || element.label != "HeartRate");

    List<int> avgList = [];
    for (var element in modelList) {
      avgList.add(int.parse(element.hr.toString()));
    }
    for (var element in temp) {
      avgList.add(int.parse(element.yValue.toStringAsFixed(0).toString()));
    }

    // if (modelList.isNotEmpty) {
    //   var count = 0;
    //   _avgHeartRate = 0;
    //   for (var element in modelList) {
    //     if (element.hr != null && element.hr != 0) {
    //       _avgHeartRate += element.hr!;
    //       count++;
    //     }
    //   }
    //   _avgHeartRate ~/= count != 0 ? count : 1;
    // } else
    avgList.sort();
      if (avgList.isNotEmpty) {
      var count = 0;
      _avgHeartRate = 0;
      for (var element in avgList) {
        if (element != null && element != 0) {
          _avgHeartRate += element.toInt();
          count++;
        }
      }
      _avgHeartRate ~/= count != 0 ? count : 1;
    }
    return _avgHeartRate;
  }

  int findLowestHeartRate() {
    List<GraphItemData> temp = [];
    temp = _hrList;
    temp.removeWhere((element) =>
        element.label != "approxHr" || element.label != "HeartRate");
print("findLowestHeartRate ${temp.map((e) => e.yValue)}");
print("findLowestHeartRate ${_hrList.map((e) => e.yValue)}");


    List<int> avgList = [];
    for (var element in modelList) {
      avgList.add(int.parse(element.hr.toString()));
    }
    for (var element in temp) {
      avgList.add(int.parse(element.yValue.toStringAsFixed(0).toString()));
    }
avgList.sort();
    // if (modelList.isNotEmpty) {
    //   var lowestHeartRate = double.infinity;
    //   for (var element in modelList) {
    //     if (element.hr != null &&
    //         element.hr != 0 &&
    //         element.hr! < lowestHeartRate) {
    //       lowestHeartRate = double.parse(element.hr.toString());
    //     }
    //   }
    //   return lowestHeartRate == double.infinity ? 0 : lowestHeartRate.toInt();
    // } else

      if (avgList.isNotEmpty) {
      var lowestHeartRate = double.infinity;
      for (var element in avgList) {
        if (element != null &&
            element != 0 &&
            element < lowestHeartRate) {
          lowestHeartRate = double.parse(element.toString());
        }
      }
      return lowestHeartRate == double.infinity ? 0 : lowestHeartRate.toInt();
    }
    return 0; // Return 0 if modelList is empty
  }

  // Future<void> getGraphData() async {
  //   _hrList = await GraphDataManager().graphManager(
  //       userId: globalUser?.userId ?? '',
  //       startDate: _startDate!,
  //       endDate: _endDate!,
  //       selectedGraphTypes: _selectedGraphTypeList,
  //       isEnableNormalize: false,
  //       unitType: 1);
  //   _hrList.removeWhere((element) => element.yValue == 0);
  // }

  Future<void> getHeartGraphData(DateTime startDate, DateTime endDate) async {
    var _hrListTemp = <GraphItemData>[];

    // var tstartDate = DateTime(startDate.year,startDate.month,startDate.day -1,0,0,0,0,0);
    // var tendDate = DateTime(endDate.year,endDate.month,endDate.day + 1,0,0,0,0,0);

    print("Datttttttt ${_hrListTemp.map((e) => e.xValue)}");
    print("Datttttttt ${_selectedGraphTypeList.map((e) => e.fieldName)}");
    // print(tstartDate);
    // print(tendDate);
    print(startDate);
    print(endDate);
    _hrListTemp = await GraphDataManager().graphManager(
        userId: globalUser?.userId ?? '',
        // startDate: tstartDate,
        // endDate: tendDate,
        startDate: startDate,
        endDate: endDate,
        selectedGraphTypes: _selectedGraphTypeList,
        isEnableNormalize: false,
        unitType: 1);
    _hrListTemp.removeWhere((element) => element.yValue == 0);
    log("Datttttttt ${_hrListTemp.map((e) => e.label).toList()}");

    var temp = <GraphItemData>[];
    for (var element in _hrListTemp) {
      if (element.label == "approxHr" || element.label == "HeartRate") {

          var colorCode = '#ff9e99';

          temp.add(
            GraphItemData(
                yValue: element.yValue,
                xValue: element.xValue,
                // label: element.label,
                label: "approxHr",
                xValueStr: element.xValueStr,
                date: element.date,
                edate: element.edate,
                type: element.type,
                colorCode: colorCode),
          );

        // return temp;
      } else if (element.label == "Sleep") {
        var sleepColorCode = '#121211';
        print("sleeeeeeppppp" + element.label);
        print("sleeeeeeppppp" + element.colorCode.toString());

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
              colorCode: element.colorCode),
        );
        // return temp;
      }
    }
    _hrList = temp;
    log("Final Data" + _hrList.map((e) => e.label).toList().toString());
    log("Final Data" + _hrList.map((e) => e.colorCode).toList().toString());
    // return temp;
  }

  reset() {
    _modelList = [];
    _isLoading = true;
    _isPageLoading = false;
  }
}
