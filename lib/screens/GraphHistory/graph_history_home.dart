import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/screens/GraphHistory/HelperWidgets/bp_area_graph.dart';
import 'package:health_gauge/screens/GraphHistory/HelperWidgets/bp_error_graph.dart';
import 'package:health_gauge/screens/GraphHistory/HelperWidgets/graph_history_appbar.dart';
import 'package:health_gauge/screens/GraphHistory/graph_history_helper.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/app_tab_bar.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/HelperWidgets/ot_graph_widget.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/vital_helpers/hr_sync_helper.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/gloabals.dart';

class GraphHistoryHome extends StatefulWidget {
  const GraphHistoryHome({super.key});

  @override
  State<GraphHistoryHome> createState() => GraphHistoryHomeState();
}

class GraphHistoryHomeState extends State<GraphHistoryHome> with SingleTickerProviderStateMixin {
  final GraphHistoryHelper _helper = GraphHistoryHelper();

  @override
  void initState() {
    _helper.bpData.value.clear();
    _helper.hrData.value.clear();
    _helper.tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _helper.selectedDay.value = DateTime.now();
    _helper.currentTab.value = HTab.day;
    refreshHRZone();
    super.initState();
  }

  Future<void> refreshHRZone() async {
    print('Hello RefreshZone');
    _helper.dayData();
    Future.delayed(Duration(milliseconds: 250), () async {
      _helper.dayRefreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: GraphHistoryAppbar(),
        ),
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _helper.selectedDay,
              builder: (BuildContext context, DateTime value, Widget? child) {
                return AppTabbar(
                  tabController: _helper.tabController,
                  dateTime: value,
                  hTab: _helper.currentTab.value,
                  onDateChange: (dateTime) {
                    _helper.selectedDay.value = dateTime;
                    _helper.dayPIndexBP = 1;
                    _helper.dayPIndexHR = 1;
                    _helper.dayData();
                    var isSyncedBP = _helper.refreshMapBP[
                            'bp_${_helper.currentTab.value.name}_${_helper.dayFromTime.toString()}'] ??
                        false;
                    var isSyncedHR = _helper.refreshMapHR[
                            'hr_${_helper.currentTab.value.name}_${_helper.dayFromTime.toString()}'] ??
                        false;
                    if (!isSyncedBP || !isSyncedHR) {
                      if (_helper.currentTab.value == HTab.day) {
                        _helper.dayRefreshController.requestRefresh();
                      }
                      if (_helper.currentTab.value == HTab.week) {
                        _helper.weekRefreshController.requestRefresh();
                      }
                      if (_helper.currentTab.value == HTab.month) {
                        _helper.monthRefreshController.requestRefresh();
                      }
                    }
                  },
                  tabs: [
                    Tab(
                      text: 'Day',
                    ),
                    Tab(
                      text: 'Week',
                    ),
                    Tab(
                      text: 'Month',
                    ),
                  ],
                  onChange: _helper.onTabChange,
                );
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _helper.tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SmartRefresher(
                    controller: _helper.dayRefreshController,
                    onRefresh: _helper.fetchDay,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _helper.bpData,
                            builder:
                                (BuildContext context, List<MHistoryModel> value, Widget? child) {
                              return BPAreaGraph(
                                list: value,
                                isDay: true,
                                isWeek: false,
                                startDate: _helper.selectedDay.value,
                                endDate: _helper.selectedDay.value.copyWith(
                                  day: _helper.selectedDay.value.day + 1,
                                  minute: _helper.selectedDay.value.minute - 1,
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _helper.bpData,
                            builder:
                                (BuildContext context, List<MHistoryModel> value, Widget? child) {
                              return BPErrorGraph(
                                list: value,
                                isDay: true,
                                isWeek: false,
                                startDate: _helper.selectedDay.value,
                                endDate: _helper.selectedDay.value.copyWith(
                                    day: _helper.selectedDay.value.day + 1,
                                    minute: _helper.selectedDay.value.minute - 1),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _helper.hrData,
                            builder:
                                (BuildContext context, List<SyncHRModel> value, Widget? child) {
                              return Container(
                                height: isMyTablet ? 590 : 470,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(10.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                          : Colors.white,
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(-4, -4),
                                    ),
                                    BoxShadow(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#000000').withOpacity(0.6)
                                          : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 320,
                                      padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 10.0,
                                        top: 2.5,
                                      ),
                                      child: HeartGraphWidget(
                                        list: value,
                                        zoneLines: _helper.zoneLines,
                                        isGraphPage: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 5.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16.0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Resting Heart Rate',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if (value.isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: value.isNotEmpty
                                                            ? _helper.avgRestingHR
                                                                .toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: value.isNotEmpty ? '  bpm' : '',
                                                        fontSize1: value.isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Lowest Resting Heart Rate',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if (value.isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: value.isNotEmpty
                                                            ? _helper.lowestRestingHR
                                                                .toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: value.isNotEmpty ? '  bpm' : '',
                                                        fontSize1: value.isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: MHistoryHelper().getDayLastMHistory(
                                        startTimestamp: _helper.dayFromTime,
                                        endTimestamp: _helper.dayToTime,
                                      ),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> snapshotHRV) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0, vertical: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'asset/strees_55.png',
                                                height: 18,
                                                width: 18,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Body1Text(
                                                            text: 'HR Variability',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12.0,
                                                          ),
                                                          Rich1Text(
                                                            text1: snapshotHRV.data?.toInt().toString() ?? '',
                                                            text2: ' ms',
                                                            fontSize1: 20.sp,
                                                            fontSize2: 12.sp,
                                                            color1: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color,
                                                            color2: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _helper.otData,
                            builder:
                                (BuildContext context, List<OTHistoryModel> value, Widget? child) {
                              return Container(
                                height: isMyTablet ? 500 : 380,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(10.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                          : Colors.white,
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(-4, -4),
                                    ),
                                    BoxShadow(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#000000').withOpacity(0.6)
                                          : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 320,
                                      padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 10.0,
                                        top: 12.5,
                                      ),
                                      child: OTGraphWidget(
                                        list: value,
                                        isGraphPage: true,
                                        type: 'spo2',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'asset/oxygen.png',
                                            height: 24.h,
                                            width: 24.h,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Average SPO2',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if (value.isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: value.isNotEmpty
                                                            ? _helper.avgOxygen.toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: value.isNotEmpty ? ' %' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SmartRefresher(
                    controller: _helper.weekRefreshController,
                    onRefresh: () {
                      _helper.fetchDay(
                        pageSize: 100,
                        startDate: _helper.firstDateWeek.millisecondsSinceEpoch,
                        endDate: _helper.lastDateWeek.add(Duration(days: 1)).millisecondsSinceEpoch,
                      );
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _helper.bpData,
                            builder:
                                (BuildContext context, List<MHistoryModel> value, Widget? child) {
                              return BPAreaGraph(
                                list: _helper.bpData.value,
                                isDay: true,
                                isWeek: false,
                                startDate: _helper.selectedDay.value,
                                endDate: _helper.selectedDay.value.copyWith(
                                    day: _helper.selectedDay.value.day + 1,
                                    minute: _helper.selectedDay.value.minute - 1),
                              );
                            },
                          ),
                          BPErrorGraph(
                            list: [],
                            isDay: false,
                            isWeek: true,
                            startDate: _helper.selectedDay.value,
                            endDate: _helper.selectedDay.value.copyWith(
                                day: _helper.selectedDay.value.day + 1,
                                minute: _helper.selectedDay.value.minute - 1),
                          ),
                          Container(
                            height: isMyTablet ? 590 : 470,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                      : Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(-4, -4),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#000000').withOpacity(0.6)
                                      : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 320,
                                      padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 10.0,
                                        top: 2.5,
                                      ),
                                      child: HeartGraphWidget(
                                        list: [],
                                        zoneLines: _helper.zoneLines,
                                        isGraphPage: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 5.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16.0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Resting Heart Rate',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if ([].isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: [].isNotEmpty
                                                            ? _helper.avgRestingHR
                                                                .toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: [].isNotEmpty ? '  bpm' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Lowest Resting Heart Rate',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if ([].isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: [].isNotEmpty
                                                            ? _helper.lowestRestingHR
                                                                .toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: [].isNotEmpty ? '  bpm' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'asset/strees_55.png',
                                    height: 18,
                                    width: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Body1Text(
                                                text: 'HR Variability',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                              Rich1Text(
                                                text1: '0',
                                                text2: ' ms',
                                                fontSize1: 20.sp,
                                                fontSize2: 12.sp,
                                                color1: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                color2: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A').withOpacity(0.85)
                                        : AppColor.backgroundColor.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                                ),
                                Body1AutoText(
                                  text: 'Coming soon ...',
                                  minFontSize: 8.sp,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  align: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: isMyTablet ? 510 : 390,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                      : Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(-4, -4),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#000000').withOpacity(0.6)
                                      : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 320,
                                      padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 10.0,
                                        top: 12.5,
                                      ),
                                      child: OTGraphWidget(
                                        list: [],
                                        isGraphPage: true,
                                        type: 'spo2',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'asset/oxygen.png',
                                            height: 24.h,
                                            width: 24.h,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Average SPO2',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if ([].isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: [].isNotEmpty
                                                            ? _helper.avgOxygen.toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: [].isNotEmpty ? ' %' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A').withOpacity(0.85)
                                        : AppColor.backgroundColor.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                                ),
                                Body1AutoText(
                                  text: 'Coming soon ...',
                                  minFontSize: 8.sp,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  align: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SmartRefresher(
                    controller: _helper.monthRefreshController,
                    onRefresh: () {
                      _helper.fetchDay(
                        pageSize: 100,
                        startDate: _helper.firstDateMonth.millisecondsSinceEpoch,
                        endDate:
                            _helper.lastDateMonth.add(Duration(days: 1)).millisecondsSinceEpoch,
                      );
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _helper.bpData,
                            builder:
                                (BuildContext context, List<MHistoryModel> value, Widget? child) {
                              return BPAreaGraph(
                                list: _helper.bpData.value,
                                isDay: true,
                                isWeek: false,
                                startDate: _helper.selectedDay.value,
                                endDate: _helper.selectedDay.value.copyWith(
                                    day: _helper.selectedDay.value.day + 1,
                                    minute: _helper.selectedDay.value.minute - 1),
                              );
                            },
                          ),
                          BPErrorGraph(
                            list: [],
                            isDay: false,
                            isWeek: true,
                            startDate: _helper.selectedDay.value,
                            endDate: _helper.selectedDay.value.copyWith(
                                day: _helper.selectedDay.value.day + 1,
                                minute: _helper.selectedDay.value.minute - 1),
                          ),
                          Container(
                            height: isMyTablet ? 590 : 470,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                      : Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(-4, -4),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#000000').withOpacity(0.6)
                                      : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 320,
                                      padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 10.0,
                                        top: 2.5,
                                      ),
                                      child: HeartGraphWidget(
                                        list: [],
                                        zoneLines: _helper.zoneLines,
                                        isGraphPage: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 5.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16.0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Resting Heart Rate',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if ([].isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: [].isNotEmpty
                                                            ? _helper.avgRestingHR
                                                                .toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: [].isNotEmpty ? '  bpm' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Lowest Resting Heart Rate',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if ([].isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: [].isNotEmpty
                                                            ? _helper.lowestRestingHR
                                                                .toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: [].isNotEmpty ? '  bpm' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 5.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'asset/strees_55.png',
                                            height: 18,
                                            width: 18,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'HR Variability',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      Rich1Text(
                                                        text1: '0',
                                                        text2: ' ms',
                                                        fontSize1: 20.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A').withOpacity(0.85)
                                        : AppColor.backgroundColor.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                                ),
                                Body1AutoText(
                                  text: 'Coming soon ...',
                                  minFontSize: 8,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  align: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: isMyTablet ? 510 : 390,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                      : Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(-4, -4),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#000000').withOpacity(0.6)
                                      : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 320,
                                      padding: EdgeInsets.only(
                                        left: 5.0,
                                        right: 10.0,
                                        top: 12.5,
                                      ),
                                      child: OTGraphWidget(
                                        list: [],
                                        isGraphPage: true,
                                        type: 'spo2',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'asset/oxygen.png',
                                            height: 24.h,
                                            width: 24.h,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Body1Text(
                                                        text: 'Average SPO2',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                      if ([].isEmpty) ...[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                      Rich1Text(
                                                        text1: [].isNotEmpty
                                                            ? _helper.avgOxygen.toStringAsFixed(0)
                                                            : 'No Data',
                                                        text2: [].isNotEmpty ? ' %' : '',
                                                        fontSize1: [].isNotEmpty ? 20.sp : 12.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                        color2: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A').withOpacity(0.85)
                                        : AppColor.backgroundColor.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                                ),
                                Body1AutoText(
                                  text: 'Coming soon ...',
                                  minFontSize: 8.sp,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  align: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
