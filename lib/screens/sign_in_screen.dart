import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/apis/confirm_user_api.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/auth/auth_repository.dart';
import 'package:health_gauge/repository/dashboard/dashboard_repository.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/repository/preference/request/get_preference_setting_request.dart';
import 'package:health_gauge/screens/disclaimer_screen.dart';
import 'package:health_gauge/screens/forgetPassword/change_password_screen.dart';
import 'package:health_gauge/screens/forgot_password_screen.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/screens/SignUp/sign_up_screen.dart';
import 'package:health_gauge/services/analytics/sentry_analytics.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/expandable_text.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/location_utils.dart';
import 'package:health_gauge/utils/reminder_notification.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../tflitet/classifier.dart';
import 'terms_&_condition.dart';

class SignInScreen extends StatefulWidget {
  String? token;

  SignInScreen({this.token});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// scaffoldKey used to display snackBar message
  /// userIdController is controller which is used to get user id entered by user
  /// passwordController is controller which is used to get password entered by user
  /// autoValidate is used to validate form automatically
  String versionName = '1.0.0';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController userIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmUserController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  bool isLoading = true;

  late FocusNode passwordFocusNode;
  late FocusNode userIdFocusNode;

  /// used to validate form by key
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool openKeyboardUserId = false;
  bool openKeyboardPasswd = false;
  bool errorId = false;
  bool errorPaswd = false;
  bool enableClick = true;

  bool errorConfirmUser = false;
  FocusNode confirmUserFocusNode = new FocusNode();
  bool openKeyboardConfirmUser = false;

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// used to store and get data
  bool obscureText = true;
  bool? rememberMe = false;
  String? storedUserId = '';
  String? storedPassword = '';

  // Classifier? _classifier;

  @override
  void initState() {
    // set portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // print('${widget.token} is token');
    setFirebasePreference();
    getDatabase();
    userIdFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    // try {
    //   _classifier = Classifier();
    // } catch (e) {
    //   print(e);
    // }
    getPreference();
    connections.requestHealthKitOrGoogleFitAuthorization();
    super.initState();
  }

