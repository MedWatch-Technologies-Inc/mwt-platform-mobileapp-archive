import 'package:flutter/cupertino.dart';

import 'graph_item_enum.dart';
import 'graph_type_model.dart';

class GraphSharedPreferenceManagerModel {
  late int index;
  late String title;
  late String iconPath;
  late bool isDefault;
  List<WindowModel?> windowList = [];

  GraphSharedPreferenceManagerModel({required this.index, required this.title, required this.windowList, required this.isDefault, required this.iconPath});

  GraphSharedPreferenceManagerModel.fromMap(Map map) {
    if(check('index', map)) {
      index = map['index'];
    }
    if(check('title', map)) {
      title = map['title'];
    }
    if(check('windowList', map)) {
      List list = map['windowList'] ?? [];
      windowList = list.map((e) => e != null ? WindowModel.fromMap(e) : null).toList();
      windowList.removeWhere((element) => element == null);
    }
    if(check('isDefault', map)) {
      isDefault = map['isDefault'];
    }
    if(check('iconPath', map)) {
      iconPath = map['iconPath'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'title': title,
      'windowList': windowList.map((e) => e?.toMap()).toList(),
      'isDefault': isDefault,
      'iconPath' : iconPath,
    };
  }

  bool check(String key, Map map) {
    if(map.containsKey(key) && map[key] != null){
      if(map[key] is String &&  map[key] == 'null'){
        return false;
      }
      return true;
    }
    return false;
  }
}

class WindowModel {
  late int index;
  late String title;
  bool normalization = true;
  bool interpolation = true;
  bool editMode = false;
  bool defaultGraph = false;
  ChartType selectedChartType = ChartType.bar;
  List<GraphTypeModel> selectedType = [];
  DateTime selectedDate = DateTime.now();
  ValueNotifier<DateTime?> onChangeDate = ValueNotifier<DateTime?>(null);

  WindowModel({required this.index, required this.title, required this.selectedType, required this.selectedChartType, required this.normalization, required this.editMode, required this.defaultGraph, required this.interpolation});

  WindowModel.fromMap(Map map) {
    if(check('index', map)) {
      index = map['index'];
    }
    if(check('title', map)) {
      title = map['title'];
    }
    if(check('selectedValue', map)) {
      selectedChartType = chartTypeFromValue(map['selectedValue']);
    }
    if(check('selectedType', map)) {
      List list = map['selectedType'];
      selectedType = list.map((e) => GraphTypeModel.fromMap(e)).toList();
    }
    if(check(('normalization'), map)) {
      normalization = map['normalization'];
    }
    if(check(('interpolation'), map)) {
      interpolation = map['interpolation'];
    }
    if(check(('editMode'), map)) {
      editMode = map['editMode'];
    }
    if(check(('defaultGraph'), map)) {
      defaultGraph = map['defaultGraph'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'title': title,
      'selectedValue': selectedChartType.value,
      'selectedType': selectedType.map((e) => e.toMap()).toList(),
      'normalization': normalization,
      'editMode': editMode,
      'defaultGraph': defaultGraph,
      'interpolation': interpolation
    };
  }

  check(String key, Map map) {
    if(map.isNotEmpty && map.containsKey(key) && map[key] != null){
      if(map[key] is String &&  map[key] == 'null'){
        return false;
      }
      return true;
    }
    return false;
  }

}
