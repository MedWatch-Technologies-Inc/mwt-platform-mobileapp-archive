import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/MeasurementHistory/HelperWidgets/app_tab_bar.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/tag/TagHistory/HelperWidget/t_app_bar.dart';
import 'package:health_gauge/screens/tag/TagHistory/HelperWidget/t_day_item.dart';
import 'package:health_gauge/screens/tag/TagHistory/HelperWidget/t_week_item.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagResponse/tag_record_model.dart';
import 'package:health_gauge/screens/tag/TagHistory/tag_history_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagHistoryHome extends StatefulWidget {
  const TagHistoryHome({super.key});

  @override
  State<TagHistoryHome> createState() => _TagHistoryHomeState();
}

class _TagHistoryHomeState extends State<TagHistoryHome> with SingleTickerProviderStateMixin {
  final THistoryHelper _helper = THistoryHelper();

  @override
  void initState() {
    _helper.dayData.value.clear();
    _helper.tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
          child: TAppbar(),
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
                    _helper.dayPIndex = 1;
                    _helper.gayData();
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
                    var isSynced = _helper.refreshMap[_helper.dayFromTime.toString()] ?? false;
                    if (!isSynced) {
                      _helper.dayRefreshController.requestRefresh();
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
                      builder: (BuildContext context, List<TagRecordModel> value, Widget? child) {
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
                                  (e) => TDayItem(tagRecordModel: e, sizeDifference: 0.h,
                                    isDay: true,)
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
                      builder: (BuildContext context, List<TDateDisplay> value, Widget? child) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: _helper.displayWeekDate.value.map(
                              (e) {
                                var index = _helper.displayWeekDate.value.indexOf(e);
                                var tDateDisplay = _helper.displayWeekDate.value.elementAt(index);
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Column(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: tDateDisplay.showDetails,
                                        builder: (BuildContext context, bool value, Widget? child) {
                                          return TWeekItem(
                                            tDateDisplay: tDateDisplay,
                                            onChange: () {
                                              if (!tDateDisplay.isShowDetails) {
                                                _helper.selectedDay.value =
                                                    DateFormat(DateUtil.ddMMMMyyyy)
                                                        .parse(tDateDisplay.title);
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
                                              tDateDisplay.isShowDetails =
                                                  !tDateDisplay.isShowDetails;
                                            },
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: tDateDisplay.showDetails,
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
                                                  List<TagRecordModel> value, Widget? child) {
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
                                                    var tagRecordModel =
                                                        _helper.dayData.value.elementAt(index);
                                                    return TDayItem(
                                                      tagRecordModel: tagRecordModel,
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
                      builder: (BuildContext context, List<TDateDisplay> value, Widget? child) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: _helper.displayMonthDate.value.map(
                              (e) {
                                var index = _helper.displayMonthDate.value.indexOf(e);
                                var tDateDisplay = _helper.displayMonthDate.value.elementAt(index);
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Column(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: tDateDisplay.showDetails,
                                        builder: (BuildContext context, bool value, Widget? child) {
                                          return TWeekItem(
                                            tDateDisplay: tDateDisplay,
                                            onChange: () {
                                              if (!tDateDisplay.isShowDetails) {
                                                _helper.selectedDay.value =
                                                    DateFormat(DateUtil.ddMMMMyyyy)
                                                        .parse(tDateDisplay.title);
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
                                              tDateDisplay.isShowDetails =
                                                  !tDateDisplay.isShowDetails;
                                            },
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: tDateDisplay.showDetails,
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
                                                  List<TagRecordModel> value, Widget? child) {
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
                                                    var tagRecordModel =
                                                        _helper.dayData.value.elementAt(index);
                                                    return TDayItem(
                                                      tagRecordModel: tagRecordModel,
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
