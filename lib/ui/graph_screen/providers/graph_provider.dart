import 'dart:convert';
import 'dart:io';

import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_using_camera_screen.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/bar_graph.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/bar_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_and_bar_graph.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_shared_preference_manager_model.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../graph_item_data.dart';

class GraphProvider extends ChangeNotifier {
  /// Added by Shahzad
  /// Added on 31st Aug 2021
  /// declaring private variables
  bool _isEditMode = false;
  List<GraphTypeModel> _selectedGraphTypeList = [];
  WindowModel? _graphWindow;
  GraphSharedPreferenceManagerModel? _graphSharedPreferenceManagerModel;
  String _graphTypeName1 = '';
  String _graphTypeName2 = '';
  Color _color1 = Colors.black;
  Color _color2 = Colors.black;
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphItemData> graphItemList = [];
  List<GraphItemData> graphItemListAvg = [];
  List<GraphItemData> graphItemListTemp = [];
  String? userId;
  bool _isShowLoadingScreen = true;
  bool _isSwap = false;
  late GraphTab _graphTab;

  /// public variables

  late DateTime startDate;
  late DateTime endDate;

  Widget lineChartWidget = Container();
  Widget barChartWidget = Container();
  Widget lineAndBarChartWidget = Container();
  List<chart.Series<GraphItemData, num>> lineChartSeries = [];
  List<chart.Series<GraphItemData, String>> barChartSeries = [];
  List<chart.Series<GraphItemData, num>> lineAndBarChartSeries = [];

