import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/home/app_service.dart';
import 'package:health_gauge/models/profile_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/measurement/measurement_repository.dart';
import 'package:health_gauge/repository/measurement/request/set_measurement_unit_request.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/WeightHistory/HelperWidgets/weight_toggle.dart';
import 'package:health_gauge/screens/device_management/picker_operationals_buttons.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/screens/no_data_found_screen.dart';
import 'package:health_gauge/screens/sign_in_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomCalendar/date_picker_dialog.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_toggle_container.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Added by: chandresh
/// Added at: 04-06-2020
/// This screen displays user information and provide feature to user for update.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool? isInternet;
  bool isEdit = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProfileModel profileModel = ProfileModel();
  String? profile_picture;
  double oldWeight = kg;

  @override
  void initState() {
    LoggingService().info('Profile', 'Open Profile Screen');
    getPref();
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = Constants.profile;
    return ChangeNotifierProvider.value(
      value: profileModel,
      child: Scaffold(
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
              centerTitle: true,
              title: Body1AutoText(
                text: stringLocalization.getText(StringLocalization.profile),
                fontSize: 18.sp,
                color: HexColor.fromHex('62CBC9'),
                fontWeight: FontWeight.bold,
                align: TextAlign.center,
                minFontSize: 14,
                // maxLine: 1,
              ),
              leading: IconButton(
                key: Key('backProfile'),
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  isEdit
                      ? backDialog(false, onClickYes: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          await onClickSave().then((value) {
                            savePreferenceInServer();
                          });
                          // Navigator.of(context).pop();
                        })
                      : Navigator.of(context).pop();
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
          ),
        ),
        body: Selector<ProfileModel, bool>(
          selector: (context, model) => model.isLoadForLocalDb ?? false,
          builder: (context, mHeightUnit, child) => dataLayout(),
        ),
      ),
    );
  }

  WebViewController? _controller;

  Widget dataLayout() {
    if (profileModel.isLoadForLocalDb ?? false) {
      return LoadingScreen();
    } else if (profileModel.user == null) {
      return NoDatFoundScreen();
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 33.w, right: 33.w),
          // constant given
          child: Column(
            key: Key('profileScreen'),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Selector<ProfileModel, bool>(
                  selector: (context, model) => model.profileImageChangeIndicator ?? false,
                  builder: (context, value, child) => profilePicture()),
              nameWidget(),
              userNameWidget(),
              genderWidget(),
              birthDate(),
              heightWidget(),
              widthWidget(),
              maxWeightWidget(),
              skinTypeWidget(),
              SizedBox(height: 30.h),
              cancelSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profilePicture() {
    Widget imageWidget = Container();
    print("profile_pic_screen ${profileModel.base64DecodedImage}");

    if (profileModel.profilePic.toString() != null || profileModel.base64DecodedImage != null) {
      if (profileModel.base64DecodedImage != null) {
        imageWidget = Image.memory(
          profileModel.base64DecodedImage!,
          height: 91.0.h,
          width: 91.0.h,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } else if (profileModel.profilePic.toString().startsWith('http')) {
        imageWidget = Image.network(
          profileModel.profilePic!,
          height: 91.0.h,
          width: 91.0.h,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } else {
        imageWidget = Image.asset(
          'asset/profile_icon.png',
          height: 91.0.h,
          width: 91.0.h,
          fit: BoxFit.cover,
        );
      }
    } else if (globalUser != null && globalUser?.gender != null && globalUser?.gender == 'O') {
      imageWidget = Padding(
        padding: EdgeInsets.all(15.h),
        child: Center(
          child: Body1AutoText(
            text: globalUser?.firstName != null && globalUser?.lastName != null
                ? '${globalUser?.firstName![0].toUpperCase()}${globalUser?.lastName![0].toUpperCase()}'
                : '',
            fontSize: 44.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#62CBC9')
                : HexColor.fromHex('#00AFAA'),
            minFontSize: 20,
          ),
        ),
      );
    } else {
      imageWidget = Container(
        child: Image.asset(
          globalUser == null || globalUser?.gender == null || globalUser!.gender!.isEmpty
              ? profileModel.images!.maleAvatar
              : globalUser?.gender == 'F'
                  ? profileModel.images!.femaleAvatar
                  : globalUser?.gender == 'M'
                      ? profileModel.images!.maleAvatar
                      : 'O',
          height: 91.0.h,
          width: 91.0.h,
          color:
              Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#62CBC9') : null,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 23.h),
          height: 121.h,
          width: 121.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  height: 121.h,
                  width: 121.h,
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/imageBackground_dark.png'
                        : 'asset/imageBackground_light.png',
                  )),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(15.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45.5.h),
                      child: imageWidget,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        TextButton(
          key: Key('editProfileImageButton'),
          child: Text(
            stringLocalization.getText(StringLocalization.edit).toUpperCase(),
            style: TextStyle(
              color: HexColor.fromHex('#00AFAA'),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // edit textsize should be changed to sp(Akhil sir)
          onPressed: () {
            showImagePickerDialog();
          },
        )
      ],
    );
  }

  Widget nameWidget() {
    if (profileModel.user == null) {
      return Container();
    }
    var name = '';
    if (profileModel.user?.firstName != null && profileModel.user!.firstName!.trim().isNotEmpty) {
      name = profileModel.user!.firstName! + ' ';
    }
    if (profileModel.user?.lastName != null && profileModel.user!.lastName!.trim().isNotEmpty) {
      name += profileModel.user!.lastName!;
    }
    if (name.isNotEmpty) {
      return TitleText(
        text: name,
        align: TextAlign.center,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : HexColor.fromHex('#384341'),
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      );
    }
    return Container();
  }

  Widget userNameWidget() {
    if (profileModel.user == null) {
      return Container();
    }

    if (profileModel.user?.userName != null && profileModel.user!.userName!.trim().isNotEmpty) {
      return Body1AutoText(
        text: profileModel.user!.userName ?? '',
        align: TextAlign.center,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      );
    }
    return Container();
  }

  Widget genderWidget() {
    return Container(
      margin: EdgeInsets.only(top: 24.0.h),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Body1AutoText(
                text: stringLocalization.getText(StringLocalization.gender),
                maxLine: 1,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              )),
          Expanded(
              flex: 7,
              child: Container(

                  /// Added by: Akhil
                  /// Added on: April/05/2021
                  /// this selector is responsible for building gender GridView
                  /// when different gender is selected.
                  child: Selector<ProfileModel, String>(
                selector: (context, model) => model.gender!,
                builder: (context, gender, child) =>
                    Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: profileModel.genderList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          key: Key('genderRadio'),
                          height: 28.h,
                          child: customRadio(
                            index: index,
                            color: index + 1 ==
                                    (gender == 'M'
                                        ? 1
                                        : gender == 'F'
                                            ? 2
                                            : 3)
                                ? HexColor.fromHex('FF6259')
                                : Colors.transparent,
                            unitText: profileModel.genderList![index].text,
                            isGender: true,
                          ),
                        );
                      })
                ]),
              ))
//            Container(
//              alignment: Alignment.topLeft,
//              width: MediaQuery.of(context).size.width,
//              child: Wrap(
//                children: <Widget>[
//                  Row(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      Radio(
//                        groupValue: gender,
//                        value: 'M',
//                        onChanged: (value) {
//                          gender != value ? isEdit = true : isEdit = false;
//                          gender = value;
//                          globalUser.gender = value;
//                          setState(() {});
//                        },
//                      ),
//                      Body1AutoText(
//                          text: stringLocalization
//                              .getText(StringLocalization.male),
//                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.87)  :  HexColor.fromHex('#384341'), fontSize: 16,)
//                    ],
//                  ),
//
//                  SizedBox(width: 5.0.w),
//                  // to maintain some gap between pickers
//                  Row(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      Radio(
//                        groupValue: gender,
//                        value: 'F',
//                        onChanged: (value) {
//                          gender != value ? isEdit = true : isEdit = false;
//                          gender = value;
//                          globalUser.gender = value;
//                          setState(() {});
//                        },
//                      ),
//                      Body1AutoText(
//                          text: stringLocalization
//                              .getText(StringLocalization.female),
//                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.87)  :  HexColor.fromHex('#384341'), fontSize: 16,)
//                    ],
//                  ),
//                ],
//              ),
//            ),
              ),
        ],
      ),
    );
  }

  Widget birthDate() {
    return Container(
      margin: EdgeInsets.only(top: 22.h),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.dateOfBirth),
              maxLine: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// Added by: Akhil
          /// Added on: April/05/2021
          /// this selector is responsible for building Date of Birth field
          /// when dateOfBirth is changed.
          Selector<ProfileModel, DateTime>(
            selector: (context, model) => model.dateOfBirth!,
            builder: (context, dateOfBirth, child) => Expanded(
              flex: 5,
              child: InkWell(
                key: Key('profileDOB'),
                onTap: () {
                  selectBirthDate();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15.0.w),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: TitleText(
                    text: DateFormat(DateUtil.dd_MM_yyyy).format(dateOfBirth),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget heightWidget() {
    // profileModel.heightText = '';
    // String heightText = '';
    // // profileModel.updateHeightText('');
    // if (profileModel.profileHeightUnit == 1) {
    //   int inches = (profileModel.profileCentimetre / 2.54).round();
    //   try {
    //     var feet = inches ~/ 12;
    //     var inch = inches % 12;
    //     profileModel.profileFeet = inches ~/ 12;
    //     profileModel.profileInch = inches % 12;
    //     // profileModel.updateProfileFeet(feet);
    //     // profileModel.updateProfileInch(inch);
    //     heightText = '$feet'$inch''';
    //     profileModel.heightText = heightText;
    //     // profileModel.updateHeightText(heightText);
    //     // profileModel.heightText = '$feet'$inch''';
    //   } catch (e) {
    //     print('exception in profile screen $e');
    //   }
    // } else {
    //   // heightText = '${profileModel.profileCentimetre}';
    //   profileModel.heightText = '${profileModel.profileCentimetre}';
    //   // profileModel.updateHeightText('${profileModel.profileCentimetre}');
    // }
    return Container(
      margin: EdgeInsets.only(top: 22.0.h),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.height),
              maxLine: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              key: Key('profileHeight'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  useRootNavigator: true,
                  isDismissible: false,
                  enableDrag: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(),
                  builder: (context) {
                    return heightPicker();
                  },
                );
              },
              child: Container(
                key: Key('profileHeightText'),
                padding: EdgeInsets.only(left: 15.0.w),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topLeft,

                /// Added by: Akhil
                /// Added on: April/05/2021
                /// this selector is responsible for building Height field when heightText
                /// is changed (depends on profileHeightUnit and height value selected).
                child: Selector<ProfileModel, String>(
                  selector: (context, model) {
                    if (model.profileHeightUnit == 1) {
                      var inches = (model.profileCentimetre! / 2.54).round();
                      try {
                        var feet = inches ~/ 12;
                        var inch = inches % 12;
                        // model.updateProfileFeet(feet);
                        // model.updateProfileInch(inch);
                        model.profileFeet = feet;
                        model.profileInch = inch;
                        var heightText = "$feet'$inch''";
                        // model.updateHeightText(heightText);
                        model.heightText = heightText;
                        return model.heightText!;
                      } catch (e) {
                        print('exception in profile screen_1 $e');
                        return model.heightText!;
                      }
                    } else {
                      // heightText = '${model.profileCentimetre}';
                      profileModel.heightText = '${profileModel.profileCentimetre}';
                      // model.updateHeightText('${model.profileCentimetre}');
                      return model.heightText!;
                    }
                  },
                  builder: (context, heightText, child) => TitleText(
                    text: profileModel.heightText ?? '',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: 13.w),

              /// Added by: Akhil
              /// Added on: April/05/2021
              /// this selector is responsible for building Height unit field
              /// when profileHeightUnit changes
              child: Selector<ProfileModel, int>(
                  selector: (context, model) => model.profileHeightUnit!,
                  builder: (context, profileHeightUnit, child) => Container(
                        height: 26.h,
                        child: CustomToggleContainer(
                            selectedUnit: profileHeightUnit,
                            unitText1:
                                StringLocalization.of(context).getText(StringLocalization.cmShort),
                            unitText2: StringLocalization.of(context)
                                .getText(StringLocalization.feetShort),
                            width: 62.w,
                            unit1Selected: () {
                              if (profileHeightUnit != 0) {
                                profileModel.updateProfileHeightUnit(0);
                                isEdit = true;
                                profileModel.isEdit = isEdit;
                              }
                            },
                            unit2Selected: () {
                              if (profileHeightUnit != 1) {
                                profileModel.updateProfileHeightUnit(1);
                                isEdit = true;
                                profileModel.isEdit = isEdit;
                              }
                            }),
                      )
                  //     ChangeUnitDesign(
                  //   height: 26,
                  //   fontWeight: FontWeight.normal,
                  //   fontSize: 16.sp,
                  //   text: profileHeightUnit == 0
                  //       ? stringLocalization.getText(StringLocalization.cmShort)
                  //       : stringLocalization
                  //           .getText(StringLocalization.feetShort),
                  //   insideShadowColor: [
                  //     Theme.of(context).brightness == Brightness.dark
                  //         ? Colors.black.withOpacity(0.8)
                  //         : HexColor.fromHex('9F2DBC').withOpacity(0.2),
                  //     Theme.of(context).brightness == Brightness.dark
                  //         ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                  //         : Colors.white,
                  //   ],
                  //   arrowContainerFlex: 2,
                  //   textContainerFlex: 3,
                  //   onTapUpCallback: onTapHeightUnit,
                  //   onTapDownCallback: onTapHeightUnit,
                  // ),
                  ),
            ),
          )
        ],
      ),
    );
  }

  heightPicker() {
    if (profileModel.profileHeightUnit == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PickerOperationalButtons(
            positiveCallback: () {
              isEdit = true;
              profileModel.isEdit = isEdit;
              profileModel.updateProfileCentimetre(profileModel.profileCentimetre!.toInt());
              Navigator.of(context, rootNavigator: true).pop();
              var inches = (profileModel.profileCentimetre! / 2.54).round();
              try {
                feet = inches ~/ 12;
                inch = inches % 12;
                // profileModel.updateProfileFeet(feet);
                // profileModel.updateProfileInch(inch);
                profileModel.profileFeet = inches ~/ 12;
                profileModel.profileInch = inches % 12;
              } catch (e) {
                print('exception in profile screen_2 $e');
              }
            },
            negativeCallback: () async {
              profileModel.user = await dbHelper.getUser(profileModel.userId.toString());
              setDefaultData(user: profileModel.user!, field: 'height');
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          SizedBox(
            height: 150.h,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomCupertinoPicker(
                    key: Key('cmHeightPicker'),
                    scrollController: FixedExtentScrollController(
                      initialItem: profileModel.profileCentimetre! + 11,
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    children: List.generate(131, (index) {
                      return Container(
                        key: Key('cmHeightItem$index'),
                        margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                        child: TitleText(text: '${index + 120}'),
                      );
                    }),
                    diameterRatio: 20,
                    itemExtent: 40,
                    useMagnifier: true,
                    magnification: 1.05,
                    looping: true,
                    onSelectedItemChanged: (int index) {
                      centimetre = index + 120;
                      profileModel.updateProfileCentimetre(index + 120);
                      globalUser?.height = (index.toString() + 120.toString());
                    },
                  ),
                ),
                SizedBox(width: 5.0.w),
                Expanded(
                    child: Center(
                        child: TitleText(
                            text: stringLocalization.getText(StringLocalization.centimetre))))
              ],
            ),
          ),
        ],
      );
    }
    return Container(
      height: 200.0.h,
      child: Column(
        children: <Widget>[
          PickerOperationalButtons(
            positiveCallback: () {
              var val = double.parse('$feet.$inch');
              var inches = profileModel.profileFeet! * 12;
              inches = inches + profileModel.profileInch!;
              centimetre = (inches * 2.54).toInt();
              profileModel.updateProfileCentimetre((inches * 2.54).toInt());
              isEdit = true;
              profileModel.isEdit = isEdit;
              // profileModel.profileCentimetre = (inches * 2.54).toInt();
              Navigator.of(context, rootNavigator: true).pop();
              // setState(() {});
            },
            negativeCallback: () async {
              profileModel.user = await dbHelper.getUser(profileModel.userId.toString());
              setDefaultData(user: profileModel.user!, field: 'height');
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          SizedBox(
            height: 150.h,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomCupertinoPicker(
                          key: Key('ftHeightPicker'),
                          scrollController: FixedExtentScrollController(
                              initialItem:
                                  profileModel.feetList!.indexOf(profileModel.profileFeet)),
                          backgroundColor: Theme.of(context).cardColor,
                          children: List.generate(profileModel.feetList!.length, (index) {
                            return Container(
                              key: Key('ftHeightItem$index'),
                              margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                              child: TitleText(
                                text: profileModel.feetList![index].toString(),
                              ),
                            );
                          }),
                          diameterRatio: 20,
                          itemExtent: 40,
                          useMagnifier: true,
                          magnification: 1.05,
                          looping: true,
                          onSelectedItemChanged: (int index) {
                            feet = profileModel.feetList![index];
                            profileModel.updateProfileFeet(profileModel.feetList![index]);
                            var value = (profileModel.feetList![index] * 30.48 +
                                    profileModel.profileInch! * 2.54)
                                .toInt();
                            // profileModel.profileFeet = profileModel.feetList[index];
                            // profileModel.updateProfileCentimetre(value);
                            profileModel.profileCentimetre = value;
                            // setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: TitleText(
                                  text: stringLocalization.getText(StringLocalization.feet))))
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomCupertinoPicker(
                          key: Key('inchHeightPicker'),
                          scrollController: new FixedExtentScrollController(
                              initialItem:
                                  profileModel.inchList!.indexOf(profileModel.profileInch)),
                          backgroundColor: Theme.of(context).cardColor,
                          children: List.generate(profileModel.inchList!.length, (index) {
                            return Container(
                              key: Key('inchHeightItem$index'),
                              margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                              child: TitleText(
                                text: profileModel.inchList![index].toString(),
                              ),
                            );
                          }),
                          diameterRatio: 20,
                          itemExtent: 40,
                          useMagnifier: true,
                          magnification: 1.05,
                          looping: true,
                          onSelectedItemChanged: (int index) {
                            isEdit = true;
                            // profileModel.updateIsEdit(isEdit);
                            profileModel.isEdit = isEdit;
                            inch = profileModel.inchList![index];
                            var value = (profileModel.profileFeet! * 30.48 + inch * 2.54).toInt();
                            // profileModel.profileInch = profileModel.inchList[index];
                            profileModel.updateProfileInch(profileModel.inchList![index]);
                            // profileModel.updateProfileCentimetre(value);
                            profileModel.profileCentimetre = value;
                            // setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: TitleText(
                                  text: stringLocalization.getText(StringLocalization.inch))))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget weightPicker(String weightType) {
    if (profileModel.profileWeightUnit == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PickerOperationalButtons(
            positiveCallback: () {
              if (weightType == 'maxWeight') {
                maxPound = (profileModel.profileMaxKg! * 2.20462);
                profileModel.updateProfileMaxPound((profileModel.profileMaxKg! * 2.20462));
              } else {
                pound = (profileModel.profileKg! * 2.20462);
                profileModel.updateProfilePound((profileModel.profileKg! * 2.20462));
              }
              isEdit = true;
              profileModel.isEdit = isEdit;
              Navigator.of(context, rootNavigator: true).pop();
            },
            negativeCallback: () async {
              profileModel.user = await dbHelper.getUser(profileModel.userId.toString());
              setDefaultData(user: profileModel.user!, field: 'weight');
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          SizedBox(
            height: 150.h,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150.0.w,
                  child: CustomCupertinoPicker(
                    key: Key('kgWeightPicker'),
                    scrollController: FixedExtentScrollController(
                        initialItem: weightType == 'maxWeight'
                            ? profileModel.kilogramList!.indexOf(profileModel.getProfileMaxKG)
                            : profileModel.kilogramList!.indexOf(profileModel.getProfileKG)),
                    backgroundColor: Theme.of(context).cardColor,
                    children: List.generate(
                      profileModel.kilogramList!.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                          child: TitleText(
                            text: profileModel.kilogramList![index].toString(),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (index) {
                      if (weightType == 'maxWeight') {
                        maxKg = double.parse(profileModel.kilogramList![index]);
                        globalUser?.maxWeight = maxKg.toString();
                        profileModel.updateProfileMaxKg(maxKg);
                      } else {
                        kg = double.parse(profileModel.kilogramList![index].toString());
                        globalUser?.weight = kg.toString();
                        profileModel.updateProfileKg(kg);
                      }
                    },
                    diameterRatio: 20,
                    itemExtent: 40,
                    useMagnifier: true,
                    magnification: 1.05,
                    looping: true,
                  ),
                ),
                SizedBox(width: 5.0.w),
                TitleText(text: stringLocalization.getText(StringLocalization.kg))
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PickerOperationalButtons(
          positiveCallback: () {
            if (weightType == 'maxWeight') {
              maxKg = (profileModel.profileMaxPound! / 2.20462);
              profileModel.updateProfileMaxKg((profileModel.profileMaxPound! / 2.20462));
            } else {
              kg = (profileModel.profilePound! / 2.20462);
              profileModel.updateProfileKg((profileModel.profilePound! / 2.20462));
            }
            isEdit = true;
            profileModel.isEdit = isEdit;
            Navigator.of(context, rootNavigator: true).pop();
          },
          negativeCallback: () async {
            profileModel.user = await dbHelper.getUser(profileModel.userId.toString());
            setDefaultData(user: profileModel.user!, field: 'weight');
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        SizedBox(
          height: 150.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150.0.w,
                child: CustomCupertinoPicker(
                  key: Key('poundWeightPicker'),
                  scrollController: FixedExtentScrollController(
                    initialItem: weightType == 'maxWeight'
                        ? profileModel.poundList!.indexOf(profileModel.getProfileMaxPound)
                        : profileModel.poundList!.indexOf(profileModel.getProfilePound),
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  children: List.generate(
                    profileModel.poundList!.length,
                    (index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                        child: TitleText(
                          text: profileModel.poundList![index].toString(),
                        ),
                      );
                    },
                  ),
                  onSelectedItemChanged: (index) {
                    if (weightType == 'maxWeight') {
                      maxPound = double.parse(profileModel.poundList![index].toString());
                      globalUser?.maxWeight = maxPound.toString();
                      profileModel.updateProfileMaxPound(profileModel.poundList![index]);
                    } else {
                      pound = double.parse(profileModel.poundList![index].toString());
                      globalUser?.weight = pound.toString();
                      profileModel.updateProfilePound(pound);
                    }
                    // setState(() {});
                  },
                  diameterRatio: 20,
                  itemExtent: 40,
                  useMagnifier: true,
                  magnification: 1.05,
                  looping: true,
                ),
              ),
              SizedBox(width: 5.0.w),
              TitleText(text: stringLocalization.getText(StringLocalization.lb))
            ],
          ),
        ),
      ],
    );
  }

  Widget widthWidget() {
    return Container(
      margin: EdgeInsets.only(top: 22.0.h),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.weight),
              maxLine: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              key: Key('profileWeight'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  useRootNavigator: true,
                  isDismissible: false,
                  enableDrag: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(),
                  builder: (context) {
                    return weightPicker('currentWeight');
                  },
                );
              },
              child: Selector<ProfileModel, String>(
                selector: (context, model) => profileModel.profileWeightUnit == 1
                    ? '${profileModel.profileKg}'
                    : '${profileModel.profilePound}',
                builder: (context, weight, child) => Container(
                  padding: EdgeInsets.only(left: 15.0.w),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: TitleText(
                    text: double.parse(weight).toStringAsFixed(1),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: 13.w),
              child: Selector<ProfileModel, int>(
                selector: (context, model) => model.profileWeightUnit!,
                builder: (context, profileWeightUnit, child) => Container(
                  height: 26.h,
                  child: WeightToggle(
                    selectedUnit: profileWeightUnit,
                    unitText1: StringLocalization.of(context).getText(StringLocalization.kg),
                    unitText2: StringLocalization.of(context).getText(StringLocalization.lb),
                    width: 62.w,
                    unit1Selected: () {
                      if (profileWeightUnit != 1) {
                        profileModel.updateProfileWeightUnit(1);
                        isEdit = true;
                        profileModel.isEdit = isEdit;
                      }
                    },
                    unit2Selected: () {
                      if (profileWeightUnit != 2) {
                        profileModel.updateProfileWeightUnit(2);
                        isEdit = true;
                        profileModel.isEdit = isEdit;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget maxWeightWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10.0.h),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.maxWeight),
              maxLine: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              key: Key('profileInitialWeight'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  useRootNavigator: true,
                  isDismissible: false,
                  enableDrag: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(),
                  builder: (context) {
                    return weightPicker('maxWeight');
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 15.0.w),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topLeft,

                /// Added by: Akhil
                /// Added on: April/05/2021
                /// this selector is responsible for building Initial Weight unit field
                child: Selector<ProfileModel, double?>(
                  selector: (context, model) => profileModel.profileWeightUnit == 1
                      ? model.profileMaxKg
                      : model.profileMaxPound,
                  builder: (context, maxWeightUnit, child) => TitleText(
                    text: profileModel.profileWeightUnit == 1
                        ? '${profileModel.profileMaxKg?.toStringAsFixed(1)} ${stringLocalization.getText(StringLocalization.kg)}'
                        : '${profileModel.profileMaxPound?.toStringAsFixed(1)} ${stringLocalization.getText(StringLocalization.lb)}',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  key: Key('initialWeightInfo'),
                  icon: Image.asset(
                    'asset/info_button.png',
                    height: 33.h,
                    width: 33.h,
                  ),
                  onPressed: maxWeightInfoDialog,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customRadio(
      {required int index,
      required Color color,
      required String unitText,
      required bool isGender}) {
    return GestureDetector(
      key: (index == 0)
          ? Key('M')
          : index == 1
              ? Key('F')
              : Key('O'),
      onTap: () {
        var valueGender = (index == 0
            ? 'M'
            : index == 1
                ? 'F'
                : 'O');
        if (isGender) {
          if (profileModel.gender != valueGender) {
            isEdit = true;
          }
          // : isEdit = false;
          //   profileModel.updateIsEdit(isEdit);
          profileModel.isEdit = isEdit;
          profileModel.updateGender(valueGender);
          globalUser?.gender = valueGender;
          // setState(() {});
        } else {
          var valueUnit = index == 0 ? Strings().metric : Strings().imperial;
          // profileModel.unit != valueUnit ?
          isEdit = true;
          // : isEdit = false;
          // profileModel.updateIsEdit(isEdit);
          profileModel.isEdit = isEdit;
          profileModel.updateUnit(valueUnit);
          // globalUser.unit = valueUnit == strings.metric ? 1 : 2;
          // setState(() {});
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
                    text: unitText,
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

  maxWeightInfoDialog() {
//    var dialog = CustomInfoDialog(
//      title: stringLocalization.getText(StringLocalization.maxWeight),
//      subTitle:
//          stringLocalization.getText(StringLocalization.initialWeightInfo),
//      maxLine: 2,
//      onClickYes: onClickOkInitialWeightInfo,
//    );
    var dialog = Dialog(
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
                    ? HexColor.fromHex('#111B1A')
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
            padding: EdgeInsets.only(top: 27.h, left: 16.w, right: 10.w),
            height: 188.h,
            width: 309.w,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    height: 25.h,
                    // child: AutoSizeText(
                    //   stringLocalization.getText(StringLocalization.maxWeight),
                    //   style: TextStyle(
                    //       fontSize: 20.sp,
                    //       fontWeight: FontWeight.bold,
                    //       color: Theme.of(context).brightness == Brightness.dark
                    //           ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    //           : HexColor.fromHex('#384341')),
                    //   maxLines: 1,
                    //   minFontSize: 10,
                    // ),
                    child: Body1AutoText(
                      text: stringLocalization.getText(StringLocalization.maxWeight),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      minFontSize: 10,
                      // maxLine: 1,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.only(
                    top: 16.h,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Container(
                          height: 55.h,
                          child: Body1AutoText(
                            text: stringLocalization.getText(StringLocalization.initialWeightInfo),
                            maxLine: 2,
                            fontSize: 16.sp,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            minFontSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: Key('OkInfoDialog'),
                            onTap: onClickOkInitialWeightInfo,
                            child: Container(
                              margin: EdgeInsets.only(right: 10.w),
                              height: 25.h,
                              // child: FittedBox(
                              //   child: Text(
                              //     stringLocalization
                              //         .getText(StringLocalization.ok)
                              //         .toUpperCase(),
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 14.sp,
                              //       color: HexColor.fromHex('#00AFAA'),
                              //     ),
                              //     // minFontSize: 8,
                              //     maxLines: 1,
                              //   ),
                              // ),
                              child: TitleText(
                                text:
                                    stringLocalization.getText(StringLocalization.ok).toUpperCase(),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: HexColor.fromHex('#00AFAA'),
                                // maxLine: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ])));
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  void onClickOkInitialWeightInfo() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget skinTypeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15.0.h),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.skinPhotoType),
              maxLine: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(left: 15.0.w),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,

              /// Added by: Akhil
              /// Added on: April/05/2021
              /// this selector is responsible for building Skin Phototype field
              child: Selector<ProfileModel, String>(
                selector: (context, model) => model.selectedColor!,
                builder: (context, selectedColor, child) => Row(
                  children: List<Widget>.generate(profileModel.colorList!.length, (index) {
                    return InkWell(
                      key: Key('profileSkinType$index'),
                      onTap: () {
                        if (selectedColor != profileModel.colorList![index]) {
                          isEdit = true;
                        }
                        // : isEdit = false;
                        // profileModel.updateIsEdit(isEdit);
                        profileModel.isEdit = isEdit;
                        profileModel.updateSelectedColor(profileModel.colorList![index]);
                        globalUser?.skinType = profileModel.selectedColor;
                        // setState(() {});
                      },
                      child: Container(
                        height: 24.0.h,
                        width: 28.0.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: profileModel.colorList![index] == selectedColor
                                  ? Colors.black
                                  : Colors.transparent),
                          color: fromHex(profileModel.colorList![index]),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method used to open date picker dialog bor birth date
  selectBirthDate() async {
    var newFormat = new DateFormat.yMMMMd('zh_HK');
    var date = DateTime.now();

    var picked = await showCustomDatePicker(
      context: context,
      useRootNavigator: true,
      initialDate: profileModel.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(date.year - 101, date.month, date.day),
      lastDate: DateTime(date.year - 12, date.month, date.day),
      fieldHintText: stringLocalization.getText(StringLocalization.enterDate),
      // initialDatePickerMode: DatePickerMode.year,
      getDatabaseDataFrom: '',
    );
    if (picked != null) {
      if (profileModel.dateOfBirth != picked) {
        isEdit = true;
      }
      // : isEdit = false;
      // profileModel.updateIsEdit(isEdit);
      profileModel.isEdit = isEdit;
      profileModel.updateDOB(picked);
      globalUser?.dateOfBirth = picked;
    }
//    dateOfBirth = '${selectedDate.day} ${selectedDate.month} ${selectedDate.year}';
//     setState(() {});
  }

  Future savePreferenceInServer() async {
    var url = Constants.baseUrl + 'StorePreferenceSettings';
    // if (userId == null) {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    // }
    // final result =
    //     await SaveAndGetLocalSettings().savePreferencesInServer(url, userId);
    final storeResult = await PreferenceRepository().storePreferenceSettings(userId);
    return Future.value();
  }

  Widget cancelSaveButton() {
    /// Added by: Akhil
    /// Added on: April/05/2021
    /// this selector is responsible for building Cancel and Save button
    /// when profile is edited(indicated by isEdit)
    return Selector<ProfileModel, bool>(
      selector: (context, model) => model.isEdit!,
      builder: (context, isEdited, child) => !profileModel.isLoadForLocalDb!
          ? Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              margin: EdgeInsets.only(bottom: 25.h),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        color: isEdit ? HexColor.fromHex('#00AFAA') : Colors.grey.withOpacity(0.7),
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
                        key: Key('saveProfile'),
                        borderRadius: BorderRadius.circular(30.h),
                        splashColor: HexColor.fromHex('#00AFAA'),
                        onTap: isEdit
                            ? () async {
                                if (!profileModel.savingData) {
                                  profileModel.savingData = true;
                                  await onClickSave().then((value) {
                                    savePreferenceInServer();
                                    /*if (mounted) {
                                      Navigator.of(context).pop();
                                    }*/
                                    // Scaffold.of(context).showSnackBar(
                                    //     SnackBar(content: Text('Saved Profile Information')));
                                  });
                                }
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
                          color: isEdit
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
                          onTap: isEdit
                              ? () async {
                                  profileModel.user =
                                      await dbHelper.getUser(profileModel.userId.toString());
                                  isEdit = false;
                                  // profileModel.updateIsEdit(isEdit);
                                  profileModel.isEdit = isEdit;
                                  profileModel.profileWeightUnit =
                                      preferences?.getInt(Constants.wightUnitKey) ?? 1;
                                  profileModel.profileHeightUnit =
                                      preferences?.getInt(Constants.mHeightUnitKey) ?? 0;
                                  setDefaultData(user: profileModel.user!);
                                  // profileModel.updateUser(await dbHelper
                                  //     .getUser(profileModel.userId.toString()));
                                  // if (this.mounted) setState(() {});
                                }
                              : null,
                          child: Container(
                            key: Key('cancelProfile'),
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
                              // child: AutoSizeText(
                              //   stringLocalization
                              //       .getText(StringLocalization.cancel)
                              //       .toUpperCase(),
                              //   style: TextStyle(
                              //     fontSize: 16.sp,
                              //     fontWeight: FontWeight.bold,
                              //     color: Theme.of(context).brightness ==
                              //             Brightness.dark
                              //         ? HexColor.fromHex('#111B1A')
                              //         : Colors.white,
                              //   ),
                              //   maxLines: 1,
                              //   minFontSize: 10,
                              // ),
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
            )
          : Container(height: 0.0),
    );
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method used to show dialog to provide options for choose picture
  showImagePickerDialog() {
    var dialog = Dialog(
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
                    ? HexColor.fromHex('#111B1A')
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
            width: 309.w,
            height: 200.h,
            child: ListView(
              children: ListTile.divideTiles(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.15)
                    : HexColor.fromHex('#D9E0E0'),
                context: context,
                tiles: [
                  photoLibrary(),
                  takePhoto(),
                  removePhoto(),
                ],
              ).toList(),
              physics: NeverScrollableScrollPhysics(),
            )));
    showDialog(context: context, useRootNavigator: true, builder: (context) => dialog);
  }

  Widget photoLibrary() {
    return Container(
      height: 69.h,
      child: Center(
        child: ListTile(
            key: Key('photoLibrary'),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              chooseFromGallery();
            },
            trailing: Image.asset('asset/gallery_icon.png',
                height: 33.h,
                width: 33.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#62CBC9')
                    : null),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.photoLibrary),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            )),
      ),
    );
  }

  Widget takePhoto() {
    return Container(
      height: 64.h,
      child: Center(
        child: ListTile(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              takePicture();
            },
            trailing: Image.asset('asset/camera_icon.png',
                height: 33.h,
                width: 33.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#62CBC9')
                    : null),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.takePhoto),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            )),
      ),
    );
  }

  Widget removePhoto() {
    return Container(
      height: 67.h,
      child: ListTile(
        key: Key('removePhoto'),
        title: Center(
          child: Text(
            stringLocalization.getText(StringLocalization.remove),
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: profileModel.base64DecodedImage != null
                    ? HexColor.fromHex('#00AFAA')
                    : HexColor.fromHex('#D3D3D3')),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: profileModel.base64DecodedImage != null
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                removePicture();
                CustomSnackBar.buildSnackbar(context, 'Profile Image Removed', 3);
              }
            : null,
      ),
    );
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// redirect to camera and take photo for profile picture
  takePicture() async {
    var imageFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 100);
    if (imageFile != null) {
      // isEdit = true;
      // profileModel.updateIsEdit(isEdit);
      await _cropImage(File(imageFile.path));
      //  base64DecodedImage = imageFile.readAsBytesSync();
    }
    // profileModel.isRemove = false;
    profileModel.updateIsRemove(false);
    // setState(() {});
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// redirect to gallery and take photo for profile picture
  chooseFromGallery() async {
    var imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      // imageQuality: 100
    );
    if (imageFile != null) {
      // isEdit = true;
      // profileModel.updateIsEdit(isEdit);
      await _cropImage(File(imageFile.path));
      // base64DecodedImage = imageFile.readAsBytesSync();
    }
    // profileModel.isRemove = false;
    profileModel.updateIsRemove(false);
    // setState(() {});
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// use to remove current profile picture
  removePicture() {
    if (profileModel.base64DecodedImage != null && profileModel.base64DecodedImage!.isNotEmpty) {
      isEdit = true;
    }
    profileModel.isEdit = isEdit;
    // profileModel.updateIsEdit(isEdit);
    profileModel.base64DecodedImage = null;

    /// variable used to show that image is changed
    profileModel.profileImageChangeIndicator = !profileModel.profileImageChangeIndicator!;
    // profileModel.updateImage(null);
    // profileModel.isRemove = true;
    profileModel.updateIsRemove(true);
    globalUser?.picture = '';
    // setState(() {});
  }

  Future<Null> _cropImage(File imageFile) async {
    var croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      imageFile = File(croppedFile.path);
      // profileModel.base64DecodedImage = imageFile.readAsBytesSync();
      isEdit = true;
      CustomSnackBar.buildSnackbar(context, 'Profile Image Updated', 3);
      profileModel.isEdit = isEdit;
      // profileModel.updateIsEdit(isEdit);
      // profileModel.updateImage(imageFile.readAsBytesSync());
      profileModel.base64DecodedImage = imageFile.readAsBytesSync();

      /// variable used to show that image is changed
      profileModel.profileImageChangeIndicator = !profileModel.profileImageChangeIndicator!;
      var base64Image = base64Encode(profileModel.base64DecodedImage!);
      globalUser?.picture = base64Image;
      print(profileModel.base64DecodedImage);
      // setState(() {});
    }
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method update user information to server as well as local db. if internet is not placed then it will store in local db as un-sync data
  /// and automatically post to server when user came back with internet.
  Future<void> onClickSave() async {
    isEdit = false;
    profileModel.isEdit = isEdit;
    // profileModel.updateIsEdit(isEdit);
    preferences?.setInt(Constants.wightUnitKey, profileModel.profileWeightUnit!);
    profileModel.user?.weightUnit = profileModel.profileWeightUnit;
    preferences?.setInt(Constants.mHeightUnitKey, profileModel.profileHeightUnit!);
    profileModel.onClose();
    isInternet = await Constants.isInternetAvailable();

    saveUnitInServer();
    profileModel.user?.isSync = 0;
    if (profileModel.isRemove ?? false) {
      profileModel.user!.isRemove = 1;
    }
    if (profileModel.base64DecodedImage != null) {
      var base64Image = base64Encode(profileModel.base64DecodedImage!);
      profileModel.user?.picture = base64Image;
    }

    profileModel.user?.dateOfBirth = profileModel.dateOfBirth != null
        ? profileModel.dateOfBirth
        : profileModel.user?.dateOfBirth;

    // user.unit = weightUnit == 0 ? 1 : 2;
    profileModel.user?.gender = profileModel.gender;
    profileModel.user?.height = '$centimetre';
    profileModel.user?.weight = '$kg';
    profileModel.user?.maxWeight = '$maxKg';

    if (profileModel.selectedColor != null) {
      profileModel.user?.skinType = profileModel.selectedColor;
    }
    profileModel.user?.isResearcherProfile = profileModel.isResearcherProfile;
    OverlayEntry? entry;
    await dbHelper.insertUser(
        profileModel.user!.toJsonForInsertUsingSignInOrSignUp(), profileModel.userId!);
    if (isInternet ?? false) {
      //region online

      entry = showOverlay(context);
      await postDataToAPI().then((value) {
        dbHelper.insertUser(
            profileModel.user!.toJsonForInsertUsingSignInOrSignUp(), profileModel.userId!);
      });
      entry.remove();
      entry = null;
      //endregion
    }

//    if(isResearcherProfile){
//      preferences?.setBool(Constants.isTrainingEnableKey, false);
//    } else{
//      preferences?.setBool(Constants.isEstimatingEnableKey, false);
//      preferences?.setBool(Constants.isOscillometricEnableKey, false);
//    }
    sendDataToSDK();
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method post user information to server
  Future postDataToAPI() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    // Map<String, dynamic> map = {
    //   "UserID": profileModel.userId.toString(),
    //   "FirstName": profileModel.user?.firstName.toString(),
    //   "LastName": profileModel.user?.lastName.toString(),
    //   "Gender": profileModel.gender.toString(),
    //   "UnitID": profileModel.unit == Strings().metric ? 1 : 2,
    //   "DateOfBirth": DateFormat(DateUtil.yyyyMMdd).format(profileModel.dateOfBirth!),
    //   "Picture": profileModel.isRemove ?? false
    //       ? null
    //       : profileModel.user?.picture ?? "".toString(),
    //   "Height": "$centimetre",
    //   "Weight": kg,
    //   "InitialWeight": maxKg,
    //   "SkinType":
    //       profileModel.selectedColor != null ? profileModel.selectedColor : "",
    //   "IsUpdate": false,
    //   "IsResearcherProfile": profileModel.isResearcherProfile,
    //   "UserMeasurementTypeID": preferences?.getInt(Constants.measurementType),
    // };
    // if (!profileModel.isRemove! && profileModel.base64DecodedImage != null) {
    //   map["IsUpdate"] = true;
    //   String base64Image = base64Encode(profileModel.base64DecodedImage!);
    //   map["UserImage"] = base64Image;
    // } else if (profileModel.isRemove!) {
    //   map["IsUpdate"] = true;
    //   map["UserImage"] = "";
    // }

    var requestData = EditUserRequest(
        userID: profileModel.userId.toString(),
        firstName: profileModel.user?.firstName.toString(),
        lastName: profileModel.user?.lastName.toString(),
        gender: profileModel.gender.toString(),
        dateOfBirth: DateFormat(DateUtil.yyyyMMdd).format(profileModel.dateOfBirth!),
        unitID: profileModel.unit == Strings().metric ? 1 : 2,
        picture:
            profileModel.isRemove ?? false ? null : profileModel.user?.picture ?? ''.toString(),
        height: '$centimetre',
        weight: kg.toString(),
        skinType: profileModel.selectedColor != null ? profileModel.selectedColor : '',
        isUpdate: false,
        initialWeight: maxKg.toString(),
        isResearcherProfile: profileModel.isResearcherProfile,
        userMeasurementTypeID: preferences?.getInt(Constants.measurementType),
        weightUnit: (profileModel.profileWeightUnit ?? UnitTypeEnum.metric.getValue()),
        heightUnit: (profileModel.user?.heightUnit ?? UnitTypeEnum.metric.getValue()),
        bmi: oldWeight == kg ? null : calculateBMI(kg));
    if (!profileModel.isRemove! && profileModel.base64DecodedImage != null) {
      requestData.isUpdate = true;
      var base64Image = base64Encode(profileModel.base64DecodedImage!);
      requestData.userImage = base64Image;
    } else if (profileModel.isRemove!) {
      requestData.isUpdate = true;
      requestData.userImage = '';
    }
    log(requestData.toJson().toString());
    var response = await UserRepository().editUser(requestData);
    if (response.hasData) {
      Constants.progressDialog(false, context);
      if (response.getData!.result!) {
        if (response.getData!.data != null) {
          profileModel.user = UserModel.mapper(response.getData!.data!);
          profileModel.user?.isSync = 1;
        } else {
          profileModel.user?.isSync = 1;
        }
      } else {
        if (scaffoldKey.currentState != null) {
          CustomSnackBar.CurrentBuildSnackBar(
              context,
              StringLocalization.of(context)
                  .getText(stringLocalization.getText(StringLocalization.somethingWentWrong)));
        }
      }
    }
  }

  double calculateBMI(double weight) {
    var bMI = 15.4;
    try {
      var ht = double.parse(centimetre.toString()) / 100;
      bMI = (weight / (ht * ht));
      print(bMI);
    } on Exception catch (e) {
      print(e);
    }
    return bMI;
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method clear shared preference and sign out user
  void logout() async {
    if (profileModel.userId == null) {
      await getPref();
    }
    await AppService.getInstance.logoutUser();
    isEdit
        ? backDialog(true, onClickYes: () {
            onClickSave();
            Constants.navigatePushAndRemove(SignInScreen(), context, rootNavigation: true);
          })
        : print('logout');
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method used to get user id from shared preference
  Future getPref() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    print('abc');
    profileModel.userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    try {
      var wU = preferences?.getInt(Constants.wightUnitKey) ?? 1;
      profileModel.profileWeightUnit = wU;
    } catch (e) {}
    try {
      var hU = preferences?.getInt(Constants.mHeightUnitKey) ?? 0;
      profileModel.profileHeightUnit = hU;
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    // preferences?.setInt(
    //     Constants.mHeightUnitKey, profileModel.profileHeightUnit);
    // preferences?.setInt(Constants.wightUnitKey, profileModel.profileWeightUnit);
    // saveUnitInServer();
    // profileModel.onClose();
  }

  saveUnitInServer() {
    var list = [
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.wightUnitKey}',
        'Unit':
            '${preferences?.getInt(Constants.wightUnitKey) == 1 ? StringLocalization.kg : StringLocalization.lb}',
        'Value': '${preferences?.getInt(Constants.wightUnitKey)}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mHeightUnitKey}',
        'Unit':
            '${preferences?.getInt(Constants.mHeightUnitKey) == 0 ? StringLocalization.centimetre : StringLocalization.inch}',
        'Value': '${preferences?.getInt(Constants.mHeightUnitKey)}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mDistanceUnitKey}',
        'Unit':
            '${preferences?.getInt(Constants.mDistanceUnitKey) == 0 ? StringLocalization.km : StringLocalization.mileage}',
        'Value': '${preferences?.getInt(Constants.mDistanceUnitKey)}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mTemperatureUnitKey}',
        'Unit':
            '${preferences?.getInt(Constants.mTemperatureUnitKey) == 0 ? StringLocalization.celsiusShort : StringLocalization.fahrenheitShort}',
        'Value': '${preferences?.getInt(Constants.mTemperatureUnitKey)}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
      {
        'UserID': preferences?.getString(Constants.prefUserIdKeyInt),
        'Measurement': '${Constants.mTimeUnitKey}',
        'Unit':
            '${preferences?.getInt(Constants.mTimeUnitKey) == 0 ? StringLocalization.twelve : StringLocalization.twentyFour}',
        'Value': '${preferences?.getInt(Constants.mTimeUnitKey)}',
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
    ];
    var map = {'UnitData': list};
    var request = SetMeasurementUnitRequest.fromJson(map);
    var result = MeasurementRepository().setMeasurementUnit(request);
    // Units().setUnit(Constants.baseUrl + 'SetMeasuremetnUnit', map);
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method used to fetch data from local dbFiand update whenever server data comes.
  Future<void> callApi() async {
    if (profileModel.userId == null) {
      await getPref();
    }
    if (isInternet ?? false) {
      final userDetailResult = await UserRepository().getUSerDetailsByUserID(profileModel.userId!);
      if (userDetailResult.hasData) {
        if (userDetailResult.getData!.result ?? false) {
          profileModel.user = UserModel.mapper(userDetailResult.getData!.data!);
          globalUser = profileModel.user;
          if (preferences != null) {
            preferences?.setInt(
                Constants.measurementType, userDetailResult.getData!.data!.userMeasurementTypeID!);
          } else {
            preferences = await SharedPreferences.getInstance();
            preferences?.setInt(
                Constants.measurementType, userDetailResult.getData!.data!.userMeasurementTypeID!);
          }
          profileModel.isResearcherProfile = profileModel.user?.isResearcherProfile;
          try {
            try {
              if (profileModel.user?.picture != null &&
                  profileModel.user!.picture!.trim().isNotEmpty) {
                var response = await get(Uri(scheme: profileModel.user!.picture));
                profileModel.base64DecodedImage = response.bodyBytes;
                profileModel.user?.picture = base64Encode(profileModel.base64DecodedImage!);
              }
            } catch (e) {
              print("exception in profile screen_3 $e");
            }
            var value = await dbHelper.insertUser(
                profileModel.user!.toJsonForInsertUsingSignInOrSignUp(), profileModel.userId!);
          } catch (e) {
            print("exception in profile screen_4 $e");
          }
          setDefaultData(user: profileModel.user!);
        }
      }
      if (mounted) {
        // setState(() {});
      }
    }
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method used to fetch data from local db
  Future getOfflineData() async {
    profileModel.user = await dbHelper.getUser(profileModel.userId.toString());
    globalUser = profileModel.user;
    profileModel.profileWeightUnit = globalUser!.weightUnit ?? 1;
    if (profileModel.user != null) {
      try {
        // profileModel
        //     .updateIsResearcherProfile(profileModel.user.isResearcherProfile);
        profileModel.isResearcherProfile = profileModel.user?.isResearcherProfile ?? false;
        // profileModel.isResearcherProfile =
        //     profileModel.user.isResearcherProfile;
        if (profileModel.user?.isRemove == 1) {
          // profileModel.updateIsRemove(true);
          // profileModel.updateImage(null);
          profileModel.isRemove = true;
          profileModel.base64DecodedImage = null;
          // profileModel.isRemove = true;
          // profileModel.base64DecodedImage = null;
        } else if (profileModel.user!.picture!.isNotEmpty &&
            !profileModel.user!.picture!.contains('http')) {
          profileModel.base64DecodedImage = base64Decode(profileModel.user!.picture!);
          // profileModel.updateImage(base64Decode(profileModel.user.picture));
          // profileModel.base64DecodedImage =
          //     base64Decode(profileModel.user.picture);
        }
      } catch (e) {
        print('exception in profile screen_5 $e');
      }
      setDefaultData(user: profileModel.user!);
    }
    return;
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// @user this user model contains all user information like profile, username, height , weight, etc.
  /// this method set data into view from user model.
  setDefaultData({UserModel? user, String? field}) async {
    try {
      if (user != null) {
        if (field != null && field.isNotEmpty) {
          if (field == 'height') {
            if (user.height != null && user.height!.isNotEmpty) {
              try {
                // centimetre = double.parse(user.height).toInt();
                // profileModel
                //     .updateProfileCentimetre(double.parse(user.height).toInt());
                profileModel.profileCentimetre = double.parse(user.height!).toInt();
                var inches = (profileModel.profileCentimetre! / 2.54).round();
                // feet = inches ~/ 12;
                // inch = inches % 12;
                // profileModel.updateProfileFeet(inches ~/ 12);
                // profileModel.updateProfileInch(inches % 12);
                profileModel.profileFeet = inches ~/ 12;
                profileModel.profileInch = inches % 12;
              } catch (e) {
                print('exception in profile screen_6 $e');
              }
            } else {
              profileModel.profileCentimetre = 150;
              profileModel.profileFeet = 5;
              profileModel.profileInch = 0;
            }
          } else if (field == 'weight') {
            try {
              if (user.weight != null && user.weight!.isNotEmpty) {
                kg = double.parse(user.weight!);
                // pound = (double.parse(user.weight!) * 2.205).round();
                pound = (double.parse(user.weight!) * 2.20462);
                if (user.maxWeight != null && user.maxWeight!.isNotEmpty) {
                  profileModel.profileMaxKg = double.parse(user.maxWeight!);
                  // profileModel.profileMaxPound = (double.parse(user.maxWeight!) * 2.205).round();
                  profileModel.profileMaxPound = (double.parse(user.maxWeight!) * 2.20462);
                }
                // profileModel.updateProfileKg(kg);
                profileModel.profileKg = double.parse(user.weight!);
                // profileModel.profilePound = (double.parse(user.weight!) * 2.205).round();
                profileModel.profilePound = (double.parse(user.weight!) * 2.20462);

                // profileModel.updateProfilePound(pound);
              } else {
                profileModel.profileKg = 50;
                profileModel.profilePound = 110;
                kg = 50;
                pound = 110;
              }
            } catch (e) {
              print('exception in profile screen_7 $e');
            }
          }
        } else {
          if (user.gender != null && user.gender!.isNotEmpty) {
            globalUser?.gender = user.gender;
            // profileModel.updateGender(user.gender);
            profileModel.gender = user.gender;

            /// variable used to show that image is changed
            profileModel.profileImageChangeIndicator = !profileModel.profileImageChangeIndicator!;
            // profileModel.gender = user.gender;
          } else {
            profileModel.gender = 'M';
            setState(() {
              globalUser?.gender = 'M';
            });
          }
          if (user.dateOfBirth != null) {
            // profileModel.dateOfBirth = user.dateOfBirth;
            // profileModel.updateDOB(user.dateOfBirth);
            profileModel.dateOfBirth = user.dateOfBirth;
          } else {
            profileModel.dateOfBirth = DateTime(1900);
          }

          if (user.height != null && user.height!.isNotEmpty) {
            try {
              // centimetre = double.parse(user.height).toInt();
              // profileModel
              //     .updateProfileCentimetre(double.parse(user.height).toInt());
              profileModel.profileCentimetre = double.parse(user.height!).toInt();
              var inches = (profileModel.profileCentimetre! / 2.54).round();
              // feet = inches ~/ 12;
              // inch = inches % 12;
              // profileModel.updateProfileFeet(inches ~/ 12);
              // profileModel.updateProfileInch(inches % 12);
              profileModel.profileFeet = inches ~/ 12;
              profileModel.profileInch = inches % 12;
            } catch (e) {
              print('exception in profile screen_8 $e');
            }
          } else {
            profileModel.profileCentimetre = 150;
            profileModel.profileFeet = 5;
            profileModel.profileInch = 0;
          }

          try {
            if (user.weight != null && user.weight!.isNotEmpty) {
              kg = double.parse(user.weight!);
              // pound = (double.parse(user.weight!) * 2.205).round();
              pound = (double.parse(user.weight!) * 2.20462);
              // profileModel.updateProfileKg(kg);
              profileModel.profileKg = double.parse(user.weight!);
              profileModel.profilePound = (double.parse(user.weight!) * 2.20462);
              // profileModel.profilePound = (double.parse(user.weight!) * 2.205).round();
              // profileModel.updateProfilePound(pound);
            } else {
              profileModel.profileKg = 50;
              profileModel.profilePound = 110;
              kg = 50;
              pound = 110;
            }
          } catch (e) {
            print('exception in profile screen_9 $e');
          }

          try {
            if (user.maxWeight != null && user.maxWeight!.isNotEmpty) {
              maxKg = double.parse(user.maxWeight!);
              // maxPound = (double.parse(user.maxWeight!) * 2.205).round();
              maxPound = (double.parse(user.maxWeight!) * 2.20462);
              // profileModel.updateProfileMaxKg(maxKg);
              // profileModel.updateProfileMaxPound(maxPound);
              profileModel.profileMaxKg = double.parse(user.maxWeight!);
              // profileModel.profileMaxPound = (double.parse(user.maxWeight!) * 2.205).round();
              profileModel.profileMaxPound = (double.parse(user.maxWeight!) * 2.20462);
            } else {
              profileModel.profileMaxKg = 50;
              profileModel.profileMaxPound = 110;
              maxKg = 50;
              maxPound = 110;
            }
          } catch (e) {
            print('exception in profile screen_10 $e');
          }

          try {
            if (user.picture != null && user.picture!.isNotEmpty) {
              // profileModel.base64DecodedImage = base64Decode(user.picture);
              // profileModel.updateImage(base64Decode(user.picture));
              if (user.picture.toString().startsWith('https')) {
                profileModel.profilePic = user.picture;
              } else {
                profileModel.base64DecodedImage = base64Decode(user.picture!);
              }
            } else {
              profileModel.base64DecodedImage = null;
            }
          } catch (e) {
            print('exception in profile screen_11 $e');
          }
          if (user.skinType != null && user.skinType!.isNotEmpty) {
            // profileModel.updateSelectedColor(user.skinType);
            profileModel.selectedColor = user.skinType;
            // profileModel.selectedColor = user.skinType;
          } else {
            profileModel.selectedColor = '';
            setState(() {
              globalUser?.skinType = '';
            });
          }
          if (user.isResearcherProfile != null) {
            profileModel.isResearcherProfile = user.isResearcherProfile;
            // profileModel.updateIsResearcherProfile(user.isResearcherProfile);
            // profileModel.isResearcherProfile = user.isResearcherProfile;
          }
        }
        sendDataToSDK();
        profileModel.updateIsLoadForLocalDb(false);
        // profileModel.isLoadForLocalDb = false;
        // profileModel.isLoadForLocalDb = false;
      }
    } catch (e) {
      print('exception in profile screen_12 $e');
    }
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method check that device is connected and if connected then it will set those profile information to bracelet.
  Future sendDataToSDK() async {
    try {
      await connections.checkAndConnectDeviceIfNotConnected().then((value) {
        profileModel.connectedDevice = value;
      });
      if (profileModel.connectedDevice != null) {
        Map map = {
          'Height': profileModel.profileCentimetre,
          'Weight': kg,
          'Age': calculateAge(profileModel.dateOfBirth!),
          'Gender': profileModel.gender == 'M',
        };
        connections.setUserData(map);

        var color = 0x00;
        if (profileModel.selectedColor != null) {
          var index = profileModel.colorList!.indexOf(profileModel.selectedColor);
          if (index > -1) {
            switch (index) {
              case 0:
                color = 0x05;
                break;
              case 1:
                color = 0x03;
                break;
              case 2:
                color = 0x02;
                break;
              case 3:
                color = 0x01;
                break;
              case 4:
                color = 0x00;
                break;
            }
            connections.setSkinType(color);
          }
        }
      }
    } catch (e) {
      print('exception in profile screen_13 $e');
    }
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method check internet
  checkInternet() async {
    if (profileModel.userId == null) {
      await getPref();
    }
    isInternet = await Constants.isInternetAvailable();
    await getOfflineData();
    if (isInternet ?? false) {
      if (profileModel.user != null &&
          profileModel.user?.isSync != null &&
          profileModel.user!.isSync == 0) {
        postDataToAPI().then((_) {
          callApi();
        });
      } else {
        // callApi();
      }
    }
    if (mounted) {
      // profileModel.updateDOB(profileModel.dateOfBirth);
      // setState(() {});
    }
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this method convert hex string to Color
  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// @birthDate is date of birth in type of DateTime
  /// this method calculate age from birthdate
  calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  ///Added by shahzad
  ///Added on: 09/10/2020
  ///this method let the user to fill password to be a researcher
  researcherProfileDialog({required GestureTapCallback onClickOk}) {
    var dialog = AlertDialog(
      title: Text(stringLocalization.getText(StringLocalization.enterPassword)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Body1Text(
                text: stringLocalization.getText(StringLocalization.enterPasswordText), maxLine: 2),
            SizedBox(height: 15.0),
            TextFormField(
              controller: profileModel.researcherProfileTextEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: stringLocalization.getText(StringLocalization.enterPassword),
                labelText: stringLocalization.getText(StringLocalization.enterPassword),
              ),
            ),
            SizedBox(height: 15.0.h),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedBtn(
                    onPressed: onClickOk,
                    text: stringLocalization.getText(StringLocalization.ok),
                    elevation: 0,
                  ),
                ),
                SizedBox(width: 10.0.w),
                Expanded(
                  child: RaisedBtn(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    text: stringLocalization.getText(StringLocalization.cancel),
                    elevation: 0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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

  bool validatePassword({String password = ''}) {
    if (password == '112233') {
      return true;
    }
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     stringLocalization.getText(StringLocalization.wrongPassword),
    //     textAlign: TextAlign.center,
    //   ),
    // ));
    CustomSnackBar.buildSnackbar(
        context, stringLocalization.getText(StringLocalization.wrongPassword), 3);
    // setState(() {});
    return false;
  }

  ///Added by: Shahzad
  ///Added on: 02/11/2020
  ///this method is used to show circular loading screen
  OverlayEntry showOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
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

  ///Added by: Shahzad
  ///added on: 16th nov 2020
  ///dialog box to confirm getting back when changes are not saved
  backDialog(bool isLogout, {required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
      title: stringLocalization.getText(StringLocalization.changesNotSaved),
      subTitle: stringLocalization.getText(StringLocalization.notSavedDescription),
      maxLine: 2,
      onClickYes: onClickYes,
      onClickNo: () {
        Navigator.of(context, rootNavigator: true).pop();
        if (isLogout) {
          Constants.navigatePushAndRemove(SignInScreen(), context, rootNavigation: true);
        } else {
          isEdit = false;
          profileModel.isEdit = isEdit;
          // profileModel.updateIsEdit(isEdit);
          Navigator.of(context).pop();
        }
      },
    );
    // var dialog = Dialog(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.h),
    //     ),
    //     elevation: 0,
    //     backgroundColor: Theme.of(context).brightness == Brightness.dark
    //         ? HexColor.fromHex('#111B1A')
    //         : AppColor.backgroundColor,
    //     child: Container(
    //         decoration: BoxDecoration(
    //             color: Theme.of(context).brightness == Brightness.dark
    //                 ? HexColor.fromHex('#111B1A')
    //                 : AppColor.backgroundColor,
    //             borderRadius: BorderRadius.circular(10.h),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Theme.of(context).brightness == Brightness.dark
    //                     ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
    //                     : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
    //                 blurRadius: 5,
    //                 spreadRadius: 0,
    //                 offset: Offset(-5, -5),
    //               ),
    //               BoxShadow(
    //                 color: Theme.of(context).brightness == Brightness.dark
    //                     ? HexColor.fromHex('#000000').withOpacity(0.75)
    //                     : HexColor.fromHex('#384341').withOpacity(0.9),
    //                 blurRadius: 5,
    //                 spreadRadius: 0,
    //                 offset: Offset(5, 5),
    //               ),
    //             ]),
    //         padding: EdgeInsets.only(top: 27.h, left: 16.w, right: 10.w),
    //         height: 188.h,
    //         width: 309.w,
    //         child:
    //             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 10.w),
    //             child: Container(
    //               height: 25.h,
    //               // child: FittedBox(
    //               //   fit: BoxFit.scaleDown,
    //               //   alignment: Alignment.centerLeft,
    // child: Text(
    //   stringLocalization
    //       .getText(StringLocalization.changesNotSaved),
    //               //     style: TextStyle(
    //               //         fontSize: 20.sp,
    //               //         fontWeight: FontWeight.bold,
    //               //         color: Theme.of(context).brightness ==
    //               //                 Brightness.dark
    //               //             ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
    //               //             : HexColor.fromHex('#384341')),
    //               //     maxLines: 1,
    //               //     // minFontSize: 10,
    //               //   ),
    //               // ),
    //               child: FittedTitleText(
    //                 text: stringLocalization
    //                     .getText(StringLocalization.changesNotSaved),
    //                 fontSize: 20.sp,
    //                 fontWeight: FontWeight.bold,
    //                 color: Theme.of(context).brightness == Brightness.dark
    //                     ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
    //                     : HexColor.fromHex('#384341'),
    //                 // maxLine: 1,
    //               ),
    //             ),
    //           ),
    //           Container(
    //               padding: EdgeInsets.only(
    //                 top: 16.h,
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   Padding(
    //                     padding: EdgeInsets.symmetric(horizontal: 10.w),
    //                     child: Container(
    //                       height: 55.h,
    //                       child: Body1AutoText(
    // text: stringLocalization.getText(
    //     StringLocalization.notSavedDescription),
    //                         maxLine: 2,
    //                         fontSize: 16.sp,
    //                         color: Theme.of(context).brightness ==
    //                                 Brightness.dark
    //                             ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
    //                             : HexColor.fromHex('#384341'),
    //                         minFontSize: 10,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 15.h,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       InkWell(
    //                         onTap: ,
    //                         child: Container(
    //                           height: 23.h,
    //                           width: 80.w,
    //                           // child: FittedBox(
    //                           //   fit: BoxFit.scaleDown,
    //                           //   alignment: Alignment.centerLeft,
    //                           //   child: Text(
    //                           //     stringLocalization
    //                           //         .getText(StringLocalization.cancel)
    //                           //         .toUpperCase(),
    //                           //     style: TextStyle(
    //                           //       fontWeight: FontWeight.bold,
    //                           //       fontSize: 14.sp,
    //                           //       color: HexColor.fromHex('#00AFAA'),
    //                           //     ),
    //                           //     // minFontSize: 8,
    //                           //     maxLines: 1,
    //                           //     textAlign: TextAlign.right,
    //                           //   ),
    //                           // ),
    //                           child: FittedTitleText(
    //                             text: stringLocalization
    //                                 .getText(StringLocalization.cancel)
    //                                 .toUpperCase(),
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 14.sp,
    //                             color: HexColor.fromHex('#00AFAA'),
    //                             // maxLine: 1,
    //                             align: TextAlign.right,
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         width: 27.w,
    //                       ),
    //                       InkWell(
    //                         onTap: onClickYes,
    //                         child: Container(
    //                           height: 23.h,
    //                           width: 39.w,
    //                           // child: FittedBox(
    //                           //   fit: BoxFit.scaleDown,
    //                           //   alignment: Alignment.centerLeft,
    //                           //   child: Text(
    //                           //     stringLocalization
    //                           //         .getText(StringLocalization.yes)
    //                           //         .toUpperCase(),
    //                           //     style: TextStyle(
    //                           //       fontWeight: FontWeight.bold,
    //                           //       fontSize: 14.sp,
    //                           //       color: HexColor.fromHex('#00AFAA'),
    //                           //     ),
    //                           //     maxLines: 1,
    //                           //     // minFontSize: 8,
    //                           //   ),
    //                           // ),
    //                           child: FittedTitleText(
    //                             text: stringLocalization
    //                                 .getText(StringLocalization.yes)
    //                                 .toUpperCase(),
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 14.sp,
    //                             color: HexColor.fromHex('#00AFAA'),
    //                             // maxLine: 1,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ))
    //         ])));
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
  ///added on: 15th feb 2021
  ///this function changes the unit of height
  onTapHeightUnit() {
    // profileModel.profileHeightUnit = profileModel.profileHeightUnit == 0 ? 1 : 0;
    isEdit = true;
    profileModel.isEdit = isEdit;
    profileModel.updateProfileHeightUnit(profileModel.profileHeightUnit == 0 ? 1 : 0);
    // profileModel.updateIsEdit(isEdit);
//    preferences?.setInt(Constants.mHeightUnitKey, heightUnit);
//     setState(() {});
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}
