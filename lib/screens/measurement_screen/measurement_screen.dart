import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:cancellation_token_http/http.dart' as cancel_http;
import 'package:charts_flutter/flutter.dart' as chart;

import 'dart:math' as math;
import 'package:device_info/device_info.dart';
import 'package:fl_chart/fl_chart.dart' as fl_charts;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/measurement/ecg_info_reading_model.dart';
import 'package:health_gauge/models/measurement/health_kit_model.dart';
import 'package:health_gauge/models/measurement/lead_off_status_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/measurement/ppg_info_reading_model.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/repository/measurement/model/estimate_result.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/GraphHistory/graph_history_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/dashboard/dash_board_screen.dart';
import 'package:health_gauge/screens/measurement_screen/cards/ecg_card.dart';
import 'package:health_gauge/screens/measurement_screen/cards/hrv_card.dart';
import 'package:health_gauge/screens/measurement_screen/cards/measurement_card.dart';
import 'package:health_gauge/screens/measurement_screen/cards/ppg_card.dart';
import 'package:health_gauge/screens/measurement_screen/dialogs/estimate_dialog.dart';
import 'package:health_gauge/screens/measurement_screen/dialogs/measurement_help_dialog.dart';
import 'package:health_gauge/screens/measurement_screen/dialogs/show_calibration_dialog.dart';
import 'package:health_gauge/screens/measurement_screen/hrv_calc.dart';
import 'package:health_gauge/screens/measurement_screen/overlays/circular_progress_overlay.dart';
import 'package:health_gauge/screens/measurement_screen/overlays/linear_progress_overlay.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/count_down_circle.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/health_kit_data_layout.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/measurement_app_bar.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/start_stop_measurement.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/timer_widget.dart';
import 'package:health_gauge/screens/tag/tag_helper.dart';
import 'package:health_gauge/screens/tag/tag_list_screen.dart';
import 'package:health_gauge/services/core_util/common_utils.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/Synchronisation/watch_sync_helper.dart';
import 'package:health_gauge/utils/app_utils.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:iirjdart/butterworth.dart';
import 'package:intl/intl.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../connection_screen.dart';
import 'cards/progress_card.dart';
import 'dialogs/ai_dalogs.dart';

ValueNotifier<int> measurementTime = ValueNotifier(50);
ValueNotifier<Timer?> mTimer = ValueNotifier(null);

class MeasurementScreen extends StatefulWidget {
  final MeasurementHistoryModel? measurementHistoryModel;

  const MeasurementScreen({Key? key, this.measurementHistoryModel}) : super(key: key);

  @override
  MeasurementScreenState createState() => MeasurementScreenState();
}

class MeasurementScreenState extends State<MeasurementScreen> implements MeasurementListener {
  OverlayEntry? entry;
  bool? isLoading;
  ValueNotifier<bool> isErrorInGetMessage = ValueNotifier<bool>(false);
  ValueNotifier<bool> isOscillometricOn = ValueNotifier<bool>(false);
  ValueNotifier<bool?> isSavedFromOscillometric = ValueNotifier<bool>(false);
  LineChartController? controllerForEcgGraph;
  LineDataSet? ecgDataSet;
  LineChartController? controllerForPpgGraph;

  bool writingNotes = false;
  ValueNotifier<EcgInfoReadingModel?> _ecgInfoModel = ValueNotifier(null);
  PpgInfoReadingModel? ppgInfoModel;
  String userId = '';
  late SharedPreferences sharedPreferences;
  ValueNotifier<int> measurementType =
      ValueNotifier<int>(preferences!.getInt(Constants.measurementType) ?? 1);
  LineChartController? controllerForSysGraph;
  LineChartController? controllerForDiaGraph;
  LineChartController? controllerForHrGraph;
  LineChartController? controllerForHrvGraph;
  List<Entry> valueForSys = [];
  List<Entry> valueForDia = [];
  List<Entry> valueForHr = [];
  List<Entry> valueForHrv = [];
  late XValueFormatter xValueFormatterForSys;
  late XValueFormatter xValueFormatterForDia;
  late XValueFormatter xValueFormatterForHr;
  List<HealthKitModel> sysList = [];
  List<HealthKitModel> diaList = [];
  List<HealthKitModel> hrList = [];
  List<HealthKitModel> hrvList = [];
  List<MeasurementValue> sysList1 = [];
  List<MeasurementValue> diaList1 = [];
  List<MeasurementValue> hrList1 = [];
  List<MeasurementValue> hrvList1 = [];
  List<chart.Series<MeasurementValue, num>> lineChartSeriesForHr = [];
  List<chart.Series<MeasurementValue, num>> lineChartSeriesForBp = [];
  List<chart.Series<MeasurementValue, num>> lineChartSeriesForHrv = [];
  Widget lineChartWidgetForHr = Container(
    width: double.infinity,
    child: Center(child: Text('No chart Available')),
  );
  Widget lineChartWidgetForBp = Container(
    width: double.infinity,
    child: Center(child: Text('No chart Available')),
  );
  Widget lineChartWidgetForHrv = Container(
    width: double.infinity,
    child: Center(child: Text('No chart Available')),
  );
  var hrCalibrationTextEditController = TextEditingController(text: '');
  var sbpCalibrationTextEditController = TextEditingController(text: '');
  var dbpCalibrationTextEditController = TextEditingController(text: '');

  // var ecgElapsedList = [];
  // var ppgElapsedList = [];
  ValueNotifier<bool> poorConductivityNotifier = ValueNotifier<bool>(false);

  bool isCalibration = false;
  DeviceModel? connectedDevice;
  ValueNotifier valueListenableForCalibration = ValueNotifier(StringLocalization.normalCalibration);
  bool openKeyboardSbp = false;
  bool openKeyboardHr = false;
  bool openKeyboardDbp = false;

