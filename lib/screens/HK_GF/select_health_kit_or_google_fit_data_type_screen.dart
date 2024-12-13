import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/HK_GF/health_kit_or_google_fit_data_screen.dart';
import 'package:health_gauge/screens/HK_GF/helper_widgets/select_type_item.dart';
import 'package:health_gauge/screens/HK_GF/hk_gf_helper.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectHealthKitOrGoogleFitDataTypeScreen extends StatefulWidget {
  final Map<String, dynamic> mapData;

  const SelectHealthKitOrGoogleFitDataTypeScreen({this.mapData = const {}});

  @override
  _SelectHealthKitOrGoogleFitDataTypeScreenState createState() =>
      _SelectHealthKitOrGoogleFitDataTypeScreenState(
        startDate: mapData['startDate'],
        endDate: mapData['endDate'],
        isFetch: mapData['isFetch'],
      );
}

class _SelectHealthKitOrGoogleFitDataTypeScreenState
    extends State<SelectHealthKitOrGoogleFitDataTypeScreen> {
  final String startDate;
  final String endDate;
  final bool isFetch;

  _SelectHealthKitOrGoogleFitDataTypeScreenState({
    required this.startDate,
    required this.endDate,
    required this.isFetch,
  });

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    var isAuthenticated = await HKGFHelper.instance.checkAuthentication();
    if (isAuthenticated && isFetch) {
      HKGFHelper.instance.fetchAllData(startDate, endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            centerTitle: true,
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
              'Select Type',
              style: TextStyle(
                  color: HexColor.fromHex('62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perWeight,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.weight, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perHeartRate,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.heartRate, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perSBP,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.sysBP, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perDBP,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.diaBP, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perDistance,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.distance, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perSleep,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.sleep, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perStep,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.step, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perBG,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.bloodGlucose, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perTemperature,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.temperature, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perOxygen,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.oxygen, progress: value);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.perActiveCalorie,
                  builder: (BuildContext context, double value, Widget? child) {
                    return SelectTypeItem(vital: Vital.activeCalorie, progress: value);
                  },
                ),
                if (Platform.isIOS) ...[
                  ValueListenableBuilder(
                    valueListenable: HKGFHelper.instance.perRestingCalorie,
                    builder: (BuildContext context, double value, Widget? child) {
                      return SelectTypeItem(vital: Vital.restingCalorie, progress: value);
                    },
                  ),
                ]
              ],
            ).toList(),
          ),
        ),
      ),
    );
  }
}
