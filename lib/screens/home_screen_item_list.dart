import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenItemList extends StatefulWidget {
  final TempModel? model;

  const HomeScreenItemList({Key? key, this.model}) : super(key: key);

  @override
  _HomeScreenItemListState createState() => _HomeScreenItemListState();
}

class _HomeScreenItemListState extends State<HomeScreenItemList> {
  List<String> listOfString = [];
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    initializeWidget();
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : HexColor.fromHex('#384341').withOpacity(0.2),
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                )
              ]),
              child: AppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                elevation: 0,
                leading: IconButton(
                  padding: EdgeInsets.only(left: 10),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Theme.of(context).brightness == Brightness.dark
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
                title: SizedBox(
                  height: 28,
                  // child: AutoSizeText(
                  //   stringLocalization
                  //       .getText(StringLocalization.homeScreenItems),
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  //   maxLines: 1,
                  //   minFontSize: 10,
                  // ),
                  child: Body1AutoText(
                    text: stringLocalization
                        .getText(StringLocalization.homeScreenItems),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    minFontSize: 10,
                    maxLine: 1,
                    color: HexColor.fromHex('62CBC9'),
                  ),
                ),
                centerTitle: true,
                actions: [
                  InkWell(
                    onTap: (){
                      preferences?.remove(Constants.prefHomeScreenItems);
                      isLoading = null;
                      listOfString = [
                        'bloodPressure',
                        'distance',
                        'step',
                        'heartRate',
                        'hrv',
                        'sleep',
                        'weight',
                        'bloodGlucose',
                         'temperature',
                        'oxygen',
                      ];
                      // initializeWidget();
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      child: Body1AutoText(
                        align: TextAlign.center,
                        text:stringLocalization
                            .getText(StringLocalization.reset)
                            .toUpperCase(),
                        fontSize: 14,
                        minFontSize: 10,
                        maxLine: 1,
                        fontWeight: FontWeight.bold,
                        color: AppColor.progressColor,
                      ),
                    ),
                  ),
                  /*FlatBtn(
                    onPressed: () {

                    },
                    text: stringLocalization
                        .getText(StringLocalization.reset)
                        .toUpperCase(),
                    color: AppColor.progressColor,
                  )*/
                ],
              ),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) async {
              if (newIndex > oldIndex) {
                newIndex = newIndex - 1;
              }
              final item = listOfString.removeAt(oldIndex);
              listOfString.insert(newIndex, item);

              // String stringA = listOfString.elementAt(oldIndex);
              // String stringB = listOfString.elementAt(newIndex);

              if (preferences == null) {
                preferences = await SharedPreferences.getInstance();
              }

              List<String> homescreenItems =
                  listOfString.map((e) => e.toString()).toList();
              preferences?.setStringList(
                  Constants.prefHomeScreenItems, homescreenItems);
              print(
                  'prefHomeScreenItems ${preferences?.getStringList(Constants.prefHomeScreenItems)}');
              if (this.mounted) {
                setState(() {});
              }
            },
            children: List.generate(listOfString.length, (index) {
              return Container(
                key: ValueKey('index-${listOfString[index]}'),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : AppColor.backgroundColor,
                  border: Border(
                      bottom: BorderSide(
                          color: index == 6 ? Colors.black : Colors.transparent,
                          width: 0.5)),
                ),
                child: getWidgetFromKey(listOfString[index]),
              );
            }),
          ),
        ));
  }

  Widget getWidgetFromKey(String key) {
    print('getWidgetFromKey $key');
    switch (key) {
      case 'bloodPressure':
        return bloodPressure();
        break;
      case 'distance':
        return distance();
        break;
      case 'step':
        return step();
        break;
      case 'heartRate':
        return heartRate();
        break;
      case 'hrv':
        return hrv();
        break;
      case 'sleep':
        return sleep();
        break;
      case 'weight':
        return weight();
        break;
      // case 'bloodGlucose':
      //   return bloodGlucose();
      //   break;
      case 'temperature':
        return temperature();
        break;
      case 'oxygen':
        return oxygen();
        break;
    }

    return Container();
  }

  void initializeWidget() {
    if (isLoading == null) {
      listOfString = preferences?.getStringList(Constants.prefHomeScreenItems) ?? [];
      print('listOfString $listOfString');
      if (listOfString.isEmpty) {
        listOfString = [
          'bloodPressure',
          'distance',
          'step',
          'heartRate',
          'hrv',
          'sleep',
          'bloodGlucose',
          'weight',
          'temperature',
          'oxygen',
        ];
      }
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
      print('listOfString $listOfString');
    }
  }

  Widget bloodPressure() {
    return ListTile(
      key: ValueKey('bloodPressure'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_bp_butt_off.png'
            : 'asset/bp_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.bloodPressure),
          fontSize: 14),
    );
  }

  Widget divider() {
    return Padding(
      key: ValueKey('divider'),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Divider(
        color: AppColor.graydark,
        thickness: 1.0,
      ),
    );
  }

  Widget distance() {
    return ListTile(
      key: ValueKey('distance'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_distance_butt_off.png'
            : 'asset/distance_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.distance),
          fontSize: 14),
    );
  }

  Widget step() {
    return ListTile(
      key: ValueKey('step'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_steps_butt_off.png'
            : 'asset/steps_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.steps),
          fontSize: 14),
    );
  }

  Widget heartRate() {
    return ListTile(
      key: ValueKey('heartRate'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_hr_butt_off.png'
            : 'asset/hr_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.heartRate),
          fontSize: 14),
    );
  }

  Widget hrv() {
    return ListTile(
      key: ValueKey('hrv'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_stress_butt_off.png'
            : 'asset/stress_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.hrv),
          fontSize: 14),
    );
  }

  Widget sleep() {
    return ListTile(
      key: ValueKey('sleep'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_sleep_butt_off.png'
            : 'asset/sleep_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.sleep),
          fontSize: 14),
    );
  }

  Widget weight() {
    return ListTile(
      key: ValueKey('weight'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_weight_butt_off.png'
            : 'asset/weight_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.weight),
          fontSize: 14),
    );
  }


  Widget bloodGlucose() {
    return ListTile(
      key: ValueKey('bloodGlucose'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? "asset/ecg_icon_unselected.png"
            : "asset/ecg_icon_selected.png",
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.bloodGlucose),
          fontSize: 14),
    );
  }


  Widget temperature() {
    return ListTile(
      key: ValueKey('temperature'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_temp_butt_off.png'
            : 'asset/temperature_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.bodyTemperature),
          fontSize: 14),
    );
  }

  Widget oxygen() {
    return ListTile(
      key: ValueKey('oxygen'),
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () {},
      leading: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_oxygen_butt_off.png'
            : 'asset/oxygen_butt_off.png',
        height: 30.h,
        width: 30.h,
      ),
      title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.bloodOxygen),
          fontSize: 14),
    );
  }
}