  XValueFormatter? xValueFormatter;
  XValueFormatter? xValueFormatterPPG;
  FocusNode? focusNodeDbp;
  String errorMessageForHeart = '';
  String errorMessageForSBP = '';
  String errorMessageForDBP = '';
  int e66CalibrationIndex = 0;
  List<RadioModel> e66CalibrationList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.normalCalibration)),
    RadioModel(false, stringLocalization.getText(StringLocalization.lowCalibration)),
    RadioModel(false, stringLocalization.getText(StringLocalization.highCalibration)),
    RadioModel(false, stringLocalization.getText(StringLocalization.hyperCalibration)),
    RadioModel(false, stringLocalization.getText(StringLocalization.highHyperCalibration)),
  ];
  ValueNotifier<num> zoomLevelPPG = ValueNotifier<num>(1);
  ValueNotifier<num> zoomLevelECG = ValueNotifier<num>(1);
  ValueNotifier<num> zoomLevelHRV = ValueNotifier<num>(1);
  Butterworth butterworth = Butterworth();
  Butterworth butterWorthLowPass = Butterworth();
  Butterworth butterWorthHighPassAfterMeasurementDone = Butterworth();
  Butterworth butterWorthLowPassAfterMeasurementDone = Butterworth();
  num firstPointPPG = 0;
  num secondPointPPG = 0;
  num firstPointECG = 0;
  num secondPointECG = 0;
  DateTime lastStartTime = DateTime.now().subtract(Duration(seconds: 6));
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo? iosInfo;

  int hrv = 0;
  final ValueNotifier<double> percentage = ValueNotifier<double>(0);
  ValueNotifier<int> ecgLength = ValueNotifier(0);
  ValueNotifier<int> ppgLength = ValueNotifier(0);
  ValueNotifier<int> hrvLength = ValueNotifier(0);

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// local time zone off set
  Duration timeZoneOffset = DateTime.now().timeZoneOffset;

  final GlobalKey webViewKey = GlobalKey();

  String url = '';
  String sys_Prediction = '';
  String dias_Prediction = '';
  double progress = 0;

  bool isListening = false;
  String? address;
  int? port;
  late WebViewController controller;

  _initServer() async {
    final server = LocalAssetsServer(
      address: InternetAddress.loopbackIPv4,
      assetsBasePath: 'tfl',
      logger: const DebugLogger(),
    );

    print('start_ ' + DateTime.now().toString());
    final address = await server.serve();
    print('end_ ' + DateTime.now().toString());

    setState(() {
      this.address = address.address;
      port = server.boundPort!;
      isListening = true;
    });

    print('local_url =>  ${"http://$address:$port"} ');
  }

  @override
  void initState() {
    LoggingService().info('Measurement', 'Open Measurement Screen');
    preferences?.setInt(Constants.prefMTime, measurementTime.value);
    measurementTime.value = preferences?.getInt(Constants.prefMTime) ?? 30;
    _initServer();
    if (Platform.isAndroid) {
      butterWorthLowPass.lowPass(3, 200, 90);
    } else {
      butterWorthLowPass.lowPass(3, 800, 84);
    }

    butterworth.highPass(3, 2500, 36);

    butterWorthHighPassAfterMeasurementDone.highPass(3, 2500, 15);
    butterWorthLowPassAfterMeasurementDone.lowPass(3, 1000, 104);

    isLeadOff.value = false;
    poorConductivityNotifier = ValueNotifier(false);
    getPreferences();

    initGraphControllers();
    setDefaultMeasurementForHistory();
    isAISelected.value = preferences!.getBool(Constants.isAISelected) ?? false;
    isTflSelected.value = preferences!.getBool(Constants.isTFLSelected) ?? false;
    print('isAISelected => ${isAISelected.value}');
    super.initState();
  }

  @override
  void dispose() {
    isLeadOff.dispose();
    poorConductivityNotifier.dispose();

    hrCalibrationTextEditController.dispose();
    sbpCalibrationTextEditController.dispose();
    dbpCalibrationTextEditController.dispose();
    super.dispose();
  }

  generateLineChart(List<chart.Series<MeasurementValue, num>> lineChartSeries, String field) {
    if (field == 'BP') {
      lineChartSeries[1]
        ..setAttribute(
          chart.measureAxisIdKey,
          chart.Axis.secondaryMeasureAxisId,
        );
    }
    return chart.LineChart(
      lineChartSeries,
      animate: true,
      customSeriesRenderers: List.generate(field == 'BP' ? 2 : 1, (index) {
        return chart.LineRendererConfig(
          customRendererId: field != 'BP'
              ? field
              : field == 'BP' && index == 0
                  ? 'BP1'
                  : 'BP2',
          includeArea: false,
          stacked: true,
          includePoints: true,
          includeLine: true,
          roundEndCaps: true,
          radiusPx: 2.0,
          strokeWidthPx: 1.0,
        );
      }),
      primaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: isDarkMode(context)
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black)),
        tickProviderSpec: chart.BasicNumericTickProviderSpec(desiredTickCount: 5, zeroBound: false),
      ),
      secondaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: isDarkMode(context)
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
            lineStyle: chart.LineStyleSpec(
                color: isDarkMode(context)
                    ? chart.ColorUtil.fromDartColor(Colors.white.withOpacity(0.4))
                    : chart.ColorUtil.fromDartColor(Color(0xffA7B2AF)))),
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          zeroBound: false,
        ),
      ),
      domainAxis: chart.NumericAxisSpec(
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
          zeroBound: true,
          desiredTickCount: 30,
        ),
        tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
          _formatterXAxis,
        ),
        renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: isDarkMode(context)
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
            lineStyle: chart.LineStyleSpec(
                color: isDarkMode(context)
                    ? chart.ColorUtil.fromDartColor(Colors.white.withOpacity(0.4))
                    : chart.ColorUtil.fromDartColor(Color(0xffA7B2AF)))),
        viewport: chart.NumericExtents(0, 31),
      ),
    );
  }

  generateSampleDataAndGraph() async {
    sysList = [];
    diaList = [];
    hrList = [];
    hrvList = [];
    sysList1 = [];
    diaList1 = [];
    hrList1 = [];
    hrvList1 = [];
    await getDataFromHealthKitForGraph();

    lineChartSeriesForHr = generateLineChartData(field: 'HR');
    lineChartSeriesForBp = generateLineChartData(field: 'BP');
    lineChartSeriesForHrv = generateLineChartData(field: 'Hrv');
    lineChartWidgetForHr = generateLineChart(lineChartSeriesForHr, 'HR');
    lineChartWidgetForBp = generateLineChart(lineChartSeriesForBp, 'BP');
    lineChartWidgetForHrv = generateLineChart(lineChartSeriesForHrv, 'Hrv');

    debugPrint('Generated data');

    Future.delayed(Duration(milliseconds: 100)).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  getDataFromHealthKitForGraph() async {
    var endDate = DateTime.now();
    var startDate = endDate.subtract(Duration(days: 30));
    final formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
    List? data1 = await connections.readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
        formatter.format(startDate), formatter.format(endDate));
    List? data2 = await connections.readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
        formatter.format(startDate), formatter.format(endDate));
    List? data3 = await connections.readHeartRateDataFromHealthKitOrGoogleFit(
        formatter.format(startDate), formatter.format(endDate));
    List? data4 = await connections.readHRVDataFromHealthKitOrGoogleFit(
        formatter.format(startDate), formatter.format(endDate));
    _ecgInfoModel.value = EcgInfoReadingModel();
    if (data3.isNotEmpty) {
      _ecgInfoModel.value?.approxHr = ((double.tryParse(data3.last['value']) ?? 0).toInt());
    } else {
      _ecgInfoModel.value?.approxHr = 0;
    }

    if (data4.isNotEmpty) {
      _ecgInfoModel.value?.hrv = ((double.tryParse(data4.last['value']) ?? 0).toInt());
    } else {
      _ecgInfoModel.value?.hrv = 0;
    }
    if (AppUtils().iOSVersionCompare(iosInfo?.systemVersion)) {
      Map? ecgData = await connections.readBodyEcgDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));
      if (ecgData != null) {
        ecgPList.value = ecgData['ecgList'];
        if (ecgPList.value.isNotEmpty) {
          ecgGraphValue1.value.clear();
          if (controllerForEcgGraph == null) {
            initGraphControllers();
          }
          for (var i = 0; i < ecgPList.value.length; i++) {
            ecgXValue.value = i + 0.0;

            var entry = Entry(
              x: ecgXValue.value,
              y: ecgPList.value[i].toDouble(),
            );
            ecgGraphValue1.value.add(entry);
          }

          _ecgInfoModel.value?.hrv = getHrvFromEcg(ecgGraphValue1.value);
          _ecgInfoModel.value?.approxHr = ecgData['hrValue'];

          setDataToEcgGraph();

          Future.delayed(Duration(milliseconds: 500)).then((value) {
            try {
              controllerForEcgGraph?.setVisibleXRangeMaximum(1200);
              controllerForEcgGraph?.setVisibleXRangeMinimum(1200);
              setState(() {});
            } catch (e) {
              debugPrint('Exception at measurement screen $e');
            }
          });
          setGraphColors();
        }
      }
    }

    if (data2.isNotEmpty) {
      sysList = data2.map((e) => HealthKitModel.fromMap(e)).toList();
      sysList1 = [];
    } else {
      sysList = [];
      sysList1 = [];
    }
    if (data1.isNotEmpty) {
      diaList = data1.map((e) => HealthKitModel.fromMap(e)).toList();
      diaList1 = [];
    } else {
      diaList = [];
      diaList1 = [];
    }
    if (data3.isNotEmpty) {
      hrList = data3.map((e) => HealthKitModel.fromMap(e)).toList();
      hrList1 = [];
    } else {
      hrList = [];
      hrList1 = [];
    }
    if (data4.isNotEmpty) {
      hrvList = data4.map((e) => HealthKitModel.fromMap(e)).toList();
      hrvList1 = [];
    } else {
      hrvList = [];
      hrvList1 = [];
    }

    var days = <DateTime>[];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    sysList1 = [];
    diaList1 = [];
    hrvList1 = [];
    hrList1 = [];
    var i = 0;
    for (var date in days) {
      var sysRes = sysList.where((element) {
        var sysDate = DateTime.tryParse(element.endTime ?? '');
        if (sysDate?.month == date.month && sysDate?.day == date.day) {
          return true;
        }
        return false;
      }).toList();
      var diaRes = diaList.where((element) {
        var sysDate = DateTime.tryParse(element.endTime ?? '');
        if (sysDate?.month == date.month && sysDate?.day == date.day) {
          return true;
        }
        return false;
      }).toList();
      var hrRes = hrList.where((element) {
        var sysDate = DateTime.tryParse(element.endTime ?? '');
        if (sysDate?.month == date.month && sysDate?.day == date.day) {
          return true;
        }
        return false;
      }).toList();
      var hrvRes = hrvList.where((element) {
        var sysDate = DateTime.tryParse(element.endTime ?? '');
        if (sysDate?.month == date.month && sysDate?.day == date.day) {
          return true;
        }
        return false;
      }).toList();
      num sysSum = 0;
      num diaSum = 0;
      num hrSum = 0;
      num hrvSum = 0;
      if (sysRes.isNotEmpty) {
        sysRes.forEach((element) {
          sysSum += double.tryParse(element.value ?? '') ?? 0;
        });
        sysSum = sysSum / sysRes.length;
      }
      if (diaRes.isNotEmpty) {
        diaRes.forEach((element) {
          diaSum += double.tryParse(element.value ?? '') ?? 0;
        });
        diaSum = diaSum / diaRes.length;
      }
      if (hrRes.isNotEmpty) {
        hrRes.forEach((element) {
          hrSum += double.tryParse(element.value ?? '') ?? 0;
        });
        hrSum = hrSum / hrRes.length;
      }
      if (hrvRes.isNotEmpty) {
        hrvRes.forEach((element) {
          hrvSum += double.tryParse(element.value ?? '') ?? 0;
        });
        hrvSum = hrvSum / hrvRes.length;
      }
      sysList1.add(MeasurementValue(
        xValue: i.toDouble(),
        xAxis: date.day.toString() + '/' + date.month.toString(),
        yValue: sysSum.toDouble(),
      ));
      diaList1.add(MeasurementValue(
        xValue: i.toDouble(),
        xAxis: date.day.toString() + '/' + date.month.toString(),
        yValue: diaSum.toDouble(),
      ));
      hrList1
        ..add(MeasurementValue(
          xValue: i.toDouble(),
          xAxis: date.day.toString() + '/' + date.month.toString(),
          yValue: hrSum.toDouble(),
        ));
      hrvList1.add(MeasurementValue(
        xValue: i.toDouble(),
        xAxis: date.day.toString() + '/' + date.month.toString(),
        yValue: hrvSum.toDouble(),
      ));
      i++;
    }

    setState(() {});
  }

  void saveMeasurementDataInDatabase(List<HealthKitModel> sysList, List<HealthKitModel> diaList,
      List<HealthKitModel> hrList, List<HealthKitModel> hrvList) async {
    try {
      var hr = double.tryParse(hrList.last.value ?? '0');
      var hrv = double.tryParse(hrvList.last.value ?? '0');
      var sys = double.tryParse(sysList.last.value ?? '0');
      var dia = double.tryParse(diaList.last.value ?? '0');
      dbHelper.getLastSavedMeasurementData(userId).then(
        (List<MeasurementHistoryModel> ecgList) async {
          if (ecgList.isNotEmpty) {
            var data = ecgList.first;
            if (data.hr == hr && data.sbp == sys && data.dbp == dia && data.hrv == hrv) {
            } else {
              var strEcgList = '22,33';
              var strPpgList = '33,44';

              var strEcgTimeList = '';
              var strPpgTimeList = '';

              var map = Map<String, dynamic>();

              map = {
                'approxHr': hrList.last.value ?? 0,
                'approxSBP': sysList.last.value ?? 0,
                'approxDBP': diaList.last.value ?? 0,
                'hrv': hrvList.last.value ?? 0,
                'ecgValue': 0,
              };
              map['ppgValue'] = null;
              map['user_Id'] = userId;
              map['date'] = DateTime.now().toString();
              map['ecg'] = strEcgList;
              map['ppg'] = strPpgList;
              map['tHr'] = 0;
              map['tSBP'] = 0;
              map['tDBP'] = 0;
              map['aiSBP'] = 0;
              map['aiDBP'] = 0;

              map['IsCalibration'] = isCalibration;
              map['isForTraining'] = false;
              map['isForOscillometric'] = false;
              map['DeviceType'] = connectedDevice?.sdkType == Constants.zhBle ? 'E08' : 'E80';
              map['IdForApi'] = null;

              var result = await dbHelper.insertMeasurementData(map, userId).then((value) {
                debugPrint(value);
              });

              debugPrint('recordId $result');
              return result;
            }
          }
        },
      );
    } catch (e) {
      debugPrint('Exception at saveMeasurementDataInDatabase $e');
    }
  }

  String _formatterXAxis(num? year) {
    try {
      var value = year?.toInt() ?? 0;
      var val = hrList1[value].xAxis;
      if (value % 3 == 0) {
        return '$val';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  List<chart.Series<MeasurementValue, num>> generateLineChartData({String? field}) {
    var graphList = <List<MeasurementValue>>[];
    if (field == 'HR') {
      graphList.add(hrList1);
    } else if (field == 'BP') {
      graphList.add(sysList1);
      graphList.add(diaList1);
    } else {
      graphList.add(hrvList1);
    }

    return List.generate(graphList.length, (index) {
      var colorCode = '#009C92';
      if (field == 'BP' && index == 1) {
        colorCode = '#0058cc';
      }
      if (colorCode.length > 4 && colorCode[3] == 'f' && colorCode[4] == 'f') {
        colorCode = colorCode.replaceRange(3, 5, '');
      }
      var materialColor = HexColor.fromHex(colorCode);

      return chart.Series<MeasurementValue, double>(
        id: (field != 'BP' ? field : (field == 'BP' && index == 0 ? 'BP1' : 'BP2')) ?? '',
        colorFn: (MeasurementValue data, __) => chart.Color(
            a: materialColor.alpha,
            r: materialColor.red,
            g: materialColor.green,
            b: materialColor.blue),
        domainFn: (MeasurementValue data, _) => data.xValue,
        measureFn: (MeasurementValue data, _) => data.yValue,
        data: graphList[index],
      )..setAttribute(
          chart.rendererIdKey,
          field != 'BP'
              ? field
              : field == 'BP' && index == 0
                  ? 'BP1'
                  : 'BP2');
    });
  }

  void selectDataSource({GestureTapCallback? onClickOk}) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return AIDialogs(
          onClickOk: onClickOk,
        );
      },
      barrierDismissible: false,
    );
  }

  Future<void> setEstimationConfiguration() async {
    var isOSM = preferences?.getBool(Constants.isOscillometricEnableKey) ?? false;
    var isEST = preferences?.getBool(Constants.isEstimatingEnableKey) ?? false;
    print('isOSM : $isOSM, isEST : $isEST');
    if (!isEST && !isOSM) {
      isAISelected.value = false;
      isTflSelected.value = false;
    } else {
      if (!isAISelected.value && !isTflSelected.value) {
        isTflSelected.value = true;
      }
      await preferences?.setBool(Constants.isAISelected, isAISelected.value);
      await preferences?.setBool(Constants.isTFLSelected, isTflSelected.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor:
            isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MeasurementAppBar(
            measurementType: measurementType,
            measurementHistoryModel: widget.measurementHistoryModel,
            generateSampleDataAndGraph: generateSampleDataAndGraph,
            isCalibration: isCalibration,
            onPressedCalibration: () {
              if (measurementType.value == 2 && Platform.isIOS) {
                generateSampleDataAndGraph();
              } else {
                isCalibration = true;
                showCalibrationDialog(
                  isOs: false,
                  isTrng: false,
                  onClickOk: () {
                    if (mounted) {
                      if (focusNodeDbp != null) {
                        focusNodeDbp!.unfocus();
                      }
                      writingNotes = false;
                      Navigator.of(context, rootNavigator: true).pop();
                    }

                    var hr = int.tryParse(hrCalibrationTextEditController.text) ?? 0;
                    var sbp = int.tryParse(sbpCalibrationTextEditController.text) ?? 0;
                    var dbp = int.tryParse(dbpCalibrationTextEditController.text) ?? 0;
                    connections.setCelebration(hr: hr, sbp: sbp, dbp: dbp);
                    preferences!.setInt(Constants.hrCalibrationPrefKey, hr);
                    preferences!.setInt(Constants.sbpCalibrationPrefKey, sbp);
                    preferences!.setInt(Constants.dbpCalibrationPrefKey, dbp);

                    if (!isMRunning.value && connectedDevice?.sdkType == Constants.zhBle) {
                      startMeasurement(context: context, showTimer: true);
                    }
                    hrCalibrationTextEditController.text = '';
                    sbpCalibrationTextEditController.text = '';
                    dbpCalibrationTextEditController.text = '';
                    OverlayEntry? entry = showProgressOverlay(context);
                    Timer.periodic(Duration(seconds: 1), (timer) {
                      percentage.value = percentage.value + (100 / 35);
                      if (percentage.value >= 100) {
                        if (entry != null) {
                          entry!.remove();
                        }
                        entry = null;
                        percentage.value = 0;
                        timer.cancel();
                        CustomSnackBar.buildSnackbar(
                          context,
                          'Calibration Successful! Your device is now calibrated and ready to take measurements.',
                          3,
                        );
                      }
                    });
                  },
                );
              }
            },
            onPressedSettings: () async {
              await setEstimationConfiguration();
              selectDataSource(onClickOk: () {
                preferences?.setBool(Constants.isAISelected, isAISelected.value);
                preferences?.setBool(Constants.isTFLSelected, isTflSelected.value);

                print('AIDialog :: Result :: ai :: ${isAISelected.value}');
                print('AIDialog :: Result :: tfl :: ${isTflSelected.value}');
                print('AIDialog :: Result :: osm :: $isOSM');
                print('AIDialog :: Result :: est :: $isEST');

                if (isTflSelected.value) {
                  // preferences?.setBool(Constants.isOscillometricEnableKey, false);
                  preferences?.setBool(Constants.isGlucoseData, false);
                  // preferences?.setBool(Constants.isEstimatingEnableKey, false);
                } else {
                  var isTrainingEnable =
                      preferences!.getBool(Constants.isTrainingEnableKey1) ?? false;
                  var isOscillometric =
                      preferences!.getBool(Constants.isOscillometricEnableKey) ?? false;
                  var isEstimate = preferences!.getBool(Constants.isEstimatingEnableKey) ?? false;
                  var isGlucoseData = preferences?.getBool(Constants.isGlucoseData1) ?? false;
                  preferences?.setBool(Constants.isTrainingEnableKey, isTrainingEnable);
                  preferences?.setBool(Constants.isOscillometricEnableKey, isOscillometric);
                  preferences?.setBool(Constants.isGlucoseData, isGlucoseData);
                  preferences?.setBool(Constants.isEstimatingEnableKey, isEstimate);
                }
                Navigator.of(context, rootNavigator: true).pop();
              });

              // lodingDailog();
            },
          ),
        ),
        body: layoutMain(),
        bottomNavigationBar: (measurementType.value == 2 && Platform.isIOS) ||
                widget.measurementHistoryModel != null
            ? Container(
                width: 1,
                height: 1,
                color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
              )
            : Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: btnEnabled,
                      builder: (BuildContext context, bool value, Widget? child) {
                        return StartStopMeasurement(
                          enabled: value,
                          onPressed: () async {
                            if ((mTimer.value?.isActive ?? false)) {
                              stopConfirmationDialog();
                            } else {
                              startMeasurement(context: context, showTimer: true);
                            }
                            isOscillometricOn.value = false;
                          },
                          lastStartTime: lastStartTime,
                          isMeasuring: isMRunning,
                          timer: mTimer,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.h, left: 20.h),
                    child: ValueListenableBuilder(
                      valueListenable: timerCount,
                      builder: (BuildContext context, int value, Widget? child) {
                        return CountDownCircle(
                          countDown: isMRunning.value ? value : 0,
                          progressColor: HexColor.fromHex('#62CBC9'),
                          connectedDevice: connectedDevice,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  int estimateNumber = 0;

  // bool isClosed = false;

  Future<dynamic> loadingDialog(cancel_http.CancellationToken cancelToken, bool isWebview) async {
    var isTflData = preferences?.getBool(Constants.isTFLSelected) ?? false;
    // var tflStatus = ValueNotifier('');
    try {
      if (isWebview) {
        // tflStatus.value = 'Starting..';
        // tflStatus.value = 'Initializing !! ';
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('http://$address:$port'))
          ..addJavaScriptChannel(
            "Print",
            onMessageReceived: (message) {
              sys_Prediction = message.message.split(',')[0];
              dias_Prediction = message.message.split(',')[1];
              controller.runJavaScript('window.stop();');
              Navigator.of(context, rootNavigator: true).pop(true);
            },
          );
        // tflStatus.value = 'Initialized !! ';
        // Future.delayed(Duration(seconds: 1), () {
        //   tflStatus.value = 'Waiting for response...';
        // });
      }
    } catch (e) {
      print(e);
      // tflStatus.value = 'Error :: ${e.toString()}';
    }

    sys_Prediction = '0';
    dias_Prediction = '0';
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.h),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10.h),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(-5, -5),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#000000').withOpacity(0.75)
                          : HexColor.fromHex('#384341').withOpacity(0.9),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(5, 5),
                    ),
                  ]),
              padding: EdgeInsets.only(bottom: 22.w, top: 10.w),
              width: 309.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Theme.of(context).brightness == Brightness.dark
                              ? Image.asset(
                                  'asset/dark_close.png',
                                  width: 33,
                                  height: 33,
                                )
                              : Image.asset(
                                  'asset/close.png',
                                  width: 33,
                                  height: 33,
                                ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context, rootNavigator: true).pop();
                              if (isWebview) {
                                controller.runJavaScript('window.stop();');
                              }
                              cancelToken.cancel();
                            }
                          },
                        ),
                      ),
                      TitleText(
                        align: TextAlign.center,
                        text: isTflData
                            ? 'Edge AI estimate in progress \nPlease wait'
                            : 'Cloud AI estimate in progress \nPlease wait',
                        fontSize: 17.sp,
                        maxLine: 2,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        // maxLine: 1,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CircularProgressIndicator(),
                      // SizedBox(
                      //   height: 15.h,
                      // ),
                      // ValueListenableBuilder(
                      //   valueListenable: tflStatus,
                      //   builder: (BuildContext context, String value, Widget? child) {
                      //     return Body1AutoText(
                      //       text: tflStatus.value,
                      //       maxLine: 10,
                      //     );
                      //   },
                      // ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : AppColor.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                  : Colors.white,
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: Offset(-10, -10),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.25)
                                  : HexColor.fromHex('#D1D9E6'),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: Offset(10, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: Key('graphCloseButton'),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Body1AutoText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.cancel),
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                    : HexColor.fromHex('#5D6A68'),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                align: TextAlign.center,
                                minFontSize: 12,
                                maxLine: 1,
                              ),
                              // child: FittedTitleText(
                              //   text: 'Close',
                              //   color: Theme.of(context).brightness == Brightness.dark
                              //       ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                              //       : HexColor.fromHex('#5D6A68'),
                              //   fontWeight: FontWeight.bold,
                              //   fontSize: 18.sp,
                              //   align: TextAlign.center,
                              //   // maxLine: 1,
                              // ),
                            ),
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.of(context, rootNavigator: true).pop();
                                if (isWebview) {
                                  controller.runJavaScript('window.stop();');
                                }
                                cancelToken.cancel();
                                // isClosed = true;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                    height: 0,
                    child: isWebview ? WebViewWidget(controller: controller) : SizedBox(),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
    return result;
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Future<void> stopMeasurement() async {
    mTimer.value?.cancel();
    mTimer.value = null;
    isMNotStarted.value = false;
    Wakelock.disable();
    ecgStartTime.value = 0;
    ppgStartTime.value = 0;
    try {
      var deviceModel = await connections.checkAndConnectDeviceIfNotConnected();
      connectedDevice = deviceModel;
      if (deviceModel != null) {
        await connections
            .isConnected(connectedDevice!.sdkType ?? Constants.e66)
            .then((value) async {
          var result = await connections.stopMeasurement();
          print('isConnected :: stopMeasurement :: $result');
        });
      }
    } catch (e) {
      debugPrint('Exception at onClickStop $e');
      LoggingService().warning('Measurement', 'Error on stop measurement called', error: e);
    }
    isMRunning.value = false;
    isLeadOff.value = false;
    preferences?.setInt(
      Constants.kbpReminder,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /*Future onClickStop([bool? isFromButton]) async {
    mTimer.value?.cancel();
    mTimer.value = null;
    isMNotStarted.value = false;
    Wakelock.disable();
    try {
      connections.checkAndConnectDeviceIfNotConnected().then((value) {
        connectedDevice = value;
        if (connectedDevice != null) {
          bool? isStopped;
          connections.stopMeasurement().then((value) {
            isStopped = value;
          });
          print('isStopped $isStopped');
        }
      });
      LoggingService().info('Measurement', 'Stop measurement called');
    } catch (e) {
      debugPrint('Exception at onClickStop $e');
      LoggingService().warning('Measurement', 'Error on stop measurement called', error: e);
    }
    // poorConductivityNotifier.value = false;

    preferences?.setInt(
      Constants.kbpReminder,
      DateTime.now().millisecondsSinceEpoch,
    );
    setState(() {});
  }*/

  stopConfirmationDialog() async {
    var dialog = CustomDialog(
      title: stringLocalization.getText(StringLocalization.stopMeasurement) + '!',
      subTitle: stringLocalization.getText(StringLocalization.areYouSureWantToStopMeasurement),
      maxLine: 10,
      secondaryButton: stringLocalization.getText(StringLocalization.no).toUpperCase(),
      onClickNo: () {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
      onClickYes: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    final result =
        await showDialog(context: context, builder: (context) => dialog, barrierDismissible: false);
    if (result is bool && result) {
      stopMeasurement();
      setState(() {
        lastStartTime = DateTime.now().subtract(Duration(seconds: 10));
      });
    }
  }

  void clearInputFields() {
    hrCalibrationTextEditController.clear();
    sbpCalibrationTextEditController.clear();
    dbpCalibrationTextEditController.clear();
  }

  Future<void> androidMemorySetup() async {
    LoggingService().info('Measurement', 'Before GC');
    getMemory(0);
    await connections.invokeGC();
    LoggingService().info('Measurement', 'After GC');
    getMemory(0);
  }

  void clearECGModel() {
    if (_ecgInfoModel.value != null) {
      if (_ecgInfoModel.value!.approxHr != null) {
        _ecgInfoModel.value!.approxHr = null;
      }
      if (_ecgInfoModel.value!.approxSBP != null) {
        _ecgInfoModel.value!.approxSBP = null;
      }
      if (_ecgInfoModel.value!.approxDBP != null) {
        _ecgInfoModel.value!.approxDBP = null;
      }
      if (_ecgInfoModel.value!.hrv != null) {
        _ecgInfoModel.value!.hrv = null;
      }
      _ecgInfoModel.value = null;
    }
  }

  void resetVariables() {
    mAISbp.value = 0;
    mAIDbp.value = 0;
    mBG1.value = 0;
    mBG2.value = 0;
    mBGUnit1.value = '';
    mBGUnit2.value = '';
    mBGClass.value = '';
    mUncertainty.value = 0;
    isMFailed.value = false;
    tsAvgPointECG.value = 0;
    tsAvgPointPPG.value = 0;
    showMFailDialog.value = false;
    isMNotStarted.value = false;
    showMWrongDialog.value = false;

    dashBoardGlobalKey.currentState?.lastDataFetchedTime = DateTime.now();
    connections.measurementListener = this;
    Wakelock.enable();
    setGraphColors();
  }

  Future<void> prepareMeasurement({bool showTimer = false}) async {
    await setEstimationConfiguration();
    hrvCalc.resetData();
    ecgLength.value = 0;
    ppgLength.value = 0;
    hrvLength.value = 0;
    previousX = 0;
    previousHRV.clear();

    offLeadCount.value = 0;
    ecgXValue.value = 0.0;
    ppgXValue.value = 0.0;

    ecgPList.value.clear();
    ppgPList.value.clear();
    hrvPointList.value.clear();
    ppgFilterList.value.clear();
    hrvGraphValues.value.clear();
    hrvGraphValues.notifyListeners();

    ecgEndTime.value = 0.0;
    ppgEndTime.value = 0.0;

    if (connectedDevice?.sdkType == Constants.e66) {
      ecgEndTime.value = DateTime.now().millisecondsSinceEpoch;
      ecgLastRecordDate.value = DateTime.now();
    }

    isCanceled.value = false;
    controllerForEcgGraph = null;
    controllerForPpgGraph = null;
    if (connectedDevice?.sdkType == Constants.e66) {
      await Future.delayed(Duration(milliseconds: 100), initGraphControllers);
    }

    avgPPGList.value.clear();
    avgECGList.value.clear();

    ecgGraphValue1.value.clear();
    ecgGraphValue2.value.clear();
    ppgGraphValue1.value.clear();
    hrvGraphValues.value.clear();

    ecgGraphValue1.value = initializeGraphEntry;
    ppgGraphValue1.value = initializeGraphEntry;
    // hrvGraphValues.value = initializeHRVGraphEntry;

    if (showTimer) {
      await showInitDialog();
      await Future.delayed(Duration(milliseconds: 500));
    }
    isLeadOff.value = true;
    isMRunning.value = true;
  }

  Future<void> checkECGMeasurements() async {
    var limit = measurementTime.value;
    mTimer.value?.cancel();
    mTimer.value = null;
    timerCount.value = 0;
    mTimer.value = Timer.periodic(Duration(seconds: 1), (time) async {
      try {
        timerCount.value = time.tick;
        if (time.tick > limit && mTimer.value!.isActive) {
          time.cancel();
          mTimer.value!.cancel();
        }
        checkAndEndMeasurement();
        var data1Validation = ecgPList.value.isEmpty || ppgPList.value.isEmpty;
        var timer1Validation = time.tick > 8;
        var dialog1Validation = !showMFailDialog.value;

        var timer2Validation = time.tick >= 10;
        var data2Validation = ppgPList.value.length <= 500 || ecgPList.value.length <= 500;
        var leadValidation = offLeadCount.value <= 2;

        if (data1Validation && timer1Validation && dialog1Validation) {
          retryCount.value += 1;
          time.cancel();
          mTimer.value!.cancel();
          print('isConnected :: retryCount :: ${retryCount.value}');
          if (retryCount.value < 3) {
            await Future.delayed(Duration(seconds: 2));
            await stopMeasurement();
            showDialogForWrongMeasurementData(
              text: stringLocalization.getText(
                StringLocalization.wrongData,
              ),
            );
          }
        } else if (timer2Validation && data2Validation && leadValidation && !isMFailed.value) {
          time.cancel();
          mTimer.value!.cancel();
          await Future.delayed(Duration(seconds: 2));
          await stopMeasurement();
          showDialogForWrongMeasurementData(
            text: stringLocalization.getText(
              StringLocalization.wrongData,
            ),
          );
        }

        if (retryCount.value >= 3) {
          retryCount.value = 0;
          time.cancel();
          mTimer.value!.cancel();
          await stopMeasurement();
          var result = await reconnectConfirmation();
          if (result) {
            var isDisconnected = await disconnectDevice();
            if (isDisconnected) {
              reconnectionLoader();
              var isConnected = await reconnectDevice();
              Navigator.of(context, rootNavigator: true).pop();
              if (isConnected) {
                Fluttertoast.showToast(msg: 'Connected successfully.');
              } else {
                Fluttertoast.showToast(msg: 'Fail to connect. Please try manually.');
              }
            } else {
              Fluttertoast.showToast(msg: 'Fail to disconnect. Please try manually.');
            }
          } else {
            var isDisconnected = await disconnectDevice();
            if (isDisconnected) {
              Fluttertoast.showToast(msg: 'Disconnected successfully.');
            } else {
              Fluttertoast.showToast(msg: 'Fail to disconnect. Please try manually.');
            }
          }
        }
      } catch (e) {
        debugPrint('Exception at measurement screen $e');
        LoggingService().info('Measurement', 'Exception at measurement screen');
      }
    });
  }

  Future<dynamic> reconnectionLoader() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.h),
              ),
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10.h),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#000000').withOpacity(0.75)
                            : HexColor.fromHex('#384341').withOpacity(0.9),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(5, 5),
                      ),
                    ]),
                padding: EdgeInsets.only(bottom: 22.w, top: 22.w),
                width: 200.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Body1AutoText(
                          text: 'Re-connecting',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          maxLine: 2,
                          minFontSize: 20,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future reconnectConfirmation() async {
    var dialog = CustomDialog(
      title: 'Please confirm',
      subTitle:
          'It seems like there is a problem while trying to establish a connection with the watch and retrieve your data. To fix that, the watch will disconnect and reconnect automatically.',
      primaryButton: 'ok',
      showSecondary: false,
      maxLine: 10,
      onClickNo: () async {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
      onClickYes: () async {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    var result = await showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );

    return result;
  }

  Future<bool> reconnectDevice() async {
    var value = preferences?.getString(Constants.connectedDeviceAddressPrefKey);
    DeviceModel? deviceModel;
    if (value != null) {
      var val = jsonDecode(value);
      deviceModel = DeviceModel.fromMap(val);
    }
    connections.connectToDevice(deviceModel);
    await Future.delayed(Duration(seconds: 5));
    var result = await connections.isConnected(deviceModel!.sdkType ?? Constants.e66);
    if (result) {
      preferences?.setString(
          Constants.connectedDeviceAddressPrefKey, jsonEncode(deviceModel.toMap()));
      connectedDevice = deviceModel;
      connections.sdkType = connectedDevice?.sdkType ?? 2;
    }
    return result;
  }

  Future<bool> disconnectDevice() async {
    var value = preferences?.getString(Constants.connectedDeviceAddressPrefKey);
    DeviceModel? deviceModel;
    if (value != null) {
      var val = jsonDecode(value);
      deviceModel = DeviceModel.fromMap(val);
    }
    var isDisconnected = await connections.disConnectToDevice();
    return isDisconnected;
  }

  ValueNotifier<double> mAISbp = ValueNotifier<double>(0);
  ValueNotifier<double> mAIDbp = ValueNotifier<double>(0);
  ValueNotifier<double> mBG1 = ValueNotifier<double>(0);
  ValueNotifier<double> mBG2 = ValueNotifier<double>(0);
  ValueNotifier<double> mUncertainty = ValueNotifier<double>(0);
  ValueNotifier<String> mBGUnit1 = ValueNotifier<String>('');
  ValueNotifier<String> mBGUnit2 = ValueNotifier<String>('');
  ValueNotifier<String> mBGClass = ValueNotifier<String>('');
  ValueNotifier<bool> isMFailed = ValueNotifier<bool>(false);
  ValueNotifier<num> tsOnClickStart = ValueNotifier<num>(0);
  ValueNotifier<num> tsAvgPointECG = ValueNotifier<num>(0);
  ValueNotifier<num> tsAvgPointPPG = ValueNotifier<num>(0);
  ValueNotifier<bool> showMFailDialog = ValueNotifier<bool>(false);
  ValueNotifier<bool> isMNotStarted = ValueNotifier<bool>(false);
  ValueNotifier<bool> showMWrongDialog = ValueNotifier<bool>(false);
  ValueNotifier<int> offLeadCount = ValueNotifier<int>(0);
  ValueNotifier<double> ecgXValue = ValueNotifier<double>(0.0);
  ValueNotifier<double> ppgXValue = ValueNotifier<double>(0.0);
  ValueNotifier<List<int>> ecgPList = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> ppgPList = ValueNotifier<List<int>>([]);
  ValueNotifier<List<num>> ppgFilterList = ValueNotifier<List<num>>([]);
  ValueNotifier<num> ecgEndTime = ValueNotifier(0);
  ValueNotifier<num> ecgStartTime = ValueNotifier(0);
  ValueNotifier<num> ppgEndTime = ValueNotifier(0);
  ValueNotifier<num> ppgStartTime = ValueNotifier(0);
  ValueNotifier<DateTime> ecgLastRecordDate = ValueNotifier(DateTime.now());
  ValueNotifier<bool> isLeadOff = ValueNotifier<bool>(false);
  ValueNotifier<bool> isMRunning = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCanceled = ValueNotifier<bool>(false);
  ValueNotifier<bool> btnEnabled = ValueNotifier<bool>(true);
  ValueNotifier<List<double>> avgECGList = ValueNotifier<List<double>>([]);
  ValueNotifier<List<double>> avgPPGList = ValueNotifier<List<double>>([]);
  ValueNotifier<List<Entry>> ecgGraphValue1 = ValueNotifier([]);
  ValueNotifier<List<Entry>> ecgGraphValue2 = ValueNotifier([]);
  ValueNotifier<List<Entry>> ppgGraphValue1 = ValueNotifier([]);
  ValueNotifier<int> retryCount = ValueNotifier(0);
  ValueNotifier<int> timerCount = ValueNotifier(0);
  ValueNotifier<List<double>> ppgListFromGraph = ValueNotifier<List<double>>([]);
  ValueNotifier<List<double>> ecgListFromGraph = ValueNotifier<List<double>>([]);

  List<Entry> get initializeGraphEntry => [for (int i = 0; i <= 200; i++) i]
      .map((e) => Entry(
            x: e.toDouble(),
            y: 0,
          ))
      .toList();

  Future<void> startMeasurement({required BuildContext context, bool showTimer = false}) async {
    btnEnabled.value = false;
    Future.delayed(Duration(seconds: 8), () {
      btnEnabled.value = true;
    });
    var isConsent = preferences!.getBool(Constants.prefConsentKey) ?? false;
    var isResearcher = globalUser!.isResearcherProfile!;
    if (isResearcher && !isConsent) {
      var appUtils = AppUtils();
      await appUtils.consentDialog(context);
    }
    isConsent = preferences!.getBool(Constants.prefConsentKey) ?? false;

    if (isConsent) {
      clearInputFields();
      if (Platform.isAndroid) {
        androidMemorySetup();
      }
      clearECGModel();
      resetVariables();

      var deviceModel = await connections.checkAndConnectDeviceIfNotConnected(doConnect: true);
      connectedDevice = deviceModel;
      if (connectedDevice != null) {
        var isConnected = await connections.isConnected(connectedDevice!.sdkType ?? Constants.e66);
        print('isConnected :: $isConnected');
        if (isConnected) {
          await prepareMeasurement(showTimer: showTimer);
          var value = await connections.startMeasurement();
          print('isConnected :: started :: $value');
          if (value) {
            tsOnClickStart.value = DateTime.now().toUtc().millisecondsSinceEpoch;
            isMRunning.value = true;
            lastStartTime = DateTime.now();
          }
          checkECGMeasurements();
        }
      } else {
        resetScreen();
        var result = await Constants.navigatePush(
          ConnectionScreen(
            sdkType: Constants.zhBle,
            title: 'Bluetooth',
            fromMeasurement: true,
          ),
          context,
          rootNavigation: false,
        );
        if (result != null && result is bool && result) {
          connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
          Future.delayed(Duration(milliseconds: 250), () {
            startMeasurement(context: context, showTimer: showTimer);
          });
        }
      }
    } else {
      var result = await consentConfirmation();
      if (result != null && result is bool && result) {
        startMeasurement(
          context: context,
          showTimer: showTimer,
        );
      }
    }
  }

  /*Future onClickStart(BuildContext context, bool showInitTimer) async {
    if (true) {
      // isClosed = false;

      await connections.checkAndConnectDeviceIfNotConnected().then((value) async {
        connectedDevice = value;
        if (connectedDevice != null) {
          await statusCheckerForEcgFrozenOrNot();
          lastStartTime = DateTime.now();
          if (mounted) {
            setState(() {});
          }
        } else {
          if (mounted) {
            setState(() {});
          }
        }
        if (mounted) {
          setState(() {});
        }
      });
    } else {
      var result = await consentConfirmation();
      if (result != null && result is bool && result) {
        onClickStart(context, showInitTimer);
      }
    }
  }*/

  Widget layoutMain() {
    return ValueListenableBuilder(
      valueListenable: measurementType,
      builder: (context, value, child) {
        return Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          child: measurementType.value == 2 && Platform.isIOS
              ? HealthKitDataLayout(
                  sysList: sysList,
                  diaList: diaList,
                  hrList: hrList,
                  hrvList: hrvList,
                  ecgInfoModel: _ecgInfoModel.value,
                  lineChartWidgetForHr: lineChartWidgetForHr,
                  lineChartWidgetForBp: lineChartWidgetForBp,
                  lineChartWidgetForHrv: lineChartWidgetForHrv,
                  iosInfo: iosInfo,
                  ecgPointList: ecgPList.value,
                  valuesForEcgGraph: ecgGraphValue1,
                  ecgLength: ecgLength,
                  measurementType: measurementType,
                  zoomLevelECG: zoomLevelECG,
                  controllerForEcgGraph: controllerForEcgGraph,
                  setZoom: setZoom,
                )
              : dataLayout(),
        );
      },
    );
  }

  Widget dataLayout() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      shrinkWrap: true,
      children: <Widget>[
        ValueListenableBuilder(
          valueListenable: _ecgInfoModel,
          builder: (context, value, child) => measurementCard(),
        ),
        ecgCard(),
        ppgCard(),
        hrvCard(),
        SizedBox(
          height: 5.h,
        )
      ],
    );
  }

  Widget measurementCard() {
    var hr = '0';
    var bp = '0';
    var hrv = '0';
    if (_ecgInfoModel.value != null) {
      if (_ecgInfoModel.value!.approxHr != null) {
        hr = '${_ecgInfoModel.value!.approxHr}';
      }
      if (_ecgInfoModel.value!.approxSBP != null && _ecgInfoModel.value!.approxDBP != null) {
        bp = '${_ecgInfoModel.value!.approxSBP}/${_ecgInfoModel.value!.approxDBP}';
      }
      if (_ecgInfoModel.value!.approxHr != null) {
        hr = '${_ecgInfoModel.value!.approxHr}';
      }
      if (_ecgInfoModel.value!.hrv != null) {
        hrv = '${_ecgInfoModel.value!.hrv}';
        WatchSyncHelper().dashData.hrvFromLastMeasurement = num.parse(hrv.isNullOrEmpty ? '0' : hrv);
      }
    }
    return MeasurementCard(mAIDbp: mAIDbp.value, mAISbp: mAISbp.value, hr: hr, bp: bp, hrv: hrv);
  }

  Widget ecgCard() {
    return ValueListenableBuilder(
      valueListenable: ecgLength,
      builder: (BuildContext context, num value, Widget? child) {
        return ECGCard(
          ecgLength: ecgLength,
          valuesForEcgGraph: ecgGraphValue1,
          zoomLevelECG: zoomLevelECG,
          ecgPointList: ecgPList.value,
          measurementType: measurementType,
          controllerForEcgGraph: controllerForEcgGraph,
          setZoom: setZoom,
        );
      },
    );
  }

  _showBGDialog() async {
    showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                    elevation: 0,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(10.h),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                  : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: Offset(-5, -5),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#000000').withOpacity(0.75)
                                  : HexColor.fromHex('#384341').withOpacity(0.9),
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 27.h, horizontal: 22.w),
                        width: 309.w,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.bloodGlucose),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                                // maxLine: 1,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                // height: 49.h,
                                margin: EdgeInsets.only(top: 17.h),
                                decoration: BoxDecoration(
                                    color: isDarkMode(context)
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(10.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDarkMode(context)
                                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                            : Colors.white,
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                        offset: Offset(-5.w, -5.h),
                                      ),
                                      BoxShadow(
                                        color: isDarkMode(context)
                                            ? Colors.black.withOpacity(0.75)
                                            : HexColor.fromHex('#D1D9E6'),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                        offset: Offset(5.w, 5.h),
                                      ),
                                    ]),
                                child: Container(
                                  // height: 49.h,
                                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                    color: isDarkMode(context)
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller:
                                              TextEditingController(text: '${mBG1.value.toInt()}'),
                                          style: TextStyle(fontSize: 16.0),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: TextStyle(color: Colors.black)),
                                          onFieldSubmitted: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    child: TitleText(
                                      text: StringLocalization.of(context)
                                          .getText(StringLocalization.ok)
                                          .toUpperCase(),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor.fromHex('62CBC9'),
                                      // maxLine: 1,
                                    ),
                                  ),
                                ],
                              )
                            ])));
              });
            },
            barrierDismissible: true)
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });

    /*await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Body1AutoText(
            text: StringLocalization.of(context).getText(
                StringLocalization.hintForPassword),
            color: HexColor.fromHex("62CBC9"),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            minFontSize: 10,
            // maxLine: 1,
          ),
          content: Row(
            children: <Widget>[
              Expanded(
                child:  */ /*TextField(
                  controller: passwordController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color:  HexColor.fromHex("62CBC9")),
                      labelText: 'Enter Password'),
                ),*/ /*
                Container(
                  // height: 49.h,
                  margin: EdgeInsets.only(top: 17.h),
                  decoration: BoxDecoration(
                      color: isDarkMode(context)
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10.h),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode(context)
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5.w, -5.h),
                        ),
                        BoxShadow(
                          color: isDarkMode(context)
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5.w, 5.h),
                        ),
                      ]),
                  child: GestureDetector(
                    key: Key('passwordContainer'),
                    onTap: () {
                      errorPaswd = false;
                      passwordFocusNode.requestFocus();
                      openKeyboardUserId = false;
                      openKeyboardPasswd = true;
                      setState(() {});
                    },
                    child:
                    Container(
                      // height: 49.h,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      decoration: openKeyboardPasswd
                          ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.h)),
                          depression: 7,
                          colors: [
                            isDarkMode(context)
                                ? Colors.black.withOpacity(0.5)
                                : HexColor.fromHex('#D1D9E6'),
                            isDarkMode(context)
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                : Colors.white,
                          ])
                          : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        color: isDarkMode(context)
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'asset/lock_icon_red.png',
                          ),
                          SizedBox(width: 10.0.w),
                          Expanded(
                            child: IgnorePointer(
                              ignoring: openKeyboardPasswd ? false : true,
                              child:
                              TextFormField(
                                key: Key('password'),
                                autofocus: openKeyboardPasswd,
                                autovalidateMode: autoValidate,
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                style: TextStyle(fontSize: 16.0),
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: errorPaswd
                                        ? StringLocalization.of(context)
                                        .getText(StringLocalization.emptyPassword)
                                        : StringLocalization.of(context).getText(
                                        StringLocalization.hintForPassword),
                                    hintStyle: TextStyle(
                                        color: errorPaswd
                                            ? HexColor.fromHex('FF6259')
                                            : HexColor.fromHex('7F8D8C'))),
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return StringLocalization.of(context)
//                                  .getText(StringLocalization.emptyPassword);
//                            }
//                            return null;
//                          },
                                onFieldSubmitted: (value) {
                                  openKeyboardPasswd = false;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              !obscureText
                                  ? 'asset/view_icon_grn.png'
                                  : 'asset/view_off_icon_grn.png',
                              height: 25.h,
                              width: 25.w,
                            ),
                            onPressed: () {
                              obscureText = !obscureText;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[

          ],
        );
  });*/
  }

  Widget ppgCard() {
    setGraphColors();
    return ValueListenableBuilder(
      valueListenable: ppgLength,
      builder: (BuildContext context, int value, Widget? child) {
        return PPGCard(
          ppgLength: ppgLength,
          valuesForPpgGraph: ppgGraphValue1,
          zoomLevelPPG: zoomLevelPPG,
          measurementType: measurementType,
          setZoom: setZoom,
          ppgPointList: ppgPList.value,
          ecgPointList: ecgPList.value,
          controllerForPpgGraph: controllerForPpgGraph,
        );
      },
    );
  }

  ChartSeriesController? _controller;

  Widget hrvCard() {
    /*return ValueListenableBuilder(
      valueListenable: hrvLength,
      builder: (BuildContext context, value, Widget? child) {
        return HRVCard(
          hrvLength: hrvLength,
          hrvGraphValues: hrvGraphValues,
          zoomLevelHRV: zoomLevelHRV,
          hrvPointList: hrvPointList.value,
          setZoom: setZoom,
          // setController: (controller) {
          //   controller.animate();
          //   // _controller ??= controller;
          //   // if(_controller!=null){
          //   //   _controller?.animate();
          //   // }
          // },
        );
      },
    );*/

    return Container(
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : HexColor.fromHex('#FFFFFF'),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4, -4),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#000000').withOpacity(0.75)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ]),
      height: 150.h,
      child: Column(
        children: <Widget>[
          Container(
            height: 25.h,
            margin: EdgeInsets.only(top: 10.h),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Body1AutoText(
                    text: StringLocalization.of(context).getText(StringLocalization.hrv),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: hrvGraphValues,
            builder: (BuildContext context, List<fl_charts.FlSpot> hrvValues, Widget? child) {
              if (hrvValues.isEmpty) {
                return Container(
                  height: 110.h,
                  child: Center(
                    child: SizedBox(
                      height: 30.h,
                      child: Body1AutoText(
                        text:
                            stringLocalization.getText(StringLocalization.ppgNoChartDataAvailable),
                        maxLine: 1,
                      ),
                    ),
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                height: 110.h,
                width: MediaQuery.of(context).size.width - 13.w,
                padding: EdgeInsets.only(left: 5.0, right: 15.0),
                child: fl_charts.LineChart(
                  fl_charts.LineChartData(
                    titlesData: fl_charts.FlTitlesData(
                      leftTitles: fl_charts.SideTitles(
                        interval: 25,
                        showTitles: true,
                        getTextStyles: (value) {
                          return TextStyle(
                            fontSize: 8.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          );
                        },
                      ),
                      bottomTitles: fl_charts.SideTitles(
                        interval: 5,
                        showTitles: true,
                        getTextStyles: (value) {
                          return TextStyle(
                            fontSize: 8.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          );
                        },
                      ),
                    ),
                    borderData: fl_charts.FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black12, width: 0.5),
                    ),
                    gridData: fl_charts.FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 25,
                      verticalInterval: 2.5,
                      getDrawingHorizontalLine: (value) {
                        return fl_charts.FlLine(
                            color: Colors.black12,
                            strokeWidth: 0.25); // Set the color of horizontal grid lines
                      },
                      getDrawingVerticalLine: (value) {
                        return fl_charts.FlLine(
                            color: Colors.black12,
                            strokeWidth: 0.25); // Set the color of vertical grid lines
                      },
                    ),
                    maxX: 50,
                    maxY: 75,
                    clipData: fl_charts.FlClipData(
                      top: true,
                      right: true,
                      left: true,
                      bottom: true,
                    ),
                    minY: 0,
                    minX: hrvGraphValues.value.first.x,
                    axisTitleData: fl_charts.FlAxisTitleData(
                        bottomTitle: fl_charts.AxisTitle(
                            showTitle: true,
                            titleText: 'Seconds(Measurement)',
                            textStyle: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 12.0))),
                    lineBarsData: [
                      fl_charts.LineChartBarData(
                        spots: hrvGraphValues.value,
                        isCurved: true,
                        colors: [Colors.blue],
                        dotData: fl_charts.FlDotData(show: false),
                        isStrokeCapRound: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> showCalibrationDialog(
      {required GestureTapCallback onClickOk,
      required bool isOs,
      required bool isTrng,
      bool useRootNavigator = true}) async {
    var result = await showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) {
        return ShowCalibrationDialog(
          uploadDatatoServerOnCancel,
          navigateToTagScreen,
          uploadDataInServer,
          errorMessageForHeart,
          isCalibration,
          isCanceled.value,
          hrCalibrationTextEditController,
          isSavedFromOscillometric,
          sbpCalibrationTextEditController,
          writingNotes,
          errorMessageForDBP,
          dbpCalibrationTextEditController,
          errorMessageForSBP,
          openKeyboardDbp,
          openKeyboardSbp,
          openKeyboardHr,
          onClickOk,
          isOs,
          isTrng,
          getCallibrationDataFromHealthKit,
        );
      },
      barrierDismissible: false,
    );
    return result;
  }

  void setE66CalibrationValue(int index) {
    if (index == 0) {
      valueListenableForCalibration.value = StringLocalization.normalCalibration;
    } else if (index == 1) {
      valueListenableForCalibration.value = StringLocalization.lowCalibration;
    } else if (index == 2) {
      valueListenableForCalibration.value = StringLocalization.highCalibration;
    } else if (index == 3) {
      valueListenableForCalibration.value = StringLocalization.highCalibration;
    } else if (index == 4) {
      valueListenableForCalibration.value = StringLocalization.highHyperCalibration;
    }
  }

  void initGraphControllers() {
    xValueFormatter = XValueFormatter(controllerForEcgGraph, connectedDevice: connectedDevice);
    xValueFormatterPPG = XValueFormatter(controllerForEcgGraph, connectedDevice: connectedDevice);
    var desc = Description()..enabled = false;
    controllerForEcgGraph = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..textColor = (Colors.transparent);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..textColor = (Colors.transparent);
      },
      legendSettingFunction: (legend, controller) {
        legend.enabled = (false);
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..setLabelCount2(4, true)
          ..axisValueFormatter = xValueFormatter;
      },
      drawGridBackground: false,
      gridBackColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      dragXEnabled: true,
      dragYEnabled: false,
      scaleXEnabled: true,
      scaleYEnabled: false,
      description: desc,
      infoTextSize: 16.sp,
      pinchZoomEnabled: false,
      doubleTapToZoomEnabled: false,
      noDataText: '',
      highlightPerDragEnabled: false,
      highLightPerTapEnabled: false,
      infoTextColor: Colors.transparent,
    );
    controllerForPpgGraph = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..textColor = (Colors.transparent);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..enabled = false
          ..textColor = (Colors.transparent);
      },
      legendSettingFunction: (legend, controller) {
        legend.enabled = (false);
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..drawGridLines = (false)
          ..drawAxisLine = (false)
          ..setLabelCount2(4, true)
          ..axisValueFormatter = xValueFormatterPPG;
      },
      drawGridBackground: false,
      dragXEnabled: true,
      dragYEnabled: false,
      scaleXEnabled: true,
      scaleYEnabled: false,
      description: desc,
      infoTextSize: 16.sp,
      noDataText: '',
      pinchZoomEnabled: false,
      doubleTapToZoomEnabled: false,
      highlightPerDragEnabled: false,
      highLightPerTapEnabled: false,
      infoTextColor: Colors.transparent,
    );
  }

  void setGraphColors() {
    controllerForEcgGraph?.axisLeft?.enabled = false;
    controllerForEcgGraph?.axisRight?.enabled = false;
    controllerForEcgGraph?.xAxis?.textColor = Colors.transparent;
    controllerForEcgGraph?.infoBgColor = Colors.transparent;
    controllerForEcgGraph?.backgroundColor = Colors.transparent;
    controllerForEcgGraph?.highLightPerTapEnabled = false;

    controllerForPpgGraph?.axisLeft?.enabled = false;
    controllerForPpgGraph?.axisRight?.enabled = false;
    controllerForPpgGraph?.xAxis?.textColor = Colors.transparent;
    controllerForPpgGraph?.infoBgColor = Colors.transparent;
    controllerForPpgGraph?.backgroundColor = Colors.transparent;
    controllerForPpgGraph?.highLightPerTapEnabled = false;
  }

  void setDataToPpgGraph() {
    if (controllerForPpgGraph != null) {
      var ppgDataSet = LineDataSet(ppgGraphValue1.value, 'PpgDataSet 1');
      ppgDataSet.setColor1(HexColor.fromHex('#9F2DBC'));
      ppgDataSet.setLineWidth(2);
      ppgDataSet.setDrawValues(false);
      ppgDataSet.setDrawCircles(false);
      ppgDataSet.setMode(Mode.LINEAR);
      ppgDataSet.setDrawFilled(false);

      try {
        if (ppgDataSet.values == null) {
          ppgDataSet.setValues(ppgGraphValue1.value);
        }
      } catch (e) {
        debugPrint('Error $e');
        LoggingService().warning('Measurement', 'Exception ', error: e);
      }

      setGraphColors();

      controllerForPpgGraph?.data = LineData.fromList([ppgDataSet]);
    }
  }

  void setDataToEcgGraph() {
    var ecgDataSet1 = LineDataSet(ecgGraphValue2.value, 'EcgDataSet 2');

    ecgDataSet1.setColor1(Colors.red);
    ecgDataSet1.setLineWidth(1);
    ecgDataSet1.setDrawValues(false);
    ecgDataSet1.setDrawCircles(true);
    ecgDataSet1.setCircleSize(2);
    ecgDataSet1.setCircleColor(Colors.red);
    ecgDataSet1.setMode(Mode.LINEAR);
    ecgDataSet1.setDrawFilled(false);

    ecgDataSet = LineDataSet(ecgGraphValue1.value, 'EcgDataSet 1');

    ecgDataSet!.setColor1(HexColor.fromHex('ff6159'));
    ecgDataSet!.setLineWidth(2);
    ecgDataSet!.setDrawValues(false);
    ecgDataSet!.setDrawCircles(false);
    ecgDataSet!.setMode(Mode.LINEAR);
    ecgDataSet!.setDrawFilled(false);

    try {
      if (ecgDataSet!.values == null) {
        ecgDataSet!.setValues(ecgGraphValue1.value);
      }
      if (ecgDataSet1.values == null) {
        ecgDataSet!.setValues(ecgGraphValue2.value);
      }
    } catch (e) {
      debugPrint('Error $e');
      LoggingService().warning('Measurement', 'Exception ', error: e);
    }

    setGraphColors();

    controllerForEcgGraph?.data = LineData.fromList([]..addAll([ecgDataSet!]));
  }

  Future<void> checkAndEndMeasurement() async {
    var isMeasurementOver = false;
    if (connectedDevice?.sdkType == Constants.e66) {
      if (mTimer.value != null) {
        isMeasurementOver = (mTimer.value?.tick ?? 0) > measurementTime.value && isMRunning.value;
      }
    } else if (connectedDevice?.sdkType == Constants.zhBle) {
      if (mTimer.value != null) {
        isMeasurementOver = (mTimer.value?.tick ?? 0) > 30 && isMRunning.value;
      }
    }

    if (isMeasurementOver && !isMFailed.value) {
      bool? isStopped;
      unawaited(
        connections.stopMeasurement().then(
          (value) {
            isStopped = value;
          },
        ),
      );

      isMRunning.value = false;
      isLeadOff.value = false;
      unawaited(Wakelock.disable());

      ecgListFromGraph.value = ecgGraphValue1.value.map((e) => e.y ?? 0.0).toList();
      ppgListFromGraph.value = ppgGraphValue1.value.map((e) => e.y ?? 0.0).toList();

      var isCorruptedData = false;
      try {
        if (ecgEndTime.value > 0 && ppgEndTime.value > 0) {
          var diff = DateTime.fromMillisecondsSinceEpoch(ecgEndTime.value.toInt())
              .difference(DateTime.fromMillisecondsSinceEpoch(ppgEndTime.value.toInt()))
              .inSeconds;
          isCorruptedData = isCurruptData(diff);
        }
      } catch (e) {
        debugPrint('Exception at checkAndEndMeasurement $e');
        LoggingService().warning('Measurement', 'Exception at checkAndEndMeasurement ', error: e);
      }

      Future.delayed(Duration(seconds: 1)).then(
        (value) async {
          print('isCorruptedData :: $isCorruptedData');
          if (isCorruptedData) {
            wrongMeasurement().then((send) {
              if (send != null && send) {
                stopMeasurement();
                debugPrint('start');
              }
            });
          } else {
            var sbp = 0;
            var dbp = 0;
            postMeasurementData(aiSBP: sbp, aiDBP: dbp);
          }
        },
      );
    }
  }

  bool isCurruptData(int diff) {
    if (connectedDevice?.sdkType == Constants.zhBle) {
      offLeadCount.value = (offLeadCount.value / 125).round();
    }

    return (offLeadCount.value > 10 || (ecgPList.value.isEmpty && ppgPList.value.isEmpty));
  }

  void setDefaultMeasurementForHistory() {
    if (controllerForEcgGraph == null) {
      initGraphControllers();
    }
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      if (widget.measurementHistoryModel != null) {
        ppgPList.value =
            (widget.measurementHistoryModel?.ppg ?? []).map((e) => num.parse(e).toInt()).toList();
        ecgPList.value =
            (widget.measurementHistoryModel?.ecg ?? []).map((e) => num.parse(e).toInt()).toList();
        var ppgList = widget.measurementHistoryModel?.ppg ?? [];
        var ecgList = widget.measurementHistoryModel?.ecg ?? [];

        for (var i = 0; i < ppgList.length; i++) {
          print('ppg_dataList_data  ${ppgList[i]}');
          ppgXValue.value = i + 0.0;
          var entry = Entry(
            x: ppgXValue.value,
            y: double.tryParse(ppgList[i]),
          );
          ppgGraphValue1.value.add(entry);
        }
        for (var i = 0; i < ecgList.length; i++) {
          ecgXValue.value = i + 0.0;

          var entry = Entry(
            x: ecgXValue.value,
            y: double.tryParse(ecgList[i]),
          );
          ecgGraphValue1.value.add(entry);
        }

        setDataToPpgGraph();
        try {
          controllerForPpgGraph?.setVisibleXRangeMaximum(500);
          controllerForPpgGraph?.moveViewToX(ppgXValue.value - 700);
        } catch (e) {
          debugPrint('Exception at measurement screen $e');
          LoggingService().warning('Measurement', 'Exception at measurement screen ', error: e);
        }

        setDataToEcgGraph();
        try {
          controllerForEcgGraph?.setVisibleXRangeMaximum(500);
          controllerForEcgGraph?.moveViewToX(ecgXValue.value - 700);
        } catch (e) {
          debugPrint('Exception at measurement screen $e');
          LoggingService().warning('Measurement', 'Exception at measurement screen ', error: e);
        }

        setGraphColors();

        _ecgInfoModel.value = EcgInfoReadingModel();
        _ecgInfoModel.value!.hrv = widget.measurementHistoryModel?.hrv ?? 0;
        _ecgInfoModel.value!.approxHr = widget.measurementHistoryModel?.hr ?? 0;
        _ecgInfoModel.value!.approxSBP = widget.measurementHistoryModel?.sbp ?? 0;
        _ecgInfoModel.value!.approxDBP = widget.measurementHistoryModel?.dbp ?? 0;
        mAISbp.value = widget.measurementHistoryModel?.aiSBP?.toDouble() ?? 0;
        mAIDbp.value = widget.measurementHistoryModel?.aiDbp?.toDouble() ?? 0;
        mBG1.value = widget.measurementHistoryModel?.BG?.toDouble() ?? 0;
        mBG2.value = widget.measurementHistoryModel?.BG1?.toDouble() ?? 0;
        mBGUnit1.value = widget.measurementHistoryModel?.Unit.toString() ?? '';
        mBGUnit2.value = widget.measurementHistoryModel?.Unit1.toString() ?? '';
        mBGClass.value = widget.measurementHistoryModel?.Class.toString() ?? '';
        mUncertainty.value = widget.measurementHistoryModel?.Uncertainty?.toDouble() ?? 0;
        _ecgInfoModel.value!.ecgPointY =
            double.tryParse(widget.measurementHistoryModel?.ecg?.last ?? '') ?? 0;

        ppgInfoModel = PpgInfoReadingModel();
        ppgInfoModel!.point = double.tryParse(widget.measurementHistoryModel?.ppg?.last ?? '') ?? 0;

        if (mounted) {
          setState(() {});
        }

        Future.delayed(Duration(milliseconds: 500)).then((_) {
          setZoom(1);
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  void setZoom(int zoomX, {bool? zoomBtn, int? fromType}) {
    var isE66 = connectedDevice?.sdkType == Constants.e66;
    try {
      fromType ??= -1;
      num zoom = (isE66 ? 200 : 500);
      if (zoomX <= 0) {
        zoom = (isE66 ? 200 : 500);
        if (fromType == 1) {
          xValueFormatterPPG?.zoomLevel = 0;
        } else if (fromType == 0) {
          xValueFormatter?.zoomLevel = 0;
        } else {
          xValueFormatterPPG?.zoomLevel = 0;
          xValueFormatter?.zoomLevel = 0;
        }
      } else {
        zoom = ((isE66 ? 200 : 500) / zoomX).toDouble();
        if (fromType == 1) {
          xValueFormatterPPG?.zoomLevel = zoomX;
        } else if (fromType == 0) {
          xValueFormatter?.zoomLevel = zoomX;
        } else {
          xValueFormatterPPG?.zoomLevel = 0;
          xValueFormatter?.zoomLevel = 0;
        }
      }

      if (controllerForPpgGraph != null) {
        if (fromType == 1) {
          controllerForPpgGraph?.setVisibleXRangeMaximum(zoom.toDouble());
          controllerForPpgGraph?.setVisibleXRangeMinimum(zoom.toDouble());
        } else {
          controllerForPpgGraph?.setVisibleXRangeMaximum((isE66 ? 200 : 500));
          controllerForPpgGraph?.setVisibleXRangeMinimum((isE66 ? 200 : 500));
        }
        if (zoomBtn == null || !zoomBtn) {
          controllerForPpgGraph?.moveViewToX(ppgXValue.value);
        }
        controllerForPpgGraph?.axisLeft!.enabled = true;
      }
      if (controllerForEcgGraph != null) {
        if (fromType == 0) {
          controllerForEcgGraph!.setVisibleXRangeMaximum(zoom.toDouble());
          controllerForEcgGraph!.setVisibleXRangeMinimum(zoom.toDouble());
        } else {
          controllerForEcgGraph!.setVisibleXRangeMaximum((isE66 ? 200 : 200));
          controllerForEcgGraph!.setVisibleXRangeMinimum((isE66 ? 200 : 200));
        }
        controllerForEcgGraph!.moveViewToX(ecgXValue.value);
        controllerForEcgGraph!.axisLeft!.enabled = false;
      }
    } catch (e) {
      debugPrint('Exception in zoom method $e');
      LoggingService().warning('Measurement', 'Exception in zoom method', error: e);
    }
  }

  bool get isOSM => preferences?.getBool(Constants.isOscillometricEnableKey) ?? false;

  bool get isEST => preferences?.getBool(Constants.isEstimatingEnableKey) ?? false;

  Future postMeasurementData({required int aiSBP, required int aiDBP}) async {
    try {
      print('HRV Points from PPG Points =============================');
      log.log('HRV : ${hrvGraphValues.value}');
      var maxHRVTime = hrvGraphValues.value
          .map((e) => e.y)
          .toList()
          .reduce((max, current) => max > current ? max : current)
          .toInt();
      var minHRVTime = hrvGraphValues.value
          .where((element) => element.y > 10)
          .toList()
          .map((e) => e.y)
          .toList()
          .reduce((min, current) => min < current ? min : current)
          .toInt();
      if (preferences == null) {
        await getPreferences();
      }
      if (isOSM) {
        var isTraining = await trainingConfirmation();
        if (isTraining) {
          preferences!.setBool(Constants.isTrainingEnableKey, true);
          preferences!.setBool(Constants.isTrainingEnableKey1, true);
          Future.delayed(Duration(milliseconds: 100), () async {
            clearTextFormFields();
            var result = await showCalibrationDialog(
              isOs: true,
              isTrng: true,
              onClickOk: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
            );
            if (result) {
              isOscillometricOn.value = true;
              isSavedFromOscillometric.value = true;
              await uploadDataInServer(
                aiDBP,
                aiSBP,
                minHRV: minHRVTime,
                maxHRV: maxHRVTime,
              );
            } else {
              await uploadDataInServer(
                aiDBP,
                aiSBP,
                minHRV: minHRVTime,
                maxHRV: maxHRVTime,
              );
            }
          });
        } else {
          preferences!.setBool(Constants.isTrainingEnableKey, false);
          preferences!.setBool(Constants.isTrainingEnableKey1, false);
          await uploadDataInServer(
            aiDBP,
            aiSBP,
            minHRV: minHRVTime,
            maxHRV: maxHRVTime,
          );
        }
      } else {
        preferences!.setBool(Constants.isTrainingEnableKey, false);
        preferences!.setBool(Constants.isTrainingEnableKey1, false);
        isOscillometricOn.value = false;
        isSavedFromOscillometric.value = false;
        uploadDataInServer(
          aiDBP,
          aiSBP,
          maxHRV: maxHRVTime,
          minHRV: minHRVTime,
        );
      }
      /*checkAndShowCalibrationDialog(entry, aiSBP, aiDBP,
          minHRVTime: minHRVTime, maxHRVTime: maxHRVTime);*/
    } catch (e) {
      debugPrint('Exception at measurement screen $e');
      LoggingService().warning('Measurement', 'Exception at measurement screen', error: e);
    }
  }

/*
  List<int> identifyPeaks(List<int> ppgPoints) {
    // This is a placeholder implementation; you need to implement peak detection
    // For simplicity, let's assume that peaks occur whenever the PPG value is above a certain threshold
    int threshold = 0; // You may need to adjust this threshold based on your data
    List<int> peakIndices = [];

    for (int i = 1; i < ppgPoints.length - 1; i++) {
      if (ppgPoints[i] > threshold && ppgPoints[i] > ppgPoints[i - 1] && ppgPoints[i] > ppgPoints[i + 1]) {
        peakIndices.add(i);
      }
    }

    return peakIndices;
  }

  List<int> calculateRRIntervals(List<int> peakIndices) {
    List<int> rrIntervals = [];

    for (int i = 1; i < peakIndices.length; i++) {
      int rrInterval = peakIndices[i] - peakIndices[i - 1];
      rrIntervals.add(rrInterval);
    }

    return rrIntervals;
  }

  double findMaxHRV(List<int> rrIntervals) {
    double maxHRV = double.negativeInfinity;

    for (int i = 1; i < rrIntervals.length; i++) {
      double hrv = calculateRMSSD(rrIntervals.sublist(0, i + 1));
      maxHRV = max(maxHRV, hrv);
    }

    return maxHRV;
  }

  double findMinHRV(List<int> rrIntervals) {
    double minHRV = double.infinity;

    for (int i = 1; i < rrIntervals.length; i++) {
      double hrv = calculateRMSSD(rrIntervals.sublist(0, i + 1));
      minHRV = min(minHRV, hrv);
    }

    return minHRV;
  }

  Map calculateHRV(List<int> ppgPoints) {
    try {
      var windowSize = ppgPoints.length; // Start with the full length of PPG data
      var maxHRV = 0.0;
      var minHRV = 0.0;

      var peakIndices = identifyPeaks(ppgPoints);
      var rrIntervals = calculateRRIntervals(peakIndices);
      maxHRV = findMaxHRV(rrIntervals);
      minHRV = findMinHRV(rrIntervals);

      */ /*while (windowSize >= 5) {
        var rrIntervals = calculateRRIntervals(ppgPoints, windowSize);
        var rmssd = calculateRMSSD(rrIntervals);
        print('HRVResult :: rmssd :: $rmssd');
        // Update maxHRV if the current RMSSD is greater
        maxHRV = math.max(maxHRV, rmssd);
        if(minHRV > 0 && rmssd > 0){
          minHRV = math.min(minHRV, rmssd);
        }

        // Decrease the window size for the next iteration
        windowSize -= 5;
      }*/ /*

      return {'max': maxHRV, 'min': minHRV};
    } catch (e) {
      print(e);
    }
    return {'max': 0.0, 'min': 0.0};
  }

  */ /*List<int> calculateRRIntervals(List<int> ppgPoints, int windowSize) {
    try {
      var rrIntervals = <int>[];
      for (var i = windowSize; i < ppgPoints.length; i++) {
        var rrInterval = ppgPoints[i] - ppgPoints[i - windowSize];
        rrIntervals.add(rrInterval);
      }
      return rrIntervals;
    } catch (e) {
      print('calculateRRIntervals $e');
    }
    return [];
  }*/ /*

  double calculateRMSSD(List<int> rrIntervals) {
    // Calculate RMSSD (Root Mean Square of Successive Differences)
    var rmssd = sqrt(
        rrIntervals.map((rr) => pow(rr, 2)).reduce((a, b) => a + b) / (rrIntervals.length - 1));

    return rmssd;
  }*/

  bool isCalibrationOn() {
    var isHrNotEmpty = hrCalibrationTextEditController.text.trim().isNotEmpty;
    var isSbpNotEmpty = sbpCalibrationTextEditController.text.trim().isNotEmpty;
    var isDbpNotEmpty = dbpCalibrationTextEditController.text.trim().isNotEmpty;
    print('isCalibrationOn :: $isHrNotEmpty :: $isSbpNotEmpty :: $isDbpNotEmpty');
    return isHrNotEmpty && isSbpNotEmpty && isDbpNotEmpty;
  }

  void clearTextFormFields() {
    hrCalibrationTextEditController.text = '';
    sbpCalibrationTextEditController.text = '';
    dbpCalibrationTextEditController.text = '';
  }

  Future consentConfirmation() async {
    var dialog = CustomDialog(
      title: 'Please confirm',
      subTitle: 'Please read and accept terms and conditions before taking a measurement',
      maxLine: 10,
      onClickNo: () async {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
      onClickYes: () async {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    var result = await showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );

    return result;
  }

  Future trainingConfirmation() async {
    var dialog = CustomDialog(
      title: 'Please confirm',
      subTitle:
          'Please indicate if this data is intended for training and data collection purposes',
      secondaryButton: 'No',
      maxLine: 10,
      onClickNo: () async {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
      onClickYes: () async {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    var result = await showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );

    return result;
  }

  Future tagConfirmation() async {
    var dialog = CustomDialog(
      title: 'Please confirm',
      subTitle: 'Please indicate if you want to add TAG to this measurement.',
      maxLine: 10,
      onClickNo: () async {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
      onClickYes: () async {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    var result = await showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );

    return result;
  }

  Future firstConfirmationDialogAfterMeasurementDone(int aiSBP, int aiDBP,
      {int minHRV = 0, int maxHRV = 0}) async {
    var dialog = CustomDialog(
      title: 'Please confirm',
      subTitle: 'The data is coming from the Oscillometric device',
      secondaryButton: 'NO',
      maxLine: 10,
      onClickYes: () async {
        isOscillometricOn.value = true;
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        isSavedFromOscillometric.value = true;
        await uploadDataInServer(
          aiDBP,
          aiSBP,
          minHRV: minHRV,
          maxHRV: maxHRV,
        );
      },
      onClickNo: () async {
        isSavedFromOscillometric.value = false;
        isOscillometricOn.value = false;
        hrCalibrationTextEditController.text = '';
        sbpCalibrationTextEditController.text = '';
        dbpCalibrationTextEditController.text = '';

        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          secondConfirmationDialogAfterMeasurementDone(
            aiSBP,
            aiDBP,
            minHRV: minHRV,
            maxHRV: maxHRV,
          );
        }
      },
    );
    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );
  }

  Future secondConfirmationDialogAfterMeasurementDone(
    int aiSBP,
    int aiDBP, {
    int minHRV = 0,
    int maxHRV = 0,
  }) async {
    var isTrainingEnable = preferences!.getBool(Constants.isTrainingEnableKey) ?? false;
    var isOscillometric = preferences!.getBool(Constants.isOscillometricEnableKey) ?? false;

    var dialog1 = CustomDialog(
      subTitle: 'You want to enter data from the Oscillometric device',
      secondaryButton: 'NO',
      maxLine: 10,
      onClickNo: () async {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          await uploadDataInServer(aiDBP, aiSBP, minHRV: minHRV, maxHRV: maxHRV);
        }
      },
      onClickYes: () {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        showCalibrationDialog(
          isOs: isOscillometric,
          isTrng: isTrainingEnable,
          onClickOk: () {
            if (mounted) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            firstConfirmationDialogAfterMeasurementDone(
              aiSBP,
              aiDBP,
              minHRV: minHRV,
              maxHRV: maxHRV,
            );
          },
        );
      },
    );
    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog1;
      },
    );
  }

  Future<void> getMemory(int? length) async {
    String? data;
    if (Platform.isAndroid) {
      data = await connections.getMemoryData();
    }
    LoggingService().info(
        'Current Measurement Status', 'got ${length ?? 0} points, memory: ${data ?? 'unknown'} ');
  }

  Future uploadDatatoServerOnCancel() {
    var aiSBP = widget.measurementHistoryModel?.aiSBP?.toInt() ?? 0;
    var aiDBP = widget.measurementHistoryModel?.aiDbp?.toInt() ?? 0;
    uploadDataInServer(aiDBP, aiSBP);
    return Future.value();
  }

  Map<String, dynamic> mapData(
      int aiDBP,
      int aiSBP,
      int sbp,
      int dbp,
      int hr,
      bool isAISelected,
      bool IsResearcher,
      bool isTrainingEnable,
      bool isOscillometric,
      int device_hr,
      int device_sbp,
      int device_dbp,
      int device_hrv,
      int minHRV,
      int maxHRV) {
    var map = <String, dynamic>{
      'birthdate': '',
      'data': [
        {
          'bg_manual': 0,
          'demographics': {
            'age': calculateAge(globalUser?.dateOfBirth ?? DateTime.now()),
            'gender': globalUser?.gender ?? '',
            'height': calculateHeight(globalUser?.height ?? ''),
            'weight': calculateWeight(double.tryParse(globalUser?.weight ?? '') ?? 0)
          },
          'device_id': '',
          'device_type': connectedDevice?.sdkType == Constants.zhBle ? 'E08' : 'E80',
          'dias_healthgauge': aiDBP,
          'o2_manual': 0,
          'schema': '',
          'sys_healthgauge': aiSBP,
          'username': '',
          'model_id': 'PROTO_1',
          'isAISelected': isAISelected,
          'IsResearcher': true,
          'userID': userId,
          'filteredEcgPoints': ecgPList.value,
          'filteredPpgPoints': ppgFilterList.value,
          'raw_times': [],
          'hrv_device': device_hrv,
          'dias_device': device_dbp,
          'hr_device': device_hr,
          'sys_device': device_sbp,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'sys_manual': sbp,
          'dias_manual': dbp,
          'hr_manual': hr,
          'ecg_elapsed_time': [tsOnClickStart.value, ecgStartTime.value, tsAvgPointECG.value],
          'ppg_elapsed_time': [tsOnClickStart.value, ppgStartTime.value, tsAvgPointPPG.value],
          'zero_ecg': ecgListFromGraph.value,
          'zero_ppg': ppgListFromGraph.value,
          'IsCalibration': false,
          'isForHourlyHR': false,
          'isForTimeBasedPpg': false,
          'isForTraining': isTrainingEnable,
          'isForOscillometric': isOscillometric,
          'IsFromCamera': false,
          'isSavedFromOscillometric': isSavedFromOscillometric.value,
          'raw_ecg': ecgPList.value,
          'raw_ppg': ppgPList.value,
          'raw_hrv': hrvPointList.value,
          'hrv_elapsed_time': [ecgStartTime.value, ecgEndTime.value],
          if (minHRV > 0) 'min_hrv_time': minHRV,
          if (maxHRV > 0) 'max_hrv_time': maxHRV,
          if (hrvGraphValues.value.isNotEmpty)
            'graph_hrv_x': hrvGraphValues.value.map((e) => e.x).toList(),
          if (hrvGraphValues.value.isNotEmpty)
            'graph_hrv_y': hrvGraphValues.value.map((e) => e.y).toList(),
          'AISys': num.parse(sys_Prediction).toInt(),
          'AIDias': num.parse(dias_Prediction).toInt()
        }
      ]
    };
    return map;
  }

  Future uploadDataInServer(int aiDBP, int aiSBP, {int maxHRV = 0, int minHRV = 0}) async {
    sys_Prediction = '0';
    dias_Prediction = '0';
    var hr = int.tryParse(hrCalibrationTextEditController.text) ?? 0;
    var sbp = int.tryParse(sbpCalibrationTextEditController.text) ?? 0;
    var dbp = int.tryParse(dbpCalibrationTextEditController.text) ?? 0;
    var strEcg = ecgPList.value.join(',');
    var strPpg = ppgPList.value.join(',');
    print('LengthCheck ECG :: ${ecgPList.value.length}');
    print('LengthCheck PPG :: ${ppgPList.value.length}');
    // var isTflData = preferences?.getBool(Constants.isTFLSelected) ?? false;
    // if (isTflData) {
    //   preferences?.setBool(Constants.isGlucoseData, false);
    // } else {
    //   var isTrainingEnable = preferences!.getBool(Constants.isTrainingEnableKey1) ?? false;
    //   var isOscillometric = preferences!.getBool(Constants.isOscillometricEnableKey) ?? false;
    //   var isEstimate = preferences!.getBool(Constants.isEstimatingEnableKey) ?? false;
    //   var isGlucoseData = preferences?.getBool(Constants.isGlucoseData1) ?? false;
    //   preferences?.setBool(Constants.isTrainingEnableKey, isTrainingEnable);
    //   preferences?.setBool(Constants.isOscillometricEnableKey, isOscillometric);
    //   preferences?.setBool(Constants.isGlucoseData, isGlucoseData);
    //   preferences?.setBool(Constants.isEstimatingEnableKey, isEstimate);
    // }
    var isTrainingEnable = preferences!.getBool(Constants.isTrainingEnableKey) ?? false;
    var isOscillometric = preferences!.getBool(Constants.isOscillometricEnableKey) ?? false;
    var isEstimate = preferences!.getBool(Constants.isEstimatingEnableKey) ?? false;
    var cancelToken = cancel_http.CancellationToken();
    var isResearcher = globalUser!.isResearcherProfile ?? false;
    OverlayEntry? entry;
    var deviceHr = _ecgInfoModel.value?.approxHr ?? 0;
    var deviceSbp = _ecgInfoModel.value?.approxSBP ?? 0;
    var deviceDbp = _ecgInfoModel.value?.approxDBP ?? 0;
    var deviceHrv = _ecgInfoModel.value?.hrv ?? 0;

    var isInternet = await Constants.isInternetAvailable();
    var estimateFlag = 0;
    if (!isTflSelected.value && !isAISelected.value) {
      showEstimationResult(
        IsResearcher: isResearcher,
        isTflData: false,
        SBP: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxSBP,
        DBP: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxDBP,
        HR: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxHr,
        result: {},
      );
      WatchSyncHelper().dashData.sys =  num.parse(_ecgInfoModel.value == null ? '0' : _ecgInfoModel.value!.approxSBP.toString());
      WatchSyncHelper().dashData.dia =  num.parse(_ecgInfoModel.value == null ? '0' : _ecgInfoModel.value!.approxDBP.toString());
      WatchSyncHelper().dashData.hr =  num.parse(_ecgInfoModel.value == null ? '0' : _ecgInfoModel.value!.approxHr.toString());

    } else if (isTflSelected.value) {
      estimateFlag = 1;
      var result = await loadingDialog(cancelToken, true);
      if (result != null) {
        if (sys_Prediction.trim().isNotEmpty || dias_Prediction.trim().isNotEmpty) {
          mAISbp.value = num.parse(sys_Prediction).toDouble();
          mAIDbp.value = num.parse(dias_Prediction).toDouble();
        }
        WatchSyncHelper().dashData.sys =  num.parse(sys_Prediction).toInt();
        WatchSyncHelper().dashData.dia =  num.parse(dias_Prediction).toInt();
        WatchSyncHelper().dashData.hr =  _ecgInfoModel.value?.approxHr ?? 0;


        showEstimationResult(
          SBP: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxSBP,
          DBP: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxDBP,
          HR: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxHr,
          result: {
            'ID': 0,
            'Sys': 0,
            'Sys Predication': sys_Prediction ?? '',
            'Dias Predication': dias_Prediction ?? '',
            'Dia': 0,
            'BG': 0,
            'BG1': 0,
            'Unit': '',
            'Unit1': '',
            'Class': '',
            'min_hrv_time': minHRV,
            'max_hrv_time': maxHRV,
          },
          isOs: isOscillometric,
          IsResearcher: isResearcher,
          isTflData: isTflSelected.value,
          // onOkClick: () async {
          //   var isMTagging = preferences?.getBool(Constants.prefMTagging) ?? false;
          //   if (isMTagging) {
          //     var result = await tagConfirmation();
          //     if (result != null && result is bool && result) {
          //       navigateToTagScreen();
          //     }
          //   }
          // },
        );
      } else {
        return;
      }
    } else {
      estimateFlag = 2;
      loadingDialog(cancelToken, false);
    }
    var recordId = await saveMeasurementDataToLocalStorage(
      trainingHr: hr,
      trainingDBP: dbp,
      trainingSBP: sbp,
      isCalibration: isCalibration,
      isSync: false,
      deviceSbp: deviceSbp,
      deviceDbp: deviceDbp,
      deviceHr: deviceHr,
      deviceHrv: deviceHrv,
      strEcgList: strEcg,
      strPpgList: strPpg,
      aiSBP: mAISbp.value.toInt(),
      aiDBP: mAIDbp.value.toInt(),
      BG: mBG1.value.toInt(),
      Uncertainty: mUncertainty.value.toInt(),
      BG1: mBG2.value.toInt(),
      BGUnit: mBGUnit1.value,
      BGUnit1: mBGUnit2.value,
      BGClass: mBGClass.value.toString(),
    );
    if (isInternet) {
      var map = mapData(
        aiDBP,
        aiSBP,
        sbp,
        dbp,
        hr,
        isAISelected.value,
        isResearcher,
        isTrainingEnable,
        isOscillometric,
        deviceHr,
        deviceSbp,
        deviceDbp,
        deviceHrv,
        minHRV,
        maxHRV,
      );
      var date = DateTime.now();
      print('API time start :: ${DateTime.now()}');
      print('API request data :: =================');
      log.log(jsonEncode(map));
      print('API wait for response :: =============');
      var url = Uri.parse('${Constants.baseUrl}${ApiConstants.getMeasurementEstimate}');
      print(url.toString());

      cancel_http
          .post(url,
              body: jsonEncode(map), headers: Constants.header, cancellationToken: cancelToken)
          .then((response) async {
        print('API time end :: ${DateTime.now()}');
        print('API response statusCode :: ${response.statusCode}');
        print('API response data :: ${response.body}');
        await MHistoryHelper().fetchDay(
          startDate: DateTime.now().subtract(Duration(minutes: 5)).millisecondsSinceEpoch,
          endDate: DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch,
          pageSize: 10,
          fetchNext: false,
        );
        GraphHistoryHelper().dayData();
        if (response.statusCode == 200) {
          var estimatedResult = EstimateResult.fromJson(jsonDecode(response.body));
          print('API time :: ${DateTime.now().difference(date).inSeconds}');
          if (!isTflSelected.value && estimateFlag == 2) {
            try {
              var value = 0;
              var sbpFromAI = 0;
              var dbpFromAI = 0;
              var BGFromAI = 0;
              var BG1FromAI = 0;
              var UncertaintyFromAI = 0;
              try {
                sbpFromAI = estimatedResult.sBP ?? 0;
                dbpFromAI = estimatedResult.dBP ?? 0;
                BGFromAI = estimatedResult.BG ?? 0;
                BG1FromAI = estimatedResult.BG1 ?? 0;
                UncertaintyFromAI = estimatedResult.Uncertainty ?? 0;
                mBGUnit1.value = estimatedResult.Unit ?? '';
                mBGUnit2.value = estimatedResult.Unit1 ?? '';
                mBGClass.value = estimatedResult.Class ?? '';

                LoggingService().info('measurementApiResponse', '$sbpFromAI, $dbpFromAI');

                Navigator.of(context, rootNavigator: true).pop();

                mAISbp.value = sbpFromAI.toDouble();
                mAIDbp.value = dbpFromAI.toDouble();
                mBG1.value = BGFromAI.toDouble();
                mUncertainty.value = UncertaintyFromAI.toDouble();
                mBG2.value = BG1FromAI.toDouble();
              } on Exception catch (e) {
                debugPrint('Exception while parsing result $e');
                LoggingService().warning('Measurement', 'Exception while parsing result', error: e);
              }
              recordId = await saveMeasurementDataToLocalStorage(
                trainingHr: hr,
                trainingDBP: dbp,
                trainingSBP: sbp,
                isSync: true,
                apiId: value,
                recordId: recordId,
                isCalibration: isCalibration,
                aiSBP: sbpFromAI,
                aiDBP: dbpFromAI,
                deviceSbp: deviceSbp,
                deviceDbp: deviceDbp,
                deviceHr: deviceHr,
                deviceHrv: deviceHrv,
                BG: BGFromAI,
                Uncertainty: UncertaintyFromAI,
                BG1: mBG2.value.toInt(),
                BGUnit: mBGUnit1.value,
                BGUnit1: mBGUnit2.value,
                BGClass: mBGClass.value,
                strEcgList: strEcg,
                strPpgList: strPpg,
              );

              print('displayDialog :: 1 :: ${isTflSelected.value}');

              if (estimatedResult.sBP != null) {
                mAISbp.value = num.parse(estimatedResult.sBP.toString()).toDouble();
                WatchSyncHelper().dashData.sys = mAISbp.value;
              }
              if (estimatedResult.dBP != null) {
                mAIDbp.value = num.parse(estimatedResult.dBP.toString()).toDouble();
                WatchSyncHelper().dashData.dia = mAIDbp.value;
              }
              WatchSyncHelper().dashData.hr = _ecgInfoModel.value?.approxHr ?? 0;

              showEstimationResult(
                SBP: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxSBP,
                DBP: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxDBP,
                HR: _ecgInfoModel.value == null ? 0 : _ecgInfoModel.value!.approxHr,
                result: {
                  'ID': estimatedResult.iD ?? 0,
                  'Sys': estimatedResult.sBP ?? 0,
                  'Sys Predication': sys_Prediction ?? '',
                  'Dias Predication': dias_Prediction ?? '',
                  'Dia': estimatedResult.dBP ?? 0,
                  'BG': estimatedResult.BG ?? 0,
                  'BG1': estimatedResult.BG1 ?? 0,
                  'Unit': estimatedResult.Unit ?? '',
                  'Unit1': estimatedResult.Unit1 ?? '',
                  'Class': estimatedResult.Class ?? '',
                  'min_hrv_time': minHRV,
                  'max_hrv_time': maxHRV,
                },
                isOs: isOscillometric,
                IsResearcher: isResearcher,
                isTflData: isTflSelected.value,
                // onOkClick: () async {
                //   var isMTagging = preferences?.getBool(Constants.prefMTagging) ?? false;
                //   if (isMTagging) {
                //     var result = await tagConfirmation();
                //     if (result != null && result is bool && result) {
                //       navigateToTagScreen();
                //     }
                //   }
                // },
              );
              print(
                  'after record insert ${!isCalibration && ((isOscillometric && (isSavedFromOscillometric.value ?? false)) || isEstimate)}');
              hrCalibrationTextEditController.text = '';
              sbpCalibrationTextEditController.text = '';
              dbpCalibrationTextEditController.text = '';
              LoggingService().info('Measurement', 'Send data to server');
            } on Exception catch (e) {
              entry?.remove();
              entry = null;
              debugPrint('Exception at measurement screen $e');
              LoggingService().warning('Measurement', 'Send data to server', error: e);
            }
          }
        }
      });

      return;
    } else if (!isCanceled.value) {
      if (isEstimate && isInternet) {
        entry = showOverlay(context);
      }
    }
  }

  void callAPIAfter30Seconds() {
    // uploadDataInServerAfterThritySeconds(
    //     widget.measurementHistoryModel?.aiSBP?.toInt() ?? 0,
    //     widget.measurementHistoryModel?.aiDbp?.toInt() ?? 0);
  }

  Future saveMeasurementDataToLocalStorage(
      {bool? isSync,
      int? trainingHr,
      int? trainingSBP,
      int? trainingDBP,
      int? apiId,
      int? recordId,
      int? aiSBP,
      int? aiDBP,
      int? BG,
      int? BG1,
      int? Uncertainty,
      String? BGUnit,
      String? BGUnit1,
      String? BGClass,
      bool? isCalibration,
      int? deviceHr,
      int? deviceSbp,
      int? deviceDbp,
      int? deviceHrv,
      var strEcgList,
      var strPpgList}) async {
    try {
      // var strEcgList = ecgPointList.join(',');
      // var strPpgList = ppgPointList.join(',');
      var strEcgTimeList = '';
      var strPpgTimeList = '';
      // for (num value in ecgElapsedList) {
      //   strEcgTimeList += '$value,';
      // }
      if (strEcgTimeList.isNotEmpty) {
        strEcgTimeList = strEcgTimeList.substring(0, strEcgTimeList.length - 1);
      }
      // for (num value in ppgElapsedList) {
      //   strPpgTimeList += '$value,';
      // }
      if (strPpgTimeList.isNotEmpty) {
        strPpgTimeList = strPpgTimeList.substring(0, strPpgTimeList.length - 1);
      }
      var map = <String, dynamic>{};

      print('saved_localStorageData ${strPpgList.toString()}');
      map = MeasurementHistoryModel(
        id: recordId,
        hr: deviceHr,
        sbp: deviceSbp,
        dbp: deviceDbp,
        hrv: deviceHrv,
        BG: BG,
        BG1: BG1,
        Uncertainty: Uncertainty,
        Unit: BGUnit,
        Unit1: BGUnit1,
        Class: BGClass,
        ecg: strEcgList != null ? strEcgList.split(',') : [],
        ppg: strPpgList != null ? strPpgList.split(',') : [],
        aiDbp: aiDBP,
        aiSBP: aiSBP,
        date: DateTime.now().toString(),
        isCalibration: isCalibration,
        isForHourlyHR: false,
        isForTimeBasedPpg: false,
        isFromCamera: false,
        tDbp: trainingDBP,
        tSbp: trainingSBP,
        tHr: trainingHr,
        isSync: (apiId is int) ? 1 : 0,
        deviceType: 'E80',
        idForApi: apiId,
        isForOscillometric: false,
      ).toMapDB();
      map['user_Id'] = userId;
      map['isSavedFromOscillometric'] = isSavedFromOscillometric.value;
      var result = dbHelper.insertMeasurementData(map, userId);
      if (recordId == null) {
        postMeasurementDataInHealthKit();
      }
      debugPrint('recordId $result');
      return result;
    } catch (e) {
      debugPrint('Exception while storingF $e');
      LoggingService().info('Measurement', 'Exception while storingF ');
    }
    return null;
  }

  Future<void> showInitDialog() async {
    var dialog = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TimerWidget(),
        ],
      ),
    );
    await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => dialog,
      barrierColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.color7F8D8C.withOpacity(0.5)
          : AppColor.color384341.withOpacity(0.6),
      barrierDismissible: false,
    );
  }

  void popTillThis(bool showHelpDialog) async {
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    _ecgInfoModel.value = null;
    await getPreferences();
    connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
    if (preferences == null) {
      await getPreferences();
    }
    resetScreen();
    ecgEndTime.value = DateTime.now().millisecondsSinceEpoch;
    ecgLastRecordDate.value = DateTime.now();
    showMWrongDialog.value = false;
    var hideDialog = preferences!.getBool(Constants.doNotAskMeAgainForMeasurementDialog) ?? false;
    if ((!hideDialog) && showHelpDialog) {
      measurementType.value = preferences!.getInt(Constants.measurementType) ?? 1;

      if (measurementType.value != 2) showMeasurementHelpDialog();
    } else if ((!hideDialog) && !showHelpDialog) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
    }
    setGraphColors();

    measurementType.value = preferences!.getInt(Constants.measurementType) ?? 1;
    if (measurementType.value == 2 && Platform.isIOS) generateSampleDataAndGraph();
  }

  void resetScreen() {
    mTimer.value?.cancel();
    mTimer.value = null;
    ecgPList.value.clear();
    ppgPList.value = [];
    hrvPointList.value.clear();
    // ecgElapsedList = [];
    // ppgElapsedList = [];
    avgECGList.value.clear();
    avgPPGList.value.clear();
    ppgFilterList.value.clear();
    ppgGraphValue1.value.clear();
    ppgGraphValue1.value.clear();
    ecgGraphValue1.value = [];
    hrvGraphValues.value.clear();
    hrvGraphValues.notifyListeners();
    hrvLength.value = 0;
    ppgXValue.value = 0;
    ecgXValue.value = 0;
  }

  Future getPreferences() async {
    preferences ??= await SharedPreferences.getInstance();
    userId = preferences!.getString(Constants.prefUserIdKeyInt) ?? '';
    measurementType.value = preferences!.getInt(Constants.measurementType) ?? 1;
    if (measurementType.value == null) {
      preferences!.setInt(Constants.measurementType, 1);
    }
    connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
    if (this.mounted) {
      setState(() {});
    }
  }

  showMeasurementHelpDialog({bool? showDismissButton}) async {
    var dialog = MeasurementHelpDialog(showDismissButton: showDismissButton);
    showDialog(context: context, builder: (context) => dialog, useRootNavigator: true);
  }

  void goSelectTag() async {
    var _helper = TagHelper();
    // var tagLabelList = await _helper.fetchTagFromLocal();
    // if(tagLabelList.)
  }

  void navigateToTagScreen() async {
    var tagList = <Tag>[];
    tagList = await dbHelper.getAutoLoadTagList(userId);
    print('Navigate Calibration :: $tagList');
    if (tagList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagListScreen(tagList: tagList),
              settings: RouteSettings(
                name: 'TagListScreen',
              ),
            ),
          );
        });
      });
    }
  }

  Future wrongMeasurement({String? text, bool? fromTimer}) async {
    if (isMFailed.value) {
      return;
    }
    if (!showMWrongDialog.value) {
      showMWrongDialog.value = true;
      return showDialogForWrongMeasurementData(text: text);
    }
  }

  Future showDialogForWrongMeasurementData({String? text}) {
    var dialog = CustomDialog(
      title: text ??
          stringLocalization.getText(
            StringLocalization.wrongData,
          ),
      subTitle: stringLocalization.getText(StringLocalization.wrongDataDescription),
      onClickNo: onClickCancelWrongData,
      onClickYes: onClickRestartWrongData,
      maxLine: 10,
    );
    return showDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false,
        useRootNavigator: true);
  }

  void onClickRestartWrongData() {
    Navigator.of(context, rootNavigator: true).pop(true);
    startMeasurement(context: context, showTimer: true);
  }

  void onClickCancelWrongData() {
    Navigator.of(context, rootNavigator: true).pop(false);
  }

  Future showDialogForMeasurementIsNotStartedInBracelet() {
    isMNotStarted.value = true;
    var dialog = CustomDialog(
      title: stringLocalization.getText(StringLocalization.measurementNotStarted),
      subTitle: stringLocalization.getText(StringLocalization.measurementNotStartedDescription),
      onClickNo: onClickCancelMeasurementNotStarted,
      onClickYes: onClickRestartMeasurementNotStarted,
      maxLine: 10,
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
      barrierDismissible: false,
      useRootNavigator: true,
    );
  }

  void onClickRestartMeasurementNotStarted() {
    Navigator.of(context, rootNavigator: true).pop(true);
  }

  void onClickCancelMeasurementNotStarted() {
    Navigator.of(context, rootNavigator: true).pop(false);
  }

  Future showEstimationResult(
      {int? SBP,
      int? DBP,
      int? HR,
      Map<dynamic, dynamic>? result,
      required bool IsResearcher,
      required bool isTflData,
      Function? onOkClick,
      bool isOs = false}) async {
    _ecgInfoModel.notifyListeners();
    var dialog = EstimateDialog(
      SBP: Platform.isAndroid ? DBP : SBP,
      DBP: Platform.isAndroid ? SBP : DBP,
      HR: HR,
      result: result,
      isOs: isOs,
      isTrainingEnable: preferences?.getBool(Constants.isTrainingEnableKey) ?? false,
      hrCalibrationTextEditController:
          TextEditingController(text: hrCalibrationTextEditController.text.toString()),
      sbpCalibrationTextEditController:
          TextEditingController(text: sbpCalibrationTextEditController.text.toString()),
      dbpCalibrationTextEditController:
          TextEditingController(text: dbpCalibrationTextEditController.text.toString()),
      isResearcher: IsResearcher,
      isTFLData: preferences?.getBool(Constants.isTFLSelected) ?? false,
      isAIData: preferences?.getBool(Constants.isAISelected) ?? false,
      onOkClick: onOkClick,
    );
    await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => dialog,
      barrierColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.color7F8D8C.withOpacity(0.6)
          : AppColor.color384341.withOpacity(0.6),
      barrierDismissible: false,
    );
  }

  postMeasurementDataInHealthKit() async {
    var date = DateFormat(DateUtil.yyyyMMddHHmmss).format(DateTime.now());
    var bloodPressureMap = <String, dynamic>{
      'sbp': _ecgInfoModel.value?.approxSBP ?? 0,
      'dbp': _ecgInfoModel.value?.approxDBP ?? 0,
      'startDate': date
    };

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// remove auth code because we already authenticated google auth on dashboard screen
    // if (Platform.isAndroid &&
    //     (preferences?.getBool(Constants.isGoogleSyncEnabled) ?? false)) {
    //   var isGranted = await Permission.activityRecognition.isGranted;
    //   if (!isGranted) {
    //     isGranted = await Permission.activityRecognition.request() ==
    //         PermissionStatus.granted;
    //   }
    //   if (isGranted) {
    //     var isAuthenticated = await connections.checkAuthForGoogleFit();
    //     if (!isAuthenticated) {
    //       return null;
    //     }
    //   } else {
    //     return null;
    //   }
    // }

    var result = await connections.writeBloodPressureDataInHealthKitOrGoogleFit(bloodPressureMap);

    var heartRateMap = <String, dynamic>{
      'heartRate': _ecgInfoModel.value?.approxHr ?? 0,
      'startDate': date
    };
    var heartRateResult = await connections.writeHeartRateDataInHealthKitOrGoogleFit(heartRateMap);
  }

  OverlayEntry showOverlay(BuildContext context) {
    var overlayState = Overlay.of(context);
    var overlayEntry = OverlayEntry(
      builder: (context) => CircularProgressOverlay(),
    );
    overlayState?.insert(overlayEntry);
    return overlayEntry;
  }

  OverlayEntry showProgressOverlay(BuildContext context) {
    var overlayState = Overlay.of(context);
    var overlayEntry =
        OverlayEntry(builder: (context) => LinearProgressOverlay(percentage: percentage));

    overlayState?.insert(overlayEntry);
    return overlayEntry;
  }

  calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  calculateWeight(double weight) {
    return weight.toInt();
  }

  calculateHeight(String height) {
    return (double.tryParse(height) ?? 0.0).toInt();
  }

  int getHrvFromEcg(List<Entry> ecgList) {
    try {
      var sumOfDistance = 0;
      var yList = <Entry>[];
      for (var i = 0; i < ecgList.length; i++) {
        if (i == 0) {
          if (ecgList[0].y != null && ecgList[1].y != null && ecgList[0].y! >= ecgList[1].y!) {
            yList.add(ecgList[0]);
          }
        } else if (ecgList[ecgList.length - 1].y != null &&
            ecgList[ecgList.length - 2].y != null &&
            i == (ecgList.length - 1)) {
          var lastItem = ecgList[ecgList.length - 1].y!;
          var lastSecondItem = ecgList[ecgList.length - 2].y!;

          if (lastItem >= lastSecondItem) {
            yList.add(ecgList[ecgList.length - 1]);
          }
        } else {
          if (ecgList[i].y != null && ecgList[i - 1].y != null && ecgList[i + 1].y != null) {
            var currentPoint = ecgList[i].y!;
            var previousPoint = ecgList[i - 1].y!;
            var nextPoint = ecgList[i + 1].y!;
            if (currentPoint >= previousPoint && currentPoint >= nextPoint) {
              yList.add(ecgList[i]);
            }
          }
        }
      }

      yList.sort((a, b) => b.y!.compareTo(a.y!));
      var seventyPercentData = measurementType.value == 2 && Platform.isIOS
          ? (yList.length * 13.7) / 100
          : (yList.length * 90) / 100;
      var trashHoldPoints = <Entry>[];
      for (var i = 0; i < seventyPercentData; i++) {
        trashHoldPoints.add(yList[i]);
      }
      yList = trashHoldPoints;
      yList.sort((a, b) => b.x!.compareTo(a.x!));
      var pointsInMillisecond = 0.250;
      if (measurementType.value == 2 && Platform.isIOS) {
        pointsInMillisecond = 0.512;
      }
      List listOfMilliSeconds = yList.map((e) => (e.x! / pointsInMillisecond).round()).toList();
      print('listOfMilliSeconds :: $listOfMilliSeconds');
      var durationDistance = <int>[];
      for (var i = listOfMilliSeconds.length ~/ 3; i < listOfMilliSeconds.length / 1.5; i++) {
        if (i != listOfMilliSeconds.length - 1) {
          int distance = listOfMilliSeconds[i + 1] - listOfMilliSeconds[i];
          durationDistance.add(distance);
        }
      }

      for (var i = 0; i < durationDistance.length; i++) {
        if (i != durationDistance.length - 1) {
          var distance = durationDistance[i + 1] - durationDistance[i];
          sumOfDistance += (distance * distance);
        }
      }
      return sqrt((sumOfDistance) / durationDistance.length).toInt();
    } catch (e) {
      debugPrint('Exception at measurement screen $e');
      LoggingService().info('Measurement', 'Exception at measurement screen ');
    }
    return 0;
  }

  checkAuthenticationGoogleFit() async {
    try {
      if (Platform.isAndroid) {
        var isGranted = await Permission.activityRecognition.isGranted;
        if (!isGranted) {
          isGranted = await Permission.activityRecognition.request() == PermissionStatus.granted;
        }
        if (isGranted) {
          var isAuthenticated = await connections.checkAuthForGoogleFit();
          if (!isAuthenticated) {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {
      LoggingService().printLog(tag: 'Google fit Auth', message: e.toString());
    }
  }

  getCallibrationDataFromHealthKit() async {
    var endDate = DateTime.now();
    var startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
    final formatter = DateFormat(DateUtil.yyyyMMddHHmmss);

    /// Added by: Chaitanya
    /// Added on: Oct/8/2021
    /// getting Callibration data from google fit and set in dialog
    dynamic healthDiaBp;
    dynamic healthSysBp;
    dynamic healthHeartRate;
    // await checkAuthenticationGoogleFit();
    if (Platform.isAndroid) {
      startDate = startDate.add(timeZoneOffset);
      endDate = endDate.add(timeZoneOffset);

      healthDiaBp = await connections.readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));

      healthSysBp = await connections.readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));

      healthHeartRate = await connections.readHeartRateDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));

      if (healthDiaBp.length > 0) {
        dbpCalibrationTextEditController.text =
            ((double.tryParse(healthDiaBp.last['value'].toString()) ?? 0).toInt()).toString();
      } else {
        dbpCalibrationTextEditController.text = '0';
      }

      if (healthSysBp.length > 0) {
        sbpCalibrationTextEditController.text =
            ((double.tryParse(healthSysBp.last['value'].toString()) ?? 0).toInt()).toString();
      } else {
        sbpCalibrationTextEditController.text = '0';
      }

      if (healthHeartRate.length > 0) {
        hrCalibrationTextEditController.text =
            ((double.tryParse(healthHeartRate.last['value'].toString()) ?? 0).toInt()).toString();
      } else {
        hrCalibrationTextEditController.text = '0';
      }
    } else {
      var data1 = await connections.readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));
      var data2 = await connections.readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));
      var data3 = await connections.readHeartRateDataFromHealthKitOrGoogleFit(
          formatter.format(startDate), formatter.format(endDate));
      if (data2.length > 0) {
        sbpCalibrationTextEditController.text =
            ((double.tryParse(data2.last['value']) ?? 0).toInt()).toString();
      } else {
        sbpCalibrationTextEditController.text = '0';
      }
      if (data1.length > 0) {
        dbpCalibrationTextEditController.text =
            ((double.tryParse(data1.last['value']) ?? 0.0).toInt()).toString();
      } else {
        dbpCalibrationTextEditController.text = '0';
      }
      if (data3.length > 0) {
        hrCalibrationTextEditController.text =
            ((double.tryParse(data3.last['value']) ?? 0).toInt()).toString();
      } else {
        hrCalibrationTextEditController.text = '0';
      }
    }

    setState(() {});
  }

  @override
  void onGetEcg(EcgInfoReadingModel ecgInfoReadingModel) async {
    print('ecgInfoReadingModel ${ecgInfoReadingModel.pointList}');
  }

  @override
  void onGetPpg(PpgInfoReadingModel ppgInfoReadingModel) {
    print('ppgInfoReadingModel ${ppgInfoReadingModel.pointList}');
  }

  ValueNotifier<List<int>> hrvPointList = ValueNotifier([]);
  ValueNotifier<List<fl_charts.FlSpot>> hrvGraphValues = ValueNotifier([]);

  @override
  void onGetEcgFromE66(EcgInfoReadingModel ecgInfoReadingModel) {
    if (!(mTimer.value?.isActive ?? false)) {
      return;
    }
    print('onGetEcgFromE66 ${ecgInfoReadingModel.pointList}');
    print('HRV Times :: ${ecgInfoReadingModel.startTime} :: ${ecgInfoReadingModel.endTime}');
    print('onGetEcgFromE66 ecgInfoReadingModel ${ecgInfoReadingModel.toJson()}');

    mAIDbp.value = ecgInfoReadingModel.approxDBP?.toDouble() ?? 0.0;
    mAISbp.value = ecgInfoReadingModel.approxSBP?.toDouble() ?? 0.0;

    if ((ecgInfoReadingModel.approxHr?.toDouble() ?? 0.0) > 0) {
      _ecgInfoModel.value?.approxHr = ecgInfoReadingModel.approxHr!.toInt();
    }

    dashBoardGlobalKey.currentState?.lastDataFetchedTime = DateTime.now();
    var pointsInMillisecond = 84;
    var seconds = (ecgXValue.value / pointsInMillisecond);

    ecgLastRecordDate.value = DateTime.now();
    try {
      ecgStartTime.value = ecgInfoReadingModel.startTime ?? 0;
      if (seconds < 60) {
        ecgEndTime.value = ecgInfoReadingModel.endTime ?? 0;
        if (ecgInfoReadingModel.pointList != null) {
          _ecgInfoModel.value = ecgInfoReadingModel;
          _ecgInfoModel.value?.hrv = hrv;
          for (var i = 0; i < (ecgInfoReadingModel.pointList?.length ?? 0); i++) {
            num y = ecgInfoReadingModel.pointList?[i] + 0.0;

            ecgPList.value.add(y.toInt());
          }
        }

        for (var i = 0; i < (ecgInfoReadingModel.pointList?.length ?? 0); i++) {
          var current = ecgInfoReadingModel.pointList?.elementAt(i) ?? 0;
          if (i % 3 == 0) {
            var avg = (firstPointECG + secondPointECG + current) / 3;
            avgECGList.value.add(avg);
            ecgXValue.value++;
            if ((avgECGList.value.length) >= 200) {
              // if (timeStampOfAvgPointEcg == 0) {
              //   timeStampOfAvgPointEcg =
              //       DateTime.now().toUtc().millisecondsSinceEpoch;
              // }
              ecgGraphValue1.value.add(Entry(
                x: ecgXValue.value,
                y: avg + 0.0,
                data: mTimer.value?.tick ?? 0,
              ));
            }
          }
          if (i == 0) {
            firstPointECG = current;
          } else if (i == 1) {
            secondPointECG = current;
          } else {
            firstPointECG = secondPointECG;
            secondPointECG = current;
          }
        }
        ecgLength.value += ecgGraphValue1.value.length;

        xValueFormatter?.listOfEntry = ecgGraphValue1.value;
        xValueFormatter?.connectedDevice = connectedDevice;

        xValueFormatter?.pointInSec = pointsInMillisecond.toDouble();
        // var tempList = <int>[];
        // for(var i in ecgInfoReadingModel.pointList ?? []){
        //   tempList.add(i);
        // }
        // List<int> rrIntervals = deriveRRIntervals(tempList);
        //
        // // Calculate RMSSD from RR intervals
        // int hrvValue = calculateRMSSD(rrIntervals).toInt();

        num hrvValue = getHrvFromEcg(ecgGraphValue1.value);
        if (hrvValue > 0 && hrvValue < 75) {
        } else {
          hrvValue = hrvValue ~/ 3;
        }
        hrvCalc.addHRV(hrvValue.toInt());
        hrv = hrvCalc.runningHRVAverage.toInt();
        _ecgInfoModel.value?.hrv = hrv;
        WatchSyncHelper().dashData.hrv = hrv;
        if (hrv > 0) {
          hrvPointList.value.add(hrv);
          previousHRV.add(hrv);
          var x = mTimer.value!.tick;
          if (x != previousX) {
            var sum = 0;
            for (var i in previousHRV) {
              sum += i;
            }
            var y = sum / previousHRV.length;

            hrvGraphValues.value.add(fl_charts.FlSpot(x.toDouble(), y.toDouble()));
            hrvLength.value = hrvGraphValues.value.length;
            previousHRV.clear();
          }
          previousX = x;
          hrvGraphValues.notifyListeners();
        }

        print('onGetEcgFromE66 hrv ${_ecgInfoModel.value?.hrv}');

        setDataToEcgGraph();

        controllerForEcgGraph?.setVisibleXRangeMaximum(200);

        controllerForEcgGraph?.moveViewToX(ecgXValue.value);
      }
      getMemory(ecgGraphValue1.value.length);
      ecgGraphValue1.notifyListeners();
    } catch (e) {
      LoggingService().warning('Measurement', 'Measurement issue', error: e);
      debugPrint('Exception at onGetEcg $e');
      LoggingService().warning('Measurement', 'Exception at measurement screen ', error: e);
    }
  }

  double calculateRMSSD(List<int> rrIntervals) {
    double sumOfSquaredDifferences = 0;

    for (int i = 1; i < rrIntervals.length; i++) {
      int difference = rrIntervals[i] - rrIntervals[i - 1];
      sumOfSquaredDifferences += pow(difference.toDouble(), 2);
    }

    double meanSquaredDifference = sumOfSquaredDifferences / (rrIntervals.length - 1);
    double rmssd = sqrt(meanSquaredDifference);

    return rmssd;
  }

  List<int> deriveRRIntervals(List<int> ecgPoints) {
    List<int> rrIntervals = [];

    for (int i = 1; i < ecgPoints.length; i++) {
      int rrInterval = ecgPoints[i] - ecgPoints[i - 1];
      rrIntervals.add(rrInterval);
    }

    return rrIntervals;
  }

  List<int> calculateRRIntervals(List<int> ppgPoints) {
    List<int> rrIntervals = [];
    for (int i = 1; i < ppgPoints.length; i++) {
      int rrInterval = ppgPoints[i] - ppgPoints[i - 1];
      rrIntervals.add(rrInterval);
    }
    return rrIntervals;
  }

