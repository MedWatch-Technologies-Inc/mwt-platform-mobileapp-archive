import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/screens/BloodPressureHistory/HelperWidgets/bp_day_item.dart';
import 'package:health_gauge/screens/BloodPressureHistory/HelperWidgets/bp_history_appbar.dart';
import 'package:health_gauge/screens/BloodPressureHistory/HelperWidgets/bp_week_item.dart';
import 'package:health_gauge/screens/BloodPressureHistory/bp_history_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/app_tab_bar.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BPHistoryHome extends StatefulWidget {
  const BPHistoryHome({super.key});

  @override
  State<BPHistoryHome> createState() => _BPHistoryHomeState();
}

class _BPHistoryHomeState extends State<BPHistoryHome> with SingleTickerProviderStateMixin {
  final BPHistoryHelper _helper = BPHistoryHelper();

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
          child: BPHistoryAppbar(),
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
                      Future.delayed(Duration(milliseconds: 100), () {
                        if (!isSynced) {
                          _helper.dayRefreshController.requestRefresh();
                        }
                      });
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
                    onRefresh: _helper.fetchDay,
                    child: ValueListenableBuilder(
                      valueListenable: _helper.dayData,
                      builder: (BuildContext context, List<BPHistoryModel> value, Widget? child) {
                        if (value.isEmpty) {
                          return Center(
                            child: Body1AutoText(
                              text: StringLocalization.of(context)
                                  .getText(StringLocalization.noDataFound),
                              maxLine: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: _helper.dayData.value
                                .map(
                                  (e) => BPDayItem(
                                    bpHistoryModel: e,
                                    sizeDifference: 0.h,
                                    isDay: true,
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  SmartRefresher(
                    controller: _helper.weekRefreshController,
                    onRefresh: _helper.fetchDay,
                    child: ValueListenableBuilder(
                      valueListenable: _helper.displayWeekDate,
                      builder: (BuildContext context, List<BPDateDisplay> value, Widget? child) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: _helper.displayWeekDate.value.map(
                              (e) {
                                var index = _helper.displayWeekDate.value.indexOf(e);
                                var bpDateDisplay = _helper.displayWeekDate.value.elementAt(index);
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Column(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: bpDateDisplay.showDetails,
                                        builder: (BuildContext context, bool value, Widget? child) {
                                          return BPWeekItem(
                                            bpDateDisplay: bpDateDisplay,
                                            onChange: () {
                                              if (!bpDateDisplay.isShowDetails) {
                                                _helper.selectedWeek.value =
                                                    DateFormat(DateUtil.ddMMMMyyyy)
                                                        .parse(bpDateDisplay.title);
                                                _helper.gayData();
                                                var isSynced = _helper.refreshMap[
                                                        _helper.dayFromTime.toString()] ??
                                                    false;
                                                if (!isSynced) {
                                                  _helper.weekRefreshController.requestRefresh();
                                                }
                                              }
                                              for (var i = 0;
                                                  i < _helper.displayWeekDate.value.length;
                                                  i++) {
                                                if (index != i) {
                                                  _helper.displayWeekDate.value[i].isShowDetails =
                                                      false;
                                                }
                                              }
                                              bpDateDisplay.isShowDetails =
                                                  !bpDateDisplay.isShowDetails;
                                            },
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: bpDateDisplay.showDetails,
                                        builder: (BuildContext context, bool value, Widget? child) {
                                          if (!value) {
                                            return SizedBox();
                                          }
                                          return Container(
                                            constraints: BoxConstraints(
                                              maxHeight: 300.h,
                                              minHeight: 80.h,
                                            ),
                                            margin: EdgeInsets.only(bottom: 5.h),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(10.h),
                                                  bottomRight: Radius.circular(10.h)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                                      : Colors.white,
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(-4, -4),
                                                ),
                                                BoxShadow(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? Colors.black.withOpacity(0.75)
                                                      : HexColor.fromHex('#9F2DBC')
                                                          .withOpacity(0.15),
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                  offset: Offset(5, 5),
                                                ),
                                              ],
                                            ),
                                            child: ValueListenableBuilder(
                                              valueListenable: _helper.dayData,
                                              builder: (BuildContext context,
                                                  List<BPHistoryModel> value, Widget? child) {
                                                if (value.isEmpty) {
                                                  return SizedBox(
                                                    height: 80.h,
                                                    child: Center(
                                                      child: Body1AutoText(
                                                        text: StringLocalization.of(context)
                                                            .getText(
                                                                StringLocalization.noDataFound),
                                                        maxLine: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return ListView.separated(
                                                  itemCount: _helper.dayData.value.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15.h, horizontal: 20.w),
                                                  itemBuilder: (BuildContext context, int index) {
                                                    var bpHistoryModel =
                                                        _helper.dayData.value.elementAt(index);
                                                    return BPDayItem(
                                                      bpHistoryModel: bpHistoryModel,
                                                      sizeDifference: 10.h,
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context, int index) {
                                                    return SizedBox(
                                                      height: 10.h,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
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
                  ),
                  SmartRefresher(
                    controller: _helper.monthRefreshController,
                    onRefresh: _helper.fetchDay,
                    child: ValueListenableBuilder(
                      valueListenable: _helper.displayMonthDate,
                      builder: (BuildContext context, List<BPDateDisplay> value, Widget? child) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: _helper.displayMonthDate.value.map(
                              (e) {
                                var index = _helper.displayMonthDate.value.indexOf(e);
                                var bpDateDisplay = _helper.displayMonthDate.value.elementAt(index);
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Column(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: bpDateDisplay.showDetails,
                                        builder: (BuildContext context, bool value, Widget? child) {
                                          return BPWeekItem(
                                            bpDateDisplay: bpDateDisplay,
                                            onChange: () {
                                              if (!bpDateDisplay.isShowDetails) {
                                                _helper.selectedMonth.value =
                                                    DateFormat(DateUtil.ddMMMMyyyy)
                                                        .parse(bpDateDisplay.title);
                                                _helper.gayData();
                                                var isSynced = _helper.refreshMap[
                                                        _helper.dayFromTime.toString()] ??
                                                    false;
                                                if (!isSynced) {
                                                  _helper.monthRefreshController.requestRefresh();
                                                }
                                              }
                                              for (var i = 0;
                                                  i < _helper.displayMonthDate.value.length;
                                                  i++) {
                                                if (index != i) {
                                                  _helper.displayMonthDate.value[i].isShowDetails =
                                                      false;
                                                }
                                              }
                                              bpDateDisplay.isShowDetails =
                                                  !bpDateDisplay.isShowDetails;
                                            },
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: bpDateDisplay.showDetails,
                                        builder: (BuildContext context, bool value, Widget? child) {
                                          if (!value) {
                                            return SizedBox();
                                          }
                                          return Container(
                                            constraints: BoxConstraints(
                                              maxHeight: 300.h,
                                              minHeight: 80.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(10.h),
                                                  bottomRight: Radius.circular(10.h)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                                      : Colors.white,
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(-4, -4),
                                                ),
                                                BoxShadow(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? Colors.black.withOpacity(0.75)
                                                      : HexColor.fromHex('#9F2DBC')
                                                          .withOpacity(0.15),
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                  offset: Offset(5, 5),
                                                ),
                                              ],
                                            ),
                                            child: ValueListenableBuilder(
                                              valueListenable: _helper.dayData,
                                              builder: (BuildContext context,
                                                  List<BPHistoryModel> value, Widget? child) {
                                                if (value.isEmpty) {
                                                  return SizedBox(
                                                    height: 80.h,
                                                    child: Center(
                                                      child: Body1AutoText(
                                                        text: StringLocalization.of(context)
                                                            .getText(
                                                                StringLocalization.noDataFound),
                                                        maxLine: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return ListView.separated(
                                                  itemCount: _helper.dayData.value.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15.h, horizontal: 20.w),
                                                  itemBuilder: (BuildContext context, int index) {
                                                    var bpHistoryModel =
                                                        _helper.dayData.value.elementAt(index);
                                                    return BPDayItem(
                                                      bpHistoryModel: bpHistoryModel,
                                                      sizeDifference: 10.h,
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context, int index) {
                                                    return SizedBox(
                                                      height: 10.h,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
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
