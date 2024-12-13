import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'blood_pressure_history_provider.dart';

class BloodPressureDayDataProvider extends ChangeNotifier {
  List<BPModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool isAllFetched = false;
  int _avgDBP = 0;
  int _avgSBP = 0;
  int _avgBloodPressure = 0;
  List<GraphItemData> _bloodPressureList = [];
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphTypeModel> _selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> _bloodPressureLineSeries = [];
  DateTime? _dateTime;
  DateTime? _startDate;
  DateTime? _endDate;

  set modelList(List<BPModel> value) {
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

  List<BPModel> get modelList => _modelList;

  int get avgBloodPressure => _avgBloodPressure;

  set avgBloodPressure(int value) {
    _avgBloodPressure = value;
  }

  List<GraphItemData> get bloodPressureList => _bloodPressureList;

  set bloodPressureList(List<GraphItemData> value) {
    _bloodPressureList = value;
  }

  List<GraphTypeModel> get graphTypeList => _graphTypeList;

  set graphTypeList(List<GraphTypeModel> value) {
    _graphTypeList = value;
  }

  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;

  set selectedGraphTypeList(List<GraphTypeModel> value) {
    _selectedGraphTypeList = value;
  }

  List<chart.Series<GraphItemData, num>> get bloodPressureLineSeries => _bloodPressureLineSeries;

  set bloodPressureLineSeries(List<chart.Series<GraphItemData, num>> value) {
    _bloodPressureLineSeries = value;
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

  Future<List<BPModel>> getHistoryData(context) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider =
        Provider.of<BloodPressureHistoryProvider>(context, listen: false);

    if (isLoading) {
      modelList.clear();
    }

    var startDate = provider.selectedDate;
    var endDate = provider.selectedDate.add(Duration(days: 1));
    var strStart = DateFormat('yyyy-MM-dd').format(startDate);
    var strEnd = DateFormat('yyyy-MM-dd').format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();

    _dateTime = startDate;
    _startDate = DateTime.parse(strStart);
    _endDate = endDate;
    List<BPModel> data = await dbHelper.getBloodPressureTableData(
        userId!, strStart, strEnd, ids);
    await Future.delayed(Duration(seconds: 3));
    if (data.isEmpty) {
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

  Future<void> initializeData() async {
    if(modelList.isNotEmpty) {
      findAvgBloodPressure();
      graphTypeList = await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
      if (graphTypeList.isNotEmpty) {
        _selectedGraphTypeList = [
          _graphTypeList.firstWhere(
                  (element) =>
              element.fieldName == DefaultGraphItem.oxygen.fieldName)
        ];
        if (_selectedGraphTypeList.isNotEmpty) {
          await getGraphData();
          _bloodPressureLineSeries =
              LineGraphData(
                  graphItemList: _bloodPressureList, graphList: _selectedGraphTypeList)
                  .getLineGraphData();
        }
      }
    }
  }

  int findAvgBloodPressure() {
    if (modelList.isNotEmpty) {
      var count = 0;
      _avgBloodPressure = 0;
      for (var element in modelList) {
        if (element.bloodDBP != null && element.bloodDBP != 0) {
          _avgBloodPressure += element.bloodDBP!.toInt();
          count++;
        }
      }
      _avgBloodPressure ~/= count != 0 ? count : 1;
    }
    return _avgBloodPressure;
  }

  int findAvgDBP() {
    if (modelList.isNotEmpty) {
      var count = 0;
      _avgDBP = 0;
      for (var element in modelList) {
        if (element.bloodDBP != null && element.bloodDBP != 0) {
          _avgDBP += element.bloodDBP!.toInt();
          count++;
        }
      }
      _avgDBP ~/= count != 0 ? count : 1;
    }
    return _avgDBP;
  }
  int findAvgSBP() {
    if (modelList.isNotEmpty) {
      var count = 0;
      _avgSBP = 0;
      for (var element in modelList) {
        if (element.bloodSBP != null && element.bloodSBP != 0) {
          _avgSBP += element.bloodSBP!.toInt();
          count++;
        }
      }
      _avgSBP ~/= count != 0 ? count : 1;
    }
    return _avgSBP;
  }
  Future<void> getGraphData() async {
    _bloodPressureList = await GraphDataManager().graphManager(
        userId: globalUser?.userId ?? '',
        startDate: _startDate!,
        endDate: _endDate!,
        selectedGraphTypes: _selectedGraphTypeList,
        isEnableNormalize: false,
        unitType: 1);
    _bloodPressureList.removeWhere((element) => element.yValue == 0);
  }

  List<BPModel> distinctList(List<BPModel> dataList) {
    var distinctList = <BPModel>[];

    try {
      for (var element in dataList) {
        if (element.date != null) {
          var date = DateFormat('yyyy-MM-dd hh:mm')
              .format(DateTime.parse(element.date!));
          var isExist = distinctList.any((e) {
            if (e.date != null) {
              var dateE = DateFormat('yyyy-MM-dd hh:mm')
                  .format(DateTime.parse(e.date!));
              return date == dateE;
            }
            return false;
          });
          if (!isExist) {
            distinctList.add(element);
          }
        }
      }
    } catch (e) {
      print('Exception at distinct list in temp $e');
    }
    return distinctList;
  }

  reset() {
    _modelList = [];
    _isLoading = true;
    _isPageLoading = false;
  }
}
