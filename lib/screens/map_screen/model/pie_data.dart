import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';

class PieData {
  static List<Data> data = [
    Data(name: 'Zone 1', percent: 40, color: AppColor.colorFFDFDE),
    Data(name: 'Zone 2', percent: 30, color: AppColor.colorFF9E99),
    Data(name: 'Zone 3', percent: 15, color: AppColor.colorFF6259),
    Data(name: 'Zone 4', percent: 15, color: AppColor.colorCC0A00),
    Data(name: 'Zone 5', percent: 15, color: AppColor.color980C23),
  ];
}

class Data {
  final String? name;

  final double? percent;

  final Color? color;

  Data({this.name, this.percent, this.color});
}
