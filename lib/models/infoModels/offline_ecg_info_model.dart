class OfflineEcgInfoModel {
  String? ecgDate;
  int? ecgHR;
  int? ecgSBP;
  int? ecgDBP;
  int? healthHrvIndex;
  int? healthFatigueIndex;
  int? healthLoadIndex;
  int? healthBodyIndex;
  int? healthHeartIndex;
  List? ecgData;

  OfflineEcgInfoModel();

  OfflineEcgInfoModel.fromMap(Map map) {
    if (check(map, "ecgDate")) {
      ecgDate = map["ecgDate"];
    }
    if (check(map, "ecgHR")) {
      ecgHR = map["ecgHR"];
    }
    if (check(map, "ecgSBP")) {
      ecgSBP = map["ecgSBP"];
    }
    if (check(map, "ecgDBP")) {
      ecgDBP = map["ecgDBP"];
    }
    if (check(map, "healthHrvIndex")) {
      healthHrvIndex = map["healthHrvIndex"];
    }
    if (check(map, "healthFatigueIndex")) {
      healthFatigueIndex = map["healthFatigueIndex"];
    }
    if (check(map, "healthLoadIndex")) {
      healthLoadIndex = map["healthLoadIndex"];
    }
    if (check(map, "healthBodyIndex")) {
      healthBodyIndex = map["healthBodyIndex"];
    }
    if (check(map, "healtHeartIndex")) {
      healthHeartIndex = map["healtHeartIndex"];
    }
    if (check(map, "ecgData")) {
      ecgData = map["ecgData"];
    }
  }

  @override
  String toString() {
    return 'OfflineEcgInfoModel{ecgDate: $ecgDate, ecgHR: $ecgHR, ecgSBP: $ecgSBP, ecgDBP: $ecgDBP, healthHrvIndex: $healthHrvIndex, healthFatigueIndex: $healthFatigueIndex, healthLoadIndex: $healthLoadIndex, healthBodyIndex: $healthBodyIndex, healtHeartIndex: $healthHeartIndex, ecgData: $ecgData}';
  }

  bool check(Map map, String key) {
    return map[key] != null;
  }
}
