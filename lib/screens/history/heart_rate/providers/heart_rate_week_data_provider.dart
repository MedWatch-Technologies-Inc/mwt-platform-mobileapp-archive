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
import 'package:health_gauge/models/measurement/measurement_history_model.dart';

import '../../../../repository/heart_rate_monitor/model/get_hr_data_response.dart';

class HeartRateWeekDataProvider extends ChangeNotifier {
  List<HrDataModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool _isAllFetched = false;

  List<GraphItemData> _hrList = [];
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphTypeModel> _selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> _hrLineSeries = [];

  DateTime _startDate = DateTime.now();

  bool get isAllFetched => _isAllFetched;

  int _currentListIndex = 0;
  bool _showDetails = false;

  bool get showDetails => _showDetails;

  int get currentListIndex => _currentListIndex;

  set currentListIndex(int value) {
    _currentListIndex = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set showDetails(bool value) {
    _showDetails = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set isAllFetched(bool value) {
    _isAllFetched = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  List<HrDataModel> get modelList => _modelList;

  set modelList(List<HrDataModel> value) {
    _modelList = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  List<GraphTypeModel> get graphTypeList => _graphTypeList;

  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;

  List<chart.Series<GraphItemData, num>> get hrLineSeries => _hrLineSeries;

  List<GraphItemData> get hrList => _hrList;

  DateTime get startDate => _startDate;

  Future<List<HrDataModel>> getHistoryData(context) async {
    assert(context != null);
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider =
        Provider.of<HeartRateHistoryProvider>(context, listen: false);

    if (isLoading) {
      modelList.clear();
    }

    var startDate = provider.firstDateOfWeek;
    var endDate = provider.lastDateOfWeek.add(Duration(days: 1));
    var strStart = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strEnd = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();
    _startDate = DateTime(startDate.year, startDate.month, startDate.day);

    // var data = await dbHelper.getHeartRateData(userId!, strStart, strEnd, ids);
    // if (data.length == 0) {
    //   isAllFetched = true;
    // } else {
    //   isAllFetched = false;
    // }
    // // data = distinctList(data);
    // modelList.addAll(data);
    await getHrDataFromDb(id: userId!, strDate: strStart, endDate: strEnd);

    await initializeData(
        _startDate, DateTime(endDate.year, endDate.month, endDate.day));

    isLoading = false;
    isPageLoading = false;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
    return Future.value(modelList);
  }

  Future<List<HrDataModel>> getHrDataFromDb(
      {String? id, String? strDate, String? endDate}) async {
    var ids = modelList.map((e) => (e.id ?? -1)).toList();
    // var data = await dbHelper.getHeartRateData(id!, strDate!, endDate!, ids);
    List<HrDataModel> data =
        await dbHelper.getHrMonitoringTableData(id!, strDate!, endDate!, ids);
    modelList.addAll(data);
    if (data != null && data.length == 20) {
      await getHrDataFromDb(id: id, strDate: strDate, endDate: endDate);
    }
    return Future.value(modelList);
  }

  Future<void> initializeData(DateTime startDate, DateTime endDate) async {
    // if(modelList.isNotEmpty) {
    _graphTypeList = await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
    if (_graphTypeList.isNotEmpty) {
      _selectedGraphTypeList = [
        _graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.hr.fieldName),
        // _graphTypeList.firstWhere((element) =>
        //     element.fieldName == DefaultGraphItem.healthKitHeartRate.fieldName),
        // _graphTypeList.firstWhere((element) =>
        //     element.fieldName == DefaultGraphItem.healthKitSleep.fieldName),
        _graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.allSleep.fieldName),
      ];
      // if (_selectedGraphTypeList.isNotEmpty) {
      await getHeartGraphData(startDate, endDate);

      _hrLineSeries = LineGraphData(
              graphItemList: _hrList, graphList: _selectedGraphTypeList)
          .getLineGraphData();
      // }
    }
    // }
  }

  // Future<void> getGraphData(DateTime startDate, DateTime endDate) async {
  //   var date = startDate;
  //   _hrList.clear();
  //   while(date.isBefore(endDate.add(Duration(days: 1)))) {
  //     _hrList.addAll( await GraphDataManager().graphManager(
  //         userId: globalUser?.userId ?? '',
  //         startDate: date,
  //         endDate: date.add(Duration(days: 1)),
  //         selectedGraphTypes: _selectedGraphTypeList,
  //         isEnableNormalize: false,
  //         unitType: 1));
  //     date = date.add(Duration(days: 1));
  //   }
  //   _hrList.removeWhere((element) => element.yValue == 0);
  // }

  Future<void> getHeartGraphData(DateTime startDate, DateTime endDate) async {
    var _hrListTemp = <GraphItemData>[];
    var date = startDate;
    print("wekk start date ${startDate.toString()} ${endDate.toString()}");
    // var tstartDate = DateTime(startDate.year,startDate.month,startDate.day -1,0,0,0,0,0);
    // var tendDate = DateTime(endDate.year,endDate.month,endDate.day + 1,0,0,0,0,0);

    print("Datttttttt ${_hrListTemp.map((e) => e.xValue)}");
    while (date.isBefore(endDate.add(Duration(days: 1)))) {
      _hrListTemp.addAll(await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: date,
          endDate: date.add(Duration(days: 1)),
          selectedGraphTypes: _selectedGraphTypeList,
          isEnableNormalize: false,
          unitType: 1));
      date = date.add(Duration(days: 1));
    }
    _hrListTemp.removeWhere((element) => element.yValue == 0);
    // log("Datttttttt ${_hrListTemp.map((e) => e.label).toList()}");

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
            // colorCode: element.colorCode,
            colorCode: '#ff9e99',
          ),
        );
        // return temp;
      }
    }
    _hrList = temp;
    log("Final Data" + _hrList.map((e) => e.label).toList().toString());
    log("Final Data" + _hrList.map((e) => e.colorCode).toList().toString());
    // return temp;
  }

  DateTime? getDate(String? date) {
    if (date != null) {
      if (DateTime.tryParse(date) != null) {
        return DateTime.parse(date);
      }
    }
  }

  List<chart.Series<GraphItemData, num>> getHrLineSeries(
      DateTime startDate, DateTime endDate) {
    // var selectedGraphTypeList = getSelectedGraphTypeList();
    var hrList = getSpecificGraphData(startDate);

    return LineGraphData(
            graphItemList: hrList, graphList: selectedGraphTypeList)
        .getLineGraphData();
  }

  // var hrZone = HRZoneHelper();
  //
  // ...List.generate(hrZone.hrZoneList.value.length, (index) {
  //
  // });


  List<GraphTypeModel> getSelectedGraphTypeList() {
    return [
      _graphTypeList.firstWhere(
          (element) => element.fieldName == DefaultGraphItem.hr.fieldName),
      _graphTypeList.firstWhere((element) =>
          element.fieldName == DefaultGraphItem.healthKitHeartRate.fieldName),
      _graphTypeList.firstWhere((element) =>
          element.fieldName == DefaultGraphItem.healthKitSleep.fieldName),

    //   _graphTypeList.add(GraphTypeModel(
    // name: element.zone,
    // fieldName: element.zone,
    // tableName: element.zone,
    // color: colorCode,
    // image: element.zone))
      _selectedGraphTypeList.firstWhere((element) =>
      element.fieldName == DefaultGraphItem.zone1.fieldName),
      _selectedGraphTypeList.firstWhere((element) =>
      element.fieldName == DefaultGraphItem.zone2.fieldName),
      _selectedGraphTypeList.firstWhere((element) =>
      element.fieldName == DefaultGraphItem.zone3.fieldName),
      _selectedGraphTypeList.firstWhere((element) =>
      element.fieldName == DefaultGraphItem.zone4.fieldName),
      _selectedGraphTypeList.firstWhere((element) =>
      element.fieldName == DefaultGraphItem.zone5.fieldName),

    ];
  }

  int? findAvgHeartRate(List<List<HrDataModel>> list, DateTime date) {
    int? avgHeartRate;
    if (list.isNotEmpty) {
      for (var l in list) {
        if (l.isNotEmpty) {
          var date1 = getDate(l[0].date);
          if (date1 != null &&
              date1.year == date.year &&
              date1.month == date.month &&
              date1.day == date.day) {
            var count = 0;
            avgHeartRate = 0;
            for (var element in l) {
              if (element.hr != null && element.hr != 0) {
                avgHeartRate = avgHeartRate! + element.hr!;
                count++;
              }
            }
            avgHeartRate = avgHeartRate! ~/ (count != 0 ? count : 1);
            break;
          }
        }
      }
    }
    return avgHeartRate;
  }

  List<GraphItemData> getSpecificGraphData(DateTime date) {
    List<GraphItemData> hrList = [];
    for (var element in _hrList) {
      if (element.date != null && DateTime.tryParse(element.date!) != null) {
        var date1 = DateTime.parse(element.date!);
        if (date1.year == date.year &&
            date1.month == date.month &&
            date1.day == date.day) {
          hrList.add(element);
        }else if(element.label.contains("Zone ")){
String   colorCode = "#008000";
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
          hrList.add(element);
        }
      }
    }
    return hrList;
  }

  void reset() async {
    _modelList = [];
    _isLoading = true;
    _isPageLoading = false;
  }
}
