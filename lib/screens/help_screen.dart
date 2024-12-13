import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/webview_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import 'package:http/http.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import 'home/home_screeen.dart';

//String filepath = 'asset/files/test.html';

/// Added by: Akhil
/// Added on: May/29/2020
/// This widget is responsible for displaying local Html content in the app

class HelpScreen extends StatefulWidget {
  final String? title;

  HelpScreen({Key? key, this.title}) : super(key: key);

  @override
  HelpScreenState createState() => HelpScreenState();
}

/// Added by: Akhil
/// Added on: May/29/2020
/// this is state of stateful WebView page
class HelpScreenState extends State<HelpScreen> {
  /// Added by: Akhil
  /// Added on: May/29/2020
  /// this is the file path for Html content
  String htmlFilePath = 'asset/help.html';
  WebViewController? webViewController;
  bool pageLoaded = false;
  String? languageCode;
  List<String> items = []; //list to store title of items
  List<String> itemInfo = []; //list to store info of items
  List<String> images = []; //list to store images of items
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;

  @override
  void initState() {
    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    );
    super.initState();
    scrollToItem();
  }

  ///Added by: Shahzad
  ///Added on: 28/10/2020
  ///this method is used to get details of help page
  getDetails() {
    items = [
      StringLocalization.HGOverview,
      StringLocalization.login,
      StringLocalization.signUp,
      StringLocalization.resetPassword,
      StringLocalization.home,
      StringLocalization.HGProfile,
      StringLocalization.HGConnection,
      StringLocalization.HGSettings,
      StringLocalization.cardioMeasurement,
      StringLocalization.activityDay,
      StringLocalization.activityWeeklyMonthly,
      StringLocalization.HGSleep,
      StringLocalization.HGTag,
      //StringLocalization.tagEditorList,
      StringLocalization.tagEditor,
      StringLocalization.HGGraph,
      StringLocalization.HGMeasurementHistory,
      StringLocalization.HGTagHistory,
      //StringLocalization.weightHelp,
      StringLocalization.moreFunctions,
      StringLocalization.HGFindBracelet,
      StringLocalization.HGliftTheWristBrighten,
      StringLocalization.HGDoNotDisturb,
      StringLocalization.HGTimeFormat,
      StringLocalization.HGWearingMethod,
      // StringLocalization.HGTraining,
      StringLocalization.HGhrMonitor,
      // StringLocalization.calibration,
      StringLocalization.references,
      StringLocalization.bloodPressure,
      StringLocalization.hr,
      StringLocalization.sleep,
      StringLocalization.bMI,
    ];

    itemInfo = [
      StringLocalization.HGIntro,
      StringLocalization.loginInfo,
      StringLocalization.signUpInfo,
      StringLocalization.resetPasswordInfo,
      StringLocalization.homeInfo,
      StringLocalization.profileInfo,
      StringLocalization.connectionInfo,
      StringLocalization.settingsInfo,
      StringLocalization.cardioMeasurementInfo,
      StringLocalization.activityDayInfo,
      StringLocalization.activityWeeklyMonthlyInfo,
      StringLocalization.sleepInfo,
      StringLocalization.tagInfo,
      //StringLocalization.tagEditorListInfo,
      StringLocalization.tagEditorInfo,
      StringLocalization.graphInfo,
      StringLocalization.measurementHistoryInfo,
      StringLocalization.tagHistoryInfo,
      '',
      StringLocalization.findBraceletInfo,
      StringLocalization.liftTheWristBrightenInfo,
      StringLocalization.doNotDisturbInfo,
      StringLocalization.timeFormatInfo,
      StringLocalization.wearingMethodInfo,
      //StringLocalization.trainingInfo,
      StringLocalization.hrMonitorInfo,
      '',
      StringLocalization.bpUrl,
      StringLocalization.hrUrl,
      StringLocalization.sleepUrl,
      StringLocalization.weightUrl,
    ];

    images = [
      '',
      StringLocalization.imageLogin,
      StringLocalization.imageSignUp,
      StringLocalization.imageResetPassword,
      StringLocalization.imageDashboard,
      StringLocalization.imageProfile,
      StringLocalization.imageConnection,
      StringLocalization.imageSetting,
      StringLocalization.imageMeasurement,
      StringLocalization.imageActivityDay,
      StringLocalization.imageActivityWeek,
      StringLocalization.imageSleep,
      StringLocalization.imageTag,
      //StringLocalization.imageTagEditor,
      StringLocalization.imageTagUpdate,
      StringLocalization.imageGraph,
      StringLocalization.imageMeasurementHistory,
      StringLocalization.imageTagHistory,
      '',
      StringLocalization.imageFindBracelet,
      Platform.isIOS && preferences?.getInt(Constants.measurementType) == 2 ? StringLocalization.imageBrightenScreen2 : StringLocalization.imageBrightenScreen,
      Platform.isIOS && preferences?.getInt(Constants.measurementType) == 2 ? StringLocalization.imageDoNotDisturb2 : StringLocalization.imageDoNotDisturb,
      StringLocalization.imageTimeFormat,
      Platform.isIOS && preferences?.getInt(Constants.measurementType) == 2 ? StringLocalization.imageWearingMethod2 : StringLocalization.imageWearingMethod,
      //  StringLocalization.imageTraining,
      StringLocalization.imageHourlyHR,
      '',
      '',
      '',
      '',
      '',
    ];
    if(Platform.isIOS && preferences?.getInt(Constants.measurementType) == 2){
      items.removeAt(8);
      itemInfo.removeAt(8);
      images.removeAt(8);
      items.removeAt(14);
      itemInfo.removeAt(14);
      images.removeAt(14);
      items.removeAt(21);
      itemInfo.removeAt(21);
      images.removeAt(21);
    }
  }

  /// Added by: Akhil
  /// Added on: May/29/2020
  /// in this function we are checking after the widget is updated that the requested page is updated
  /// also in this page we are calling native js function on the webpage to navigate to specific portion of webpage
  @override
  void didUpdateWidget(HelpScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    scrollToItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ? AppColor.darkBackgroundColor
                    : AppColor.backgroundColor,
                title: TitleText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.help),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex('62CBC9'),
                ),
                centerTitle: true,
              ),
            )),
        body: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          child: ListView.builder(
              scrollDirection: scrollDirection,
              controller: controller,
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      items[index] == StringLocalization.sleep
                          ? Container()
                          : TitleText(
                          text: index == 0 ? '${StringLocalization.of(context).getText(items[index])}'
                            : items[index] != ''
                              ? Platform.isIOS && preferences?.getInt(Constants.measurementType) == 2 ? index < 16 ? '$index. ${StringLocalization.of(context)
                                  .getText(items[index])}' : index < 21 ? '${index - 15}. ${StringLocalization.of(context)
                              .getText(items[index])}' : '${StringLocalization.of(context)
                              .getText(items[index])}'
                              :  index < 18 ? '$index. ${StringLocalization.of(context)
                              .getText(items[index])}' : index < 24 ? '${index - 17}. ${StringLocalization.of(context)
                              .getText(items[index])}' : '${StringLocalization.of(context)
                              .getText(items[index])}'
                              :' ',
                          fontSize: index == 0
                              ? 50
                              : (index > 17 && index < 24) ||
                                      (index > 24 && index < 29)
                                  ? 20
                                  : 24,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          align: index == 0
                              ? TextAlign.center
                              : TextAlign.left,
                          maxLine: index == 0 || index == 10 ? 2 : 1,
                            ),
                      index > 24 && index < 29
                          ? Container()
                          : SizedBox(height: 20),
                      index > 24 && index < 29
                          ? Column(
                              children: [
                                url(items[index]),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // height: MediaQuery.of(context).size.height - 50,
                                  // width: MediaQuery.of(context).size.width - 40,
                                  child: Text(
                                    itemInfo[index] != ''
                                        ? StringLocalization.of(context)
                                            .getText(itemInfo[index])
                                        : '',
                                    // fontSize: 16,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColor.primaryColor),
                                    maxLines: 17,
                                    textAlign: TextAlign.left,
                                    // minFontSize: 8,
                                  ),
                                ),
                                SizedBox(
                                    height: itemInfo[index] != '' ? 20 : 0),
                                Center(
                                    child: images[index] != ''
                                        ? Image.asset(
                                            StringLocalization.of(context)
                                                .getText(images[index]),
                                            width: 300.h,
                                            height: 450.h,
                                          )
                                        : Container()),
//                      url(items[index]),
//                      items[index] == StringLocalization.cardioMeasurement ? SizedBox(height: 15) : Container(),
//                      items[index] == StringLocalization.cardioMeasurement ? url(StringLocalization.hr) : Container(),
                                SizedBox(height: images[index] == '' ? 0 : 40),
                              ],
                            ),
                    ],
                  ),
                );
              }),
        ));
  }

  Widget url(String title) {
    String info = getFurtherInfo(title);
    return info != ''
        ? Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
//          Text(stringLocalization.getText(info),
//          style: TextStyle(
//              fontSize: 16, color: AppColor.primaryColor
//          ),),
                GestureDetector(
                  child: Text(
                    stringLocalization.getText(getUrl(title)),
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: AppColor.primaryColor),
                  ),
                  onTap: () {
                    Constants.navigatePush(
                        WebViewScreen(
                          title: title,
                          isFromHelp: true,
                        ),
                        context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        : Container();
  }

  String getUrl(String title) {
    switch (title) {
      case StringLocalization.bMI:
        return StringLocalization.weightUrl;
      case StringLocalization.bloodPressure:
        return StringLocalization.bpUrl;
      case StringLocalization.sleep:
        return StringLocalization.sleepUrl;
      case StringLocalization.hr:
        return StringLocalization.hrUrl;
      default:
        return '';
    }
  }

  String getFurtherInfo(String title) {
    switch (title) {
      case StringLocalization.bMI:
        return StringLocalization.furtherInfoWeight;
      case StringLocalization.bloodPressure:
        return StringLocalization.furtherInfoBp;
      case StringLocalization.sleep:
        return StringLocalization.furtherInfoSleep;
      case StringLocalization.hr:
        return StringLocalization.furtherInfoHr;
      default:
        return '';
    }
  }

  Future scrollToItem() async {
    int index = 0;
    for (int i = 0; i < items.length; i++) {
      if (widget.title!.toLowerCase() == items[i].toLowerCase()) {
        index = i;
        break;
      }
    }
    await controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }
}
