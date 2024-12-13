import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/circular_percent_indicator.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class LinearProgressSynchronisationOverlay extends StatelessWidget {
  final ValueNotifier<double> percentage;
  const LinearProgressSynchronisationOverlay(
      {Key? key, required this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ValueListenableBuilder(
          valueListenable: percentage,
          builder: (context, double value, Widget? child) {
            print('Percentage value:- $value');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 10.0,
                    percent: (value > 100) ? 1 : value.abs() / 100,
                    center: Text(
                      '${(value < 100) ? value.roundToDouble().toInt() : 100} %',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    footer: TitleText(
                      text: 'Synchronizing...',
                      color: HexColor.fromHex('#00AFAA'),
                      fontWeight: FontWeight.bold,
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: HexColor.fromHex('#00AFAA'),
                  ),
                  // LinearPercentIndicator(
                  //   width: MediaQuery.of(context).size.width - 50,
                  //   alignment: MainAxisAlignment.center,
                  //   lineHeight: 20.0.sp,
                  //   percent: value / 100,
                  //   center: Text(
                  //     '${value.toInt()}/100',
                  //     style:
                  //     TextStyle(fontSize: 14.0, color: Colors.black),
                  //   ),
                  //   linearStrokeCap: LinearStrokeCap.roundAll,
                  //   progressColor: HexColor.fromHex('#00AFAA'),
                  // ),
                  // TitleText(
                  //   text: 'Synchronisation...',
                  //   color: HexColor.fromHex('#00AFAA'),
                  //   fontWeight: FontWeight.bold,
                  // ),
                ],
              ),
            );
          },
        ),
        color: Colors.black54,
      ),
    );
  }
}
