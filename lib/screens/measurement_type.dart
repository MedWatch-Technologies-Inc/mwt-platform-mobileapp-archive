import 'package:flutter/material.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeasurementType extends StatefulWidget {
  bool researcherProfile;
  MeasurementType(this.researcherProfile,{Key? key}) : super(key: key);

  @override
  _MeasurementTypeState createState() => _MeasurementTypeState();
}

class _MeasurementTypeState extends State<MeasurementType> {
  late int measurementType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreference();
  }

  getPreference() async{
    if(preferences != null){
      preferences = await SharedPreferences.getInstance();
    }
    measurementType = preferences?.getInt(Constants.measurementType)??1;
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
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
                      .getText(StringLocalization.measurementType),
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
                  children: ListTile.divideTiles(context: context, tiles: [
                    healthKit(),
                    bracelet(),
                  ]).toList(),
                )
              ],
            )));
  }

  Future postDataToAPI() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    // Map<String, dynamic> map = {
    //   'UserID': globalUser?.userId??'',
    //   'FirstName': globalUser?.firstName?.toString()??'',
    //   'LastName': globalUser?.lastName?.toString()??'',
    //   'Gender': globalUser?.gender??'',
    //   // 'UnitID': globalUser.unit,
    //   'DateOfBirth': DateFormat(DateUtil.yyyyMMdd).format(globalUser?.dateOfBirth??DateTime.now()),
    //   'Picture': globalUser?.picture??'',
    //   'Height': globalUser?.height??'',
    //   'Weight': globalUser?.weight??'',
    //   'SkinType': globalUser?.skinType??'',
    //   'IsUpdate': false,
    //   'InitialWeight': globalUser?.maxWeight??'',
    //   'IsResearcherProfile': widget.researcherProfile,
    //   'UserMeasurementTypeID' : preferences?.getInt(Constants.measurementType)??0
    // };
    // if (globalUser?.picture != null) {
    //   map['IsUpdate'] = true;
    //   map['UserImage'] = globalUser?.picture??'';
    // }
    var requestData = EditUserRequest(
        userID: globalUser!.userId ?? '',
        firstName: globalUser!.firstName.toString(),
        lastName: globalUser!.lastName.toString(),
        gender: globalUser!.gender ?? '',
        dateOfBirth: DateFormat(DateUtil.yyyyMMdd)
            .format(globalUser!.dateOfBirth ?? DateTime.now()),
        unitID: 1,
        picture: globalUser!.picture ?? '',
        height: globalUser!.height ?? '',
        weight: globalUser!.weight ?? '',
        skinType: globalUser!.skinType ?? '',
        isUpdate: false,
        initialWeight: globalUser!.maxWeight ?? '',
        isResearcherProfile: widget.researcherProfile,
        userMeasurementTypeID: preferences?.getInt(Constants.measurementType),
        weightUnit: weightUnit+1,
        heightUnit: heightUnit+1,
    );
    if (globalUser?.picture != null) {
      requestData.isUpdate = true;
      requestData.userImage = globalUser?.picture ?? '';
      // map["IsUpdate"] = true;
      // map["UserImage"] = globalUser?.picture;
    }
    var response = await UserRepository().editUser(requestData);
    if (response.hasData) {
      if (response.getData!.result!) {
        if (response.getData!.data != null) {
          globalUser = UserModel.mapper(response.getData!.data!);
          globalUser?.isSync = 1;
        } else {
          var value = await dbHelper.insertUser(
              globalUser!.toJsonForInsertUsingSignInOrSignUp(),
              globalUser!.userId!);
        }
      }
    } else {}

//    Constants.progressDialog(true, context);
//     var result = await UpdateProfileParser()
//         .callApi(Constants.baseUrl + 'EditUser', map);
// //    Constants.progressDialog(false, context);
//     if (!result['isError']) {
//       if (result['value'] is UserModel) {
//         globalUser = result['value'];
//         globalUser?.isSync = 1;
//       }else{
//         int value = await dbHelper.insertUser(globalUser?.toJsonForInsertUsingSignInOrSignUp()??{}, globalUser?.userId??'');
//       }
//     } else {
//
//     }
  }

  Widget healthKit() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      leading: IconButton(icon: Image.asset('asset/health_kit_icon.png'), onPressed: () {  },),
      title: Body1AutoText(
          text: 'Health Kit',
          fontSize: 14),
      trailing: CustomSwitch(
        value: measurementType == 2 ? true : false,
        onChanged: (value) {
          print(value);
          if(!value){
            preferences?.setInt(Constants.measurementType, 1);
          }else{
            preferences?.setInt(Constants.measurementType, 2);
          }
          measurementType = preferences?.getInt(Constants.measurementType)??1;
          postDataToAPI();
          if(mounted) {
            setState(() {});
          }
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget bracelet() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      leading: IconButton(icon: Image.asset('asset/alarm_icon.png'), onPressed: () {  },),
      title: Body1AutoText(
          text: 'Bracelet',
          fontSize: 14),
      trailing: CustomSwitch(
        value: measurementType == 1 ? true : false,
        onChanged: (value) {
          print(value);
          if(value){
            preferences?.setInt(Constants.measurementType, 1);
          }else{
            preferences?.setInt(Constants.measurementType, 2);
          }
          measurementType = preferences?.getInt(Constants.measurementType)??1;
          postDataToAPI();
          if(mounted) {
            setState(() {});
          }
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }
}
