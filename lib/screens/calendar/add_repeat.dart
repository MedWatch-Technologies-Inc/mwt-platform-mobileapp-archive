import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/calendar/custom_alert.dart';
import 'package:health_gauge/screens/calendar/select_list_item.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class AddRepeatScreen extends StatefulWidget {
  final int item;

  AddRepeatScreen({required this.item});

  @override
  _AddRepeatScreenState createState() => _AddRepeatScreenState();
}

class _AddRepeatScreenState extends State<AddRepeatScreen> {

  List<String> repeatTypeList = [
    'None',
    'Every Day',
    'Every Week',
    'Every Month',
    'Every Year'
  ];
  late int selectedItem;
  Map<int, String> mappedRepeat = {};

  @override
  void initState() {
    selectedItem = widget.item;
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
                          'Repeat',
                          style: TextStyle(
                            fontSize: 16,
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
                          Navigator.of(context).pop(mappedRepeat);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 13.w),
                          child: Text(
                            stringLocalization.getText(StringLocalization.done),
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
                padding: EdgeInsets.only(top: 15.h),
                child: ListView.builder(
                  itemCount: repeatTypeList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return SelectListItem(
                          title: repeatTypeList[index],
                          isSelected: selectedItem == index ? true : false,
                          onTap: (){
                            mappedRepeat.clear();
                            setState(() {
                              selectedItem = index;
                              mappedRepeat[index] = repeatTypeList[index];
                            });
                          });
                    }),
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                    : HexColor.fromHex('#D9E0E0'),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 68.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomAlertScreen()));
                  },
                  child: Text(
                    'Custom ...',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
