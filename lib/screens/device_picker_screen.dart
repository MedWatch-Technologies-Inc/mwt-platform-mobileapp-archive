import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import 'package:mp_chart/mp/controller/controller.dart';

import 'connection_screen.dart';
import 'home/home_screeen.dart';

class DevicePickerScreen extends StatefulWidget {
  final keyName;
  @override
  DevicePickerScreen({Key? key, this.keyName}) : super(key: key);

  _DevicePickerScreenState createState() => _DevicePickerScreenState();
}

class _DevicePickerScreenState extends State<DevicePickerScreen> {
  DeviceModel? connectedDevice;

  @override
  void initState() {
    super.initState();
    connections.checkAndConnectDeviceIfNotConnected().then((value) {
      connectedDevice = value;
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : HexColor.fromHex("#EEF1F1"),
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
                    if (mounted) {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
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
                  stringLocalization.getText(StringLocalization.bluetooth),
                  style: TextStyle(
                      color: HexColor.fromHex("#62CBC9"),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 46.w, right: 46.w, top: 33.h),
                height: 74.h,
                child: Center(
                  // child: AutoSizeText(
                  //   stringLocalization
                  //       .getText(StringLocalization.selectYourDevice)
                  //       .toUpperCase(),
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 24,
                  //     color: Theme.of(context).brightness == Brightness.dark
                  //         ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                  //         : HexColor.fromHex("#384341"),
                  //   ),
                  //   maxLines: 1,
                  //   minFontSize: 14,
                  // ),
                  child: Body1AutoText(
                    text: stringLocalization
                        .getText(StringLocalization.selectYourDevice)
                        .toUpperCase(),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex("#384341"),
                    minFontSize: 14,
                    // maxLine: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 19.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [hg08(), hg66(), hg80()],
                ),
              )
            ],
          ),
        ));
  }

  Widget hg08() {
    return GestureDetector(
      child: Container(
        height: 155.h,
        width: 104.w,
        child: Column(
          children: [
            Container(
              height: 104.h,
              width: 104.w,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#111B1A")
                      : connectedDevice?.sdkType == 1
                          ? HexColor.fromHex("#E5E5E5")
                          : AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                          : Colors.white,
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4, -4),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.75)
                          : HexColor.fromHex("#9F2DBC").withOpacity(0.15),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(4, 4),
                    ),
                  ]),
              child: connectedDevice?.sdkType == 1
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                      HexColor.fromHex("#CC0A00")
                                          .withOpacity(0.15),
                                      HexColor.fromHex("#9F2DBC")
                                          .withOpacity(0.15),
                                    ])
                              : RadialGradient(colors: [
                                  HexColor.fromHex("#FFDFDE").withOpacity(0.5),
                                  HexColor.fromHex("#FFDFDE").withOpacity(0.0)
                                ], stops: [
                                  0.7,
                                  1
                                ])),
                      child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.symmetric(horizontal: 16.w,vertical:16.h),
                          child: Image.asset("asset/HG08.png")),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
                      child: Image.asset("asset/HG08.png")),
            ),
            SizedBox(
              height: 15.h,
            ),
            deviceName(stringLocalization.getText(StringLocalization.hg08Name)),
            connectedDevice?.sdkType == 1
                ? isConnected()
                : Container()
          ],
        ),
      ),
      onTap: () async {
        var result = await Constants.navigatePush(
            ConnectionScreen(
                key: widget.keyName,
                sdkType: Constants.zhBle,
                title: stringLocalization.getText(StringLocalization.hg08Name)),
            context,
            rootNavigation: false);
        await connections.checkAndConnectDeviceIfNotConnected().then((value) {
          connectedDevice = value;
        });
        if (this.mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget hg66() {
    return GestureDetector(
      child: Container(
        height: 155.h,
        width: 104.w,
        child: Column(
          children: [
            Container(
              height: 104.h,
              width: 104.w,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#111B1A")
                    : connectedDevice?.sdkType == 2
                        ? HexColor.fromHex("#E5E5E5")
                        : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(-4, -4),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex("#9F2DBC").withOpacity(0.15),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: connectedDevice?.sdkType == 2
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                      HexColor.fromHex("#CC0A00")
                                          .withOpacity(0.15),
                                      HexColor.fromHex("#9F2DBC")
                                          .withOpacity(0.15),
                                    ])
                              : RadialGradient(colors: [
                                  HexColor.fromHex("#FFDFDE").withOpacity(0.5),
                                  HexColor.fromHex("#FFDFDE").withOpacity(0.0)
                                ], stops: [
                                  0.7,
                                  1
                                ])),
                      child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
                          child: Image.asset("asset/HG66.png")),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
                      child: Image.asset("asset/HG66.png")),
            ),
            SizedBox(
              height: 15.h,
            ),
            deviceName(stringLocalization.getText(StringLocalization.hg66Name)),
            connectedDevice?.sdkType == 2
                ? isConnected()
                : Container()
          ],
        ),
      ),
      onTap: () async {
        var result = await Constants.navigatePush(
            ConnectionScreen(
              key: widget.keyName,
              sdkType: Constants.e66,
              title: stringLocalization.getText(StringLocalization.hg66Name),
            ),
            context,
            rootNavigation: false);
        await connections.checkAndConnectDeviceIfNotConnected().then((value) {
          connectedDevice = value;
        });
        if (this.mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget hg80() {
    return GestureDetector(
      child: Container(
        height: 155.h,
        width: 104.w,
        child: Column(
          children: [
            Container(
              height: 104.h,
              width: 104.w,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#111B1A")
                      : AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                          : Colors.white,
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4, -4),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.75)
                          : HexColor.fromHex("#9F2DBC").withOpacity(0.15),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(4, 4),
                    ),
                  ]),
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
                  child: Image.asset("asset/HG80.png")),
            ),
            SizedBox(
              height: 15.h,
            ),
            deviceName(stringLocalization.getText(StringLocalization.hg80Name)),
          ],
        ),
      ),
      onTap: () async {
        var result = await Constants.navigatePush(
            ConnectionScreen(
              key: widget.keyName,
              sdkType: Constants.e66,
              title: stringLocalization.getText(StringLocalization.hg80Name),
            ),
            context,
            rootNavigation: false);
      },
    );
  }

  Widget deviceName(String name) {
    return SizedBox(
      height: 20.h,
      // child: AutoSizeText(
      //   name,
      //   style: TextStyle(
      //     fontSize: 14,
      //     fontWeight: FontWeight.bold,
      //     color: Theme.of(context).brightness == Brightness.dark
      //         ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
      //         : HexColor.fromHex("#384341"),
      //   ),
      //   // minFontSize: 6,
      //   maxLines: 1,
      // ),
      child: Body1AutoText(
        text: name,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
            : HexColor.fromHex("#384341"),
        minFontSize: 6,
      ),
    );
  }

  Widget isConnected() {
    return SizedBox(
      height: 15.h,
      // child: AutoSizeText(
      //   "Already Connected",
      //   style: TextStyle(
      //     fontSize: 10,
      //     color: Theme.of(context).brightness == Brightness.dark
      //         ? HexColor.fromHex('#FFFFFF').withOpacity(0.38)
      //         : HexColor.fromHex("#7F8D8C"),
      //   ),
      //   maxLines: 1,
      //   minFontSize: 5,
      // ),
      child: Body1AutoText(
        text: "Already Connected",
        fontSize: 10,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#FFFFFF').withOpacity(0.38)
            : HexColor.fromHex("#7F8D8C"),
        minFontSize: 5,
        // maxLine: 1,
      ),
    );
  }

