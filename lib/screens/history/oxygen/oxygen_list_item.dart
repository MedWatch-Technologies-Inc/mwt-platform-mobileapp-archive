import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class OxygenListItem extends StatefulWidget {
   final TempModel tempModel;

  final GestureTapCallback? onClickItem;

  const OxygenListItem({Key? key, required this.tempModel, this.onClickItem})
      : super(key: key);

  @override
  _OxygenListItemState createState() => _OxygenListItemState(tempModel);
}

class _OxygenListItemState extends State<OxygenListItem> {
  final TempModel tempModel;

  _OxygenListItemState(this.tempModel);

  @override
  Widget build(BuildContext context) {
    return Visibility(
    visible: (tempModel.oxygen??0) > 0,
      child: GestureDetector(
        child: Container(
          height: 56.h,
          margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13.h),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                gradient: Theme.of(context).brightness == Brightness.dark
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                            HexColor.fromHex('#CC0A00').withOpacity(0.15),
                            HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                          ])
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                            HexColor.fromHex('#FF9E99').withOpacity(0.1),
                            HexColor.fromHex('#9F2DBC').withOpacity(0.023),
                          ])),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  Expanded(
                    child: Body1Text(
                      text: removeTrailingZero('${tempModel.oxygen ?? ''}')+' %',
                      fontSize: 16.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex(
                              '384341',
                            ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Body1Text(
                      text: DateFormat(DateUtil.hmma).format(
                        DateTime.parse(
                          tempModel.date ?? DateTime.now().toString(),
                        ),
                      ),
                      fontSize: 16.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex(
                              '384341',
                            ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: widget.onClickItem,
      ),
    );
  }

  String removeTrailingZero(String string) {
    if (!string.contains('.')) {
      return string;
    }
    string = string.replaceAll(RegExp(r'0*$'), '');
    if (string.endsWith('.')) {
      string = string.substring(0, string.length - 1);
    }
    return string;
  }
}
