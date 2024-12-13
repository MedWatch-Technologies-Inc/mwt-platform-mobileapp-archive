import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/target_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

class TargetScreen extends StatefulWidget {
  final UserModel user;

  const TargetScreen({required this.user});

  @override
  _TargetScreenState createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  // double stepCount = 8000;
  // double sleepHour = 8;
  // double sleepMinute = 0;
  //
  // List listOfStep = [];
  //
  // List listOfHour = [];
  // List listOfMinute = [];
  //
  // double selectedCalories = 2000;
  // List listOfCalories = [];
  //
  // double selectedDistance = 5000;
  // List listOfDistance = [];
  //
  // double selectedWeight = 70;
  // List listOfWeight = [];
  //
  // String userId;
  //
  // bool isLoading = true;
  // int stepValue;
  // int hourValue;
  // int minuteValue;
  // int caloriesValue;
  // int distanceValue;
  // int weightValue;
  TargetModel targetModel = TargetModel();

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  Future savePreferenceInServer() async {
    String url = Constants.baseUrl + 'StorePreferenceSettings';
    // if (userId == null) {
    String userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    // }
    // final result =
    //     await SaveAndGetLocalSettings().savePreferencesInServer(url, userId);
    final storeResult =
        await PreferenceRepository().storePreferenceSettings(userId);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: targetModel,
      child: Selector<TargetModel, bool>(
        selector: (context, model) => model.isLoading,
        builder: (context, isLoading, child) {
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
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
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
                    title: Text(
                        StringLocalization.of(context)
                            .getText(StringLocalization.target),
                        style: TextStyle(
                            fontSize: 18,
                            color: HexColor.fromHex('62CBC9'),
                            fontWeight: FontWeight.bold)),
                    centerTitle: true,
                  ),
                )),
            body: layoutMain(),
            bottomNavigationBar: Padding(
              key:Key('saveButton'),
              padding: EdgeInsets.all(10.0.sp),
              child: confirmButton(),
            ),
          );
        },
      ),
    );
  }

  Widget layoutMain() {
    if (targetModel.isLoading) {
      return LoadingScreen();
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(12.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            targetStepCard(),
            sleepTargetCard(),
            caloriesTargetCard(),
            distanceTargetCard(),
            weightTargetCard(),
          ],
        ),
      ),
    );
  }

  Widget confirmButton() {
    return Container(
      margin: EdgeInsets.only(top: 10.0.sp),
      child: Selector<TargetModel, bool>(
        selector: (context, model) => model.isGoalEdit,
        builder: (context, isGoalEdit, child) => RaisedBtn(
          text: StringLocalization.of(context)
              .getText(StringLocalization.save)
              .toUpperCase(),
          onPressed: isGoalEdit
              ? () async {
                  Constants.progressDialog(true, context);

                  Map map = {
                    'userId': targetModel.userId,
                    'step': targetModel.stepCount,
                  };
                  connections.setStepTarget(targetModel.stepCount.toInt());
                  preferences?.setString(
                      Constants.prefSavedStepTarget, jsonEncode(map));
                  map = {
                    'userId': targetModel.userId,
                    'hour': targetModel.sleepHour,
                    'minute': targetModel.sleepMinute
                  };
                  connections.setSleepTarget(targetModel.sleepHour.toInt(),
                      targetModel.sleepMinute.toInt());

                  preferences?.setString(
                      Constants.prefSavedSleepTarget, jsonEncode(map));
                  map = {
                    'userId': targetModel.userId,
                    'calories': targetModel.selectedCalories,
                  };
                  connections.setCaloriesTarget(targetModel.caloriesValue!);
                  preferences?.setString(
                      Constants.prefSavedCaloriesTarget, jsonEncode(map));
                  map = {
                    'userId': targetModel.userId,
                    'distance': targetModel.selectedDistance,
                  };
                  preferences?.setString(
                      Constants.prefSavedDistanceTarget, jsonEncode(map));

                  if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
                    // targetModel.updateSelectedWeight(
                    //     targetModel.selectedWeight / 2.205);
                    targetModel.updateSelectedWeight(

                        targetModel.selectedWeight / 2.20462);
                  }

                  map = {
                    'userId': targetModel.userId,
                    'weight': targetModel.selectedWeight,
                  };
                  preferences?.setString(
                      Constants.prefSavedWeightTarget, jsonEncode(map));

                  savePreferenceInServer();
                  if (context != null) {
                    //         CustomSnackBar.CurrentBuildSnackBar(
                    // context,
                    // scaffoldKey,
                    //             'Saved goals successfully');
                    //         CustomSnackBar.buildSnackbar(
                    //               context, 'Saved goals successfully', 3);

                    // Scaffold.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       'Saved goals successfully',
                    //     ),
                    //   ),
                    // );
                    Constants.progressDialog(false, context);

                    Navigator.of(context).pop(true);
                  }
                }
              : null,
        ),
      ),
    );
  }

  Widget targetStepCard() {
//    ScreenUtil.init(context, width: 423.5294196844927, height: 752.9411905502093, allowFontScaling: true);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0.sp),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 12.0.sp,
            ),
            SubTitleText(
                text: StringLocalization.of(context)
                    .getText(StringLocalization.chooseYourStepTarget)),
            SizedBox(height: 15.0.sp),
            stepSlider(),
            SizedBox(
              height: 30.0.sp,
            ),
            Selector<TargetModel, int>(
              selector: (context, model) => model.stepCount.round(),
              builder: (context, stepCount, child) => Body2Text(
                text:
                    '${StringLocalization.of(context).getText(StringLocalization.targetScreen)}: $stepCount',
                align: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.0.sp,
            ),
            Center(
              child: Body1AutoText(
                text: StringLocalization.of(context)
                    .getText(StringLocalization.stepSuggestion),
                color: Colors.grey,
                align: TextAlign.center,
                maxLine: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Body2Text selectedDistanceText() {
    String strValue = '${targetModel.selectedDistance.round()} mm';
    if (distanceUnit == 1) {
      strValue =
          "${(targetModel.selectedDistance / 1609).toStringAsFixed(2).padLeft(2, "0")} ${targetModel.selectedDistance < 1 ? "Mile" : "Miles"}";
    } else {
      if (targetModel.selectedDistance > 1000) {
        strValue =
            "${(targetModel.selectedDistance / 1000).toStringAsFixed(2).padLeft(2, "0")} km";
      }
    }
    return Body2Text(
      text:
          '${StringLocalization.of(context).getText(StringLocalization.distanceTarget)} $strValue',
      align: TextAlign.center,
    );
  }

  Column stepSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 20.0.sp),
        Container(
          key: Key('stepsTarget'),
          alignment: Alignment.center,
          height: 30.0.sp,
          child: RotatedBox(
            quarterTurns: 135,
            child: Selector<TargetModel, int>(
              selector: (context, model) => model.stepValue ?? 0,
              builder: (context, stepValue, child) => CustomCupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: new FixedExtentScrollController(
                    initialItem: targetModel.listOfStep
                        .indexOf(targetModel.stepCount.toInt())),
                itemExtent: 60.sp,
                children: List.generate(targetModel.listOfStep.length, (index) {
                  return RotatedBox(
                  //  key: stepValue == targetModel.listOfStep[index]?Key('targetStepSlider'):Key('anotherTargetValue'),
                    quarterTurns: 45,
                    child: Container(
                      // key: Key('targetStepSlider'),
                      margin: EdgeInsets.all(5.0.sp),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: TitleText(
                          text: targetModel.listOfStep[index].toString(),
                          color: stepValue == targetModel.listOfStep[index]
                              ? AppColor.primaryColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  // stepValue = listOfStep[value];
                  // stepCount = listOfStep[value].toDouble();
                  targetModel.updateStepValue(targetModel.listOfStep[value]);
                  targetModel.updateStepCount(
                      targetModel.listOfStep[value].toDouble());
                  targetModel.updateIsGoalEdit();
                  // setState(() {});
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0.sp),
        Body1AutoText(
          text:
              StringLocalization.of(context).getText(StringLocalization.steps),
          align: TextAlign.center,
        )
      ],
    );
  }

  Widget sleepTargetCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 12.0.sp,
              ),
              SubTitleText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.chooseSleepTarget)),
              SizedBox(height: 15),
              hourSlider(),
              SizedBox(
                height: 15.0.sp,
              ),
              minuteSlider(),
              SizedBox(
                height: 30.0.sp,
              ),
              Selector<TargetModel, String>(
                selector: (context, model) =>
                    '${model.sleepHour.round()} H ${targetModel.sleepMinute.round().toString().padLeft(2, "0")} M',
                builder: (context, sleepTime, child) => Body2Text(
                  text:
                      '${StringLocalization.of(context).getText(StringLocalization.sleeptargetScreen)}: $sleepTime',
                  align: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10.0.sp,
              ),
              Center(
                child: Body1AutoText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.sleepSuggestion),
                  color: Colors.grey,
                  align: TextAlign.center,
                  maxLine: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column minuteSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 10.0.sp),
        Container(
          key: Key('sleepMinuteGoal'),
          height: 30.0.sp,
          child: RotatedBox(
            quarterTurns: 135,
            child: Selector<TargetModel, int>(
              selector: (context, model) => model.minuteValue ?? 0,
              builder: (context, minuteValue, child) => CustomCupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: new FixedExtentScrollController(
                    initialItem: targetModel.listOfMinute
                        .indexOf(targetModel.sleepMinute)),
                itemExtent: 40.w,
                children:
                    List.generate(targetModel.listOfMinute.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Container(
                      margin: EdgeInsets.all(5.0.sp),
                      child: TitleText(
                        text: (targetModel.listOfMinute[index]).toString(),
                        color: minuteValue == targetModel.listOfMinute[index]
                            ? AppColor.primaryColor
                            : Colors.black,
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  // minuteValue = listOfMinute[value];
                  // sleepMinute = listOfMinute[value].toDouble();
                  targetModel
                      .updateMinuteValue(targetModel.listOfMinute[value]);
                  targetModel.updateSleepMinute(
                      targetModel.listOfMinute[value].toDouble());
                  targetModel.updateIsGoalEdit();
                  // setState(() {});
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0.sp),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Body1AutoText(
            text: StringLocalization.of(context)
                .getText(StringLocalization.minute),
            align: TextAlign.center,
          ),
        )
      ],
    );
  }

  Column hourSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 10.0.sp),
        Container(
          key: Key('sleepTarget'),
          height: 30.0.sp,
          child: RotatedBox(
            quarterTurns: 135,
            child: Selector<TargetModel, int>(
              selector: (context, model) => model.hourValue ?? 0,
              builder: (context, hourValue, child) => CustomCupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: new FixedExtentScrollController(
                    initialItem:
                        targetModel.listOfHour.indexOf(targetModel.sleepHour)),
                itemExtent: 40.w,
                children: List.generate(targetModel.listOfHour.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Container(
                      margin: EdgeInsets.all(5.0.sp),
                      child: TitleText(
                        text: (targetModel.listOfHour[index]).toString(),
                        color: hourValue == targetModel.listOfHour[index]
                            ? AppColor.primaryColor
                            : Colors.black,
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  // hourValue = listOfHour[value];
                  // sleepHour = listOfHour[value].toDouble();
                  targetModel.updateHourValue(targetModel.listOfHour[value]);
                  targetModel.updateSleepHour(
                      targetModel.listOfHour[value].toDouble());
                  targetModel.updateIsGoalEdit();
                  // setState(() {});
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0.sp),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Body1AutoText(
            text:
                StringLocalization.of(context).getText(StringLocalization.hour),
            align: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget caloriesTargetCard() {
//    ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0.sp),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 12.0.sp,
            ),
            SubTitleText(
                text: StringLocalization.of(context)
                    .getText(StringLocalization.chooseYourCaloriesTarget)),
            SizedBox(height: 15.0.sp),
            caloriesSlider(),
            SizedBox(
              height: 30.0.sp,
            ),
            Selector<TargetModel, int>(
              selector: (context, model) => model.selectedCalories.round(),
              builder: (context, selectedCalories, child) => Body2Text(
                text:
                    '${StringLocalization.of(context).getText(StringLocalization.caloriesTarget)} $selectedCalories',
                align: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.0.sp,
            ),
            Center(
              child: Body1AutoText(
                text: StringLocalization.of(context)
                    .getText(StringLocalization.caloriesSuggestion),
                color: Colors.grey,
                align: TextAlign.center,
                maxLine: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column caloriesSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 20.0.sp),
        Container(
          key: Key('caloriesTarget'),
          alignment: Alignment.center,
          height: 30.0.sp,
          child: RotatedBox(
            quarterTurns: 135,
            child: Selector<TargetModel, int>(
              selector: (context, model) => model.caloriesValue ?? 0,
              builder: (context, caloriesValue, child) => CustomCupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: new FixedExtentScrollController(
                    initialItem: targetModel.listOfCalories
                        .indexOf(targetModel.selectedCalories.toInt())),
                itemExtent: 60.sp,
                children:
                    List.generate(targetModel.listOfCalories.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Container(
                      margin: EdgeInsets.all(5.0.sp),
                      child: TitleText(
                        text: targetModel.listOfCalories[index].toString(),
                        color:
                            caloriesValue == targetModel.listOfCalories[index]
                                ? AppColor.primaryColor
                                : Colors.black,
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  // caloriesValue = listOfCalories[value];
                  // selectedCalories = listOfCalories[value].toDouble();
                  targetModel
                      .updateCalorieValue(targetModel.listOfCalories[value]);
                  targetModel.updateSelectedCalorie(
                      targetModel.listOfCalories[value].toDouble());
                  targetModel.updateIsGoalEdit();
                  // setState(() {});
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0.sp),
        Body1AutoText(
          text: StringLocalization.of(context)
              .getText(StringLocalization.calories),
          align: TextAlign.center,
        )
      ],
    );
  }

  Widget distanceTargetCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0.sp),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 12.0.sp,
            ),
            SubTitleText(
                text: StringLocalization.of(context)
                    .getText(StringLocalization.chooseYourDistanceTarget)),
            SizedBox(height: 15.0.sp),
            distanceSlider(),
            SizedBox(
              height: 30.0.sp,
            ),
            Selector<TargetModel, double>(
                selector: (context, model) => model.selectedDistance,
                builder: (context, selectedDistance, child) =>
                    selectedDistanceText()),
            SizedBox(
              height: 10.0.sp,
            ),
            Center(
              child: Body1AutoText(
                text: StringLocalization.of(context).getText(distanceUnit == 1
                    ? StringLocalization.distanceSuggestionMile
                    : StringLocalization.distanceSuggestion),
                color: Colors.grey,
                align: TextAlign.center,
                maxLine: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column distanceSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 20.0.sp),
        Container(
          key: Key('distanceTarget'),
          alignment: Alignment.center,
          height: 30.0.sp,
          child: RotatedBox(
            quarterTurns: 135,
            child: Selector<TargetModel, int>(
              selector: (context, model) => model.distanceValue ?? 0,
              builder: (context, distanceValue, child) => CustomCupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: new FixedExtentScrollController(
                    initialItem: targetModel.listOfDistance
                        .indexOf(targetModel.selectedDistance.toInt())),
                itemExtent: 60.sp,
                children:
                    List.generate(targetModel.listOfDistance.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Container(
                      margin: EdgeInsets.all(5.0.sp),
                      child: TitleText(
                        text: distance(index),
                        color:
                            distanceValue == targetModel.listOfDistance[index]
                                ? AppColor.primaryColor
                                : Colors.black,
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  // distanceValue = listOfDistance[value];
                  // selectedDistance = listOfDistance[value].toDouble();
                  targetModel
                      .updateDistanceValue(targetModel.listOfDistance[value]);
                  targetModel.updateSelectedDistance(
                      targetModel.listOfDistance[value].toDouble());
                  targetModel.updateIsGoalEdit();
                  // setState(() {});
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0.sp),
        Body1AutoText(
          text: StringLocalization.of(context)
              .getText(StringLocalization.distance),
          align: TextAlign.center,
        )
      ],
    );
  }

  String distance(int index) {
    if (distanceUnit == 1) {
      return (targetModel.listOfDistance[index] / 1609).toStringAsFixed(2);
    }
    return targetModel.listOfDistance[index].toString();
  }

  Widget weightTargetCard() {
//    ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0.sp),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 12.0.sp,
            ),
            SubTitleText(
                text: StringLocalization.of(context)
                    .getText(StringLocalization.chooseYourWeightTarget)),
            SizedBox(height: 15.0.sp),
            weightSlider(),
            SizedBox(
              height: 30.0.sp,
            ),
            Selector<TargetModel, int>(
              selector: (context, model) => model.selectedWeight.round(),
              builder: (context, selectedWeight, child) => Body2Text(
                text:
                    "${StringLocalization.of(context).getText(StringLocalization.weightTarget)}: $selectedWeight ${UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric ? 'kg' : StringLocalization.of(context).getText(StringLocalization.lb)}",
                align: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.0.sp,
            ),
            Center(
              child: Body1AutoText(
                text: getWeightSuggestion(),
                color: Colors.grey,
                align: TextAlign.center,
                maxLine: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getWeightSuggestion(){
    var lowerWeight = 50.0;
    var higherWeight = 60.0;
    if(globalUser != null && globalUser!.height != null && globalUser!.weight != null){
       lowerWeight = 18.5 * double.parse(globalUser!.height!) * double.parse(globalUser!.height!) / 10000;
       higherWeight = 24.9 * double.parse(globalUser!.height!) * double.parse(globalUser!.height!) / 10000;
    }
    if(UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial){
      // lowerWeight = lowerWeight * 2.205;
      // higherWeight = higherWeight * 2.205;
      lowerWeight = lowerWeight * 2.20462;
      higherWeight = higherWeight * 2.20462;
    }
    return '${StringLocalization.of(context).getText(
        StringLocalization.weightSuggestion)}'
        '${lowerWeight.round()} to ${higherWeight.round()} ${ UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial ?
    StringLocalization.of(context).getText(StringLocalization.lb) :
    StringLocalization.of(context).getText(StringLocalization.kg)}';
  }

  Column weightSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 20.0.sp),
        Container(
          key: Key('weightTarget'),
          alignment: Alignment.center,
          height: 30.0.sp,
          child: RotatedBox(
            quarterTurns: 135,
            child: Selector<TargetModel, int>(
              selector: (context, model) => model.weightValue ?? 0,
              builder: (context, weightValue, child) => CustomCupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: new FixedExtentScrollController(
                    initialItem: targetModel.listOfWeight
                        .indexOf(targetModel.selectedWeight.toInt())),
                itemExtent: 60.sp,
                children:
                    List.generate(targetModel.listOfWeight.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Container(
                      margin: EdgeInsets.all(5.0.sp),
                      child: TitleText(
                        text: targetModel.listOfWeight[index].toString(),
                        color: weightValue == index
                            ? AppColor.primaryColor
                            : Colors.black,
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  // weightValue = value;
                  // selectedWeight = listOfWeight[value].toDouble();
                  targetModel.updateWeightValue(value);
                  targetModel.updateSelectedWeight(
                      targetModel.listOfWeight[value].toDouble());
                  targetModel.updateIsGoalEdit();
                  // setState(() {});
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0.sp),
        Body1AutoText(
          text:
              StringLocalization.of(context).getText(StringLocalization.weight),
          align: TextAlign.center,
        )
      ],
    );
  }

  void getPreferences() async {
    try {
      targetModel.userId = preferences?.getString(Constants.prefUserIdKeyInt);
      var strJson = preferences?.getString(Constants.prefSavedStepTarget) ?? '';
      if (strJson.isNotEmpty) {
        Map map = jsonDecode(strJson);
        if (map != null && map.containsKey('userId')) {
          if (map['userId'] == targetModel.userId) {
            if (map.containsKey('step')) {
              if (map['step'].toDouble() >= 100) {
                // stepCount = map["step"].toDouble();
                targetModel.updateStepCount(map['step'].toDouble());
              } else {
                // stepCount = await connections.getStepTarget() + 0.0;
                targetModel
                    .updateStepCount(await connections.getStepTarget() + 0.0);
              }
            } else {
              // stepCount = await connections.getStepTarget() + 0.0;
              targetModel
                  .updateStepCount(await connections.getStepTarget() + 0.0);
            }
          } else {
            // stepCount = await connections.getStepTarget() + 0.0;
            targetModel
                .updateStepCount(await connections.getStepTarget() + 0.0);
          }
        } else {
          // stepCount = await connections.getStepTarget() + 0.0;
          targetModel.updateStepCount(await connections.getStepTarget() + 0.0);
        }
      }

      var strJson1 =
          preferences?.getString(Constants.prefSavedSleepTarget) ?? '';
      if (strJson1.isNotEmpty) {
        Map map = jsonDecode(strJson1);
        if (map != null && map.containsKey('userId')) {
          if (map['userId'] == targetModel.userId) {
            if (map.containsKey('hour')) {
              // sleepHour = map["hour"].toDouble();
              targetModel.updateSleepHour(map['hour'].toDouble());
            }
            if (map.containsKey('minute')) {
              // sleepMinute = map["minute"].toDouble();
              targetModel.updateSleepMinute(map['minute'].toDouble());
            }
          }
        }
      }

      strJson1 =
          preferences?.getString(Constants.prefSavedDistanceTarget) ?? '';
      if (strJson1.isNotEmpty) {
        Map map = jsonDecode(strJson1);
        if (map.containsKey('distance')) {
          if (map['distance'].toDouble() >= 75 &&
              map['distance'].toDouble() <= 15250) {
            // selectedDistance = map["distance"].toDouble();
            targetModel.updateSelectedDistance(map['distance'].toDouble());
          }
        }
      }
      strJson1 =
          preferences?.getString(Constants.prefSavedCaloriesTarget) ?? '';
      if (strJson1.isNotEmpty) {
        Map map = jsonDecode(strJson1);
        if (map.containsKey('calories')) {
          if (map['calories'].toDouble() >= 1200 &&
              map['calories'].toDouble() <= 4000) {
            // selectedCalories = map["calories"].toDouble();
            targetModel.updateSelectedCalorie(map['calories'].toDouble());
          }
        }
      }

      strJson1 = preferences?.getString(Constants.prefSavedWeightTarget) ?? '';
      if (strJson1.isNotEmpty) {
        Map map = jsonDecode(strJson1);
        if (map.containsKey('weight')) {
          if (map['weight'].toDouble() >= 30 &&
              map['weight'].toDouble() <= 300) {
            // selectedWeight = weightUnit == 0
            //     ? map["weight"].toDouble()
            //     : map["weight"].toDouble() * 2.205;
            targetModel.updateSelectedWeight(UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
                ? map['weight'].toDouble()
                : map['weight'].toDouble() * 2.20462);

            // targetModel.updateSelectedWeight(UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
            //
            //     ? map['weight'].toDouble()
            //     : map['weight'].toDouble() * 2.205);
          }
        }
      }

      // stepValue = stepCount.toInt();
      // hourValue = sleepHour.toInt();
      // minuteValue = sleepMinute.toInt();
      // distanceValue = selectedDistance.toInt();
      // caloriesValue = selectedCalories.toInt();
      // weightValue = selectedWeight.toInt();
      // isLoading = false;
      targetModel.updateStepValue(targetModel.stepCount.toInt());
      targetModel.updateHourValue(targetModel.sleepHour.toInt());
      targetModel.updateMinuteValue(targetModel.sleepMinute.toInt());
      targetModel.updateDistanceValue(targetModel.selectedDistance.toInt());
      targetModel.updateCalorieValue(targetModel.selectedCalories.toInt());
      targetModel.updateWeightValue(targetModel.selectedWeight.toInt());
      targetModel.updateIsLoading(false);
    } catch (e) {
      print(e);
    }

    // setState(() {});
  }
}
