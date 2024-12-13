class ItemValue {
  double? fieldName;
  String? date;
  String? edate;

  ItemValue({required this.fieldName, required this.date,required this.edate});

  ItemValue.fromMap(Map map , String fieldName , String date,String edate, {bool isSleep = false}) {
    if(isSleep && check(fieldName, map)){
      this.fieldName = 0.0;
      var hr = int.parse(map['endTime'].difference(map['startTime']).toString().split(':')[0]);
      var min = int.parse(map['endTime'].difference(map['startTime']).toString().split(':')[0]);
      this.fieldName = hr + min/60;
    }else if (check(fieldName, map)) {
      this.fieldName = double.parse(map[fieldName].toString());
    }
    if (check(date, map)) {
      this.date = map[date].toString();
    }
    if (check(edate, map)) {
      this.edate = map[edate].toString().isEmpty ? map[date].toString()  : map[edate].toString();
    }

  }


  check(String key, Map map) {
    if(map.isNotEmpty && map.containsKey(key)
        && map[key] != null){
      if(map[key] is String &&  map[key] == 'null'){
        return false;
      }
      return true;
    }
    return false;
  }
}