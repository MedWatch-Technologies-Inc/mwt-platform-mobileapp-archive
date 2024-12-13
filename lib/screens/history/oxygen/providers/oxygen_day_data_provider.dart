import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:health_gauge/models/temp_model.dart';
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

import 'oxygen_history_provider.dart';

class OxygenDayDataProvider extends ChangeNotifier {
  List<TempModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool isAllFetched = false;

  int _avgOxygenRate = 0;
  List<GraphItemData> _oxygenList = [];
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphTypeModel> _selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> _oxygenLineSeries = [];
  DateTime? _dateTime;
  DateTime? _startDate;
  DateTime? _endDate;

  set modelList(List<TempModel> value) {
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

  List<TempModel> get modelList => _modelList;

  int get avgOxygenRate => _avgOxygenRate;

  set avgOxygenRate(int value) {
    _avgOxygenRate = value;
  }

  List<GraphItemData> get oxygenList => _oxygenList;

  set oxygenList(List<GraphItemData> value) {
    _oxygenList = value;
  }

  List<GraphTypeModel> get graphTypeList => _graphTypeList;

  set graphTypeList(List<GraphTypeModel> value) {
    _graphTypeList = value;
  }

  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;

  set selectedGraphTypeList(List<GraphTypeModel> value) {
    _selectedGraphTypeList = value;
  }

  List<chart.Series<GraphItemData, num>> get oxygenLineSeries => _oxygenLineSeries;

  set oxygenLineSeries(List<chart.Series<GraphItemData, num>> value) {
    _oxygenLineSeries = value;
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

  Future<List<TempModel>> getHistoryData(context) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider = Provider.of<OxygenHistoryProvider>(context, listen: false);

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
    var data = await dbHelper.getTempTableData(userId!, strStart, strEnd, ids);
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

  Future<void> initializeData() async {
    if(modelList.isNotEmpty) {
      findAvgOxygenRate();
      graphTypeList = await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
      if (graphTypeList.isNotEmpty) {
        _selectedGraphTypeList = [
          _graphTypeList.firstWhere(
                  (element) =>
              element.fieldName == DefaultGraphItem.oxygen.fieldName)
        ];
        if (_selectedGraphTypeList.isNotEmpty) {
          await getGraphData();
          _oxygenLineSeries =
              LineGraphData(
                  graphItemList: _oxygenList, graphList: _selectedGraphTypeList)
                  .getLineGraphData();
        }
      }
    }
  }

  int findAvgOxygenRate() {
    if (modelList.isNotEmpty) {
      var count = 0;
      _avgOxygenRate = 0;
      for (var element in modelList) {
        if (element.oxygen != null && element.oxygen != 0) {
          _avgOxygenRate += element.oxygen!.toInt();
          count++;
        }
      }
      _avgOxygenRate ~/= count != 0 ? count : 1;
    }
    return _avgOxygenRate;
  }

  Future<void> getGraphData() async {
    _oxygenList = await GraphDataManager().graphManager(
        userId: globalUser?.userId ?? '',
        startDate: _startDate!,
        endDate: _endDate!,
        selectedGraphTypes: _selectedGraphTypeList,
        isEnableNormalize: false,
        unitType: 1);
    _oxygenList.removeWhere((element) => element.yValue == 0);
  }

  List<TempModel> distinctList(var dataList) {
    var distinctList = <TempModel>[];

    try {
      dataList.forEach((TempModel element) {
        if (element.date != null) {
          String date = DateFormat(DateUtil.yyyyMMddhhmm)
              .format(DateTime.parse(element.date!));
          bool isExist = distinctList.any((e) {
            if (e.date != null) {
              String dateE = DateFormat(DateUtil.yyyyMMddhhmm)
                  .format(DateTime.parse(e.date!));
              return date == dateE;
            }
            return false;
          });
          if (!isExist) {
            distinctList.add(element);
          }
        }
      });
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
