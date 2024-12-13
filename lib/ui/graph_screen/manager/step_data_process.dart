
import 'package:health_gauge/ui/graph_screen/manager/process_graph_item_data.dart';

import '../item_value.dart';

class StepDataProcess extends ProcessGraphItemData {
  final DateTime startDate;
  final DateTime endDate;
  final userId;

  StepDataProcess({required this.startDate, required this.endDate, required this.userId, required fieldName, required tableName, required bool isEnableNormalize}) : super(startDate:startDate, endDate:endDate,userId:userId,fieldName:fieldName,tableName: tableName,isEnableNormalize:isEnableNormalize);

  @override
  Future <List<ItemValue>> getItemDataHistory() async {
    List<ItemValue> valueList = [];
    try {

      if (endDate.difference(startDate).inDays <= 1) {
        List? stepDataList;
        List list = await dbHelper.getItemDataHistory(
            userId.toString(), startDate.toString(), endDate.toString(), 'data', tableName ?? "");
        if (list.isNotEmpty) {
          if (list.last['data'] != null && list.last['data'] is List) {
            stepDataList = list.last['data'];
          }

          if (list.last['data'] != null && list.last['data'] is String) {
            stepDataList = list.last['data'].split(",").map((e)=>int.parse(e)).toList();
          }
        }
        if (stepDataList != null) {
          DateTime dateTime = DateTime.parse(list.last['date']);
          for (int i = 0; i < stepDataList.length; i++) {
            ItemValue value = ItemValue(
                fieldName : double.parse(stepDataList[i].toString()),
                date : DateTime(dateTime.year, dateTime.month, dateTime.day, i, 0)
                .toString(),
                edate: DateTime(dateTime.year, dateTime.month, dateTime.day, i, 0)
                    .toString()
            );
            valueList.add(value);
          }
        }
        print(valueList);
      }
      else {
        List list = await dbHelper.getItemDataHistory(
            userId.toString(), startDate.toString(), endDate.toString(), fieldName, tableName ?? "");
        valueList =
            list.map((e) => ItemValue.fromMap(e, fieldName, 'date','edate')).toList();
      }
    return valueList;
    } catch (e) {
      print(e);
      return valueList;
    }
  }

}