import 'package:flutter/material.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class GlucoseDataFromECGPPG extends StatefulWidget {
  // final user;

  // GlucoseDataFromECGPPG({this.user});

  @override
  _GlucoseDataFromECGPPGState createState() => _GlucoseDataFromECGPPGState();
}

class _GlucoseDataFromECGPPGState extends State<GlucoseDataFromECGPPG> {

  // String? userId;

  @override
  void initState() {
    // TODO: implement initState
    // getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
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
                      : HexColor.fromHex("#384341").withOpacity(0.2),
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
                    "asset/dark_leftArrow.png",
                    width: 13,
                    height: 22,
                  )
                      : Image.asset(
                    "asset/leftArrow.png",
                    width: 13,
                    height: 22,
                  ),
                ),
                title: Text(
                  'Glucose Data',
                  style: TextStyle(
                      color: HexColor.fromHex("62CBC9"),
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            )),
        body:oscillometric());
  }
  var isGlucoseData = false;
  Widget oscillometric() {
    if (preferences != null &&
        preferences?.getBool(Constants.isGlucoseData) != null) {
      isGlucoseData = preferences?.getBool(Constants.isGlucoseData) ?? false ;
    }
    print('isGlucose_ $isGlucoseData');
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        leading: Icon(Icons.bloodtype, color: IconTheme.of(context).color),
        title: Body1AutoText(
            text: 'Glucose Data From ECG & PPG',
            fontSize: 14),
        trailing: Padding(
          padding:EdgeInsets.zero,
          // key:Key('clickOnAIToggle'),
          child:CustomSwitch(
            value: isGlucoseData,
            onChanged: (value) {
                preferences?.setBool(Constants.isGlucoseData, value);
                preferences?.setBool(Constants.isGlucoseData1, value);
              setState(() {

              });
              print('isGlucose_000 $isGlucoseData');
            },
            activeColor: HexColor.fromHex("#00AFAA"),
            inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),
            inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : HexColor.fromHex("#D1D9E6"),
            activeTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),
          ),
        ));
  }



}
