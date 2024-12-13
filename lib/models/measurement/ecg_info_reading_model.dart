class EcgInfoReadingModel {
  int? approxHr;
  int? approxSBP;
  int? approxDBP;
  int? hrv;
  double? ecgPointY;
  List? pointList;
  num? startTime;
  num? endTime;
  bool? isLeadOff;
  bool? isPoorConductivity;
  bool? isFromCamera;
  int? BG;
  int? Uncertainty;



  EcgInfoReadingModel(
      {this.approxHr,
      this.approxSBP,
      this.approxDBP,
      this.hrv,
      this.BG,
      this.Uncertainty,
      this.ecgPointY,
      this.startTime,
      this.endTime,
      this.isLeadOff,
      this.isPoorConductivity,}
      );

  EcgInfoReadingModel.fromMap(Map map) {
    if (check("startTime", map)) {
      startTime = map["startTime"];
    }
    if (check("endTime", map)) {
      endTime = map["endTime"];
    }
    if (check("isFromCamera", map)) {
      isFromCamera = map["isFromCamera"]??false;
    }
    if (check("approxHr", map)) {
      approxHr = map["approxHr"];
    }
    if (check("approxSBP", map)) {
      approxSBP = map["approxSBP"];
    }
    if (check("approxDBP", map)) {
      approxDBP = map["approxDBP"];
    }
    if (check("ecgPointY", map)) {
      ecgPointY = double.parse("${map["ecgPointY"] + 0.0}");
    }
    if (check("hrv", map)) {
      hrv = map["hrv"];
    }
    if (check("BG", map)) {
      hrv = map["BG"];
    }
    if (check("Uncertainty", map)) {
      hrv = map["Uncertainty"];
    }
    if (check("isLeadOff", map)) {
      isLeadOff = map["isLeadOff"];
    }
    if (check("isPoorConductivity", map)) {
      isPoorConductivity = map["isPoorConductivity"];
    }
    if (check("pointList", map)) {
      pointList = map["pointList"];
    }
    if (map["startTimeWithMilliseconds"] is String) {
      startTime = DateTime.parse(map["startTimeWithMilliseconds"]).toUtc().millisecondsSinceEpoch;
    }
  }


  Map<String, dynamic> toJson() {
    return {
      "approxHr": this.approxHr,
      "approxSBP": this.approxSBP,
      "approxDBP": this.approxDBP,
      "hrv": this.hrv,
      "ecgPointY": this.ecgPointY,
      "pointList": this.pointList,
      "startTime": this.startTime,
      "endTime": this.endTime,
      "isLeadOff": this.isLeadOff,
      "isPoorConductivity": this.isPoorConductivity,
      "isFromCamera": this.isFromCamera,
      "BG": this.BG,
      "Uncertainty": this.Uncertainty,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "approxHr": approxHr??0,
      "approxSBP": approxSBP??0,
      "approxDBP": approxDBP??0,
      "hrv": hrv??0,
      "BG": BG??0,
      "Uncertainty": Uncertainty??0,
      "ecgValue": ecgPointY??0,
    };
  }

  check(String key, Map map) {
    if(map != null && map.containsKey(key) && map[key] != null){
      if(map[key] is String &&  map[key] == "null"){
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'EcgInfoModel{approxHr: $approxHr, approxSBP: $approxSBP, approxDBP: $approxDBP, point: $ecgPointY hrv: $hrv, BG: $BG, Uncertainty: $Uncertainty}';
  }
}
