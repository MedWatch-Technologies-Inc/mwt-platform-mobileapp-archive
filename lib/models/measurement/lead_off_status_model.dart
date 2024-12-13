class LeadOffStatusModel {
  int? ecgStatus;
  int? ppgStatus;

  LeadOffStatusModel(
      {this.ecgStatus,
        this.ppgStatus,}
      );

  LeadOffStatusModel.fromMap(Map map) {
    if (check("ecgStatus", map)) {
      ecgStatus = map["ecgStatus"];
    }
    if (check("ppgStatus", map)) {
      ppgStatus = map["ppgStatus"];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "ecgStatus": ecgStatus??0,
      "ppgStatus": ppgStatus??0,
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
    return 'LeadOffStatusModel{ecgStatus: $ecgStatus, ppgStatus: $ppgStatus,}';
  }
}