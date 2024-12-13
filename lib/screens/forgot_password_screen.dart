import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/terms_&_condition.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bool forgotPassword;

  ForgotPasswordScreen({required this.forgotPassword});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// validate form by form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String versionName = '1.0.0';

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// get email from controller
  TextEditingController emailAddressController = TextEditingController();

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// validate form automatically
  String errorMessage = '';

  FocusNode emailFocusNode = FocusNode();
  bool openKeyboardEmail = false;

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// key used display snack bar message
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int _sec = 30;
  int _min = 0;
  String mins = '00';
  String secs = '30';

  bool sendUserName = false;
  String buttonText = 'Confirm';
  String pleaseEnterRegisterEmail =
      'Please enter your registered\n email address.';

  Timer? _timer;
  bool sendingSuccessful = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer != null) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Added by: chandresh
    /// Added at: 02-06-2020
    /// this library used to make responsive design
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);

    return Scaffold(
      key: scaffoldKey,
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark
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
            ),
          )),
      bottomNavigationBar: Container(
        height: 88.h,
        color: isDarkMode()
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
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
                      text: 'Privacy Policy',
                      fontSize: 16.sp,
                      color: HexColor.fromHex('#00AFAA'),
                      // decoration: TextDecoration.underline,
                      maxLine: 1,
                      minFontSize: 8,
                    ),
                    // child: AutoSizeText(
                    //   "Privacy Policy",
                    //   style: TextStyle(
                    //     fontSize: 16.sp,
                    //     color: HexColor.fromHex("#00AFAA"),
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
                    color: isDarkMode()
                        ? Colors.white
                        : HexColor.fromHex('#384341'),
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
                      text: 'Terms of Service',
                      fontSize: 16.sp,
                      color: HexColor.fromHex('#00AFAA'),
                      // decoration: TextDecoration.underline,
                      maxLine: 1,
                      minFontSize: 8,
                    ),
                    // child: AutoSizeText(
                    //   "Terms of Service",
                    //   style: TextStyle(
                    //     fontSize: 16.sp,
                    //     color: HexColor.fromHex("#00AFAA"),
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
      body: layoutMain(),
    );
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//      String appName = packageInfo.appName;
//      String packageName = packageInfo.packageName;
      versionName = packageInfo.version;
