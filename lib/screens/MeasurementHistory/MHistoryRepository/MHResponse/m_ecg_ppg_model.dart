import 'package:health_gauge/utils/json_serializable_utils.dart';

class MECGPPGModel {
  int id;
  int userID;
  String fileName;
  String dataStoreServer;
  List<num> filteredEcgPoints;
  List<num> filteredPpgPoints;
  List<num> ecgElapsedTime;
  List<num> ppgElapsedTime;
  List<num> rawHRV;
  List<num> hrvElapsedTime;
  num minHRVTime;
  num maxHRVTime;
  List<num> graphHRVx;
  List<num> graphHRVy;

  MECGPPGModel({
    required this.id,
    required this.userID,
    required this.fileName,
    required this.dataStoreServer,
    required this.filteredEcgPoints,
    required this.filteredPpgPoints,
    required this.ecgElapsedTime,
    required this.ppgElapsedTime,
    required this.rawHRV,
    required this.hrvElapsedTime,
    required this.minHRVTime,
    required this.maxHRVTime,
    required this.graphHRVx,
    required this.graphHRVy,
  });

  factory MECGPPGModel.fromJson(Map<String, dynamic> json) {
    return MECGPPGModel(
      id: JsonSerializableUtils.instance.checkInt(json['ID']),
      userID: JsonSerializableUtils.instance.checkInt(json['UserID']),
      fileName: JsonSerializableUtils.instance.checkString(json['FileName']),
      dataStoreServer: JsonSerializableUtils.instance.checkString(json['DataStoreServer']),
      filteredEcgPoints: (json['filteredEcgPoints'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
      filteredPpgPoints: (json['filteredPpgPoints'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
      ecgElapsedTime: (json['ecg_elapsed_time'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
      ppgElapsedTime: (json['ppg_elapsed_time'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
      rawHRV:
          (json['raw_hrv'] ?? []).map((i) => JsonSerializableUtils.instance.checkNum(i)).toList(),
      hrvElapsedTime: (json['hrv_elapsed_time'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
      minHRVTime: JsonSerializableUtils.instance.checkNum(json['min_hrv_time']),
      maxHRVTime: JsonSerializableUtils.instance.checkNum(json['max_hrv_time']),
      graphHRVx: (json['graph_hrv_x'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
      graphHRVy: List.of(json['graph_hrv_y'] ?? [])
          .map((i) => JsonSerializableUtils.instance.checkNum(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'UserID': userID,
      'FileName': fileName,
      'DataStoreServer': dataStoreServer,
      'filteredEcgPoints': filteredEcgPoints.map((e) => e.toString()).toList(),
      'filteredPpgPoints': filteredPpgPoints.map((e) => e.toString()).toList(),
      'ecg_elapsed_time': ecgElapsedTime.map((e) => e.toString()).toList(),
      'ppg_elapsed_time': ppgElapsedTime.map((e) => e.toString()).toList(),
      'raw_hrv': rawHRV.map((e) => e.toString()).toList(),
      'hrv_elapsed_time': hrvElapsedTime.map((e) => e.toString()).toList(),
      'min_hrv_time': minHRVTime,
      'max_hrv_time': maxHRVTime,
      'graph_hrv_x': graphHRVx.map((e) => e.toString()).toList(),
      'graph_hrv_y': graphHRVy.map((e) => e.toString()).toList(),
    };
  }
}
