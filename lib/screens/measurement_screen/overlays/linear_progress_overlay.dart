import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinearProgressOverlay extends StatelessWidget {
  final ValueNotifier<double> percentage;
  const LinearProgressOverlay({Key? key, required this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ValueListenableBuilder(
        valueListenable: percentage,
        builder: (context, double value, Widget? child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50,
                  alignment: MainAxisAlignment.center,
                  lineHeight: 20.0.sp,
                  percent: value / 100,
                  center: Text(
                    '${value.toInt()}%',
                    style:
                    TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: HexColor.fromHex('#00AFAA'),
                ),
                TitleText(
                  text: 'Calibrating...',
                  color: HexColor.fromHex('#00AFAA'),
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          );
        },
      ),
      color: Colors.black26,
    );
  }
}