//      String buildNumber = packageInfo.buildNumber;

      setState(() {});
    });
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
      color:
          isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 33.0.w),
          shrinkWrap: true,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 64.h, bottom: 62.2.h),
                    child: logoImageLayout(),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 36.h),
                    child: Text(
                      pleaseEnterRegisterEmail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                      ),
                    ),
                  ),
                  !widget.forgotPassword && _timer != null && _timer!.isActive
                      ? Column(
                          children: <Widget>[
                            Text(
                              '$mins : $secs',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.normal,
                                  color: HexColor.fromHex('#00AFAA')),
                            ),
                            SizedBox(
                              height: 34.h,
                            ),
                          ],
                        )
                      : Container(),
                  textFields(),
                  nextButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return widget.forgotPassword
        ? Container(
            color: isDarkMode()
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: GestureDetector(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: HexColor.fromHex('#00AFAA'),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode()
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: isDarkMode()
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      depression: 10,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ]),
                  child: Center(
                    child: Text(
                      StringLocalization.of(context)
                          .getText(StringLocalization.next)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode()
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: onClickForgotPassword,
            ))
        : Container(
            color: isDarkMode()
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: GestureDetector(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: _timer != null && _timer!.isActive
                        ? Colors.grey.withOpacity(0.7)
                        : HexColor.fromHex('#00AFAA').withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode()
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: isDarkMode()
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      depression: 10,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ]),
                  child: Center(
                    child: Text(
                      buttonText.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode()
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: _timer != null && _timer!.isActive
                  ? null
                  : onClickForgotPassword,
            ));
  }

  void startTimer() {
    _min = 0;
    _sec = 30;
    mins = '00';
    secs = '30';
    if (_timer != null) {
      setState(() {});
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_sec == 0) {
        _timer?.cancel();
        buttonText = 'Resend';
        if(sendingSuccessful){
          pleaseEnterRegisterEmail = 'If you haven’t received an email yet,\n please resend your request.';
        }else{
          pleaseEnterRegisterEmail =
          'Please enter your registered\n email address.';
        }
        setState(() {});
      } else {
        _sec--;
        if (_sec <= 9) {
          secs = '0$_sec';
        } else {
          secs = '$_sec';
        }
        setState(() {});
      }
    });
  }

  Widget logoImageLayout() {
    return Image.asset(
      'asset/appLogo.png',
      height: 119.0.h,
      width: 170.0.w,
    );
  }

  Widget textFields() {
    return Column(
      children: <Widget>[
        Container(
          // height: 49,
          //margin: EdgeInsets.only(bottom: 17),
          decoration: BoxDecoration(
              color: isDarkMode()
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode()
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: isDarkMode()
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          child: GestureDetector(
            onTap: () {
              emailFocusNode.requestFocus();
              openKeyboardEmail = true;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: openKeyboardEmail
                  ? ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      depression: 7,
                      colors: [
                          isDarkMode()
                              ? Colors.black.withOpacity(0.5)
                              : HexColor.fromHex('#D1D9E6'),
                          isDarkMode()
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                              : Colors.white,
                        ])
                  : BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: isDarkMode()
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                    ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'asset/email_icon_red.png',
                    // height: 20.w,
                    // width: 20.w,
                  ),
                  SizedBox(width: 15.0.w),
                  Expanded(
                    child: IgnorePointer(
                      ignoring: openKeyboardEmail ? false : true,
                      child: TextFormField(
                        focusNode: emailFocusNode,
                        controller: emailAddressController,
                        autofocus: openKeyboardEmail,
                        style: TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            // hintText: StringLocalization.of(context).getText(StringLocalization.hintForEmail),
                            hintText: errorMessage.isNotEmpty
                                ? errorMessage
                                : StringLocalization.of(context)
                                    .getText(StringLocalization.hintForEmail),
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: errorMessage.isNotEmpty
                                    ? HexColor.fromHex('FF6259')
                                    : HexColor.fromHex('7F8D8C'))),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          openKeyboardEmail = false;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 27.0.h),
      ],
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  void onClickForgotPassword() async {
    if (emailAddressController.text.trim().isEmpty) {
      errorMessage =
          StringLocalization.of(context).getText(StringLocalization.emptyEmail);
    }
    if (!Constants.validateEmail(emailAddressController.text.trim())) {
      errorMessage = StringLocalization.of(context)
          .getText(StringLocalization.enterValidEmail);
    }
    var isInvalid = (emailAddressController.text.trim().isEmpty ||
        !Constants.validateEmail(emailAddressController.text.trim()));
    if (!isInvalid) {
      errorMessage = '';
      FocusScope.of(context).requestFocus(FocusNode());
      // CustomSnackBar.buildSnackbar(
      //     context, "Reset link have been sent to $emailAddressController", 3);
      if (widget.forgotPassword) {
        callApi();
      } else {
        var isInternet = await Constants.isInternetAvailable();
        if (isInternet) {
          print("asdasdasdasdasd");

          callApiForUserId();
        }
      }
    } else {
      emailAddressController.text = '';
      setState(() {});
    }
  }

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// call api to get reset link in email
  Future<void> callApi() async {
    // var isInternet = await Constants.isInternetAvailable();
    // if (isInternet) {
    //   var email = emailAddressController.text.trim();
    //   Constants.progressDialog(true, context);
    //   final result = await ForgotPassword()
    //       .callApi('${Constants.baseUrl}${'ForgetPassword?Email=$email'}', '');
    //   if (!result['isError']) {
    //     String url = result['value'];
    //     final result2 = await SignIn().callApi(url, '');
    //     Constants.progressDialog(false, context);
    //     if (!result2['isError']) {
    //       UserModel user = result2['value'];
    //       if (user != null && user.userId != null) {
    //         Constants.navigatePush(
    //             ResetPasswordScreen(userModel: user), context);
    //       }
    //     }
    //   } else {
    //     Constants.progressDialog(false, context);
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => OTPVerification(
    //               email: emailAddressController.text,
    //             )));
    //     if (result['value'].toString().isNotEmpty) {
    //       // scaffoldKey.currentState
    //       //     .showSnackBar(SnackBar(content: Text(result["value"])));
    //       // CustomSnackBar.buildSnackbar(context, result["value"], 3);
    //     }
    //   }
    // } else {
    //   // scaffoldKey.currentState.showSnackBar(SnackBar(
    //   //     content: Text(StringLocalization.of(context)
    //   //         .getText(StringLocalization.enableInternet))));
    //
    //   CustomSnackBar.CurrentBuildSnackBar(
    //       context,
    //       scaffoldKey,
    //       StringLocalization.of(context)
    //           .getText(StringLocalization.enableInternet));
    // }
    // setState(() {});
  }

  Future<void> callApiForUserId() async {
    var isInternet = await Constants.isInternetAvailable();
    try {
      if (isInternet) {
        Constants.progressDialog(true, context);
        // Constants.progressDialog(true, context);
        var data = {
          'Email': emailAddressController.text.trim(),
        };
        // ChangePasswordByUserID?UserId=${globalUser.userId}&OldPassword=${_oldTextEditingController.text}&NewPassword=${_newTextEditingController.text}
        final forgetUserIdResult =
            await UserRepository().forgetUserID(emailAddressController.text.trim());
        if (forgetUserIdResult.hasData) {
          if (forgetUserIdResult.getData!.result ?? false) {
            sendingSuccessful = true;
            Constants.progressDialog(false, context);
            pleaseEnterRegisterEmail =
                'Your User Name has been sent to you email address. Please check your Inbox.';
            buttonText = 'Resend';
            startTimer();
          } else {
            sendingSuccessful = false;
            Constants.progressDialog(false, context);

            showDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => CustomInfoDialog(
                  title: 'Notice',
                  subTitle:
                  'This email does not exist in our system. Please double-check your email address or sign up.',
                  onClickYes: () {
                    Navigator.of(context).pop();
                  },
                  maxLine: 5,
                  primaryButton: stringLocalization.getText(StringLocalization.ok),
                ),
                barrierColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.color7F8D8C.withOpacity(0.6)
                    : AppColor.color384341.withOpacity(0.6),
                barrierDismissible: false);
          }
        } else {
          CustomSnackBar.buildSnackbar(
              context, 'Error while request, try again later', 3);
          Constants.progressDialog(false, context);
        }

      } else {
        CustomSnackBar.buildSnackbar(
            context,
            StringLocalization.of(context)
                .getText(StringLocalization.enableInternet),
            3);
      }
    } catch (e) {
      try {
        CustomSnackBar.buildSnackbar(
            context, 'Error while request, try again later', 3);
        Constants.progressDialog(false, context);
      } catch (_) {}
    }

    setState(() {});
  }
}
