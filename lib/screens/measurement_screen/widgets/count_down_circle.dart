

import 'package:flutter/material.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/progress_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
class CountDownCircle extends StatelessWidget {
  final int countDown;
  final Color progressColor;
  final DeviceModel? connectedDevice;
  const CountDownCircle({required this.countDown, required this.progressColor,required this.connectedDevice,Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A').withOpacity(0.1)
              : AppColor.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : Colors.white.withOpacity(0.7),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4.w, -4.h),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(4.w, 4.h),
            ),
          ]),
      child: Container(
        margin: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A').withOpacity(0.1)
              : HexColor.fromHex('#FFDFDE').withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: ConcaveDecoration(
              depression: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.h),
              ),
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.8),
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.4)
                    : Colors.white,
              ]),
          child: ProgressIndicatorNew(countDown: countDown, connectedDevice: connectedDevice, progressColor: progressColor,),
        ),
      ),
    );
  }
}
