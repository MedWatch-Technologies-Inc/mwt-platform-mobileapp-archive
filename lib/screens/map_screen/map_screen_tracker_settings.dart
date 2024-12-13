import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/providers/location_track_provider.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class MapScreenTrackerSettings extends StatefulWidget {
  const MapScreenTrackerSettings({Key? key}) : super(key: key);

  @override
  _MapScreenTrackerSettingsState createState() =>
      _MapScreenTrackerSettingsState();
}

class _MapScreenTrackerSettingsState extends State<MapScreenTrackerSettings> {
  LocationTrackProvider locationTrackProvider = LocationTrackProvider();
  bool enableAutoPause = false;
  AppImages images = AppImages();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  Future<void> getPrefs() async {
    if (preferences != null) {
      var autoPause = preferences?.getBool('enableAutoPause');
      if (autoPause == null) {
        preferences?.setBool('enableAutoPause', false);
      } else {
        enableAutoPause = autoPause;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
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
                Navigator.of(context).pop();
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                images.leftArrowDark,
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                images.leftArrowLight,
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              'Tracker Setting',
              style: TextStyle(color: HexColor.fromHex('#62CBC9')),
              // .toUpperCase(),
            ),
            centerTitle: true,
            actions: [],
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
              leading: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Image.asset(
                  images.settingIcon,
                  // height: 33,
                  // width: 33,
                ),
              ),
              title: Body1AutoText(
                text: 'Enable Auto Pause',
                fontSize: 16,
                maxLine: 1,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
              ),
              trailing: CustomSwitch(
                value: enableAutoPause,
                onChanged: (value) {
                  preferences?.setBool('enableAutoPause', value);
                  enableAutoPause = value;
                  setState(() {});
                },
                activeColor: HexColor.fromHex('#00AFAA'),
                inactiveTrackColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : HexColor.fromHex('#E7EBF2'),
                inactiveThumbColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.6)
                        : HexColor.fromHex('#D1D9E6'),
                activeTrackColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : HexColor.fromHex('#E7EBF2'),
              ))
        ],
      ),
    );
  }
}
