import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/user/request/forget_password_using_user_name_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/forgetPassword/choose_medium_for_forget_password.dart';
import 'package:health_gauge/screens/forgot_password_screen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class ChangePasswordNewScreen extends StatefulWidget {
  const ChangePasswordNewScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordNewScreenState createState() =>
      _ChangePasswordNewScreenState();
}

class _ChangePasswordNewScreenState extends State<ChangePasswordNewScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode userIDFocusNode = FocusNode();
  bool openKeyboardUserID = false;
  String errorMessage = '';

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  late TextEditingController userIdController;
  int currentIndex = 0;

  @override
  void initState() {
    userIdController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
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
      body: dataLayout(),
    );
  }

  Widget logoImageLayout() {
    return Image.asset(
      'asset/appLogo.png',
      height: 119.0.h,
      width: 170.0.w,
    );
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
                    margin: EdgeInsets.only(bottom: 86.h),
                    child: Text(
                      'Please enter your User ID',
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
                  textFields(),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 30.h),
                  //   child: Text(
                  //     "Please select where you want your authentication code",
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? Colors.white.withOpacity(0.87)
                  //           : HexColor.fromHex('#384341'),
                  //     ),
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     customRadio(
                  //         index: 0,
                  //         unitText: 'Email',
                  //         color: currentIndex == 0
                  //             ? HexColor.fromHex("FF6259")
                  //             : Colors.transparent),
                  //     SizedBox(
                  //       width: 30.w,
                  //     ),
                  //     customRadio(
                  //         index: 1,
                  //         unitText: 'Phone',
                  //         color: currentIndex == 1
                  //             ? HexColor.fromHex("FF6259")
                  //             : Colors.transparent),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 25.h,
                  // ),
                  nextButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customRadio(
      {int? index, Color? color, String? unitText, bool? isGender}) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          currentIndex = 0;
        } else {
          currentIndex = 1;
        }
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.h)),
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
                      color: color,
                    )),
              ),
            ),
            SizedBox(
              width: 9.w,
            ),
            unitText != ''
                ? TitleText(
              text: unitText ?? '',
                    fontSize: 16.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                  )
                : Container()
          ],
        ),
      ),
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
              userIDFocusNode.requestFocus();
              openKeyboardUserID = true;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: openKeyboardUserID
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
                    'asset/profile_icon_red.png',
                    // height: 20.w,
                    // width: 20.w,
                  ),
                  SizedBox(width: 15.0.w),
                  Expanded(
                    child: IgnorePointer(
                      ignoring: openKeyboardUserID ? false : true,
                      child: TextFormField(
                        focusNode: userIDFocusNode,
                        controller: userIdController,
                        autofocus: openKeyboardUserID,
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
                                    .getText(StringLocalization.hintForUserId),
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: errorMessage.isNotEmpty
                                    ? HexColor.fromHex('FF6259')
                                    : HexColor.fromHex('7F8D8C'))),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          openKeyboardUserID = false;
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

  Widget nextButton() {
    return Container(
        color: isDarkMode()
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
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
          onTap: onClickNextButton,
        ));
  }

  void onClickNextButton() {
    if (userIdController == null || userIdController.text == '') {
      errorMessage = stringLocalization.getText(StringLocalization.emptyUserId);
      setState(() {});
      return;
    } else {
      callApi();
    }
  }

  Future<void> callApi() async {
    var isInternet = await Constants.isInternetAvailable();
    try {
      if (isInternet) {
        Constants.progressDialog(true, context);
        var data = {
          'UserName': userIdController.text,
        };
        final forgetPasswordUsingUserNameResult = await UserRepository()
            .forgetPasswordUsingUserName(ForgetPasswordUsingUserNameRequest(
                userName: userIdController.text));
        if (forgetPasswordUsingUserNameResult.hasData) {
          if (forgetPasswordUsingUserNameResult.getData!.result!) {
            if(mounted){
              Constants.progressDialog(false, context);
              Constants.navigatePush(
                  ChooseMediumForForgetPassword(
                    userId: userIdController.text,
                    email:
                    forgetPasswordUsingUserNameResult.getData!.emailAddress ??
                        '',
                    phone:
                    forgetPasswordUsingUserNameResult.getData!.phoneNumber ??
                        '',
                  ),
                  context);
            }

          } else {
            Constants.progressDialog(false, context);
            var dialog = CustomDialog(
              title: 'Notice',
              subTitle:
                  'We don’t have any record with this user Id in our system.',
              onClickYes: () {
                Navigator.of(context).pop();
              },
              onClickNo: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Constants.navigatePush(
                    ForgotPasswordScreen(
                      forgotPassword: false,
                    ),
                    context);
              },
              maxLine: 2,
              primaryButton: stringLocalization.getText(StringLocalization.ok),
              secondaryButton:
                  stringLocalization.getText(StringLocalization.forgotUserId),
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
        } else {
          CustomSnackBar.buildSnackbar(
              context, 'Error while request, try again later', 3);
          Constants.progressDialog(false, context);
        }
        // var result =
        //     await ForgetPasswordUsingUserNameApi().callApi(
        //         '${Constants.baseUrl}ForgetPasswordUsingUserName', data);
        // if (result.result!) {
        //   Constants.progressDialog(false, context);
        //   Constants.navigatePush(
        //       ChooseMediumForForgetPassword(
        //         userId: userIdController.text,
        //         email: result.emailAddress ?? '',
        //         phone: result.phoneNumber ?? '',
        //       ),
        //       context);
        // } else {
        //   Constants.progressDialog(false, context);
        //   var dialog = CustomDialog(
        //     title: 'Notice',
        //     subTitle:
        //         'We don’t have any record with this user Id in our system.',
        //     onClickYes: () {
        //       Navigator.of(context).pop();
        //     },
        //     onClickNo: () {
        //       Navigator.of(context).pop();
        //       Navigator.of(context).pop();
        //       Constants.navigatePush(
        //           ForgotPasswordScreen(
        //             forgotPassword: false,
        //           ),
        //           context);
        //     },
        //     maxLine: 2,
        //     primaryButton: stringLocalization.getText(StringLocalization.ok),
        //     secondaryButton:
        //         stringLocalization.getText(StringLocalization.forgotUserId),
        //   );
        //   showDialog(
        //       context: context,
        //       useRootNavigator: true,
        //       builder: (context) => dialog,
        //       barrierDismissible: false);
        // }
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
