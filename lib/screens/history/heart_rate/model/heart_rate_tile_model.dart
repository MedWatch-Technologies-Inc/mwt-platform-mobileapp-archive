import 'heart_rate_graph_model.dart';

class HeartRateTileModel {
  DateTime? dateTime;
  int? avgHeartRate;
  String? unit;
  String? subTitle;
  HeartRateGraphModel? graphWidget;

  HeartRateTileModel({
    this.dateTime,
    this.avgHeartRate,
    this.unit,
    this.subTitle,
    this.graphWidget,
  });
}
