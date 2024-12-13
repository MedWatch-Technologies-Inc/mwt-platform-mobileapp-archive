/// operation : "tag"
/// type : "drinking"
/// amount : "1"
/// date : "today's date"
/// times : [""]

class NlpSpeechEventModel {
  String? _operation;
  String? _type;
  String? _amount;
  String? _date;
  String? _unit_quantity;
  String? _other_type;
  List<String>? _times;

  String? get operation => _operation;
  String? get type => _type;
  String? get amount => _amount;
  String? get date => _date;
  String? get unitQuantity => _unit_quantity;
  String? get otherType => _other_type;
  List<String>? get times => _times;

  NlpSpeechEventModel({
      String? operation,
      String? type,
      String? amount,
      String? date,
    String? unitQuantity,
    String? otherType,
      List<String>? times}){
    _operation = operation;
    _type = type;
    _amount = amount;
    _date = date;
    _times = times;
    _unit_quantity = unitQuantity;
    _other_type = otherType;
}

  NlpSpeechEventModel.fromJson(dynamic json) {
    _operation = json["operation"];
    _type = json["type"];
    _amount = json["amount"];
    _date = json["date"];
    _unit_quantity = json['unit_quantity'];
    _other_type = json['other_type'];
    _times = json["times"] != null ? json["times"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["operation"] = _operation;
    map["type"] = _type;
    map["amount"] = _amount;
    map["date"] = _date;
    map['unit_quantity'] = _unit_quantity;
    map["times"] = _times;
    map['other_type'] = _other_type;
    return map;
  }

}