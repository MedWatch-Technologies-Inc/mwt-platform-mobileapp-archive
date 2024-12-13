import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/widgets/CustomTimePicker/time_picker.dart';

TimeOfDay timeofday = TimeOfDay.now();

class Time {
  Future<TimeOfDay> selectTime(
      BuildContext context, TimeOfDay timeofday) async {
    final TimeOfDay? picked = await showCustomTimePicker(
      context: context,
      initialTime: timeofday,
    );

    if (picked != null && picked != timeofday) timeofday = picked;

    return timeofday;
  }
}