  List<RadioModel> graphList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.lineGraph)),
    RadioModel(false, stringLocalization.getText(StringLocalization.barGraph)),
    RadioModel(
        false, stringLocalization.getText(StringLocalization.lineAndBarGraph))
  ];



  /// Added by Shahzad
  /// Added on 31st Aug 2021
  /// get values from private variables.
  bool get isEditMode => _isEditMode;
  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;
  WindowModel? get graphWindow => _graphWindow;
  GraphSharedPreferenceManagerModel? get graphSharedPreferenceManagerModel => _graphSharedPreferenceManagerModel;
  String get graphTypeName1 => _graphTypeName1;
  String get graphTypeName2 => _graphTypeName2;
  Color get color1 => _color1;
  Color get color2 => _color2;
  List<GraphTypeModel> get graphTypeList => _graphTypeList;
  bool get isShowLoadingScreen => _isShowLoadingScreen;
  bool get isSwap => _isSwap;
  GraphTab get graphTab => _graphTab;

  /// Added by Shahzad
  /// Added on 31st Aug 2021
  /// set values to private variables
  set isEditMode(bool value){
    _isEditMode = value;
    _graphWindow?.editMode = _isEditMode;
    updatePrefForSelectedItem();
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set selectedGraphTypeList(List<GraphTypeModel> value) {
    _selectedGraphTypeList = value;
    removeDeletedType();
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set graphWindow(WindowModel? value){
    _graphWindow = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set graphSharedPreferenceManagerModel(GraphSharedPreferenceManagerModel? value){
    _graphSharedPreferenceManagerModel = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set graphTypeName1(String value){
    _graphTypeName1 = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set graphTypeName2(String value){
    _graphTypeName2 = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set color1(Color value){
    _color1 = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set color2(Color value){
    _color2 = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set graphTypeList(List<GraphTypeModel> value) {
    _graphTypeList = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set isShowLoadingScreen(bool value){
    _isShowLoadingScreen = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set isSwap(bool value){
    _isSwap = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set graphTab(GraphTab value){
    _graphTab = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  /// common functions to be used by graphs

  /// Added by Shahzad
  /// Added on 31st Aug 2021
  /// update graph list in preferences
  void updatePrefForSelectedItem() async {
    _graphWindow?.selectedType = _selectedGraphTypeList;
    preferences ??= await SharedPreferences.getInstance();
    var listOfPages = preferences!.getStringList(Constants.prefKeyForGraphPages);
    if (listOfPages != null && listOfPages.isNotEmpty) {
      var listOfPagesFromPreference =
      listOfPages
          .map((e) =>
          GraphSharedPreferenceManagerModel.fromMap(jsonDecode(e)))
          .toList();
      var index = listOfPagesFromPreference.indexWhere((element) =>
      element.index == _graphSharedPreferenceManagerModel?.index);

      var tempGraphSharedPreferenceManagerModel =
      listOfPagesFromPreference[index];
      var i = tempGraphSharedPreferenceManagerModel.windowList
          .indexWhere((element) => element?.index == _graphWindow?.index);
      if(i != -1) {
        tempGraphSharedPreferenceManagerModel.windowList[i] = _graphWindow;
      }

      preferences!.setStringList(Constants.prefKeyForGraphPages,
          listOfPagesFromPreference.map((e) => jsonEncode(e.toMap())).toList());
    }
  }


  /// Added by Shahzad
  /// Added on 31st Aug
  /// set graph title
  void getGraphTitle() {
    if (_graphWindow != null) {
      var name = _graphWindow!.title.split('Vs');
      if (name.isNotEmpty) {
        if (name.length == 1) {
          _graphTypeName1 = name[0];
        } else {
          _graphTypeName1 = name[0];
          _graphTypeName2 = name[1];
        }
      }
    }
    if (_selectedGraphTypeList.isNotEmpty) {
      if (_selectedGraphTypeList.length == 1) {
        _color1 = _selectedGraphTypeList[0].color.isNotEmpty
            ? HexColor.fromHex(selectedGraphTypeList[0].color)
            : Colors.black;
      } else {
        _color1 = _selectedGraphTypeList[0].color.isNotEmpty
            ? HexColor.fromHex(selectedGraphTypeList[0].color)
            : Colors.black;
        _color2 = _selectedGraphTypeList[1].color.isNotEmpty
            ? HexColor.fromHex(selectedGraphTypeList[1].color)
            : Colors.black;
      }
    }
  }

  /// Added by Shahzad
  /// Added on 31st Aug
  /// get data for each graph item
  Future getData({int? selectedUnit, required BuildContext context}) async {
    removeDeletedType();
    if (userId == null) {
      await getPreference();
    }
    if (startDate != null && endDate != null) {
      var unit = selectedUnit ?? 1;
      if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric) {
        unit = 1;
      }
      if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
        unit = 2;
      }

      graphItemList = await GraphDataManager().graphManager(
          userId: userId!,
          startDate: startDate,
          endDate: endDate,
          selectedGraphTypes: selectedGraphTypeList,
          isEnableNormalize: false,
          unitType: unit);
      var distinct = <GraphItemData>[];
      print("graphItemList  1" + graphItemList.length.toString());
      print(graphItemList.map((e) => e.label.toString()));
      if(graphItemList.isNotEmpty) {
        for (var d in graphItemList) {
          var value = graphItemList
              .where((element) {
            return (element.label == d.label &&
                element.xValueStr == d.xValueStr &&
                element.yValue == d.yValue &&
                element.xValue == d.xValue);
          })
              .toList()
              .last;
          if (!distinct.contains(value)) {
            distinct.add(value);
          }
        }
      }
      for(var i = 0; i<distinct.length; i++){
        if(distinct[i].yValue == 0){
          distinct.removeAt(i);
          i--;
        }
      }
      distinct.sort((a, b) => a.date!.compareTo(b.date!));
      distinct.sort((a, b) => a.label.compareTo(b.label));

      if(_graphWindow?.selectedChartType == ChartType.bar && _graphTab == GraphTab.day) {
        var dayAvgList = <GraphItemData>[];
        var yVal = 0.0;
        var count = 0;
        print("here is the length of the distinct -- "+distinct.length.toString());

        if(distinct.length > 1) {
          for (var i = 0; i < distinct.length - 1; i++) {

            var date1 = Date().convertDateFromStringForGraph(
                distinct[i].date!);
            var date2 = Date().convertDateFromStringForGraph(
                distinct[i + 1].date!);
            if (i == distinct.length - 2) {
              if (date1.hour == date2.hour &&
                  distinct[i].label == distinct[i + 1].label) {
                yVal = yVal + distinct[i].yValue + distinct[i + 1].yValue;
                yVal = yVal / (count + 2);
                dayAvgList.add(GraphItemData(
                  type: distinct[i].type,
                  date: distinct[i].date,
                  yValue: yVal,
                  xValue: distinct[i].xValue,
                  colorCode: distinct[i].colorCode,
                  label: distinct[i].label,
                  xValueStr: distinct[i].xValueStr,
                ));
              } else {
                yVal = yVal + distinct[i].yValue;
                count++;
                yVal = yVal / count;
                dayAvgList.add(GraphItemData(
                  type: distinct[i].type,
                  date: distinct[i].date,
                  yValue: yVal,
                  xValue: distinct[i].xValue,
                  colorCode: distinct[i].colorCode,
                  label: distinct[i].label,
                  xValueStr: distinct[i].xValueStr,
                ));
                dayAvgList.add(GraphItemData(
                  type: distinct[i + 1].type,
                  date: distinct[i + 1].date,
                  yValue: distinct[i + 1].yValue,
                  xValue: distinct[i + 1].xValue,
                  colorCode: distinct[i + 1].colorCode,
                  label: distinct[i + 1].label,
                  xValueStr: distinct[i + 1].xValueStr,
                ));
              }
            }
            else if (date1.hour == date2.hour &&
                distinct[i].label == distinct[i + 1].label) {
              yVal = yVal + distinct[i].yValue;
              count++;
            }
            else {
              yVal = yVal + distinct[i].yValue;
              count++;
              yVal = yVal / count;
              dayAvgList.add(GraphItemData(
                type: distinct[i].type,
                date: distinct[i].date,
                yValue: yVal,
                xValue: distinct[i].xValue,
                colorCode: distinct[i].colorCode,
                label: distinct[i].label,
                xValueStr: distinct[i].xValueStr,
              ));
              yVal = 0;
              count = 0;
            }
          }
          distinct = dayAvgList;
        }
      }



      if(_graphWindow?.selectedChartType == ChartType.pie && _graphTab == GraphTab.day) {
        var labelHr = <GraphItemData>[];
        var labelStep = <GraphItemData>[];

        print("in this");
        var yVal = 0.0;
        var count = 0;
        var dayAvgList = <GraphItemData>[];
        var distinct1 = distinct;
        if(distinct1.length > 1) {


          labelHr.add(distinct1[0]);

          for(var i=1;i<distinct1.length;i++){
            if(distinct1[i].label==labelHr[0].label){
              labelHr.add(distinct1[i]);
            }
            else{
              labelStep.add(distinct1[i]);
            }
          }

          labelHr.sort((a, b) => a.date!.compareTo(b.date!));
          labelStep.sort((a, b) => a.date!.compareTo(b.date!));

          distinct1 = labelHr;

          // for(var i=0;i<labelStep.length;i++){
          //   distinct1.add(labelStep[i]);
          // }
          distinct1.addAll(labelStep);
          print(distinct1.toString());

          for (var i = 0; i < distinct1.length - 1; i++) {

            var date1 = Date().convertDateFromStringForGraph(
                distinct1[i].date!);
            var date2 = Date().convertDateFromStringForGraph(
                distinct1[i + 1].date!);
            if (i == distinct1.length - 2) {
              if (date1.hour == date2.hour &&
                  distinct1[i].label == distinct1[i + 1].label) {
                yVal = yVal + distinct1[i].yValue + distinct1[i + 1].yValue;
                yVal = yVal / (count + 2);
                dayAvgList.add(GraphItemData(
                  type: distinct1[i].type,
                  date: distinct1[i].date,
                  yValue: yVal,
                  xValue: double.parse((distinct1[i].xValueStr)),
                  colorCode: distinct1[i].colorCode,
                  label: distinct1[i].label,
                  xValueStr: (distinct1[i].xValueStr),
                ));
              } else {
                yVal = yVal + distinct1[i].yValue;
                count++;
                yVal = yVal / count;
                dayAvgList.add(GraphItemData(
                  type: distinct1[i].type,
                  date: distinct1[i].date,
                  yValue: yVal,
                  xValue: double.parse((distinct1[i].xValueStr)),
                  colorCode: distinct1[i].colorCode,
                  label: distinct1[i].label,
                  xValueStr: distinct1[i].xValueStr,
                ));
                dayAvgList.add(GraphItemData(
                  type: distinct1[i + 1].type,
                  date: distinct1[i + 1].date,
                  yValue: distinct1[i + 1].yValue,
                  xValue: double.parse((distinct1[i+1].xValueStr)),
                  colorCode: distinct1[i + 1].colorCode,
                  label: distinct1[i + 1].label,
                  xValueStr: distinct1[i + 1].xValueStr,
                ));
              }
            }
            else if (date1.hour == date2.hour &&
                distinct1[i].label == distinct1[i + 1].label) {
              yVal = yVal + distinct1[i].yValue;
              count++;
            }
            else {
              yVal = yVal + distinct1[i].yValue;
              count++;
              yVal = yVal / count;
              dayAvgList.add(GraphItemData(
                type: distinct1[i].type,
                date: distinct1[i].date,
                yValue: yVal,
                xValue: double.parse((distinct1[i].xValueStr)),
                colorCode: distinct1[i].colorCode,
                label: distinct1[i].label,
                xValueStr: distinct1[i].xValueStr,
              ));
              yVal = 0;
              count = 0;
            }
          }

        //  distinct = dayAvgList;
        }
        if(dayAvgList.isNotEmpty) {
          graphItemListAvg = dayAvgList;
        }
      }

      if(distinct.isNotEmpty) {
        graphItemList = distinct;
        graphItemListTemp = distinct;
      }
      makeOrRefreshChartWidget(context);
    }
    _isShowLoadingScreen = false;
    _isSwap = false;
  }


  Future getPreference() async {
    preferences ??= await SharedPreferences.getInstance();
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    removeDeletedType();
    return Future.value();
  }

  void removeDeletedType() {
    try {
      var list = [];
      if (_graphTypeList.isNotEmpty) {
        for (var element in _selectedGraphTypeList) {
          if (!_graphTypeList.any((e) => e.fieldName == element.fieldName)) {
            list.add(element);
          }
        }
        for (var element in list) {
          _selectedGraphTypeList.remove(element);
        }
      }
    } catch (e) {
      print('exception in graph window screen $e');
    }
  }

  void setDates(DateTime selectedDate) {
    if (graphTab == GraphTab.week) {
      var dayNr = (selectedDate.weekday + 7) % 7 - 1;
      startDate = selectedDate.subtract(Duration(days: (dayNr)));
      startDate =
          DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
      endDate = startDate.add(Duration(days: 6));
      endDate = DateTime(endDate.year, endDate.month, endDate.day + 1);
    } else if (graphTab == GraphTab.month) {
      startDate = DateTime(selectedDate.year, selectedDate.month, 1);
      endDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    } else {
      startDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      endDate = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day + 1);
    }
  }

  void makeOrRefreshChartWidget(BuildContext context) {
    makeDefaultValueForXAxisToBarChart();
    if (!isSwap) {
      if (_graphWindow?.selectedChartType == ChartType.pie &&
          _graphTab == GraphTab.day) {
        List<GraphItemData> newList = [];
        for (var j = 0; j < graphItemListTemp.length; j++) {
          if (selectedGraphTypeList[0].fieldName ==
              graphItemListTemp[j].label) {
            if(_graphWindow!.interpolation && graphItemListTemp[j].yValue==0){

            }
            else {
              newList.add(graphItemListTemp[j]);
            }
          }
        }
        for (var j = 0; j < graphItemListAvg.length; j++) {
          if (selectedGraphTypeList[1].fieldName == graphItemListAvg[j].label) {

              newList.add(graphItemListAvg[j]);
          }
        }
        if(newList.isNotEmpty) {
          graphItemList = newList;
        }
      }
      if (_graphWindow?.selectedChartType == ChartType.pie &&
          _graphTab == GraphTab.week || _graphWindow?.selectedChartType == ChartType.pie &&
          _graphTab == GraphTab.month) {
        graphItemList.removeWhere((element) => selectedGraphTypeList[0].fieldName ==
            element.label && element.yValue==0);
      }
    }
    else{
      if(_graphWindow?.selectedChartType == ChartType.pie && _graphTab == GraphTab.day){
        List<GraphItemData> newList = [];
        for(var j=0;j<graphItemListTemp.length;j++) {
          if (selectedGraphTypeList[1].fieldName ==
              graphItemListTemp[j].label) {
            if(_graphWindow!.interpolation && graphItemListTemp[j].yValue==0){

            }
            else {
              newList.add(graphItemListTemp[j]);
            }
          }
        }
        for(var j=0;j<graphItemListAvg.length;j++) {
          if(selectedGraphTypeList[0].fieldName==graphItemListAvg[j].label){
              newList.add(graphItemListAvg[j]);
          }
        }
        if(newList.isNotEmpty) {
          graphItemList = newList;
        }
      }
      if (_graphWindow?.selectedChartType == ChartType.pie &&
          _graphTab == GraphTab.week || _graphWindow?.selectedChartType == ChartType.pie &&
          _graphTab == GraphTab.month) {
        graphItemList.removeWhere((element) => selectedGraphTypeList[1].fieldName ==
            element.label && element.yValue==0);
      }
    }

    graphItemList.sort(
            (GraphItemData a, GraphItemData b) => (a.xValue == b.xValue && a.date != null && b.date != null) ? a.date!.compareTo(b.date!) : a.xValue.compareTo(b.xValue));

    if (isSwap) {

      var temp = selectedGraphTypeList[0];
      selectedGraphTypeList[0] = selectedGraphTypeList[1];
      selectedGraphTypeList[1] = temp;
      var title1 = setGraphTitle(selectedGraphTypeList, 0);
      var title2 = setGraphTitle(selectedGraphTypeList, 1);
      graphTypeName1 = title1;
      graphTypeName2 = title2;
      graphWindow?.title = '$graphTypeName1 Vs $graphTypeName2';

    }


    //region line chart
    lineChartSeries = LineGraphData(graphList: _selectedGraphTypeList, graphItemList: graphItemList).getLineGraphData();
    lineChartWidget = LineGraph(
        graphList: _selectedGraphTypeList,
        lineChartSeries: lineChartSeries,
        context: context,
        startDate: startDate,
        endDate: endDate,
        graphTab: graphTab,
        isNormalization: graphWindow?.normalization ?? false).getLineGraph();
    //endregion


    //region bar chart
    barChartSeries = BarGraphData(graphList: selectedGraphTypeList, graphItemList: graphItemList).getBarGraphData();
    barChartWidget = BarGraph(
        graphList: _selectedGraphTypeList,
        barChartSeries: barChartSeries,
        context: context, startDate: startDate,
        endDate: endDate,
        graphTab: graphTab,
        graphItemList: graphItemList,
        isNormalization:  graphWindow?.normalization ?? false).getBarGraph();
    //endregion

    // region line and bar chart
    lineAndBarChartSeries = LineGraphData(graphList: _selectedGraphTypeList, graphItemList: graphItemList).getLineGraphData();
    lineAndBarChartWidget = LineAndBarGraph(
        graphList: _selectedGraphTypeList,
        lineAndBarChartSeries: lineAndBarChartSeries,
        context: context,
        startDate: startDate,
        endDate: endDate,
        graphTab: graphTab,
        isNormalization: graphWindow?.normalization ?? false).getLineAndBarGraph();
    //endregion

    notifyListeners();

  }

  void makeDefaultValueForXAxisToBarChart() {
    var loopLength = 0;
    if (graphTab == GraphTab.day) {
      if(graphWindow != null && graphWindow!.selectedChartType == ChartType.line){
        loopLength = 25;
      } else {
        loopLength = 24;
      }
    } else if (graphTab == GraphTab.week) {
      loopLength = 7;
    } else if (graphTab == GraphTab.month) {
      loopLength = DateTime(startDate.day, startDate.month + 1, 0).day;
    }
    if(!_graphWindow!.interpolation || _graphWindow?.selectedChartType == ChartType.bar || _graphWindow?.selectedChartType == ChartType.pie) {
      var unAvailableXValues = <GraphItemData>[];
      var unAvailableXValuesTemp = <GraphItemData>[];
      var unAvailableXValuesAvg = <GraphItemData>[];

      if (graphTab == GraphTab.day) {
        selectedGraphTypeList.forEach((element) {
          for (var i = 0; i <= loopLength; i++) {
            var valueIsAlreadyExistForThisAxis = graphItemList
                .any((e) =>
            e.label == element.fieldName && e.xValue.toInt() == i);
            if (!valueIsAlreadyExistForThisAxis) {
              var emptyGraphItem = GraphItemData(
                  label: element.fieldName,
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toInt().toString());
              unAvailableXValues.add(emptyGraphItem);
            }
            var valueIsAlreadyExistForThisAxisTemp = graphItemListTemp
                .any((e) =>
            e.label == element.fieldName && e.xValue.toInt() == i);
            if (!valueIsAlreadyExistForThisAxisTemp) {
              var emptyGraphItem = GraphItemData(
                  label: element.fieldName,
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toInt().toString());
              unAvailableXValuesTemp.add(emptyGraphItem);
            }
            var valueIsAlreadyExistForThisAxisAvg = graphItemListAvg
                .any((e) =>
            e.label == element.fieldName && e.xValue.toInt() == i);
            if (!valueIsAlreadyExistForThisAxisAvg) {
              var emptyGraphItem = GraphItemData(
                  label: element.fieldName,
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toInt().toString());
              unAvailableXValuesAvg.add(emptyGraphItem);
            }
          }
        });
      }
      else {
        selectedGraphTypeList.forEach((element) {
          for (var i = 1; i <= loopLength; i++) {
            var valueIsAlreadyExistForThisAxis = graphItemList
                .any((e) =>
            e.label == element.fieldName && e.xValue.toInt() == i);
            if (!valueIsAlreadyExistForThisAxis) {
              var emptyGraphItem = GraphItemData(
                  label: element.fieldName,
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toInt().toString());
              unAvailableXValues.add(emptyGraphItem);
            }
            var valueIsAlreadyExistForThisAxisTemp = graphItemListTemp
                .any((e) =>
            e.label == element.fieldName && e.xValue.toInt() == i);
            if (!valueIsAlreadyExistForThisAxisTemp) {
              var emptyGraphItem = GraphItemData(
                  label: element.fieldName,
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toInt().toString());
              unAvailableXValuesTemp.add(emptyGraphItem);
            }
            var valueIsAlreadyExistForThisAxisAvg = graphItemListAvg
                .any((e) =>
            e.label == element.fieldName && e.xValue.toInt() == i);
            if (!valueIsAlreadyExistForThisAxisAvg) {
              var emptyGraphItem = GraphItemData(
                  label: element.fieldName,
                  yValue: 0,
                  xValue: i.toDouble(),
                  xValueStr: i.toInt().toString());
              unAvailableXValuesAvg.add(emptyGraphItem);
            }
          }
        });
      }
      graphItemList.addAll(unAvailableXValues);
      graphItemListTemp.addAll(unAvailableXValuesTemp);
      graphItemListAvg.addAll(unAvailableXValuesAvg);
    }
  }


  String setGraphTitle(List<GraphTypeModel> selectedGraphList, int index) {
    switch (selectedGraphTypeList[index].fieldName) {
      case 'approxSBP':
        return 'Systolic BP';
      case 'approxDBP':
        return 'Diastolic BP';
      case 'HeartRate':
        return Platform.isIOS ? 'HealthKit HR' : 'GoogleFit HR';
      case 'DiastolicBloodPressure':
        return Platform.isIOS ? 'HealthKit DBP' : 'GoogleFit DBP';
      case 'SystolicBloodPressure':
        return Platform.isIOS ? 'HealthKit SBP' : 'GoogleFit SBP';
      default:
        return selectedGraphTypeList[index].name;
    }
  }

  int daysInMonth(DateTime date) {
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 0);
    return firstDayNextMonth.day;
  }


}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}