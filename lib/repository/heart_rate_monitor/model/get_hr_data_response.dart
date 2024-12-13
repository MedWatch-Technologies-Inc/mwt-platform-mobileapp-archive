import 'package:health_gauge/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_hr_data_response.g.dart';

@JsonSerializable()
class GetHrDataResponse extends Object {
  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  List<HrDataModel> hrData;

  GetHrDataResponse(
    this.result,
    this.response,
    this.hrData,
  );

  factory GetHrDataResponse.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetHrDataResponseFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetHrDataResponseToJson(this);
}

@JsonSerializable()
class HrDataModel extends Object {
  @JsonKey(name: 'ID')
  int? apiId;

  @JsonKey(name: 'userId')
  int? userId;

  @JsonKey(name: 'date')
  String? date;

  @JsonKey(name: 'hr')
  int? hr;

  int? id;

  @JsonKey(name: 'ZoneID')
  int? zoneID;

  HrDataModel(
      {this.apiId, this.userId, this.date, this.hr, this.id, this.zoneID});

  factory HrDataModel.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$HrDataModelFromJson(srcJson);
  }
  Map<String, dynamic> toJson() => _$HrDataModelToJson(this);

  Map<String, dynamic> toMapToInsertInDb() {
    return {
      'userId': userId.toString(),
      'approxHr': hr,
      'date': date,
      'idForApi': apiId,
      "ZoneID": zoneID,
    };
  }

  HrDataModel.clone(HrDataModel hrHistoryItem) {
    userId = hrHistoryItem.userId;
    hr = hrHistoryItem.hr;
    date = hrHistoryItem.date;
    apiId = hrHistoryItem.apiId;
    id = hrHistoryItem.id;
    zoneID = hrHistoryItem.zoneID;
  }

  HrDataModel.fromDbMapToObject(Map<String, dynamic> map) {
    userId = int.tryParse(map['userId']);
    hr = map['approxHr'];
    date = map['date'];
    apiId = map['idForApi'];
    id = map['id'];
    zoneID = map['ZoneID'];
  }
}

class ChartData {
  int? hr;
  int? hours;
  int? minutes;
  int? secound;
  String? date;

  ChartData({this.hr, this.hours, this.minutes, this.secound, this.date});

  double get x => (((hours!.toDouble() * 60) + minutes!.toDouble()) /60);

  ChartData.fromJson(Map<String, dynamic> json) {
    hr = json['hr'];
    hours = json['hours'];
    minutes = json['minutes'];
    secound = json['secound'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    print("Hours ${hours}");
    print("minutes ${hours}");
    print("secound ${hours}");
    print("secound ${hours}");



    data['hr'] = this.hr;
    data['hours'] = this.hours;
    data['minutes'] = this.minutes;
    data['secound'] = this.secound;
    data['date'] = this.date;
    return data;
  }
}
