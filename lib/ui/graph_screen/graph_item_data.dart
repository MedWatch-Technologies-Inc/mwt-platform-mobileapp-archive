import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';

class GraphItemData{
  late double xValue;
  late double yValue;
  late String xValueStr;
  late String label;
  String? colorCode;
  String? type;
  String? date;
  String? edate;
  GraphItemData({required this.yValue, required this.xValue, this.colorCode, required this.label, required this.xValueStr, this.type, this.date, this.edate});
  GraphItemData.clone(GraphItemData model){
    this.xValue = model.xValue;
    this.yValue = model.yValue;
    this.xValueStr = model.xValueStr;
    this.label = model.label;
    this.colorCode = model.colorCode;
    this.type = model.type;
    this.date = model.date;
    this.edate = model.edate;
  }

}