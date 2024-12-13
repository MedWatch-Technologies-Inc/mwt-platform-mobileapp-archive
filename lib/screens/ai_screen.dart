import 'package:flutter/material.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  _AIScreenState createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  ValueNotifier<bool> isOscillometric = ValueNotifier(false);
  ValueNotifier<bool> isEstimation = ValueNotifier(false);

  @override
  void initState() {
    isOscillometric.value = preferences?.getBool(Constants.isOscillometricEnableKey) ?? false;
    isEstimation.value = preferences?.getBool(Constants.isEstimatingEnableKey) ?? false;
    super.initState();
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
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
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
              stringLocalization.getText(StringLocalization.Ai),
              style: TextStyle(
                color: HexColor.fromHex('62CBC9'),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView(
              children: [
                oscillometric(),
                estimated(),
                // hgEstimated(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget oscillometric() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      leading: Icon(Icons.assessment, color: IconTheme.of(context).color),
      title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.oscillometric),
          fontSize: 14),
      trailing: ValueListenableBuilder(
        valueListenable: isOscillometric,
        builder: (context, bool isOSM, widget) {
          return CustomSwitch(
            value: isOSM,
            onChanged: (value) {
              isOscillometric.value = value;
              preferences?.setBool(Constants.isOscillometricEnableKey, value);
              if (value) {
                isEstimation.value = false;
                preferences?.setBool(Constants.isEstimatingEnableKey, false);
                preferences?.setBool(Constants.isTrainingEnableKey, false);
                preferences?.setBool(Constants.isTrainingEnableKey1, false);
              }
            },
            activeColor: HexColor.fromHex('#00AFAA'),
            inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : HexColor.fromHex('#E7EBF2'),
            inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.6)
                : HexColor.fromHex('#D1D9E6'),
            activeTrackColor: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : HexColor.fromHex('#E7EBF2'),
          );
        },
      ),
    );
  }

  Widget estimated() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      leading: Icon(Icons.ev_station, color: IconTheme.of(context).color),
      title: Body1AutoText(
        text: StringLocalization.of(context).getText(StringLocalization.estimating),
        fontSize: 14,
      ),
      trailing: ValueListenableBuilder(
        valueListenable: isEstimation,
        builder: (context, bool isEST, widget) {
          return CustomSwitch(
            value: isEST,
            onChanged: (value) {
              isEstimation.value = value;
              preferences?.setBool(Constants.isEstimatingEnableKey, value);
              preferences?.setBool(Constants.isEstimatingEnableKey1, value);
              if (value) {
                isOscillometric.value = false;
                preferences?.setBool(Constants.isOscillometricEnableKey, false);
                preferences?.setBool(Constants.isOscillometricEnableKey1, false);
                preferences?.setBool(Constants.isTrainingEnableKey, false);
                preferences?.setBool(Constants.isTrainingEnableKey1, false);
              }
            },
            activeColor: HexColor.fromHex('#00AFAA'),
            inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : HexColor.fromHex('#E7EBF2'),
            inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.6)
                : HexColor.fromHex('#D1D9E6'),
            activeTrackColor: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : HexColor.fromHex('#E7EBF2'),
          );
        },
      ),
    );
  }
}
