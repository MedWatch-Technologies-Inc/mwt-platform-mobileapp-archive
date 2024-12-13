import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/user/request/reset_password_using_user_name_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/text_utils.dart';

import '../sign_in_screen.dart';

class AddNewPasswordScreen extends StatefulWidget {
  final String? otp;
  final String? email;
  final String? userId;

  AddNewPasswordScreen(
      {required this.otp, required this.email, required this.userId, Key? key})
      : super(key: key);

  @override
  _AddNewPasswordScreenState createState() => _AddNewPasswordScreenState();
}

class _AddNewPasswordScreenState extends State<AddNewPasswordScreen> {
  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String versionName = '1.0.0';
  bool openKeyboardPassword = false;
  bool openConfirmPasswordKeyboard = false;
  String errorMessage = '';
  String errorConfirmPasswordMessage = '';
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool errorPassword = false;
  bool errorConfirmPassword = false;
  bool error8To20Character = false;
  bool mustContainOneUppercase = false;
  bool mustContainOneLowercase = false;
  bool mustContainOneSpecialCharacter = false;
  bool mustContainOneNumber = false;
  bool isFirstTimePassword = true;
  bool obscureText = true;
  bool obscureConfirmText = true;
  bool disableButton = false;
  String messageLengthPassword =
      stringLocalization.getText(StringLocalization.min8toMax20);

  // 'Must be minimum 8 to maximum 20 characters long';
  String messageUppercasePassword =
      stringLocalization.getText(StringLocalization.oneUppercase);

  // 'Must contain at least one uppercase letter';
  String messageLowercasePassword =
      stringLocalization.getText(StringLocalization.oneLowercase);

  // 'Must contain at least one lowercase letter';
  String messageSpecialPassword =
      stringLocalization.getText(StringLocalization.oneSpecialCharacter);

  // 'Must contain at least one special character';
  String messageNumberPassword =
      stringLocalization.getText(StringLocalization.oneNumber);

