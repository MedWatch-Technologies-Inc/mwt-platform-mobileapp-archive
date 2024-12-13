// ignore_for_file: always_declare_return_types, type_annotate_public_apis, prefer_interpolation_to_compose_strings, override_on_non_overriding_member, prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/auth/auth_repository.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/repository/preference/request/get_preference_setting_request.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/GraphHistory/graph_history_home.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_home.dart';
import 'package:health_gauge/screens/dashboard/dash_board_screen.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/multi_navigator_bottom_bar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final bool? isFromSignInScreen;

  const HomeScreen({Key? key, this.isFromSignInScreen}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GlobalKey<MultiNavigatorBottomBarState> bottomNavigationBarKey = GlobalKey();

//  GlobalKey<MainGraphScreenState> mainGraphScreenGlobalKey =GlobalKey();

  String? userId;

  int initIndex = 0;
  int currentIndex = 0;
  bool? isInternet;
  bool tap = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFirst = true;

  bool isPressedOnce = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    checkDeviceType();
    callPrefrance();
    super.initState();
  }

  callPrefrance() async {
    var res = await PreferenceRepository()
        .getPreferenceSettings(GetPreferenceSettingRequest(userID: userId));
    setState(() {});
  }

  void checkDeviceType() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosInfo;

    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      if (!androidInfo.isPhysicalDevice) {
        isMyTablet = true;
      } else {
        isMyTablet = false;
      }
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.model.toLowerCase().contains("ipad")) {
        isMyTablet = true;
      } else {
        isMyTablet = false;
      }
    }
  }

  Future<void> callApiForGettingLatestAuthToken(
      {required String userName, required String pass}) async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      var deviceToken = preferences?.getString('firebaseMessagingToken') ?? '';
      Map map = {'UserName': userName, 'Password': pass};
      var signInResult =
          await AuthRepository().userLogin(userName, pass, deviceToken);
      if (signInResult.hasData) {
        if (signInResult.getData!.result ?? false) {
          var userModel = UserModel.mapper(signInResult.getData!.data!);
          preferences?.setString(
              Constants.prefUserIdKeyInt, userModel.userId ?? '');
          preferences?.setString(
              Constants.prefUserName, userModel.userName ?? '');
          preferences?.setString(
              Constants.prefUserPasswordKey, Constants.encryptStr(pass));
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light));
    stringLocalization = StringLocalization.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      /*floatingActionButton: FloatingActionButton(
        child: Text('T'),
        onPressed: () async {
          await SyncHelper().initialise();
        },
      ),*/
      body: Stack(
        children: [
          MultiNavigatorBottomBar(
            key: bottomNavigationBarKey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            initTabIndex: initIndex,
            onTap: (int index) async {
              if (index == 2) {
                await graphScreenGlobalKey.currentState?.refreshHRZone();
              }
              currentIndex = index;
              if (index != 1 && measurementGlobalKey.currentState != null) {
                await measurementGlobalKey.currentState!.stopMeasurement();
                if (mTimer.value != null) {
                  mTimer.value?.cancel();
                }
              }
              if (index != 1) {
                var isActive = dashBoardGlobalKey
                        .currentState?.heartRateSecondsTimer?.isActive ??
                    false;
                if (isActive) {
                  connections.stopMeasurement();
                  dashBoardGlobalKey.currentState?.heartRateSecondsTimer
                      ?.cancel();
                }
              }
              switch (index) {
                case 0:
                  {
                    // if (screen == Constants.profile && isEdit) {
                    //   saveProfileData();
                    // }
                    // isEdit = false;
                    screen = Constants.home;
                    dashBoardGlobalKey.currentState?.popTillThis();
                    break;
                  }
                case 2:
                  {
                    // if (screen == Constants.profile && isEdit) {
                    //   saveProfileData();
                    // }
                    // isEdit = false;
                    screen = Constants.graph;
                    if (mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                    break;
                  }
                case 1:
                  {
                    // if (screen == Constants.profile && isEdit) {
                    //   saveProfileData();
                    // }
                    // isEdit = false;
                    screen = Constants.cardioMeasurement;
                    measurementGlobalKey.currentState?.popTillThis(true);
                    break;
                  }
              }
            },
            tabs: [
              BottomBarTab(
                initPageBuilder: (_) {
                  return DashBoardScreen(
                    key: dashBoardGlobalKey,
                  );
                },
                tabIconBuilder: (_) {
                  return Padding(
                    padding: EdgeInsets.zero,
                    key: Key('homeScreen'),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/${currentIndex == 0 ? 'dark_home_icon_on' : 'dark_home_icon_off'}.png'
                          : 'asset/${currentIndex == 0 ? 'home_icon_selected' : 'home_icon_unselected'}.png',
                      //'asset/home_icon_selected.png',
                      height: 32,
                      width: 32,
                    ),
                  );
                },
                tabTitle: '',
              ),
              BottomBarTab(
                initPageBuilder: (_) {
                  var measurementType =
                      preferences?.getInt(Constants.measurementType) ?? 2;
                  return measurementType == 1 &&
                          (globalUser?.isResearcherProfile ?? true)
                      ? MeasurementScreen(key: measurementGlobalKey)
                      : MHistoryHome(
                          isBack: false,
                        );
                },
                tabIconBuilder: (_) {
                  return Padding(
                    key: Key('openMeasurementScreens'),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/${currentIndex == 1 ? 'dark_cardio_icon_on' : 'dark_cardio_icon_off'}.png'
                          : 'asset/${currentIndex == 1 ? 'ecg_icon_selected' : 'ecg_icon_unselected'}.png',
                      height: 32,
                      width: 32,
                    ),
                  );
                },
                tabTitle: '',
              ),
              BottomBarTab(
                initPageBuilder: (_) {
                  return GraphHistoryHome(
                    key: graphScreenGlobalKey,
                  );
                },
                tabIconBuilder: (_) {
                  return Padding(
                    padding: EdgeInsets.all(0),
                    key: Key('graphScreen'),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/${currentIndex == 2 ? 'dark_graph_icon_on' : 'dark_graph_icon_off'}.png'
                          : 'asset/${currentIndex == 2 ? 'graph_icon_selected' : 'graph_icon_unselected'}.png',
                      // 'asset/graph_icon_unselected.png',
                      height: 32,
                      width: 32,
                    ),
                  );
                },
                tabTitle: '',
              ),
              /*BottomBarTab(
                initPageBuilder: (_) => HelpScreen(
                  key: helpwScreenGlobalKey,
                  title: screen,
                ),
                tabIconBuilder: (_) {
                  return Padding(
                    key: Key('clickOnHelpIcon'),
                    padding: const EdgeInsets.all(0),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/${currentINdex == 3 ? 'dark_help_icon_on' : 'dark_help_icon_off'}.png'
                          : 'asset/${currentINdex == 3 ? 'help_icon_selected' : 'help_icon_unselected'}.png',
                      height: 32,
                      width: 32,
                    ),
                  );
                },
                tabTitle: '',
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  backDialog({required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
      title: stringLocalization.getText(StringLocalization.changesNotSaved),
      subTitle:
          stringLocalization.getText(StringLocalization.notSavedDescription),
      maxLine: 2,
      onClickYes: onClickYes,
      onClickNo: () {
        if (context != null) {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
    );
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  Future postDataToAPI() async {
    // Map<String, dynamic> map = {
    //   "UserID": globalUser?.userId,
    //   "FirstName": globalUser?.firstName.toString(),
    //   "LastName": globalUser?.lastName.toString(),
    //   "Gender": globalUser?.gender,
    //   // "UnitID": globalUser.unit,
    //   "DateOfBirth": DateFormat(DateUtil.yyyyMMdd).format(globalUser!.dateOfBirth!),
    //   "Picture": globalUser?.picture,
    //   "Height": globalUser?.height,
    //   "Weight": globalUser?.weight,
    //   "InitialWeight": globalUser?.maxWeight,
    //   "SkinType": globalUser?.skinType,
    //   "IsUpdate": false,
    //   "IsResearcherProfile": globalUser?.isResearcherProfile,
    // };
    // if (globalUser?.picture != null) {
    //   map["IsUpdate"] = true;
    //   map["UserImage"] = globalUser?.picture;
    // }

    var requestData = EditUserRequest(
      userID: globalUser!.userId ?? '',
      firstName: globalUser!.firstName.toString(),
      lastName: globalUser!.lastName.toString(),
      gender: globalUser!.gender ?? '',
      dateOfBirth: DateFormat(DateUtil.yyyyMMdd)
          .format(globalUser!.dateOfBirth ?? DateTime.now()),
      unitID: 1,
      picture: globalUser!.picture ?? '',
      height: globalUser!.height ?? '',
      weight: globalUser!.weight ?? '',
      skinType: globalUser!.skinType ?? '',
      isUpdate: false,
      initialWeight: globalUser!.maxWeight ?? '',
      isResearcherProfile: globalUser!.isResearcherProfile ?? false,
      userMeasurementTypeID: preferences?.getInt(Constants.measurementType),
      weightUnit: weightUnit + 1,
      heightUnit: heightUnit + 1,
    );
    if (globalUser?.picture != null) {
      requestData.isUpdate = true;
      requestData.userImage = globalUser?.picture;
      // map["IsUpdate"] = true;
      // map["UserImage"] = globalUser?.picture;
    }
    var response = await UserRepository().editUser(requestData);
    if (response.hasData) {
      Constants.progressDialog(false, context);
      if (response.getData!.result!) {
        if (response.getData!.data != null) {
          globalUser = UserModel.mapper(response.getData!.data!);
          globalUser?.isSync = 1;
          preferences?.setInt(Constants.measurementType,
              globalUser?.userMeasurementTypeId ?? 0);
        }
      } else {
        CustomSnackBar.buildSnackbar(
            context,
            StringLocalization.of(context)
                .getText(StringLocalization.somethingWentWrong),
            3);
      }
    }
  }

  Future<void> saveProfileData() async {
    isInternet = await Constants.isInternetAvailable();
    backDialog(onClickYes: () async {
      globalUser?.height = '$centimetre';
      globalUser?.weight = '$kg';
      preferences?.setInt(Constants.wightUnitKey, weightUnit);
      preferences?.setInt(Constants.mHeightUnitKey, heightUnit);
      await dbHelper.insertUser(
          globalUser!.toJsonForInsertUsingSignInOrSignUp(),
          globalUser?.userId ?? '');
      if (isInternet ?? false) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        postDataToAPI().then((value) {
          savePreferenceInServer();
        });
      }
    });
  }

  Future savePreferenceInServer() async {
    var url = Constants.baseUrl + 'StorePreferenceSettings';
    // if (userId == null) {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    // }
    // final result =
    //     await SaveAndGetLocalSettings().savePreferencesInServer(url, userId);
    final storeResult =
        await PreferenceRepository().storePreferenceSettings(userId);
    return Future.value();
  }

  onClickBack() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      isPressedOnce = false;
    });
    if (isPressedOnce) {
      exit(0);
    } else {
      Fluttertoast.showToast(
          msg: stringLocalization.getText(StringLocalization.clickAgain));
      isPressedOnce = true;
    }
  }
}