/*  double calculateRMSSD(List<int> rrIntervals) {
    double rmssd = sqrt(
        rrIntervals.map((rr) => pow(rr, 2)).reduce((a, b) => a + b) / (rrIntervals.length - 1));
    return rmssd;
  }*/

  int previousX = 0;
  List<int> previousHRV = [];
  HRVCalc hrvCalc = HRVCalc();

  List<int> detectPeaks(List<int> signal) {
    // A simple peak detection algorithm (replace with a more sophisticated method if available)
    List<int> peaks = [];

    for (int i = 1; i < signal.length - 1; i++) {
      if (signal[i] > signal[i - 1] && signal[i] > signal[i + 1]) {
        peaks.add(i);
      }
    }

    return peaks;
  }

  @override
  void onGetPpgFromE66(PpgInfoReadingModel ppgInfoReadingModel) {
    if (!(mTimer.value?.isActive ?? false)) {
      return;
    }
    /*print('onGetPpgFromE66 ${ppgInfoReadingModel.pointList}');
    try {
      if (ppgInfoReadingModel.pointList != null && (mTimer.value?.tick ?? 0) > 5) {
        var tempList = <int>[];
        for (int i = 0; i < ppgInfoReadingModel.pointList!.length; i++) {
          tempList.add(ppgInfoReadingModel.pointList![i]);
        }
        // tempList = tempList.map((e) => e.abs()).toList();
        // tempList = detectPeaks(tempList);
        var rrIntervals = calculateRRIntervals(tempList);
        var hrvValue = calculateRMSSD(rrIntervals);
        var tempHRV = 0;
        tempHRV = hrvValue.toInt();
        // if (hrvValue > 0 && hrvValue < 75) {
        //   tempHRV = hrvValue.toInt();
        // } else {
        //   tempHRV = hrvValue ~/ 3;
        // }
        _ecgInfoModel.value?.hrv = hrv;
        print('HRVResult :: hrv :: $hrvValue ms');
        hrvCalc.addHRV(tempHRV);
        hrv = hrvCalc.runningHRVAverage.toInt();
        print('graphHRV :: hrv :: HRV :: $hrv');
        hrvPointList.value.add(hrv);
        previousHRV.add(hrv);
        var x = mTimer.value!.tick;
        if (x != previousX) {
          var sum = 0;
          for (var i in previousHRV) {
            sum += i;
          }
          var y = sum / previousHRV.length;
          hrvGraphValues.value.add(fl_charts.FlSpot(x.toDouble(), y.toDouble()));
          hrvLength.value = hrvGraphValues.value.length;
          previousHRV.clear();
        }
        previousX = x;
        // if (mTimer.value!.tick % 2 == 0) {
        hrvGraphValues.notifyListeners();
        // }
      }
    } catch (e) {
      print('calculateRRIntervals $e');
    }*/

    dashBoardGlobalKey.currentState?.lastDataFetchedTime = DateTime.now();
    ecgLastRecordDate.value = DateTime.now();
    var pointsInSec = 84;
    // var noOfSeconds = 60;
    // var noOfSeconds = 30;
    var noOfSeconds = measurementTime.value;
    var seconds = (ppgXValue.value / pointsInSec);
    try {
      ppgStartTime.value = (ppgInfoReadingModel.startTime ?? 0) as num;
      if (seconds < noOfSeconds) {
        ppgEndTime.value = (ppgInfoReadingModel.endTime ?? 0) as num;
        if (ppgInfoReadingModel.pointList != null) {
          ppgInfoModel = ppgInfoReadingModel;
          for (var i = 0; i < ppgInfoReadingModel.pointList!.length; i++) {
            var value = ppgInfoReadingModel.pointList![i];
            ppgPList.value.add(value);
          }
        }
        for (var i = 0; i < (ppgInfoReadingModel.pointList?.length ?? 0); i++) {
          var current = ppgInfoReadingModel.pointList?.elementAt(i) ?? 0;
          if (i % 3 == 0) {
            var avg = (firstPointPPG + secondPointPPG + current) / 3;
            avgPPGList.value.add(avg);
            if (avgPPGList.value.length >= 200) {
              if (tsAvgPointPPG.value == 0) {
                tsAvgPointPPG.value = DateTime.now().toUtc().millisecondsSinceEpoch;
              }
              ppgGraphValue1.value.add(Entry(
                x: ppgXValue.value,
                y: (applyRealTimeFilter(avg) + 0.0) * -1,
                data: mTimer.value?.tick ?? 0,
              ));
            }
            ppgXValue.value += 1;
          }
          if (i == 0) {
            firstPointPPG = current;
          } else if (i == 1) {
            secondPointPPG = current;
          } else {
            firstPointPPG = secondPointPPG;
            secondPointPPG = current;
          }
        }
        ppgLength.value += ppgGraphValue1.value.length;
        xValueFormatterPPG?.listOfEntry = ppgGraphValue1.value;
        xValueFormatterPPG?.connectedDevice = connectedDevice;
        xValueFormatterPPG?.pointInSec = pointsInSec.toDouble();
        setDataToPpgGraph();
        controllerForPpgGraph?.setVisibleXRangeMaximum(200);
        controllerForPpgGraph?.moveViewToX(ppgXValue.value);
      }
    } catch (e) {
      debugPrint('Exception at onGetPpg $e');
      LoggingService().warning('Measurement', 'Exception at measurement screen ', error: e);
    }
  }

  num applyRealTimeFilter(num y) {
    y = butterworth.filter(y.toDouble());
    y = butterWorthLowPass.filter(y.toDouble());
    ppgFilterList.value.add(y);
    return y;
  }

  applyHighPassFilterOnPPG([List<Entry>? valuesForPpgGraph]) {
    if (connectedDevice?.sdkType == Constants.e66) {
      var ppgLists = List.from(ppgPList.value);
      try {
        var newList = <Entry>[];
        for (var i = 0; i < (ppgLists.length); i++) {
          num element = ppgLists.elementAt(i);
          var e = Entry();
          e.y = butterWorthHighPassAfterMeasurementDone.filter(element + 0.0);
          e.y = -butterWorthLowPassAfterMeasurementDone.filter(e.y! + 0.0);
          e.x = i + 0.0;
          newList.add(e);
          ppgFilterList.value.add(e.y?.toDouble() ?? 0.0);
        }
        ppgGraphValue1.value = newList;
        xValueFormatterPPG?.listOfEntry = newList;
        setDataToPpgGraph();

        controllerForPpgGraph?.moveViewToX(ppgXValue.value);
      } catch (e) {
        debugPrint('Exception at applyHighPassFilterOnPPG $e');
        LoggingService().warning('Measurement', 'Exception at measurement screen ', error: e);
      }
    }
  }

  @override
  void onGetLeadStatus(LeadOffStatusModel leadOffStatusModel) async {
    print('onGetLeadStatus  ${ppgPList.value.length}');
    if (leadOffStatusModel.ecgStatus == 0) {
      isLeadOff.value = false;
    } else {
      isLeadOff.value = true;
      if (ppgPList.value.length > 500 && (mTimer.value?.tick ?? 0) < measurementTime.value - 5) {
        await stopMeasurement();
        showMWrongDialog.value = false;
        if (!showMWrongDialog.value) {
          showMWrongDialog.value = true;
          showDialogForWrongMeasurementData(
            text: stringLocalization.getText(
              StringLocalization.wrongData,
            ),
          );
        }
      }
    }
    // TODO: implement onGetLeadStatus
  }
}

