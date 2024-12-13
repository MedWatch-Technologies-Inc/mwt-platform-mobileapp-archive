import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/apis/confirm_user_api.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/auth/auth_repository.dart';
import 'package:health_gauge/repository/auth/request/user_registration_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/SignUp/HelperWidgets/gender_radio.dart';
import 'package:health_gauge/screens/SignUp/app_gender.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/screens/terms_&_condition.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomCalendar/date_picker_dialog.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_toggle_container.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../disclaimer_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String token;
  final String versionName;

  SignUpScreen({required this.token, required this.versionName});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// validate form by key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// get value from controller
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userIDController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController confirmUserController = TextEditingController();
  TextEditingController studyCodeController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController feetController = TextEditingController();
  TextEditingController inchController = TextEditingController();

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// set focus next by key
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode userIDFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode emailAddressFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode confirmUserFocusNode = FocusNode();
  FocusNode studyCodeFocusNode = FocusNode();
  FocusNode heightNode = FocusNode();
  FocusNode weightNode = FocusNode();
  FocusNode feetNode = FocusNode();
  FocusNode inchNode = FocusNode();

  bool openKeyboardFirstName = false;
  bool openKeyboardLastName = false;
  bool openKeyboardUserId = false;
  bool openKeyboardPhoneNo = false;
  bool openKeyboardEmail = false;
  bool openKeyboardPaswd = false;
  bool openKeyboardConfirmPaswd = false;
  bool openKeyboardHeight = false;
  bool openKeyboardWeight = false;
  bool openKeyboardBirthday = false;
  bool openKeyboardStudyCode = false;
  bool openKeyboardFeet = false;
  bool openKeyboardInch = false;
  bool readTermsAndCondition = false;
  bool readDisclaimer = false;

  String errorMessageForFirstName = '';
  String errorMessageForLastName = '';
  String errorMessageForUserId = '';
  String errorMessageForEmail = '';
  String errorMessageForBirthDate = '';

  //String errorMessageForPhone = '';
  String errorMessageForPassword = '';
  String errorMessageForConfirmPassword = '';
  String errorWeight = '';
  String errorHeight = '';
  String errorFeet = '';
  String errorInch = '';

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// validate automatically

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// scaffold key used to display snack bar message
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool agreeTermsAndCondition = false;
  bool agreeDisclaimer = false;
  int pageIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// handle local database methods
  SharedPreferences? sharedPreferences;

  DateTime selectedDate = DateTime(1990, 1);

  bool apiErrorLastName = false;
  bool apiErrorFirstName = false;
  bool apiErrorPassword = false;
  bool error8To20Character = false;
  bool mustContainOneUppercase = false;
  bool mustContainOneLowercase = false;
  bool mustContainOneSpecialCharacter = false;
  bool mustContainOneNumber = false;
  bool errorInHeight = false;
  bool errorInWeight = false;
  String errorMessageHeight = '';
  String errorMessageWeight = '';
  String apiErrorMsgLastName = '';
  String apiErrorMsgFirstName = '';
  String apiErrorMsgPassword = '';
  String messageLengthPassword = stringLocalization.getText(StringLocalization.min8toMax20);

  // 'Must be minimum 8 to maximum 20 characters long';
  String messageUppercasePassword = stringLocalization.getText(StringLocalization.oneUppercase);

  // 'Must contain at least one uppercase letter';
  String messageLowercasePassword = stringLocalization.getText(StringLocalization.oneLowercase);

  // 'Must contain at least one lowercase letter';
  String messageSpecialPassword =
      stringLocalization.getText(StringLocalization.oneSpecialCharacter);

  // 'Must contain at least one special character';
  String messageNumberPassword = stringLocalization.getText(StringLocalization.oneNumber);

  // = 'Must contain at least one number';
  bool isFirstTimeFN = true;
  bool isFirstTimeSN = true;
  bool isFirstTimePassword = true;
  bool obscureText = true;
  bool obscureTextConfirm = true;

  bool errorConfirmUser = false;
  bool openKeyboardConfirmUser = false;
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('1');

  var _weightUnit = 0;
  var _heightUnit = 0;

  OverlayEntry? entry;
  ScrollController scrollController = ScrollController();

  ValueNotifier<AppGender?> selectedGender = ValueNotifier<AppGender?>(null);
  ValueNotifier<bool> genderError = ValueNotifier<bool>(false);

  final List<AppGender> genderItems = [
    AppGender(title: 'Male', value: 1, icon: 'asset/3.0x/male_gender.png'),
    AppGender(title: 'Female', value: 2, icon: 'asset/3.0x/female_gender.png'),
    AppGender(title: 'Others', value: 3, icon: 'asset/3.0x/other_gender.png'),
  ];

  String get requestGender {
    switch (selectedGender.value?.value) {
      case 1:
        return 'M';
      case 2:
        return 'F';
      case 3:
        return 'O';
      default:
        return 'U';
    }
  }

  @override
  void initState() {
    /// Added by: chandresh
    /// Added at: 02-06-2020
    /// set portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    getPref();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    userIDController.dispose();
    phoneNumberController.dispose();
    studyCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(BoxConstraints(),orientation: Orientation.portrait,
    //    designSize:  Size( 375.0,  812.0));

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          key: Key('backButton'),
          padding: EdgeInsets.only(left: 10.h),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Theme.of(context).brightness == Brightness.dark
              ? Image.asset(
                  'asset/dark_leftArrow.png',
                  width: 13.w,
                  height: 22.h,
                )
              : Image.asset(
                  'asset/leftArrow.png',
                  width: 13.w,
                  height: 22.h,
                ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      bottomNavigationBar: Container(
        height: 88.h,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex("#111B1A")
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
                      text:
                          StringLocalization.of(context).getText(StringLocalization.privacyPolicy),
                      fontSize: 16.sp,
                      color: AppColor.color00AFAA,
                      decoration: TextDecoration.underline,
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
                    color: AppColor.color00AFAA,
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
                      text:
                          StringLocalization.of(context).getText(StringLocalization.termsOfService),
                      fontSize: 16.sp,
                      color: HexColor.fromHex('#00AFAA'),
                      decoration: TextDecoration.underline,
                      maxLine: 1,
                      minFontSize: 8,
                    ),
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
      body: SafeArea(child: layoutMain()),
    );
  }

  Widget version() {
    return Container(
      height: 17.h,
      child: Body1AutoText(
        text:
            '${StringLocalization.of(context).getText(StringLocalization.version)}${' : ${widget.versionName}'}',
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
      color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            logoImageLayout(),
            Container(
              height: 450.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 9,
                itemBuilder: (context, index) {
                  return pageItems(index);
                },
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
//                  textFields(),
            // studyCode(),
//            SizedBox(height: 20.h),
//            termsAndCondition(),
//            disclaimer(),
//            SizedBox(height: 8.0.h),
          ],
        ),
      ),
    );
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: AppColor.primaryColor),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: AppColor.primaryColor,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) => setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('CA'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0.w),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0.w),
          Flexible(child: Text(country.name))
        ],
      );

  Widget pageItems(int index) {
    switch (index) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpFirstNameContainer'),
                onTap: () {
                  firstNameFocusNode.requestFocus();
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = true;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = false;
                  openKeyboardBirthday = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardFirstName
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'asset/profile_icon_red.png',
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: openKeyboardFirstName ? false : true,
                          child: TextFormField(
                            key: Key('signUpFirstName'),
                            focusNode: firstNameFocusNode,
                            controller: firstNameController,
                            style: TextStyle(fontSize: 16.0),
                            autofocus: openKeyboardFirstName,
                            decoration: InputDecoration(
                              // contentPadding: EdgeInsets.only(bottom: 5.h),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: errorMessageForFirstName.isNotEmpty
                                  ? errorMessageForFirstName
                                  : StringLocalization.of(context)
                                          .getText(StringLocalization.hintForFirstName) +
                                      '*',
                              hintStyle: TextStyle(
                                color: errorMessageForFirstName.isNotEmpty
                                    ? HexColor.fromHex('FF6259')
                                    : HexColor.fromHex('7F8D8C'),
                                fontSize: 16.sp,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                              FilteringTextInputFormatter(RegExp('[a-zA-Z ]'), allow: true),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            onFieldSubmitted: (_) {
                              validateNameOnPressed(firstNameController.text);
                              FocusScope.of(context).requestFocus(lastNameFocusNode);
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = true;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
                              setState(() {});
                            },
                            onChanged: validateNameOnPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            apiErrorFirstName
                ? showApiError(apiErrorMsgFirstName, isError: apiErrorFirstName)
                : Container(),
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 17.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpLastNameContainer'),
                onTap: () {
                  validateLastNameOnPressed(lastNameController.text);
                  if (isFirstTimeFN) {
                    isFirstTimeFN = false;
                  } else {
                    validateNameOnPressed(firstNameController.text);
                  }
                  lastNameFocusNode.requestFocus();
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = true;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = false;
                  openKeyboardBirthday = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardLastName
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'asset/profile_icon_red.png',
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: openKeyboardLastName ? false : true,
                          child: TextFormField(
                            key: Key('signUpLastName'),
                            focusNode: lastNameFocusNode,
                            controller: lastNameController,
                            inputFormatters: [
                              FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                              FilteringTextInputFormatter(RegExp('[a-zA-Z ]'), allow: true),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            autofocus: openKeyboardLastName,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: errorMessageForLastName.isNotEmpty
                                    ? errorMessageForLastName
                                    : StringLocalization.of(context)
                                            .getText(StringLocalization.hintForLastName) +
                                        '*',
                                hintStyle: TextStyle(
                                  color: errorMessageForLastName.isNotEmpty
                                      ? HexColor.fromHex('FF6259')
                                      : HexColor.fromHex('7F8D8C'),
                                  fontSize: 16.sp,
                                )),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              validateNameOnPressed(firstNameController.text);
                              validateLastNameOnPressed(lastNameController.text);
                              openKeyboardUserId = true;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
                              setState(() {});
                            },
                            onChanged: validateLastNameOnPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            apiErrorLastName
                ? showApiError(apiErrorMsgLastName, isError: apiErrorLastName)
                : Container(),
            ValueListenableBuilder(
              valueListenable: genderError,
              builder: (BuildContext context, bool value, Widget? child) {
                return Container(
                  height: 50.h,
                  margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 17.h),
                  decoration: BoxDecoration(
                    color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                    border: Border.all(
                      width: 1,
                      color: genderError.value
                          ? HexColor.fromHex('FF6259')
                          : isDarkMode()
                              ? HexColor.fromHex('#111B1A')
                              : AppColor.backgroundColor,
                    ),
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
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ValueListenableBuilder(
                      builder: (BuildContext context, value, Widget? child) {
                        return DropdownButtonFormField2(
                          isExpanded: true,
                          value: selectedGender.value,
                          onChanged: (value) {
                            genderError.value = false;
                            selectedGender.value = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_drop_down_rounded,
                              ),
                            ),
                          ),
                          hint: GenderRadio(
                            value: -1,
                            title: 'Gender',
                            iconAsset: 'asset/3.0x/hint_gender.png',
                            selectedValue: -2,
                          ),
                          items: genderItems
                              .map(
                                (AppGender item) => DropdownMenuItem<AppGender>(
                                  value: item,
                                  child: GenderRadio(
                                    value: item.value,
                                    title: item.title,
                                    iconAsset: item.icon,
                                    selectedValue: selectedGender.value?.value ?? -2,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                      valueListenable: selectedGender,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpUserId'),
                onTap: () {
                  userIDFocusNode.requestFocus();
                  openKeyboardUserId = true;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = false;
                  openKeyboardBirthday = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardUserId
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                            focusNode: userIDFocusNode,
                            controller: userIDController,
                            autofocus: openKeyboardUserId,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: errorMessageForUserId.isNotEmpty
                                    ? errorMessageForUserId
                                    : StringLocalization.of(context)
                                            .getText(StringLocalization.hintForUserId) +
                                        '*',
                                hintStyle: TextStyle(
                                    color: errorMessageForUserId.isNotEmpty
                                        ? HexColor.fromHex('FF6259')
                                        : HexColor.fromHex('7F8D8C'),
                                    fontSize: 16.sp)),
                            inputFormatters: [
                              FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                              FilteringTextInputFormatter(RegExp('[a-zA-Z0-9.]'), allow: true),
                              LengthLimitingTextInputFormatter(30),
                            ],
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(emailAddressFocusNode);
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = true;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
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
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 2:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                onTap: () {
                  openKeyboardBirthday = true;
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardBirthday
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'asset/birthday_icon.png',
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: GestureDetector(
                          key: Key('signUpDateofBirthContainer'),
                          onTap: () async {
                            var date = await showCustomDatePicker(
                                  context: context,
                                  initialDate: selectedDate.isAfter(DateTime.now())
                                      ? DateTime.now()
                                      : selectedDate,
                                  firstDate: DateTime(1920, 1),
                                  lastDate: DateTime.now().subtract(Duration(days: 365 * 5)),
                                  fieldHintText:
                                      stringLocalization.getText(StringLocalization.enterDate),
                                  getDatabaseDataFrom: '',
                                ) ??
                                DateTime.now();
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                                birthDateController.text =
                                    DateFormat(DateUtil.ddMMyyyyDashed).format(date);
                              });
                            }
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: birthDateController,
                            autofocus: false,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: errorMessageForBirthDate.isNotEmpty
                                    ? errorMessageForBirthDate
                                    : StringLocalization.of(context)
                                            .getText(StringLocalization.hintForBirthDate) +
                                        '*',
                                hintStyle: TextStyle(
                                    color: errorMessageForBirthDate.isNotEmpty
                                        ? HexColor.fromHex('FF6259')
                                        : HexColor.fromHex('7F8D8C'),
                                    fontSize: 16.sp),
                                suffixIcon: Image.asset(
                                  'asset/calendar_button.png',
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  maxHeight: 33.h,
                                  maxWidth: 33.h,
                                  minHeight: 33.h,
                                  minWidth: 33.h,
                                )),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(emailAddressFocusNode);
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = true;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
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
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 3:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    // height: 49.h,
                    margin: EdgeInsets.only(left: 33.w, right: 20.w, top: 15.h),
                    decoration: BoxDecoration(
                        color:
                            isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                      onTap: () {
                        weightNode.requestFocus();
                        validateWeightOnPressed(weightController.text);
                        openKeyboardWeight = true;
                        openKeyboardUserId = false;
                        openKeyboardConfirmPaswd = false;
                        openKeyboardEmail = false;
                        openKeyboardFirstName = false;
                        openKeyboardLastName = false;
                        openKeyboardPaswd = false;
                        openKeyboardPhoneNo = false;
                        openKeyboardBirthday = false;
                        openKeyboardFeet = false;
                        openKeyboardInch = false;
                        setState(() {});
                      },
                      child: Container(
                        key: Key('weightTextContainer'),
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        decoration: openKeyboardWeight
                            ? ConcaveDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.h)),
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
                                borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                color: isDarkMode()
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                              ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'asset/weight_33_red.png',
                              height: 33.w,
                              width: 33.w,
                            ),
                            SizedBox(width: 10.0.w),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: openKeyboardWeight ? false : true,
                                child: TextFormField(
                                  focusNode: weightNode,
                                  controller: weightController,
                                  autofocus: openKeyboardWeight,
                                  style: TextStyle(fontSize: 16.0),
                                  decoration: InputDecoration(
                                      // contentPadding: EdgeInsets.only(bottom: 5.h),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: errorWeight.isNotEmpty
                                          ? errorWeight
                                          : stringLocalization.getText(StringLocalization.weight) +
                                              '*',
                                      hintStyle: TextStyle(
                                          color: errorWeight.isNotEmpty
                                              ? HexColor.fromHex('FF6259')
                                              : HexColor.fromHex('7F8D8C'),
                                          fontSize: 16.sp)),
                                  inputFormatters: [
                                    FilteringTextInputFormatter(RegExp('[a-zA-Z]'), allow: false),
                                    FilteringTextInputFormatter(RegExp('[\\-|\\ ,|.]'),
                                        allow: false),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    validateWeightOnPressed(weightController.text);
                                  },
                                  onFieldSubmitted: (_) {
                                    // FocusScope.of(context)
                                    //     .requestFocus(emailAddressFocusNode);
                                    openKeyboardUserId = false;
                                    openKeyboardConfirmPaswd = false;
                                    openKeyboardEmail = false;
                                    openKeyboardFirstName = false;
                                    openKeyboardLastName = false;
                                    openKeyboardPaswd = false;
                                    openKeyboardPhoneNo = false;
                                    openKeyboardBirthday = false;
                                    openKeyboardFeet = false;
                                    openKeyboardInch = false;
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
                ),
                Container(
                  height: 55.h,
                  margin: EdgeInsets.only(right: 33.w, top: 15.h),
                  child: CustomToggleContainer(
                      selectedUnit: _weightUnit,
                      unitText1: stringLocalization.getText(StringLocalization.kg),
                      unitText2: stringLocalization.getText(StringLocalization.lb),
                      unit1Selected: () {
                        if (_weightUnit != 0) {
                          _weightUnit = 0;
                          errorWeight = '';
                          errorInWeight = false;
                          weightController.text = '';
                          setState(() {});
                        }
                      },
                      unit2Selected: () {
                        if (_weightUnit != 1) {
                          _weightUnit = 1;
                          errorWeight = '';
                          errorInWeight = false;
                          weightController.text = '';
                          setState(() {});
                        }
                      },
                      width: 80.w),
                ),
              ],
            ),
            errorInWeight ? showApiError(errorMessageWeight, isError: errorInWeight) : Container(),
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 4:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _heightUnit == 1
                    ? Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 33.w, right: 15.w, top: 15.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
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
                                    onTap: () {
                                      feetNode.requestFocus();
                                      // validateHeightOnPressed(feetController.text);
                                      openKeyboardFeet = true;
                                      openKeyboardHeight = false;
                                      openKeyboardWeight = false;
                                      openKeyboardUserId = false;
                                      openKeyboardConfirmPaswd = false;
                                      openKeyboardEmail = false;
                                      openKeyboardFirstName = false;
                                      openKeyboardLastName = false;
                                      openKeyboardPaswd = false;
                                      openKeyboardPhoneNo = false;
                                      openKeyboardBirthday = false;
                                      openKeyboardInch = false;
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                      decoration: openKeyboardFeet
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
                                              borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                              color: isDarkMode()
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                            ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'asset/height_33_red.png',
                                            height: 33.w,
                                            width: 33.w,
                                          ),
                                          SizedBox(width: 5.0.w),
                                          Container(
                                            width: 35.w,
                                            child: IgnorePointer(
                                              ignoring: openKeyboardFeet ? false : true,
                                              child: TextFormField(
                                                focusNode: feetNode,
                                                controller: feetController,
                                                autofocus: openKeyboardFeet,
                                                style: TextStyle(fontSize: 16.0),
                                                decoration: InputDecoration(
                                                    // contentPadding: EdgeInsets.only(bottom: 5.h),
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    hintText: errorFeet.isNotEmpty
                                                        ? errorFeet
                                                        : stringLocalization
                                                                .getText(StringLocalization.feet) +
                                                            '*',
                                                    hintStyle: TextStyle(
                                                        color: errorFeet.isNotEmpty
                                                            ? HexColor.fromHex('FF6259')
                                                            : HexColor.fromHex('7F8D8C'),
                                                        fontSize: 16.sp)),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter(RegExp('[a-zA-Z0]'),
                                                      allow: false),
                                                  FilteringTextInputFormatter(
                                                      RegExp('[\\-|\\ ,|.]'),
                                                      allow: false),
                                                  LengthLimitingTextInputFormatter(1),
                                                ],
                                                keyboardType: TextInputType.number,
                                                textInputAction: TextInputAction.next,
                                                onChanged: (value) {
                                                  validateHeightOnPressed(feetController.text);
                                                },
                                                onFieldSubmitted: (_) {
                                                  openKeyboardUserId = false;
                                                  openKeyboardConfirmPaswd = false;
                                                  openKeyboardEmail = false;
                                                  openKeyboardFirstName = false;
                                                  openKeyboardLastName = false;
                                                  openKeyboardPaswd = false;
                                                  openKeyboardPhoneNo = false;
                                                  openKeyboardBirthday = false;
                                                  openKeyboardHeight = false;
                                                  openKeyboardInch = false;
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
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15.w),
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
                                    onTap: () {
                                      inchNode.requestFocus();
                                      // validateHeightOnPressed(inchController.text);
                                      openKeyboardInch = true;
                                      openKeyboardHeight = false;
                                      openKeyboardWeight = false;
                                      openKeyboardUserId = false;
                                      openKeyboardConfirmPaswd = false;
                                      openKeyboardEmail = false;
                                      openKeyboardFirstName = false;
                                      openKeyboardLastName = false;
                                      openKeyboardPaswd = false;
                                      openKeyboardPhoneNo = false;
                                      openKeyboardBirthday = false;
                                      openKeyboardFeet = false;
                                      setState(() {});
                                    },
                                    child: Container(
                                      key: Key('heightTextContainer'),
                                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                      decoration: openKeyboardInch
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
                                              borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                              color: isDarkMode()
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                            ),
                                      child: Container(
                                        width: 50.w,
                                        child: IgnorePointer(
                                          ignoring: openKeyboardInch ? false : true,
                                          child: TextFormField(
                                            focusNode: inchNode,
                                            controller: inchController,
                                            autofocus: openKeyboardInch,
                                            style: TextStyle(fontSize: 16.0),
                                            decoration: InputDecoration(
                                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder.none,
                                                hintText: errorInch.isNotEmpty
                                                    ? errorInch
                                                    : stringLocalization
                                                            .getText(StringLocalization.inch) +
                                                        '*',
                                                hintStyle: TextStyle(
                                                    color: errorInch.isNotEmpty
                                                        ? HexColor.fromHex('FF6259')
                                                        : HexColor.fromHex('7F8D8C'),
                                                    fontSize: 16.sp)),
                                            inputFormatters: [
                                              FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
                                                  allow: false),
                                              FilteringTextInputFormatter(RegExp('[\\-|\\ ,|.]'),
                                                  allow: false),
                                              LengthLimitingTextInputFormatter(2),
                                            ],
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.next,
                                            onChanged: (value) {
                                              validateHeightOnPressed(inchController.text);
                                            },
                                            onFieldSubmitted: (_) {
                                              openKeyboardUserId = false;
                                              openKeyboardConfirmPaswd = false;
                                              openKeyboardEmail = false;
                                              openKeyboardFirstName = false;
                                              openKeyboardLastName = false;
                                              openKeyboardPaswd = false;
                                              openKeyboardPhoneNo = false;
                                              openKeyboardBirthday = false;
                                              openKeyboardFeet = false;
                                              openKeyboardHeight = false;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          // height: 49.h,
                          margin: EdgeInsets.only(left: 33.w, right: 20.w, top: 15.h),
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
                            onTap: () {
                              heightNode.requestFocus();
                              // validateHeightOnPressed(heightController.text);
                              openKeyboardHeight = true;
                              openKeyboardWeight = false;
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              setState(() {});
                            },
                            child: Container(
                              key: Key('heightTextContainer'),
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              decoration: openKeyboardHeight
                                  ? ConcaveDecoration(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.h)),
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
                                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                                      color: isDarkMode()
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                    ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'asset/height_33_red.png',
                                    height: 33.w,
                                    width: 33.w,
                                  ),
                                  SizedBox(width: 10.0.w),
                                  Expanded(
                                    child: IgnorePointer(
                                      ignoring: openKeyboardHeight ? false : true,
                                      child: TextFormField(
                                        focusNode: heightNode,
                                        controller: heightController,
                                        autofocus: openKeyboardHeight,
                                        style: TextStyle(fontSize: 16.0),
                                        decoration: InputDecoration(
                                            // contentPadding: EdgeInsets.only(bottom: 5.h),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: errorHeight.isNotEmpty
                                                ? errorHeight
                                                : stringLocalization
                                                        .getText(StringLocalization.height) +
                                                    '*',
                                            hintStyle: TextStyle(
                                                color: errorHeight.isNotEmpty
                                                    ? HexColor.fromHex('FF6259')
                                                    : HexColor.fromHex('7F8D8C'),
                                                fontSize: 16.sp)),
                                        inputFormatters: [
                                          FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
                                              allow: false),
                                          FilteringTextInputFormatter(RegExp('[\\-|\\ ,|.]'),
                                              allow: false),
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (value) {
                                          validateHeightOnPressed(heightController.text);
                                        },
                                        onFieldSubmitted: (_) {
                                          openKeyboardUserId = false;
                                          openKeyboardConfirmPaswd = false;
                                          openKeyboardEmail = false;
                                          openKeyboardFirstName = false;
                                          openKeyboardLastName = false;
                                          openKeyboardPaswd = false;
                                          openKeyboardPhoneNo = false;
                                          openKeyboardBirthday = false;
                                          openKeyboardFeet = false;
                                          openKeyboardInch = false;
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
                      ),
                Container(
                  height: 55.h,
                  margin: EdgeInsets.only(right: 33.w, top: 15.h),
                  child: CustomToggleContainer(
                      selectedUnit: _heightUnit,
                      unitText1: stringLocalization.getText(StringLocalization.cmShort),
                      unitText2: stringLocalization.getText(StringLocalization.feetShort),
                      unit1Selected: () {
                        if (_heightUnit != 0) {
                          _heightUnit = 0;
                          errorHeight = '';
                          errorInHeight = false;
                          heightController.text = '';
                          feetController.text = '';
                          inchController.text = '';
                          setState(() {});
                        }
                      },
                      unit2Selected: () {
                        if (_heightUnit != 1) {
                          _heightUnit = 1;
                          errorHeight = '';
                          errorInHeight = false;
                          heightController.text = '';
                          feetController.text = '';
                          inchController.text = '';
                          setState(() {});
                        }
                      },
                      width: 80.w),
                )
              ],
            ),
            errorInHeight ? showApiError(errorMessageHeight, isError: errorInHeight) : Container(),
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 5:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpEmailContainer'),
                onTap: () {
                  emailAddressFocusNode.requestFocus();
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = true;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = false;
                  openKeyboardBirthday = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardEmail
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'asset/email_icon_red.png',
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: openKeyboardEmail ? false : true,
                          child: TextFormField(
                            focusNode: emailAddressFocusNode,
                            controller: emailAddressController,
                            autofocus: openKeyboardEmail,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: errorMessageForEmail.isNotEmpty
                                    ? errorMessageForEmail
                                    : StringLocalization.of(context)
                                            .getText(StringLocalization.hintForEmail) +
                                        '*',
                                hintStyle: TextStyle(
                                    color: errorMessageForEmail.isNotEmpty
                                        ? HexColor.fromHex('FF6259')
                                        : HexColor.fromHex('7F8D8C'))),
                            inputFormatters: [
                              FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = true;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
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
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 6:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _openCountryPickerDialog,
              child: Container(
                margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
                child: Row(
                  children: [
                    Text('Phone Code'),
                    SizedBox(width: 25.w),
                    Flexible(child: _buildDialogItem(_selectedDialogCountry)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpPhoneContainer'),
                onTap: () {
                  phoneNumberFocusNode.requestFocus();
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = true;
                  openKeyboardBirthday = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardPhoneNo
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'asset/phone_icon_red.png',
                        height: 33.h,
                        width: 33.h,
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: openKeyboardPhoneNo ? false : true,
                          child: TextFormField(
                            focusNode: phoneNumberFocusNode,
                            controller: phoneNumberController,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp('[a-zA-Z]'), allow: false),
                              FilteringTextInputFormatter(RegExp('[\\-|\\ ,|.]'), allow: false),
                              LengthLimitingTextInputFormatter(15),
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false, signed: false),
                            autofocus: openKeyboardPhoneNo,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: StringLocalization.of(context)
                                    .getText(StringLocalization.hintForPhone),
                                hintStyle: TextStyle(color: HexColor.fromHex('7F8D8C'))),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = true;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              apiErrorPassword = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
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
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      case 7:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpPasswordContainer'),
                onTap: () {
                  isFirstTimePassword = false;
                  passwordFocusNode.requestFocus();
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = false;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = true;
                  openKeyboardPhoneNo = false;
                  openKeyboardBirthday = false;
                  apiErrorPassword = false;
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardPaswd
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'asset/lock_icon_red.png',
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: openKeyboardPaswd ? false : true,
                          child: TextFormField(
                            obscureText: obscureText,
                            focusNode: passwordFocusNode,
                            controller: passwordController,
                            autofocus: openKeyboardPaswd,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: errorMessageForPassword.isNotEmpty
                                    ? errorMessageForPassword
                                    : StringLocalization.of(context)
                                            .getText(StringLocalization.hintForPassword) +
                                        '*',
                                hintStyle: TextStyle(
                                    color: errorMessageForPassword.isNotEmpty
                                        ? HexColor.fromHex('FF6259')
                                        : HexColor.fromHex('7F8D8C'))),
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                              FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9!\"#$%&('
                                      ')*+,-./:;<=>?@[\\]^_`{|}~]'),
                                  allow: true),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              isFirstTimePassword
                                  ? null
                                  : validatePasswordOnPressed(passwordController.text);
                              FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = true;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
                              setState(() {});
                            },
                            onChanged: (value) {
                              validatePasswordOnPressed(value);
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            !isFirstTimePassword
                ? showApiError(messageLengthPassword,
                    isError: !error8To20Character, isPassword: false)
                : Container(),
            !isFirstTimePassword
                ? showApiError(messageUppercasePassword,
                    isError: !mustContainOneUppercase, isPassword: true)
                : Container(),
            !isFirstTimePassword
                ? showApiError(messageLowercasePassword,
                    isError: !mustContainOneLowercase, isPassword: true)
                : Container(),
            !isFirstTimePassword
                ? showApiError(messageSpecialPassword,
                    isError: !mustContainOneSpecialCharacter, isPassword: true)
                : Container(),
            !isFirstTimePassword
                ? showApiError(messageNumberPassword,
                    isError: !mustContainOneNumber, isPassword: true)
                : Container(),
            Container(
              // height: 49.h,
              margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
              decoration: BoxDecoration(
                  color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
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
                key: Key('signUpConfirmPasswordContainer'),
                onTap: () {
                  // isFirstTimePassword
                  //     ? null
                  //     : validatePasswordOnPressed(passwordController.text);
                  confirmPasswordFocusNode.requestFocus();
                  openKeyboardFeet = false;
                  openKeyboardInch = false;
                  openKeyboardUserId = false;
                  openKeyboardConfirmPaswd = true;
                  openKeyboardEmail = false;
                  openKeyboardFirstName = false;
                  openKeyboardLastName = false;
                  openKeyboardPaswd = false;
                  openKeyboardPhoneNo = false;
                  openKeyboardBirthday = false;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: openKeyboardConfirmPaswd
                      ? ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.h)),
                          color:
                              isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                        ),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'asset/lock_icon_red.png',
                        // height: 20.57.h,
                        // width: 18.w,
                      ),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: openKeyboardConfirmPaswd ? false : true,
                          child: TextFormField(
                            obscureText: obscureTextConfirm,
                            focusNode: confirmPasswordFocusNode,
                            controller: confirmPasswordController,
                            autofocus: openKeyboardConfirmPaswd,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 5.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: errorMessageForConfirmPassword.isNotEmpty
                                    ? errorMessageForConfirmPassword
                                    : StringLocalization.of(context)
                                        .getText(StringLocalization.hintForConfirmPassword),
                                hintStyle: TextStyle(
                                    color: errorMessageForConfirmPassword.isNotEmpty
                                        ? HexColor.fromHex('FF6259')
                                        : HexColor.fromHex('7F8D8C'))),
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                              FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9!\"#$%&('
                                      ')*+,-./:;<=>?@[\\]^_`{|}~]'),
                                  allow: true),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              isFirstTimePassword
                                  ? null
                                  : validatePasswordOnPressed(passwordController.text);
                              openKeyboardUserId = false;
                              openKeyboardConfirmPaswd = false;
                              openKeyboardEmail = false;
                              openKeyboardFirstName = false;
                              openKeyboardLastName = false;
                              openKeyboardPaswd = false;
                              openKeyboardPhoneNo = false;
                              openKeyboardBirthday = false;
                              openKeyboardFeet = false;
                              openKeyboardInch = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          !obscureTextConfirm
                              ? 'asset/view_icon_grn.png'
                              : 'asset/view_off_icon_grn.png',
                          height: 25.h,
                          width: 25.w,
                        ),
                        onPressed: () {
                          obscureTextConfirm = !obscureTextConfirm;
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
            signUpButton(),
          ],
        );
      case 8:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            termsAndCondition(),
            disclaimer(),
            SizedBox(
              height: 27.h,
            ),
            signUpButton(),
          ],
        );
      default:
        return Container();
    }
  }

  Widget disclaimer() {
    return Container(
        margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 15.h),
        child: Row(
          children: [
            customRadioDisclaimer(),
            Text(stringLocalization.getText(StringLocalization.iAcceptThe),
                style: TextStyle(
                  color: isDarkMode() ? Colors.white.withOpacity(0.9) : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Constants.navigatePush(DisclaimerScreen(), context).then((value) {
                  readDisclaimer = true;
                });
              },
              child: Padding(
                key: Key('signUpDisclaimerText'),
                padding: const EdgeInsets.all(0),
                child: Text(
                  StringLocalization.of(context).getText(StringLocalization.disclaimer),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: HexColor.fromHex('#00AFAA'),
                  ),
                ),
              ),
            ))
          ],
        ));
  }

  Widget customRadioDisclaimer() {
    return GestureDetector(
      onTap: () {
        if (readDisclaimer) {
          agreeDisclaimer = !agreeDisclaimer;
          if (this.mounted) setState(() {});
        } else {
          var dialog = CustomInfoDialog(
            title: stringLocalization.getText(StringLocalization.information),
            subTitle: stringLocalization.getText(StringLocalization.readDisclaimer),
            onClickYes: () {
              Navigator.of(context).pop();
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
                        ? Colors.white
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
                    key: Key('signUpDisclaimerRadio'),
                    margin: EdgeInsets.all(3.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: agreeDisclaimer ? HexColor.fromHex('FF6259') : Colors.transparent,
                    )),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 33.w),
      child: Row(
        children: [
          pageIndex != 0
              ? Expanded(
                  child: GestureDetector(
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.h),
                            color: HexColor.fromHex('#00AFAA'),
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
                        child: Container(
                          key: Key('signUpPrevButton'),
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
                              'PREV',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode() ? HexColor.fromHex('#111B1A') : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          pageIndex--;
                        });

                        print('Index : $pageIndex');
                        _pageController.animateToPage(pageIndex,
                            duration: Duration(milliseconds: 200), curve: Curves.linear);
                        scrollController.animateTo(0,
                            duration: Duration(milliseconds: 200), curve: Curves.linear);
                      }),
                )
              : Container(),
          pageIndex != 0
              ? SizedBox(
                  width: 20.w,
                )
              : Container(),
          Expanded(
            child: GestureDetector(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.h),
                    color: HexColor.fromHex('#00AFAA'),
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
                child: Container(
                  key: Key('signUpNextButton'),
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
                      pageIndex >= 8
                          ? StringLocalization.of(context)
                              .getText(StringLocalization.btnSignUp)
                              .toUpperCase()
                          : StringLocalization.of(context)
                              .getText(StringLocalization.next)
                              .toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode() ? HexColor.fromHex('#111B1A') : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () async {
                if (pageIndex >= 8) {
                  onClickSignUp();
                } else {
                  if (!validateTextFields(pageIndex)) {
                    var newUserIdOrEmail;
                    if (pageIndex == 1 || pageIndex == 5) {
                      newUserIdOrEmail = await alreadyExistUserIdOrEmail(pageIndex);
                      if (newUserIdOrEmail) {
                        pageIndex++;
                        print('Index : $pageIndex');
                        _pageController.animateToPage(pageIndex,
                            duration: Duration(milliseconds: 200), curve: Curves.linear);
                        scrollController.animateTo(0,
                            duration: Duration(milliseconds: 200), curve: Curves.linear);
                      }
                    } else {
                      pageIndex++;
                      print('Index : $pageIndex');
                      _pageController.animateToPage(pageIndex,
                          duration: Duration(milliseconds: 200), curve: Curves.linear);
                      scrollController.animateTo(0,
                          duration: Duration(milliseconds: 200), curve: Curves.linear);
                    }
                    setState(() {});
                  } else {
                    setState(() {});
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> alreadyExistUserIdOrEmail(int index) async {
    var isInternet = await Constants.isInternetAvailable();
    var isNewUser = false;
    if (isInternet) {
      entry = showOverlay(context);
      var result;
      if (index == 1) {
        result = await UserRepository()
            .checkDuplicateUserIDAndEmail(userIDController.text, 2); // 2 for user ID
      } else {
        result = await UserRepository()
            .checkDuplicateUserIDAndEmail(emailAddressController.text, 1); // 1 for email
      }
      if (result.hasData) {
        if (result.getData!.result) {
          errorDialog(error: result.getData!.message, title: 'Already Exist');
        } else {
          isNewUser = true;
        }
      }
    } else {
      errorDialog(
          error: StringLocalization.of(context).getText(StringLocalization.enableInternet),
          title: StringLocalization.of(context).getText(StringLocalization.error));
    }
    entry?.remove();
    entry = null;
    return isNewUser;
  }

  errorDialog({required String error, required String title}) {
    var dialog = CustomInfoDialog(
      title: title,
      subTitle: error,
      maxLine: 2,
      primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
      onClickYes: () {
        if (context != null) {
          Navigator.of(context, rootNavigator: true).pop();
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

  ///Added by: Shahzad
  ///Added on: 23/09/2021
  ///this method is used to show circular loading screen
  OverlayEntry showOverlay(BuildContext context) {
    var overlayState = Overlay.of(context);
    var overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator()),
          color: Colors.black26,
        ),
      ),
    );
    overlayState?.insert(overlayEntry);
    return overlayEntry;
  }

  bool validateTextFields(int index) {
    switch (index) {
      case 0:
        bool error = validateName();
        return error;
      case 1:
        bool error = validateUserId();
        return error;
      case 2:
        bool error = validateDob();
        return error;
      case 3:
        bool error = validateWeight();
        return error;
      case 4:
        bool error = validateHeight();
        return error;
      case 5:
        bool error = validateEmail();
        return error;
      case 7:
        bool error = validatePassword();
        return error;
      default:
        return false;
    }
  }

  bool validateName() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    bool isError = false;
    genderError.value = false;
    if (firstName.trim().isEmpty) {
      apiErrorFirstName = false;
      errorMessageForFirstName =
          StringLocalization.of(context).getText(StringLocalization.emptyFirstName);
      firstNameController.text = '';
      isError = true;
    }
    if (lastName.trim().isEmpty) {
      apiErrorLastName = false;
      errorMessageForLastName =
          StringLocalization.of(context).getText(StringLocalization.emptyLastName);
      lastNameController.text = '';
      isError = true;
    }
    if (firstName.trim().length < 2 || firstName.trim().length > 50) {
      isError = true;
    }
    if (lastName.trim().length < 2 || lastName.trim().length > 50) {
      isError = true;
    }
    if (selectedGender.value == null) {
      isError = true;
      genderError.value = true;
      selectedGender.notifyListeners();
    }
    if (apiErrorFirstName || apiErrorLastName) {
      isError = true;
    }
    return isError;
  }

  bool validateUserId() {
    String userId = userIDController.text;
    bool isError = false;
    if (userId.trim().isEmpty) {
      errorMessageForUserId =
          StringLocalization.of(context).getText(StringLocalization.emptyUserId);
      userIDController.text = '';
      isError = true;
    }
    return isError;
  }

  bool validateDob() {
    String birthDate = birthDateController.text;
    bool isError = false;
    if (birthDate.trim().isEmpty) {
      errorMessageForBirthDate =
          StringLocalization.of(context).getText(StringLocalization.emptyBirthDate);
      birthDateController.text = '';
      isError = true;
    }
    return isError;
  }

  bool validateWeight() {
    var weight = weightController.text.trim();
    var isError = false;
    if (weight.trim().isEmpty) {
      errorWeight = StringLocalization.of(context).getText(StringLocalization.emptyWeight);
      weightController.text = '';
      isError = true;
      errorInWeight = false;
    } else if (weight[0] == '0') {
      errorWeight = stringLocalization.getText(StringLocalization.enterValidWeight);
      weightController.text = '';
      isError = true;
      errorInWeight = false;
    } else {
      if (_weightUnit == 0) {
        if (double.parse(weight) >= 200) {
          errorWeight = '';
          // errorWeight = '${stringLocalization.getText(StringLocalization.maxWeightLimit)} 200 ${stringLocalization.getText(StringLocalization.kg)}';
          weightController.text = '';
          isError = true;
        }
      } else {
        // var weightValue = double.parse(weight) / 2.205;
        var weightValue = double.parse(weight) / 2.20462;
        if (weightValue >= 200) {
          errorWeight = '';
          // errorWeight = '${stringLocalization.getText(StringLocalization.maxWeightLimit)} 441 ${stringLocalization.getText(StringLocalization.lb)}';
          weightController.text = '';
          isError = true;
        }
      }
    }
    return isError;
  }

  bool validateHeight() {
    String height = heightController.text.trim();
    bool isError = false;
    if (_heightUnit == 0) {
      if (height.trim().isEmpty) {
        errorHeight = StringLocalization.of(context).getText(StringLocalization.enterHeight);
        heightController.text = '';
        isError = true;
        errorInHeight = false;
      } else if (height[0] == '0') {
        errorHeight = stringLocalization.getText(StringLocalization.enterValidHeight);
        heightController.text = '';
        errorInHeight = false;
        isError = true;
      } else if (double.parse(height) >= 241) {
        errorHeight = '';
        // errorHeight = stringLocalization.getText(StringLocalization.enterHeight);
        errorInHeight = true;
        heightController.text = '';
        isError = true;
      }
    } else {
      var heightValue = 0.0;
      if (feetController.text.isEmpty) {
        isError = true;
        // errorFeet = stringLocalization.getText(StringLocalization.enterFeet);
        errorFeet = '';
        errorInHeight = true;
        errorMessageHeight = stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
        feetController.text = '';
      } else if (inchController.text.isEmpty) {
        isError = true;
        // errorInch = stringLocalization.getText(StringLocalization.enterInch);
        errorInch = '';
        errorInHeight = true;
        errorMessageHeight = stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
        inchController.text = '';
      } else {
        var controllerInchValue = int.parse(inchController.text);
        var controllerFeetValue = int.parse(feetController.text);
        if (controllerFeetValue == 0 ||
            (controllerFeetValue == 7 && controllerInchValue >= 11) ||
            controllerInchValue > 12) {
          errorHeight = '';
          // stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
          errorMessageHeight = stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
          heightController.text = '';
          inchController.text = '';
          feetController.text = '';
          errorInHeight = true;
          isError = true;
        } else {
          var inches = int.parse(feetController.text) * 12;
          inches = inches + int.parse(inchController.text);
          heightValue = (inches * 2.54).truncateToDouble();
          if (heightValue >= 241) {
            errorHeight = stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
            errorHeight = '';
            errorMessageHeight = stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
            heightController.text = '';
            inchController.text = '';
            feetController.text = '';
            errorInHeight = true;
            isError = true;
          }
        }
      }
    }
    return isError;
  }

  bool validateEmail() {
    String email = emailAddressController.text;
    bool isError = false;
    if (email.trim().isEmpty) {
      errorMessageForEmail = StringLocalization.of(context).getText(StringLocalization.emptyEmail);
      emailAddressController.text = '';
      isError = true;
    }
    if (email.trim().isNotEmpty && !Constants.validateEmail(email)) {
      errorMessageForEmail =
          StringLocalization.of(context).getText(StringLocalization.enterValidEmail);
      emailAddressController.text = '';
      isError = true;
    }
    return isError;
  }

  bool validatePassword() {
    String password = passwordController.text;
    bool isError = false;
    if (password.trim().isEmpty) {
      errorMessageForPassword =
          StringLocalization.of(context).getText(StringLocalization.emptyPassword);
      passwordController.text = '';
      isError = true;
    }
    if (!error8To20Character ||
        !mustContainOneLowercase ||
        !mustContainOneNumber ||
        !mustContainOneSpecialCharacter ||
        !mustContainOneUppercase) {
      isError = true;
    }

    String confirmPassword = confirmPasswordController.text;
    if (confirmPassword.trim().isEmpty) {
      errorMessageForConfirmPassword =
          StringLocalization.of(context).getText(StringLocalization.emptyConfirmPassword);
      confirmPasswordController.text = '';
      isError = true;
    }
    if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password.trim() != confirmPassword.trim()) {
        errorMessageForConfirmPassword =
            StringLocalization.of(context).getText(StringLocalization.passwordMismatch);
        confirmPasswordController.text = '';
        isError = true;
      }
    }
    return isError;
  }

  bool validateConfirmPassword() {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    bool isError = false;
    if (confirmPassword.trim().isEmpty) {
      errorMessageForConfirmPassword =
          StringLocalization.of(context).getText(StringLocalization.emptyConfirmPassword);
      confirmPasswordController.text = '';
      isError = true;
    }
    if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password.trim() != confirmPassword.trim()) {
        errorMessageForConfirmPassword =
            StringLocalization.of(context).getText(StringLocalization.passwordMismatch);
        confirmPasswordController.text = '';
        isError = true;
      }
    }
    return isError;
  }

  Widget termsAndCondition() {
    return Padding(
        padding: EdgeInsets.only(
          left: 33.w,
          right: 33.w,
        ),
        child: Row(
          children: [
            Container(
              height: 30.h,
              child: customRadio(
                  agreeTermsAndCondition ? HexColor.fromHex('FF6259') : Colors.transparent),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(stringLocalization.getText(StringLocalization.iAccept),
                      style: TextStyle(
                        color: isDarkMode()
                            ? Colors.white.withOpacity(0.9)
                            : HexColor.fromHex('#384341'),
                        fontSize: 16.sp,
                      )),
                  GestureDetector(
                    onTap: () {
                      Constants.navigatePush(
                              TermsAndCondition(
                                title: StringLocalization.of(context)
                                    .getText(StringLocalization.termsAndConditions),
                              ),
                              context)
                          .then((value) {
                        readTermsAndCondition = true;
                      });
                    },
                    child: Padding(
                      key: Key('signUpTermsandConditionsText'),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        StringLocalization.of(context)
                            .getText(StringLocalization.termsAndConditions),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: HexColor.fromHex('#00AFAA'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget logoImageLayout() {
    return Padding(
      padding: EdgeInsets.only(bottom: 99.2.h, top: 65.0.h),
      child: Image.asset(
        'asset/appLogo.png',
        height: 119.0.h,
        width: 170.0.w,
      ),
    );
  }

  void validateNameOnPressed(String value) {
    if (value.trim().length < 2 || value.trim().length > 50) {
      errorMessageForFirstName = '';
      apiErrorFirstName = true;
      apiErrorMsgFirstName =
          StringLocalization.of(context).getText(StringLocalization.firstNameValidation);
      // 'First name must be minimum 2 to maximum 50 characters long';
    } else {
      apiErrorFirstName = false;
      apiErrorMsgFirstName = '';
    }
    setState(() {});
  }

  void validateLastNameOnPressed(String value) {
    if (value.trim().length < 2 || value.trim().length > 50) {
      errorMessageForLastName = '';
      apiErrorLastName = true;
      apiErrorMsgLastName =
          StringLocalization.of(context).getText(StringLocalization.lastNameValidation);
      // 'Last name must be minimum 2 to maximum 50 characters long';
    } else {
      apiErrorLastName = false;
      apiErrorMsgLastName = '';
    }

    setState(() {});
  }

  void validateWeightOnPressed(String value) {
    if (_weightUnit == 0) {
      if (value == null ||
          value == '' ||
          value == '0' ||
          value[0] == '0' ||
          double.parse(value) >= 200) {
        errorWeight = '';
        errorInWeight = true;
        errorMessageWeight =
            '${stringLocalization.getText(StringLocalization.maxWeightLimit)} 200 ${stringLocalization.getText(StringLocalization.kg)}';
      } else if (value != null && value != '' && double.parse(value) < 200) {
        errorInWeight = false;
        errorMessageWeight = '';
      }
    } else {
      var weight = 0.0;
      if (value.isNotEmpty) {
        // weight = double.parse(value) / 2.205;
        weight = double.parse(value) / 2.20462;
      }
      if (weight >= 200) {
        errorWeight = '';
        errorInWeight = true;
        errorMessageWeight =
            '${stringLocalization.getText(StringLocalization.maxWeightLimit)} 441 ${stringLocalization.getText(StringLocalization.lb)}';
      } else {
        errorInWeight = false;
        errorMessageWeight = '';
      }
    }
    setState(() {});
  }

  void validateHeightOnPressed(String value) {
    if (_heightUnit == 0) {
      if (value == null ||
          value == '' ||
          value == '0' ||
          value[0] == '0' ||
          double.parse(value) >= 241) {
        errorHeight = '';
        errorInHeight = true;
        errorMessageHeight = stringLocalization.getText(StringLocalization.maxHeightLimitCm);
        ;
      } else if (value != null && value != '' && double.parse(value) < 241) {
        errorInHeight = false;
        errorMessageHeight = '';
      }
    } else {
      double heightValue = 0.0;
      var inches = 0.0;
      if (feetController.text.isNotEmpty) {
        inches = int.parse(feetController.text) * 12;
      }
      if (inchController.text.isNotEmpty) {
        inches = inches + int.parse(inchController.text);
      }
      heightValue = (inches * 2.54).truncateToDouble();
      if (value == null ||
          value == '' ||
          value == '0' ||
          value[0] == '0' ||
          heightValue >= 241 ||
          (inchController.text.isNotEmpty && int.parse(inchController.text) > 12)) {
        errorHeight = '';
        errorInHeight = true;
        if (inchController.text.isNotEmpty && int.parse(inchController.text) > 12) {
          errorMessageHeight = stringLocalization.getText(StringLocalization.inchLimit);
        } else {
          errorMessageHeight = stringLocalization.getText(StringLocalization.maxHeightLimitFeet);
        }
      } else if (value != null && value != '' && double.parse(value) < 241) {
        errorInHeight = false;
        errorMessageHeight = '';
      }
    }
    setState(() {});
  }

  bool validateStructure(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_^]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void isPasswordCompliant(String password, [int minLength = 8, int maxLength = 20]) {
    if (password == null || password.isEmpty) {
      // return false;
      error8To20Character = false;
      mustContainOneLowercase = false;
      mustContainOneNumber = false;
      mustContainOneUppercase = false;
      mustContainOneSpecialCharacter = false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!"#$%&(' ')*+,-./:;<=>?@[\\]^_`{|}~]'));
    bool hasMinLength = password.length >= minLength && password.length <= maxLength;
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

    if (hasDigits && hasUppercase && hasLowercase && hasSpecialCharacters && hasMinLength) {
      apiErrorPassword = false;
      errorMessageForPassword = '';
    } else {
      if (isFirstTimePassword) {
      } else {
        apiErrorPassword = true;
        errorMessageForPassword = stringLocalization.getText(StringLocalization.enterPassword);
      }
    }

    setState(() {});
  }

  void validatePasswordOnPressed(String value) {
    isPasswordCompliant(
      value,
    );
    setState(() {});
  }

//   Widget textFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         //region FirstName LastName
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Container(
//                 // height: 49.h,
//                 decoration: BoxDecoration(
//                     color: isDarkMode()
//                         ? HexColor.fromHex('#111B1A')
//                         : AppColor.backgroundColor,
//                     borderRadius: BorderRadius.circular(10.h),
//                     boxShadow: [
//                       BoxShadow(
//                         color: isDarkMode()
//                             ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                             : Colors.white,
//                         blurRadius: 5,
//                         spreadRadius: 0,
//                         offset: Offset(-5.w, -5.h),
//                       ),
//                       BoxShadow(
//                         color: isDarkMode()
//                             ? Colors.black.withOpacity(0.75)
//                             : HexColor.fromHex('#D1D9E6'),
//                         blurRadius: 5,
//                         spreadRadius: 0,
//                         offset: Offset(5.w, 5.h),
//                       ),
//                     ]),
//                 child: GestureDetector(
//                   onTap: () {
//                     if (isFirstTimeSN) {
//                       isFirstTimeSN = false;
//                     } else {
//                       validateLastNameOnPressed(lastNameController.text);
//                     }
//                     validateNameOnPressed(firstNameController.text);
//                     // isFirstTimePassword
//                     //     ? null
//                     //     : validatePasswordOnPressed(passwordController.text);
//                     firstNameFocusNode.requestFocus();
//                     openKeyboardUserId = false;
//                     openKeyboardConfirmPaswd = false;
//                     openKeyboardEmail = false;
//                     openKeyboardFirstName = true;
//                     openKeyboardLastName = false;
//                     openKeyboardPaswd = false;
//                     openKeyboardPhoneNo = false;
//                     openKeyboardBirthday = false;
//                     apiErrorFirstName = false;
//                     setState(() {});
//                   },
//                   child: Container(
//                     padding: EdgeInsets.only(left: 20.w, right: 20.w),
//                     decoration: openKeyboardFirstName
//                         ? ConcaveDecoration(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.h)),
//                             depression: 7,
//                             colors: [
//                                 isDarkMode()
//                                     ? Colors.black.withOpacity(0.5)
//                                     : HexColor.fromHex('#D1D9E6'),
//                                 isDarkMode()
//                                     ? HexColor.fromHex('#D1D9E6')
//                                         .withOpacity(0.07)
//                                     : Colors.white,
//                               ])
//                         : BoxDecoration(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.h)),
//                             color: isDarkMode()
//                                 ? HexColor.fromHex('#111B1A')
//                                 : AppColor.backgroundColor,
//                           ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           'asset/profile_icon_red.png',
//                         ),
//                         SizedBox(width: 10.0.w),
//                         Expanded(
//                           child: IgnorePointer(
//                             ignoring: openKeyboardFirstName ? false : true,
//                             child: TextFormField(
//                               focusNode: firstNameFocusNode,
//                               controller: firstNameController,
//                               style: TextStyle(fontSize: 16.0),
//                               autofocus: openKeyboardFirstName,
//                               decoration: InputDecoration(
//                                 // contentPadding: EdgeInsets.only(bottom: 5.h),
//                                 border: InputBorder.none,
//                                 focusedBorder: InputBorder.none,
//                                 enabledBorder: InputBorder.none,
//                                 errorBorder: InputBorder.none,
//                                 disabledBorder: InputBorder.none,
//                                 hintText: errorMessageForFirstName.isNotEmpty
//                                     ? errorMessageForFirstName
//                                     : StringLocalization.of(context).getText(
//                                         StringLocalization.hintForFirstName),
//                                 hintStyle: TextStyle(
//                                   color: errorMessageForFirstName.isNotEmpty
//                                       ? HexColor.fromHex('FF6259')
//                                       : HexColor.fromHex('7F8D8C'),
//                                   fontSize: errorMessageForFirstName.isNotEmpty
//                                       ? 10.sp
//                                       : 16.sp,
//                                 ),
//                               ),
//                               keyboardType: TextInputType.text,
//                               textInputAction: TextInputAction.next,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter(
//                                     regExForRestrictEmoji(),
//                                     allow: false),
//                                 FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
//                                     allow: true),
//                                 LengthLimitingTextInputFormatter(50),
//                               ],
//                               onFieldSubmitted: (_) {
//                                 validateNameOnPressed(firstNameController.text);
//                                 isFirstTimePassword
//                                     ? null
//                                     : validatePasswordOnPressed(
//                                         passwordController.text);
//
//                                 FocusScope.of(context)
//                                     .requestFocus(lastNameFocusNode);
//                                 openKeyboardUserId = false;
//                                 openKeyboardConfirmPaswd = false;
//                                 openKeyboardEmail = false;
//                                 openKeyboardFirstName = false;
//                                 openKeyboardLastName = true;
//                                 openKeyboardPaswd = false;
//                                 openKeyboardPhoneNo = false;
//                                 openKeyboardBirthday = false;
//                                 apiErrorLastName = false;
//                                 setState(() {});
//                               },
//                               onChanged: (value) {
//                                 validateNameOnPressed(value);
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 11.w,
//             ),
//             Expanded(
//               child: Container(
//                 // height: 49.h,
//                 // margin: EdgeInsets.only(top: 17.h),
//                 decoration: BoxDecoration(
//                     color: isDarkMode()
//                         ? HexColor.fromHex('#111B1A')
//                         : AppColor.backgroundColor,
//                     borderRadius: BorderRadius.circular(10.h),
//                     boxShadow: [
//                       BoxShadow(
//                         color: isDarkMode()
//                             ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                             : Colors.white,
//                         blurRadius: 5,
//                         spreadRadius: 0,
//                         offset: Offset(-5.w, -5.h),
//                       ),
//                       BoxShadow(
//                         color: isDarkMode()
//                             ? Colors.black.withOpacity(0.75)
//                             : HexColor.fromHex('#D1D9E6'),
//                         blurRadius: 5,
//                         spreadRadius: 0,
//                         offset: Offset(5.w, 5.h),
//                       ),
//                     ]),
//                 child: GestureDetector(
//                   onTap: () {
//                     validateLastNameOnPressed(lastNameController.text);
//                     if (isFirstTimeFN) {
//                       isFirstTimeFN = false;
//                     } else {
//                       validateNameOnPressed(firstNameController.text);
//                       // isFirstTimePassword
//                       //     ? null
//                       //     : validatePasswordOnPressed(passwordController.text);
//                     }
//
//                     lastNameFocusNode.requestFocus();
//                     openKeyboardUserId = false;
//                     openKeyboardConfirmPaswd = false;
//                     openKeyboardEmail = false;
//                     openKeyboardFirstName = false;
//                     openKeyboardLastName = true;
//                     openKeyboardPaswd = false;
//                     openKeyboardPhoneNo = false;
//                     openKeyboardBirthday = false;
//                     apiErrorLastName = false;
//                     setState(() {});
//                   },
//                   child: Container(
//                     padding: EdgeInsets.only(left: 20.w, right: 20.w),
//                     decoration: openKeyboardLastName
//                         ? ConcaveDecoration(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.h)),
//                             depression: 7,
//                             colors: [
//                                 isDarkMode()
//                                     ? Colors.black.withOpacity(0.5)
//                                     : HexColor.fromHex('#D1D9E6'),
//                                 isDarkMode()
//                                     ? HexColor.fromHex('#D1D9E6')
//                                         .withOpacity(0.07)
//                                     : Colors.white,
//                               ])
//                         : BoxDecoration(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.h)),
//                             color: isDarkMode()
//                                 ? HexColor.fromHex('#111B1A')
//                                 : AppColor.backgroundColor,
//                           ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           'asset/profile_icon_red.png',
//                         ),
//                         SizedBox(width: 10.0.w),
//                         Expanded(
//                           child: IgnorePointer(
//                             ignoring: openKeyboardLastName ? false : true,
//                             child: TextFormField(
//                               focusNode: lastNameFocusNode,
//                               controller: lastNameController,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter(
//                                     regExForRestrictEmoji(),
//                                     allow: false),
//                                 FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
//                                     allow: true),
//                                 LengthLimitingTextInputFormatter(50),
//                               ],
//                               autofocus: openKeyboardLastName,
//                               style: TextStyle(fontSize: 16),
//                               decoration: InputDecoration(
//                                   // contentPadding: EdgeInsets.only(bottom: 5.h),
//                                   border: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                   errorBorder: InputBorder.none,
//                                   disabledBorder: InputBorder.none,
//                                   hintText: errorMessageForLastName.isNotEmpty
//                                       ? errorMessageForLastName
//                                       : StringLocalization.of(context).getText(
//                                           StringLocalization.hintForLastName),
//                                   hintStyle: TextStyle(
//                                     color: errorMessageForLastName.isNotEmpty
//                                         ? HexColor.fromHex('FF6259')
//                                         : HexColor.fromHex('7F8D8C'),
//                                     fontSize: errorMessageForLastName.isNotEmpty
//                                         ? 10.sp
//                                         : 16.sp,
//                                   )),
//                               keyboardType: TextInputType.text,
//                               textInputAction: TextInputAction.next,
//                               onFieldSubmitted: (_) {
//                                 validateNameOnPressed(firstNameController.text);
//                                 validateLastNameOnPressed(
//                                     lastNameController.text);
//                                 isFirstTimePassword
//                                     ? null
//                                     : validatePasswordOnPressed(
//                                         passwordController.text);
//
//                                 FocusScope.of(context)
//                                     .requestFocus(userIDFocusNode);
//                                 openKeyboardUserId = true;
//                                 openKeyboardConfirmPaswd = false;
//                                 openKeyboardEmail = false;
//                                 openKeyboardFirstName = false;
//                                 openKeyboardLastName = false;
//                                 openKeyboardPaswd = false;
//                                 openKeyboardPhoneNo = false;
//                                 openKeyboardBirthday = false;
//
//                                 setState(() {});
//                               },
//                               onChanged: (value) {
//                                 validateLastNameOnPressed(value);
//                                 // if(value.length < 2 || value.length > 50){
//                                 //   apiErrorLastName = true;
//                                 //   apiErrorMsgLastName = 'Last name must be minimum 2 to maximum 50 character long';
//                                 // }else{
//                                 //   apiErrorLastName = false;
//                                 //   apiErrorMsgLastName = '';
//                                 // }
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         apiErrorFirstName
//             ? showApiError(apiErrorMsgFirstName, isError: apiErrorFirstName)
//             : Container(),
//         apiErrorLastName
//             ? showApiError(apiErrorMsgLastName, isError: apiErrorLastName)
//             : Container(),
//
//         //endregion
//         //region user Id
//         Container(
//           // height: 49.h,
//           margin: EdgeInsets.only(top: 17.h),
//           decoration: BoxDecoration(
//               color: isDarkMode()
//                   ? HexColor.fromHex('#111B1A')
//                   : AppColor.backgroundColor,
//               borderRadius: BorderRadius.circular(10.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                       : Colors.white,
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(-5.w, -5.h),
//                 ),
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? Colors.black.withOpacity(0.75)
//                       : HexColor.fromHex('#D1D9E6'),
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(5.w, 5.h),
//                 ),
//               ]),
//           child: GestureDetector(
//             onTap: () {
//               validateLastNameOnPressed(lastNameController.text);
//               validateNameOnPressed(firstNameController.text);
//               // isFirstTimePassword
//               //     ? null
//               //     : validatePasswordOnPressed(passwordController.text);
//               userIDFocusNode.requestFocus();
//               openKeyboardUserId = true;
//               openKeyboardConfirmPaswd = false;
//               openKeyboardEmail = false;
//               openKeyboardFirstName = false;
//               openKeyboardLastName = false;
//               openKeyboardPaswd = false;
//               openKeyboardPhoneNo = false;
//               openKeyboardBirthday = false;
//               setState(() {});
//             },
//             child: Container(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               decoration: openKeyboardUserId
//                   ? ConcaveDecoration(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.h)),
//                       depression: 7,
//                       colors: [
//                           isDarkMode()
//                               ? Colors.black.withOpacity(0.5)
//                               : HexColor.fromHex('#D1D9E6'),
//                           isDarkMode()
//                               ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
//                               : Colors.white,
//                         ])
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                       color: isDarkMode()
//                           ? HexColor.fromHex('#111B1A')
//                           : AppColor.backgroundColor,
//                     ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Image.asset(
//                     'asset/profile_icon_red.png',
//                   ),
//                   SizedBox(width: 10.0.w),
//                   Expanded(
//                     child: IgnorePointer(
//                       ignoring: openKeyboardUserId ? false : true,
//                       child: TextFormField(
//                         focusNode: userIDFocusNode,
//                         controller: userIDController,
//                         autofocus: openKeyboardUserId,
//                         style: TextStyle(fontSize: 16.0),
//                         decoration: InputDecoration(
//                             // contentPadding: EdgeInsets.only(bottom: 5.h),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             hintText: errorMessageForUserId.isNotEmpty
//                                 ? errorMessageForUserId
//                                 : StringLocalization.of(context)
//                                     .getText(StringLocalization.hintForUserId),
//                             hintStyle: TextStyle(
//                                 color: errorMessageForUserId.isNotEmpty
//                                     ? HexColor.fromHex('FF6259')
//                                     : HexColor.fromHex('7F8D8C'),
//                                 fontSize: 16.sp)),
// //                        validator: (value) {
// //                          if (value.trim().isEmpty) {
// //                            return StringLocalization.of(context)
// //                                .getText(StringLocalization.emptyUserId);
// //                          }
// //                          return null;
// //                        },
//                         inputFormatters: [
//                           FilteringTextInputFormatter(regExForRestrictEmoji(),
//                               allow: false),
//                           // FilteringTextInputFormatter(RegExp('[a-zA-Z]'),allow: true),
//                           LengthLimitingTextInputFormatter(30),
//                         ],
//                         keyboardType: TextInputType.text,
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           validateNameOnPressed(firstNameController.text);
//                           validateLastNameOnPressed(lastNameController.text);
//                           isFirstTimePassword
//                               ? null
//                               : validatePasswordOnPressed(
//                                   passwordController.text);
//                           FocusScope.of(context)
//                               .requestFocus(emailAddressFocusNode);
//                           openKeyboardUserId = false;
//                           openKeyboardConfirmPaswd = false;
//                           openKeyboardEmail = true;
//                           openKeyboardFirstName = false;
//                           openKeyboardLastName = false;
//                           openKeyboardPaswd = false;
//                           openKeyboardPhoneNo = false;
//                           openKeyboardBirthday = false;
//
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
// //        errorUserId ? errorContainer(StringLocalization.of(context).getText(
// //            StringLocalization.emptyUserId)) : Container(),
//         //endregion
//         //region birth date
//         Container(
//           // height: 49.h,
//           margin: EdgeInsets.only(top: 17.h),
//           decoration: BoxDecoration(
//               color: isDarkMode()
//                   ? HexColor.fromHex('#111B1A')
//                   : AppColor.backgroundColor,
//               borderRadius: BorderRadius.circular(10.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                       : Colors.white,
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(-5.w, -5.h),
//                 ),
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? Colors.black.withOpacity(0.75)
//                       : HexColor.fromHex('#D1D9E6'),
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(5.w, 5.h),
//                 ),
//               ]),
//           child: GestureDetector(
//             onTap: () {
//               validateLastNameOnPressed(lastNameController.text);
//               validateNameOnPressed(firstNameController.text);
//               // isFirstTimePassword
//               //     ? null
//               //     : validatePasswordOnPressed(passwordController.text);
//               openKeyboardBirthday = true;
//               openKeyboardUserId = false;
//               openKeyboardConfirmPaswd = false;
//               openKeyboardEmail = false;
//               openKeyboardFirstName = false;
//               openKeyboardLastName = false;
//               openKeyboardPaswd = false;
//               openKeyboardPhoneNo = false;
//               setState(() {});
//             },
//             child: Container(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               decoration: openKeyboardBirthday
//                   ? ConcaveDecoration(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.h)),
//                       depression: 7,
//                       colors: [
//                           isDarkMode()
//                               ? Colors.black.withOpacity(0.5)
//                               : HexColor.fromHex('#D1D9E6'),
//                           isDarkMode()
//                               ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
//                               : Colors.white,
//                         ])
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                       color: isDarkMode()
//                           ? HexColor.fromHex('#111B1A')
//                           : AppColor.backgroundColor,
//                     ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Image.asset(
//                     'asset/birthday_icon.png',
//                   ),
//                   SizedBox(width: 10.0.w),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () async {
//                         DateTime date = await showCustomDatePicker(
//                           context: context,
//                           initialDate: selectedDate.isAfter(DateTime.now())
//                               ? DateTime.now()
//                               : selectedDate,
//                           firstDate: DateTime(1920, 1),
//                           lastDate: DateTime.now(),
//                           fieldHintText: stringLocalization
//                               .getText(StringLocalization.enterDate),
//                           getDatabaseDataFrom: '',
//                         );
//                         if (date != null) {
//                           setState(() {
//                             selectedDate = date;
//                             birthDateController.text =
//                                 DateFormat('dd-MM-yyyy').format(date);
//                           });
//                         }
//                       },
//                       child: TextFormField(
//                         enabled: false,
//                         controller: birthDateController,
//                         autofocus: false,
//                         style: TextStyle(fontSize: 16.0),
//                         decoration: InputDecoration(
//                             // contentPadding: EdgeInsets.only(bottom: 5.h),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             hintText: errorMessageForBirthDate.isNotEmpty
//                                 ? errorMessageForBirthDate
//                                 : StringLocalization.of(context).getText(
//                                     StringLocalization.hintForBirthDate),
//                             hintStyle: TextStyle(
//                                 color: errorMessageForBirthDate.isNotEmpty
//                                     ? HexColor.fromHex('FF6259')
//                                     : HexColor.fromHex('7F8D8C'),
//                                 fontSize: 16.sp),
//                             suffixIcon: Image.asset(
//                               'asset/calendar_button.png',
//                             ),
//                             suffixIconConstraints: BoxConstraints(
//                               maxHeight: 33.h,
//                               maxWidth: 33.h,
//                               minHeight: 33.h,
//                               minWidth: 33.h,
//                             )),
//                         keyboardType: TextInputType.text,
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           validateNameOnPressed(firstNameController.text);
//                           validateLastNameOnPressed(lastNameController.text);
//                           isFirstTimePassword
//                               ? null
//                               : validatePasswordOnPressed(
//                                   passwordController.text);
//                           FocusScope.of(context)
//                               .requestFocus(emailAddressFocusNode);
//                           openKeyboardUserId = false;
//                           openKeyboardConfirmPaswd = false;
//                           openKeyboardEmail = true;
//                           openKeyboardFirstName = false;
//                           openKeyboardLastName = false;
//                           openKeyboardPaswd = false;
//                           openKeyboardPhoneNo = false;
//                           openKeyboardBirthday = false;
//
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         //endregion
//         //region email
//         Container(
//           // height: 49.h,
//           margin: EdgeInsets.only(top: 17.h),
//           decoration: BoxDecoration(
//               color: isDarkMode()
//                   ? HexColor.fromHex('#111B1A')
//                   : AppColor.backgroundColor,
//               borderRadius: BorderRadius.circular(10.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                       : Colors.white,
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(-5.w, -5.h),
//                 ),
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? Colors.black.withOpacity(0.75)
//                       : HexColor.fromHex('#D1D9E6'),
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(5.w, 5.h),
//                 ),
//               ]),
//           child: GestureDetector(
//             onTap: () {
//               validateLastNameOnPressed(lastNameController.text);
//               validateNameOnPressed(firstNameController.text);
//               // isFirstTimePassword
//               //     ? null
//               //     : validatePasswordOnPressed(passwordController.text);
//               emailAddressFocusNode.requestFocus();
//               openKeyboardUserId = false;
//               openKeyboardConfirmPaswd = false;
//               openKeyboardEmail = true;
//               openKeyboardFirstName = false;
//               openKeyboardLastName = false;
//               openKeyboardPaswd = false;
//               openKeyboardPhoneNo = false;
//               openKeyboardBirthday = false;
//               setState(() {});
//             },
//             child: Container(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               decoration: openKeyboardEmail
//                   ? ConcaveDecoration(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.h)),
//                       depression: 7,
//                       colors: [
//                           isDarkMode()
//                               ? Colors.black.withOpacity(0.5)
//                               : HexColor.fromHex('#D1D9E6'),
//                           isDarkMode()
//                               ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
//                               : Colors.white,
//                         ])
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                       color: isDarkMode()
//                           ? HexColor.fromHex('#111B1A')
//                           : AppColor.backgroundColor,
//                     ),
//               child: Row(
//                 children: <Widget>[
//                   Image.asset(
//                     'asset/email_icon_red.png',
//                   ),
//                   SizedBox(width: 10.0.w),
//                   Expanded(
//                     child: IgnorePointer(
//                       ignoring: openKeyboardEmail ? false : true,
//                       child: TextFormField(
//                         focusNode: emailAddressFocusNode,
//                         controller: emailAddressController,
//                         autofocus: openKeyboardEmail,
//                         style: TextStyle(fontSize: 16.0),
//                         decoration: InputDecoration(
//                             // contentPadding: EdgeInsets.only(bottom: 5.h),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             hintText: errorMessageForEmail.isNotEmpty
//                                 ? errorMessageForEmail
//                                 : StringLocalization.of(context)
//                                     .getText(StringLocalization.hintForEmail),
//                             hintStyle: TextStyle(
//                                 color: errorMessageForEmail.isNotEmpty
//                                     ? HexColor.fromHex('FF6259')
//                                     : HexColor.fromHex('7F8D8C'))),
// //                        validator: (value) {
// //                          if (value.trim().isEmpty) {
// //                            return StringLocalization.of(context)
// //                                .getText(StringLocalization.emptyEmail);
// //                          }
// //                          if (!Constants.validateEmail(value)) {
// //                            return StringLocalization.of(context)
// //                                .getText(StringLocalization.enterValidEmail);
// //                          }
// //                          return null;
// //                        },
//                         inputFormatters: [
//                           FilteringTextInputFormatter(regExForRestrictEmoji(),
//                               allow: false),
//                           LengthLimitingTextInputFormatter(50),
//                         ],
//                         keyboardType: TextInputType.emailAddress,
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           validateNameOnPressed(firstNameController.text);
//                           validateLastNameOnPressed(lastNameController.text);
//                           isFirstTimePassword
//                               ? null
//                               : validatePasswordOnPressed(
//                                   passwordController.text);
//                           FocusScope.of(context)
//                               .requestFocus(phoneNumberFocusNode);
//                           openKeyboardUserId = false;
//                           openKeyboardConfirmPaswd = false;
//                           openKeyboardEmail = false;
//                           openKeyboardFirstName = false;
//                           openKeyboardLastName = false;
//                           openKeyboardPaswd = false;
//                           openKeyboardPhoneNo = true;
//                           openKeyboardBirthday = false;
//
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
// //        errorEmail ? errorContainer( emailAddressController.text.isEmpty ? StringLocalization.of(context).getText(
// //            StringLocalization.emptyEmail) : !Constants.validateEmail(emailAddressController.text) ? StringLocalization.of(context).getText(
// //            StringLocalization.enterValidEmail) : StringLocalization.of(context).getText(
// //            StringLocalization.emptyEmail)) : Container(),
//         //endregion
//         //region phone
//         Container(
//           // height: 49.h,
//           margin: EdgeInsets.only(top: 17.h),
//           decoration: BoxDecoration(
//               color: isDarkMode()
//                   ? HexColor.fromHex('#111B1A')
//                   : AppColor.backgroundColor,
//               borderRadius: BorderRadius.circular(10.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                       : Colors.white,
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(-5.w, -5.h),
//                 ),
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? Colors.black.withOpacity(0.75)
//                       : HexColor.fromHex('#D1D9E6'),
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(5.w, 5.h),
//                 ),
//               ]),
//           child: GestureDetector(
//             onTap: () {
//               validateLastNameOnPressed(lastNameController.text);
//               validateNameOnPressed(firstNameController.text);
//               // isFirstTimePassword
//               //     ? null
//               //     : validatePasswordOnPressed(passwordController.text);
//               phoneNumberFocusNode.requestFocus();
//               openKeyboardUserId = false;
//               openKeyboardConfirmPaswd = false;
//               openKeyboardEmail = false;
//               openKeyboardFirstName = false;
//               openKeyboardLastName = false;
//               openKeyboardPaswd = false;
//               openKeyboardPhoneNo = true;
//               openKeyboardBirthday = false;
//               setState(() {});
//             },
//             child: Container(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               decoration: openKeyboardPhoneNo
//                   ? ConcaveDecoration(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.h)),
//                       depression: 7,
//                       colors: [
//                           isDarkMode()
//                               ? Colors.black.withOpacity(0.5)
//                               : HexColor.fromHex('#D1D9E6'),
//                           isDarkMode()
//                               ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
//                               : Colors.white,
//                         ])
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                       color: isDarkMode()
//                           ? HexColor.fromHex('#111B1A')
//                           : AppColor.backgroundColor,
//                     ),
//               child: Row(
//                 children: <Widget>[
//                   Image.asset(
//                     'asset/profile_icon_red.png',
//                   ),
//                   SizedBox(width: 10.0.w),
//                   Expanded(
//                     child: IgnorePointer(
//                       ignoring: openKeyboardPhoneNo ? false : true,
//                       child: TextFormField(
//                         focusNode: phoneNumberFocusNode,
//                         controller: phoneNumberController,
//                         inputFormatters: [
//                           FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
//                               allow: false),
//                           FilteringTextInputFormatter(RegExp('[\\-|\\ ,|.]'),
//                               allow: false),
//                           LengthLimitingTextInputFormatter(15),
//                         ],
//                         keyboardType: TextInputType.numberWithOptions(
//                             decimal: false, signed: false),
//                         autofocus: openKeyboardPhoneNo,
//                         style: TextStyle(fontSize: 16.0),
//                         decoration: InputDecoration(
//                             // contentPadding: EdgeInsets.only(bottom: 5.h),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             hintText: StringLocalization.of(context)
//                                 .getText(StringLocalization.hintForPhone),
//                             hintStyle:
//                                 TextStyle(color: HexColor.fromHex('7F8D8C'))),
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           validateNameOnPressed(firstNameController.text);
//                           validateLastNameOnPressed(lastNameController.text);
//                           isFirstTimePassword
//                               ? null
//                               : validatePasswordOnPressed(
//                                   passwordController.text);
//                           FocusScope.of(context)
//                               .requestFocus(passwordFocusNode);
//                           openKeyboardUserId = false;
//                           openKeyboardConfirmPaswd = false;
//                           openKeyboardEmail = false;
//                           openKeyboardFirstName = false;
//                           openKeyboardLastName = false;
//                           openKeyboardPaswd = true;
//                           openKeyboardPhoneNo = false;
//                           openKeyboardBirthday = false;
//                           apiErrorPassword = false;
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
// //        errorPhoneNo ? errorContainer(phoneNumberController.text.isEmpty ? StringLocalization.of(context).getText(
// //            StringLocalization.emptyPhone) : !Constants.isNumeric(phoneNumberController.text) ? StringLocalization.of(context).getText(
// //            StringLocalization.enterValidPhone) : StringLocalization.of(context).getText(
// //            StringLocalization.emptyPhone)) : Container(),
//         //endregion
//         //region password
//         Container(
//           // height: 49.h,
//           margin: EdgeInsets.only(top: 17.h),
//           decoration: BoxDecoration(
//               color: isDarkMode()
//                   ? HexColor.fromHex('#111B1A')
//                   : AppColor.backgroundColor,
//               borderRadius: BorderRadius.circular(10.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                       : Colors.white,
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(-5.w, -5.h),
//                 ),
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? Colors.black.withOpacity(0.75)
//                       : HexColor.fromHex('#D1D9E6'),
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(5.w, 5.h),
//                 ),
//               ]),
//           child: GestureDetector(
//             onTap: () {
//               isFirstTimePassword = false;
//               validateLastNameOnPressed(lastNameController.text);
//               validateNameOnPressed(firstNameController.text);
//               // validatePasswordOnPressed(passwordController.text);
//               passwordFocusNode.requestFocus();
//               openKeyboardUserId = false;
//               openKeyboardConfirmPaswd = false;
//               openKeyboardEmail = false;
//               openKeyboardFirstName = false;
//               openKeyboardLastName = false;
//               openKeyboardPaswd = true;
//               openKeyboardPhoneNo = false;
//               openKeyboardBirthday = false;
//               apiErrorPassword = false;
//               setState(() {});
//             },
//             child: Container(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               decoration: openKeyboardPaswd
//                   ? ConcaveDecoration(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.h)),
//                       depression: 7,
//                       colors: [
//                           isDarkMode()
//                               ? Colors.black.withOpacity(0.5)
//                               : HexColor.fromHex('#D1D9E6'),
//                           isDarkMode()
//                               ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
//                               : Colors.white,
//                         ])
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                       color: isDarkMode()
//                           ? HexColor.fromHex('#111B1A')
//                           : AppColor.backgroundColor,
//                     ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Image.asset(
//                     'asset/lock_icon_red.png',
//                   ),
//                   SizedBox(width: 10.0.w),
//                   Expanded(
//                     child: IgnorePointer(
//                       ignoring: openKeyboardPaswd ? false : true,
//                       child: TextFormField(
//                         obscureText: obscureText,
//                         focusNode: passwordFocusNode,
//                         controller: passwordController,
//                         autofocus: openKeyboardPaswd,
//                         style: TextStyle(fontSize: 16.0),
//                         decoration: InputDecoration(
//                             // contentPadding: EdgeInsets.only(bottom: 5.h),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             hintText: errorMessageForPassword.isNotEmpty
//                                 ? errorMessageForPassword
//                                 : StringLocalization.of(context).getText(
//                                     StringLocalization.hintForPassword),
//                             hintStyle: TextStyle(
//                                 color: errorMessageForPassword.isNotEmpty
//                                     ? HexColor.fromHex('FF6259')
//                                     : HexColor.fromHex('7F8D8C'))),
//                         keyboardType: TextInputType.text,
//                         inputFormatters: [
//                           FilteringTextInputFormatter(regExForRestrictEmoji(),
//                               allow: false),
//                           FilteringTextInputFormatter(
//                               RegExp(r'[a-zA-Z0-9!@#\$&*~_^]'),
//                               allow: true),
//                           LengthLimitingTextInputFormatter(20),
//                         ],
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           validateNameOnPressed(firstNameController.text);
//                           validateLastNameOnPressed(lastNameController.text);
//                           isFirstTimePassword
//                               ? null
//                               : validatePasswordOnPressed(
//                                   passwordController.text);
//                           FocusScope.of(context)
//                               .requestFocus(confirmPasswordFocusNode);
//                           openKeyboardUserId = false;
//                           openKeyboardConfirmPaswd = true;
//                           openKeyboardEmail = false;
//                           openKeyboardFirstName = false;
//                           openKeyboardLastName = false;
//                           openKeyboardPaswd = false;
//                           openKeyboardPhoneNo = false;
//                           openKeyboardBirthday = false;
//
//                           setState(() {});
//                         },
//                         onChanged: (value) {
//                           validatePasswordOnPressed(value);
//                           // if (value.length < 8 || value.length > 20) {
//                           //   apiErrorPassword = true;
//                           //   apiErrorMsgPassword =
//                           //       'Please enter a password with minimum 8 and maximum 20 characters, must contain at least one uppercase letter, one lowercase letter, one number and one special character';
//                           // } else {
//                           //   if (validateStructure(value)) {
//                           //     apiErrorPassword = false;
//                           //     apiErrorMsgPassword = '';
//                           //   } else {
//                           //     apiErrorPassword = true;
//                           //     apiErrorMsgPassword =
//                           //         'Please enter a password with minimum 8 and maximum 20 characters, must contain at least one uppercase letter, one lowercase letter, one number and one special character';
//                           //   }
//                           // }
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Image.asset(
//                       !obscureText
//                           ? 'asset/view_icon_grn.png'
//                           : 'asset/view_off_icon_grn.png',
//                       height: 25.h,
//                       width: 25.w,
//                     ),
//                     onPressed: () {
//                       obscureText = !obscureText;
//                       setState(() {});
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // apiErrorPassword ? showApiError(apiErrorMsgPassword,isError: apiErrorPassword) : Container(),
//         !isFirstTimePassword
//             ? showApiError(messageLengthPassword, isError: !error8To20Character)
//             : Container(),
//         !isFirstTimePassword
//             ? showApiError(messageUppercasePassword,
//                 isError: !mustContainOneUppercase)
//             : Container(),
//         !isFirstTimePassword
//             ? showApiError(messageLowercasePassword,
//                 isError: !mustContainOneLowercase)
//             : Container(),
//         !isFirstTimePassword
//             ? showApiError(messageSpecialPassword,
//                 isError: !mustContainOneSpecialCharacter)
//             : Container(),
//         !isFirstTimePassword
//             ? showApiError(messageNumberPassword,
//                 isError: !mustContainOneNumber)
//             : Container(),
//         //endregion
//         //region Confirm password
//         Container(
//           // height: 49.h,
//           margin: EdgeInsets.only(top: 17),
//           decoration: BoxDecoration(
//               color: isDarkMode()
//                   ? HexColor.fromHex('#111B1A')
//                   : AppColor.backgroundColor,
//               borderRadius: BorderRadius.circular(10.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                       : Colors.white,
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(-5.w, -5.h),
//                 ),
//                 BoxShadow(
//                   color: isDarkMode()
//                       ? Colors.black.withOpacity(0.75)
//                       : HexColor.fromHex('#D1D9E6'),
//                   blurRadius: 5,
//                   spreadRadius: 0,
//                   offset: Offset(5.w, 5.h),
//                 ),
//               ]),
//           child: GestureDetector(
//             onTap: () {
//               validateLastNameOnPressed(lastNameController.text);
//               validateNameOnPressed(firstNameController.text);
//               // isFirstTimePassword
//               //     ? null
//               //     : validatePasswordOnPressed(passwordController.text);
//               confirmPasswordFocusNode.requestFocus();
//               openKeyboardUserId = false;
//               openKeyboardConfirmPaswd = true;
//               openKeyboardEmail = false;
//               openKeyboardFirstName = false;
//               openKeyboardLastName = false;
//               openKeyboardPaswd = false;
//               openKeyboardPhoneNo = false;
//               openKeyboardBirthday = false;
//               setState(() {});
//             },
//             child: Container(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w),
//               decoration: openKeyboardConfirmPaswd
//                   ? ConcaveDecoration(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.h)),
//                       depression: 7,
//                       colors: [
//                           isDarkMode()
//                               ? Colors.black.withOpacity(0.5)
//                               : HexColor.fromHex('#D1D9E6'),
//                           isDarkMode()
//                               ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
//                               : Colors.white,
//                         ])
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                       color: isDarkMode()
//                           ? HexColor.fromHex('#111B1A')
//                           : AppColor.backgroundColor,
//                     ),
//               child: Row(
//                 children: <Widget>[
//                   Image.asset(
//                     'asset/lock_icon_red.png',
//                     // height: 20.57.h,
//                     // width: 18.w,
//                   ),
//                   SizedBox(width: 10.0.w),
//                   Expanded(
//                     child: IgnorePointer(
//                       ignoring: openKeyboardConfirmPaswd ? false : true,
//                       child: TextFormField(
//                         obscureText: obscureTextConfirm,
//                         focusNode: confirmPasswordFocusNode,
//                         controller: confirmPasswordController,
//                         autofocus: openKeyboardConfirmPaswd,
//                         style: TextStyle(fontSize: 16.0),
//                         decoration: InputDecoration(
//                             // contentPadding: EdgeInsets.only(bottom: 5.h),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             hintText: errorMessageForConfirmPassword.isNotEmpty
//                                 ? errorMessageForConfirmPassword
//                                 : StringLocalization.of(context).getText(
//                                     StringLocalization.hintForConfirmPassword),
//                             hintStyle: TextStyle(
//                                 color: errorMessageForConfirmPassword.isNotEmpty
//                                     ? HexColor.fromHex('FF6259')
//                                     : HexColor.fromHex('7F8D8C'))),
// //                        validator: (value) {
// //                          if (value.trim().isEmpty) {
// //                            return StringLocalization.of(context).getText(
// //                                StringLocalization.emptyConfirmPassword);
// //                          }
// //                          if (value != passwordController.text) {
// //                            return StringLocalization.of(context).getText(
// //                                StringLocalization.confirmPasswordDoesntMatch);
// //                          }
// //                          return null;
// //                        },
//                         keyboardType: TextInputType.text,
//                         inputFormatters: [
//                           FilteringTextInputFormatter(regExForRestrictEmoji(),
//                               allow: false),
//                           LengthLimitingTextInputFormatter(50),
//                         ],
//                         textInputAction: TextInputAction.done,
//                         onFieldSubmitted: (value) {
//                           validateNameOnPressed(firstNameController.text);
//                           validateLastNameOnPressed(lastNameController.text);
//                           isFirstTimePassword
//                               ? null
//                               : validatePasswordOnPressed(
//                                   passwordController.text);
//                           openKeyboardUserId = false;
//                           openKeyboardConfirmPaswd = false;
//                           openKeyboardEmail = false;
//                           openKeyboardFirstName = false;
//                           openKeyboardLastName = false;
//                           openKeyboardPaswd = false;
//                           openKeyboardPhoneNo = false;
//                           openKeyboardBirthday = false;
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Image.asset(
//                       !obscureTextConfirm
//                           ? 'asset/view_icon_grn.png'
//                           : 'asset/view_off_icon_grn.png',
//                       height: 25.h,
//                       width: 25.w,
//                     ),
//                     onPressed: () {
//                       obscureTextConfirm = !obscureTextConfirm;
//                       setState(() {});
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
// //        errorConfirmPaswd ? errorContainer(passwordController.text != confirmPasswordController.text ? StringLocalization.of(context).getText(
// //                                StringLocalization.confirmPasswordDoesntMatch) : StringLocalization.of(context).getText(
// //                                StringLocalization.emptyConfirmPassword)) : Container(),
//         //endregion
//         SizedBox(height: 20.0.h),
//       ],
//     );
//   }

  RegExp regExForRestrictEmoji() => RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  Widget customRadio(Color color) {
    return GestureDetector(
      onTap: () {
        if (readTermsAndCondition) {
          agreeTermsAndCondition = !agreeTermsAndCondition;
          setState(() {});
        } else {
          var dialog = CustomInfoDialog(
            title: stringLocalization.getText(StringLocalization.information),
            subTitle: stringLocalization.getText(StringLocalization.readTermsAndConditions),
            onClickYes: () {
              Navigator.of(context).pop();
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
                    isDarkMode() ? Colors.white : HexColor.fromHex('#D1D9E6'),
                    isDarkMode() ? HexColor.fromHex('#D1D9E6').withOpacity(0.1) : Colors.white,
                  ]),
              child: Container(
                margin: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                    color: isDarkMode() ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode()
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(-3.w, -3.h),
                      ),
                      BoxShadow(
                        color: isDarkMode()
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(3.w, 3.h),
                      ),
                    ]),
                child: Container(
                    key: Key('signUpTermsRadio'),
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
          ],
        ),
      ),
    );
  }

  Widget showApiError(String error, {bool? isError, bool? isPassword}) {
    return Container(
      padding: EdgeInsets.only(
          top: isPassword != null && isPassword ? 4.h : 17.h, left: 33.h, right: 33.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isError ?? false
              ? Image.asset('asset/info_icon_red.png', height: 26.h, width: 26.h)
              : Icon(
                  Icons.check,
                  size: 26.h,
                  color: AppColor.green,
                ),
          SizedBox(width: 7.w),
          Flexible(
            child: Text(
              error,
              style: TextStyle(
                fontSize: 12.sp,
                color: isError ?? false ? HexColor.fromHex('#FF6259') : AppColor.green,
              ),
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void onClickSignUp() {
    bool validate = validateSignUp();
    if (validate) {
      if (birthDateController.text.trim().isNotEmpty) {
        if (!agreeTermsAndCondition) {
          CustomSnackBar.CurrentBuildSnackBar(context,
              StringLocalization.of(context).getText(StringLocalization.agreeTermsAndCondition));
        } else {
          if (!agreeDisclaimer) {
            CustomSnackBar.CurrentBuildSnackBar(context,
                StringLocalization.of(context).getText(StringLocalization.agreeDisclaimerText));
          } else {
            FocusScope.of(context).requestFocus(FocusNode());
            preferences?.clear();
            callApi();
          }
        }
      } else {
        CustomSnackBar.CurrentBuildSnackBar(
            context, StringLocalization.of(context).getText(StringLocalization.emptyBirthDate));
      }
    } else {
      setState(() {});
    }
  }

  bool validateSignUp() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String birthDate = birthDateController.text;
    String email = emailAddressController.text;
    String phone = phoneNumberController.text;
    String password = passwordController.text;
    String username = userIDController.text;
    String confirmPassword = confirmPasswordController.text;
    bool validate = true;
    if (firstName.trim().isEmpty) {
      errorMessageForFirstName =
          StringLocalization.of(context).getText(StringLocalization.emptyFirstName);
      firstNameController.text = '';
      validate = false;
    }
    if (username.trim().isEmpty) {
      errorMessageForUserId =
          StringLocalization.of(context).getText(StringLocalization.emptyUserId);
      userIDController.text = '';
      validate = false;
    }
    if (lastName.trim().isEmpty) {
      errorMessageForLastName =
          StringLocalization.of(context).getText(StringLocalization.emptyLastName);
      lastNameController.text = '';
      validate = false;
    }
    if (birthDate.trim().isEmpty) {
      errorMessageForBirthDate =
          StringLocalization.of(context).getText(StringLocalization.emptyBirthDate);
      birthDateController.text = '';
      validate = false;
    }
    if (email.trim().isEmpty) {
      errorMessageForEmail = StringLocalization.of(context).getText(StringLocalization.emptyEmail);
      emailAddressController.text = '';
      validate = false;
    }
    if (!Constants.validateEmail(email)) {
      errorMessageForEmail =
          StringLocalization.of(context).getText(StringLocalization.enterValidEmail);
      emailAddressController.text = '';
      validate = false;
    }
//    if (phone.trim().isEmpty) {
//      errorMessageForPhone =
//          StringLocalization.of(context).getText(StringLocalization.emptyPhone);
//      phoneNumberController.text = '';
//      validate = false;
//    }
    if (password.trim().isEmpty) {
      errorMessageForPassword =
          StringLocalization.of(context).getText(StringLocalization.emptyPassword);
      passwordController.text = '';
      validate = false;
    }
    if (confirmPassword.trim().isEmpty) {
      errorMessageForConfirmPassword =
          StringLocalization.of(context).getText(StringLocalization.emptyConfirmPassword);
      confirmPasswordController.text = '';
      validate = false;
    }
    if (firstName.trim().length < 2 || firstName.trim().length > 50) {
      validate = false;
    }
    if (lastName.trim().length < 2 || lastName.trim().length > 50) {
      validate = false;
    }
    if (password.trim().length < 5 || password.trim().length > 25) {
      validate = false;
    }
    if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password.trim() != confirmPassword.trim()) {
        errorMessageForConfirmPassword =
            StringLocalization.of(context).getText(StringLocalization.passwordMismatch);
        confirmPasswordController.text = '';
        validate = false;
      }
    }
    if (validate) {
      errorMessageForFirstName = '';
      errorMessageForLastName = '';
      errorMessageForUserId = '';
      errorMessageForEmail = '';
      errorMessageForBirthDate = '';
//      errorMessageForPhone = '';
      errorMessageForPassword = '';
      errorMessageForConfirmPassword = '';
    }
    return validate;
  }

  /// Added by: chandresh
  /// Added at: 02-06-2020
  /// post data to register api and store local
  Future<void> callApi() async {
    bool isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String userId = userIDController.text.trim();
      String email = emailAddressController.text.trim().toLowerCase();
      String phone = phoneNumberController.text.trim();
      double height = 0.0;
      double weight = double.parse(weightController.text);

      if (_weightUnit == 1) {
        // weight = weight / 2.205;
        weight = weight / 2.20462;
      }

      if (_heightUnit == 0) {
        height = double.parse(heightController.text);
      } else {
        var inches = int.parse(feetController.text) * 12;
        inches = inches + int.parse(inchController.text);
        height = (inches * 2.54).truncateToDouble();
      }

      if (phone != null && phone.length != 0) {
        phone = '+' + _selectedDialogCountry.phoneCode + phone;
      }
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();
      int studyCode =
          studyCodeController.text.trim() == '' ? 0 : int.parse(studyCodeController.text.trim());
      String deviceToken = widget.token;
      if (deviceToken == null) {
        if (preferences != null) {
          deviceToken = preferences!.getString('firebaseMessagingToken') ?? '';
        } else {
          SharedPreferences.getInstance().then((value) {
            preferences = value;
            deviceToken = preferences?.getString('firebaseMessagingToken') ?? '';
          });
        }
      }
      var map = {
        'FirstName': firstName,
        'LastName': lastName,
        'Gender': requestGender,
        'Email': email,
        'Phone': phone,
        'Password': password,
        'UserName': userId,
        'DateOfBirth': DateFormat(DateUtil.yyyyMMdd).format(selectedDate),
        'UserGroup': studyCode,
        'UserMeasurementTypeID': 1,
        'Height': height,
        'Weight': weight,
        'DeviceToken': deviceToken,
        'InitialWeight': weight,
        'HeightUnit': _heightUnit + 1, // 1 for cm and 2 for ft
        'WeightUnit': _weightUnit + 1, // 1 for kg and 2 for lb
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch
      };

      // String url = Constants.baseUrl + 'UserRegistation';

      Constants.progressDialog(true, context);
      final signUpResult =
          await AuthRepository().userRegistration(UserRegistrationRequest.fromJson(map));
      if (signUpResult.hasData) {
        Constants.progressDialog(false, context);
        if (signUpResult.getData!.result ?? false) {
          UserModel userModel = UserModel.mapper(signUpResult.getData!.data!);
          if (userModel.dateOfBirth == null || userModel.dateOfBirth != selectedDate) {
            userModel.dateOfBirth = selectedDate;
          }
          preferences?.setString(Constants.prefUserPasswordKey, Constants.encryptStr(password));
          preferences?.setInt(Constants.measurementType, userModel.userMeasurementTypeId!);

          //await openConfirmationCodeDialog(userModel);
          await saveDataToDbAndNavigate(userModel);

          CustomSnackBar.CurrentBuildSnackBar(
              context,
              StringLocalization.of(context)
                  .getText(StringLocalization.userRegisteredSuccessfully));
        } else {
          Constants.progressDialog(false, context);
          if (signUpResult.getData!.message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(signUpResult.getData!.message!)));
          } else if (signUpResult.getData!.errors != null) {
            try {
              List<dynamic> apiErrorList = signUpResult.getData!.errors!;
              for (int i = 0; i < apiErrorList.length; i++) {
                if (apiErrorList[i].contains('Last Name')) {
                  apiErrorLastName = true;
                  apiErrorMsgLastName = apiErrorList[i];
                }
                if (apiErrorList[i].contains('First Name')) {
                  apiErrorFirstName = true;
                  apiErrorMsgFirstName = apiErrorList[i];
                }
                if (apiErrorList[i].contains('Password')) {
                  apiErrorPassword = true;
                  apiErrorMsgPassword = apiErrorList[i];
                }
                setState(() {});
              }
            } catch (e) {
              print(e);
            }
          }
//          scaffoldKey.currentState
//              .showSnackBar(SnackBar(content: Text(result['value'][0])));
        }
      }
//       final Map result = await new SignUp().callApi(url, map);
//       Constants.progressDialog(false, context);
//       if (!result["isError"]) {
//         UserModel userModel = result["value"];
//         if (userModel.dateOfBirth == null ||
//             userModel.dateOfBirth != selectedDate) {
//           userModel.dateOfBirth = selectedDate;
//         }
//         preferences?.setString(
//             Constants.prefUserPasswordKey, Constants.encryptStr(password));
//         preferences?.setInt(
//             Constants.measurementType, userModel.userMeasurementTypeId!);
//
//         // scaffoldKey.currentState.showSnackBar(
//         //   SnackBar(
//         //     content: Text(StringLocalization.of(context)
//         //         .getText(StringLocalization.userRegisteredSuccessfully)),
//         //     duration: Duration(seconds: 1),
//         //   ),
//
//         //await openConfirmationCodeDialog(userModel);
//         await saveDataToDbAndNavigate(userModel);
//
//         CustomSnackBar.CurrentBuildSnackBar(
//             context,
//             scaffoldKey,
//             StringLocalization.of(context)
//                 .getText(StringLocalization.userRegisteredSuccessfully));
//       } else {
//         if (result["value"] != null && result["value"].toString().isNotEmpty) {
//           if (result["value"] is String) {
//             scaffoldKey.currentState!
//                 .showSnackBar(SnackBar(content: Text(result["value"])));
//           } else {
//             try {
//               List<dynamic> apiErrorList = result["value"];
//               for (int i = 0; i < apiErrorList.length; i++) {
//                 if (apiErrorList[i].contains("Last Name")) {
//                   apiErrorLastName = true;
//                   apiErrorMsgLastName = apiErrorList[i];
//                 }
//                 if (apiErrorList[i].contains("First Name")) {
//                   apiErrorFirstName = true;
//                   apiErrorMsgFirstName = apiErrorList[i];
//                 }
//                 if (apiErrorList[i].contains("Password")) {
//                   apiErrorPassword = true;
//                   apiErrorMsgPassword = apiErrorList[i];
//                 }
//                 setState(() {});
//               }
//             } catch (e) {
//               print(e);
//             }
//           }
// //          scaffoldKey.currentState
// //              .showSnackBar(SnackBar(content: Text(result["value"][0])));
//         }
//       }
    } else {
      // scaffoldKey.currentState.showSnackBar(SnackBar(
      //     content: Text(StringLocalization.of(context)
      //         .getText(StringLocalization.enableInternet))));

      CustomSnackBar.CurrentBuildSnackBar(
          context, StringLocalization.of(context).getText(StringLocalization.enableInternet));
    }
    setState(() {});
  }

  openConfirmationCodeDialog(UserModel userData) {
    confirmUserDialog(onClickOk: () async {
      if (context != null) {
        openKeyboardConfirmUser = false;
        Navigator.of(context, rootNavigator: true).pop();
      }
      // bool isValidPswd =
      // validatePassword(password: confirmUserController.text);
      bool isInternet = await Constants.isInternetAvailable();
      if (isInternet) {
        Constants.progressDialog(true, context);
        Map map = {'UserID': userData.userId, 'ConfirmationCode': confirmUserController.text};
        ConfirmUser()
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
            Constants.progressDialog(false, context);
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
        CustomSnackBar.CurrentBuildSnackBar(
            context, StringLocalization.of(context).getText(StringLocalization.enableInternet));
      }
    });
  }

//  showAPIErrorDialogue(List<dynamic> errors){
//    var dialog = Dialog(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10),
//        ),
//        elevation: 0,
//        backgroundColor: isDarkMode()
//            ? HexColor.fromHex('#111B1A')
//            : AppColor.backgroundColor,
//        child: Container(
//            decoration: BoxDecoration(
//                color: isDarkMode()
//                    ? HexColor.fromHex('#111B1A')
//                    : AppColor.backgroundColor,
//                borderRadius: BorderRadius.circular(10),
//                boxShadow: [
//                  BoxShadow(
//                    color: isDarkMode()
//                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                        : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
//                    blurRadius: 5,
//                    spreadRadius: 0,
//                    offset: Offset(-5, -5),
//                  ),
//                  BoxShadow(
//                    color: isDarkMode()
//                        ? HexColor.fromHex('#000000').withOpacity(0.75)
//                        : HexColor.fromHex('#384341').withOpacity(0.9),
//                    blurRadius: 5,
//                    spreadRadius: 0,
//                    offset: Offset(5, 5),
//                  ),
//                ]),
//            padding: EdgeInsets.only(top: 27.h, left: 15.w, right: 15.w),
//            height: 309.h,
//            width: 309.w,
//            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                      Expanded(
//                         child:  ListView.builder(
//                         itemCount: errors.length,
//                         itemBuilder: (context, index) {
//                         return errorText(errors[index]);
//                        }),),
//                      SizedBox(height: 5.h,),
//                      Align(
//                        alignment: Alignment.bottomRight,
//                        child: FlatButton(
//                          onPressed: () {
//                            if (context != null) {
//                              Navigator.of(context, rootNavigator: true).pop();
//                            }
//                          },
//                          child: Text (stringLocalization
//                              .getText(StringLocalization.ok)
//                              .toUpperCase(),
//                            style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                              fontSize: 14,
//                              color: HexColor.fromHex('#00AFAA'),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ))
//            );
//    showDialog(
//        context: context,
//        useRootNavigator: true,
//        builder: (context) => dialog,
//        barrierDismissible: false);
//  }

  showErrorDialog(String error) {
    var dialog = CustomInfoDialog(
      title: 'Error',
      subTitle: error,
      maxLine: 2,
      primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
      onClickYes: () {
        if (context != null) {
          Navigator.of(context, rootNavigator: true).pop();
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

  saveDataToDbAndNavigate(UserModel userData) async {
    preferences?.setString(Constants.prefUserIdKeyInt, userData.userId ?? '');
    preferences?.setString(Constants.prefUserEmailKey, userData.email ?? '');
    preferences?.setString(Constants.prefUserName, userData.userName ?? '');
    preferences?.setInt(Constants.wightUnitKey, (userData.weightUnit ?? 1) - 1);
    preferences?.setInt(Constants.mHeightUnitKey, (userData.heightUnit ?? 1) - 1);

    try {
      if (userData.picture != null && userData.picture!.isNotEmpty) {
        Response response = await get(Uri(scheme: userData.picture));
        Uint8List base64DecodedImage = response.bodyBytes;
        userData.picture = base64Encode(base64DecodedImage);
      }
      await dbHelper.insertUser(
          userData.toJsonForInsertUsingSignInOrSignUp(), userData.userId.toString());
      isFromSignUp = true;
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        Constants.navigatePushAndRemove(
            HomeScreen(
              key: homeScreenStateKey,
              isFromSignInScreen: true,
            ),
            context);
      });
    } catch (e) {
      print(e);
    }
  }

  confirmUserDialog({required GestureTapCallback onClickOk}) {
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
                              SizedBox(height: 10.h),
                              SizedBox(
                                height: 95.h,
                                child: Body1AutoText(
                                  text: stringLocalization
                                      .getText(StringLocalization.userRegisteredText),
                                  fontSize: 16.sp,
                                  maxLine: 4,
                                  minFontSize: 10,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
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
                                                style: TextStyle(fontSize: 16.0),
                                                decoration: InputDecoration(
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
                                                if (context != null) {
                                                  Navigator.of(context, rootNavigator: true).pop();
                                                }
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

  validateEmptyPassword() {
    if (confirmUserController != null && confirmUserController.text.isEmpty) {
      errorConfirmUser = true;
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  Widget errorText(String text) {
    return Container(
      child: Text('* $text',
          style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode()
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                  : HexColor.fromHex('#384341'))),
    );
  }

  getPref() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
  }
}
