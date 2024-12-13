// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:intl/intl.dart';
//
//import '../input_border.dart';
//import '../input_decorator.dart';
//import '../material_localizations.dart';
//import '../text_form_field.dart';
//import '../theme.dart';
//
//import 'date_picker_common.dart';
//import 'date_utils.dart' as utils;

// import 'package:flutter/src/material/pickers/date_picker_common.dart';
// import 'package:flutter/src/material/date_picker.dart' as utils;
// import 'package:date_utils/date_utils.dart' as utils;

// import 'package:flutter/src/material/pickers/date_utils.dart' as utils;

/// A [TextFormField] configured to accept and validate a date entered by a user.
///
/// When the field is saved or submitted, the text will be parsed into a
/// [DateTime] according to the ambient locale's compact date format. If the
/// input text doesn't parse into a date, the [errorFormatText] message will
/// be displayed under the field.
///
/// [firstDate], [lastDate], and [selectableDayPredicate] provide constraints on
/// what days are valid. If the input date isn't in the date range or doesn't pass
/// the given predicate, then the [errorInvalidText] message will be displayed
/// under the field.
///
/// See also:
///
///  * [showDatePicker], which shows a dialog that contains a material design
///    date picker which includes support for text entry of dates.
///  * [MaterialLocalizations.parseCompactDate], which is used to parse the text
///    input into a [DateTime].
///
class CustomInputDatePickerFormField extends StatefulWidget {
  /// Creates a [TextFormField] configured to accept and validate a date.
  ///
  /// If the optional [initialDate] is provided, then it will be used to populate
  /// the text field. If the [fieldHintText] is provided, it will be shown.
  ///
  /// If [initialDate] is provided, it must not be before [firstDate] or after
  /// [lastDate]. If [selectableDayPredicate] is provided, it must return `true`
  /// for [initialDate].
  ///
  /// [firstDate] must be on or before [lastDate].
  ///
  /// [firstDate], [lastDate], and [autofocus] must be non-null.
  ///
  CustomInputDatePickerFormField({
    Key? key,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    this.onDateSubmitted,
    this.onDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.autofocus = false,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(autofocus != null),
        initialDate =
            initialDate != null ? DateUtils.dateOnly(initialDate) : null,
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        super(key: key) {
    assert(!this.lastDate.isBefore(this.firstDate),
        'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.');
    assert(initialDate == null || !this.initialDate!.isBefore(this.firstDate),
        'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.');
    assert(initialDate == null || !this.initialDate!.isAfter(this.lastDate),
        'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.');
    assert(
        selectableDayPredicate == null ||
            initialDate == null ||
            selectableDayPredicate!(this.initialDate!),
        'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.');
  }

  /// If provided, it will be used as the default value of the field.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDate;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field. Will only be called if the input represents a valid
  /// [DateTime].
  final ValueChanged<DateTime>? onDateSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save]. Will only be called if the input represents
  /// a valid [DateTime].
  final ValueChanged<DateTime>? onDateSaved;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String? errorInvalidText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format string. For example,
  /// 'mm/dd/yyyy' for en_US.
  final String? fieldHintText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String? fieldLabelText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool? autofocus;

  @override
  _InputDatePickerFormFieldState createState() =>
      _InputDatePickerFormFieldState();
}

class _InputDatePickerFormFieldState
    extends State<CustomInputDatePickerFormField> {
  final TextEditingController _controller = TextEditingController();
  late DateTime _selectedDate;
  String? _inputText;
  bool _autoSelected = false;
  bool _invalidInput = false;
  String? msg;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedDate != null) {
      // final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      // _inputText = localizations.formatCompactDate(_selectedDate);
      _inputText = dateToString(_selectedDate);
      TextEditingValue textEditingValue =
          _controller.value.copyWith(text: _inputText);
      // Select the new text if we are auto focused and haven't selected the text before.
      if (widget.autofocus != null && widget.autofocus! && !_autoSelected) {
        textEditingValue = textEditingValue.copyWith(
            selection: TextSelection(
          baseOffset: 0,
          extentOffset: _inputText?.length ?? 0,
        ));
        _autoSelected = true;
      }
      _controller.value = textEditingValue;
    }
  }

  DateTime? _parseDate(String? text) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  bool _isValidAcceptableDate(DateTime date) {
    return date != null &&
        !date.isBefore(widget.firstDate) &&
        !date.isAfter(widget.lastDate) &&
        (widget.selectableDayPredicate == null ||
            widget.selectableDayPredicate!(date));
  }

  String? _validateDate(String text) {
    final DateTime? date = _parseDate(text);
    if (date == null) {
      return widget.errorFormatText ??
          MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      return widget.errorInvalidText ??
          MaterialLocalizations.of(context).dateOutOfRangeLabel;
    }
    return null;
  }


  void _handleSaved(String? text) {
    _updateDate(text, widget.onDateSaved);
  }

  void _updateDate(String? text, ValueChanged<DateTime>? callback) {
    final DateTime? date = DateFormat(DateUtil.calendarDateddMMyyyy).parse(text ?? '');
    if (date != null && _isValidAcceptableDate(date)) {
      _selectedDate = date;
      _inputText = text;
      callback?.call(_selectedDate);
    }
  }

  void _handleSubmitted(String text) {
    if (widget.onDateSubmitted != null) {
      // final DateTime date = _parseDate(text);
      final DateTime? date = stringToDate(text);
      if (date != null && _isValidAcceptableDate(date)) {
        _selectedDate = date;
        _inputText = text;
        widget.onDateSubmitted!(date);
      }
    }
  }

  String _formatTwoDigitZeroPad(int number) {
    assert(0 <= number && number < 100);

    if (number < 10) return '0$number';

    return '$number';
  }

  String dateToString(DateTime date) {
    // Assumes US mm/dd/yyyy format
    final String month = _formatTwoDigitZeroPad(date.month);
    final String day = _formatTwoDigitZeroPad(date.day);
    final String year = date.year.toString().padLeft(4, '0');
    return '$day/$month/$year';
  }

  int _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29;
      return 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }

  DateTime? stringToDate(String inputString) {
    // Assumes dd/mm/yyyy format
    final List<String> inputParts = inputString.split('/');
    if (inputParts.length != 3) {
      return null;
    }

    final int? year = int.tryParse(inputParts[2], radix: 10);
    if (year == null || year < 1) {
      return null;
    }

    final int? month = int.tryParse(inputParts[1], radix: 10);
    if (month == null || month < 1 || month > 12) {
      return null;
    }

    final int? day = int.tryParse(inputParts[0], radix: 10);
    if (day == null || day < 1 || day > _getDaysInMonth(year, month)) {
      return null;
    }
    return DateTime(year, month, day);
  }

  String? _customValidateDate(String? text) {
    print('---------validator Called----');
    if (_isFirst) {
      _isFirst = false;
    }
    final DateTime? date = stringToDate(text ?? "");
    print('-------------------$date----------');
    // final DateTime date = _parseDate(text);
    if (date == null) {
      _invalidInput = true;
      msg = widget.errorFormatText ??
          MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      _invalidInput = true;
      msg = widget.errorInvalidText ??
          MaterialLocalizations.of(context).dateOutOfRangeLabel;
    } else {
      _invalidInput = false;
      msg = null;
    }
    return msg;
  }

  void onChange(text) {
    String val = msg ?? "";
    if (val != _customValidateDate(text)) {
      setState(() {});
    }
    if (widget.onDateSubmitted != null) {
      // final DateTime date = _parseDate(text);
      final DateTime? date = stringToDate(text);
      if (date != null && _isValidAcceptableDate(date)) {
        _selectedDate = date;
        _inputText = text;
        widget.onDateSubmitted!(date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final InputDecorationTheme inputTheme =
        Theme.of(context).inputDecorationTheme;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: Key("dobEditContainer"),
            // height: 39,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                depression: 4,
                colors: [
                  Theme.of(context).brightness == Brightness.dark
                      ? Color(0xff000000).withOpacity(0.75)
                      : Color(0xffD1D9E6),
                  Theme.of(context).brightness == Brightness.dark
                      ? Color(0xffD1D9E6).withOpacity(0.1)
                      : Color(0xffffffff),
                ]),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: inputTheme.filled,
                errorStyle: TextStyle(height: 0, fontSize: 0),
                hintText: widget.fieldHintText ?? localizations.dateHelpText,
              ),
              validator: _customValidateDate,
              // keyboardType: TextInputType.datetime,`
              onSaved: _handleSaved,
              onFieldSubmitted: _handleSubmitted,
              autofocus: widget.autofocus!,
              controller: _controller,
              onChanged: _handleSubmitted,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 11.w),
              child: Text(
                _invalidInput ? msg ?? '' : '',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ))
        ]);
  }
}
