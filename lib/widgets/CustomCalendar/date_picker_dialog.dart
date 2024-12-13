// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/src/material/pickers/date_picker_common.dart';
// import 'package:flutter/src/material/pickers/date_utils.dart' as utils;
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'calendar_date_picker.dart';
import 'date_picker_header.dart';
import 'input_date_picker.dart';


class CustomSize {
  double height;
  double width;
  CustomSize(this.width, this.height);
}

var _calendarPortraitDialogSize = CustomSize(309.0.w, 463.0.h);
var _calendarLandscapeDialogSize = CustomSize(496.0.w, 346.0.h);
var _inputPortraitDialogSize = CustomSize(309.0.w, 234.0);
var _inputLandscapeDialogSize = CustomSize(496.w, 160.0.h);
var _dialogSizeAnimationDuration = Duration(milliseconds: 200);
double _inputFormPortraitHeight = 98.0.h;
double _inputFormLandscapeHeight = 108.0.h;

/// Shows a dialog containing a Material Design date picker.
///
/// The returned [Future] resolves to the date selected by the user when the
/// user confirms the dialog. If the user cancels the dialog, null is returned.
///
/// When the date picker is first displayed, it will show the month of
/// [initialDate], with [initialDate] selected.
///
/// The [firstDate] is the earliest allowable date. The [lastDate] is the latest
/// allowable date. [initialDate] must either fall between these dates,
/// or be equal to one of them. For each of these [DateTime] parameters, only
/// their dates are considered. Their time fields are ignored. They must all
/// be non-null.
///
/// The [currentDate] represents the current day (i.e. today). This
/// date will be highlighted in the day grid. If null, the date of
/// `DateTime.now()` will be used.
///
/// An optional [initialEntryMode] argument can be used to display the date
/// picker in the [DatePickerEntryMode.calendar] (a calendar month grid)
/// or [DatePickerEntryMode.input] (a text input field) mode.
/// It defaults to [DatePickerEntryMode.calendar] and must be non-null.
///
/// An optional [selectableDayPredicate] function can be passed in to only allow
/// certain days for selection. If provided, only the days that
/// [selectableDayPredicate] returns true for will be selectable. For example,
/// this can be used to only allow weekdays for selection. If provided, it must
/// return true for [initialDate].
///
/// The following optional string parameters allow you to override the default
/// text used for various parts of the dialog:
///
///   * [helpText], label displayed at the top of the dialog.
///   * [cancelText], label on the cancel button.
///   * [confirmText], label on the ok button.
///   * [errorFormatText], message used when the input text isn't in a proper date format.
///   * [errorInvalidText], message used when the input text isn't a selectable date.
///   * [fieldHintText], text used to prompt the user when no text has been entered in the field.
///   * [fieldLabelText], label for the date text input field.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// ([TextDirection.ltr] or [TextDirection.rtl]) for the date picker. It
/// defaults to the ambient text direction provided by [Directionality]. If both
/// [locale] and [textDirection] are non-null, [textDirection] overrides the
/// direction chosen for the [locale].
///
/// The [context], [useRootNavigator] and [routeSettings] arguments are passed to
/// [showDialog], the documentation for which discusses how it is used. [context]
/// and [useRootNavigator] must be non-null.
///
/// The [builder] parameter can be used to wrap the dialog widget
/// to add inherited widgets like [Theme].
///
/// An optional [initialDatePickerMode] argument can be used to have the
/// calendar date picker initially appear in the [DatePickerMode.year] or
/// [DatePickerMode.day] mode. It defaults to [DatePickerMode.day], and
/// must be non-null.
///
/// See also:
///
///  * [showDateRangePicker], which shows a material design date range picker
///    used to select a range of dates.
///  * [CustomCalendarDatePicker], which provides the calendar grid used by the date picker dialog.
///  * [CustomInputDatePickerFormField], which provides a text input field for entering dates.
///
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  required String getDatabaseDataFrom,
}) async {
  assert(context != null);
  assert(initialDate != null);
  assert(firstDate != null);
  assert(lastDate != null);
  initialDate = DateUtils.dateOnly(initialDate);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(!lastDate.isBefore(firstDate),
      'lastDate $lastDate must be on or after firstDate $firstDate.');
  assert(!initialDate.isBefore(firstDate),
      'initialDate $initialDate must be on or after firstDate $firstDate.');
  assert(!initialDate.isAfter(lastDate),
      'initialDate $initialDate must be on or before lastDate $lastDate.');
  assert(selectableDayPredicate == null || selectableDayPredicate(initialDate),
      'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.');
  assert(initialEntryMode != null);
  assert(useRootNavigator != null);
  assert(initialDatePickerMode != null);
  assert(debugCheckHasMaterialLocalizations(context));
  assert(getDatabaseDataFrom != null);

  Widget dialog = _DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
    getDatabaseDataFrom: getDatabaseDataFrom,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

class _DatePickerDialog extends StatefulWidget {
  _DatePickerDialog(
      {Key? key,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate,
      DateTime? currentDate,
      this.initialEntryMode = DatePickerEntryMode.calendar,
      this.selectableDayPredicate,
      this.cancelText,
      this.confirmText,
      this.helpText,
      this.initialCalendarMode = DatePickerMode.day,
      this.errorFormatText,
      this.errorInvalidText,
      this.fieldHintText,
      this.fieldLabelText,
      required this.getDatabaseDataFrom})
      : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        assert(initialEntryMode != null),
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
        'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate');
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

  final DatePickerEntryMode initialEntryMode;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The text that is displayed on the cancel button.
  final String? cancelText;

  /// The text that is displayed on the confirm button.
  final String? confirmText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  final String? errorFormatText;

  final String? errorInvalidText;

  final String? fieldHintText;

  final String? fieldLabelText;

  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  late DatePickerEntryMode _entryMode;
  late DateTime _selectedDate;
  late AutovalidateMode _autoValidate;
  final GlobalKey _calendarPickerKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _entryMode = widget.initialEntryMode;
    _selectedDate = widget.initialDate;
    _autoValidate = AutovalidateMode.disabled;
  }

  void _handleOk() {
    if (_entryMode == DatePickerEntryMode.input) {
      final FormState form = _formKey.currentState!;
      if (!form.validate()) {
        setState(() => _autoValidate = AutovalidateMode.always);
        return;
      }
      form.save();
    }
    Navigator.pop(context, _selectedDate);
  }

  void _handleCancel() {
    Navigator.pop(context, widget.initialDate);
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode) {
        case DatePickerEntryMode.calendar:
          _autoValidate = AutovalidateMode.disabled;
          _entryMode = DatePickerEntryMode.input;
          break;
        case DatePickerEntryMode.input:
          _formKey.currentState!.save();
          _entryMode = DatePickerEntryMode.calendar;
          break;
        default:
          break;
      }
    });
  }

  void _handleDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  CustomSize? _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (_entryMode) {
      case DatePickerEntryMode.calendar:
        switch (orientation) {
          case Orientation.portrait:
            return _calendarPortraitDialogSize;
          case Orientation.landscape:
            return _calendarLandscapeDialogSize;
        }
      case DatePickerEntryMode.input:
        switch (orientation) {
          case Orientation.portrait:
            return _inputPortraitDialogSize;
          case Orientation.landscape:
            return _inputLandscapeDialogSize;
        }
      default:
        break;
    }
    return null;
  }

  static final Map<LogicalKeySet, Intent> _formShortcutMap =
      <LogicalKeySet, Intent>{
    // Pressing enter on the field will move focus to the next field or control.
    LogicalKeySet(LogicalKeyboardKey.enter): const NextFocusIntent(),
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final TextTheme textTheme = theme.textTheme;
    // Constrain the textScaleFactor to the largest supported value to prevent
    // layout issues.
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);

    final String dateText = _selectedDate != null
        ? localizations.formatMediumDate(_selectedDate)
        : localizations.unspecifiedDate;
    final Color dateColor = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final TextStyle? dateStyle = orientation == Orientation.landscape
        ? textTheme.headline5?.copyWith(color: dateColor)
        : textTheme.headline4?.copyWith(color: dateColor);

    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: BoxConstraints(minHeight: 52.0.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: OverflowBar(
        spacing: 8,
        children: <Widget>[
          TextButton(
            child: Text(
              widget.cancelText ?? localizations.cancelButtonLabel,
              style: TextStyle(
                  color: Color(0xff00AFAA),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: _handleCancel,
          ),
          TextButton(
            child: Text(
              widget.confirmText ??
                  stringLocalization
                      .getText(StringLocalization.ok)
                      .toUpperCase(),
              style: TextStyle(
                  color: Color(0xff00AFAA),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: _handleOk,
          ),
        ],
      ),
    );

    Widget? picker;
    IconData? entryModeIcon;
    String? entryModeTooltip;
    switch (_entryMode) {
      case DatePickerEntryMode.calendar:
        picker = CustomCalendarDatePicker(
          key: _calendarPickerKey,
          initialDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          currentDate: widget.currentDate,
          onDateChanged: _handleDateChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
          initialCalendarMode: widget.initialCalendarMode,
          getDatabaseDataFrom: widget.getDatabaseDataFrom,
        );
        entryModeIcon = Icons.edit;
        entryModeTooltip = localizations.inputDateModeButtonLabel;
        break;

      case DatePickerEntryMode.input:
        picker = Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 23.w),
            height: orientation == Orientation.portrait
                ? _inputFormPortraitHeight
                : _inputFormLandscapeHeight,
            child: Shortcuts(
              shortcuts: _formShortcutMap,
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  Container(
                    // height: 39,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xff111B1A)
                          : Color(0xffEEF1F1),
                    ),
                    child: CustomInputDatePickerFormField(
                      initialDate: _selectedDate,
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      onDateSubmitted: _handleDateChanged,
                      onDateSaved: _handleDateChanged,
                      selectableDayPredicate: widget.selectableDayPredicate,
                      fieldHintText: widget.fieldHintText,
                      autofocus: true,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
        entryModeIcon = Icons.calendar_today;
        entryModeTooltip = localizations.calendarModeButtonLabel;
        break;
      default:
        break;
    }

    final Widget header = CustomDatePickerHeader(
      helpText: widget.helpText ?? localizations.datePickerHelpText,
      titleText: dateText,
      titleStyle: dateStyle!,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
      icon: entryModeIcon!,
      iconTooltip: entryModeTooltip!,
      onIconPressed: _handleEntryModeToggle,
      mode: _entryMode,
    );

    final CustomSize? dialogSize = _dialogSize(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex("#111B1A")
          : AppColor.backgroundColor,
      child: AnimatedContainer(
        width: dialogSize?.width,
        height: dialogSize?.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xff111B1A)
                : Color(0xffEEF1F1),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                    : HexColor.fromHex("#DDE3E3").withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(-5, -5),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#000000").withOpacity(0.75)
                    : HexColor.fromHex("#384341").withOpacity(0.9),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(5, 5),
              ),
            ]),
        child: Builder(builder: (BuildContext context) {
          switch (orientation) {
            case Orientation.portrait:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  Expanded(child: picker!),
                  actions,
                ],
              );
            case Orientation.landscape:
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(child: picker!),
                        actions,
                      ],
                    ),
                  ),
                ],
              );
          }
        }),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      //clipBehavior: Clip.antiAlias,
    );
  }
}
