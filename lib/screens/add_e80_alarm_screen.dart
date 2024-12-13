import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/e80_set_alarm_model.dart';
import 'package:health_gauge/utils/alarm_notification.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomTimePicker/time_picker.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/text_utils.dart';

/// Added by: Akhil
/// Added on: July/23/2020
/// This widget is for adding the alarm in bracelet
/// @model Alarm Model object which contains data if user wants to update the alarm otherwise it is null.
class AddE80AlarmScreen extends StatefulWidget {
  final E80SetAlarmModel? model;
  final bool isEdit;

  AddE80AlarmScreen({Key? key, this.model, this.isEdit = false})
      : super(key: key);

  @override
  _AddE80AlarmScreenState createState() => _AddE80AlarmScreenState();
}

/// Added by: Akhil
/// Added on: July/23/2020
/// This class maintains the state of AddE80AlarmScreen
class _AddE80AlarmScreenState extends State<AddE80AlarmScreen> {
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

  List<String> alarmType = [
    'Wake up',
    'Sleep',
    'Gym',
    'Medicine',
    'Date',
    'Party',
    'Meeting',
    'Defining',
  ];

  int? alarmTypeValue;
  int? selectedIndex;

  // bool _invalidInput = false;

  List<int> listPicker = [];

  late FixedExtentScrollController scrollCntrl;

  List<E80SetAlarmModel> alarmList = <E80SetAlarmModel>[];
  TextEditingController titleTextController = new TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = new GlobalKey();

  // DatabaseHelper helper = DatabaseHelper.instance;

  String? userId;