  Future<void> getPreference() async {
    preferences ??= await SharedPreferences.getInstance();
    rememberMe = preferences?.getBool(Constants.rememberMe);
    if (rememberMe == null) {
      rememberMe = false;
    } else if (rememberMe ?? false) {
      rememberMe = true;
      storedUserId = preferences?.getString(Constants.storedUserId);
      storedPassword = preferences?.getString(Constants.storedPassword);
      userIdController.text = storedUserId ?? '';
      passwordController.text = storedPassword ?? '';
    } else {
      rememberMe = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<File> getImageFileFromAssets() async {
    final byteData = await rootBundle.load('asset/twinmodelnoptt.tflite');

    final file =
        await File('${(await getApplicationDocumentsDirectory()).path}').create(recursive: true);
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  setFirebasePreference() async {
    widget.token ??= await FirebaseMessaging.instance.getToken();
    print('widget.token :: ${widget.token}');
    if (preferences != null) {
      if (widget.token != null) {
        preferences?.setString('firebaseMessagingToken', '${widget.token}');
      }
    } else {
      await SharedPreferences.getInstance().then((value) {
        preferences = value;
        if (widget.token != null) {
          preferences?.setString('firebaseMessagingToken', '${widget.token}');
        }
      });
    }
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    userIdFocusNode.dispose();
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future getDatabase() {
    return dbHelper.database.then((value) async {
      //  isLoading = false;
      getVersion();
      getPref();
      // await _showLocationDialog();
      LocationUtils().checkPermission(context);
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    var now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? now) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tap back again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            isDarkMode(context) ? Theme.of(context).backgroundColor : Colors.grey[300],
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light));
    stringLocalization = StringLocalization.of(context);
    // ScreenUtil.init(BoxConstraints(), orientation: Orientation.portrait,
    //     designSize :Size(375.0,  812.0));
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pop Screen Disabled. You cannot go to previous screen.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      },
      child: SafeArea(
        bottom: false,
        top: false,
        child: Container(
            color: isDarkMode(context) ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
            child: Visibility(
              visible: isLoading,
              replacement: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : AppColor.backgroundColor,
                ),
                key: scaffoldKey,
                body: layoutMain(),
                bottomNavigationBar: Container(
                  height: 88.h,
                  color:
                      isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                  child: Column(
                    children: [
                      Container(
                        height: 1.5.h,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Constants.navigatePush(
                                  TermsAndCondition(
                                    title: StringLocalization.of(context)
                                        .getText(StringLocalization.privacyPolicy),
                                  ),
                                  context);
                            },
                            child: SizedBox(
                              height: 24.h,
                              child: Body1AutoText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.privacyPolicy),
                                fontSize: 16.sp,
                                color: HexColor.fromHex('#00AFAA'),
                                decoration: TextDecoration.underline,
                                maxLine: 1,
                                minFontSize: 8,
                              ),
                              // child: AutoSizeText(
                              //   'Privacy Policy',
                              //   style: TextStyle(
                              //     fontSize: 16.sp,
                              //     color: HexColor.fromHex('#00AFAA'),
                              //     decoration: TextDecoration.underline,
                              //   ),
                              //   maxLines: 1,
                              //   minFontSize: 8,
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                            child: TitleText(
                              text: ' & ',
                              fontSize: 16.sp,
                              color: HexColor.fromHex('#00AFAA'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Constants.navigatePush(
                                  TermsAndCondition(
                                    title: StringLocalization.of(context)
                                        .getText(StringLocalization.termsAndConditions),
                                  ),
                                  context);
                            },
                            child: SizedBox(
                              height: 24.h,
                              child: Body1AutoText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.termsOfService),
                                fontSize: 16.sp,
                                color: HexColor.fromHex('#00AFAA'),
                                decoration: TextDecoration.underline,
                                maxLine: 2,
                                minFontSize: 8,
                              ),
                              // child: AutoSizeText(
                              //   'Terms of Service',
                              //   style: TextStyle(
                              //     fontSize: 16.sp,
                              //     color: HexColor.fromHex('#00AFAA'),
                              //     decoration: TextDecoration.underline,
                              //   ),
                              //   maxLines: 1,
                              //   minFontSize: 8,
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      version(),
                    ],
                  ),
                ),
              ),
              child: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            )),
      ),
    );
  }

  Widget singUp() {
    return GestureDetector(
      key: Key('signUpScreen'),
      onTap: () {
        Constants.navigatePush(
            SignUpScreen(
              token: widget.token ?? '',
              versionName: versionName,
            ),
            context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 33.w),
        height: 25.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.dontHaveAnAccount),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : HexColor.fromHex('#384341'),
              fontSize: 16.sp,
            ),
            SizedBox(width: 7.0.w),
            Body2Text(
              text: StringLocalization.of(context).getText(StringLocalization.btnSignUp),
              color: HexColor.fromHex('#00AFAA'),
              fontSize: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget disclaimer() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 33.w),
      height: 80.h,
      child: ExpandableText(
        '${stringLocalization.getText(StringLocalization.disclaimer)} : ${stringLocalization.getText(StringLocalization.disclaimerInfo)}',
        trimLines: 3,
        callback: () {
          userIdFocusNode.unfocus();
          passwordFocusNode.unfocus();
          Constants.navigatePush(DisclaimerScreen(), context);
        },
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     SizedBox(
      //       height: 55.h,
      //       child: Text(
      //         '${stringLocalization.getText(StringLocalization.disclaimer)} : ${stringLocalization.getText(StringLocalization.disclaimerInfo)}',
      //         style: TextStyle(
      //           color: Theme.of(context).brightness == Brightness.dark
      //               ? Colors.white.withOpacity(0.87)
      //               : HexColor.fromHex('#384341'),
      //           fontSize:
      //           MediaQuery.of(context).textScaleFactor > 1 ? 8.sp : 12.sp,
      //         ),
      //         maxLines: 3,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //     ),
      //     GestureDetector(
      //       child: SizedBox(
      //         height: 20.h,
      //         child: TitleText(
      //           text: stringLocalization.getText(StringLocalization.readMore),
      //           color: HexColor.fromHex('#00AFAA'),
      //           fontSize: 16,
      //         ),
      //       ),
      //       onTap: () {
      //         userIdFocusNode.unfocus();
      //         passwordFocusNode.unfocus();
      //         Constants.navigatePush(DisclaimerScreen(), context);
      //       },
      //     )
      //   ],
      // ),
    );
  }

  Widget version() {
    return Container(
      height: 17.h,
      child: Body1AutoText(
        text:
            '${StringLocalization.of(context).getText(StringLocalization.version)}${' : $versionName'}',
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.60)
            : HexColor.fromHex('#5D6A68'),
      ),
    );
  }

  Widget layoutMain() {
    return dataLayout();
  }

  Widget dataLayout() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
      child: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 33.w),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      logoImageLayout(),
                      textFields(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              onClickForgotPassword(forgotPassword: false);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Body1AutoText(
                                text: StringLocalization.of(context)
                                        .getText(StringLocalization.forgotId) +
                                    '? ',
                                color: HexColor.fromHex('#00AFAA'),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          Body1AutoText(
                            text: 'or',
                            color: isDarkMode(context)
                                ? Colors.white.withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            fontSize: 16.sp,
                          ),
                          GestureDetector(
                            onTap: () {
                              // onClickForgotPassword(forgotPassword: true);
                              Constants.navigatePush(ChangePasswordNewScreen(), context);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Body1AutoText(
                                text: ' ' +
                                    StringLocalization.of(context)
                                        .getText(StringLocalization.forgotPassword) +
                                    '?',
                                color: HexColor.fromHex('#00AFAA'),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 17.w,
                          // ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Body1AutoText(
                                    text: stringLocalization.getText(StringLocalization.rememberMe),
                                    color: isDarkMode(context)
                                        ? Colors.white.withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: 12,
                                    maxLine: 2,
                                    align: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                customRadioRememberMe()
                              ],
                            ),
                          ),
                          // Expanded(
                          //   flex: 2,
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: FlatButton(
                          //         onPressed:
                          //             null /*() async {
                          //
                          //           String userId = await getId();
                          //           UserModel user = UserModel();
                          //           user.userId = 'Skip$userId';
                          //           sharedpreferences?.setString(
                          //               Constants.prefUserIdKeyInt,
                          //               user.userId);
                          //           try {
                          //             int value = await dbHelper.insertUser(
                          //                 user.toJsonForInsertUsingSignInOrSignUp(),
                          //                 user.id.toString());
                          //             print(value);
                          //           } catch (e) {
                          //             print('exception in sign in screen $e');
                          //           }
                          //
                          //           Constants.navigatePushAndRemove(
                          //               HomeScreen(), context);
                          //
                          //         },
                          //
                          //         }*/
                          //         ,
                          //         child: Text(
                          //           '', //StringLocalization.of(context).getText(StringLocalization.skipBtn),
                          //
                          //           style: TextStyle(
                          //             color: HexColor.fromHex('#00AFAA'),
                          //             fontSize: 16,
                          //           ),
                          //         )),
                          //   ),
                          // ),
                        ],
                      ),
                      logInButton()
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 31.h),
            singUp(),
            disclaimer(),
          ],
        ),
      ),
    );
  }

  Widget customRadioRememberMe() {
    return GestureDetector(
      onTap: () async {
        rememberMe = !(rememberMe ?? false);
        setState(() {});
      },
      child: Container(
        height: 28.h,
        child: Row(
          children: [
            Container(
              height: 28.h,
              width: 28.h,
              decoration: ConcaveDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
                  depression: 4,
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex('#D1D9E6'),
                    Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                  ]),
              child: Container(
                margin: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(3, 3),
                      ),
                    ]),
                child: Container(
                    margin: EdgeInsets.all(3.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rememberMe ?? false ? HexColor.fromHex('FF6259') : Colors.transparent,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logInButton() {
    return Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        padding: EdgeInsets.only(top: 22.h),
        child: GestureDetector(
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#00AFAA')
                    : HexColor.fromHex('#00AFAA').withOpacity(0.8),
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
                key: Key('signInButton'),
                child: Text(
                  StringLocalization.of(context).getText(StringLocalization.loginBtn).toUpperCase(),
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
          onTap: !enableClick
              ? null
              : () {
                  print("log_in");
                  validatingLogin();
                  if (!errorId && !errorPaswd) onClickSignIn();
                },
        ));
  }

  validatingLogin() {
    if (userIdController.text.isEmpty) {
      errorId = true;
    }
    if (passwordController.text.isEmpty) {
      errorPaswd = true;
    }
    setState(() {});
  }

  Widget logoImageLayout() {
    return Padding(
      padding: EdgeInsets.only(bottom: 67.2.h, top: 64.0.h),
      child: Image.asset(
        'asset/appLogo.png',
        height: 119.0.h,
        width: 170.0.w,
      ),
    );
  }

  Widget textFields() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: <Widget>[
          Container(
            // height: 49.h,
            decoration: BoxDecoration(
                color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5.w, -5.h),
                  ),
                  BoxShadow(
                    color: isDarkMode(context)
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5.w, 5.h),
                  ),
                ]),
            child: GestureDetector(
              key: Key('userIdContainer'),
              onTap: () {
                errorId = false;
                userIdFocusNode.requestFocus();
                openKeyboardUserId = true;
                openKeyboardPasswd = false;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                decoration: openKeyboardUserId
                    ? ConcaveDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                        depression: 7,
                        colors: [
                            isDarkMode(context)
                                ? Colors.black.withOpacity(0.5)
                                : HexColor.fromHex('#D1D9E6'),
                            isDarkMode(context)
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                : Colors.white,
                          ])
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        color: isDarkMode(context)
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                      ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'asset/profile_icon_red.png',
                    ),
                    SizedBox(width: 10.0.w),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: openKeyboardUserId ? false : true,
                        child: TextFormField(
                          key: Key('userId'),
                          // textAlignVertical: TextAlignVertical.center,
                          autofocus: openKeyboardUserId,
                          focusNode: userIdFocusNode,
                          autovalidateMode: autoValidate,
                          controller: userIdController,
                          style: TextStyle(fontSize: 16.0),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: errorId
                                  ? StringLocalization.of(context)
                                      .getText(StringLocalization.emptyUserId)
                                  : StringLocalization.of(context)
                                      .getText(StringLocalization.hintForUserId),
                              hintStyle: TextStyle(
                                  color: errorId
                                      ? HexColor.fromHex('FF6259')
                                      : HexColor.fromHex('7F8D8C'))),
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return StringLocalization.of(context)
//                                  .getText(StringLocalization.emptyUserId);
//                            }
//                            return null;
//                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            openKeyboardPasswd = true;
                            openKeyboardUserId = false;
                            errorPaswd = false;
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            // height: 49.h,
            margin: EdgeInsets.only(top: 17.h),
            decoration: BoxDecoration(
                color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5.w, -5.h),
                  ),
                  BoxShadow(
                    color: isDarkMode(context)
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5.w, 5.h),
                  ),
                ]),
            child: GestureDetector(
              key: Key('passwordContainer'),
              onTap: () {
                errorPaswd = false;
                passwordFocusNode.requestFocus();
                openKeyboardUserId = false;
                openKeyboardPasswd = true;
                setState(() {});
              },
              child: Container(
                // height: 49.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                decoration: openKeyboardPasswd
                    ? ConcaveDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                        depression: 7,
                        colors: [
                            isDarkMode(context)
                                ? Colors.black.withOpacity(0.5)
                                : HexColor.fromHex('#D1D9E6'),
                            isDarkMode(context)
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                : Colors.white,
                          ])
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        color: isDarkMode(context)
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                      ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'asset/lock_icon_red.png',
                    ),
                    SizedBox(width: 10.0.w),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: openKeyboardPasswd ? false : true,
                        child: TextFormField(
                          key: Key('password'),
                          autofocus: openKeyboardPasswd,
                          autovalidateMode: autoValidate,
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          style: TextStyle(fontSize: 16.0),
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: errorPaswd
                                  ? StringLocalization.of(context)
                                      .getText(StringLocalization.emptyPassword)
                                  : StringLocalization.of(context)
                                      .getText(StringLocalization.hintForPassword),
                              hintStyle: TextStyle(
                                  color: errorPaswd
                                      ? HexColor.fromHex('FF6259')
                                      : HexColor.fromHex('7F8D8C'))),
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return StringLocalization.of(context)
//                                  .getText(StringLocalization.emptyPassword);
//                            }
//                            return null;
//                          },
                          onFieldSubmitted: (value) {
                            openKeyboardPasswd = false;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(
                        !obscureText ? 'asset/view_icon_grn.png' : 'asset/view_off_icon_grn.png',
                        height: 25.h,
                        width: 25.w,
                      ),
                      onPressed: () {
                        obscureText = !obscureText;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
//          errorPaswd ? Container(height: 17.h,
//              padding: EdgeInsets.only(top: 2.h, left: 40.w),
//              child: Align(
//                alignment: Alignment.centerLeft,
//                child: Text(StringLocalization.of(context).getText(StringLocalization.emptyPassword),
//                  style: TextStyle(
//                      fontSize: 11.sp,
//                      color: HexColor.fromHex('#FF6259')
//                  ),),
//              )) : Container(),
        ],
      );
    });
  }

  bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  void onClickSignIn() {
    if (formKey.currentState!.validate()) {
      //   enableClick = false;
      FocusScope.of(context).requestFocus(FocusNode());
      callApi();
    } else {
      autoValidate = AutovalidateMode.always;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void onClickForgotPassword({bool? forgotPassword}) {
    // Constants.navigatePush(
    //         ForgotPasswordScreen(
    //           forgotPassword: forgotPassword,
    //         ),
    //         context)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(
          forgotPassword: forgotPassword ?? false,
        ),
        settings: RouteSettings(
          name: 'forgetPasswordScreen',
        ),
      ),
    ).then((value) {
      print(value);
      if (value != null && value) {
        CustomSnackBar.CurrentBuildSnackBar(
            context, 'User id has been sent to your registered email. Please check your email.');
      }
    });
  }

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// call rest full api for sign in
  /// store or update register user
  Future<void> callApi() async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      print('call_api');
      var userId = userIdController.text.trim();
      var password = passwordController.text.trim();
      var deviceToken = widget.token ?? (await FirebaseMessaging.instance.getToken() ?? '');
      if (deviceToken == null) {
        if (preferences != null) {
          deviceToken = preferences?.getString('firebaseMessagingToken') ?? '';
        } else {
          SharedPreferences.getInstance().then((value) {
            preferences = value;
            deviceToken = preferences?.getString('firebaseMessagingToken') ?? '';
          });
        }
      }
      Constants.progressDialog(true, context);
      var map = {
        'UserName': userId,
        'Password': password,
        'DeviceToken': deviceToken,
      };
      var signInResult = await AuthRepository().userLogin(userId, password, deviceToken);
      if (signInResult.hasData) {
        if (signInResult.getData!.result ?? false) {
          try {
            preferences ??= await SharedPreferences.getInstance();
            if (rememberMe ?? false) {
              await preferences?.setString(Constants.storedUserId, userIdController.text);
              await preferences?.setString(Constants.storedPassword, passwordController.text);
              await preferences?.setBool(Constants.rememberMe, true);
            } else {
              await preferences?.setString(Constants.storedUserId, '');
              await preferences?.setString(Constants.storedPassword, '');
              await preferences?.setBool(Constants.rememberMe, false);
            }
            var userModel = UserModel.mapper(signInResult.getData!.data!);
            try {
              LoggingService().setUserInfo(userModel.userId);
              await SentryAnalytics().setUserScope(userModel.userId ?? '', userModel.email ?? '');
              SentryAnalytics().addBreadCrumb(message: 'Authenticated User');
              print('Send Analytics');
            } catch (e) {
              print('exception in sign in screen 1 $e');
              LoggingService().warning('SignIn ', 'Exception', error: e);
            }
            await preferences?.setString(
                Constants.prefUserPasswordKey, Constants.encryptStr(password));
            await preferences?.setInt(
                Constants.measurementType,
                userModel.userMeasurementTypeId! == 0
                    ? Platform.isIOS
                        ? 2
                        : 1
                    : userModel.userMeasurementTypeId!);
            try {
              try {
                if (userModel.picture != null && userModel.picture!.isNotEmpty) {
                  var response = await get(Uri(scheme: userModel.picture));
                  var base64DecodedImage = response.bodyBytes;
                  userModel.picture = base64Encode(base64DecodedImage);
                }
              } catch (e) {
                print('exception in sign in screen 2 $e');
                LoggingService().warning('SignIn ', 'Exception', error: e);
              }
              // UserModel user = await dbHelper.getUser(userModel.userId);
              //  if (userModel != null &&
              //      userModel.isConfirmedUser != null &&
              //      userModel.isConfirmedUser ) {
              //userModel.isConfirmedUser = true;
              if (userModel.height == '') {
                userModel.height = Constants.defaultValueofHeightinCM.toString();
              }
              await saveDataToDbAndNavigate(userModel);

              ReminderNotification.initialize();
              ReminderNotification.enableAllByUserId(userModel.userId.toString());
            } catch (e) {
              print('exception in sign in screen 3 $e');
              LoggingService().warning('SignIn ', 'Exception', error: e);
            }
          } catch (e) {
            print('exception in sign in screen 4 $e');
            LoggingService().warning('SignIn ', 'Exception', error: e);
          }
        } else {
          Constants.progressDialog(false, context);
          showErrorDialog(signInResult.getData!.message!);
        }
      } else {
        Constants.progressDialog(false, context);
      }

      if (this.mounted) {
        setState(() {});
      }
      // new SignIn()
      //     .callApi(Constants.baseUrl + "userlogin", map)
      //     .then((result) async {
      //   if (!result["isError"]) {
      //     try {
      //       if (preferences == null) {
      //         preferences = await SharedPreferences.getInstance();
      //       }
      //       if (rememberMe ?? false) {
      //         preferences?.setString(
      //             Constants.storedUserId, userIdController.text);
      //         preferences?.setString(
      //             Constants.storedPassword, passwordController.text);
      //         preferences?.setBool(Constants.rememberMe, true);
      //       } else {
      //         preferences?.setString(Constants.storedUserId, "");
      //         preferences?.setString(Constants.storedPassword, "");
      //         preferences?.setBool(Constants.rememberMe, false);
      //       }
      //       UserModel userModel = result["value"];
      //       // try {
      //       //   String preferencesUrl =
      //       //       Constants.baseUrl + "GetPreferenceSettings";
      //       //   await SaveAndGetLocalSettings()
      //       //       .getPreferencesInServer(preferencesUrl, userModel.userId);
      //       // } catch (e) {
      //       //   print('exception in sign in screen $e');
      //       // }
      //       // Constants.progressDialog(false, context);
      //       try {
      //         // Sentry.configureScope(
      //         //       (scope) => scope.user = User(id: userModel.userId, email: userModel.email),
      //         // );
      //         // Sentry.addBreadcrumb(Breadcrumb(message: 'Authenticated user'));
      //         await SentryAnalytics()
      //             .setUserScope(userModel.userId ?? '', userModel.email ?? '');
      //         SentryAnalytics().addBreadCrumb(message: 'Authenticated User');
      //         print('Send Analytics');
      //       } catch (e) {
      //         print('exception in sign in screen $e');
      //       }
      //       preferences?.setString(
      //           Constants.prefUserPasswordKey, Constants.encryptStr(password));
      //       preferences?.setInt(
      //           Constants.measurementType,
      //           userModel.userMeasurementTypeId! == 0
      //               ? Platform.isIOS
      //                   ? 2
      //                   : 1
      //               : userModel.userMeasurementTypeId!);
      //       try {
      //         try {
      //           if (userModel.picture != null &&
      //               userModel.picture!.isNotEmpty) {
      //             Response response = await get(Uri(scheme: userModel.picture));
      //             Uint8List base64DecodedImage = response.bodyBytes;
      //             userModel.picture = base64Encode(base64DecodedImage);
      //           }
      //         } catch (e) {
      //           print('exception in sign in screen $e');
      //         }
      //         // UserModel user = await dbHelper.getUser(userModel.userId);
      //         //  if (userModel != null &&
      //         //      userModel.isConfirmedUser != null &&
      //         //      userModel.isConfirmedUser ) {
      //         //userModel.isConfirmedUser = true;
      //         await saveDataToDbAndNavigate(userModel);
      //         // } else {
      //         //   await openConfirmationCodeDialog(userModel);
      //         // }
      //
      //         ReminderNotification.initialize();
      //         ReminderNotification.enableAllByUserId(
      //             userModel.userId.toString());
      //       } catch (e) {
      //         print('exception in sign in screen $e');
      //       }
      //
      //       /*scaffoldKey.currentState.showSnackBar(
      //         SnackBar(
      //           content: Text(StringLocalization.of(context).getText(StringLocalization.userLoggedInSuccessfully)),
      //           duration: Duration(seconds: 1),
      //         ),
      //       );*/
      //
      //       // Future.delayed(Duration(seconds: 1)).then((value) {
      //       // Constants.navigatePushAndRemove(
      //       //     HomeScreen(key: homeScreenStateKey), context);
      //       // });
      //     } catch (e) {
      //       print('exception in sign in screen $e');
      //     }
      //   } else if (result["value"].toString().isNotEmpty) {
      //     Constants.progressDialog(false, context);
      //     showErrorDialog(result['value']);
      //     // Timer(Duration(seconds: 2), () {
      //     //   enableClick = true;
      //     //   if (this.mounted) {
      //     //     setState(() {});
      //     //   }
      //     // });
      //   } else {
      //     Constants.progressDialog(false, context);
      //   }
      //
      //   if (this.mounted) {
      //     setState(() {});
      //   }
      // });
    } else {
      showErrorDialog(StringLocalization.of(context).getText(StringLocalization.enableInternet));
      // Timer(Duration(seconds: 2), () {
      //   enableClick = true;
      //   if (this.mounted) {
      //     setState(() {});
      //   }
      // });
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  openConfirmationCodeDialog(UserModel userData) {
    Constants.progressDialog(false, context);
    confirmUserDialog(userData.userId ?? '', onClickOk: () async {
      openKeyboardConfirmUser = false;
      Navigator.of(context, rootNavigator: true).pop();
      // bool isValidPswd =
      // validatePassword(password: confirmUserController.text);
      var isInternet = await Constants.isInternetAvailable();
      if (isInternet) {
        Constants.progressDialog(true, context);
        Map map = {'UserID': userData.userId, 'ConfirmationCode': confirmUserController.text};
        new ConfirmUser()
            .callApi(Constants.baseUrl + 'UserRegistationConfirmation', jsonEncode(map))
            .then((result) async {
          if (!result['isError']) {
            userData.isConfirmedUser = true;
            Constants.progressDialog(true, context);
            if (this.mounted) {
              setState(() {});
            }
            await saveDataToDbAndNavigate(userData);
          } else {
            CustomSnackBar.CurrentBuildSnackBar(context, result['value']);
            Future.delayed(Duration(seconds: 3), () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            });
            openConfirmationCodeDialog(userData);
          }
          confirmUserController.clear();
          setState(() {});
        });
      } else {
        showErrorDialog(StringLocalization.of(context).getText(StringLocalization.enableInternet));
      }
    });
  }

  bool checkDate(DateTime date) {
    var todayDate = DateTime.now();
    return date.month == todayDate.month && date.day == todayDate.day;
  }

  saveDataToDbAndNavigate(UserModel userData) async {
    try {
      var rememberMe = preferences?.getBool(Constants.rememberMe) ?? false;
      var userId = '';
      var password = '';
      if (rememberMe) {
        userId = preferences?.getString(Constants.storedUserId) ?? '';
        password = preferences?.getString(Constants.storedPassword) ?? '';
      } else {
        userId = '';
        password = '';
      }
      await PreferenceRepository()
          .getPreferenceSettings(GetPreferenceSettingRequest(userID: userData.userId));
      if (rememberMe) {
        await preferences?.setString(Constants.storedUserId, userId);
        await preferences?.setString(Constants.storedPassword, password);
        await preferences?.setBool(Constants.rememberMe, true);
      } else {
        await preferences?.setString(Constants.storedUserId, '');
        await preferences?.setString(Constants.storedPassword, '');
        await preferences?.setBool(Constants.rememberMe, false);
      }
      var result = await DashboardRepository().getPreferenceSettings(userData.userId!);
      if (result.hasData) {
        if (result.getData!.result!) {
          try {
            if (result.getData!.sleepInfoModel != null) {
              var date = DateTime.parse(result.getData!.sleepInfoModel!.date!);
              if (checkDate(date)) {
                var items = await dbHelper.getSleepData(userData.userId ?? '');
                try {
                  var item = items.indexWhere(
                      (element) => element.idForApi == result.getData!.sleepInfoModel!.idForApi!);
                  if (item == -1) {
                    await dbHelper.insertSleepDataFromApi(
                        [result.getData!.sleepInfoModel!], userData.userId ?? '');
                  }
                } catch (e) {
                  print(e);
                  LoggingService().warning('SignIn ', 'Exception', error: e);
                }
              }
            }
            if (result.getData!.weightMeasurementModel != null) {
              var weightData = await dbHelper.getWeightDataOfDay(userData.userId ?? '');
              try {
                var weighItem = weightData.indexWhere((element) =>
                    element.idForApi == result.getData!.weightMeasurementModel!.idForApi);
                print(weighItem);
                if (weighItem == -1) {
                  await dbHelper.insertWeightMeasurementDataFromApi(
                      [result.getData!.weightMeasurementModel!], userData.userId ?? '');
                }
              } catch (e) {
                print(e);
                LoggingService().warning('SignIn ', 'Exception', error: e);
              }
            }
            if (result.getData!.motionInfoModel != null) {
              var date = DateTime.parse(result.getData!.motionInfoModel!.date!);
              if (checkDate(date)) {
                var motionItem = await dbHelper.getActivityData(userData.userId ?? '');
                try {
                  var weighItem = motionItem.indexWhere(
                      (element) => element.idForApi == result.getData!.motionInfoModel!.idForApi!);
                  print(weighItem);
                  if (weighItem == -1) {
                    await dbHelper.insertMotionDataFromApi(
                        [result.getData!.motionInfoModel!], userData.userId ?? '');
                  }
                } catch (e) {
                  print(e);
                  LoggingService().warning('SignIn ', 'Exception', error: e);
                }
              }
            }
            if (result.getData!.measurementHistoryModel != null) {
              var measData = await dbHelper.getAllMeasurementHistory(userData.userId ?? '');
              try {
                var weighItem = measData.indexWhere((element) =>
                    element.idForApi == result.getData!.measurementHistoryModel!.idForApi!);
                print(weighItem);
                if (weighItem == -1) {
                  await dbHelper.insertMeasurementDataFromApi(
                      [result.getData!.measurementHistoryModel!], userData.userId ?? '');
                }
              } catch (e) {
                print(e);
                LoggingService().warning('SignIn ', 'Exception', error: e);
              }
            }
            if (result.getData!.tempModel != null) {
              List<TempModel> info = await dbHelper.getSyncTempTableData(userData.userId ?? '');
              var allData = result.getData!.tempModel ?? [];
              try {
                for (var i = 0; i < allData.length; i++) {
                  var isPresent =
                      info.indexWhere((element) => element.idForApi == allData[i].idForApi);
                  if (isPresent == -1) {
                    Map lastItem = allData[i].toMap();
                    lastItem['UserId'] = userData.userId;
                    var result = await dbHelper.insertTemperatureData([lastItem]);
                    print(result);
                  }
                }
              } catch (e) {
                print(e);
                LoggingService().warning('SignIn ', 'Exception', error: e);
              }
            }
          } catch (e) {
            LoggingService().warning('SignIn ', 'Exception', error: e);
            print(e);
          }
        }
      }
    } catch (e) {
      print('exception in sign in screen 5 $e');
      LoggingService().warning('SignIn ', 'Exception', error: e);
    }
    connections.startScan(Constants.e66);
    connections.checkAndConnectDeviceIfNotConnected().then((value) {
      debugPrint('device model $value');
    });
    Constants.progressDialog(false, context);
    preferences?.setString(Constants.prefUserIdKeyInt, userData.userId ?? '');
    preferences?.setString(Constants.prefUserEmailKey, userData.email ?? '');
    preferences?.setString(Constants.prefUserName, userData.userName ?? '');
    preferences?.setInt(Constants.measurementType, userData.userMeasurementTypeId ?? 0);
    var value = await dbHelper.insertUser(
        userData.toJsonForInsertUsingSignInOrSignUp(), userData.id.toString());
    Future.delayed(Duration(seconds: 0)).then((value) {
      Constants.navigatePushAndRemove(
          HomeScreen(
            key: homeScreenStateKey,
            isFromSignInScreen: true,
          ),
          context);
      // Constants.navigatePushAndRemove(MapScreen(), context);
    });
  }

  showErrorDialog(String error) {
    var dialog = CustomInfoDialog(
      title: StringLocalization.of(context).getText(StringLocalization.error),
      subTitle: error,
      maxLine: 2,
      primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
      onClickYes: () {
        Navigator.of(context, rootNavigator: true).pop();
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

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// check user is already logged in or not
  getPref() async {
    try {
      if (preferences == null) {
        preferences = await SharedPreferences.getInstance();
      }
      var userId = preferences?.getString(Constants.prefUserIdKeyInt);
      var userName = preferences?.getString(Constants.prefUserName);
      var pass = preferences?.getString(Constants.prefUserPasswordKey);
      if (pass != null && pass.isNotEmpty) final decrypted = Constants.deCryptStr(pass);
      if (preferences?.getString(Constants.prefTokenKey) != null) {
        Constants.authToken = preferences?.getString(Constants.prefTokenKey) ?? '';
        Constants.header = {
          'Authorization': '${Constants.authToken}',
          'Content-Type': 'application/json',
        };
      }
      print('Auth token : ${Constants.authToken}');
      if (userId != null) {
        preferences?.setInt(Constants.measurementType, 1);
        LoggingService().setUserInfo(userId);
        LoggingService().shout('Sign In', 'Auto SignIn successful opening connection screen');
        Constants.navigatePushAndRemove(HomeScreen(key: homeScreenStateKey), context);
        // Constants.navigatePushAndRemove(MapScreen(), context);
      } else {
        isLoading = false;
      }
      await Future.delayed(Duration(seconds: 1));
      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      LoggingService().warning('SignIn ', 'Exception', error: e);
      print(e);
    }
  }

  getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//      String appName = packageInfo.appName;
//      String packageName = packageInfo.packageName;
      versionName = packageInfo.version;
//      String buildNumber = packageInfo.buildNumber;

      setState(() {});
    });
  }

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// check and request permission
  Future<bool> checkPermission() async {
    _showLocationDialog();
    if (Platform.isIOS) {
      return true;
    }
    var isGranted = await Permission.location.isGranted;
    if (!isGranted) {
      await Permission.location.request();
    }
    return Future.value(false);
  }

  _showLocationDialog() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    var showLocation = preferences?.getBool('showLocation');
    if (Platform.isIOS) return;
    if (showLocation == null || showLocation) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(stringLocalization.getText(StringLocalization.information)),
            content: new Text(
                'This app needs location data to enable [bluetooth feature] even when the app is closed or not in use to reconnects the smartwatch or weigh-scale devices.'),
            actions: <Widget>[
              new TextButton(
                key: Key('agreeKey'),
                child: new Text(
                  'Agree',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex('#00AFAA')),
                ),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  preferences?.setBool('showLocation', false);
                  checkPermission();
                },
              ),
              // usually buttons at the bottom of the dialog
              new TextButton(
                key: Key('disagreeKey'),
                child: new Text(
                  'Disagree',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex('#00AFAA')),
                ),
                onPressed: () {
                  // Close the dialog
                  preferences?.setBool('showLocation', false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  confirmUserDialog(String userId, {required GestureTapCallback onClickOk}) {
    showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                    elevation: 0,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColor.darkBackgroundColor
                                : AppColor.backgroundColor,
                            borderRadius: BorderRadius.circular(10.h),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                    : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(-5, -5),
                              ),
                              BoxShadow(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#000000').withOpacity(0.75)
                                    : HexColor.fromHex('#384341').withOpacity(0.9),
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(5, 5),
                              ),
                            ]),
                        padding: EdgeInsets.only(top: 27.h, left: 26.w, right: 26.w),
                        width: 309.w,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 28.h,
                                child: TitleText(
                                  text: 'Confirm User',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                  // maxLine: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                height: 45.h,
                                child: Body1AutoText(
                                  text:
                                      stringLocalization.getText(StringLocalization.resendCodeText),
                                  maxLine: 2,
                                  minFontSize: 10,
                                  fontSize: 16.sp,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                                child: InkWell(
                                  onTap: () {
                                    callResendConfirmationCodeApi(userId);
                                  },
                                  child: AutoSizeText(
                                    stringLocalization.getText(StringLocalization.resendCode),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: HexColor.fromHex('#00AFAA'),
                                      decoration: TextDecoration.underline,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 10,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                    top: 16.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Container(
                                      //   height: 25.h,
                                      //   child: FittedBody1AutoText(
                                      //     text: 'Confirmation Code',
                                      //     maxLine: 1,
                                      //     fontSize: 16.sp,
                                      //     color: Theme.of(context).brightness ==
                                      //         Brightness.dark
                                      //         ? HexColor.fromHex('#FFFFFF')
                                      //         .withOpacity(0.87)
                                      //         : HexColor.fromHex('#384341'),
                                      //     minFontSize: 8,
                                      //   ),
                                      // ),
                                      SizedBox(height: 12.h),
                                      Container(
                                        // height: 48.h,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? HexColor.fromHex('#111B1A')
                                                : AppColor.backgroundColor,
                                            borderRadius: BorderRadius.circular(10.h),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                                    : Colors.white.withOpacity(0.7),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                                offset: Offset(-4, -4),
                                              ),
                                              BoxShadow(
                                                color: Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.black.withOpacity(0.75)
                                                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                                offset: Offset(4, 4),
                                              ),
                                            ]),
                                        child: GestureDetector(
                                          onTap: () {
                                            errorConfirmUser = false;
                                            confirmUserFocusNode.requestFocus();
                                            openKeyboardConfirmUser = true;
                                            if (this.mounted) {
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            key: Key('confirmUserText'),
                                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                            decoration: openKeyboardConfirmUser
                                                ? ConcaveDecoration(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.h)),
                                                    depression: 7,
                                                    colors: [
                                                        Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? Colors.black.withOpacity(0.5)
                                                            : HexColor.fromHex('#D1D9E6'),
                                                        Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? HexColor.fromHex('#D1D9E6')
                                                                .withOpacity(0.07)
                                                            : Colors.white,
                                                      ])
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(10.h)),
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex('#111B1A')
                                                        : AppColor.backgroundColor,
                                                  ),
                                            child: IgnorePointer(
                                              ignoring: openKeyboardConfirmUser ? false : true,
                                              child: TextFormField(
                                                focusNode: confirmUserFocusNode,
                                                controller: confirmUserController,
                                                style: TextStyle(fontSize: 16.0.sp),
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(bottom: 5.h),
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    hintText: 'Enter Your Confirmation Code',
                                                    hintStyle: TextStyle(
                                                        color: errorConfirmUser
                                                            ? HexColor.fromHex('FF6259')
                                                            : Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? Colors.white.withOpacity(0.38)
                                                                : HexColor.fromHex('7F8D8C'),
                                                        fontSize: 16.sp)),
                                                keyboardType: TextInputType.text,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter(
                                                      regExForRestrictEmoji(),
                                                      allow: false),
                                                  LengthLimitingTextInputFormatter(4),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              child: Container(
                                                height: 34.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30.h),
                                                    color: HexColor.fromHex('#FF6259')
                                                        .withOpacity(0.8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? HexColor.fromHex('#D1D9E6')
                                                                .withOpacity(0.1)
                                                            : Colors.white,
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(-5, -5),
                                                      ),
                                                      BoxShadow(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? Colors.black.withOpacity(0.75)
                                                            : HexColor.fromHex('#D1D9E6'),
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(5, 5),
                                                      ),
                                                    ]),
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
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        stringLocalization
                                                            .getText(StringLocalization.cancel)
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                              ? HexColor.fromHex('#111B1A')
                                                              : Colors.white,
                                                        ),
                                                        maxLines: 1,
                                                        minFontSize: 6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                confirmUserController.clear();
                                                errorConfirmUser = false;
                                                openKeyboardConfirmUser = false;
                                                Navigator.of(context, rootNavigator: true).pop();
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 17.w),
                                          Expanded(
                                              child: GestureDetector(
                                                  child: Container(
                                                    height: 34.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30.h),
                                                        color: HexColor.fromHex('#00AFAA'),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? HexColor.fromHex('#D1D9E6')
                                                                    .withOpacity(0.1)
                                                                : Colors.white,
                                                            blurRadius: 5,
                                                            spreadRadius: 0,
                                                            offset: Offset(-5, -5),
                                                          ),
                                                          BoxShadow(
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? Colors.black.withOpacity(0.75)
                                                                : HexColor.fromHex('#D1D9E6'),
                                                            blurRadius: 5,
                                                            spreadRadius: 0,
                                                            offset: Offset(5, 5),
                                                          ),
                                                        ]),
                                                    child: Container(
                                                      decoration: ConcaveDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(30.h),
                                                          ),
                                                          depression: 10,
                                                          colors: [
                                                            Colors.white,
                                                            HexColor.fromHex('#D1D9E6'),
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(horizontal: 10.w),
                                                        child: Center(
                                                          key: Key('confirmUserOk'),
                                                          child: AutoSizeText(
                                                            stringLocalization
                                                                .getText(StringLocalization.ok)
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: Theme.of(context).brightness ==
                                                                      Brightness.dark
                                                                  ? HexColor.fromHex('#111B1A')
                                                                  : Colors.white,
                                                            ),
                                                            minFontSize: 6,
                                                            maxLines: 1,
                                                            // child: AutoSizeText(
                                                            //   stringLocalization
                                                            //       .getText(
                                                            //           StringLocalization
                                                            //               .ok)
                                                            //       .toUpperCase(),
                                                            //   style: TextStyle(
                                                            //     fontSize: 14.sp,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .bold,
                                                            //     color: Theme.of(context)
                                                            //                 .brightness ==
                                                            //             Brightness
                                                            //                 .dark
                                                            //         ? HexColor
                                                            //             .fromHex(
                                                            //                 '#111B1A')
                                                            //         : Colors
                                                            //             .white,
                                                            //   ),
                                                            //   minFontSize: 6,
                                                            //   maxLines: 1,
                                                            // ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    validateEmptyPassword();
                                                    if (!errorConfirmUser) {
                                                      onClickOk();
                                                    } else {
                                                      if (this.mounted) {
                                                        setState(() {});
                                                      }
                                                    }
                                                  })),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      )
                                    ],
                                  ))
                            ])));
              });
            },
            barrierDismissible: false)
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  bool validatePassword({String? password}) {
    if (password == '1234') {
      return true;
    }
    return false;
  }

  validateEmptyPassword() {
    if (confirmUserController.text.isEmpty) {
      errorConfirmUser = true;
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  RegExp regExForRestrictEmoji() => RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  callResendConfirmationCodeApi(String userId) async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      Map map = {'UserID': userId};
      new ConfirmUser()
          .callApi(Constants.baseUrl + 'ResendConfirmationCode', jsonEncode(map))
          .then((result) async {
        if (result['value'] != null && result['value'] != '') {
          CustomSnackBar.CurrentBuildSnackBar(context, result['value']);
          Future.delayed(Duration(seconds: 3), () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          });
        }
      });
    } else {
      showErrorDialog(StringLocalization.of(context).getText(StringLocalization.enableInternet));
    }
  }

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// get unique id for android and ios.
  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print('device ${androidDeviceInfo.device}');
      print('manufacturer ${androidDeviceInfo.manufacturer}');
      print('model ${androidDeviceInfo.model}');
      print('hardware ${androidDeviceInfo.hardware}');
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
