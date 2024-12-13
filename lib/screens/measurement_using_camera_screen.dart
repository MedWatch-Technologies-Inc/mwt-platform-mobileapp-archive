import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:health_gauge/models/measurement/ecg_info_reading_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/repository/measurement/measurement_repository.dart';
import 'package:health_gauge/repository/measurement/request/add_measurement_request.dart';
import 'package:health_gauge/screens/measurement_screen/cards/hrv_card.dart';
import 'package:health_gauge/screens/measurement_screen/cards/ppg_card.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:iirjdart/butterworth.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

// import 'package:mp_chart/mp/core/entry/entry.dart';
// import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

import 'dashboard/progress_indicator_painter.dart';
import 'measurement_screen/widgets/background_paint.dart';

class MeasurementUsingCamera extends StatefulWidget {
  final MeasurementHistoryModel? measurementHistoryModel;

  const MeasurementUsingCamera({Key? key, this.measurementHistoryModel}) : super(key: key);

  @override
  _MeasurementUsingCameraState createState() => _MeasurementUsingCameraState();
}

class _MeasurementUsingCameraState extends State<MeasurementUsingCamera>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  CameraImage? _image;
  Timer? _timer;
  Timer? measurementTimer;
  List<SensorValue> _data = [];
  AnimationController? _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  int currentHeartRate = 0; // beats per minute
  int currentHRV = 0; // beats per minute
  final int _fs = 30; // sampling frequency (fps)
  final int _windowLen = 30 * 6; // window length to display - 6 seconds
  double? _avg; // store the average value during calculation
  final double _alpha = 0.3; // factor for the mean value
  int pageNo = 0;
  LineChartController? controllerForPpgGraph;
  List<Entry> valuesForPpgGraph = [];
  List<Entry> yListForThreshHolds = [];
  double ppgValueX = 0.0;
  XValueFormatter? xValueFormatterPPG;
  List ppgPointList = [];
  String? userId;

  num? startTimePpg;
  num? endTimePpg;

  //text edit controller for training param
  TextEditingController hrCalibrationTextEditController = TextEditingController();
  TextEditingController sbpCalibrationTextEditController = TextEditingController();
  TextEditingController dbpCalibrationTextEditController = TextEditingController();

  FocusNode focusNodeDbp = FocusNode();

  bool openKeyboardSbp = false;
  bool openKeyboardHr = false;
  bool openKeyboardDbp = false;

  String errorMessageForSBP = '';
  String errorMessageForDBP = '';
  String errorMessageForHeart = '';

  bool isCancelClicked = false;

  OverlayEntry? entry;
  Butterworth butterWorthLowPass = Butterworth();
  Butterworth butterworth = Butterworth();

  @override
  void initState() {
    super.initState();
    initGraphControllers();

    if (Platform.isAndroid) {
      butterWorthLowPass.lowPass(3, 200, 90);
    } else {
      butterWorthLowPass.lowPass(3, 800, 84);
    }
    butterworth.highPass(3, 2500, 36);
    _animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      ?..addListener(() {
        _iconScale = 1.0 + _animationController!.value * 0.4;
        if (mounted) {
          setState(() {});
        }
      });
    setValues();
    Future.delayed(Duration(milliseconds: 500)).then((value) => showCameraInfoDialog());
  }

  showCameraInfoDialog() {
    var hideDialog =
        preferences?.getBool(Constants.doNotAskMeAgainForCameraMeasurementDialog) ?? false;
    if (!hideDialog) {
      cameraMeasurementInfoDialog(true);
    }
  }

  void setValues() {
    try {
      if (widget.measurementHistoryModel != null) {
        ppgPointList =
            widget.measurementHistoryModel!.ppg?.map((e) => double.parse('$e')).toList() ?? [];
        for (var i = 0; i < ppgPointList.length; i++) {
          ppgValueX = i.toDouble();
          _avg = ppgPointList[i.toInt()];
          var entry = Entry(
            x: ppgValueX,
            y: -_avg!,
            data: measurementTimer?.tick ?? 0,
          );
          valuesForPpgGraph.add(entry);
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    if (controllerForPpgGraph != null &&
        controllerForPpgGraph!.axisLeft != null &&
        controllerForPpgGraph!.axisRight != null) {
      controllerForPpgGraph!.axisLeft!.enabled = false;
      controllerForPpgGraph!.axisRight!.enabled = false;
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        'asset/dark_leftArrow.png',
                        width: 13,
                        height: 22,
                      )
                    : Image.asset(
                        'asset/leftArrow.png',
                        width: 13,
                        height: 22,
                      ),
              ),
              title: Text(
                stringLocalization.getText(StringLocalization.cameraMeasurement),
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/info_dark.png'
                        : 'asset/info.png',
                    height: 33.h,
                    width: 33.h,
                  ),
                  //can change this
                  onPressed: () {
                    cameraMeasurementInfoDialog(false);
                  },
                ),
              ],
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: dataLayout(),
      ),
    );
  }

  Widget dataLayout() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      shrinkWrap: true,
      children: <Widget>[
        measurementCard(),
        ppgCard(),
        hrvCard(),
        cameraCard(),
        progressCard(),
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 17.h, bottom: 23.h),
          child: GestureDetector(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.h),
                  color: HexColor.fromHex('#00AFAA'),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(-5.w, -5.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.75)
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(5.w, 5.h),
                    ),
                  ]),
              child: Container(
                decoration: ConcaveDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.h),
                    ),
                    depression: 10,
                    colors: [
                      Colors.white,
                      HexColor.fromHex('#D1D9E6'),
                    ]),
                //center
                child: Center(
                  // child: FittedBox(
                  //   fit: BoxFit.scaleDown,
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     (_timer != null && _timer.isActive)
                  //         ? StringLocalization.of(context)
                  //             .getText(StringLocalization.stopMeasurement)
                  //             .toUpperCase()
                  //         : StringLocalization.of(context)
                  //             .getText(StringLocalization.startMeasurement)
                  //             .toUpperCase(),
                  //     style: TextStyle(
                  //       fontSize: 16.sp,
                  //       fontWeight: FontWeight.bold,
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? HexColor.fromHex('#111B1A')
                  //           : Colors.white,
                  //     ),
                  //   ),
                  // ),
                  child: TitleText(
                    text: (_timer?.isActive ?? false)
                        ? StringLocalization.of(context)
                            .getText(StringLocalization.stopMeasurement)
                            .toUpperCase()
                        : StringLocalization.of(context)
                            .getText(StringLocalization.startMeasurement)
                            .toUpperCase(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : Colors.white,
                  ),
                ),
              ),
            ),
            onTap: () async {
              if (_timer?.isActive ?? false) {
                await onClickStop();
              } else {
                await onClickStart();
              }
            },
          ),
        ),
      ],
    );
  }

  ValueNotifier<int> get measurementType =>
      ValueNotifier(preferences!.getInt(Constants.measurementType) ?? 1);

  void setZoom(int zoomX, {bool? zoomBtn, int? fromType}) {
    try {
      fromType ??= -1;
      num zoom = (200);
      if (zoomX <= 0) {
        zoom = (200);
        if (fromType == 1) {
          xValueFormatterPPG?.zoomLevel = 0;
        }
      } else {
        zoom = ((200) / zoomX).toDouble();
        if (fromType == 1) {
          xValueFormatterPPG?.zoomLevel = zoomX;
        }
      }

      if (controllerForPpgGraph != null) {
        if (fromType == 1) {
          controllerForPpgGraph?.setVisibleXRangeMaximum(zoom.toDouble());
          controllerForPpgGraph?.setVisibleXRangeMinimum(zoom.toDouble());
        } else {
          controllerForPpgGraph?.setVisibleXRangeMaximum((200));
          controllerForPpgGraph?.setVisibleXRangeMinimum((200));
        }
        if (zoomBtn == null || !zoomBtn) {
          controllerForPpgGraph?.moveViewToX(ppgValueX);
        }
        controllerForPpgGraph?.axisLeft!.enabled = true;
      }
    } catch (e) {
      debugPrint('Exception in zoom method $e');
      LoggingService().warning('Measurement', 'Exception in zoom method', error: e);
    }
  }

  Widget ppgCard() {
    setGraphColors();
    return ValueListenableBuilder(
      valueListenable: ppgLength,
      builder: (BuildContext context, int value, Widget? child) {
        return PPGCard(
          ppgLength: ppgLength,
          valuesForPpgGraph: ppgGraphValues,
          zoomLevelPPG: zoomLevelPPG,
          measurementType: measurementType,
          setZoom: setZoom,
          ppgPointList: ppgPList.value,
          ecgPointList: ppgPList.value,
          controllerForPpgGraph: controllerForPpgGraph,
        );
      },
    );
  }

  ValueNotifier<int> hrvLength = ValueNotifier(0);
  ValueNotifier<List<ChartSampleData>> hrvGraphValues = ValueNotifier([]);
  ValueNotifier<num> zoomLevelHRV = ValueNotifier<num>(1);
  ValueNotifier<List<int>> hrvPointList = ValueNotifier([]);

  Widget hrvCard() {
    return ValueListenableBuilder(
      valueListenable: hrvLength,
      builder: (BuildContext context, value, Widget? child) {
        return HRVCard(
          hrvLength: hrvLength,
          hrvGraphValues: ValueNotifier(<FlSpot>[]),
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
    );
  }

  Widget cameraCard() {
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
        ],
      ),
      height: 171.h,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.5.w),
        height: 135.h,
        width: MediaQuery.of(context).size.width - 13.w,
        child: _controller != null ? CameraPreview(_controller!) : Container(),
        // child: Chart(_data),
      ),
    );
  }

  void cameraMeasurementInfoDialog(bool showDontAskAgain) async {
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
                        height: 499.h,
                        width: 309.w,
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
                        padding: EdgeInsets.only(top: 27.h),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 26.w),
                                height: 25.h,
                                child: Body1AutoText(
                                  text: StringLocalization.of(context)
                                      .getText(StringLocalization.instruction),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                  minFontSize: 10,
                                  // maxLine: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                height: 273.h,
                                margin: EdgeInsets.symmetric(horizontal: 17.w),
                                child: Center(child: Image.asset(getInstructionImage(pageNo))),
                              ),
                              Container(
                                height: 90.h,
                                margin: EdgeInsets.symmetric(horizontal: 33.w),
                                child: Body1AutoText(
                                  text: getInstructionText(pageNo),
                                  maxLine: 4,
                                  fontSize: 14.sp,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                  minFontSize: 8,
                                  align: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  pageNo > 0
                                      ? GestureDetector(
                                          child: Container(
                                            height: 25.h,
                                            width: 50.w,
                                            child: Body1AutoText(
                                                text: stringLocalization
                                                    .getText(StringLocalization.backText),
                                                maxLine: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                                minFontSize: 10,
                                                color: HexColor.fromHex('#00AFAA'),
                                                align: TextAlign.right),
                                          ),
                                          onTap: () {
                                            pageNo--;
                                            if (this.mounted) {
                                              setState(() {});
                                            }
                                          },
                                        )
                                      : pageNo == 0 && showDontAskAgain
                                          ? GestureDetector(
                                              child: Container(
                                                height: 25.h,
                                                width: 160.w,
                                                child: Body1AutoText(
                                                  text: stringLocalization
                                                      .getText(StringLocalization.doNotAskAgain),
                                                  maxLine: 1,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                  minFontSize: 10,
                                                  color: HexColor.fromHex('#00AFAA'),
                                                  align: TextAlign.right,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context, rootNavigator: true).pop();
                                                preferences?.setBool(
                                                    Constants
                                                        .doNotAskMeAgainForCameraMeasurementDialog,
                                                    true);
                                              },
                                            )
                                          : Container(),
                                  SizedBox(
                                    width: pageNo == 0 ? 28.w : 42.w,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 25.h,
                                      width: 50.w,
                                      child: Body1AutoText(
                                        text: pageNo < 2
                                            ? stringLocalization.getText(StringLocalization.next)
                                            : stringLocalization.getText(StringLocalization.done),
                                        maxLine: 1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        minFontSize: 10,
                                        color: HexColor.fromHex('#00AFAA'),
                                      ),
                                    ),
                                    onTap: pageNo < 2
                                        ? () {
                                            pageNo++;
                                            if (this.mounted) {
                                              setState(() {});
                                            }
                                          }
                                        : () {
                                            pageNo = 0;
                                            Navigator.of(context, rootNavigator: true).pop();
                                          },
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ])));
              });
            },
            barrierDismissible: false)
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String getInstructionText(int pageNo) {
    switch (pageNo) {
      case 0:
        return StringLocalization.of(context)
            .getText(StringLocalization.camMeasurementInstruction1);
      case 1:
        return StringLocalization.of(context)
            .getText(StringLocalization.camMeasurementInstruction2);
      case 2:
        return StringLocalization.of(context)
            .getText(StringLocalization.camMeasurementInstruction3);
      default:
        return StringLocalization.of(context)
            .getText(StringLocalization.camMeasurementInstruction1);
    }
  }

  String getInstructionImage(int pageNo) {
    switch (pageNo) {
      case 0:
        return Theme.of(context).brightness == Brightness.dark
            ? 'asset/instruction1_dark.png'
            : 'asset/instruction1.png';
      case 1:
        return Theme.of(context).brightness == Brightness.dark
            ? 'asset/instruction2_dark.png'
            : 'asset/instruction2.png';
      case 2:
        return Theme.of(context).brightness == Brightness.dark
            ? 'asset/instruction3_dark.png'
            : 'asset/instruction3.png';
      default:
        return Theme.of(context).brightness == Brightness.dark
            ? 'asset/instruction1_dark.png'
            : 'asset/instruction1.png';
    }
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    var now = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < _windowLen; i++)
      _data.insert(0, SensorValue(DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  onClickStop() {
    endTimePpg ??= DateTime.now().millisecondsSinceEpoch;
    measurementTimer?.cancel();
    measurementTimer = null;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    _timer?.cancel();
    if (mounted) {
      setState(() {});
    }
  }

  onClickStart() {
    startTimePpg = null;
    endTimePpg = null;
    ppgValueX = 0;
    ppgPointList = [];
    valuesForPpgGraph = [];
    measurementTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if ((t.tick) >= 60) {
        t.cancel();
        measurementTimer = null;
        onClickStop();
        postMeasurementData();
      }
    });

    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
        if (mounted && _image != null) {
          _scanImage(_image!);
        }
      });
      _updateBPM();
    });
  }

  Widget measurementCard() {
    /*String hrv = '0';
    if(_bpm != null){
      hrv = '$_bpm';
    }*/
    return Container(
      margin: EdgeInsets.only(top: 18.h),
      width: 265.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 61.h,
              width: 90.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E5E5E5'),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white.withOpacity(0.9),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4.w, -4.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(4.w, 4.h),
                    ),
                  ]),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
                    color: Colors.white,
                    gradient: Theme.of(context).brightness == Brightness.dark
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                                HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                              ])
                        : RadialGradient(colors: [
                            HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                            HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                          ], stops: [
                            0.4,
                            1
                          ])),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 6.h,
                    ),
                    SizedBox(
                      height: 25.h,
                      // child: AutoSizeText(
                      //   '$currentHeartRate',
                      //   style: TextStyle(
                      //     color: Theme.of(context).brightness == Brightness.dark
                      //         ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                      //         : HexColor.fromHex('#384341'),
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 20.sp,
                      //   ),
                      //   textAlign: TextAlign.center,
                      //   maxLines: 1,
                      //   minFontSize: 8,
                      // ),
                      child: Body1AutoText(
                        text: '${currentHeartRate}',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        minFontSize: 8,
                        align: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: SizedBox(
                        height: 19.h,
                        child: Body1AutoText(
                          align: TextAlign.center,
                          maxLine: 1,
                          text: StringLocalization.of(context).getText(StringLocalization.hr),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68'),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*Expanded(
            child: Container(
              height: 64.h,
              width: 90.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E5E5E5'),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white.withOpacity(0.9),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4.w, -4.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(4.w, 4.h),
                    ),
                  ]),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    gradient: Theme.of(context).brightness == Brightness.dark
                        ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          HexColor.fromHex('#CC0A00').withOpacity(0.15),
                          HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                        ])
                        : RadialGradient(colors: [
                      HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                      HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                    ], stops: [
                      0.4,
                      1
                    ])),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      '$currentHeartRate',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Body1AutoText(
                        align: TextAlign.center,
                        maxLine: 3,
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.hr)+' ppg',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                            : HexColor.fromHex('#5D6A68'),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 64.h,
              width: 90.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E5E5E5'),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white.withOpacity(0.9),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4.w, -4.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(4.w, 4.h),
                    ),
                  ]),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    gradient: Theme.of(context).brightness == Brightness.dark
                        ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          HexColor.fromHex('#CC0A00').withOpacity(0.15),
                          HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                        ])
                        : RadialGradient(colors: [
                      HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                      HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                    ], stops: [
                      0.4,
                      1
                    ])),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      '$currentHRV',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Body1AutoText(
                        align: TextAlign.center,
                        maxLine: 3,
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.hrv),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                            : HexColor.fromHex('#5D6A68'),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so 'exact' regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_timer?.isActive ?? false) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (var i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold && _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 * 1000 / (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
        if (Platform.isAndroid) {
          if (this._bpm < 221) {
            currentHeartRate = this._bpm;
          }
        }
        if (mounted) {
          setState(() {});
        }
      }
      await Future.delayed(
          Duration(milliseconds: 1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }

  ValueNotifier<DateTime> ppgLastRecordDate = ValueNotifier(DateTime.now());
  ValueNotifier<int> ppgStartTime = ValueNotifier(0);
  ValueNotifier<int> ppgEndTime = ValueNotifier(0);

  /*void onGetPpgFromE66(PpgInfoReadingModel ppgInfoReadingModel) {
    if (!(_timer?.isActive ?? false)) {
      return;
    }
    print('onGetPpgFromE66 ${ppgInfoReadingModel.pointList}');

    dashBoardGlobalKey.currentState?.lastDataFetchedTime = DateTime.now();
    ppgLastRecordDate.value = DateTime.now();
    var pointsInSec = 84;
    // var noOfSeconds = 60;
    // var noOfSeconds = 30;
    var noOfSeconds = 60;
    var seconds = (ppgXValue.value / pointsInSec);
    try {
      ppgStartTime.value = DateTime.now().millisecondsSinceEpoch;
      if (seconds < noOfSeconds) {
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
  }*/

  ValueNotifier<int> ppgLength = ValueNotifier(0);
  ValueNotifier<List<int>> ppgPList = ValueNotifier([]);
  ValueNotifier<List<SensorValue>> sensorPList = ValueNotifier([]);
  ValueNotifier<List<Entry>> ppgGraphValues = ValueNotifier([]);
  ValueNotifier<num> zoomLevelPPG = ValueNotifier<num>(1);

  num applyRealTimeFilter(num y) {
    y = butterworth.filter(y.toDouble());
    y = butterWorthLowPass.filter(y.toDouble());
    return y;
  }

  List<int> extractPPGPoints(CameraImage cameraImage) {
    // Placeholder for PPG extraction logic
    // Replace this with your PPG extraction algorithm
    // This is a basic example that averages the red channel intensity

    var width = cameraImage.width;
    var height = cameraImage.height;
    var sumIntensity = 0.0;
    var tempPoints = <int>[];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int pixelColor = cameraImage.planes[0].bytes[y * width + x];
        int redChannel = pixelColor; // Assuming grayscale image
        tempPoints.add(redChannel);
      }
    }

    print('PPG Points: total : $tempPoints');
    return tempPoints;


    var totalPixels = width * height;
    var averageIntensity = sumIntensity / totalPixels;
    return [averageIntensity.toInt() * -100000];
  }

  void _scanImage(CameraImage image) {
    // Extract PPG points from the camera frame
    var ppgPoints = extractPPGPoints(image);

    // Do something with the PPG points (e.g., update UI, store data)
    print("PPG Points: $ppgPoints");
    // butterWorthLowPass.lowPass(1, 30, 100);
    // butterWorthLowPass.lowPass(1, 30, 100);
    // var _now = DateTime.now();
    // var _bytes = image.planes.first.bytes;
    // var _avg = _bytes.reduce((value, element) => value + element) / _bytes.length;
    // print('_scanImage :: image :: $_avg');
    // if (sensorPList.value.length >= _windowLen) {
    //   sensorPList.value.removeAt(0);
    // }
    // sensorPList.value.add(
    //   SensorValue(_now, 255 - _avg),
    // );
    // sensorPList.notifyListeners();
    // ppgValueX++;
    // ppgPList.value.addAll(ppgPoints);
    // ppgLength.value = ppgPList.value.length;
    // for (var y in ppgPoints) {
    //   var entry = Entry(
    //     x: ppgValueX,
    //     y: (applyRealTimeFilter(y) + 0.0) * -1,
    //     data: measurementTimer?.tick ?? 0,
    //   );
    //   ppgGraphValues.value.add(entry);
    // }
    // var hrvValue = getHrvFromPPG(valuesForPpgGraph);
    // var hrv = hrvValue.toInt();
    // print('graphHRV :: hrv :: HRV :: $hrv');
    // // if (mTimer.value!.tick % 2 == 0) {
    // hrvGraphValues.value.add(ChartSampleData(x: _timer!.tick, y: hrv));
    // hrvLength.value = hrvGraphValues.value.length;
    // // }
    // hrvPointList.value.add(hrv);
    //
    // ppgGraphValues.notifyListeners();
    // hrvGraphValues.notifyListeners();
    // ppgLength.value += ppgGraphValues.value.length;
    // xValueFormatterPPG?.listOfEntry = ppgGraphValues.value;
    // setDataToPpgGraph();
    // controllerForPpgGraph?.setVisibleXRangeMaximum(200);
    // controllerForPpgGraph?.moveViewToX(ppgValueX);
    /*butterWorthLowPass.lowPass(1,30, 100);
    var _now = DateTime.now();
    startTimePpg ??= _now.millisecondsSinceEpoch;
    _avg = image.planes.first.bytes.reduce((value, element) => value + element) / image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    _data.add(SensorValue(_now, _avg??0));
    ppgValueX++;
    ppgPointList.add(_avg);

    var entry = Entry(
      x: ppgValueX,
      y: -(butterWorthLowPass.filter(_avg??0)),
      data: measurementTimer?.tick??0,
    );

    valuesForPpgGraph.add(entry);

    if (Platform.isIOS) {
      var hr;
      try {
         hr = ((60 / getHrFromPPG(valuesForPpgGraph)) * 1000).round();
      } on Exception catch (e) {
        LoggingService().printLog(message: e.toString(), tag: 'While getting HR in camera measurement screen');
      }
      if(hr <= 220) {
        currentHeartRate = hr;
      }
    }

    currentHRV = getHrvFromPPG(valuesForPpgGraph);

    setDataToPpgGraph();*/
  }

  Future<void> _initController() async {
    try {
      var isGranted = await Permission.camera.isGranted;
      if (!isGranted) {
        await Permission.camera.request();
      }
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller?.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller?.setFlashMode(FlashMode.torch);
      });
      _controller?.startImageStream((CameraImage image) {
        _image = image;
      });
    } on Exception {
      debugPrint('$Exception');
    }
  }

  Widget progressCard() {
    var countDown = 0;
    var limit = 60;
    try {
      if ((measurementTimer?.isActive ?? false) && (measurementTimer?.tick ?? 0) <= limit) {
        countDown = measurementTimer?.tick ?? 0;
      }
    } catch (e) {
      print(e);
    }
    print(' count down $countDown');
    return Container(
      height: 79.h,
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10.h),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.2)
                  : Colors.white.withOpacity(0.7),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4.w, -4.h),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(4.w, 4.h),
            ),
          ]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: Colors.white,
          gradient:
              LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#9F2DBC').withOpacity(0.15)
                : HexColor.fromHex('#FFDFDE').withOpacity(0.4),
            Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#9F2DBC').withOpacity(0.0)
                : HexColor.fromHex('#FFDFDE').withOpacity(0.0),
          ]),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    measuringText(),
                    // measuringText(),
                  ],
                ),
              ),
              countDownCircle(countDown, HexColor.fromHex('#FF6259')),
            ],
          ),
        ),
      ),
    );
  }

  Widget countDownCircle(int countDown, Color progressColor) {
    return Container(
      height: 54.h,
      width: 54.h,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A').withOpacity(0.1)
              : AppColor.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : Colors.white.withOpacity(0.7),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4.w, -4.h),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(4.w, 4.h),
            ),
          ]),
      child: Container(
        margin: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A').withOpacity(0.1)
              : HexColor.fromHex('#FFDFDE').withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: ConcaveDecoration(
              depression: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.h),
              ),
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.8),
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.4)
                    : Colors.white,
              ]),
          child: progressIndicator(countDown, progressColor),
        ),
      ),
    );
  }

  Widget progressIndicator(int countDown, Color progressColor) {
    var limit = 60;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return RotationTransition(
      turns: AlwaysStoppedAnimation((0 * 360 / 60) / 360),
      child: CustomPaint(
        painter: MyPainter(
          lineColor: isDarkMode ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
          completeColor: progressColor,
          completePercent:
              countDown == 0 ? (countDown / limit * 100) : (countDown / limit * 100) - 1,
          width: 8.w,
        ),
        child: Center(
          child: SizedBox(
            height: 25.h,
            // child: AutoSizeText(
            //   countDown.toString(),
            //   style: TextStyle(
            //       color: isDarkMode
            //           ? Colors.white.withOpacity(0.6)
            //           : HexColor.fromHex('#384341'),
            //       fontSize: 20.sp,
            //       fontWeight: FontWeight.bold),
            //   maxLines: 1,
            //   minFontSize: 10,
            // ),
            child: Body1AutoText(
              text: countDown.toString(),
              color: isDarkMode ? Colors.white.withOpacity(0.6) : HexColor.fromHex('#384341'),
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              minFontSize: 10,

              // maxLine: 1,
            ),
          ),
        ),
      ),
    );
  }

  ///Added by: Shahzad
  ///Added on: 02/11/2020
  ///this method is used to show circular loading screen
  OverlayEntry showOverlay(BuildContext context) {
    var overlayState = Overlay.of(context);
    var overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator()),
          color: Colors.black26,
        ),
      ),
    );
    overlayState?.insert(overlayEntry);
    return overlayEntry;
  }

  void initGraphControllers() {
    xValueFormatterPPG = XValueFormatter(controllerForPpgGraph);
    var desc = Description()..enabled = false;
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

  void setDataToPpgGraph() {
    if (controllerForPpgGraph != null) {
      var ppgDataSet = LineDataSet(ppgGraphValues.value, 'PpgDataSet 1');
      ppgDataSet.setColor1(HexColor.fromHex('#9F2DBC'));
      ppgDataSet.setLineWidth(2);
      ppgDataSet.setDrawValues(false);
      ppgDataSet.setDrawCircles(false);
      ppgDataSet.setMode(Mode.LINEAR);
      ppgDataSet.setDrawFilled(false);

      try {
        if (ppgDataSet.values == null) {
          ppgDataSet.setValues(ppgGraphValues.value);
        }
      } catch (e) {
        debugPrint('Error $e');
        LoggingService().warning('Measurement', 'Exception ', error: e);
      }

      setGraphColors();

      controllerForPpgGraph?.data = LineData.fromList([ppgDataSet]);
    }
  }

  void setGraphColors() {
    controllerForPpgGraph?.axisLeft?.enabled = false;
    controllerForPpgGraph?.axisRight?.enabled = false;
    controllerForPpgGraph?.xAxis?.textColor = Colors.transparent;
    controllerForPpgGraph?.infoBgColor = Colors.transparent;
    controllerForPpgGraph?.backgroundColor = Colors.transparent;
    controllerForPpgGraph?.highLightPerTapEnabled = false;
  }

  /*void setDataToPpgGraph() {
    if (controllerForPpgGraph != null) {
      try {
        xValueFormatterPPG!.listOfEntry = valuesForPpgGraph;
      } on Exception catch (e) {
        print(e);
      }

      var ppgDataSet = LineDataSet(valuesForPpgGraph, 'PpgDataSet 1');
      ppgDataSet.setColor1(HexColor.fromHex('#9F2DBC'));
      ppgDataSet.setLineWidth(0.8);
      ppgDataSet.setDrawValues(false);
      ppgDataSet.setDrawCircles(false);
      ppgDataSet.setMode(Mode.LINEAR);
      ppgDataSet.setDrawFilled(false);

      var ppgDataSet2 = LineDataSet(yListForThreshHolds, 'PpgDataSet 2');
      ppgDataSet2.setColor1(AppColor.red);
      ppgDataSet2.setLineWidth(0.8);
      ppgDataSet2.setDrawValues(false);
      ppgDataSet2.setDrawCircles(false);
      ppgDataSet2.setMode(Mode.LINEAR);
      ppgDataSet2.setDrawFilled(false);

      try {
        if (ppgDataSet2.values == null) {
          ppgDataSet2.setValues(yListForThreshHolds);
        }
      } on Exception catch (e) {
        LoggingService().printLog(tag: 'Camera measurement screen', message: e.toString());
      }

      controllerForPpgGraph?.gridBackColor = controllerForPpgGraph?.backgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor;
      controllerForPpgGraph?.backgroundColor = controllerForPpgGraph?.backgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor;
      controllerForPpgGraph?.backgroundColor = controllerForPpgGraph?.backgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor;
      controllerForPpgGraph?.drawMarkers = false;
      controllerForPpgGraph?.data = LineData.fromList([ppgDataSet]);
      if (controllerForPpgGraph?.axisLeft != null) {
        controllerForPpgGraph!.axisLeft!.enabled = false;
        controllerForPpgGraph!.axisLeft!.textColor = Colors.transparent;
      }

      try {
        controllerForPpgGraph?.setVisibleXRangeMaximum(100);
      } on Exception catch (e) {
        LoggingService().printLog(tag: 'Camera measurement screen', message: e.toString());
      }
      try {
        controllerForPpgGraph?.moveViewToX(ppgValueX);
      } on Exception catch (e) {
        LoggingService().printLog(tag: 'Camera measurement screen', message: e.toString());
      }

      controllerForPpgGraph?.xAxis?.textColor = HexColor.fromHex('#384341');

      if (mounted) {
        setState(() {});
      }
    }
  }*/

  Widget measuringText() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Display1Text(
        text: stringLocalization.getText((measurementTimer == null || !measurementTimer!.isActive)
            ? StringLocalization.startMeasurement
            : StringLocalization.goodSignal),
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#99D9D9')
            : HexColor.fromHex('#00AFAA'),
        fontSize: 16.sp,
      ),
    ]);
  }

  int getHrvFromPPG(List<Entry> ppgList) {
    try {
      var yList = <Entry>[];
      for (var i = 0; i < ppgList.length; i++) {
        if (i == 0) {
          if (ppgList[0].y != null && ppgList[1].y != null && ppgList[0].y! <= ppgList[1].y!) {
            yList.add(ppgList[0]);
          }
        } else if (ppgList[ppgList.length - 1].y != null &&
            ppgList[ppgList.length - 2].y != null &&
            i == (ppgList.length - 1)) {
          var lastItem = ppgList[ppgList.length - 1].y!;
          var lastSecondItem = ppgList[ppgList.length - 2].y!;

          if (lastItem <= lastSecondItem) {
            yList.add(ppgList[ppgList.length - 1]);
          }
        } else {
          if (ppgList[i].y != null && ppgList[i - 1].y != null && ppgList[i + 1].y != null) {
            var currentPoint = ppgList[i].y!;
            var previousPoint = ppgList[i - 1].y!;
            var nextPoint = ppgList[i + 1].y!;
            if (currentPoint <= previousPoint && currentPoint <= nextPoint) {
              yList.add(ppgList[i]);
            }
          }
        }
      }

      yList.sort((a, b) => a.y!.compareTo(b.y!));
      var seventyPercentData = (yList.length * 70) ~/ 100;
      var trashHoldPoints = <Entry>[];
      for (var i = 0; i < seventyPercentData; i++) {
        trashHoldPoints.add(yList[i]);
      }
      yList = trashHoldPoints;
      yList.sort((a, b) => a.x!.compareTo(b.x!));

      var sum = 0;

      var listOfMilliSeconds = yList.map((e) => (e.x! / 0.30).round()).toList();

      var durationDistance = <int>[];
      for (var i = 0; i < listOfMilliSeconds.length; i++) {
        if (i != listOfMilliSeconds.length - 1) {
          var distance = listOfMilliSeconds[i + 1] - listOfMilliSeconds[i];
          durationDistance.add(distance);

          sum = sum +
              ((listOfMilliSeconds[i] - listOfMilliSeconds[i + 1]) *
                  (listOfMilliSeconds[i] - listOfMilliSeconds[i + 1]));
        }
      }

      var hrv = sqrt(sum).round();

      return hrv;
    } catch (e) {
      print(e);
    }
    return 0;
  }

  int getHrFromPPG(List<Entry> ppgList) {
    try {
      var yList = <Entry>[];
      for (var i = 0; i < ppgList.length; i++) {
        if (i == 0) {
          if (ppgList[0].y != null && ppgList[1].y != null && ppgList[0].y! <= ppgList[1].y!) {
            yList.add(ppgList[0]);
          }
        } else if (ppgList[ppgList.length - 1].y != null &&
            ppgList[ppgList.length - 2].y != null &&
            i == (ppgList.length - 1)) {
          var lastItem = ppgList[ppgList.length - 1].y!;
          var lastSecondItem = ppgList[ppgList.length - 2].y!;

          if (lastItem <= lastSecondItem) {
            yList.add(ppgList[ppgList.length - 1]);
          }
        } else {
          if (ppgList[i].y != null && ppgList[i - 1].y != null && ppgList[i + 1].y != null) {
            var currentPoint = ppgList[i].y!;
            var previousPoint = ppgList[i - 1].y!;
            var nextPoint = ppgList[i + 1].y!;
            if (currentPoint <= previousPoint && currentPoint <= nextPoint) {
              yList.add(ppgList[i]);
            }
          }
        }
      }

      yList.sort((a, b) => b.y!.compareTo(a.y!));
      var seventyPercentData = (yList.length * 30) ~/ 100;
      var trashHoldPoints = <Entry>[];
      for (var i = 0; i < seventyPercentData; i++) {
        trashHoldPoints.add(yList[i]);
      }
      yList = trashHoldPoints;
      yList.sort((a, b) => a.x!.compareTo(b.x!));
      yListForThreshHolds = yList;

      var listOfMilliSeconds = yList.map((e) => (e.x! / 0.030).round()).toList();
      // print('ylist $listOfMilliSeconds');

      var durationDistance = <int>[];
      for (var i = 0; i < listOfMilliSeconds.length; i++) {
        if (i != listOfMilliSeconds.length - 1) {
          var distance = listOfMilliSeconds[i + 1] - listOfMilliSeconds[i];
          durationDistance.add(distance);
        }
      }

      durationDistance.sort((first, second) => second.compareTo(first));

      //  print('durationDistance List $durationDistance');

      List distinctList = durationDistance.toSet().toList();

      // print('distinct List $distinctList');

      var listOfCommonTime = [];

      distinctList.forEach((element) {
        listOfCommonTime.add(durationDistance.where((e) => e == element).toList());
      });

      //  print('list of list => $listOfCommonTime');

      var a =
          listOfCommonTime.reduce((current, next) => current.length > next.length ? current : next);
      var b =
          listOfCommonTime.reduce((current, next) => current.length < next.length ? current : next);

      listOfCommonTime.sort((a, b) => b.length.compareTo(a.length));

      var mostFirst3CommonNumberList = [];
      for (var i = 0; i < listOfCommonTime.length; i++) {
        if (listOfCommonTime.length > 3 && i < 3) {
          mostFirst3CommonNumberList.add(listOfCommonTime[i]);
        } else if (listOfCommonTime.length <= 3) {
          mostFirst3CommonNumberList.add(listOfCommonTime[i]);
        }
      }

      //  print('most common 3 List $mostFirst3CommonNumberList');

      var lst = mostFirst3CommonNumberList.map((e) => e[0]).toList();

      var smallestHr = lst.reduce((current, next) {
        print('$current, $next');
        return current > next ? current : next;
      });

      //  print('smallestHr $smallestHr');

      int smallestHR = smallestHr;
      /*try {
        for(int i=0;i<distinctList.length;i++){
          if(i == 0){
            smallestHR = distinctList[i];
          }
          if(smallestHR < distinctList[i]){
            smallestHR = distinctList[i];
          }
        }
      } catch (e) {
        print(e);
      }
*/

      if (this.mounted) {
        setState(() {});
      }

      // return a.first;
      return smallestHR;
    } catch (e) {
      print(e);
    }
    return 1;
  }

  Future postMeasurementData() async {
    var hr = 0;
    var sbp = 0;
    var dbp = 0;

    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    try {
      var recordId = await saveMeasurementDataToLocalStorage(
        trainingHr: _bpm,
        trainingDBP: 0,
        trainingSBP: 0,
        isCalibration: false,
        isSync: false,
      );
      var isInternet = await Constants.isInternetAvailable();
      if (userId != null && userId!.isNotEmpty && !userId!.contains('Skip') && isInternet) {
        var isOscillates = preferences?.getBool(Constants.isOscillometricEnableKey) ?? false;
        if (isOscillates) {
          await showCalibrationDialog(
            onClickOk: () {
              focusNodeDbp.unfocus();
              Navigator.of(context, rootNavigator: true).pop();
              hr = int.parse(hrCalibrationTextEditController.text);
              sbp = int.parse(sbpCalibrationTextEditController.text);
              dbp = int.parse(dbpCalibrationTextEditController.text);
            },
          );
        }
        var isGlucoseData = preferences?.getBool(Constants.isGlucoseData) ?? false;
        var IsResearcher = globalUser!.isResearcherProfile! && isGlucoseData;
        print('IsResearcher ${IsResearcher}');
        // entry = showOverlay(context);
        var map = {
          'birthdate': '',
          'data': [
            {
              'bg_manual': 0,
              'demographics': {
                'age': calculateAge(globalUser?.dateOfBirth ?? DateTime.now()),
                'gender': globalUser?.gender ?? '',
                'height': calculateHeight(globalUser?.height ?? ''),
                'weight': calculateWeight(double.parse(globalUser?.weight ?? ''))
              },
              'device_id': '',
              'device_type': '',
              'dias_healthgauge': 0,
              'o2_manual': 0,
              'schema': '',
              'sys_healthgauge': 0,
              'username': '',
              'model_id': 'PROTO_1',
              'isAISelected': preferences!.getBool(Constants.isAISelected) ?? false,
              'IsResearcher': IsResearcher,
              'userID': userId,
              'raw_ecg': [],
              'raw_ppg': ppgPointList,
              'raw_times': [], //todo this is remaining
              'hrv_device': currentHeartRate,
              'dias_device': 0,
              'hr_device': 0,
              'sys_device': 0,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'sys_manual': sbp,
              'dias_manual': dbp,
              'hr_manual': hr,
              'ecg_elapsed_time': [startTimePpg, endTimePpg],
              'ppg_elapsed_time': [startTimePpg, endTimePpg],
              'IsCalibration': false,
              'isForTimeBasedPpg': false,
              'isForTraining': false,
              'isForOscillometric': isOscillates,
              'IsFromCamera': true,
            }
          ]
        };

        Constants.progressDialog(true, context);
        var estimatedResult;
        try {
          estimatedResult =
              await MeasurementRepository().getEstimate(AddMeasurementRequest.fromJson(map));
          var value = 0;
          if (estimatedResult.hasData) {
            //Constants.progressDialog(false, context);
            if (estimatedResult.getData!.value != null &&
                estimatedResult.getData!.value is List &&
                estimatedResult.getData!.value[0] != null &&
                estimatedResult.getData!.value[0] is int) {
              value = estimatedResult.getData!.value[0];
            } else if (estimatedResult.getData!.value != null &&
                estimatedResult.getData!.value is int) {
              value = estimatedResult.getData!.value;
            } else if (estimatedResult.getData!.iD != null && estimatedResult.getData!.iD is int) {
              value = estimatedResult.getData!.iD!;
            }
          } else {
            //Constants.progressDialog(false, context);
          }
          recordId = await saveMeasurementDataToLocalStorage(
            trainingHr: 0,
            trainingDBP: 0,
            trainingSBP: 0,
            isSync: true,
            apiId: value,
            recordId: recordId,
            isCalibration: false,
          );
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          print(e);
          if (mounted) {
            setState(() {});
          }
        } finally {
          Constants.progressDialog(false, context);
        }

        if (isOscillates) {
          var str = await showEstimationResult(
            HR: currentHeartRate,
            result: {
              'ID': estimatedResult.hasData ? estimatedResult.getData?.iD ?? 0 : 0,
              'Sys': estimatedResult.hasData ? estimatedResult.getData?.sBP ?? 0 : 0,
              'Dia': estimatedResult.hasData ? estimatedResult.getData?.dBP ?? 0 : 0,
              'BG': estimatedResult.hasData ? estimatedResult.getData?.BG ?? 0 : 0,
              'BG1': estimatedResult.hasData ? estimatedResult.getData?.BG1 ?? 0 : 0,
            },
            isOs: true,
            IsResearcher: IsResearcher,
          );
        }
        // await PostMeasurementData()
        //     .callApi(Constants.baseUrl + 'estimate', jsonEncode(map))
        //     .then((result) async {
        //   Constants.progressDialog(false, context);
        //   //  if (!result['isError']) {
        //   try {
        //     int value = 0;
        //     if (result['value'] is List && result['value'][0] is int) {
        //       value = result['value'][0];
        //     }
        //     if (result['value'] is int) {
        //       value = result['value'];
        //     }
        //
        //     if (result is Map && result['ID'] != null && result['ID'] is int) {
        //       value = result['ID'];
        //     }
        //     recordId = await saveMeasurementDataToLocalStorage(
        //       trainingHr: 0,
        //       trainingDBP: 0,
        //       trainingSBP: 0,
        //       isSync: true,
        //       apiId: value,
        //       recordId: recordId,
        //       isCalibration: false,
        //     );
        //     if (mounted) {
        //       setState(() {});
        //     }
        //   } catch (e) {
        //     print(e);
        //     if (mounted) {
        //       setState(() {});
        //     }
        //   }
        //
        //   if (isOscillates) {
        //     var str = await showEstimationResult(
        //         HR: currentHeartRate,
        //         result: result,
        //         isOs: true,
        //     );
        //   }
        //
        //   return;
        // });
      }
    } catch (e) {
      print(e);
    }
  }

  Future showEstimationResult(
      {required int HR,
      required Map<dynamic, dynamic> result,
      required bool isOs,
      required bool IsResearcher}) {
    var dialog = Dialog(
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
                  ? HexColor.fromHex('#111B1A')
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
          padding: EdgeInsets.only(top: 27.h, left: 16.w, right: 10.w),
          width: 309.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                    height: 25.h,
                    child: AutoSizeText(
                      'Result',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                    )),
                SizedBox(
                    height: 25.h,
                    child: AutoSizeText(
                      'Device data',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                    )),
                SizedBox(height: 15.0.h),
                SizedBox(
                  height: 25.h,
                  child: AutoSizeText(
                    'HR : $HR',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                ),
                SizedBox(height: 15.0.h),
                userData(),
                SizedBox(height: 15.0.h),
                SizedBox(
                    height: 25.h,
                    child: AutoSizeText(
                      'AI Estimate data',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                    )),
                SizedBox(height: 15.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 25.h,
                        child: AutoSizeText(
                          'Sys: ${result['Sys']}',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                        )),
                    SizedBox(
                        height: 25.h,
                        child: AutoSizeText(
                          'Dia: ${result['Dia']}',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                        )),
                  ],
                ),
                IsResearcher ? glucoseData(result) : Container(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      hrCalibrationTextEditController.clear();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Container(
                      height: 25.h,
                      width: 50.w,
                      child: AutoSizeText(
                        stringLocalization.getText(StringLocalization.ok).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: HexColor.fromHex('#00AFAA'),
                        ),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                )
              ],
            ),
          ),
        ));
    return showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  Widget glucoseData(Map<dynamic, dynamic> result) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.0.h),
        SizedBox(
            height: 25.h,
            child: AutoSizeText(
              'AI Glucose Data',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              maxLines: 1,
              minFontSize: 8,
            )),
        SizedBox(height: 15.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                height: 25.h,
                child: AutoSizeText(
                  'BG: ${result['BG']}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                  ),
                  maxLines: 1,
                  minFontSize: 8,
                )),
          ],
        ),
      ],
    );
  }

  showCalibrationDialog({required GestureTapCallback onClickOk}) async {
    await showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              var focusNodeHr = FocusNode();
              var focusNodeSbp = FocusNode();
              focusNodeDbp = FocusNode();
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
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10.h),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : HexColor.fromHex('#DDE3E3').withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5, -5),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#000000').withOpacity(0.75)
                              : HexColor.fromHex('#7F8D8C'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                  padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w, bottom: 20.h),
                  width: 309.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SizedBox(
                          height: 25.h,
                          child: Body1AutoText(
                            text: StringLocalization.of(context)
                                .getText(StringLocalization.oscillometric),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            minFontSize: 12,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 5.h,
                          ),
                          width: 309.w,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: SizedBox(
                                  height: 58.h,
                                  child: Body1AutoText(
                                      text: StringLocalization.of(context)
                                          .getText(StringLocalization.shortDescription),
                                      maxLine: 2,
                                      fontSize: 16.sp,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                          : HexColor.fromHex('#384341')),
                                ),
                              ),
                              Container(
                                  height: 48.h,
                                  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                              : Colors.white.withOpacity(0.7),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(-4, -4),
                                        ),
                                        BoxShadow(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black.withOpacity(0.75)
                                              : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(4, 4),
                                        ),
                                      ]),
                                  child: GestureDetector(
                                    onTap: () {
                                      openKeyboardHr = true;

                                      focusNodeHr.requestFocus();
                                      //FocusScope.of(context).requestFocus(focusNodeHr);
                                      setState(() {});
                                    },
                                    child: Container(
                                        decoration: openKeyboardHr
                                            ? ConcaveDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.h)),
                                                depression: 10,
                                                colors: [
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.black.withOpacity(0.5)
                                                        : HexColor.fromHex('#D1D9E6'),
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? HexColor.fromHex('#D1D9E6')
                                                            .withOpacity(0.07)
                                                        : Colors.white,
                                                  ])
                                            : BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                color:
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? HexColor.fromHex('#111B1A')
                                                        : AppColor.backgroundColor,
                                              ),
                                        child: IgnorePointer(
                                          child: TextFormField(
                                            autofocus: openKeyboardHr,
                                            focusNode: focusNodeHr,
                                            controller: hrCalibrationTextEditController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 16.w, bottom: 11.h, top: 11.h, right: 16.w),
                                              hintText: errorMessageForHeart.isNotEmpty
                                                  ? errorMessageForHeart
                                                  : StringLocalization.of(context)
                                                      .getText(StringLocalization.hr),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: errorMessageForHeart.isNotEmpty
                                                      ? HexColor.fromHex('FF6259')
                                                      : HexColor.fromHex('7F8D8C')),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            // Only number
                                            keyboardType: TextInputType.number,
                                            maxLines: 1,
                                          ),
                                        )),
                                  )),
                              Container(
                                  // height: 48.h,
                                  margin: EdgeInsets.only(top: 17.h, left: 10.w, right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                              : Colors.white.withOpacity(0.7),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(-4, -4),
                                        ),
                                        BoxShadow(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black.withOpacity(0.75)
                                              : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(4, 4),
                                        ),
                                      ]),
                                  child: GestureDetector(
                                    onTap: () {
                                      openKeyboardSbp = true;
                                      openKeyboardHr = false;
                                      openKeyboardDbp = false;
                                      focusNodeSbp.requestFocus();
                                      // FocusScope.of(context).requestFocus(focusNodeSbp);
                                      setState(() {});
                                    },
                                    child: Container(
                                        decoration: openKeyboardSbp
                                            ? ConcaveDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.h)),
                                                depression: 10,
                                                colors: [
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.black.withOpacity(0.5)
                                                        : HexColor.fromHex('#D1D9E6'),
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? HexColor.fromHex('#D1D9E6')
                                                            .withOpacity(0.07)
                                                        : Colors.white,
                                                  ])
                                            : BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(10.h)),
                                                color:
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? HexColor.fromHex('#111B1A')
                                                        : AppColor.backgroundColor,
                                              ),
                                        child: IgnorePointer(
                                          ignoring: openKeyboardSbp ? false : true,
                                          child: TextFormField(
                                            autofocus: openKeyboardSbp,
                                            focusNode: focusNodeSbp,
                                            controller: sbpCalibrationTextEditController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 16.w, bottom: 11.h, top: 11.h, right: 16.w),
                                              hintText: errorMessageForSBP.isNotEmpty
                                                  ? errorMessageForSBP
                                                  : StringLocalization.of(context)
                                                      .getText(StringLocalization.sbd),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: errorMessageForSBP.isNotEmpty
                                                      ? HexColor.fromHex('FF6259')
                                                      : HexColor.fromHex('7F8D8C')),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            // Only number
                                            keyboardType: TextInputType.number,
                                            maxLines: 1,
                                          ),
                                        )),
                                  )),
                              Container(
                                  // height: 48.h,
                                  margin: EdgeInsets.only(top: 17.h, left: 10.w, right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                              : Colors.white.withOpacity(0.7),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(-4, -4),
                                        ),
                                        BoxShadow(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black.withOpacity(0.75)
                                              : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(4, 4),
                                        ),
                                      ]),
                                  child: GestureDetector(
                                    onTap: () {
                                      openKeyboardDbp = true;
                                      openKeyboardHr = false;
                                      openKeyboardSbp = false;
                                      focusNodeDbp.requestFocus();
                                      //FocusScope.of(context).requestFocus(focusNodeDbp);
                                      setState(() {});
                                    },
                                    child: Container(
                                        decoration: openKeyboardDbp
                                            ? ConcaveDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.h)),
                                                depression: 10,
                                                colors: [
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.black.withOpacity(0.5)
                                                        : HexColor.fromHex('#D1D9E6'),
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? HexColor.fromHex('#D1D9E6')
                                                            .withOpacity(0.07)
                                                        : Colors.white,
                                                  ])
                                            : BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(10.h)),
                                                color:
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? HexColor.fromHex('#111B1A')
                                                        : AppColor.backgroundColor,
                                              ),
                                        child: IgnorePointer(
                                          ignoring: openKeyboardDbp ? false : true,
                                          child: TextFormField(
                                            autofocus: openKeyboardDbp,
                                            focusNode: focusNodeDbp,
                                            controller: dbpCalibrationTextEditController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 16.w, bottom: 11.h, top: 11.h, right: 16.w),
                                              hintText: errorMessageForDBP.isNotEmpty
                                                  ? errorMessageForDBP
                                                  : StringLocalization.of(context)
                                                      .getText(StringLocalization.dbp),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: errorMessageForDBP.isNotEmpty
                                                      ? HexColor.fromHex('FF6259')
                                                      : HexColor.fromHex('7F8D8C')),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            // Only number
                                            keyboardType: TextInputType.number,
                                            maxLines: 1,
                                          ),
                                        )),
                                  )),
                              SizedBox(
                                height: 25.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          height: 34.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30.h),
                                              color: HexColor.fromHex('#FF6259').withOpacity(0.8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                                      : Colors.white,
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                  offset: Offset(-5, -5),
                                                ),
                                                BoxShadow(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? Colors.black.withOpacity(0.75)
                                                      : HexColor.fromHex('#D1D9E6'),
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                  offset: Offset(5, 5),
                                                ),
                                              ]),
                                          child: Container(
                                            decoration: ConcaveDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.h),
                                                ),
                                                depression: 10,
                                                colors: [
                                                  Colors.white,
                                                  HexColor.fromHex('#D1D9E6'),
                                                ]),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                child: AutoSizeText(
                                                  StringLocalization.of(context)
                                                      .getText(StringLocalization.cancel)
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex('#111B1A')
                                                        : Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  minFontSize: 6,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          errorMessageForHeart = '';
                                          hrCalibrationTextEditController.text = '';
                                          openKeyboardHr = false;
                                          isCancelClicked = true;
                                          Navigator.of(context, rootNavigator: true).pop();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 11.w),
                                    Expanded(
                                      child: GestureDetector(
                                          child: Container(
                                            height: 34.h,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30.h),
                                                color: HexColor.fromHex('#00AFAA'),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex('#D1D9E6')
                                                            .withOpacity(0.1)
                                                        : Colors.white,
                                                    blurRadius: 5,
                                                    spreadRadius: 0,
                                                    offset: Offset(-5, -5),
                                                  ),
                                                  BoxShadow(
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.black.withOpacity(0.75)
                                                        : HexColor.fromHex('#D1D9E6'),
                                                    blurRadius: 5,
                                                    spreadRadius: 0,
                                                    offset: Offset(5, 5),
                                                  ),
                                                ]),
                                            child: Container(
                                              decoration: ConcaveDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.h),
                                                  ),
                                                  depression: 10,
                                                  colors: [
                                                    Colors.white,
                                                    HexColor.fromHex('#D1D9E6'),
                                                  ]),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                  child: AutoSizeText(
                                                    StringLocalization.of(context)
                                                        .getText(StringLocalization.add)
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#111B1A')
                                                          : Colors.white,
                                                    ),
                                                    maxLines: 1,
                                                    minFontSize: 6,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            var validate = true;
                                            if (hrCalibrationTextEditController.text == '') {
                                              errorMessageForHeart = 'Enter Heart Rate';
                                              validate = false;
                                            }

                                            if (hrCalibrationTextEditController.text.length > 3) {
                                              errorMessageForHeart = 'Enter valid Heart Rate';
                                              hrCalibrationTextEditController.text = '';
                                              validate = false;
                                            }

                                            if (sbpCalibrationTextEditController.text == '') {
                                              errorMessageForSBP = 'Enter SBP';
                                              validate = false;
                                            }
                                            if (dbpCalibrationTextEditController.text == '') {
                                              errorMessageForDBP = 'Enter DBP';
                                              validate = false;
                                            }
                                            try {
                                              if (hrCalibrationTextEditController.text.length > 3 ||
                                                  int.parse(hrCalibrationTextEditController.text) <
                                                      10) {
                                                errorMessageForHeart = 'Enter valid Heart Rate';
                                                hrCalibrationTextEditController.text = '';
                                                validate = false;
                                              }
                                            } catch (e) {}
                                            try {
                                              if (sbpCalibrationTextEditController.text.length >
                                                      3 ||
                                                  int.parse(sbpCalibrationTextEditController.text) <
                                                      10) {
                                                errorMessageForSBP = 'Enter valid SBP';
                                                sbpCalibrationTextEditController.text = '';
                                                validate = false;
                                              }
                                            } catch (e) {}
                                            try {
                                              if (dbpCalibrationTextEditController.text.length >
                                                      3 ||
                                                  int.parse(dbpCalibrationTextEditController.text) <
                                                      10) {
                                                errorMessageForDBP = 'Enter valid DBP';
                                                dbpCalibrationTextEditController.text = '';
                                                validate = false;
                                              }
                                            } catch (e) {}

                                            setState(() {});
                                            if (validate) {
                                              openKeyboardHr = false;
                                              onClickOk();
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        barrierDismissible: false);
  }

  Widget userData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 25.h,
            child: AutoSizeText(
              'Data entered by user',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              maxLines: 1,
              minFontSize: 8,
            )),
        SizedBox(height: 15.0.h),
        SizedBox(
          height: 25.h,
          child: AutoSizeText(
            'HR : ${hrCalibrationTextEditController.text}',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            maxLines: 1,
            minFontSize: 8,
          ),
        ),
      ],
    );
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
    if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
      // return (weight ~/ 2.205);
      return (weight ~/ 2.20462);
    } else {
      return weight.toInt();
    }
  }

  calculateHeight(String height) {
    if (UnitExtension.getUnitType(heightUnit) == UnitTypeEnum.imperial) {
      var feet = int.parse(height.split('.')[0]);
      var inch = int.parse(height.split('.')[1]);
      if (inch > 12) {
        inch = int.parse(height.split('.')[1][0]);
      }
      var inches = feet * 12;
      inches = inches + inch;
      return (inches * 2.54).toInt();
    } else {
      return double.parse(height).toInt();
    }
  }

  Future saveMeasurementDataToLocalStorage({
    bool? isSync,
    int? trainingHr,
    int? trainingSBP,
    int? trainingDBP,
    int? apiId,
    int? recordId,
    int? aiSBP,
    int? aiDBP,
    bool? isCalibration,
  }) async {
    //region point string
    var strEcgList = '';
    var strPpgList = '';
    for (double value in ppgPointList) {
      strEcgList += value.toString() + ',';
    }
    if (strEcgList.isNotEmpty) {
      strEcgList = strEcgList.substring(0, strEcgList.length - 1);
    }

    for (double value in ppgPointList) {
      strPpgList += value.toString() + ',';
    }
    if (strPpgList.isNotEmpty) {
      strPpgList = strPpgList.substring(0, strPpgList.length - 1);
    }
    //endregion

    var map = Map<String, dynamic>();
    if (userId == null) {
      return Future.value();
    }
    var ecgInfoModel = EcgInfoReadingModel();
    ecgInfoModel.startTime = startTimePpg;
    ecgInfoModel.endTime = endTimePpg;
    ecgInfoModel.approxHr = _bpm;
    map = ecgInfoModel.toMap();
    map['ppgValue'] = ppgPointList.last;
    map['user_Id'] = userId;
    map['date'] = DateTime.now().toString();
    map['ecg'] = strEcgList;
    map['ppg'] = strPpgList;
    map['tHr'] = trainingHr;
    map['tSBP'] = trainingSBP;
    map['tDBP'] = trainingDBP;
    map['aiSBP'] = aiSBP ?? 0;
    map['aiDBP'] = aiDBP ?? 0;
    map['IsSync'] = isSync;
    map['IsCalibration'] = isCalibration ?? false;
    map['isForTraining'] = false;
    map['isForOscillometric'] = false;
    map['isFromCamera'] = true;

    if (apiId != null) {
      map['IdForApi'] = apiId;
    }
    if (recordId != null) {
      map['id'] = recordId;
    }
    var result = await dbHelper.insertMeasurementData(map, userId ?? '');
    print('recordId $result');
    return result;
  }
}

class Chart extends StatelessWidget {
  final List<SensorValue> _data;

  Chart(this._data);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart([
      charts.Series<SensorValue, DateTime>(
        id: 'Values',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (SensorValue values, _) => values.time,
        measureFn: (SensorValue values, _) => values.value,
        data: _data,
      )
    ],
        animate: false,
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
          renderSpec: charts.NoneRenderSpec(),
        ),
        domainAxis: charts.DateTimeAxisSpec(renderSpec: charts.NoneRenderSpec()));
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}

class ChartSampleData{

}