  // bool isRepeatEnable = false;
  int delayTime = 0;

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// This function gets value from shared preference and call function to set values of model variables to show on the screen.
  @override
  void initState() {
    getPreferences();
    setDefaultValues();
    setListPicker();
    super.initState();
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// This function is for setting values of model variables to show on the screen.
  setDefaultValues() {
    if (widget.model != null && widget.isEdit) {
      E80SetAlarmModel model = widget.model!;
      if (model.hour != null && model.minute != null) {
        int hour = model.hour!;
        int minute = model.minute!;
        alarmTime = TimeOfDay(hour: hour, minute: minute);
      }

      if (model.type != null) {
        titleTextController.text = alarmType[model.type!];
        alarmTypeValue = model.type;
      }

      if (model.days != null && model.days!.isNotEmpty) {
        days = model.days!;
      }
      if (model.delayTime != null) {
        delayTime = model.delayTime!;
        try {
          Future.delayed(Duration.zero).then((value) {
            scrollCntrl.jumpToItem(listPicker.indexOf(model.delayTime!));
          });
        } catch (e) {
          print('Exception at jumpToItem $e');
        }
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
              // slider(context),
              SizedBox(
                height: 10.h,
              ),
              true ? labelAndDescription() : typeListWidget(),
              // repeat(),
            ],
          ),
        ),
      ),
    );
  }

  Widget slider(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitleText(
          text:
              'Delay Time', //stringLocalization.getText(StringLocalization.selectDays),
        ),
        SizedBox(height: 10.h),
        Center(
            child: Container(
          margin: EdgeInsets.only(top: 18.h),
          height: 50.h,
          width: Constants.width.w * 0.8,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.8)
                  : HexColor.fromHex("#D1D9E6"),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 2.h),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.8)
                  : HexColor.fromHex("#D1D9E6"),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, -2.h),
            ),
          ]),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#111B1A")
                  : HexColor.fromHex("#F2F2F2"),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : HexColor.fromHex("#E7EBF2"),
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : HexColor.fromHex("#E7EBF2"),
                    Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#212D2B")
                        : HexColor.fromHex("#FFFFFF"),
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : HexColor.fromHex("#E7EBF2"),
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : HexColor.fromHex("#E7EBF2"),
                  ]),
            ),
            height: 50.h,
            width: Constants.width.w * 0.8,
            child: RotatedBox(
              quarterTurns: 135,
              child: CustomCupertinoPicker(
                // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                children: List.generate(listPicker.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Container(
                      //margin: EdgeInsets.all(7.0.sp),
                      child: Center(
                        child: TitleText(
                          text: listPicker[index].toString(),
                          color: delayTime == listPicker[index]
                              ? HexColor.fromHex("#FF6259")
                              : Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                                  : HexColor.fromHex("#5D6A68"),
                          fontWeight: delayTime == listPicker[index]
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }),
                backgroundColor: Colors.transparent,
                scrollController: scrollCntrl,
                itemExtent: 75.w,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    delayTime = listPicker[index];
                  });
                },
              ),
            ),
          ),
        )),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget typeListWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SubTitleText(
            text:
                'Select Type', //stringLocalization.getText(StringLocalization.selectDays),
          ),
          SizedBox(width: 20.h),
          Container(
            child: DropdownButton(
                value: alarmType[alarmTypeValue ?? 0],
                items: alarmType
                    .map((element) => DropdownMenuItem(
                          child: Text(element),
                          value: element,
                        ))
                    .toList(),
                onChanged: (String? value) {
                  alarmTypeValue = alarmType.indexOf(value ?? '');
                  setState(() {});
                }),
          ),
          SizedBox(height: 13.h),
        ],
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
          onPressed: onTapAlarmTime,
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
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(days.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: InkWell(
                onTap: () {
                  days[index] = days[index] == 0 ? 1 : 0;
                  // _invalidInput  = false;
                  setState(() {});
                },
                child: Container(
                  // alignment: Alignment.center,
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
                      color: days[index] == 1 ? Colors.white : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        })),
        SizedBox(height: 13.h),
        // Visibility(
        //   visible: _invalidInput,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.only(left: 11.w),
        //         child: Text(
        //           'Select days',
        //           style: TextStyle(color: Colors.red, fontSize: 14),
        //         ),
        //       ),
        //       SizedBox(height: 10.h),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  showPicker() {
    selectedIndex = alarmTypeValue ?? 0;
    return Container(
      height: 200.0.h,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1AutoText(
                      text: stringLocalization
                          .getText(StringLocalization.cancel)
                          .toUpperCase()),
                ),
              ),
              InkWell(
                onTap: () {
                  if (context != null) {
                    alarmTypeValue = selectedIndex;
                    titleTextController.text = alarmType[alarmTypeValue!];
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  // setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1AutoText(
                      text: stringLocalization
                          .getText(StringLocalization.confirm)
                          .toUpperCase()),
                ),
              ),
            ],
          ),
          Flexible(
            child: CustomCupertinoPicker(
              scrollController: new FixedExtentScrollController(
                initialItem: alarmTypeValue ?? 0,
              ),
              backgroundColor: Theme.of(context).cardColor,
              children: List.generate(alarmType.length, (index) {
                return TitleText(
                  text: alarmType[index],
                  // color: selectedIndex == index
                  //     ? HexColor.fromHex("#FF6259")
                  //     : Theme.of(context).brightness == Brightness.dark
                  //     ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                  //     : HexColor.fromHex("#5D6A68"),
                  // fontWeight: selectedIndex == index
                  //     ? FontWeight.bold
                  //     : FontWeight.normal,
                  fontSize: 18,
                );
              }),
              itemExtent: 40.h,
              looping: true,
              onSelectedItemChanged: (int index) {
                selectedIndex = index;
                // setState(() {
                // });
              },
            ),
          ),
        ],
      ),
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
          SubTitleText(
            text:
                'Alarm Type', //stringLocalization.getText(StringLocalization.selectDays),
          ),
          SizedBox(height: 10.h),
          TextFormField(
            onTap: () {
              // Below line stops keyboard from appearing
              FocusScope.of(context).requestFocus(new FocusNode());

              // Show Date Picker Here
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).cardColor,
                useRootNavigator: true,
                builder: (context) {
                  return showPicker();
                },
              );
            },
            readOnly: true,
            // enabled: !widget.isEdit,
            autovalidateMode: autoValidate,
            controller: titleTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select Alarm Type',
              // stringLocalization.getText(StringLocalization.alarmLabel),
              prefixIcon: Icon(Icons.label_outline),
              contentPadding: EdgeInsets.all(0.0),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Select type';
                // return stringLocalization
                //     .getText(StringLocalization.alarmLabel);
              }
              // else if (days.indexOf(1) < 0) {
              //   _invalidInput = true;
              // }
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
  // Widget repeat() {
  //   return ListTile(
  //     title: Text(stringLocalization.getText(StringLocalization.repeat)),
  //     trailing: CustomSwitch(
  //       value: isRepeatEnable,
  //       onChanged: (value) {
  //         isRepeatEnable = value;
  //         setState(() {});
  //       },
  //       activeColor: HexColor.fromHex("#00AFAA"),
  //       inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),
  //       inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : HexColor.fromHex("#D1D9E6"),
  //       activeTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),
  //     ),
  //   );
  // }

  getTextFromKey(String key) {
    return StringLocalization.of(context).getText(key);
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to update database and calling function to set set alarm in bracelet
  void onClickSave() async {
    // bool isUpdate = false;
    if (preferences == null) {
      await getPreferences();
    }
    // isUpdate = widget.model != null;

    if (formKey.currentState!.validate()) {
      Constants.progressDialog(true, context);
      E80SetAlarmModel model = addValueToModel();
      print(model.repeatBits);
      // var map = model.toMap();
      // map["UserId"] = userId;
      // var alarmId = isUpdate
      //     ? await helper.updateAlarm(map)
      //     : await helper.insertAlarm(map);
      // model.id = alarmId;
      // map["previousAlarmTime"] = model.previousAlarmTime;
      await sendDataToDevice(model);
      await setNotification(model);
      Constants.progressDialog(false, context);
      if (context != null && Navigator.canPop(context)) {
        Navigator.of(context).pop(true);
      }
    } else {
      autoValidate = AutovalidateMode.always;
      setState(() {});
    }
  }

  setNotification(E80SetAlarmModel model) async {
    String label;
    AlarmNotification().initialize();
    if (widget.isEdit && widget.model != null) {
      // label = "${widget.model.hour.toString().padLeft(2, "0")}:${widget.model.minute.toString().padLeft(2, "0")}";
      int id = int.parse('${widget.model!.type}${widget.model!.delayTime}');
      await AlarmNotification.disableReminder(
        days: widget.model!.days!,
        id: id,
        hour: widget.model!.hour!,
        minute: widget.model!.minute!,
      );
    }
    int id = int.parse('${model.type}${model.delayTime}');
    label =
        "${model.hour.toString().padLeft(2, "0")}:${model.minute.toString().padLeft(2, "0")}";
    await AlarmNotification().enableReminder(
        days: model.days!,
        id: id,
        hour: model.hour!,
        minute: model.minute!,
        label: label,
        description: alarmType[model.type!]);
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to set alarm in bracelet
  Future sendDataToDevice(E80SetAlarmModel model) async {
    !widget.isEdit
        ? await connections.setAlarmInE80(model)
        : await connections.modifyAlarmInE80(model);
    return Future.value();
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to create the alarm model to send data to bracelet and save data in database
  E80SetAlarmModel addValueToModel() {
    E80SetAlarmModel alarmModel = E80SetAlarmModel();
    if (widget.model != null) {
      alarmModel = E80SetAlarmModel.clone(widget.model!);
      if (alarmModel.hour != null && alarmModel.minute != null) {
        alarmModel.oldHr = alarmModel.hour;
        alarmModel.oldMin = alarmModel.minute;
      }
    } else {
      // alarmModel.id = alarmList.length;
    }
    alarmModel.isAlarmEnable = true;
    if (alarmModel != null) {
      if (alarmTime != null) {
        alarmModel.hour = alarmTime.hour;
        alarmModel.minute = alarmTime.minute;
      }
    }
    if (alarmTypeValue != null) {
      alarmModel.type = alarmTypeValue ?? 0;
    }

    if (delayTime != null) {
      alarmModel.delayTime = delayTime;
    }
    if (days != null) {
      alarmModel.days = days;
    }
    return alarmModel;
  }

  /// Added by: Akhil
  /// Added on: July/23/2020
  /// function to get userId from the shared preferences
  Future getPreferences() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    // if (userId != null && userId.isNotEmpty) {
    //   await getAlarmList();
    // }
  }

  void setListPicker() {
    for (int i = 0; i < 60; i += 5) listPicker.add(i);
    scrollCntrl =
        FixedExtentScrollController(initialItem: listPicker.indexOf(delayTime));
  }
}
