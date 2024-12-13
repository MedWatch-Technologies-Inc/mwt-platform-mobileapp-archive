import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/calendar/custom_alert.dart';
import 'package:health_gauge/screens/calendar/select_list_item.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';

class SelectColorScreen extends StatefulWidget {
  final Color color;
  SelectColorScreen({required this.color});

  @override
  _SelectColorScreenState createState() => _SelectColorScreenState();
}

class _SelectColorScreenState extends State<SelectColorScreen> {

  List<String> colorNameList = [];
  List<Color> colorList = [];
  late Color selectedColor;
  Map<Color, String> mappedColor = {};

  @override
  void initState() {
    selectedColor = widget.color;
    colorNameList = [
      'Default',
      'Purple',
      'Green',
      'Black'
    ];
    colorList = [
      AppColor.colorFF6259,
      AppColor.color9F2DBC,
      AppColor.color00AFAA,
      AppColor.color111B1A,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#7F8D8C')
          : HexColor.fromHex('#384341'),
      body: Padding(
        padding: EdgeInsets.only(top: 50.0.h),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.h),
                  topRight: Radius.circular(20.h))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 26.w, top: 26.h),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Theme.of(context).brightness == Brightness.dark
                              ? Image.asset(
                            'asset/dark_leftArrow.png',
                            width: 13,
                            height: 22,
                          )
                              : Image.asset(
                            'asset/leftArrow.png',
                            width: 13,
                            height: 22,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 17.w),
                        child: Text(
                         'Color',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(mappedColor);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 13.w),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: HexColor.fromHex('#00AFAA'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 15.h,),
                child: ListView.builder(
                    itemCount: colorList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return SelectListItem(
                        isColor: true,
                          title: colorNameList[index],
                          isSelected: selectedColor == colorList[index] ? true : false,
                          color: colorList[index],
                          onTap: (){
                            mappedColor.clear();
                            setState(() {
                              selectedColor = colorList[index];
                              mappedColor[colorList[index]] = colorNameList[index];
                            });
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
