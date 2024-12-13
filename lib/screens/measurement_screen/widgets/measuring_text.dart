import 'package:flutter/material.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class MeasuringText extends StatelessWidget {
  final ValueNotifier<bool> poorConductivityNotifier;
  final ValueNotifier<bool> leadOfNotifier;
  final ValueNotifier<bool> isMeasuring;

  const MeasuringText({
    required this.poorConductivityNotifier,
    required this.leadOfNotifier,
    required this.isMeasuring,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!leadOfNotifier.value && !poorConductivityNotifier.value && isMeasuring.value) {
      return ValueListenableBuilder<bool>(
        valueListenable: isMeasuring,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Display1Text(
                text: stringLocalization.getText(StringLocalization.goodSignal),
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#99D9D9')
                    : HexColor.fromHex('#00AFAA'),
                fontSize: 16.sp,
              ),
            ],
          );
        },
      );
    } else if (!leadOfNotifier.value && !poorConductivityNotifier.value && !isMeasuring.value) {
      return ValueListenableBuilder<bool>(
        valueListenable: isMeasuring,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Body1AutoText(
                text: stringLocalization.getText(isMeasuring.value
                    ? StringLocalization.measurementInProgress
                    : StringLocalization.readyForMeasurement),
                fontSize: 16.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                    : HexColor.fromHex('#5D6A68'),
                minFontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ],
          );
        },
      );
    }
    return Container();
  }
}
