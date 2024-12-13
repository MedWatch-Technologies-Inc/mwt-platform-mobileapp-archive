
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_screen.dart';


class ResearcherProfileScreen extends StatefulWidget {
  @override
  _ResearcherProfileState createState() => _ResearcherProfileState();
}

class _ResearcherProfileState extends State<ResearcherProfileScreen> {
  bool showMeasurementType = false;
  int? measurementType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreference();
  }

  getPreference() async {
    if (preferences != null) {
      preferences = await SharedPreferences.getInstance();
    }
    measurementType = preferences?.getInt(Constants.measurementType) ?? 2;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
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
                    if (Navigator.canPop(context)) {
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
                title: Text(
                  stringLocalization
                      .getText(StringLocalization.researcherProfileTitle),
                  style: TextStyle(
                      color: HexColor.fromHex('62CBC9'),
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            )),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                ListView(
                  children: [    // measurement(),
                    // bracelet(),

                    Ai(),
                    // hrZone(),
                  ],
                )
              ],
            )));
  }

  Widget measurement() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showMeasurementType = !showMeasurementType;
          if (mounted) {
            setState(() {});
          }
        },
        child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/measurement_type.png',
                height: 33,
                width: 33,
              ),
            ),
            title: Body1AutoText(
              text: stringLocalization
                  .getText(StringLocalization.measurementType),
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: showMeasurementType ? 5 : 10),
                child: Image.asset(
                  !showMeasurementType
                      ? Theme.of(context).brightness == Brightness.dark
                          ? 'asset/right_setting_dark.png'
                          : 'asset/right_setting.png'
                      : Theme.of(context).brightness == Brightness.dark
                          ? 'asset/up_arrow_dark.png'
                          : 'asset/up_arrow_icon.png',
                  height: showMeasurementType ? 10 : 14,
                  width: showMeasurementType ? 20 : 8,
                ))),
      ),
    );
  }

  Widget Ai() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          Constants.navigatePush(AIScreen(), context)
              .then((value) => screen = Constants.settings);
        },
        leading: Padding(
          key: Key('clickOnAIButon'),
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/ai_icon.png',
            height: 33,
            width: 33,
          ),
        ),
        title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.Ai),
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            )));
  }

  Widget bracelet() {
    return Visibility(
      visible: showMeasurementType,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            preferences?.setInt(Constants.measurementType, 1);
            measurementType =
                preferences?.getInt(Constants.measurementType) ?? 1;
            postDataToAPI();
            setState(() {});
          },
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              leading: Image.asset(
                'asset/alarm_icon.png',
                color: Colors.transparent,
              ),
              title: Body1AutoText(text: 'Watch', fontSize: 16),
              trailing: measurementType == 1
                  ? Image.asset(
                      'asset/check_icon.png',
                      height: 33.h,
                      width: 33.h,
                    )
                  : SizedBox(
                      width: 2.w,
                    )),
        ),
      ),
    );
  }


  Future postDataToAPI() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    var requestData = EditUserRequest(
      userID: globalUser?.userId,
      firstName: globalUser?.firstName.toString(),
      lastName: globalUser?.lastName.toString(),
      gender: globalUser?.gender,
      dateOfBirth: DateFormat(DateUtil.yyyyMMdd)
          .format(globalUser?.dateOfBirth ?? DateTime.now()),
      picture: globalUser?.picture,
      height: globalUser?.height,
      weight: globalUser?.weight,
      skinType: globalUser?.skinType,
      isUpdate: false,
      initialWeight: globalUser?.maxWeight,
      isResearcherProfile: true,
      userMeasurementTypeID: preferences?.getInt(Constants.measurementType),
      weightUnit: weightUnit + 1,
      heightUnit: heightUnit + 1,
    );
    // Map<String, dynamic> map = {
    //   "UserID": globalUser?.userId,
    //   "FirstName": globalUser?.firstName.toString(),
    //   "LastName": globalUser?.lastName.toString(),
    //   "Gender": globalUser?.gender,
    //   // "UnitID": globalUser.unit,
    //   "DateOfBirth": DateFormat(DateUtil.yyyyMMdd).format(globalUser?.dateOfBirth ?? DateTime.now()),
    //   "Picture": globalUser?.picture,
    //   "Height": globalUser?.height,
    //   "Weight": globalUser?.weight,
    //   "SkinType": globalUser?.skinType,
    //   "IsUpdate": false,
    //   "InitialWeight": globalUser?.maxWeight,
    //   "IsResearcherProfile": true,
    //   "UserMeasurementTypeID": preferences?.getInt(Constants.measurementType)
    // };
    if (globalUser?.picture != null) {
      requestData.isUpdate = true;
      requestData.userImage = globalUser?.picture;
      // map['IsUpdate'] = true;
      // map['UserImage'] = globalUser?.picture!;
    }

    Constants.progressDialog(true, context);
    var response = await UserRepository().editUser(requestData);
    Constants.progressDialog(false, context);
    if (response.hasData) {
      Constants.progressDialog(false, context);
      if (response.getData!.result!) {
        if (response.getData!.data != null) {
          globalUser = UserModel.mapper(response.getData!.data!);
          globalUser?.isSync = 1;
        } else {
          if (globalUser != null && globalUser!.userId != null) {
            var value = await dbHelper.insertUser(
                globalUser!.toJsonForInsertUsingSignInOrSignUp(),
                globalUser!.userId!);
          }
        }
      }
    } else {
      Constants.progressDialog(false, context);
    }
//    Constants.progressDialog(true, context);
//     var result = await UpdateProfileParser()
//         .callApi(Constants.baseUrl + "EditUser", map);
// //    Constants.progressDialog(false, context);
//     if (!result["isError"]) {
//       print('Profile Updated Successfully');
//       if (result["value"] is UserModel) {
//         globalUser = result["value"];
//         globalUser?.isSync = 1;
//       } else {
//         if(globalUser != null && globalUser!.userId !=null)
//         int value = await dbHelper.insertUser(globalUser!.toJsonForInsertUsingSignInOrSignUp(), globalUser!.userId!);
//       }
//     } else {}
  }
}
