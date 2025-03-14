// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:convert';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/gloabals.dart';

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 8.0;

const int _yearPickerColumnCount = 3;
const double _yearPickerPadding = 16.0;
const double _yearPickerRowHeight = 52.0;
const double _yearPickerRowSpacing = 8.0;

const double _subHeaderHeight = 52.0;
const double _monthNavButtonsWidth = 108.0;

/// Displays a grid of days for a given month and allows the user to select a date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The calendar picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which will create a dialog that uses this as well as provides
/// a text entry option.
///
/// See also:
///
///  * [showDatePicker], which creates a Dialog that contains a [CalendarDatePicker]
///    and provides an optional compact view where the user can enter a date as
///    a line of text.
///  * [showTimePicker], which shows a dialog that contains a material design
///    time picker.
///
class CustomCalendarDatePicker extends StatefulWidget {
  /// Creates a calender date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day
  /// indicated by [initialDate] will be selected.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track
  /// the currently displayed month.
  ///
  /// The user interface provides a way to change the year of the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// to start in the year selection interface with [initialCalendarMode] set
  /// to [DatePickerMode.year].
  ///
  /// The [initialDate], [firstDate], [lastDate], [onDateChanged], and
  /// [initialCalendarMode] must be non-null.
  ///
  /// [lastDate] must be after or equal to [firstDate].
  ///
  /// [initialDate] must be between [firstDate] and [lastDate] or equal to
  /// one of them.
  ///
  /// [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// If [selectableDayPredicate] is non-null, it must return `true` for the
  /// [initialDate].
  CustomCalendarDatePicker({
    Key? key,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    required this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.initialCalendarMode = DatePickerMode.day,
    this.selectableDayPredicate,
    required this.getDatabaseDataFrom,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        assert(onDateChanged != null),
        assert(initialCalendarMode != null),
        super(key: key) {
    assert(!this.lastDate.isBefore(this.firstDate),
        'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.');
    assert(!this.initialDate.isBefore(this.firstDate),
        'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.');
    assert(!this.initialDate.isAfter(this.lastDate),
        'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.');
    assert(
        selectableDayPredicate == null ||
            selectableDayPredicate!(this.initialDate),
        'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.');
  }

  final String getDatabaseDataFrom;

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _CalendarDatePickerState createState() => _CalendarDatePickerState();
}

class _CalendarDatePickerState extends State<CustomCalendarDatePicker> {
  bool _announcedInitialDate = false;
  late DatePickerMode _mode;
  late DateTime _currentDisplayedMonthDate;
  late DateTime _selectedDate;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  MaterialLocalizations? _localizations;
  TextDirection? _textDirection;

  @override
  void initState() {
    super.initState();
    _initWidgetState();
  }

  @override
  void didUpdateWidget(CustomCalendarDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initWidgetState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        _localizations!.formatFullDate(_selectedDate),
        _textDirection!,
      );
    }
  }

  void _initWidgetState() {
    _mode = widget.initialCalendarMode;
    _currentDisplayedMonthDate =
        DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_mode == DatePickerMode.day) {
        SemanticsService.announce(
          _localizations!.formatMonthYear(_selectedDate),
          _textDirection!,
        );
      } else {
        SemanticsService.announce(
          _localizations!.formatYear(_selectedDate),
          _textDirection!,
        );
      }
    });
  }

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    if (value.isBefore(widget.firstDate)) {
      value = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      value = widget.lastDate;
    }

    setState(() {
      _mode = DatePickerMode.day;
      _handleMonthChanged(value);
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged.call(_selectedDate);
    });
  }

  Widget? _buildPicker() {
    switch (_mode) {
      case DatePickerMode.day:
        return _MonthPicker(
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          currentDate: widget.currentDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
          getDatabaseDataFrom: widget.getDatabaseDataFrom,
        );
      case DatePickerMode.year:
        return Padding(
          padding: const EdgeInsets.only(top: _subHeaderHeight),
          child: _YearPicker(
            key: _yearPickerKey,
            currentDate: widget.currentDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _currentDisplayedMonthDate,
            selectedDate: _selectedDate,
            onChanged: _handleYearChanged,
          ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Container(
      height: 200.h,
      width: 200.w,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: _subHeaderHeight + _maxDayPickerHeight,
            child: _buildPicker(),
          ),
          // Put the mode toggle button on top so that it won't be covered up by the _MonthPicker
          _DatePickerModeToggleButton(
            mode: _mode,
            title: _localizations!.formatMonthYear(_currentDisplayedMonthDate),
            onTitlePressed: () {
              // Toggle the day/year mode.
              _handleModeChanged(_mode == DatePickerMode.day
                  ? DatePickerMode.year
                  : DatePickerMode.day);
            },
          ),
        ],
      ),
    );
  }
}

