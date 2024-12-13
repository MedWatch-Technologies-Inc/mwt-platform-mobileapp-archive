import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  bool openKeyboardOldPassword = false;
  bool openKeyboardNewPassword = false;
  bool openKeyboardConfirmPassword = false;
  late FocusNode oldPasswordFocusNode;
  late FocusNode newPasswordFocusNode;
  late FocusNode confirmNewPasswordNode;
  bool errorOldPassword = false;
  bool errorNewPassword = false;
  bool errorConfirmPassword = false;
  bool isFirstTimePassword = true;
  String apiErrorMsgPassword =
      stringLocalization.getText(StringLocalization.emptyPassword);
  String confirmPasswordError =
      stringLocalization.getText(StringLocalization.emptyConfirmPassword);
  late TextEditingController _oldTextEditingController;
  late TextEditingController _newTextEditingController;
  late TextEditingController _confirmTextEditingController;
  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;
  bool error8To20Character = false;
  bool mustContainOneLowercase = false;
  bool mustContainOneNumber = false;
  bool mustContainOneUppercase = false;
  bool mustContainOneSpecialCharacter = false;
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
    oldPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmNewPasswordNode = FocusNode();
    _oldTextEditingController = TextEditingController(text: '');
    _newTextEditingController = TextEditingController(text: '');
    _confirmTextEditingController = TextEditingController(text: '');
    super.initState();
  }

  Widget showApiError(String error, {bool isError = false}) {
    return Container(
      padding: EdgeInsets.only(
        top: 5.h,
        left: 15.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isError
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
                fontSize: 12,
                color: isError ? HexColor.fromHex('#FF6259') : AppColor.green,
              ),
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            backgroundColor: isDarkMode()
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
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
                StringLocalization.of(context)
                    .getText(StringLocalization.changePassword),
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: isDarkMode()
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 67.2.h, top: 64.0.h),
                child: Image.asset(
                  'asset/appLogo.png',
                  height: 119.0.h,
                  width: 170.0.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Container(
                  // height: 49.h,
                  margin: EdgeInsets.only(top: 17.h),
                  decoration: BoxDecoration(
                      color: isDarkMode()
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10.h),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode()
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5.w, -5.h),
                        ),
                        BoxShadow(
                          color: isDarkMode()
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5.w, 5.h),
                        ),
                      ]),
                  child: GestureDetector(
                    key: Key('clickOnOldPassword'),
                    onTap: () {
                      // errorPaswd = false;
                      oldPasswordFocusNode.requestFocus();
                      // openKeyboardUserId = false;
                      openKeyboardOldPassword = true;
                      openKeyboardNewPassword = false;
                      _newTextEditingController.text != ''
                          ? validatePasswordOnPressed(
                              _newTextEditingController.text)
                          : null;
                      setState(() {});
                    },
                    child: Container(
                      // height: 49.h,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      decoration: openKeyboardOldPassword
                          ? ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.h)),
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
                                  BorderRadius.all(Radius.circular(10.h)),
                              color: isDarkMode()
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
                              ignoring: openKeyboardOldPassword ? false : true,
                              child: TextFormField(
                                autofocus: openKeyboardOldPassword,
                                // autovalidate: autoValidate,
                                focusNode: oldPasswordFocusNode,
                                controller: _oldTextEditingController,
                                style: TextStyle(fontSize: 16.0),
                                obscureText: obscureNew,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: errorOldPassword
                                        ? StringLocalization.of(context)
                                            .getText(StringLocalization
                                                .emptyPassword)
                                        : StringLocalization.of(context)
                                            .getText(
                                                StringLocalization.oldPassword),
                                    hintStyle: TextStyle(
                                        color: errorOldPassword
                                            ? HexColor.fromHex('FF6259')
                                            : HexColor.fromHex('7F8D8C'))),
                                onFieldSubmitted: (value) {
                                  openKeyboardOldPassword = false;
                                  openKeyboardNewPassword = false;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            key: Key('clickONEyeIconOld'),
                            icon: Image.asset(
                              !obscureNew
                                  ? 'asset/view_icon_grn.png'
                                  : 'asset/view_off_icon_grn.png',
                              height: 25.w,
                              width: 25.w,
                            ),
                            onPressed: () {
                              obscureNew = !obscureNew;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Container(
                  // height: 49.h,
                  margin: EdgeInsets.only(top: 17.h),
                  decoration: BoxDecoration(
                      color: isDarkMode()
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10.h),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode()
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5.w, -5.h),
                        ),
                        BoxShadow(
                          color: isDarkMode()
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5.w, 5.h),
                        ),
                      ]),
                  child: GestureDetector(
                    key: Key('clickOnNewPassword'),
                    onTap: () {
                      isFirstTimePassword = false;
                      errorNewPassword = false;
                      newPasswordFocusNode.requestFocus();
                      openKeyboardNewPassword = true;
                      openKeyboardOldPassword = false;
                      openKeyboardConfirmPassword = false;
                      setState(() {});
                    },
                    child: Container(
                      // height: 49.h,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      decoration: openKeyboardNewPassword
                          ? ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.h)),
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
                                  BorderRadius.all(Radius.circular(10.h)),
                              color: isDarkMode()
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
                              ignoring: openKeyboardNewPassword ? false : true,
                              child: TextFormField(
                                autofocus: openKeyboardNewPassword,
                                // autovalidate: autoValidate,
                                focusNode: newPasswordFocusNode,
                                controller: _newTextEditingController,
                                style: TextStyle(fontSize: 16.0),
                                obscureText: obscureOld,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: errorNewPassword
                                        ? StringLocalization.of(context)
                                            .getText(StringLocalization
                                                .emptyPassword)
                                        : StringLocalization.of(context)
                                            .getText(StringLocalization
                                                .hintForNewPassword),
                                    hintStyle: TextStyle(
                                        color: errorNewPassword
                                            ? HexColor.fromHex('FF6259')
                                            : HexColor.fromHex('7F8D8C'))),
                                onFieldSubmitted: (value) {
                                  openKeyboardNewPassword = false;
                                  openKeyboardOldPassword = false;
                                  setState(() {});
                                },
                                onChanged: validatePasswordOnPressed,
                              ),
                            ),
                          ),
                          IconButton(
                            key: Key('clickOnEyeIconNewPassword'),
                            icon: Image.asset(
                              !obscureOld
                                  ? 'asset/view_icon_grn.png'
                                  : 'asset/view_off_icon_grn.png',
                              height: 25.w,
                              width: 25.w,
                            ),
                            onPressed: () {
                              obscureOld = !obscureOld;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // errorNewPassword ? Container(
              //   padding: EdgeInsets.only(top: 5.h),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Icon(
              //         Icons.error,
              //         color: HexColor.fromHex("#FF6259"),
              //         size: 15.h,
              //       ),
              //       SizedBox(width: 2.w),
              //       Flexible(
              //         child: Text(
              //           apiErrorMsgPassword,
              //           style: TextStyle(
              //             fontSize: 12.sp,
              //             color: HexColor.fromHex("#FF6259"),
              //           ),
              //           softWrap: true,
              //         ),
              //       ),
              //     ],
              //   ),
              // ) : Container(),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Container(
                  // height: 49.h,
                  margin: EdgeInsets.only(top: 17.h),
                  decoration: BoxDecoration(
                      color: isDarkMode()
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10.h),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode()
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5.w, -5.h),
                        ),
                        BoxShadow(
                          color: isDarkMode()
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5.w, 5.h),
                        ),
                      ]),
                  child: GestureDetector(
                    key: Key('clickOnConfirmNewPassword'),
                    onTap: () {
                      errorConfirmPassword = false;
                      confirmNewPasswordNode.requestFocus();
                      openKeyboardConfirmPassword = true;
                      setState(() {});
                    },
                    child: Container(
                      // height: 49.h,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      decoration: openKeyboardConfirmPassword
                          ? ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.h)),
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
                                  BorderRadius.all(Radius.circular(10.h)),
                              color: isDarkMode()
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
                              ignoring:
                                  openKeyboardConfirmPassword ? false : true,
                              child: TextFormField(
                                autofocus: openKeyboardConfirmPassword,
                                // autovalidate: autoValidate,
                                focusNode: confirmNewPasswordNode,
                                controller: _confirmTextEditingController,
                                style: TextStyle(fontSize: 16.0),
                                obscureText: obscureConfirm,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: errorConfirmPassword
                                        ? confirmPasswordError
                                        : StringLocalization.of(context)
                                            .getText(StringLocalization
                                                .confirmNewPassword),
                                    hintStyle: TextStyle(
                                        color: errorConfirmPassword
                                            ? HexColor.fromHex('FF6259')
                                            : HexColor.fromHex('7F8D8C'))),
                                onFieldSubmitted: (value) {
                                  openKeyboardNewPassword = false;
                                  openKeyboardOldPassword = false;
                                  openKeyboardConfirmPassword = false;
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  // validatePasswordOnPressed(value);
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            key: Key('clickOnEyeIconConfirmNewPassword'),
                            icon: Image.asset(
                              !obscureConfirm
                                  ? 'asset/view_icon_grn.png'
                                  : 'asset/view_off_icon_grn.png',
                              height: 25.w,
                              width: 25.w,
                            ),
                            onPressed: () {
                              obscureConfirm = !obscureConfirm;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Container(
                    margin: EdgeInsets.only(top: 17.h),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: GestureDetector(
                      child: Container(
                        height: 40.h,
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
                                offset: Offset(-5.w, -5.h),
                              ),
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
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
                            key: Key('clickOnChangePasswordButton'),
                            child: Text(
                              StringLocalization.of(context)
                                  .getText(StringLocalization.changePassword)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: validateAndCallApi,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateAndCallApi() async {
    oldPasswordFocusNode.unfocus();
    newPasswordFocusNode.unfocus();
    confirmNewPasswordNode.unfocus();
    openKeyboardNewPassword = false;
    openKeyboardOldPassword = false;
    openKeyboardConfirmPassword = false;
    setState(() {});
    var validate = true;
    var oldPasswordStringMatch = false;
    if (_oldTextEditingController != null &&
        _oldTextEditingController.text == '') {
      errorOldPassword = true;
      validate = false;
    }
    if (_oldTextEditingController.text != null) {
      var oldPassword = '';
      preferences ??= await SharedPreferences.getInstance();
      oldPassword = Constants.deCryptStr(
          preferences?.getString(Constants.prefUserPasswordKey) ?? '')!;
      if (_oldTextEditingController.text != oldPassword) {
        if (_oldTextEditingController.text.isNotEmpty &&
            _newTextEditingController.text.isNotEmpty &&
            _confirmTextEditingController.text.isNotEmpty) {
          CustomSnackBar.buildSnackbar(
              context,
              StringLocalization.of(context)
                  .getText(StringLocalization.oldPasswordDoesNotMatch),
              3);
        }
        oldPasswordStringMatch = false;
        errorOldPassword = true;
        validate = false;
      } else {
        oldPasswordStringMatch = true;
      }
    }
    if (_newTextEditingController.text == '') {
      errorNewPassword = true;
      validate = false;
    }
    if (_newTextEditingController.text == _oldTextEditingController.text) {
      if (oldPasswordStringMatch) {
        CustomSnackBar.buildSnackbar(
            context,
            StringLocalization.of(context)
                .getText(StringLocalization.oldNewPassword),
            3);
      }
      validate = false;
      errorNewPassword = true;
    }
    if (_confirmTextEditingController.text == '') {
      confirmPasswordError = StringLocalization.of(context)
          .getText(StringLocalization.emptyConfirmPassword);
      errorConfirmPassword = true;
      validate = false;
    }
    if (_confirmTextEditingController.text != _newTextEditingController.text) {
      _confirmTextEditingController.text = '';
      confirmPasswordError = StringLocalization.of(context)
          .getText(StringLocalization.passwordMismatch);
      errorConfirmPassword = true;
      validate = false;
    }
    if (errorNewPassword) {
      validate = false;
    }
    if (validate) {
      confirmPasswordError = '';
      errorNewPassword = false;
      errorOldPassword = false;
      errorConfirmPassword = false;
      callApi();
    } else {
      setState(() {});
    }
  }

  Future callApi() async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      Constants.progressDialog(true, context);
      var data = {
        'UserId': globalUser?.userId,
        'OldPassword': _oldTextEditingController.text,
        'NewPassword': _newTextEditingController.text,
      };
      final changePasswordByUserIdResult = await UserRepository()
          .changePasswordByUserID(globalUser!.userId!,
              _oldTextEditingController.text, _newTextEditingController.text);
      if (changePasswordByUserIdResult.hasData) {
        if (changePasswordByUserIdResult.getData!.result!) {
          Constants.progressDialog(false, context);
          CustomSnackBar.buildSnackbar(
              context,
              stringLocalization
                  .getText(StringLocalization.passwordChangedSuccessfully),
              3);
          preferences?.setString(Constants.prefUserPasswordKey,
              Constants.encryptStr(_newTextEditingController.text));
          Navigator.of(context).pop();
        } else {
          Constants.progressDialog(false, context);
          oldPasswordFocusNode.unfocus();
          newPasswordFocusNode.unfocus();
          openKeyboardNewPassword = false;
          openKeyboardOldPassword = false;
          CustomSnackBar.buildSnackbar(
              context, changePasswordByUserIdResult.getData!.message!, 3);
        }
      } else {
        Constants.progressDialog(false, context);
        oldPasswordFocusNode.unfocus();
        newPasswordFocusNode.unfocus();
        openKeyboardNewPassword = false;
        openKeyboardOldPassword = false;
        CustomSnackBar.buildSnackbar(context, 'Something went wrong!!', 3);
      }
      // ChangePasswordByUserID?UserId=${globalUser.userId}&OldPassword=${_oldTextEditingController.text}&NewPassword=${_newTextEditingController.text}
      // ResetPassword? result = await ChangePassword().callApi(
      //     Constants.baseUrl +
      //         "ChangePasswordByUserID?UserId=${globalUser?.userId!}&OldPassword=${_oldTextEditingController.text}&NewPassword=${_newTextEditingController.text}",
      //     "");
      // Constants.progressDialog(false, context);
      // if (result?.result ?? false) {
      //   CustomSnackBar.buildSnackbar(
      //       context,
      //       stringLocalization
      //           .getText(StringLocalization.passwordChangedSuccessfully),
      //       3);
      //   preferences?.setString(Constants.prefUserPasswordKey,
      //       Constants.encryptStr(_newTextEditingController.text));
      //   Navigator.of(context).pop();
      // } else {
      //   oldPasswordFocusNode.unfocus();
      //   newPasswordFocusNode.unfocus();
      //   openKeyboardNewPassword = false;
      //   openKeyboardOldPassword = false;
      //   CustomSnackBar.buildSnackbar(context, result!.message!, 3);
      // }
    } else {
      CustomSnackBar.buildSnackbar(
          context,
          StringLocalization.of(context)
              .getText(StringLocalization.enableInternet),
          3);
    }
    setState(() {});
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

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength =
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
      errorNewPassword = false;
      apiErrorMsgPassword =
          stringLocalization.getText(StringLocalization.emptyPassword);
    } else {
      errorNewPassword = true;
      apiErrorMsgPassword =
          stringLocalization.getText(StringLocalization.emptyPassword);
    }

    setState(() {});
    // return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
  }

  void validatePasswordOnPressed(String value) {
    isPasswordCompliant(value);
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_^]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