  @override
  void initState() {
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  void isPasswordCompliant(String password,
      [int minLength = 8, int maxLength = 20]) {
    if (password == null || password.isEmpty) {
      // return false;
      error8To20Character = false;
      mustContainOneLowercase = false;
      mustContainOneNumber = false;
      mustContainOneUppercase = false;
      mustContainOneSpecialCharacter = false;
    }

    var hasUppercase = password.contains(RegExp(r'[A-Z]'));
    var hasDigits = password.contains(RegExp(r'[0-9]'));
    var hasLowercase = password.contains(RegExp(r'[a-z]'));
    var hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    var hasMinLength =
        password.length >= minLength && password.length <= maxLength;
    if (hasUppercase) {
      mustContainOneUppercase = true;
    } else {
      mustContainOneUppercase = false;
    }
    if (hasDigits) {
      mustContainOneNumber = true;
    } else {
      mustContainOneNumber = false;
    }
    if (hasLowercase) {
      mustContainOneLowercase = true;
    } else {
      mustContainOneLowercase = false;
    }
    if (hasSpecialCharacters) {
      mustContainOneSpecialCharacter = true;
    } else {
      mustContainOneSpecialCharacter = false;
    }
    if (hasMinLength) {
      error8To20Character = true;
    } else {
      error8To20Character = false;
    }

    if (hasDigits &&
        hasUppercase &&
        hasLowercase &&
        hasSpecialCharacters &&
        hasMinLength) {
      errorPassword = false;
      errorMessage = '';
    } else {
      errorPassword = true;
      errorMessage = 'Enter password.';
    }

    setState(() {});
    // return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
  }

  void validatePasswordOnPressed(String value) {
    isPasswordCompliant(
      value,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          onPressed: () {
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            Constants.navigatePushAndRemove(SignInScreen(), context);
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
        color: isDarkMode()
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),
            shrinkWrap: true,
            children: <Widget>[
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 62.22.h, top: 63.3.h),
                      child: Image.asset(
                        'asset/appLogo.png',
                        height: 119.0.h,
                        width: 170.0.w,
                      ),
                    ),
                    // SizedBox(
                    //   height: 62.h,
                    // ),
                    Text(
                      stringLocalization.getText(
                          StringLocalization.pleaseEnterYourNewPassword),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Column(
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
                                      ? HexColor.fromHex('#D1D9E6')
                                          .withOpacity(0.1)
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
                              passwordFocusNode.requestFocus();
                              openKeyboardPassword = true;
                              isFirstTimePassword = false;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: openKeyboardPassword
                                  ? ConcaveDecoration(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      depression: 7,
                                      colors: [
                                          isDarkMode()
                                              ? Colors.black.withOpacity(0.5)
                                              : HexColor.fromHex('#D1D9E6'),
                                          isDarkMode()
                                              ? HexColor.fromHex('#D1D9E6')
                                                  .withOpacity(0.07)
                                              : Colors.white,
                                        ])
                                  : BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: isDarkMode()
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                    ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'asset/lock_icon_red.png',
                                    // height: 20.w,
                                    // width: 20.w,
                                  ),
                                  SizedBox(width: 15.0.w),
                                  Expanded(
                                    child: IgnorePointer(
                                      ignoring:
                                          openKeyboardPassword ? false : true,
                                      child: TextFormField(
                                        focusNode: passwordFocusNode,
                                        controller: passwordController,
                                        autofocus: openKeyboardPassword,
                                        style: TextStyle(fontSize: 16.0),
                                        obscureText: obscureText,
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
                                                    .getText(StringLocalization
                                                        .hintForPassword),
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: errorMessage.isNotEmpty
                                                    ? HexColor.fromHex('FF6259')
                                                    : HexColor.fromHex(
                                                        '7F8D8C'))),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (value) {
                                          // openKeyboardEmail = false;
                                          // if (this.mounted) {
                                          //   setState(() {});
                                          // }
                                        },
                                        onChanged: (value) {
                                          validatePasswordOnPressed(value);
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Image.asset(
                                      !obscureText
                                          ? 'asset/view_icon_grn.png'
                                          : 'asset/view_off_icon_grn.png',
                                      height: 25.h,
                                      width: 25.w,
                                    ),
                                    onPressed: () {
                                      obscureText = !obscureText;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        !isFirstTimePassword
                            ? showApiError(messageLengthPassword,
                                isError: !error8To20Character)
                            : Container(),
                        !isFirstTimePassword
                            ? showApiError(messageUppercasePassword,
                                isError: !mustContainOneUppercase)
                            : Container(),
                        !isFirstTimePassword
                            ? showApiError(messageLowercasePassword,
                                isError: !mustContainOneLowercase)
                            : Container(),
                        !isFirstTimePassword
                            ? showApiError(messageSpecialPassword,
                                isError: !mustContainOneSpecialCharacter)
                            : Container(),
                        !isFirstTimePassword
                            ? showApiError(messageNumberPassword,
                                isError: !mustContainOneNumber)
                            : Container(),
                        SizedBox(height: 17.0.h),
                      ],
                    ),
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
                          confirmPasswordFocusNode.requestFocus();
                          openConfirmPasswordKeyboard = true;
                          isFirstTimePassword = false;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: openConfirmPasswordKeyboard
                              ? ConcaveDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  depression: 7,
                                  colors: [
                                      isDarkMode()
                                          ? Colors.black.withOpacity(0.5)
                                          : HexColor.fromHex('#D1D9E6'),
                                      isDarkMode()
                                          ? HexColor.fromHex('#D1D9E6')
                                              .withOpacity(0.07)
                                          : Colors.white,
                                    ])
                              : BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: isDarkMode()
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'asset/lock_icon_red.png',
                                // height: 20.w,
                                // width: 20.w,
                              ),
                              SizedBox(width: 15.0.w),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: openConfirmPasswordKeyboard
                                      ? false
                                      : true,
                                  child: TextFormField(
                                    focusNode: confirmPasswordFocusNode,
                                    controller: confirmPasswordController,
                                    autofocus: openConfirmPasswordKeyboard,
                                    style: TextStyle(fontSize: 16.0),
                                    obscureText: obscureConfirmText,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        // hintText: StringLocalization.of(context).getText(StringLocalization.hintForEmail),
                                        hintText: errorConfirmPasswordMessage
                                                .isNotEmpty
                                            ? errorConfirmPasswordMessage
                                            : StringLocalization.of(context)
                                                .getText(StringLocalization
                                                    .hintForConfirmPassword),
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: errorConfirmPasswordMessage
                                                    .isNotEmpty
                                                ? HexColor.fromHex('FF6259')
                                                : HexColor.fromHex('7F8D8C'))),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {},
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset(
                                  !obscureConfirmText
                                      ? 'asset/view_icon_grn.png'
                                      : 'asset/view_off_icon_grn.png',
                                  height: 25.h,
                                  width: 25.w,
                                ),
                                onPressed: () {
                                  obscureConfirmText = !obscureConfirmText;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 27.h,
                    ),
                    Container(
                        color: isDarkMode()
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: GestureDetector(
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: disableButton
                                    ? Colors.grey.withOpacity(0.7)
                                    : isDarkMode()
                                        ? HexColor.fromHex('#00AFAA')
                                        : HexColor.fromHex('#00AFAA')
                                            .withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode()
                                        ? HexColor.fromHex('#D1D9E6')
                                            .withOpacity(0.1)
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
                                  'Save'.toUpperCase(),
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
                          onTap: disableButton
                              ? null
                              : validatePasswordAndResetPassword,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 88.h,
      //   color: isDarkMode()
      //       ? HexColor.fromHex("#111B1A")
      //       : AppColor.backgroundColor,
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 1.5.h,
      //         color: Colors.black.withOpacity(0.2),
      //       ),
      //       SizedBox(
      //         height: 5.h,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           InkWell(
      //             onTap: () {
      //               Constants.navigatePush(
      //                   TermsAndCondition(
      //                     title: StringLocalization.of(context)
      //                         .getText(StringLocalization.privacyPolicy),
      //                   ),
      //                   context);
      //             },
      //             child: SizedBox(
      //               height: 24.h,
      //               child: Body1AutoText(
      //                 text: "Privacy Policy",
      //                 fontSize: 16.sp,
      //                 color: HexColor.fromHex("#00AFAA"),
      //                 // decoration: TextDecoration.underline,
      //                 maxLine: 1,
      //                 minFontSize: 8,
      //               ),
      //               // child: AutoSizeText(
      //               //   "Privacy Policy",
      //               //   style: TextStyle(
      //               //     fontSize: 16.sp,
      //               //     color: HexColor.fromHex("#00AFAA"),
      //               //     decoration: TextDecoration.underline,
      //               //   ),
      //               //   maxLines: 1,
      //               //   minFontSize: 8,
      //               // ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 24.h,
      //             child: TitleText(
      //               text: " & ",
      //               fontSize: 16.sp,
      //               color: HexColor.fromHex("#00AFAA"),
      //             ),
      //           ),
      //           InkWell(
      //             onTap: () {
      //               Constants.navigatePush(
      //                   TermsAndCondition(
      //                     title: StringLocalization.of(context)
      //                         .getText(StringLocalization.termsAndConditions),
      //                   ),
      //                   context);
      //             },
      //             child: SizedBox(
      //               height: 24.h,
      //               child: Body1AutoText(
      //                 text: "Terms of Service",
      //                 fontSize: 16.sp,
      //                 color: HexColor.fromHex("#00AFAA"),
      //                 // decoration: TextDecoration.underline,
      //                 maxLine: 1,
      //                 minFontSize: 8,
      //               ),
      //               // child: AutoSizeText(
      //               //   "Terms of Service",
      //               //   style: TextStyle(
      //               //     fontSize: 16.sp,
      //               //     color: HexColor.fromHex("#00AFAA"),
      //               //     decoration: TextDecoration.underline,
      //               //   ),
      //               //   maxLines: 1,
      //               //   minFontSize: 8,
      //               // ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 3.h,
      //       ),
      //       version(),
      //     ],
      //   ),
      // ),
    );
  }

  void validatePasswordAndResetPassword() {
    passwordFocusNode.unfocus();
    confirmPasswordFocusNode.unfocus();
    openKeyboardPassword = false;
    openConfirmPasswordKeyboard = false;
    errorConfirmPassword = false;
    if (passwordController.text == null || passwordController.text == '') {
      errorPassword = true;
      errorMessage = 'Enter password';
      passwordController.text = '';
    }
    if (confirmPasswordController.text == null ||
        confirmPasswordController.text == '') {
      errorConfirmPassword = true;
      errorConfirmPasswordMessage = 'Enter Confirm Password';
      confirmPasswordController.text = '';
    }
    if (confirmPasswordController.text != null &&
        confirmPasswordController.text != passwordController.text) {
      errorConfirmPassword = true;
      errorConfirmPasswordMessage = 'Password must match';
      confirmPasswordController.text = '';
    }
    if (!errorPassword && !errorConfirmPassword) {
      callApiAndGoToSignUpScreen();
      disableButton = true;
    } else {
      if (errorPassword) {
        errorPassword = true;
        errorMessage = 'Enter password';
        passwordController.text = '';
      }
    }
    if(mounted){
      setState(() {});

    }

  }

  void callApiAndGoToSignUpScreen() async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      var password = passwordController.text.trim();
      var body = {
        'UserName': widget.userId,
        'VerificationOTP': widget.otp,
        'ConfirmPassword': password
      };
      try {
        Constants.progressDialog(true, context);
        final resetPasswordUsingUserNameResult = await UserRepository()
            .resetPasswordUsingUserName(ResetPasswordUsingUserNameRequest(
          userName: widget.userId,
          verificationOTP: widget.otp,
          confirmPassword: password,
        ));
        if (resetPasswordUsingUserNameResult.hasData) {
          if (resetPasswordUsingUserNameResult.getData!.result!) {
            Constants.progressDialog(false, context);
            CustomSnackBar.CurrentBuildSnackBar(context,
                '${resetPasswordUsingUserNameResult.getData!.message}',
                duration: 3);
            Future.delayed(Duration(seconds: 3), () {
              // Navigator.popUntil(context, (route){
              //   print(route.settings.name);
              //   return route.settings.name == '/';
              // });
              Constants.navigatePushAndRemove(SignInScreen(), context);

              // if(mounted){
              //   Navigator.of(context).pop();
              //   Navigator.of(context).pop();
              //   Navigator.of(context).pop();
              //   Navigator.of(context).pop();
              // }
            });
          } else {
            Constants.progressDialog(false, context);
            CustomSnackBar.CurrentBuildSnackBar(context,
                '${resetPasswordUsingUserNameResult.getData!.message}',
                duration: 3);
            Future.delayed(Duration(seconds: 3), () {
              // CustomSnackBar.CurrentBuildSnackBar(
              //     context, scaffoldKey, '${result.message}',
              //     duration: 5);
              if(mounted){
                Navigator.of(context).pop();
              }

              // Navigator.of(context).pop();
              // Navigator.of(context).pop();
            });
          }
        } else {
          Constants.progressDialog(false, context);
          CustomSnackBar.CurrentBuildSnackBar(
              context,  'Something went wrong!!',
              duration: 3);
          Future.delayed(Duration(seconds: 3), () {
            // CustomSnackBar.CurrentBuildSnackBar(
            //     context, scaffoldKey, '${result.message}',
            //     duration: 5);
            if(mounted){
              Navigator.of(context).pop();
            }
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
          });
        }
        // final ResetPasswordUsingUserNameModel result =
        //     await ResetPasswordUsingUserNameApi().callApi(
        //         Constants.baseUrl + "ResetPasswordUsingUserName", body);
        // Constants.progressDialog(false, context);
        // if (result.result!) {
        //   // scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${result.message}')));
        //   CustomSnackBar.CurrentBuildSnackBar(
        //       context, scaffoldKey, '${result.message}',
        //       duration: 5);
        //   // CustomSnackBar.buildSnackbar(context, '${result.message}', 3);
        //   Future.delayed(Duration(seconds: 3), () {
        //     // Navigator.popUntil(context, (route){
        //     //   print(route.settings.name);
        //     //   return route.settings.name == '/';
        //     // });
        //     // Constants.navigatePushAndRemove(SignInScreen(), context);
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //   });
        //   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()), (route) => false);
        // } else {
        //   CustomSnackBar.CurrentBuildSnackBar(
        //       context, scaffoldKey, '${result.message}',
        //       duration: 5);
        //   Future.delayed(Duration(seconds: 3), () {
        //     // CustomSnackBar.CurrentBuildSnackBar(
        //     //     context, scaffoldKey, '${result.message}',
        //     //     duration: 5);
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //   });
        //   // Future.delayed(Duration(seconds: 3),(){
        //   //   Navigator.popUntil(context, (route){
        //   //     print(route.settings.name);
        //   //     return route.settings.name == '/';
        //   //   });
        //   // });
        //   // Constants.navigatePushAndRemove(SignInScreen(), context);
        //   // Navigator.popUntil(context, ModalRoute.withName('/signIn'));
        //   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()), (route) => false);
        // }
      } catch (e) {
        Constants.progressDialog(false, context);
      }
    } else {}
    setState(() {});
  }

  Widget showApiError(String error, {bool? isError}) {
    return Container(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isError ?? false
              ? Image.asset(
                  'asset/info_icon_red.png',
                  width: 26.w,
                  height: 26.w,
                )
              : Icon(
                  Icons.check,
                  color: AppColor.green,
                  size: 26.w,
                ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              error,
              style: TextStyle(
                fontSize: 12.sp,
                color: isError ?? false
                    ? HexColor.fromHex('#FF6259')
                    : AppColor.green,
              ),
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ],
      ),
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
}
