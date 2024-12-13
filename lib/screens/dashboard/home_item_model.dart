import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';

class HomeItemModel {
  VoidCallback? onTap;
  MHistoryModel? measurementHistoryModel;
  SleepInfoModel? sleepInfoModel;
  MotionInfoModel? motionInfoModel;
  num targetDistance;
  String iconPath;
  bool isAiModeSelected;
  List<String> details;
  String title;
  String lastRecordTime;
  double iconSize;
  double fontTitleSize;
  double fontDetailSize;

  HomeItemModel({
    required this.iconPath,
    this.measurementHistoryModel,
    this.onTap,
    this.sleepInfoModel,
    this.motionInfoModel,
    this.isAiModeSelected = true,
    this.details = const <String>[],
    this.title = '',
    this.lastRecordTime = '',
    this.iconSize = 26,
    this.fontTitleSize = 15.0,
    this.fontDetailSize = 13.0,
    this.targetDistance = 0.0,
  });
}