//  /// Added by: Shahzad
//  /// Added on : 26th nov 2020
//  /// Container for HG 08
//  Widget hg08() {
//    return GestureDetector(
//      child: Container(
//          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [
//              Colors.grey.withOpacity(0.4),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//            ],
//          )),
//          child: Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Container(
//                  width: 80,
//                  child: Image.asset(
//                    "asset/HG08.png",
//                    height: 60,
//                    width: 60,
//                  ),
//                ),
//                Text(
//                  "HG 08",
//                  style: TextStyle(
//                      color: HexColor.fromHex("#5D6A68"),
//                      fontSize: 23,
//                      fontWeight: FontWeight.bold),
//                ),
//                Container(
//                  width: 32,
//                  child: Icon(Icons.arrow_forward_ios),
//                ),
//              ],
//            ),
//          )),
//      onTap: () async {
//        var result = await Constants.navigatePush(
//            ConnectionScreen(
//              key: connectionScreenKey,
//              sdkType: Constants.zhBle,
//            ),
//            context,
//            rootNavigation: false);
//      },
//    );
//  }
//
//  /// Added by: Shahzad
//  /// Added on : 26th nov 2020
//  /// Container for HG 66
//  Widget hg66() {
//    return GestureDetector(
//      child: Container(
//          //color: HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [
//              Colors.grey.withOpacity(0.4),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//            ],
//          )),
//          child: Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Container(
//                  width: 80,
//                  child: Image.asset(
//                    "asset/HG66.png",
//                    height: 60,
//                    width: 60,
//                  ),
//                ),
//                Text(
//                  "HG 66",
//                  style: TextStyle(
//                      color: HexColor.fromHex("#5D6A68"),
//                      fontSize: 23,
//                      fontWeight: FontWeight.bold),
//                ),
//                Container(
//                  width: 32,
//                  child: Icon(Icons.arrow_forward_ios),
//                ),
//              ],
//            ),
//          )),
//      onTap: () async {
//        var result = await Constants.navigatePush(
//            ConnectionScreen(
//              key: connectionScreenKey,
//              sdkType: Constants.e66,
//            ),
//            context,
//            rootNavigation: false);
//      },
//    );
//  }
//
//  /// Added by: Shahzad
//  /// Added on : 26th nov 2020
//  /// Container for HG 80
//  Widget hg80() {
//    return GestureDetector(
//      child: Container(
////          color: HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [
//              Colors.grey.withOpacity(0.4),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//              HexColor.fromHex("#FFDFDE").withOpacity(0.2),
//            ],
//          )),
//          child: Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Container(
//                  width: 80,
//                  child: Image.asset(
//                    "asset/HG80.png",
//                    height: 60,
//                    width: 60,
//                  ),
//                ),
//                Text(
//                  "HG 80",
//                  style: TextStyle(
//                      color: HexColor.fromHex("#5D6A68"),
//                      fontSize: 23,
//                      fontWeight: FontWeight.bold),
//                ),
//                Container(
//                  width: 32,
//                  child: Icon(Icons.arrow_forward_ios),
//                ),
//              ],
//            ),
//          )),
//      onTap: () async {
//        var result = await Constants.navigatePush(
//            ConnectionScreen(
//              key: connectionScreenKey,
//              sdkType: Constants.e66,
//            ),
//            context,
//            rootNavigation: false);
//      },
//    );
//  }

  /// Added by: Shahzad
  /// Added on : 26th nov 2020
  /// Container for title
  Widget title() {
    return Container(
      // color: HexColor.fromHex("#FFDFDE").withOpacity(0.2),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.withOpacity(0.3),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
        ],
      )),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Text(
            "Which Health Gauge tracker are you setting up ?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: HexColor.fromHex("#5D6A68"),
                fontSize: 23,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// Added by: Shahzad
  /// Added on : 26th nov 2020
  /// Container for last shadow effect
  Widget lastContainer() {
    return Container(
      height: 7.h,
      //color: Colors.grey.withOpacity(0.2),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.withOpacity(0.3),
          HexColor.fromHex("#FFDFDE").withOpacity(0.2),
        ],
      )),
    );
  }
}
