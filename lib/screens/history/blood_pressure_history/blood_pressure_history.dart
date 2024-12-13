import 'package:flutter/material.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_day_data_provider.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_history_provider.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_month_data_provider.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_week_data_provider.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/day_week_month_tab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_bar.dart';
import 'blood_pressure_day_tab.dart';
import 'blood_pressure_month_tab.dart';
import 'blood_pressure_week_tab.dart';

class BloodPressureHistory extends StatefulWidget {
  const BloodPressureHistory({Key? key}) : super(key: key);

  @override
  _BloodPressureHistoryState createState() => _BloodPressureHistoryState();
}

class _BloodPressureHistoryState extends State<BloodPressureHistory> {
  PageController pageController = PageController(initialPage: 0);
  late BloodPressureHistoryProvider provider;
  late BloodPressureDayDataProvider dayDataProvider;
  late BloodPressureWeekDataProvider weekDataProvider;
  late BloodPressureMonthDataProvider monthDataProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      provider =
          Provider.of<BloodPressureHistoryProvider>(context, listen: false);
      dayDataProvider =
          Provider.of<BloodPressureDayDataProvider>(context, listen: false);
      weekDataProvider =
          Provider.of<BloodPressureWeekDataProvider>(context, listen: false);
      monthDataProvider =
          Provider.of<BloodPressureMonthDataProvider>(context, listen: false);
      provider.selectedDate = DateTime.now();
      provider.selectWeek(provider.selectedDate);
      provider.currentIndex = 0;
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
          child: BloodPressureAppBar(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<BloodPressureHistoryProvider>(
              builder: (BuildContext context,
                  BloodPressureHistoryProvider provider, Widget? child) {
                return DayWeekMonthTab(
                  currentIndex: provider.currentIndex,
                  date: selectedValueText(),
                  onTapPreviousDate: onClickBefore,
                  onTapNextDate: () {
                    var now = DateTime.now();
                    var isEnable = true;
                    var diff = provider.selectedDate.difference(now);
                    var weekDiff = provider.lastDateOfWeek.difference(now).inDays;
                    if (provider.currentIndex == 0 && diff.inDays == 0) {
                      isEnable = false;
                    }
                    if (provider.currentIndex == 1 && weekDiff >= 0) {
                      isEnable = false;
                    }
                    if (provider.currentIndex == 2 &&
                        (diff.inDays >= 0 ||
                            (provider.selectedDate.year == now.year &&
                                provider.selectedDate.month == now.month))) {
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
                    var date = await Date(getDatabaseDataFrom: 'BP')
                        .selectDate(context, provider.selectedDate);
                    if (date != provider.selectedDate && date != null) {
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
                  var provider = Provider.of<BloodPressureHistoryProvider>(context, listen: false);
                  provider.currentIndex = page;
                },
                children: [
                  BloodPressureDayTab(),
                  BloodPressureWeekTab(),
                  BloodPressureMonthTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String selectedValueText() {
    var provider = Provider.of<BloodPressureHistoryProvider>(context, listen: false);
    if (provider.currentIndex == 0) {
      return txtSelectedDate();
    } else if (provider.currentIndex == 1) {
      provider.firstDateOfWeek;
      provider.lastDateOfWeek;
      var first = DateFormat('dd/MM/yyyy').format(provider.firstDateOfWeek);
      var last = DateFormat('dd/MM/yyyy').format(provider.lastDateOfWeek);
      return '$first   to   $last';
    } else if (provider.currentIndex == 2) {
      var date = DateFormat('MMMM yyyy').format(provider.selectedDate);
      var year = date.split(' ')[1];
      date = '${Date().getSelectedMonthLocalization(date)}${' $year'}';
      return '$date';
    }
    return '';
  }

  String txtSelectedDate() {
    var provider = Provider.of<BloodPressureHistoryProvider>(context, listen: false);
    var title = DateFormat('dd-MM-yyyy').format(provider.selectedDate);

    var now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final selected = DateTime(provider.selectedDate.year, provider.selectedDate.month, provider.selectedDate.day);

    if (selected == today) {
      title = StringLocalization.of(context).getText(StringLocalization.today);
    } else if (selected == yesterday) {
      title = StringLocalization.of(context).getText(StringLocalization.yesterday);
    } else if (selected == tomorrow) {
      title = StringLocalization.of(context).getText(StringLocalization.tomorrow);
    }
    return '$title';
  }

  void onClickNext() {
    var provider = Provider.of<BloodPressureHistoryProvider>(context, listen: false);
    var now = DateTime.now();
    provider.selectedDate;
    switch (provider.currentIndex) {
      case 0:
        provider.selectedDate = DateTime(provider.selectedDate.year, provider.selectedDate.month, provider.selectedDate.day + 1);
        break;
      case 1:
        provider.selectedDate = DateTime(provider.selectedDate.year, provider.selectedDate.month, provider.selectedDate.day + 7);
        break;
      case 2:
        provider.selectedDate = DateTime(provider.selectedDate.year, provider.selectedDate.month + 1, provider.selectedDate.day);
        break;
    }
    provider.selectWeek(provider.selectedDate);
    loadData(provider.currentIndex);
  }

  void onClickBefore() {
    var provider = Provider.of<BloodPressureHistoryProvider>(context, listen: false);
    var now = DateTime.now();
    provider.selectedDate;
    switch (provider.currentIndex) {
      case 0:
        provider.selectedDate = DateTime(provider.selectedDate.year, provider.selectedDate.month, provider.selectedDate.day - 1);
        break;
      case 1:
        provider.selectedDate = DateTime(provider.selectedDate.year, provider.selectedDate.month, provider.selectedDate.day - 7);
        break;
      case 2:
        provider.selectedDate = DateTime(provider.selectedDate.year, provider.selectedDate.month - 1, provider.selectedDate.day);
        break;
    }
    provider.selectWeek(provider.selectedDate);
    loadData(provider.currentIndex);
  }

  void loadData(int index) async {
    if (index == 0) {
      var dayDataProvider = Provider.of<BloodPressureDayDataProvider>(context, listen: false);
      dayDataProvider.isLoading = true;
      dayDataProvider.getHistoryData(context);
    }

    if (index == 1) {
      var weekDataProvider = Provider.of<BloodPressureWeekDataProvider>(context, listen: false);
      weekDataProvider.isLoading = true;
      weekDataProvider.getHistoryData(context);
    }

    if (index == 2) {
      var monthDataProvider = Provider.of<BloodPressureMonthDataProvider>(context, listen: false);
      monthDataProvider.isLoading = true;
      monthDataProvider.getHistoryData(context);
    }
  }

  @override
  void dispose() {
    provider.reset();
    dayDataProvider.reset();
    weekDataProvider.reset();
    monthDataProvider.reset();
    super.dispose();
  }
}
