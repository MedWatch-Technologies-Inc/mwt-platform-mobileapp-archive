import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/set_unit_screen_model.dart';
import 'package:health_gauge/repository/measurement/measurement_repository.dart';
import 'package:health_gauge/repository/measurement/request/set_measurement_unit_request.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/screens/WeightHistory/HelperWidgets/weight_toggle.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/gloabals.dart' as main;
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_toggle_container.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

class SetUnitScreen extends StatefulWidget {
  @override
  _SetUnitScreenState createState() => _SetUnitScreenState();
}

class _SetUnitScreenState extends State<SetUnitScreen> {
  // int wightUnit = 0;
  // int mHeightUnit = 0;
  // int mDistanceUnit = 0;
  // int mTemperatureUnit = 0;
  // int timeUnit = 0;
  // bool isEdited = false;

  late SetUnitScreenModel setUnitScreenModel;

  @override
  void initState() {
    setUnitScreenModel = SetUnitScreenModel();
    setDefaultValues();
    super.initState();
  }

  Future savePreferenceInServer() async {
    var url = Constants.baseUrl + 'StorePreferenceSettings';
    var userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    final storeResult = await PreferenceRepository().storePreferenceSettings(userId);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ChangeNotifierProvider(
      create: (context) => setUnitScreenModel,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: isDarkMode()
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
              backgroundColor:
                  isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: isDarkMode()
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
                height: 28.h,
                child: AutoSizeText(
                  stringLocalization.getText(StringLocalization.setUnit),
                  style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: dataLayout(),
      ),
    );
  }

  void onClickSave(BuildContext context) {
    preferences?.setInt(Constants.wightUnitKey, setUnitScreenModel.wightUnit);
    preferences?.setInt(Constants.mHeightUnitKey, setUnitScreenModel.mHeightUnit);
    preferences?.setInt(Constants.mDistanceUnitKey, setUnitScreenModel.mDistanceUnit);
    preferences?.setInt(Constants.mTemperatureUnitKey, setUnitScreenModel.mTemperatureUnit);
    preferences?.setInt(Constants.mTimeUnitKey, setUnitScreenModel.timeUnit);
    preferences?.setInt(Constants.bloodGlucoseUnitKey, setUnitScreenModel.bloodGlucoseUnit);
    globalUser!.weightUnit = setUnitScreenModel.wightUnit;
    dbHelper.insertUser(globalUser!.toJsonForInsertUsingSignInOrSignUp(), globalUser!.id.toString());
    main.weightUnit = setUnitScreenModel.wightUnit;
    main.heightUnit = setUnitScreenModel.mHeightUnit;
    main.distanceUnit = setUnitScreenModel.mDistanceUnit;
    main.tempUnit = setUnitScreenModel.mTemperatureUnit;
    main.timeUnit = setUnitScreenModel.timeUnit;
    main.bloodGlucoseUnit = setUnitScreenModel.bloodGlucoseUnit;
    setUnitInNative();
    savePreferenceInServer();
    saveUnitInServer();
    if (mounted) {
      try {
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       StringLocalization.of(context)
        //           .getText(StringLocalization.unitSetSuccess),
        //     ),
        //   ),
        // );
        // CustomSnackBar.buildSnackbar(
        //     context,
        //     StringLocalization.of(context)
        //         .getText(StringLocalization.unitSetSuccess),
        //     3);
      } catch (e) {
        print('exception in set unit screen $e');
      }
      Navigator.of(context).pop(true);
    }
  }