class XValueFormatter extends ValueFormatter {
  LineChartController? _controller;
  var _connectedDevice;
  late List<Entry> _listOfEntry;
  int _zoomLevel = 0;
  var _pointInSec = 125.0;

  set pointInSec(double value) {
    _pointInSec = value;
  }

  get connectedDevice => _connectedDevice;

  set connectedDevice(value) {
    _connectedDevice = value;
    if (_connectedDevice?.sdkType == Constants.e66) {
      if (Platform.isAndroid) {
        pointInSec = 243;
      } else {
        pointInSec = 254;
      }
    }
  }

  set controller(LineChartController value) {
    _controller = value;
  }

  set listOfEntry(List<Entry> value) {
    _listOfEntry = value;
  }

  XValueFormatter(LineChartController? controller, {connectedDevice}) {
    this._controller = controller;
    this.connectedDevice = connectedDevice;
  }

  @override
  String getFormattedValue1(double? value) {
    return '';
  }

  String removeTrailingZero(String string) {
    if (!string.contains('.')) {
      return string;
    }
    string = string.replaceAll(RegExp(r'0*$'), '');
    if (string.endsWith('.')) {
      string = string.substring(0, string.length - 1);
    }
    return string;
  }

  set zoomLevel(int value) {
    _zoomLevel = value;
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}

class MeasurementValue {
  double xValue;
  double yValue;
  String xAxis;

  MeasurementValue({required this.xValue, required this.yValue, required this.xAxis});
}
