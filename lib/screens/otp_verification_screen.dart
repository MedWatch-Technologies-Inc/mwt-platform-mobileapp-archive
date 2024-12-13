import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/user/request/forget_password_choose_medium_request.dart';
import 'package:health_gauge/repository/user/request/verify_otp_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/forgetPassword/add_new_password_screen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_otp_text_field.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends StatefulWidget {
  final String? email;
  final String? userId;
  final bool? isPhone;

  OTPVerification({this.email, this.userId, this.isPhone, Key? key}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  bool otpExpired = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Timer? _timer;
  int _sec = 59;
  int _min = 1;
  String mins = '01';
  String secs = '59';
  String versionName = '1.0.0';

  // String? otp;
  String buttonText = 'Verify';

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    getVersion();
    super.initState();
  }

  void startTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _min = 1;
    _sec = 59;
    mins = '01';
    secs = '59';
    buttonText = 'Verify';
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_min < 1 && _sec < 1) {
            otpExpired = true;
            buttonText = 'Resend OTP';
            pinController.clear();
            timer.cancel();
          } else if (_sec < 1) {
            _sec = 59;
            _min--;
            mins = _min.toString().padLeft(2, '0');
            secs = _sec.toString().padLeft(2, '0');
          } else {
            _sec--;
            secs = _sec.toString().padLeft(2, '0');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  Widget version() {
    return Container(
      height: 17.h,
      child: Body1AutoText(
        text:
            StringLocalization.of(context).getText(StringLocalization.version) + ' : $versionName',
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.60)
            : HexColor.fromHex('#5D6A68'),
      ),
    );
  }

  final pinController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          onPressed: () {
            if(mounted){

              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }

            // Navigator.of(context).popUntil(
            //       (route) {
            //     print(route.settings.name);
            //     // MailLandingPage not in route.settings.name
            //     return route.settings.name == 'forgetPasswordScreen';
            //   },
            // );
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),
            shrinkWrap: true,
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 62.22.h, top: 64.h),
                      child: Image.asset(
                        'asset/appLogo.png',
                        height: 119.0.h,
                        width: 170.0.w,
                      ),
                    ),
                    // SizedBox(
                    //   height: 62.h,
                    // ),
                    Container(
                      child: Text(
                        widget.isPhone ?? false
                            ? stringLocalization.getText(
                                StringLocalization.pleaseEnterTheSixDigitCodeSentToYourPhone)
                            : stringLocalization.getText(
                                StringLocalization.pleaseEnterTheSixDigitCodeSentToYourEmail),
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '$mins : $secs',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal,
                                color: otpExpired
                                    ? HexColor.fromHex('#FF6259')
                                    : HexColor.fromHex('#00AFAA')),
                          ),
                        ),
                        SizedBox(
                          height: 34.h,
                        ),
                        Pinput(
                          controller: pinController,
                          length: 6,
                          validator: (value){
                            if(value == null || value.length < 6){
                              return 'Please enter valid OTP';
                            }
                            return null;
                          },
                          defaultPinTheme: PinTheme(
                            height: 45,
                            width: 50,
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            ),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDarkMode() ? Colors.white : Colors.black)
                                        .withOpacity(0.25),
                                    blurRadius: 3,
                                    spreadRadius: 0.2,
                                  )
                                ],
                                border: Border.all(
                                  color:
                                      (isDarkMode() ? Colors.white : Colors.black).withOpacity(0.5),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),

                        SizedBox(height: 27.0.h),
                      ],
                    ),
                    pinController.text.trim().length == 6
                        ? verifyGreen()
                        : (_timer?.isActive ?? false)
                            ? verifyGrey()
                            : resendOTP()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget resendOTP() {
    return Container(
        color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: GestureDetector(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isDarkMode()
                      ? HexColor.fromHex('#00AFAA')
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
                    'Resend Authentication code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode() ? HexColor.fromHex('#111B1A') : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              startTimer();
              callApiForOTP();
            }));
  }

  void validateOtp() {
    // CustomSnackBar.CurrentBuildSnackBar(context, scaffoldKey, "Please enter otp");
  }

  Widget verifyGrey() {
    return Container(
      color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode() ? HexColor.fromHex('#D1D9E6').withOpacity(0.1) : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color:
                      isDarkMode() ? Colors.black.withOpacity(0.75) : HexColor.fromHex('#D1D9E6'),
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
                'Verify'.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : Colors.white,
                ),
              ),
            ),
          ),
        ),
        onTap: validateOtp,
      ),
    );
  }

  Widget verifyGreen() {
    return Container(
        color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: GestureDetector(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isDarkMode()
                      ? HexColor.fromHex('#00AFAA')
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
                    'Verify'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode() ? HexColor.fromHex('#111B1A') : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            onTap: callApiForOTPVerification));
  }

  Future<void> callApiForOTP() async {
    var isInternet = await Constants.isInternetAvailable();
    try {
      if (isInternet) {
        Constants.progressDialog(true, context);
        var data = {'UserName': widget.userId, 'isPhone': widget.isPhone};
        var forgetPasswordChooseMediumResult =
            await UserRepository().forgetPasswordChooseMedium(ForgetPasswordChooseMediumRequest(
          userName: widget.userId,
          isPhone: widget.isPhone,
        ));
        if (forgetPasswordChooseMediumResult.hasData) {
          if (forgetPasswordChooseMediumResult.getData!.result ?? false) {
            Constants.progressDialog(false, context);
          } else {
            Constants.progressDialog(false, context);
          }
        }
        // var result =
        //     await ForgetPasswordChooseMediumApi().callApi(
        //         '${Constants.baseUrl}ForgetPasswordChooseMedium', data);
        // if (result.result ?? false) {
        //   Constants.progressDialog(false, context);
        //   // Constants.navigatePush(OTPVerification(userId: widget.userId,isPhone:currentIndex == 0 ? false : true ,), context);
        // } else {
        //   Constants.progressDialog(false, context);
        // }
      } else {
        CustomSnackBar.buildSnackbar(
            context, StringLocalization.of(context).getText(StringLocalization.enableInternet), 3);
      }
    } catch (e) {
      try {
        CustomSnackBar.buildSnackbar(context, 'Error while request, try again later', 3);
        Constants.progressDialog(false, context);
      } catch (_) {}
    }
    otpExpired = false;
    setState(() {});
  }

  Future<void> callApiForOTPVerification() async {
    if(!formKey.currentState!.validate()){
      return;
    }
    var isInternet = await Constants.isInternetAvailable();
    try {
      if (isInternet) {
        Constants.progressDialog(true, context);
        var data = {
          'UserName': widget.userId,
          'VerificationOTP': pinController.text.trim(),
        };
        final verifyOtpResult = await UserRepository().verifyOTP(
            VerifyOtpRequest(userName: widget.userId, verificationOTP: pinController.text));
        if (verifyOtpResult.hasData) {
          if (verifyOtpResult.getData!.response! == 200) {
            Constants.progressDialog(false, context);
            Constants.navigatePush(
              AddNewPasswordScreen(
                email: widget.email,
                otp: pinController.text.trim(),
                userId: widget.userId,
              ),
              context,
            );
          } else {
            Constants.progressDialog(false, context);
            var dialog = CustomInfoDialog(
              title: 'Notice',
              subTitle: 'Please enter valid verification code.',
              onClickYes: () {
                if(mounted){

                  Navigator.of(context).pop();

                }

              },
              maxLine: 2,
              primaryButton: stringLocalization.getText(StringLocalization.ok),
            );
            showDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => dialog,
                barrierDismissible: false);
          }
        } else {
          CustomSnackBar.buildSnackbar(context, 'Error while request, try again later', 3);
          Constants.progressDialog(false, context);
        }
        // OTPVerificationModel result = await OTPVerificationApi()
        //     .callApi(Constants.baseUrl + "VerifyOTP", data);
        // if (result.response == 200) {
        //   Constants.progressDialog(false, context);
        //   Constants.navigatePush(
        //       AddNewPasswordScreen(
        //         email: widget.email,
        //         otp: otp,
        //         userId: widget.userId,
        //       ),
        //       context);
        //   // Constants.navigatePush(OTPVerification(userId: widget.userId,isPhone:currentIndex == 0 ? false : true ,), context);
        // } else {
        //   Constants.progressDialog(false, context);
        //   var dialog = CustomInfoDialog(
        //     title: "Notice",
        //     subTitle: "Please enter valid verification code.",
        //     onClickYes: () {
        //       Navigator.of(context).pop();
        //     },
        //     maxLine: 2,
        //     primaryButton: stringLocalization.getText(StringLocalization.ok),
        //   );
        //   showDialog(
        //       context: context,
        //       useRootNavigator: true,
        //       builder: (context) => dialog,
        //       barrierDismissible: false);
        // }
      } else {
        CustomSnackBar.buildSnackbar(
            context, StringLocalization.of(context).getText(StringLocalization.enableInternet), 3);
      }
    } catch (e) {
      try {
        CustomSnackBar.buildSnackbar(context, 'Error while request, try again later', 3);
        Constants.progressDialog(false, context);
      } catch (e) {}
    }
    otpExpired = false;
    setState(() {});
  }
}
