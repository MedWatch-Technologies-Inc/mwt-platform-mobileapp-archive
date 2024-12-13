
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomCalendar/date_picker_dialog.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';



class HGServerScreen extends StatefulWidget {
  @override
  _HGServerState createState() => _HGServerState();
}

class _HGServerState extends State<HGServerScreen> {
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now();
  final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
  bool isShowLoadingScreen = false;
  bool isDataCollected = false;

  List<HealthKitOrGoogleFitModel> localDatabaseData = [];

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
              backgroundColor: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Theme
                    .of(context)
                    .brightness == Brightness.dark
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
                'Server Sync',
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          )),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        color: Theme
            .of(context)
            .brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isShowLoadingScreen)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        stringLocalization.getText(
                            StringLocalization.startDate),
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? AppColor.white87
                                : AppColor.color384341),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 69.h,
                        margin: EdgeInsets.symmetric(horizontal: 33.w),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(10.h),
                          boxShadow: [
                            BoxShadow(
                              color: Theme
                                  .of(context)
                                  .brightness ==
                                  Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                  : Colors.white,
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.75)
                                  : HexColor.fromHex('#9F2DBC').withOpacity(
                                  0.15),
                              blurRadius: 4,
                              spreadRadius: 0,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: Body1Text(
                              text: DateFormat(DateUtil.ddMMMMyyyy).format(
                                DateTime.parse(startDate.toString()),
                              ),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColor.white87
                                  : AppColor.color384341,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                              padding: EdgeInsets.only(right: 20.w),
                                icon: Image.asset('asset/calendar_button.png'),
                                onPressed: () async {
                                  var selectedDate = await Date().selectDate(context, startDate);
                                  if (selectedDate != null) {
                                    if (startDate != selectedDate)
                                      isDataCollected = false;
                                    startDate = selectedDate;
                                    setState(() {});
                                  }
                                })
                          ],
                        ),
                      ),
                      // datePicker(),
                      SizedBox(height: 32.h),
                      Text(
                        stringLocalization
                            .getText(StringLocalization.endDate),
                        style: TextStyle(fontSize: 16.sp,
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark ? AppColor
                                .white87 : AppColor.color384341),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 69.h,
                        margin: EdgeInsets.symmetric(horizontal: 33.w),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark ? AppColor
                              .darkBackgroundColor : AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(10.h),
                          boxShadow: [
                            BoxShadow(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                  : Colors.white,
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.75)
                                  : HexColor.fromHex('#9F2DBC').withOpacity(
                                  0.15),
                              blurRadius: 4,
                              spreadRadius: 0,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Body1Text(
                          text: DateFormat(DateUtil.ddMMMMyyyy).format(
                            DateTime.parse(endDate.toString()),
                          ),
                          color: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? AppColor.white87
                              : AppColor.color384341,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),

                      SizedBox(
                        height: 43.h,
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 25.h,
                                top: 28.h,
                                left: 33.w,
                                right: 33.w),
                            width: 127.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.h),
                                color: isDataCollected
                                    ? HexColor.fromHex('#62CBC9')
                                    : HexColor.fromHex('#00AFAA'),
                                boxShadow: !isDataCollected
                                ? [
                                BoxShadow(
                                  color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6')
                                      .withOpacity(0.1)
                                      : Colors.white,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(-5, -5),
                                ),
                                BoxShadow(
                                  color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark
                                      ? Colors.black.withOpacity(0.75)
                                      : HexColor.fromHex('#D1D9E6'),
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(5, 5),
                                ),
                                ] : [
                            BoxShadow(
                            color: Theme.of(context).brightness == Brightness
                                .dark
                                ? HexColor.fromHex('#FF9E99').withOpacity(0.8)
                                : HexColor.fromHex('#9F2DBC').withOpacity(
                                0.8),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: Offset(0, 0),
                          ),
                          BoxShadow(
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? HexColor.fromHex('#000000').withOpacity(
                                0.25)
                                : HexColor.fromHex('#00AFAA').withOpacity(
                                0.05),
                            spreadRadius: 5,
                            blurRadius: 6,
                            offset: Offset(10, 10),
                          ),
                        ],),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.h),
                          onTap: () {
                            isShowLoadingScreen = true;
                            if (validateDate()) {
                              fetchData();
                            } else {
                              isShowLoadingScreen = false;
                              var dialog = CustomInfoDialog(
                                maxLine: 2,
                                primaryButton: stringLocalization
                                    .getText(StringLocalization.ok),
                                onClickYes: () {
                                  if (context != null) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  }
                                },
                                subTitle:
                                'End date can\'t be before than start date',
                              );
                              showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (context) => dialog,
                                  barrierDismissible: false);
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          child: Container(
                            decoration: ConcaveDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.h),
                                ),
                                depression: isDataCollected ? 8 : 5,
                                colors: [
                                  isDataCollected && Theme
                                      .of(context)
                                      .brightness == Brightness.dark ? HexColor
                                      .fromHex('#D1D9E6') : Colors.white,
                                  isDataCollected && Theme
                                      .of(context)
                                      .brightness == Brightness.dark ? HexColor
                                      .fromHex('#BD78CE') : HexColor.fromHex(
                                      '#D1D9E6'),
                                    ]),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.h),
                                    child: Text(
                                      isDataCollected
                                          ? stringLocalization.getText(
                                              StringLocalization.dataCollected)
                                          : stringLocalization.getText(
                                              StringLocalization.collectData),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? isDataCollected
                                                ? AppColor.color9F2DBC
                                                : HexColor.fromHex('#111B1A')
                                            : isDataCollected
                                        ? AppColor.color9F2DBC
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
      ],
    ),)
    ,
    );
  }

  bool checkDateIsBetweenOrNot(endDate1) => endDate1.isBefore(DateTime.now()) &&
      endDate1.isAfter(DateTime.now().subtract(Duration(days: 31)));

  fetchData() async {
    try {
      if (startDate != null) {
        preferences?.setString(
            Constants.synchronizationKey, startDate.toString());
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    isShowLoadingScreen = false;
    isDataCollected = true;
    CustomSnackBar.buildSnackbar(context, 'Fetch Successfully', 3);
    setState(() {});
  }

  bool validateDate() {
    if (endDate
        .difference(startDate)
        .inDays < 0) {
      return false;
    }
    return true;
  }

  Future getPreferences() async {
    if (preferences != null &&
        preferences!.getString(Constants.synchronizationKey) != null) {
      String storedDate = preferences!.getString(Constants.synchronizationKey)!;
      startDate = DateTime.parse(storedDate);
      setState(() {});
    }
  }
}
