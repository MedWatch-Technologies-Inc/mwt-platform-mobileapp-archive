import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:intl/intl.dart';
import '../graph_item_data.dart';
import '../item_value.dart';
import 'graph_item_enum.dart';

abstract class ProcessGraphItemData {
  final dbHelper = DatabaseHelper.instance;
  String? itemType = "";
  String userId;
  DateTime startDate;
  DateTime endDate;
  String fieldName;
  String? tableName;
  bool isEnableNormalize = false;
  ProcessGraphItemData(
      {this.itemType,
      required this.userId,
      required this.startDate,
      required this.endDate,
      required this.fieldName,
      this.tableName,
      required this.isEnableNormalize});

  Future<List<GraphItemData>> getData() async {
    return fetchData(startDate: startDate, endDate: endDate);
  }

  Future<List<GraphItemData>> fetchData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<GraphItemData> data = [];
    if (endDate.difference(startDate).inDays <= 1) {
      data = await loadData();
    } else if (endDate.difference(startDate).inDays > 1)
      data = await loadWeekAndMonthData();
    return data;
  }

  Future<List<ItemValue>> getItemDataHistory() async {
    var valueList = <ItemValue>[];
    var list = await dbHelper.getItemDataHistory(userId.toString(),
        startDate.toString(), endDate.toString(), fieldName, tableName ?? '');
    var tempList = list.map((e) => Map.of(e)).toList();
    if(tableName == DBTableHelper().hr.table){
      for (var element in tempList) {
        element['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['date'])));
      }
    }
    print('valueList :: $list');
    try {
      valueList = tempList
          .map((e) => ItemValue.fromMap(e, fieldName, 'date', 'edate'))
          .toList();
    } catch (e) {
      print('MyException :: $e');
    }
    return valueList;
  }
  // Future<List<ItemValue>> getItemDataHistory() async {
  //   List<ItemValue> valueList = [];
  //
  //   List list = await dbHelper.getItemDataHistory(userId.toString(),
  //       startDate.toString(), endDate.toString(), fieldName, tableName ?? "");
  //
  //
  //
  //   valueList =
  //       list.map((e) => ItemValue.fromMap(e, fieldName, 'date')).toList();
  //   return valueList;
  // }

  Future<List<GraphItemData>> loadData() async {
    try {
      int hours = endDate.difference(startDate).inHours;
      List<GraphItemData> data = [];
      List<ItemValue> reducedList = [];
      List<ItemValue> valueList = await getItemDataHistory();

      try {
        valueList.removeWhere(
            (element) => element.fieldName == null || element.date == null);
      } catch (e) {
        print(e);
      }
      // for (int i = 0; i < hours; i++) {
      //   DateTime day = startDate.add(Duration(hours: i));
      //   List<ItemValue> temp =
      //   valueList.where((element) =>
      //   DateTime
      //       .parse(element.date)
      //       .hour == day.hour).toList();
      //   if (temp != null && temp.length > 0) {
      //     double averageValue = getAverage(
      //         List.generate(temp.length, (index) => temp[index].fieldName));
      //     ItemValue item = ItemValue();
      //     if (averageValue != null) {
      //       item.fieldName = averageValue.toDouble();
      //     }
      //     item.date = temp.first.date;
      //     reducedList.add(item);
      //   }
      // }
      List<double> yValues = List.generate(
          valueList.length, (index) => valueList[index].fieldName!);
      double maxValue = getMax(yValues);
      for (var i in valueList) {
        data.add(
          GraphItemData(
            label: fieldName,
            yValue:
                ((this.isEnableNormalize != null && !this.isEnableNormalize) ||
                        this.fieldName == DefaultGraphItem.sbp.fieldName ||
                        this.fieldName == DefaultGraphItem.sbp.fieldName)
                    ? i.fieldName!
                    : normalise(value: i.fieldName!, max: maxValue),
            xValueStr: DateTime.parse(i.date!).hour.toString(),
            xValue: DateTime.parse(i.date!).hour.toDouble() +
                (DateTime.parse(i.date!).minute / 60),
            date: i.date,
          ),
        );
      }
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GraphItemData>> loadWeekAndMonthData() async {
    try {
      int days = endDate.difference(startDate).inDays;
      List<ItemValue> reducedList = [];
      List<GraphItemData> data = [];
      List<ItemValue> valueList = await getItemDataHistory();
      valueList.removeWhere(
          (element) => element.fieldName == null || element.date == null);
      for (int i = 0; i < days; i++) {
        DateTime day = startDate.add(Duration(days: i));
        List<ItemValue> temp = valueList
            .where((element) => DateTime.parse(element.date!).day == day.day)
            .toList();
        if (temp != null && temp.length > 0) {
          double averageValue = getAverage(
              List.generate(temp.length, (index) => temp[index].fieldName!));
          ItemValue item = ItemValue(
            fieldName: averageValue.toDouble(),
            date: temp.first.date,
            edate: temp.first.edate
          );
          reducedList.add(item);
        }
      }
      List<double> yValues = List.generate(
          valueList.length, (index) => valueList[index].fieldName!);
      double maxValue = getMax(yValues);
      for (var i in reducedList) {
        data.add(
          GraphItemData(
            xValue: days <= 7
                ? (DateTime.parse(i.date!).weekday).toDouble()
                : (DateTime.parse(i.date!).day).toDouble(),
            xValueStr: DateTime.parse(i.date!).day.toString(),
            yValue: (!isEnableNormalize ||
                    fieldName == DefaultGraphItem.sbp.fieldName ||
                    this.fieldName == DefaultGraphItem.sbp.fieldName)
                ? i.fieldName!
                : normalise(value: i.fieldName!, max: maxValue),
            label: fieldName,
            date: i.date,
          ),
        );
      }
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  double getMax(List<double> list) {
    double temp = 0;
    for (var i in list) {
      if (i > temp) temp = i;
    }
    return temp;
  }

  double normalise({
    required double value,
    required double max,
  }) {
    return max == 0 ? 0 : (value.toDouble() / max) * 100;
  }

  double getAverage(List<double> list) {
    double sum = 0;
    int count = 0;
    if (list.isNotEmpty) {
      for (var i in list) {
        sum += i;
        if (i != 0) count++;
      }
      return count != 0 ? sum / count : 0;
    } else {
      return 0;
    }
  }
}
