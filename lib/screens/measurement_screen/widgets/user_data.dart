import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class UserData extends StatelessWidget {
  final hrCalibrationTextEditController;
  final sbpCalibrationTextEditController;
  final dbpCalibrationTextEditController;

  const UserData(
      {Key? key,
      required this.hrCalibrationTextEditController,
      required this.sbpCalibrationTextEditController,
      required this.dbpCalibrationTextEditController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.h,
          child: TitleText(
            text: 'Data entered by user',
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
        ),
        SizedBox(height: 15.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 25.h,
              child: TitleText(
                text: 'HR : ${hrCalibrationTextEditController.text}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
            SizedBox(
              height: 25.h,
              child: TitleText(
                text: 'Sys: ${sbpCalibrationTextEditController.text}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
            SizedBox(
              height: 25.h,
              child: TitleText(
                text: 'Dia: ${dbpCalibrationTextEditController.text}',
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
