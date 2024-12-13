import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';

import 'history_graph_model.dart';

class HistoryTileModel {
  HistoryItemType historyItemType;
  DateTime? dateTime;
  int? avgRate;
  int? avgSBP;

  String? subTitle;
  HistoryGraphModel? graphWidget;

  HistoryTileModel({
    required this.historyItemType,
    this.dateTime,
    this.avgRate,
    this.avgSBP=0,
    this.subTitle,
    this.graphWidget,
  });

  String avgValue() {
    if (avgRate == 0) {
      return 'N/A';
    } else {
      if (historyItemType == HistoryItemType.Temperature) {
        try {
          if (tempUnit == 1) {
            var temp = (avgRate! * 9 / 5) + 32;
            return temp.toStringAsFixed(2);
          } else {
            return avgRate.toString();
          }
        } catch (e) {
          print('Exception at temperatureNotifier $e');
        }
        return '';
      }
      if (historyItemType == HistoryItemType.BloodPressure) {
        return '${avgSBP}/${avgRate}';

      }
      return avgRate.toString();
    }
  }
}
