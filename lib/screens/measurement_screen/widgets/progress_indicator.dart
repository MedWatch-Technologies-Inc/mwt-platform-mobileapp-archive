
import 'package:flutter/material.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/screens/dashboard/extensions/my_painter_widget.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
class ProgressIndicatorNew extends StatelessWidget {
  final int countDown;
  final Color progressColor;
  final DeviceModel? connectedDevice;
  const ProgressIndicatorNew({required this.countDown, required this.progressColor,required this.connectedDevice,Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var limit = 30;
    try {
      if (connectedDevice?.sdkType == Constants.e66) {
        // limit = 60;
        // limit = 30;
        limit = measurementTime.value;
      }
    } catch (e) {
      debugPrint('Exception at progressIndicator $e');
      LoggingService()
          .warning('Measurement', 'Exception at progressIndicator', error: e);
    }
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return RotationTransition(
        turns: AlwaysStoppedAnimation((0 * 360 / 60) / 360),
        child: CustomPaint(
          painter: MyPainter(
            lineColor: isDarkMode
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            completeColor: progressColor,
            completePercent: countDown == 0
                ? (countDown / limit * 100)
                : (countDown / limit * 100) - 1,
            width: 8.w,
          ),
          child: Center(
            child: SizedBox(
              height: 25.h,
              child: Body1AutoText(
                text: countDown.toString(),
                color: isDarkMode
                    ? Colors.white.withOpacity(0.6)
                    : HexColor.fromHex('#384341'),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                minFontSize: 12,
              ),
            ),
          ),
        ));
  }
}
