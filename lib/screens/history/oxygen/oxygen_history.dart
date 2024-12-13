import 'package:flutter/material.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_day_data_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_history_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_month_data_provider.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_week_data_provider.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/day_week_month_tab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_bar.dart';
import 'oxygen_day_tab.dart';
import 'oxygen_month_tab.dart';
import 'oxygen_week_tab.dart';

class OxygenHistory extends StatefulWidget {
  const OxygenHistory({Key? key}) : super(key: key);

  @override
  _OxygenHistoryState createState() => _OxygenHistoryState();
}

class _OxygenHistoryState extends State<OxygenHistory> {
  var pageController = PageController(initialPage: 0);
  var provider;
  var dayDataProvider;
  var weekDataProvider;
  var monthDataProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      provider = Provider.of<OxygenHistoryProvider>(context, listen: false);
      dayDataProvider =
          Provider.of<OxygenDayDataProvider>(context, listen: false);
      weekDataProvider =
          Provider.of<OxygenWeekDataProvider>(context, listen: false);
      monthDataProvider =
          Provider.of<OxygenMonthDataProvider>(context, listen: false);
      provider.selectedDate = DateTime.now();
      provider.selectWeek(provider.selectedDate);
      provider.currentIndex = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //   context,
    //   width: Constants.staticWidth,
    //   height: Constants.staticHeight,
    //   allowFontScaling: true,
    // );
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: OxygenAppBar(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<OxygenHistoryProvider>(
              builder: (BuildContext context, OxygenHistoryProvider provider,
                  Widget? child) {
                return DayWeekMonthTab(
                  currentIndex: provider.currentIndex,
                  date: selectedValueText() ?? '',
                  onTapPreviousDate: onClickBefore,
                  onTapNextDate: () {
                    bool isEnable = true;
                    Duration diff =
                        provider.selectedDate.difference(DateTime.now());
                    var weekDiff = provider.lastDateOfWeek
                        .difference(DateTime.now())
                        .inDays;
                    if (provider.currentIndex == 0 && diff.inDays == 0) {
                      isEnable = false;
                    }
                    if (provider.currentIndex == 1 && weekDiff >= 0) {
                      isEnable = false;
                    }
                    if (provider.currentIndex == 2 &&
                        (diff.inDays >= 0 ||
                            (provider.selectedDate.year ==
                                    DateTime.now().year &&
                                provider.selectedDate.month ==
                                    DateTime.now().month))) {
                      isEnable = false;
                    }

                    if (isEnable) {
                      onClickNext();
                    }
                  },
                  onTapDay: () async {
                    provider.currentIndex = 0;
                    pageController.jumpToPage(0);
                  },
                  onTapWeek: () async {
                    provider.currentIndex = 1;
                    pageController.jumpToPage(1);
                  },
                  onTapMonth: () async {
                    var currentTime = DateTime.now();
                    if (selectedDate.year == currentTime.year &&
                        selectedDate.month - currentTime.month > 0) {
                      selectedDate = currentTime;
                    }
                    provider.currentIndex = 2;
                    pageController.jumpToPage(2);
                  },
                  onTapCalendar: () async {
                    var date = await Date(getDatabaseDataFrom: 'Oxygen')
                        .selectDate(context, provider.selectedDate);
                    if (date != provider.selectedDate) {
                      provider.selectedDate = date;
                      provider.selectWeek(provider.selectedDate);
                      loadData(provider.currentIndex);
                    }
                  },
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (int page) {
                  OxygenHistoryProvider provider =
                      Provider.of<OxygenHistoryProvider>(context,
                          listen: false);
                  provider.currentIndex = page;
                },
                children: [
                  OxygenDayTab(),
                  OxygenWeekTab(),
                  OxygenMonthTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  selectedValueText() {
    var provider = Provider.of<OxygenHistoryProvider>(context, listen: false);
    if (provider.currentIndex == 0) {
      return txtSelectedDate();
    } else if (provider.currentIndex == 1) {
      provider.firstDateOfWeek;
      provider.lastDateOfWeek;
      String first =
          DateFormat(DateUtil.ddMMyyyy).format(provider.firstDateOfWeek);
      String last =
          DateFormat(DateUtil.ddMMyyyy).format(provider.lastDateOfWeek);
      return '$first   to   $last';
    } else if (provider.currentIndex == 2) {
      String date = DateFormat(DateUtil.MMMMyyyy).format(provider.selectedDate);
      String year = date.split(' ')[1];
      date = Date().getSelectedMonthLocalization(date) + ' $year';
      return "$date";
    }
  }

  String txtSelectedDate() {
    var provider = Provider.of<OxygenHistoryProvider>(context, listen: false);
    String title =
        DateFormat(DateUtil.ddMMyyyyDashed).format(provider.selectedDate);

    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final selected = DateTime(provider.selectedDate.year,
        provider.selectedDate.month, provider.selectedDate.day);

    if (selected == today) {
      title = StringLocalization.of(context).getText(StringLocalization.today);
    } else if (selected == yesterday) {
      title =
          StringLocalization.of(context).getText(StringLocalization.yesterday);
    } else if (selected == tomorrow) {
      title =
          StringLocalization.of(context).getText(StringLocalization.tomorrow);
    }
    return "$title";
  }

  void onClickNext() {
    var provider = Provider.of<OxygenHistoryProvider>(context, listen: false);
    var now = DateTime.now();
    provider.selectedDate;
    switch (provider.currentIndex) {
      case 0:
        provider.selectedDate = DateTime(provider.selectedDate.year,
            provider.selectedDate.month, provider.selectedDate.day + 1);
        break;
      case 1:
        provider.selectedDate = DateTime(provider.selectedDate.year,
            provider.selectedDate.month, provider.selectedDate.day + 7);
        break;
      case 2:
        provider.selectedDate = DateTime(provider.selectedDate.year,
            provider.selectedDate.month + 1, provider.selectedDate.day);
        break;
    }
    provider.selectWeek(provider.selectedDate);
    loadData(provider.currentIndex);
  }

  void onClickBefore() {
    var provider = Provider.of<OxygenHistoryProvider>(context, listen: false);
    var now = DateTime.now();
    provider.selectedDate;
    switch (provider.currentIndex) {
      case 0:
        provider.selectedDate = DateTime(provider.selectedDate.year,
            provider.selectedDate.month, provider.selectedDate.day - 1);
        break;
      case 1:
        provider.selectedDate = DateTime(provider.selectedDate.year,
            provider.selectedDate.month, provider.selectedDate.day - 7);
        break;
      case 2:
        provider.selectedDate = DateTime(provider.selectedDate.year,
            provider.selectedDate.month - 1, provider.selectedDate.day);
        break;
    }
    provider.selectWeek(provider.selectedDate);
    loadData(provider.currentIndex);
  }

  loadData(int index) {
    if (index == 0) {
      var dayDataProvider =
          Provider.of<OxygenDayDataProvider>(context, listen: false);
      dayDataProvider.isLoading = true;
      dayDataProvider.getHistoryData(context);
    }

    if (index == 1) {
      var weekDataProvider =
          Provider.of<OxygenWeekDataProvider>(context, listen: false);
      weekDataProvider.isLoading = true;
      weekDataProvider.getHistoryData(context);
    }

    if (index == 2) {
      var monthDataProvider =
          Provider.of<OxygenMonthDataProvider>(context, listen: false);
      monthDataProvider.isLoading = true;
      monthDataProvider.getHistoryData(context);
    }
  }

  @override
  void dispose() {
    provider?.reset();
    dayDataProvider?.reset();
    weekDataProvider?.reset();
    monthDataProvider?.reset();
    super.dispose();
  }
}
