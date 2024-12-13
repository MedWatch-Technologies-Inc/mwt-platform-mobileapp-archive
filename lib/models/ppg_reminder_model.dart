
import 'package:flutter/material.dart';

import 'reminder_model.dart';

class PpgReminderModel {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<TimeOfDay>? interval;
  List? days = REMINDER_DAYS;

  PpgReminderModel({ this.startTime, this.endTime, this.interval, this.days});


  }