import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'HRdata.g.dart';

@JsonSerializable()
List<HRdata> sampleFromJson(String str) {
  // final jsonData = json(str);
  final jsonData = jsonDecode(str);
  return List<HRdata>.from(jsonData.map((x) => HRdata.fromJson(x)));
}

String sampleToJson(List<HRdata> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class HRdata {
  int timestamp;
  String hartRate;

  HRdata({
    required this.timestamp,
    required this.hartRate,
  });

  factory HRdata.fromJson(Map<String, dynamic> json) => _$HRdataFromJson(json);

  Map<String, dynamic> toJson() => _$HRdataToJson(this);
}

List<HRdata> HART_RATE_DATA = [
  HRdata(timestamp: 00, hartRate: '100'),
  HRdata(timestamp: 01, hartRate: '130'),
  HRdata(timestamp: 02, hartRate: '140'),
  HRdata(timestamp: 03, hartRate: '90'),
  HRdata(timestamp: 04, hartRate: '160'),
  HRdata(timestamp: 05, hartRate: '190'),
];
