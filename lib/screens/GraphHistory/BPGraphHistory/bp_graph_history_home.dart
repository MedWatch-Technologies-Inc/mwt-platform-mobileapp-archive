import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/screens/GraphHistory/BPGraphHistory/bp_graph_history_helper.dart';
import 'package:health_gauge/screens/GraphHistory/HelperWidgets/bp_area_graph.dart';
import 'package:health_gauge/screens/GraphHistory/HelperWidgets/bp_error_graph.dart';
import 'package:health_gauge/screens/GraphHistory/HelperWidgets/graph_history_appbar.dart';
import 'package:health_gauge/screens/GraphHistory/graph_history_helper.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/app_tab_bar.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/vital_helpers/hr_sync_helper.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BPGraphHistoryHome extends StatefulWidget {
  const BPGraphHistoryHome({super.key});

  @override
  State<BPGraphHistoryHome> createState() => _BPGraphHistoryHomeState();
}

class _BPGraphHistoryHomeState extends State<BPGraphHistoryHome> with SingleTickerProviderStateMixin {
  final BPGraphHistoryHelper _helper = BPGraphHistoryHelper();

  @override
  void initState() {
    _helper.bpData.value.clear();
    _helper.tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _helper.selectedDay.value = DateTime.now();
    _helper.currentTab.value = HTab.day;
    _helper.deyDataBP();
    Future.delayed(Duration(milliseconds: 250), () {
      _helper.dayRefreshController.requestRefresh();
    });
    super.initState();
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
                    _helper.deyDataBP();
                    var isSyncedBP = _helper.refreshMapBP[
                            'bp_${_helper.currentTab.value.name}_${_helper.dayFromTime.toString()}'] ??
                        false;
                    if (!isSyncedBP) {
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
                    onRefresh: _helper.fetchDayBP,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
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
                        ],
                      ),
                    ),
                  ),
                  SmartRefresher(
                    controller: _helper.weekRefreshController,
                    onRefresh: () {
                      _helper.fetchDayBP(
                        pageSize: 100,
                        startDate: _helper.firstDateWeek.millisecondsSinceEpoch,
                        endDate: _helper.lastDateWeek.add(Duration(days: 1)).millisecondsSinceEpoch,
                      );
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
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
                        ],
                      ),
                    ),
                  ),
                  SmartRefresher(
                    controller: _helper.monthRefreshController,
                    onRefresh: () {
                      _helper.fetchDayBP(
                        pageSize: 100,
                        startDate: _helper.firstDateMonth.millisecondsSinceEpoch,
                        endDate:
                            _helper.lastDateMonth.add(Duration(days: 1)).millisecondsSinceEpoch,
                      );
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
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