  saveUnitInServer() {
    var list = [
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.wightUnitKey}',
        'Unit':
            '${UnitExtension.getUnitType(main.weightUnit) == UnitTypeEnum.metric ? StringLocalization.kg : StringLocalization.lb}',
        'Value': '${main.weightUnit}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mHeightUnitKey}',
        'Unit':
            '${UnitExtension.getUnitType(main.heightUnit) == UnitTypeEnum.metric ? StringLocalization.centimetre : StringLocalization.inch}',
        'Value': '${main.heightUnit}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mDistanceUnitKey}',
        'Unit': '${main.distanceUnit == 0 ? StringLocalization.km : StringLocalization.mileage}',
        'Value': '${main.distanceUnit}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mTemperatureUnitKey}',
        'Unit':
            '${main.tempUnit == 0 ? StringLocalization.celsiusShort : StringLocalization.fahrenheitShort}',
        'Value': '${main.tempUnit}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mTimeUnitKey}',
        'Unit': '${main.timeUnit == 0 ? StringLocalization.twelve : StringLocalization.twentyFour}',
        'Value': '${main.timeUnit}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.bloodGlucoseUnitKey}',
        'Unit': '${main.bloodGlucoseUnit == 0 ? StringLocalization.MMOL : StringLocalization.MGDL}',
        'Value': '${main.bloodGlucoseUnit}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
    ];
    var map = {'UnitData': list};
    var request = SetMeasurementUnitRequest.fromJson(map);
    var result = MeasurementRepository().setMeasurementUnit(request);
    // Units().setUnit(Constants.baseUrl + "SetMeasuremetnUnit", map);
  }

  void setUnitInNative() {
    try {
      if (connections != null) {
        connections.changeWeightScaleUnit(setUnitScreenModel.wightUnit + 1);
        Map map = {
          'weightUnit': main.weightUnit,
          'heightUnit': main.heightUnit,
          'tempUnit': main.tempUnit,
          'distanceUnit': main.distanceUnit,
          'timeUnit': main.timeUnit
        };
        connections.setUnits(map);
      }
    } catch (e) {
      print('exception in set unit screen $e');
    }
  }

  Widget dataLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 33.w),
        child: Column(
          children: [
            SizedBox(height: 46.h),
            Image.asset(
              'asset/appLogo.png',
              height: 119.h,
              width: 170.w,
            ),
            SizedBox(height: 72.h),
            // Expanded(
            //     child: ListView(
            //         shrinkWrap: true,
            //         padding: EdgeInsets.only(
            //           right: 33.0.w,
            //           left: 33.0.w,
            //           bottom: 33.0.h,
            //         ),
            //         // physics: NeverScrollableScrollPhysics(),
            //         children: [
            timeFormat(),
            weightUnitWidget(),
            heightUnit(),
            distanceUnit(),
            temperatureUnit(),
            bloodGlucoseUnit(),
            // ]
            // )
            //     ),
            //     saveButton(),
            cancelSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget timeFormat() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(left: 13.w, right: 13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText(StringLocalization.of(context).getText(StringLocalization.timeFormat)),
          Spacer(),
          Selector<SetUnitScreenModel, int>(
            selector: (context, model) => model.timeUnit,
            builder: (context, timeUnit, child) {
              print('++++++++++++++++++++Timer Rebuild=+++++++++++++');
              return CustomToggleContainer(
                  selectedUnit: timeUnit,
                  unitText1: StringLocalization.of(context).getText(StringLocalization.twelve),
                  unitText2: StringLocalization.of(context).getText(StringLocalization.twentyFour),
                  width: 102.w,
                  unit1Selected: () {
                    if (timeUnit != 0) {
                      setUnitScreenModel.changeTimeUnit(0, mounted);
                      setUnitScreenModel.changeisEdited(true);

                      // this.timeUnit = 0;
                      // if (mounted) {
                      //   setState(() {});
                      // }
                    }
                  },
                  unit2Selected: () {
                    if (timeUnit != 1) {
                      setUnitScreenModel.changeTimeUnit(1, mounted);
                      setUnitScreenModel.changeisEdited(true);

                      // this.timeUnit = 1;
                      // if (mounted) {
                      //   setState(() {});
                      // }
                    }
                  });
            },
          )
        ],
      ),
    );
  }

  Widget weightUnitWidget() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 18.h, left: 13.w, right: 13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText(StringLocalization.of(context).getText(StringLocalization.weight)),
          Spacer(),
          Selector<SetUnitScreenModel, int>(
              selector: (context, model) => model.wightUnit,
              builder: (context, wightUnit, child) {
                print('++++++++++++++++++++wightUnit Rebuild=+++++++++++++');
                return WeightToggle(
                    selectedUnit: wightUnit,
                    unitText1: StringLocalization.of(context).getText(StringLocalization.kg),
                    unitText2: StringLocalization.of(context).getText(StringLocalization.lb),
                    width: 102.w,
                    unit1Selected: () {
                      if (wightUnit != 1) {
                        setUnitScreenModel.changeWightUnit(1, mounted);
                        setUnitScreenModel.changeisEdited(true);

                        // this.wightUnit = 0;
                        // if (mounted) {
                        //   setState(() {});}
                        // }
                      }
                    },
                    unit2Selected: () {
                      if (wightUnit != 2) {
                        setUnitScreenModel.changeWightUnit(2, mounted);
                        setUnitScreenModel.changeisEdited(true);

                        // this.wightUnit = 1;
                        // if (mounted) {
                        //   setState(() {});
                        // }
                      }
                    });
              })
        ],
      ),
    );
  }

  Widget heightUnit() {
    /*

          trailing: Selector<SetUnitScreenModel, int>(
              selector: (context, model) => model.mDistanceUnit,
              builder: (context, mDistanceUnit, child) {
                print("++++++++++++++++++++mDistanceUnit Rebuild=+++++++++++++");
                return toggleContainer(
                    selectedUnit: mDistanceUnit,
                    unitText1: StringLocalization.of(context)
                        .getText(StringLocalization.km),
                    unitText2: StringLocalization.of(context)
                        .getText(StringLocalization.mileage),
                    unit1Selected: () {
                      if (mDistanceUnit != 0) {
                        setUnitScreenModel.changeMDistanceUnit(0, mounted);

                        // this.mDistanceUnit = 0;
                        // if (mounted) {
                        //   setState(() {});
                        // }
                      }
                    },
                    unit2Selected: () {
                      if (mDistanceUnit != 1) {
                        setUnitScreenModel.changeMDistanceUnit(1, mounted);

                        // this.mDistanceUnit = 1;
                        // if (mounted) {
                        //   setState(() {});
                        // }
                      }
                    });
              })),
    );
     */
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 18.h, left: 13.w, right: 13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText(StringLocalization.of(context).getText(StringLocalization.height)),
          Spacer(),
          Selector<SetUnitScreenModel, int>(
              selector: (context, model) => model.mHeightUnit,
              builder: (context, mHeightUnit, child) {
                print('++++++++++++++++++++mHeightUnit Rebuild=+++++++++++++');
                return CustomToggleContainer(
                    selectedUnit: mHeightUnit,
                    unitText1: StringLocalization.of(context).getText(StringLocalization.cmShort),
                    unitText2: StringLocalization.of(context).getText(StringLocalization.feetShort),
                    width: 102.w,
                    unit1Selected: () {
                      if (mHeightUnit != 0) {
                        setUnitScreenModel.changeMHeightUnit(0, mounted);
                        setUnitScreenModel.changeisEdited(true);

                        // this.mHeightUnit = 0;
                        // if (mounted) {
                        //   setState(() {});}
                        // }
                      }
                    },
                    unit2Selected: () {
                      if (mHeightUnit != 1) {
                        setUnitScreenModel.changeMHeightUnit(1, mounted);
                        setUnitScreenModel.changeisEdited(true);

                        // this.mHeightUnit = 1;
                        // if (mounted) {
                        //   setState(() {});
                        // }
                      }
                    });
              }),
        ],
      ),
    );
  }

  Widget distanceUnit() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 18.h, left: 13.w, right: 13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText(StringLocalization.of(context).getText(StringLocalization.distance)),
          Spacer(),
          Selector<SetUnitScreenModel, int>(
              selector: (context, model) => model.mDistanceUnit,
              builder: (context, mDistanceUnit, child) {
                print('++++++++++++++++++++mDistanceUnit Rebuild=+++++++++++++');
                return CustomToggleContainer(
                    selectedUnit: mDistanceUnit,
                    unitText1: StringLocalization.of(context).getText(StringLocalization.km),
                    unitText2: StringLocalization.of(context).getText(StringLocalization.mileage),
                    width: 102.w,
                    unit1Selected: () {
                      if (mDistanceUnit != 0) {
                        setUnitScreenModel.changeMDistanceUnit(0, mounted);
                        setUnitScreenModel.changeisEdited(true);

                        // this.mDistanceUnit = 0;
                        // if (mounted) {
                        //   setState(() {});
                        // }
                      }
                    },
                    unit2Selected: () {
                      if (mDistanceUnit != 1) {
                        setUnitScreenModel.changeMDistanceUnit(1, mounted);
                        setUnitScreenModel.changeisEdited(true);

                        // this.mDistanceUnit = 1;
                        // if (mounted) {
                        //   setState(() {});
                        // }
                      }
                    });
              }),
        ],
      ),
    );
  }

  Widget temperatureUnit() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 18.h, left: 13.w, right: 13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText(StringLocalization.of(context).getText(StringLocalization.bodyTemperature)),
          Spacer(),
          Selector<SetUnitScreenModel, int>(
            selector: (context, model) => model.mTemperatureUnit,
            builder: (context, mTemperatureUnit, child) {
              print('++++++++++++++++++++Temperature Rebuild=+++++++++++++');
              return CustomToggleContainer(
                  selectedUnit: mTemperatureUnit,
                  unitText1:
                      StringLocalization.of(context).getText(StringLocalization.celsiusShort),
                  unitText2:
                      StringLocalization.of(context).getText(StringLocalization.fahrenheitShort),
                  width: 102.w,
                  unit1Selected: () {
                    if (mTemperatureUnit != 0) {
                      setUnitScreenModel.changeMTemperatureUnit(0, mounted);
                      setUnitScreenModel.changeisEdited(true);
                      // this.mTemperatureUnit = 0;
                      // if (mounted) {
                      //   setState(() {});
                      // }
                    }
                  },
                  unit2Selected: () {
                    if (mTemperatureUnit != 1) {
                      setUnitScreenModel.changeMTemperatureUnit(1, mounted);
                      setUnitScreenModel.changeisEdited(true);
                      // this.mTemperatureUnit = 1;
                      // if (mounted) {
                      //   setState(() {});
                      // }
                    }
                  });
            },
          )
        ],
      ),
    );
  }

  Widget bloodGlucoseUnit() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 18.h, left: 13.w, right: 13.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText(StringLocalization.of(context).getText(StringLocalization.bloodGlucose)),
          Spacer(),
          Selector<SetUnitScreenModel, int>(
            selector: (context, model) => model.bloodGlucoseUnit,
            builder: (context, bloodGlucoseUnit, child) {
              print('++++++++++++++++++++Temperature Rebuild=+++++++++++++');
              return CustomToggleContainer(
                  selectedUnit: bloodGlucoseUnit,
                  unitText1: StringLocalization.of(context).getText(StringLocalization.MMOL),
                  unitText2: StringLocalization.of(context).getText(StringLocalization.MGDL),
                  width: 102.w,
                  unit1Selected: () {
                    if (bloodGlucoseUnit != 0) {
                      setUnitScreenModel.changeBloodGlucoseUnit(0, mounted);
                      setUnitScreenModel.changeisEdited(true);
                    }
                  },
                  unit2Selected: () {
                    if (bloodGlucoseUnit != 1) {
                      setUnitScreenModel.changeBloodGlucoseUnit(1, mounted);
                      setUnitScreenModel.changeisEdited(true);
                    }
                  });
            },
          )
        ],
      ),
    );
  }

  Widget saveButton() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      padding: EdgeInsets.only(top: 53.h, bottom: 25.h),
      child: Selector<SetUnitScreenModel, bool>(
        selector: (context, model) => model.isEdited,
        builder: (context, isEdited, child) => Container(
          height: 40.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: isEdited ? HexColor.fromHex('#00AFAA') : Colors.grey.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5.w, -5.h),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5.w, 5.h),
                ),
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30.h),
              // splashColor:  HexColor.fromHex("#00AFAA"),
              onTap: setUnitScreenModel.isEdited
                  ? () {
                      onClickSave(context);
                    }
                  : null,
              child: Container(
                decoration: ConcaveDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.h),
                    ),
                    depression: 10,
                    colors: [
                      Colors.white,
                      HexColor.fromHex('#D1D9E6'),
                    ]),
                child: Center(
                  child: Text(
                    StringLocalization.of(context).getText(StringLocalization.save).toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cancelSaveButton() {
    /// Added by: Akhil
    /// Added on: April/05/2021
    /// this selector is responsible for building Cancel and Save button
    /// when profile is edited(indicated by isEdit)
    return Selector<SetUnitScreenModel, bool>(
        selector: (context, model) => model.isEdited,
        builder: (context, isEdited, child) => Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              margin: EdgeInsets.only(top: 53.h, bottom: 25.h),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        color:
                            isEdited ? HexColor.fromHex('#00AFAA') : Colors.grey.withOpacity(0.7),
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
                                : HexColor.fromHex('#D1D9E6'),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('unitSettingsSave'),
                        borderRadius: BorderRadius.circular(30.h),
                        splashColor: HexColor.fromHex('#00AFAA'),
                        onTap: isEdited
                            ? () async {
                                onClickSave(context);
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.h),
                              ),
                              depression: 11,
                              colors: [
                                Colors.white,
                                HexColor.fromHex('#D1D9E6'),
                              ]),
                          child: Center(
                            child: Body1AutoText(
                              text:
                                  stringLocalization.getText(StringLocalization.save).toUpperCase(),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : Colors.white,
                              minFontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 17.w),
                  Expanded(
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.h),
                          color: isEdited
                              ? HexColor.fromHex('#FF6259').withOpacity(0.8)
                              : Colors.grey.withOpacity(0.7),
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
                                  : HexColor.fromHex('#D1D9E6'),
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: Offset(5, 5),
                            ),
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.h),
                          splashColor: HexColor.fromHex('#FF6259').withOpacity(0.8),
                          onTap: isEdited
                              ? () async {
                                  setDefaultValues();
                                  setUnitScreenModel.isEdited = false;
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: ConcaveDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.h),
                                ),
                                depression: 11,
                                colors: [
                                  Colors.white,
                                  HexColor.fromHex('#D1D9E6'),
                                ]),
                            child: Center(
                              child: Body1AutoText(
                                text: stringLocalization
                                    .getText(StringLocalization.cancel)
                                    .toUpperCase(),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : Colors.white,
                                minFontSize: 10,
                                // maxLine: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  void setDefaultValues() {
    // wightUnit = preferences.getInt(Constants.wightUnitKey) ?? 0;
    // mHeightUnit = preferences.getInt(Constants.mHeightUnitKey) ?? 0;
    // mDistanceUnit = preferences.getInt(Constants.mDistanceUnitKey) ?? 0;
    // mTemperatureUnit = preferences.getInt(Constants.mTemperatureUnitKey) ?? 0;
    // timeUnit = preferences.getInt(Constants.mTimeUnitKey) ?? 0;

    setUnitScreenModel.wightUnit = preferences?.getInt(Constants.wightUnitKey) ?? 1;
    setUnitScreenModel.mHeightUnit = preferences?.getInt(Constants.mHeightUnitKey) ?? 0;
    setUnitScreenModel.mDistanceUnit = preferences?.getInt(Constants.mDistanceUnitKey) ?? 0;
    setUnitScreenModel.mTemperatureUnit = preferences?.getInt(Constants.mTemperatureUnitKey) ?? 0;
    setUnitScreenModel.timeUnit = preferences?.getInt(Constants.mTimeUnitKey) ?? 0;
    setUnitScreenModel.bloodGlucoseUnit = preferences?.getInt(Constants.bloodGlucoseUnitKey) ?? 0;
    connections.changeWeightScaleUnit(main.weightUnit + 1);
    Map map = {
      'weightUnit': main.weightUnit,
      'heightUnit': main.heightUnit,
      'tempUnit': main.tempUnit,
      'distanceUnit': main.distanceUnit,
      // "timeUnit": main.timeUnit
      'timeUnit': setUnitScreenModel.timeUnit
    };
    connections.setUnits(map);
    setUnitScreenModel.changeTimeUnit(setUnitScreenModel.timeUnit, mounted);
  }

  Widget titleText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : HexColor.fromHex('#384341'),
        fontSize: 16.sp,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
