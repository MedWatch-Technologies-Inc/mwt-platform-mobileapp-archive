// ignore_for_file: always_declare_return_types, prefer_conditional_assignment

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/reminder_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/reminder_notification.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomTimePicker/time_picker.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddReminderScreen extends StatefulWidget {
  final ReminderModel model;
  final DeviceModel? connectedDevice;

  AddReminderScreen({required this.model, this.connectedDevice});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  TimeOfDay startTimeOfDay = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTimeOfDay = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay secondStartTimeOfDay = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay secondEndTimeOfDay = TimeOfDay(hour: 0, minute: 0);
  List intervalTime = [
    '1 ${stringLocalization.getText(StringLocalization.minute)}',
    '2 ${stringLocalization.getText(StringLocalization.minute)}',
    '5 ${stringLocalization.getText(StringLocalization.minute)}',
    '1 ${stringLocalization.getText(StringLocalization.hour)}',
    '2 ${stringLocalization.getText(StringLocalization.hour)}',
    '4 ${stringLocalization.getText(StringLocalization.hour)}',
    '6 ${stringLocalization.getText(StringLocalization.hour)}',
    '8 ${stringLocalization.getText(StringLocalization.hour)}',
    '10 ${stringLocalization.getText(StringLocalization.hour)}',
    '12 ${stringLocalization.getText(StringLocalization.hour)}'
  ];

  List days = REMINDER_DAYS;

  String selectedInterval =
      '0 ${stringLocalization.getText(StringLocalization.minute)}';
  Uint8List? imageFile;
  bool isNotificationEnable = false;

  //endregion

  TextEditingController titleTextController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = new GlobalKey();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DatabaseHelper helper = DatabaseHelper.instance;

  String? userId;

  DeviceModel? connectedDevice;

  @override
  void initState() {
    if (widget.connectedDevice != null &&
        widget.connectedDevice?.sdkType == 2 &&
        widget.model != null &&
        widget.model.label == 'Sedentary') {
      intervalTime = [
        '15 ${stringLocalization.getText(StringLocalization.minute)}',
        '30 ${stringLocalization.getText(StringLocalization.minute)}',
        '45 ${stringLocalization.getText(StringLocalization.minute)}',
        '60 ${stringLocalization.getText(StringLocalization.minute)}',
      ];
    } else if (widget.model != null && widget.model.isDefault!) {
      intervalTime = [
        '1 ${stringLocalization.getText(StringLocalization.hour)}',
        '2 ${stringLocalization.getText(StringLocalization.hour)}',
        '4 ${stringLocalization.getText(StringLocalization.hour)}',
        '6 ${stringLocalization.getText(StringLocalization.hour)}',
        '8 ${stringLocalization.getText(StringLocalization.hour)}',
        '10 ${stringLocalization.getText(StringLocalization.hour)}',
        '12 ${stringLocalization.getText(StringLocalization.hour)}'
      ];
    }
    connectedDevice = widget.connectedDevice;
    //connections.checkAndConnectDeviceIfNotConnected();
    ReminderNotification.initialize();
    getPreferences();
    setDefaultValues();
    super.initState();
  }

  setDefaultValues() {
    if (widget.model != null) {
      var model = widget.model;
      if (model.startTime != null && model.startTime!.isNotEmpty) {
        var hour = int.parse(model.startTime!.split(':')[0]);
        var minute = int.parse(model.startTime!.split(':')[1]);
        startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.endTime != null && model.endTime!.isNotEmpty) {
        var hour = int.parse(model.endTime!.split(':')[0]);
        var minute = int.parse(model.endTime!.split(':')[1]);
        endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.secondStartTime != null && model.secondStartTime!.isNotEmpty) {
        var hour = int.parse(model.secondStartTime!.split(':')[0]);
        var minute = int.parse(model.secondStartTime!.split(':')[1]);
        secondStartTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.secondEndTime != null && model.secondEndTime!.isNotEmpty) {
        var hour = int.parse(model.secondEndTime!.split(':')[0]);
        var minute = int.parse(model.secondEndTime!.split(':')[1]);
        secondEndTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.interval != null && model.interval!.isNotEmpty) {
        selectedInterval = model.interval!;
      }
      if (model.label != null && model.label!.isNotEmpty) {
        titleTextController.text = model.label ?? '';
      }
      if (model.description != null && model.description!.isNotEmpty) {
        descriptionController.text = model.description ?? '';
      }
      if (model.imageBase64 != null && model.imageBase64!.isNotEmpty) {
        imageFile = base64Decode(model.imageBase64 ?? '');
      }
      if (model.days != null && model.days!.isNotEmpty) {
        days = model.days!;
      }
      if (model.isNotification != null) {
        isNotificationEnable = model.isNotification!;
      }
    }

    if (!intervalTime.contains(selectedInterval)) {
      selectedInterval = intervalTime.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.width,
    //     height: Constants.height,
    //     allowFontScaling: true);

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
            elevation: 0,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
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
            title: Text(
              getTextFromKey(StringLocalization.updateReminders),
              style: TextStyle(
                  color: HexColor.fromHex('#62CBC9'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: Icon(Icons.check,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: onClickSave),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          child: (widget.connectedDevice != null &&
                  widget.connectedDevice?.sdkType == 2 &&
                  widget.model.label == 'Sedentary')
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TitleText(
                        text: 'First Reminder Period',
                        align: TextAlign.left,
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        startTimeWidget(),
                        endTimeWidget(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TitleText(
                        text: 'Second Reminder Period',
                        align: TextAlign.left,
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        secondStartTimeWidget(),
                        secondEndTimeWidget(),
                      ],
                    ),

                    intervalWidget(),
                    repetitionWidget(),
                    labelAndDescription(),
//              imageWidget(),
                    notificationWidget()
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    startTimeWidget(),
                    endTimeWidget(),
                    intervalWidget(),
                    // repetitionWidget(),
                    labelAndDescription(),
//              imageWidget(),
                    notificationWidget()
                  ],
                ),
        ),
      ),
    );
  }

  Widget startTimeWidget() {
    if (startTimeOfDay == null) {
      startTimeOfDay = TimeOfDay(hour: 0, minute: 0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text:
              "${startTimeOfDay.hour.toString().padLeft(2, "0")}:${startTimeOfDay.minute.toString().padLeft(2, "0")}",
          align: TextAlign.center,
        ),
        TextButton(
          onPressed: onTapStartTime,
          child: Text(
            stringLocalization.getText(StringLocalization.startTime),
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  onTapStartTime() async {
    var time = await showCustomTimePicker(
      initialTime: startTimeOfDay,
      context: context,
    );
    if (time != null) {
      startTimeOfDay = time;
      setState(() {});
    }
  }

  Widget secondStartTimeWidget() {
    if (secondStartTimeOfDay == null) {
      secondStartTimeOfDay = TimeOfDay(hour: 0, minute: 0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text:
              "${secondStartTimeOfDay.hour.toString().padLeft(2, "0")}:${secondStartTimeOfDay.minute.toString().padLeft(2, "0")}",
          align: TextAlign.center,
        ),
        TextButton(
          onPressed: onTapSecondStartTime,
          child: Text(stringLocalization.getText(StringLocalization.startTime),
              style: TextStyle(
                color: AppColor.primaryColor,
              )),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  onTapSecondStartTime() async {
    var time = await showCustomTimePicker(
      initialTime: secondStartTimeOfDay,
      context: context,
    );
    if (time != null) {
      secondStartTimeOfDay = time;
      setState(() {});
    }
  }

  Widget secondEndTimeWidget() {
    if (secondEndTimeOfDay == null) {
      secondEndTimeOfDay = TimeOfDay(hour: 0, minute: 0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text:
              "${secondEndTimeOfDay.hour.toString().padLeft(2, "0")}:${secondEndTimeOfDay.minute.toString().padLeft(2, "0")}",
          align: TextAlign.center,
        ),
        SizedBox(height: 5.h),
        TextButton(
          onPressed: onTapSecondEndTime,
          child: Text(
            stringLocalization.getText(StringLocalization.endTime),
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  onTapSecondEndTime() async {
    var time = await showCustomTimePicker(
      initialTime: secondEndTimeOfDay,
      context: context,
    );
    if (time != null) {
      secondEndTimeOfDay = time;
      setState(() {});
    }
  }

  Widget endTimeWidget() {
    if (endTimeOfDay == null) {
      endTimeOfDay = TimeOfDay(hour: 0, minute: 0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text:
              "${endTimeOfDay.hour.toString().padLeft(2, "0")}:${endTimeOfDay.minute.toString().padLeft(2, "0")}",
          align: TextAlign.center,
        ),
        SizedBox(height: 5.h),
        TextButton(
          onPressed: onTapEndTime,
          child: Text(
            stringLocalization.getText(StringLocalization.endTime),
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  onTapEndTime() async {
    var time = await showCustomTimePicker(
      initialTime: endTimeOfDay,
      context: context,
    );
    if (time != null) {
      endTimeOfDay = time;
      setState(() {});
    }
  }

  Widget intervalWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text: '$selectedInterval',
          align: TextAlign.center,
        ),
        SizedBox(height: 5.h),
        TextButton(
          onPressed: onClickInterval,
          child: Text(
            stringLocalization.getText(StringLocalization.intervalTime),
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  onClickInterval() async {
    var dialog = AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(intervalTime.length, (index) {
            return ListTile(
              onTap: () {
                if (context != null) {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context, rootNavigator: true).pop(index);
                  }
                }
              },
              title: Text(intervalTime[index]),
            );
          }),
        ),
      ),
    );
    if (intervalTime.length > 0) {
      var index = await showDialog(
          context: context,
          useRootNavigator: true,
          builder: (context) => dialog);
      if (index != null) {
        selectedInterval = intervalTime[index];
        setState(() {});
      }
    }
  }

  Column repetitionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitleText(
          text: stringLocalization.getText(StringLocalization.repeat),
        ),
        SizedBox(height: 8.h),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(days.length, (index) {
              return InkWell(
                onTap: (widget.model != null &&
                        widget.model.isDefault != null &&
                        widget.model.isDefault! &&
                        !(widget.model.label == 'Sedentary' &&
                            widget.connectedDevice?.sdkType == 2))
                    ? null
                    : () {
                        days[index]['isSelected'] = !days[index]['isSelected'];
                        setState(() {});
                      },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryColor),
                    color: days[index]['isSelected']
                        ? AppColor.primaryColor
                        : Colors.transparent,
                  ),
                  padding: EdgeInsets.all(15.h),
                  child: Text(
                    stringLocalization.getText(days[index]['name']),
                    style: TextStyle(
                        color: days[index]['isSelected'] ? Colors.white : null),
                  ),
                ),
              );
            })),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget labelAndDescription() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: (widget.model != null &&
                    widget.model.isDefault != null &&
                    widget.model.isDefault!)
                ? false
                : true,
            autovalidateMode: autoValidate,
            controller: titleTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: stringLocalization.getText(StringLocalization.label),
              prefixIcon: Icon(Icons.label_outline,
                  color: Theme.of(context).iconTheme.color),
              contentPadding: EdgeInsets.all(0.0),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return stringLocalization.getText(StringLocalization.label);
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          TextFormField(
//            enabled: (widget.model !=null && widget.model.isDefault != null && widget.model.isDefault)?false:true,
            autovalidateMode: autoValidate,
            controller: descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  stringLocalization.getText(StringLocalization.description),
              prefixIcon: Icon(Icons.description,
                  color: Theme.of(context).iconTheme.color),
              contentPadding: EdgeInsets.all(0.0),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return stringLocalization
                    .getText(StringLocalization.description);
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter(regExForRestrictEmoji(),
                  allow: false),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  ListTile imageWidget() {
    return ListTile(
      enabled: (widget.model != null &&
              widget.model.isDefault != null &&
              widget.model.isDefault!)
          ? false
          : true,
      leading: Icon(Icons.image, color: Theme.of(context).iconTheme.color),
      title: Text(stringLocalization.getText(StringLocalization.selectImage)),
      trailing: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: IconButton(
          onPressed: () => (widget.model != null &&
                  widget.model.isDefault != null &&
                  widget.model.isDefault!)
              ? null
              : showImagePickerDialog(),
          icon: imageFile == null
              ? Icon(Icons.add_circle, color: Theme.of(context).iconTheme.color)
              : Image.memory(
                  imageFile!,
                  height: 30.h,
                  width: 30.w,
                ),
        ),
      ),
    );
  }

  ListTile notificationWidget() {
    return titleTextController.text.toLowerCase() ==
            '${stringLocalization.getText(StringLocalization.ppgReminderTitle)}'
                .toLowerCase()
        ? ListTile()
        : ListTile(
            leading: Icon(Icons.notifications_active,
                color: Theme.of(context).iconTheme.color),
            title: Text(
                stringLocalization.getText(StringLocalization.notification)),
            trailing: CustomSwitch(
              value: isNotificationEnable,
              onChanged: (value) {
                isNotificationEnable = value;
                setState(() {});
              },
              activeColor: HexColor.fromHex('#00AFAA'),
              inactiveTrackColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E7EBF2'),
              inactiveThumbColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#D1D9E6'),
              activeTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
            ),
          );
  }

  showImagePickerDialog() {
    var dialog = AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              title:
                  Text(stringLocalization.getText(StringLocalization.camera)),
              onTap: () {
                if (context != null) {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
                takePicture();
              },
            ),
            ListTile(
              title:
                  Text(stringLocalization.getText(StringLocalization.gallery)),
              onTap: () {
                if (context != null) {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
                chooseFromGallery();
              },
            ),
            ListTile(
              title:
                  Text(stringLocalization.getText(StringLocalization.remove)),
              onTap: () {
                if (context != null) {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
                removePicture();
              },
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, useRootNavigator: true, builder: (context) => dialog);
  }

  takePicture() async {
    var file = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 100,
        maxHeight: 100,
        imageQuality: 50);
    if (file != null) {
      imageFile = await file.readAsBytes();
      setState(() {});
    }
  }

  chooseFromGallery() async {
    var file = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 100,
        maxHeight: 100,
        imageQuality: 50);
    if (file != null) {
      imageFile = await file.readAsBytes();
      setState(() {});
    }
    setState(() {});
  }

  removePicture() {
    imageFile = null;
    setState(() {});
  }

  getTextFromKey(String key) {
    return StringLocalization.of(context).getText(key);
  }

  void onClickSave() async {
    try {
      if (widget.model != null) {
        await ReminderNotification.disableReminder(widget.model);
      }
      if (preferences == null) {
        await getPreferences();
      }
      if (formKey.currentState!.validate()) {
        Constants.progressDialog(true, context);
        var model = addValueToModel();
        await sendDataToDevice(model);
        var map = model.toMap();
        map['UserId'] = userId;
        var reminderId = await helper.insertUpdateReminder(map);
        print('createNotificationId Id = $reminderId');
        if (isNotificationEnable) {
          await ReminderNotification.enableReminder(model);
        }

        if (!(model.isDefault ?? false)) {
          // if (model.isDefault) {
          var sdkType = Constants.e66;
          try {
            sdkType = widget.connectedDevice?.sdkType ?? 2;
          } catch (e) {
            print(e);
          }
          await connections.setCustomReminder(model, reminderId, sdkType);
        } else {
          if (model.reminderType == 1 ||
              model.reminderType == 2 ||
              model.reminderType == 3) {
            connections.setDefaultReminder(model, model.reminderType,
                (widget.connectedDevice?.sdkType ?? Constants.e66));
          }
          if (model.reminderType == 4) {
            ppgReminderModel.startTime =
                ReminderNotification.stringToTimeOfDay(model.startTime!);
            ppgReminderModel.endTime =
                ReminderNotification.stringToTimeOfDay(model.endTime!);
            ppgReminderModel.days =
                model.days!.where((m) => m['isSelected']).toList();
            Duration? duration;
            if (model.interval!.contains(
                stringLocalization.getText(StringLocalization.minute))) {
              var a = model.interval!.replaceFirst(
                  ' ${stringLocalization.getText(StringLocalization.minute)}',
                  '');
              duration = new Duration(minutes: int.parse(a));
            } else if (model.interval!.contains(
                stringLocalization.getText(StringLocalization.hour))) {
              var a = model.interval!.replaceFirst(
                  ' ${stringLocalization.getText(StringLocalization.hour)}',
                  '');
              duration = new Duration(hours: int.parse(a));
            }
            if (duration != null) {
              ppgReminderModel.interval = ReminderNotification.getTimes(
                      ppgReminderModel.startTime!,
                      ppgReminderModel.endTime!,
                      duration)
                  .toList();
            }
            ppgReminder(userId!, connections);
          }
        }

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
    } catch (e) {
      print('Exception at add reminder $e');
    }
  }

  Future sendDataToDevice(ReminderModel model) async {
    var sdkType = Constants.e66;
    try {
      sdkType = connectedDevice?.sdkType ?? 2;
    } catch (e) {
      print(e);
    }

    if (model.label!.toLowerCase() ==
        '${stringLocalization.getText(StringLocalization.waterReminderTitle)}'
            .toLowerCase()) {
      await connections.setDefaultReminder(model, 1, sdkType);
    } else if (model.label!.toLowerCase() ==
        '${stringLocalization.getText(StringLocalization.sedentaryReminderTitle)}'
            .toLowerCase()) {
      await connections.setDefaultReminder(model, 2, sdkType);
    } else if (model.label!.toLowerCase() ==
        '${stringLocalization.getText(StringLocalization.medicineReminderTitle)}'
            .toLowerCase()) {
      await connections.setDefaultReminder(model, 3, sdkType);
    }
    return Future.value();
  }

  ReminderModel addValueToModel() {
    var reminderModel = new ReminderModel();
    if (widget.model != null) {
      reminderModel = widget.model;
    }
    reminderModel.isEnable = true;
    if (reminderModel != null) {
      if (startTimeOfDay != null) {
        reminderModel.startTime =
            '${startTimeOfDay.hour}:${startTimeOfDay.minute}';
      }
      if (endTimeOfDay != null) {
        reminderModel.endTime = '${endTimeOfDay.hour}:${endTimeOfDay.minute}';
      }
      if (connectedDevice?.sdkType == 2) {
        if (secondStartTimeOfDay != null) {
          reminderModel.secondStartTime =
              '${secondStartTimeOfDay.hour}:${secondStartTimeOfDay.minute}';
        }
        if (secondEndTimeOfDay != null) {
          reminderModel.secondEndTime =
              '${secondEndTimeOfDay.hour}:${secondEndTimeOfDay.minute}';
        }
      }

      if (selectedInterval != null) {
        reminderModel.interval = selectedInterval;
      }
      if (isNotificationEnable != null) {
        reminderModel.isNotification = isNotificationEnable;
      }
      if (reminderModel.isDefault == null || !reminderModel.isDefault!) {
        if (days != null) {
          reminderModel.days = days;
        }
        reminderModel.label = titleTextController.text;
        reminderModel.description = descriptionController.text;
        if (imageFile != null) {
          var base64Image = base64Encode(imageFile!);
          reminderModel.imageBase64 = base64Image;
        }
        reminderModel.isDefault = false;
      }
      if (reminderModel.isSync == null) {
        reminderModel.isSync = false;
      }
      if (reminderModel.isRemove == null) {
        reminderModel.isRemove = false;
      }
    }
    if (titleTextController.text.toLowerCase() ==
        '${stringLocalization.getText(StringLocalization.ppgReminderTitle)}'
            .toLowerCase()) {
      if (timer != null && (timer?.isActive ?? false)) {
        timer?.cancel();
      }
      ppgReminderModel.startTime = startTimeOfDay;
      ppgReminderModel.endTime = endTimeOfDay;
      ppgReminderModel.days = days.where((m) => m['isSelected']).toList();
      Duration? duration;
      if (selectedInterval
          .contains(stringLocalization.getText(StringLocalization.minute))) {
        var a = selectedInterval.replaceFirst(
            ' ${stringLocalization.getText(StringLocalization.minute)}', '');
        duration = new Duration(minutes: int.parse(a));
      } else if (selectedInterval
          .contains(stringLocalization.getText(StringLocalization.hour))) {
        var a = selectedInterval.replaceFirst(
            ' ${stringLocalization.getText(StringLocalization.hour)}', '');
        duration = new Duration(hours: int.parse(a));
      }
      if (duration != null) {
        ppgReminderModel.interval = ReminderNotification.getTimes(
                startTimeOfDay, endTimeOfDay, duration)
            .toList();
      }
      ppgReminder(userId!, connections);
    }
    return reminderModel;
  }

  Future getPreferences() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
  }

  RegExp regExForRestrictEmoji() => RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
}
