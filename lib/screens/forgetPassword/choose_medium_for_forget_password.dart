import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/user/request/forget_password_choose_medium_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/otp_verification_screen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class ChooseMediumForForgetPassword extends StatefulWidget {
  final String? userId;
  final String? email;
  final String? phone;

  ChooseMediumForForgetPassword({this.userId, this.email, this.phone, Key? key})
      : super(key: key);

  @override
  _ChooseMediumForForgetPasswordState createState() =>
      _ChooseMediumForForgetPasswordState();
}

class _ChooseMediumForForgetPasswordState
    extends State<ChooseMediumForForgetPassword> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  int currentIndex = 0;

  @override
  void initState() {
    if (widget.phone!.toLowerCase().contains('not available')) {
      currentIndex = 0;
    } else if (widget.email!.toLowerCase().contains('not available')) {
      currentIndex = 1;
    }
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
            if(mounted){

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
      ),
      body: dataLayout(),
    );
  }

  Widget logoImageLayout() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0.h, top: 20.0.h),
      child: Image.asset(
        'asset/appLogo.png',
        height: 119.0.h,
        width: 170.0.w,
      ),
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
                    margin: EdgeInsets.only(bottom: 35.h),
                    child: Text(
                      stringLocalization
                          .getText(StringLocalization.whereAuthenticationCode),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.email != null &&
                              widget.email!
                                  .toLowerCase()
                                  .contains('not available')
                          ? Container()
                          : customRadio(
                              index: 0,
                              unitText: '${widget.email}',
                              color: currentIndex == 0
                                  ? HexColor.fromHex('FF6259')
                                  : Colors.transparent),
                      SizedBox(
                        height: widget.phone != null &&
                                widget.phone!
                                    .toLowerCase()
                                    .contains('not available')
                            ? 0
                            : 19.w,
                      ),
                      widget.phone != null &&
                              widget.phone!
                                  .toLowerCase()
                                  .contains('not available')
                          ? Container()
                          : customRadio(
                              index: 1,
                              unitText: '${widget.phone}',
                              color: currentIndex == 1
                                  ? HexColor.fromHex('FF6259')
                                  : Colors.transparent),
                    ],
                  ),
                  SizedBox(
                    height: 27.h,
                  ),
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
          onTap: onClickNextButton,
        ));
  }

  void onClickNextButton() async {
    var isInternet = await Constants.isInternetAvailable();
    try {
      if (isInternet) {
        Constants.progressDialog(true, context);
        var data = {
          'UserName': widget.userId,
          'isPhone': currentIndex == 0 ? false : true
        };
        var forgetPasswordChooseMediumResult = await UserRepository()
            .forgetPasswordChooseMedium(ForgetPasswordChooseMediumRequest(
          userName: widget.userId,
          isPhone: currentIndex == 0 ? false : true,
        ));
        if (forgetPasswordChooseMediumResult.hasData) {
          if (forgetPasswordChooseMediumResult.getData!.result!) {
            Constants.progressDialog(false, context);
            Constants.navigatePush(
                OTPVerification(
                  userId: widget.userId!,
                  isPhone: currentIndex == 0 ? false : true,
                ),
                context);
          } else {
            Constants.progressDialog(false, context);
            var dialog = CustomInfoDialog(
              title: 'Error',
              subTitle: '${forgetPasswordChooseMediumResult.getData!.message}',
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
          CustomSnackBar.buildSnackbar(
              context, 'Error while request, try again later', 3);
          Constants.progressDialog(false, context);
        }
        // var result =
        //     await ForgetPasswordChooseMediumApi().callApi(
        //         '${Constants.baseUrl}ForgetPasswordChooseMedium', data);
        // if (result.result!) {
        //   Constants.progressDialog(false, context);
        //   Constants.navigatePush(
        //       OTPVerification(
        //         userId: widget.userId!,
        //         isPhone: currentIndex == 0 ? false : true,
        //       ),
        //       context);
        // } else {
        //   Constants.progressDialog(false, context);
        //   var dialog = CustomInfoDialog(
        //     title: 'Error',
        //     subTitle: '${result.message}',
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
}
