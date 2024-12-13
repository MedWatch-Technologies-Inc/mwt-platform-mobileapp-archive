import 'package:flutter/material.dart';
import 'package:health_gauge/screens/history/temperature/app_bar.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_day_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_history_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_month_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_week_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/temp_day_tab.dart';
import 'package:health_gauge/screens/history/temperature/temp_month_tab.dart';
import 'package:health_gauge/screens/history/temperature/temp_week_tab.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/day_week_month_tab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TemperatureHistory extends StatefulWidget {
  const TemperatureHistory({Key? key}) : super(key: key);

  @override
  _TemperatureHistoryState createState() => _TemperatureHistoryState();
}

class _TemperatureHistoryState extends State<TemperatureHistory> {
  var pageController = PageController(initialPage: 0);
  var provider;
  var dayDataProvider;
  var weekDataProvider;
  var monthDataProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      provider = Provider.of<TempHistoryProvider>(context, listen: false);
      provider.selectedDate = DateTime.now();
      provider.selectWeek(provider.selectedDate);
      provider.currentIndex = 0;

      dayDataProvider =
          Provider.of<TempDayDataProvider>(context, listen: false);
      weekDataProvider =
          Provider.of<TempWeekDataProvider>(context, listen: false);
      monthDataProvider =
          Provider.of<TempMonthDataProvider>(context, listen: false);
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
          child: TempAppBar(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<TempHistoryProvider>(
              builder: (BuildContext context, TempHistoryProvider tempProvider,
                  Widget? child) {
                return DayWeekMonthTab(
                  currentIndex: tempProvider.currentIndex,
                  date: selectedValueText() ?? '',
                  onTapPreviousDate: () {
                    onClickBefore();
                  },
                  onTapNextDate: () {
                    bool isEnable = true;
                    Duration diff =
                        tempProvider.selectedDate.difference(DateTime.now());
                    var weekDiff = tempProvider.lastDateOfWeek
                        .difference(DateTime.now())
                        .inDays;
                    if (tempProvider.currentIndex == 0 && diff.inDays == 0) {
                      isEnable = false;
                    }
                    if (tempProvider.currentIndex == 1 && weekDiff >= 0) {
                      isEnable = false;
                    }
                    if (tempProvider.currentIndex == 2 &&
                        (diff.inDays >= 0 ||
                            (tempProvider.selectedDate.year ==
                                    DateTime.now().year &&
                                tempProvider.selectedDate.month ==
                                    DateTime.now().month))) {
                      isEnable = false;
                    }

                    if (isEnable) {
                      onClickNext();
                    }
                  },
                  onTapDay: () async {
                    tempProvider.currentIndex = 0;
                    pageController.jumpToPage(0);
                  },
                  onTapWeek: () async {
                    tempProvider.currentIndex = 1;
                    pageController.jumpToPage(1);
                  },
                  onTapMonth: () async {
                    var currentTime = DateTime.now();
                    if (selectedDate.year == currentTime.year &&
                        selectedDate.month - currentTime.month > 0) {
                      selectedDate = currentTime;
                    }
                    tempProvider.currentIndex = 2;
                    pageController.jumpToPage(2);
                  },
                  onTapCalendar: () async {
                    var date = await Date(getDatabaseDataFrom: 'Temperature')
                        .selectDate(context, tempProvider.selectedDate);
                    if (date != tempProvider.selectedDate) {
                      tempProvider.selectedDate = date;
                      tempProvider.selectWeek(tempProvider.selectedDate);
                      loadData(provider.currentIndex);
                    }
                  },
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  TempDayTab(),
                  TempWeekTab(),
                  TempMonthTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  selectedValueText() {
    var provider = Provider.of<TempHistoryProvider>(context, listen: false);
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
    var provider = Provider.of<TempHistoryProvider>(context, listen: false);
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
    var provider = Provider.of<TempHistoryProvider>(context, listen: false);
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
    var provider = Provider.of<TempHistoryProvider>(context, listen: false);
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
          Provider.of<TempDayDataProvider>(context, listen: false);
      dayDataProvider.isLoading = true;
      dayDataProvider.getHistoryData(context);
    }

    if (index == 1) {
      var weekDataProvider =
          Provider.of<TempWeekDataProvider>(context, listen: false);
      weekDataProvider.isLoading = true;
      weekDataProvider.getHistoryData(context);
    }

    if (index == 2) {
      var monthDataProvider =
          Provider.of<TempMonthDataProvider>(context, listen: false);
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
