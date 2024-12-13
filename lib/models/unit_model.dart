class UnitModel{
  String? id;
  String? userId;
  String? unitName;
  String? value;
  String? valueName;
  String? createdDateTime;

  UnitModel({this.id, this.userId, this.unitName, this.value, this.valueName});
  UnitModel.fromMap(Map map){
    if(check('ID',map)){
      id = '${map['ID']}';
    }
    if(check('UserID',map)){
      userId = '${map['UserID']}';
    }
    if(check('Measurement',map)){
      unitName = '${map['Measurement']}';
    }
    if(check('Value',map)){
      value = '${map['Value']}';
    }
    if(check('Unit',map)){
      valueName = '${map['Unit']}';
    }
    if(check('CreatedDateTime',map)){
      createdDateTime = '${map['CreatedDateTime']}';
    }
  }

  check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}