import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/hr_history_appbar.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/hr_week_item.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/app_tab_bar.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HRHistoryHome extends StatefulWidget {
  const HRHistoryHome({super.key});

  @override
  State<HRHistoryHome> createState() => _BPHistoryHomeState();
}

class _BPHistoryHomeState extends State<HRHistoryHome> with SingleTickerProviderStateMixin {
  final HRHelper _helper = HRHelper();

  @override
  void initState() {
    _helper.dayData.value.clear();
    _helper.tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _helper.dayPIndex = 1;
    _helper.selectedDay.value = DateTime.now();
    _helper.currentTab.value = HTab.day;
    _helper.gayData();
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
          child: ValueListenableBuilder(
            valueListenable: _helper.currentTab,
            builder: (BuildContext context, HTab value, Widget? child) {
              return HRHistoryAppbar(
                showAction: value == HTab.day,
              );
            },
          ),
        ),
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _helper.selectedDay,
              builder: (BuildContext context, DateTime value, Widget? child) {
                return AppTabbar(
                  tabController: _helper.tabController,
                  dateTime: _helper.currentDate,
                  hTab: _helper.currentTab.value,
                  onDateChange: (dateTime) {
                    switch (_helper.currentTab.value) {
                      case HTab.day:
                        _helper.selectedDay.value = dateTime;
                        break;
                      case HTab.week:
                        _helper.selectedWeek.value = dateTime;
                        break;
                      case HTab.month:
                        _helper.selectedMonth.value = dateTime;
                        break;
                    }
                    _helper.dayPIndex = 1;
                    _helper.selectedDay.notifyListeners();
                    _helper.gayData();
                    if (_helper.currentTab.value == HTab.day) {
                      var isSynced = _helper.refreshMap[_helper.dayFromTime.toString()] ?? false;
                      if (!isSynced) {
                        _helper.dayRefreshController.requestRefresh();
                      }
                    }
                    if (_helper.currentTab.value == HTab.week) {
                      _helper.displayWeekDate.value.clear();
                      _helper.displayWeekDate.value.addAll(_helper.getWeekItems);
                      _helper.displayWeekDate.notifyListeners();
                    }
                    if (_helper.currentTab.value == HTab.month) {
                      _helper.displayMonthDate.value.clear();
                      _helper.displayMonthDate.value.addAll(_helper.getMonthItems);
                      _helper.displayMonthDate.notifyListeners();
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
                    onRefresh: () async {
                      await _helper.fetchDay();
                      // _helper.gayData();
                    },
                    child: ValueListenableBuilder(
                      valueListenable: _helper.dayData,
                      builder: (BuildContext context, List<SyncHRModel> value, Widget? child) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              HeartGraphWidget(
                                list: value,
                                zoneLines: _helper.zoneLines,
                                isGraphPage: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
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
                                                ),
                                                if (value.isEmpty) ...[
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                ],
                                                Rich1Text(
                                                  text1: value.isNotEmpty
                                                      ? _helper.avgRestingHR.toStringAsFixed(0)
                                                      : 'No Data',
                                                  text2: value.isNotEmpty ? ' bpm' : '',
                                                  fontSize1: value.isNotEmpty ? 30.sp : 15.sp,
                                                  fontSize2: 15.sp,
                                                  color1:
                                                      Theme.of(context).textTheme.bodyText1!.color,
                                                  color2:
                                                      Theme.of(context).textTheme.bodyText1!.color,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
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
                                                ),
                                                if (value.isEmpty) ...[
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                ],
                                                Rich1Text(
                                                  text1: value.isNotEmpty
                                                      ? _helper.lowestRestingHR.toStringAsFixed(0)
                                                      : 'No Data',
                                                  text2: value.isNotEmpty ? ' bpm' : '',
                                                  fontSize1: value.isNotEmpty ? 30.sp : 15.sp,
                                                  fontSize2: 15.sp,
                                                  color1:
                                                      Theme.of(context).textTheme.bodyText1!.color,
                                                  color2:
                                                      Theme.of(context).textTheme.bodyText1!.color,
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
                                builder: (BuildContext context, AsyncSnapshot<double> snapshotHRV) {
                                  return  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'asset/strees_55.png',
                                          height: 24,
                                          width: 24,
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
                                                      text: 'HR Variability',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    Rich1Text(
                                                      text1: snapshotHRV.connectionState == ConnectionState.waiting ? '0' : snapshotHRV.data!.toInt().toString(),
                                                      text2: '  ms',
                                                      fontSize1: 30.sp,
                                                      fontSize2: 15.sp,
                                                      color1: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color,
                                                      color2: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
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
                  ),
                  ValueListenableBuilder(
                    valueListenable: _helper.displayWeekDate,
                    builder: (BuildContext context, List<HRDateDisplay> value, Widget? child) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: _helper.displayWeekDate.value.map(
                            (e) {
                              var index = _helper.displayWeekDate.value.indexOf(e);
                              var hrDateDisplay = _helper.displayWeekDate.value.elementAt(index);
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                child: Column(
                                  children: [
                                    HRWeekItem(
                                      hrDateDisplay: hrDateDisplay,
                                      onChange: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _helper.displayMonthDate,
                    builder: (BuildContext context, List<HRDateDisplay> value, Widget? child) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: _helper.displayMonthDate.value.map(
                            (e) {
                              var index = _helper.displayMonthDate.value.indexOf(e);
                              var hrDateDisplay = _helper.displayMonthDate.value.elementAt(index);
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                child: Column(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: hrDateDisplay.showDetails,
                                      builder: (BuildContext context, bool value, Widget? child) {
                                        return HRWeekItem(
                                          hrDateDisplay: hrDateDisplay,
                                          onChange: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
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
