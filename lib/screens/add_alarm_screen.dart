import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/alarm_models/alarm_model.dart';
import 'package:health_gauge/utils/alarm_notification.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomTimePicker/time_picker.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

/// Added by: Akhil
/// Added on: July/23/2020
/// This widget is for adding the alarm in bracelet
/// @model Alarm Model object which contains data if user wants to update the alarm otherwise it is null.
class AddAlarmScreen extends StatefulWidget {
  final AlarmModel? model;

  AddAlarmScreen({Key? key, this.model}) : super(key: key);

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

/// Added by: Akhil
/// Added on: July/23/2020
/// This class maintains the state of AddAlarmScreen
class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TimeOfDay alarmTime = TimeOfDay(hour: 0, minute: 0);

  //region days
  List days = [0, 0, 0, 0, 0, 0, 0];
  List daysName = [
    StringLocalization.mon,
    StringLocalization.tue,
    StringLocalization.wed,
    StringLocalization.thu,
    StringLocalization.fri,
    StringLocalization.sat,
    StringLocalization.sun
  ];
  List<AlarmModel> alarmList = <AlarmModel>[];
  TextEditingController titleTextController = new TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = new GlobalKey();

  DatabaseHelper helper = DatabaseHelper.instance;

  String? userId;

  bool isRepeatEnable = false;

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// This function gets value from shared preference and call function to set values of model variables to show on the screen.
  @override
  void initState() {
    getPreferences();
    setDefaultValues();
    super.initState();
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// This function is for setting values of model variables to show on the screen.
  setDefaultValues() {
    if (widget.model != null) {
      AlarmModel model = widget.model!;
      if (model.alarmTime != null && model.alarmTime!.isNotEmpty) {
        int hour = int.parse(model.alarmTime!.split(":")[0]);
        int minute = int.parse(model.alarmTime!.split(":")[1]);
        alarmTime = TimeOfDay(hour: hour, minute: minute);
      }

      if (model.label != null && model.label!.isNotEmpty) {
        titleTextController.text = model.label ?? '';
      }

      if (model.days != null && model.days!.isNotEmpty) {
        days = model.days!;
      }
      if (model.isRepeatEnable != null) {
        isRepeatEnable = model.isRepeatEnable!;
      }
    }
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// This function is responsible for building UI.
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.width,
    //     height: Constants.height,
    //     allowFontScaling: true);

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
                getTextFromKey(
                  StringLocalization.addAlarm,
                ),
                style: TextStyle(color: HexColor.fromHex("#62CBC9")),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      color: HexColor.fromHex("#62CBC9"),
                    ),
                    onPressed: () => onClickSave()),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              alarmTimeWidget(),
              repetitionWidget(),
              labelAndDescription(),
              repeat(),
            ],
          ),
        ),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// widget to set the alarm time
  Widget alarmTimeWidget() {
    if (alarmTime == null) {
      alarmTime = TimeOfDay(hour: 0, minute: 0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text:
              "${alarmTime.hour.toString().padLeft(2, "0")}:${alarmTime.minute.toString().padLeft(2, "0")}",
          align: TextAlign.center,
        ),
        TextButton(
          onPressed: () async => onTapAlarmTime(),
          child: Text(
            stringLocalization.getText(StringLocalization.selectTime),
            style: TextStyle(color: AppColor.primaryColor),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  ///function to show alarm time which is selected by user
  onTapAlarmTime() async {
    TimeOfDay? time = await showCustomTimePicker(
      initialTime: alarmTime,
      context: context,
    );
    if (time != null) {
      alarmTime = time;
      setState(() {});
    }
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// widget for repetition of alarm on different days
  Column repetitionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitleText(
          text: stringLocalization.getText(StringLocalization.selectDays),
        ),
        SizedBox(height: 10.h),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(days.length, (index) {
              return InkWell(
                onTap: () {
                  days[index] = days[index] == 0 ? 1 : 0;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryColor),
                    color: days[index] == 1
                        ? AppColor.primaryColor
                        : Colors.transparent,
                  ),
                  padding: EdgeInsets.all(15.h),
                  child: Text(
                    stringLocalization.getText(daysName[index]),
                    style: TextStyle(
                        color: days[index] == 1 ? Colors.white : null),
                  ),
                ),
              );
            })),
        SizedBox(height: 13.h),
      ],
    );
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// alarm description widget to set alarm label
  Widget labelAndDescription() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: true,
            autovalidateMode: autoValidate,
            controller: titleTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  stringLocalization.getText(StringLocalization.alarmLabel),
              prefixIcon: Icon(Icons.label_outline),
              contentPadding: EdgeInsets.all(0.0),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return stringLocalization
                    .getText(StringLocalization.alarmLabel);
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// widget for repetition of alarm
  Widget repeat() {
    return ListTile(
      title: Text(stringLocalization.getText(StringLocalization.repeat)),
      trailing: CustomSwitch(
        value: isRepeatEnable,
        onChanged: (value) {
          isRepeatEnable = value;
          setState(() {});
        },
        activeColor: HexColor.fromHex("#00AFAA"),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex("#E7EBF2"),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex("#D1D9E6"),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex("#E7EBF2"),
      ),
    );
  }

  getTextFromKey(String key) {
    return StringLocalization.of(context).getText(key);
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to update database and calling function to set set alarm in bracelet
  void onClickSave() async {
    bool isUpdate = false;
    if (preferences == null) {
      await getPreferences();
    }
    isUpdate = widget.model != null;

    if (formKey.currentState!.validate()) {
      Constants.progressDialog(true, context);
      AlarmModel model = addValueToModel();
      var map = model.toMap();
      map["UserId"] = userId;
      var alarmId = isUpdate
          ? await helper.updateAlarm(map)
          : await helper.insertAlarm(map);
      model.id = alarmId;
      map["previousAlarmTime"] = model.previousAlarmTime;
      await sendDataToDevice(model);
      await setNotification(model);
      Constants.progressDialog(false, context);
      if (context != null) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(true);
        }
      }
    } else {
      autoValidate = AutovalidateMode.always;
      setState(() {});
    }
  }

  setNotification(AlarmModel model) async {
    String label;
    int hour;
    int minute;
    AlarmNotification().initialize();
    if (widget.model != null) {
      hour = int.parse(widget.model!.alarmTime!.split(":")[0]);
      minute = int.parse(widget.model!.alarmTime!.split(":")[1]);
      await AlarmNotification.disableReminder(
        days: widget.model!.days!,
        id: widget.model!.id!,
        hour: hour,
        minute: minute,
      );
    }
    hour = int.parse(model.alarmTime!.split(":")[0]);
    minute = int.parse(model.alarmTime!.split(":")[1]);
    label =
        "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
    await AlarmNotification().enableReminder(
        days: model.days!,
        id: model.id!,
        hour: alarmTime.hour,
        minute: alarmTime.minute,
        label: label,
        description: model.label!);
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to set alarm in bracelet
  Future sendDataToDevice(AlarmModel model) async {
    await connections.setAlarm(model);
    return Future.value();
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to create the alarm model to send data to bracelet and save data in database
  AlarmModel addValueToModel() {
    AlarmModel alarmModel = new AlarmModel();
    if (widget.model != null) {
      alarmModel = AlarmModel.clone(widget.model!);
      if (alarmModel.alarmTime != null) {
        alarmModel.previousAlarmTime = alarmModel.alarmTime;
      }
    } else {
      alarmModel.id = alarmList.length;
    }
    alarmModel.isAlarmEnable = 1;
    if (alarmModel != null) {
      if (alarmTime != null) {
        alarmModel.alarmTime = "${alarmTime.hour}:${alarmTime.minute}";
      }
    }
    if (days != null) {
      alarmModel.days = days;
    }
    alarmModel.label = titleTextController.text;
    alarmModel.isRepeatEnable = isRepeatEnable;
    return alarmModel;
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to get userId from the shared preferences
  Future getPreferences() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    if (userId != null && userId!.isNotEmpty) {
      await getAlarmList();
    }
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to get alarmList from local database
  getAlarmList() async {
    if (preferences == null) {
      await getPreferences();
    }
    alarmList = await helper.getAlarmList(userId!);
    setState(() {});
  }
}
