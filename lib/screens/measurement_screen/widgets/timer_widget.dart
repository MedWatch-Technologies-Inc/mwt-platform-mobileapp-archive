import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  ValueNotifier<int> strTime = ValueNotifier<int>(3);
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      strTime.value = strTime.value - 1;
      if (strTime.value <= 0) {
        if (timer != null) {
          timer!.cancel();
        }
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: strTime,
        builder: (context, value, child) {
          return Text(
            strTime.value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
