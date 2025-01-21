import 'process_graph_item_data.dart';

/// Added by: Akhil
/// Added on: July/15/2020
/// this class is used to process data for measurement
class SubDataProcess extends ProcessGraphItemData {
  final DateTime startDate;
  final DateTime endDate;
  final String userId;


  SubDataProcess({required this.startDate, required this.endDate, required this.userId,required fieldName,required tableName, required bool isEnableNormalize}) : super(startDate:startDate, endDate:endDate,userId:userId,fieldName:fieldName,tableName: tableName,isEnableNormalize:isEnableNormalize) ;

}