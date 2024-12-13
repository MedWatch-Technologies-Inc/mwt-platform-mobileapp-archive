import 'package:health_gauge/ui/graph_screen/manager/process_graph_item_data.dart';

import '../item_value.dart';

class WeightDataProcess extends ProcessGraphItemData {
  final DateTime startDate;
  final DateTime endDate;
  final userId;

  WeightDataProcess({required this.startDate, required this.endDate, required this.userId, required fieldName, required tableName, required bool isEnableNormalize}) : super(startDate:startDate, endDate:endDate,userId:userId,fieldName:fieldName,tableName: tableName,isEnableNormalize:isEnableNormalize);

  @override
  Future <List<ItemValue>> getItemDataHistory() async {
    List<ItemValue> valueList = [];
    List list = await  dbHelper.getWeightDataHistory(userId.toString(),startDate.toString(),endDate.toString(),fieldName, tableName ?? "");
    valueList = list.map((e) => ItemValue.fromMap(e,fieldName,'Date','eDate')).toList();
    return valueList;
  }
}