import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/ui/graph_screen/manager/process_graph_item_data.dart';

import '../item_value.dart';

class TagDataProcess extends ProcessGraphItemData {
  List<Tag>? list;
  List<List<TagNote>> tagNoteList = [];
  final DateTime startDate;
  final DateTime endDate;
  final userId;

  TagDataProcess({required this.startDate, required this.endDate, required this.userId, required fieldName, required bool isEnableNormalize}) : super(startDate:startDate, endDate:endDate,userId:userId,fieldName:fieldName,isEnableNormalize:isEnableNormalize);

  @override
  Future <List<ItemValue>> getItemDataHistory() async {
    List<ItemValue> valueList = [];
    List list = await  dbHelper.getTagNoteListForParticularTag(startDate.toString(),endDate.toString(),userId.toString(),fieldName);
    valueList = list.map((e) => ItemValue.fromMap(e,'Value','Date', 'eDate')).toList();
    return valueList;
  }

}