/// A button that used to toggle the [DatePickerMode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [DatePickerMode] to display either the calendar view or the year list.
class _DatePickerModeToggleButton extends StatefulWidget {
  const _DatePickerModeToggleButton({
    required this.mode,
    required this.title,
    required this.onTitlePressed,
  });

  /// The current display of the calendar picker.
  final DatePickerMode mode;

  /// The text that displays the current month/year being viewed.
  final String title;

  /// The callback when the title is pressed.
  final VoidCallback onTitlePressed;

  @override
  _DatePickerModeToggleButtonState createState() =>
      _DatePickerModeToggleButtonState();
}

class _DatePickerModeToggleButtonState
    extends State<_DatePickerModeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.mode == DatePickerMode.year ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_DatePickerModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePickerMode.year) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color controlColor = colorScheme.onSurface.withOpacity(0.60);

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: _subHeaderHeight,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Semantics(
              label: MaterialLocalizations.of(context).selectYearSemanticsLabel,
              excludeSemantics: true,
              button: true,
              child: Container(
                height: _subHeaderHeight,
                child: InkWell(
                  key:Key('weightGraphCalendarShowYear'),

                  onTap: widget.onTitlePressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            width: 102,
                            child: AutoSizeText(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xffffffff).withOpacity(0.87)
                                    : Color(0xff384341),
                              ),
                              maxLines: 1,
                              minFontSize: 6,
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: _controller,
                          child: Image.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'asset/down_icon_dark.png'
                                : 'asset/calendar_down_icon.png',
                            width: 22,
                            height: 22,
                            // color: controlColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.mode == DatePickerMode.day)
            // Give space for the prev/next month buttons that are underneath this row
            const SizedBox(width: _monthNavButtonsWidth),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _MonthPicker({
    Key? key,
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
    required this.getDatabaseDataFrom,
  })  : assert(selectedDate != null),
        assert(currentDate != null),
        assert(onChanged != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate)),
        super(key: key);

  final String getDatabaseDataFrom;

  /// The initial month to display.
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentMonth;
  late DateTime _nextMonthDate;
  late DateTime _previousMonthDate;
  late PageController _pageController;
  MaterialLocalizations? _localizations;
  TextDirection? _textDirection;
  late Map<LogicalKeySet, Intent> _shortcutMap;
  late Map<Type, Action<Intent>> _actionMap;
  late FocusNode _dayGridFocus;
  DateTime? _focusedDay;
  List<dynamic> dateList = [];

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _previousMonthDate = DateUtils.addMonthsToMonthDate(_currentMonth, -1);
    _nextMonthDate = DateUtils.addMonthsToMonthDate(_currentMonth, 1);
    _pageController = PageController(
        initialPage: DateUtils.monthDelta(widget.firstDate, _currentMonth));
    _shortcutMap = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft):
          const DirectionalFocusIntent(TraversalDirection.left),
      LogicalKeySet(LogicalKeyboardKey.arrowRight):
          const DirectionalFocusIntent(TraversalDirection.right),
      LogicalKeySet(LogicalKeyboardKey.arrowDown):
          const DirectionalFocusIntent(TraversalDirection.down),
      LogicalKeySet(LogicalKeyboardKey.arrowUp):
          const DirectionalFocusIntent(TraversalDirection.up),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent:
          CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  Future<bool> getInitialDataDates() async {
    DateTime startDate =
        DateTime(widget.initialMonth.year, widget.initialMonth.month, 1);
    DateTime endDate =
        DateTime(widget.initialMonth.year, widget.initialMonth.month + 1, 0);
    endDate = endDate.add(Duration(days: 1));
    await getCalendarDates(startDate, endDate);
    return true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void didUpdateWidget(_MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != oldWidget.initialMonth) {
      _showMonth(widget.initialMonth);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged.call(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        _previousMonthDate = DateUtils.addMonthsToMonthDate(_currentMonth, -1);
        _nextMonthDate = DateUtils.addMonthsToMonthDate(_currentMonth, 1);
        widget.onDisplayedMonthChanged.call(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) return newFocus;
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) return newFocus;
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      SemanticsService.announce(
        _localizations!.formatMonthYear(_nextMonthDate),
        _textDirection!,
      );
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      SemanticsService.announce(
        _localizations!.formatMonthYear(_previousMonthDate),
        _textDirection!,
      );
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  Future<void> getCalendarDates(DateTime startDate, DateTime endDate) async {
    switch (widget.getDatabaseDataFrom) {
      case 'Weight':
        {
         await getWeightDates(startDate, endDate);
          break;
        }
      case 'tag':
        {
         await getTagNoteDates(startDate, endDate);
          break;
        }
      case 'Sleep' : {
        await getSleepDates(startDate, endDate);
        break;

      }
     case 'Blood Pressure' : {
     await getMeasurementDates(startDate, endDate);
       break;
     }
      case 'Activity' : {
      await getHrDates(startDate, endDate);
        break;
      }
      case 'Heart Rate' : {
        await getHrDates(startDate, endDate);
        break;
      }
      case 'BP' : {
        await getBPDates(startDate, endDate);
        break;
      }
      case 'Oxygen' : {
       await getOxygenDates(startDate, endDate);
        break;
      }
      case 'Temperature' : {
       await getTempDates(startDate, endDate);
        break;
      }
    }
  }

  /// get weight dates in pagination from the database
  Future<void> getWeightDates(DateTime startDate, DateTime endDate) async {
    List<WeightMeasurementModel> weightMeasurementModelList = await dbHelper.getWeightDataForCalendar(
        globalUser?.userId ?? '', startDate, endDate, dateList.length);
    if (weightMeasurementModelList.isNotEmpty) {
      dateList.addAll(weightMeasurementModelList);
      await getWeightDates(startDate, endDate);
    }
  }

  /// get tag dates in pagination from the database
  Future<void> getTagNoteDates(DateTime startDate, DateTime endDate) async {
    List<TagNote> tagNoteList = await dbHelper.getTagNoteForCalendar(
        globalUser?.userId ?? '', startDate, endDate, dateList.length);
    if (tagNoteList.isNotEmpty) {
      dateList.addAll(tagNoteList);
      await getTagNoteDates(startDate, endDate);
    }
  }

  /// get sleep dates in pagination from the database
  Future<void> getSleepDates(DateTime startDate, DateTime endDate) async {
    List<SleepInfoModel> sleepList = await dbHelper.getSleepForCalendar(
        globalUser?.userId ?? '', startDate, endDate, dateList.length);
    if (sleepList.isNotEmpty) {
      dateList.addAll(sleepList);
      await getSleepDates(startDate, endDate);
    }
  }


  /// get measurement dates in pagination from the database
  Future<void> getMeasurementDates(DateTime startDate, DateTime endDate) async {
    List<MeasurementHistoryModel> cardioList = await dbHelper.getMeasurementHistoryForCalendar(globalUser?.userId ?? '', startDate, endDate, dateList.length);
    if (cardioList.isNotEmpty) {
      dateList.addAll(cardioList);
      await getMeasurementDates(startDate, endDate);
    }
  }


  /// get oxygen dates in pagination from the database
  Future<void> getOxygenDates(DateTime startDate, DateTime endDate) async {
    List<TempModel> oxygenList = await dbHelper.getTempTableDataForCalendar(globalUser?.userId ?? '', startDate, endDate, 'Oxygen', dateList.length);
    if (oxygenList.isNotEmpty) {
      dateList.addAll(oxygenList);
      await getOxygenDates(startDate, endDate);
    }
  }

/// get temperature dates in pagination from the database
  Future<void> getTempDates(DateTime startDate, DateTime endDate) async {
    List<TempModel> tempList = await dbHelper.getTempTableDataForCalendar(globalUser?.userId ?? '', startDate, endDate, 'Temperature', dateList.length);
  if (tempList.isNotEmpty) {
  dateList.addAll(tempList);
  await getTempDates(startDate, endDate);
  }
}


  /// get hr dates in pagination from the database
  Future<void> getHrDates(DateTime startDate, DateTime endDate) async {
    List<MeasurementHistoryModel> cardioList = await dbHelper.getHeartRateForCalendar(globalUser?.userId ?? '', startDate, endDate, dateList.length);
    if (cardioList.isNotEmpty) {
      dateList.addAll(cardioList);
      await getHrDates(startDate, endDate);
    }
  }


  /// get BP dates in pagination from the database
  Future<void> getBPDates(DateTime startDate, DateTime endDate) async {
    List<BPModel> bpList = await dbHelper.getBloodPressureDataForCalendar(globalUser?.userId ?? '', startDate, endDate, dateList.length);
    if (bpList.isNotEmpty) {
      dateList.addAll(bpList);
      await getBPDates(startDate, endDate);
    }
  }




  /// Navigate to the given month.
  void _showMonth(DateTime month) {
    final int monthPage = DateUtils.monthDelta(widget.firstDate, month);
    _pageController.animateToPage(monthPage,
        duration: _monthScrollDuration, curve: Curves.ease);
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month),
    );
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(bool focused) {
      if (focused && _focusedDay == null) {
        if (DateUtils.isSameMonth(widget.selectedDate, _currentMonth)) {
          _focusedDay = widget.selectedDate;
        } else if (DateUtils.isSameMonth(widget.currentDate, _currentMonth)) {
          _focusedDay =
              _focusableDayForMonth(_currentMonth, widget.currentDate.day);
        } else {
          _focusedDay = _focusableDayForMonth(_currentMonth, 1);
        }
      }
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final DateTime nextDate =
          _nextDateInDirection(_focusedDay!, intent.direction) ?? DateTime.now();
      if (nextDate != null) {
        _focusedDay = nextDate;
        if (!DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          _showMonth(_focusedDay!);
        }
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int? _dayDirectionOffset(
      TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left)
        traversalDirection = TraversalDirection.right;
      else if (traversalDirection == TraversalDirection.right)
        traversalDirection = TraversalDirection.left;
    }
    return _directionOffset[traversalDirection];
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    DateTime nextDate = DateUtils.addDaysToDate(
        date, _dayDirectionOffset(direction, textDirection) ?? 0);
    while (!nextDate.isBefore(widget.firstDate) &&
        !nextDate.isAfter(widget.lastDate)) {
      if (_isSelectable(nextDate)) {
        return nextDate;
      }
      nextDate = DateUtils.addDaysToDate(
          nextDate, _dayDirectionOffset(direction, textDirection) ?? 0);
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return _DayPicker(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
      dataList: dateList,
      getDatabaseDataFrom: widget.getDatabaseDataFrom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String previousTooltipText =
        '${_localizations!.previousMonthTooltip} ${_localizations!.formatMonthYear(_previousMonthDate)}';
    final String nextTooltipText =
        '${_localizations!.nextMonthTooltip} ${_localizations!.formatMonthYear(_nextMonthDate)}';
    final Color controlColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.60);

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Semantics(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
                  height: _subHeaderHeight,
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      IconButton(
                  key:Key('weightGraphChangeMonth'),

                        icon: const Icon(Icons.chevron_left),
                        color: controlColor,
                        tooltip: _isDisplayingFirstMonth
                            ? null
                            : previousTooltipText,
                        onPressed: _isDisplayingFirstMonth
                            ? null
                            : _handlePreviousMonth,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        color: controlColor,
                        tooltip:
                            _isDisplayingLastMonth ? null : nextTooltipText,
                        onPressed:
                            _isDisplayingLastMonth ? null : _handleNextMonth,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FocusableActionDetector(
                    shortcuts: _shortcutMap,
                    actions: _actionMap,
                    focusNode: _dayGridFocus,
                    onFocusChange: _handleGridFocusChange,
                    child: _FocusedDate(
                      date: _dayGridFocus.hasFocus ? _focusedDay! : DateTime.now(),
                      child: PageView.builder(
                        key: _pageViewKey,
                        controller: _pageController,
                        itemBuilder: _buildItems,
                        itemCount: DateUtils.monthDelta(
                                widget.firstDate, widget.lastDate) +
                            1,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: _handleMonthPageChanged,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
      future: getInitialDataDates(),
    );
  }
}

/// InheritedWidget indicating what the current focused date is for its children.
///
/// This is used by the [_MonthPicker] to let its children [_DayPicker]s know
/// what the currently focused date (if any) should be.
class _FocusedDate extends InheritedWidget {
  const _FocusedDate({Key? key, required Widget child, this.date})
      : super(key: key, child: child);

  final DateTime? date;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date);
  }

  static DateTime? of(BuildContext context) {
    final _FocusedDate? focusedDate =
        context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
    return focusedDate?.date;
  }
}

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _DayPicker extends StatefulWidget {
  /// Creates a day picker.
  _DayPicker({
    Key? key,
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.selectableDayPredicate,
    required this.dataList,
    required this.getDatabaseDataFrom,
  })  : assert(currentDate != null),
        assert(displayedMonth != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(selectedDate != null),
        assert(onChanged != null),
        assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate)),
        super(key: key);

  final String getDatabaseDataFrom;

  final List<dynamic> dataList;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _DayPickerState createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
        daysInMonth,
        (int index) =>
            FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate.of(context);
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _dayHeaders(
      TextStyle headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Container(
          height: 40,
          child: Center(child: Text(weekday, style: headerStyle)),
        ),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    // final TextStyle headerStyle = textTheme.caption?.apply(
    //   color: colorScheme.onSurface.withOpacity(0.60),
    // );
    final TextStyle headerStyle = TextStyle(
      color: Color(0xffFF6259),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    final TextStyle? dayStyle = textTheme.bodySmall;
    final Color enabledDayColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledDayColor = colorScheme.onSurface.withOpacity(0.38);
    final Color selectedDayColor = colorScheme.onPrimary;
    final Color selectedDayBackground = colorScheme.primary;
    final Color todayColor = colorScheme.primary;

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = _dayHeaders(headerStyle, localizations);
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
            dayToBuild.isBefore(widget.firstDate) ||
            (widget.selectableDayPredicate != null &&
                !widget.selectableDayPredicate!(dayToBuild));
        final bool isSelectedDay =
            DateUtils.isSameDay(widget.selectedDate, dayToBuild);
        final bool isToday =
            DateUtils.isSameDay(widget.currentDate, dayToBuild);
        BoxDecoration? decoration;
        Color dayColor = enabledDayColor.withOpacity(0.87);

        if (widget.getDatabaseDataFrom.isNotEmpty) {
          if (widget.dataList != null && widget.dataList.isNotEmpty) {
            int flag = 0;
            DateTime tempDate;
            for (int i = 0; i < widget.dataList.length; i++) {
              if (widget.getDatabaseDataFrom == 'Temperature' || widget.getDatabaseDataFrom == 'Oxygen') {
                tempDate = Date().convertDateFromString(widget.dataList[i].date,temp: true);
              } else {
                if (widget.dataList[i].date is String) {
                  tempDate =
                      Date().convertDateFromString(widget.dataList[i].date);
                } else {
                  tempDate = widget.dataList[i].date;
                }
              }
              if (tempDate.year == dayToBuild.year &&
                  tempDate.month == dayToBuild.month &&
                  tempDate.day == dayToBuild.day) {
                flag = 1;
                break;
              }
            }
            if (flag == 1) {
              dayColor = Theme.of(context).brightness == Brightness.dark
                  ? Color(0xffD3A5DF)
                  : Color(0xff9F2DBC);
              decoration = BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xffBD78CE).withOpacity(0.2)
                    : Color(0xff9F2DBC).withOpacity(0.1),
                shape: BoxShape.circle,
              );
            }
          }

          if (isSelectedDay) {
            // The selected day gets a circle background highlight, and a
            // contrasting text color.
            dayColor = Theme.of(context).brightness == Brightness.dark
                ? Color(0xff000000)
                : Color(0xffffffff);
            decoration = BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xffBD78CE)
                  : Color(0xff9F2DBC),
              shape: BoxShape.circle,
            );
          }
        } else {
          if (isSelectedDay) {
            // The selected day gets a circle background highlight, and a
            // contrasting text color.
            dayColor = Theme.of(context).brightness == Brightness.dark
                ? Color(0xff000000)
                : Color(0xffffffff);
            decoration = BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xffBD78CE)
                  : Color(0xff9F2DBC),
              shape: BoxShape.circle,
            );
          } else if (isDisabled) {
            dayColor = disabledDayColor;
          } else if (isToday) {
            // The current day gets a different text color and a circle stroke
            // border.
            dayColor = Theme.of(context).brightness == Brightness.dark
                ? Color(0xffD3A5DF)
                : Color(0xff9F2DBC);
            decoration = BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xffBD78CE).withOpacity(0.2)
                  : Color(0xff9F2DBC).withOpacity(0.1),
              shape: BoxShape.circle,
            );
          }
        }

        Widget dayWidget = Container(
          width: 42,
          height: 42,
          decoration: decoration,
          child: Center(
            child: Text(
              localizations.formatDecimal(day),
              // style: dayStyle.apply(color: dayColor)
              style: TextStyle(
                fontSize: 12,
                color: dayColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            focusNode: _dayFocusNodes[day - 1],
            onTap: () => widget.onChanged(dayToBuild),
            radius: _dayPickerRowHeight / 2 + 4,
            splashColor: selectedDayBackground.withOpacity(0.38),
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(_dayPickerRowHeight,
        constraints.viewportMainAxisExtent / (_maxDayPickerRowCount + 1));
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

/// A scrollable list of years to allow picking a year.
class _YearPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [currentDate, [firstDate], [lastDate], [selectedDate], and [onChanged]
  /// arguments must be non-null. The [lastDate] must be after the [firstDate].
  _YearPicker({
    Key? key,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.selectedDate,
    required this.onChanged,
  })  : assert(currentDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(initialDate != null),
        assert(selectedDate != null),
        assert(onChanged != null),
        assert(!firstDate.isAfter(lastDate)),
        super(key: key);

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The initial date to center the year display around.
  final DateTime initialDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<_YearPicker> {
  late ScrollController scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();

    // Set the scroll position to approximately center the initial year.
    final int initialYearIndex =
        widget.selectedDate.year - widget.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ _yearPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    final double scrollOffset =
        _itemCount < minYears ? 0 : centeredYearRow * _yearPickerRowHeight;
    scrollController = ScrollController(initialScrollOffset: scrollOffset);
  }

  Widget _buildYearItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0;
    final int year = widget.firstDate.year + index - offset;
    final bool isSelected = year == widget.selectedDate.year;
    final bool isCurrentYear = year == widget.currentDate.year;
    final bool isDisabled =
        year < widget.firstDate.year || year > widget.lastDate.year;
    const double decorationHeight = 32.0;
    const double decorationWidth = 66.0;

    Color textColor;
    if (isSelected) {
      textColor = Theme.of(context).brightness == Brightness.dark
          ? Color(0xff000000)
          : Color(0xffffffff);
    } else if (isDisabled) {
      textColor = Theme.of(context).brightness == Brightness.dark
          ? Color(0xffffffff).withOpacity(0.87)
          : Color(0xff384341);
    } else if (isCurrentYear) {
      textColor = Theme.of(context).brightness == Brightness.dark
          ? Color(0xffBD78CE)
          : Color(0xff9F2DBC);
    } else {
      textColor = Theme.of(context).brightness == Brightness.dark
          ? Color(0xffffffff).withOpacity(0.87)
          : Color(0xff384341);
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color(0xffBD78CE)
            : Color(0xff9F2DBC),
        borderRadius: BorderRadius.circular(decorationHeight / 2),
        shape: BoxShape.rectangle,
      );
    } else if (isCurrentYear && !isDisabled) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(decorationHeight / 2),
        shape: BoxShape.rectangle,
        color: Theme.of(context).brightness == Brightness.dark
            ? Color(0xffBD78CE).withOpacity(0.2)
            : Color(0xff9F2DBC).withOpacity(0.1),
      );
    }

    Widget yearItem = Center(
      child: Container(
        decoration: decoration,
        height: decorationHeight,
        width: decorationWidth,
        child: Center(
          child: Semantics(
            selected: isSelected,
            child: Text(
              year.toString(),
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );

    if (isDisabled) {
      yearItem = ExcludeSemantics(
        child: yearItem,
      );
    } else {
      yearItem = InkWell(
        key: ValueKey<int>(year),
        onTap: () {
          widget.onChanged(
            DateTime(
              year,
              widget.initialDate.month,
              widget.initialDate.day,
            ),
          );
        },
        child: yearItem,
      );
    }

    return yearItem;
  }

  int get _itemCount {
    return widget.lastDate.year - widget.firstDate.year + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 17,
        ),
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: _yearPickerGridDelegate,
            itemBuilder: _buildYearItem,
            itemCount: math.max(_itemCount, minYears),
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        ),
      ],
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  const _YearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_yearPickerColumnCount - 1) * _yearPickerRowSpacing) /
        _yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _yearPickerRowHeight,
      crossAxisCount: _yearPickerColumnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: _yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}

const _YearPickerGridDelegate _yearPickerGridDelegate =
    _YearPickerGridDelegate();
