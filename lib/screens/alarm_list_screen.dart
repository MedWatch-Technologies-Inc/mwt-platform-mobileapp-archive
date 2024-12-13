import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/alarm_models/alarm_model.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'add_alarm_screen.dart';

/// Added by: Akhil
/// Added on: July/24/2020
/// This widget is for showing alarm list
class AlarmListScreen extends StatefulWidget {
  @override
  _AlarmListScreenState createState() => _AlarmListScreenState();
}

/// Added by: Akhil
/// Added on: July/24/2020
/// This class maintains the state of AlarmListScreen
class _AlarmListScreenState extends State<AlarmListScreen> {
  bool isLoading = false;
  DatabaseHelper helper = DatabaseHelper.instance;



  String? userId;
  int alarmCount = 0;

  List<AlarmModel> alarmList = <AlarmModel>[];

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function gets value from shared preference.
  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function is responsible for building UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex("#384341").withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      "asset/dark_leftArrow.png",
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      "asset/leftArrow.png",
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              StringLocalization.of(context).getText(StringLocalization.alarm),
              style: TextStyle(
                  color: HexColor.fromHex("62CBC9"),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: alarmCount < 5
                      ? Image.asset(
                          "asset/plus.png",
                          width: 18,
                          height: 18,
                        )
                      : Container(),
                  onPressed: alarmCount < 5
                      ? () async {
                          final result = await Constants.navigatePush(
                              AddAlarmScreen(), context);
                          if (result != null && result) {
                            getPreferences();
                          }
                        }
                      : () {}),
              /*IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () async{
                ReminderNotification.showNotification();
              }),*/
            ],
          ),
        ),
      ),
      body: mainLayout(context),
    );
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This widget is the body of scaffold
  Widget mainLayout(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(alarmList.isEmpty){
      return Center(
        child: Text('No Alarm Found'),
      );
    }
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.separated(
        itemCount: alarmList.length,
        itemBuilder: (BuildContext context, int index) {
          var model = alarmList[index];
          if (model != null) {
            return item(model);
          }
          return Container();
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This widget is the List Tile to show the Alarm Information
  Widget item(AlarmModel model) {
    return ListTile(
      onTap: () async {
        var result =
            await Constants.navigatePush(AddAlarmScreen(model: model), context);
        if (result != null && result) {
          getAlarmList();
        }
      },
      leading: Icon(Icons.alarm),
      title: Text(model.alarmTime != null ? getFormattedTime(model.alarmTime!) : ""),
      subtitle: Text(model.label ?? ""),
      trailing: CustomSwitch(
          value: model.isAlarmEnable == 1,
          onChanged: (value) async {
            await onChangeValue(model, value);
          },
        activeColor: HexColor.fromHex("#00AFAA"),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : HexColor.fromHex("#D1D9E6"),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),),
    );
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This widget is to On/Off the alarm
  Future onChangeValue(AlarmModel model, bool value) async {
    Constants.progressDialog(true, context);
    model.isAlarmEnable = value ? 1 : 0;
    var map = model.toMap();
    map["UserId"] = userId;
    await helper.updateAlarm(map);
    if (model.id != null) {
      await connections.setAlarm(model);
    }
    Constants.progressDialog(false, context);
    setState(() {});
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function is to get userId from shared preferences and call function to get Alarm List from database
  Future getPreferences() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    if (userId != null && userId!.isNotEmpty) {
      await getAlarmList();
    }
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function to get Alarm List from database
  getAlarmList() async {
    if (preferences == null) {
      await getPreferences();
    }
    alarmList = await helper.getAlarmList(userId!);
    alarmCount = alarmList.length;
    isLoading = false;
    setState(() {});
  }
  getFormattedTime(String time){
    try{
      var val = time.split(':');
      String newTime;
      if(val != null && val[1].length == 1){
        newTime = val[0]+':'+'0${val[1]}';
        return newTime;
      }else{
        return time;
      }
    }catch(e){

    }
  }
}
