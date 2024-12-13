import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/repository/tag/tag_repository.dart';
import 'package:health_gauge/screens/history/week_and_month_history_data.dart';
import 'package:health_gauge/screens/tag/tag_note_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/day_week_month_tab.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class TagHistoryScreen extends StatefulWidget {
  @override
  _TagHistoryScreenState createState() => _TagHistoryScreenState();
}

class _TagHistoryScreenState extends State<TagHistoryScreen> {
  bool isLoading = true;
  bool isPagePushed = true;
 // TagNote data = TagNote();
  int currentIndex = 0;

  Map<String, Tag> tagMap = Map();
  List<Map<String, Tag>> tagMapList= [];

  DateTime selectedDate = DateTime.now();

//  DateTime selectedDateForWeek = DateTime.now();
//  DateTime selectedDateForMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  DateTime firstDateOfWeek = DateTime.now();
  DateTime lastDateOfWeek = DateTime.now();

  late String userId;

  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<List<TagNote>> tagList = [];
  List<TagNote> dayTagList = [];
  bool showListDetails = false;

  int currentOuterListIndex = 0;

  // List<MergedTagSliderModel> weekTagList = new List<MergedTagSliderModel>();
  // List<MonthWeekItemModel> monthTagList = new List<MonthWeekItemModel>();
  bool showDetails = false;
  int currentListIndex = 0;
  late TagHistoryListItems tagNoteDetail;

  @override
  void initState() {
    databaseHelper.database;
    getPreference();
    makeTagMap(userId);
    getTagDataFromDb(isDay: true);
    super.initState();
  }

  Widget tagIcon({
    Tag? tag,
    double? height,
    double? width,
  }) {
    try {
      if (tag != null && tag.icon != null && tag.icon!.isNotEmpty) {
        if (tag.icon!.contains('asset')) {
          return Image.asset(
            'asset/strees_icon.png',
            //color: Colors.red,
            //Theme.of(context).brightness == Brightness.dark ?  HexColor.fromHex('#00AFAA') : HexColor.fromHex('#62CBC9'),
            height: height ?? 40.0.h,
            width: width,
            gaplessPlayback: true,
          );
        } else {
          try {
            return Image.memory(
              base64Decode(tag.icon!),
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#00AFAA')
                  : null,
              height: height ?? 40.0.h,
              width: width,
              gaplessPlayback: true,
            );
          } catch (e) {
            print('Exception in ImageWidget(TagHistoryScreen): $e');
          }
        }
      }
      return Image.asset(
        'asset/placeholder.png',
        height: height ?? 40.0.h,
        width: width,
        gaplessPlayback: true,
      );
    } catch (e) {
      print('Exception in ImageWidget(TagHistoryScreen): $e');
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
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
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                connections.disconnectWeightDevice();
                Navigator.of(context).pop();
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
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            title: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.tagHistory),
              fontSize: 18.sp,
              color: HexColor.fromHex('62CBC9'),
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
              minFontSize: 12,
              // maxLine: 1,
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: bodyLayout(),
    );
  }

  Widget bodyLayout() {
    // if (isLoading) {
    //   return LoadingScreen();
    // }
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          DayWeekMonthTab(
            currentIndex: currentIndex,
            date: selectedValueText(),
            onTapPreviousDate: onClickBefore,
            onTapNextDate: () {
              bool isEnable = true;
              //isLoading = true;
              if (currentIndex == 0 &&
                  selectedDate.difference(DateTime.now()).inDays == 0) {
                isEnable = false;
              }
              if (currentIndex == 1 &&
                  lastDateOfWeek.difference(DateTime.now()).inDays >= 0) {
                isEnable = false;
              }
              if (currentIndex == 2 &&
                  (selectedDate.difference(DateTime.now()).inDays >= 0 ||
                      (selectedDate.year == DateTime.now().year &&
                          selectedDate.month == DateTime.now().month))) {
                isEnable = false;
              }
              if (isEnable) onClickNext();
            },
            onTapDay: () async {
              //isLoading = true;
              currentIndex = 0;
              getTagDataFromDb(isDay: true);
            },
            onTapWeek: () async {
              //isLoading = true;
              currentIndex = 1;
              selectWeek(selectedDate);
              getTagDataFromDb(isWeek: true);
            },
            onTapMonth: () async {
              //isLoading = true;
              var currentTime = DateTime.now();
              if (selectedDate.year == currentTime.year &&
                  selectedDate.month - currentTime.month > 0) {
                selectedDate = currentTime;
              }
              currentIndex = 2;
              getTagDataFromDb(isMonth: true);
            },
            onTapCalendar: () async {
              selectedDate = await Date(getDatabaseDataFrom: 'tag').selectDate(
                context,
                selectedDate,
              );
              selectWeek(selectedDate);
              getTagDataFromDb(
                isDay: currentIndex == 0 ? true : false,
                isWeek: currentIndex == 1 ? true : false,
                isMonth: currentIndex == 2 ? true : false,
              );
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: currentIndex == 0 ?
                      dayTagList.isNotEmpty ?
                      ListView.builder(
                          itemCount: dayTagList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (showDetails && currentListIndex == index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 13.w,
                                    right: 13.w,
                                    top: 16.h,
                                    bottom: index == dayTagList.length - 1
                                        ? 16.h
                                        : 0.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(10.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? HexColor.fromHex('#D1D9E6')
                                            .withOpacity(0.1)
                                            : Colors.white,
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: Offset(-4, -4),
                                      ),
                                      BoxShadow(
                                        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? Colors.black.withOpacity(0.75)
                                            : HexColor.fromHex('#9F2DBC')
                                            .withOpacity(0.15),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: Offset(4, 4),
                                      ),
                                    ]),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        height: 56.h,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 13.h),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .brightness ==
                                                Brightness.dark
                                                ? HexColor.fromHex('#111B1A')
                                                : AppColor.backgroundColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.h),
                                                topRight:
                                                Radius.circular(10.h)),
                                            gradient: Theme.of(context)
                                                .brightness ==
                                                Brightness.dark
                                                ? LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  HexColor.fromHex(
                                                      '#CC0A00')
                                                      .withOpacity(0.15),
                                                  HexColor.fromHex(
                                                      '#9F2DBC')
                                                      .withOpacity(0.15),
                                                ])
                                                : LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  HexColor.fromHex(
                                                      '#FF9E99')
                                                      .withOpacity(0.1),
                                                  HexColor.fromHex(
                                                      '#9F2DBC')
                                                      .withOpacity(0.023),
                                                ])),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                              EdgeInsets.only(left: 15.w),
                                              child: tagIcon(
                                                tag: tagMap[
                                                dayTagList[index].label],
                                                height: 33.h,
                                                width: 33.h,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(left: 12.w),
                                              child: Container(
                                                width: 100.w,
                                                height: 30.h,
                                                alignment: Alignment.centerLeft,
                                                child: Body1Text(
                                                  text: dayTagList[index].label ??
                                                      '',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? Colors.white
                                                      .withOpacity(0.87)
                                                      : HexColor.fromHex(
                                                      '384341'),
                                                  textOverflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 14.w),
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerRight,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: [
                                                      Body1Text(
                                                        text: DateFormat(
                                                            DateUtil
                                                                .MMMddhhmma)
                                                            .format(
                                                          // DateTime.parse(
                                                          //     tagList[index]
                                                          //         .date
                                                          //         .toString()),
                                                            getDateInFormat(
                                                                dayTagList[
                                                                index])),
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white
                                                            .withOpacity(
                                                            0.87)
                                                            : HexColor.fromHex(
                                                            '384341'),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Image.asset(
                                                        'asset/up_icon_small.png',
                                                        height: 26.h,
                                                        width: 26.h,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        showDetails = false;
                                        setState(() {});
                                      },
                                    ),
                                    tagNoteDetail != null
                                        ? GestureDetector(
                                      onTap: () async {
                                        var tag = await databaseHelper
                                            .getTagById(
                                            dayTagList[index].tagId ?? 0,
                                            apiId: dayTagList[index]
                                                .tagApiId,
                                            label:
                                            dayTagList[index].label);
                                        if (tag != null) {
                                          Constants.navigatePush(
                                              TagNoteScreen(
                                                tag: tag,
                                                tagNote: dayTagList[index],
                                              ),
                                              context);
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            26.w,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .brightness ==
                                                Brightness.dark
                                                ? HexColor.fromHex(
                                                '#111B1A')
                                                : AppColor
                                                .backgroundColor,
                                            borderRadius:
                                            BorderRadius.only(
                                                bottomLeft:
                                                Radius.circular(
                                                    10.h),
                                                bottomRight:
                                                Radius.circular(
                                                    10.h))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: 20.w,
                                                // top: 11.h,
                                                // 15.h,
                                                // 21.h,
                                              ),
                                              // decoration: BoxDecoration(
                                              //   // color: Colors.red,
                                              //   borderRadius: 1 >=
                                              //           tagNoteDetail.length
                                              //       ? BorderRadius.only(
                                              //           bottomLeft:
                                              //               Radius.circular(10.h),
                                              //           bottomRight:
                                              //               Radius.circular(10.h))
                                              //       : BorderRadius.circular(0.0),
                                              // ),
                                              height: 52.5.h,
                                              child: tagByValue(tagMap[
                                              dayTagList[index].label]?.tagType) != TagType.bloodGlucose
                                                  ?
                                                  Row( children : [

                                                   Body1AutoText(
                                                  text: tagNoteDetail.label.toString() == 'Glucose Patch' ? '${tagNoteDetail.label} :' : tagNoteDetail
                                                      .heading ,
                                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white
                                                      .withOpacity(0.8) : HexColor.fromHex('#5D6A68'), fontSize: 16.sp, fontWeight: FontWeight.bold,
                                                ),
                                                   Body1AutoText(
                                                  text: tagNoteDetail.label.toString() == 'Glucose Patch' ? '${tagNoteDetail.patchLocation}' : tagNoteDetail.value.toString(),
                                                  color: Theme.of(context)
                                                      .brightness == Brightness.dark ? Colors.white.withOpacity(0.8) : HexColor.fromHex('#384341'),
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  minFontSize: 6,
                                                ),
                                              ]
                                              )
                                                  : Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Body1AutoText(
                                                        text:
                                                        '${stringLocalization.getText(StringLocalization.MMOLPerLiter)}: ',
                                                        color: Theme.of(context).brightness ==
                                                            Brightness
                                                                .dark
                                                            ? Colors
                                                            .white
                                                            .withOpacity(
                                                            0.8)
                                                            : HexColor.fromHex(
                                                            '#5D6A68'),
                                                        fontSize:
                                                        16.sp,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        // align: TextAlign.right,
                                                        minFontSize:
                                                        6,
                                                      ),
                                                      Body1AutoText(
                                                        text: tagNoteDetail
                                                            .unitType ==
                                                            '1'
                                                            ? tagNoteDetail
                                                            .value
                                                            .toString()
                                                            : (tagNoteDetail.value /
                                                            18)
                                                            .toStringAsFixed(1),
                                                        color: Theme.of(context).brightness ==
                                                            Brightness
                                                                .dark
                                                            ? Colors
                                                            .white
                                                            .withOpacity(
                                                            0.8)
                                                            : HexColor.fromHex(
                                                            '#384341'),
                                                        fontSize:
                                                        16.sp,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        // align: TextAlign.right,
                                                        minFontSize:
                                                        6,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets
                                                        .only(
                                                        right: 66
                                                            .h),
                                                    child: Row(
                                                      children: [
                                                        Body1AutoText(
                                                          text:
                                                          '${stringLocalization.getText(StringLocalization.MGDL)}: ',
                                                          color: Theme.of(context).brightness ==
                                                              Brightness
                                                                  .dark
                                                              ? Colors
                                                              .white
                                                              .withOpacity(0.8)
                                                              : HexColor.fromHex('#5D6A68'),
                                                          fontSize:
                                                          16.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          // align: TextAlign.right,
                                                          minFontSize:
                                                          6,
                                                        ),
                                                        Body1AutoText(
                                                          text: tagNoteDetail.unitType ==
                                                              '2'
                                                              ? tagNoteDetail
                                                              .value
                                                              .toString()
                                                              : (tagNoteDetail.value * 18).roundToDouble()
                                                              .toStringAsFixed(1),
                                                          color: Theme.of(context).brightness ==
                                                              Brightness
                                                                  .dark
                                                              ? Colors
                                                              .white
                                                              .withOpacity(0.8)
                                                              : HexColor.fromHex('#384341'),
                                                          fontSize:
                                                          16.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          // align: TextAlign.right,
                                                          minFontSize:
                                                          6,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            (tagNoteDetail.note != null &&
                                                tagNoteDetail.note
                                                    .isNotEmpty) ||
                                                (tagNoteDetail
                                                    .tagImageList !=
                                                    null &&
                                                    tagNoteDetail
                                                        .tagImageList!
                                                        .isNotEmpty)
                                                ? Container(
                                              height: 1.h,
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness
                                                      .dark
                                                  ? Colors.white
                                                  .withOpacity(
                                                  0.15)
                                                  : HexColor
                                                  .fromHex(
                                                  'D9E0E0'),
                                            )
                                                : Container(),
                                            (tagNoteDetail.note != null &&
                                                tagNoteDetail.note
                                                    .isNotEmpty) ||
                                                (tagNoteDetail
                                                    .tagImageList !=
                                                    null &&
                                                    tagNoteDetail
                                                        .tagImageList!
                                                        .isNotEmpty)
                                                ? Container(
                                              decoration:
                                              BoxDecoration(
                                                  borderRadius:
                                                  // 2 >=
                                                  //         tagNoteDetail.length
                                                  //     ?
                                                  BorderRadius.only(
                                                      bottomLeft: Radius.circular(10
                                                          .h),
                                                      bottomRight:
                                                      Radius.circular(10.h))
                                                // : BorderRadius.circular(0.0),
                                              ),
                                              // height: 52.5.h,
                                              child: Container(
                                                margin:
                                                EdgeInsets.only(
                                                    bottom:
                                                    21.h),
                                                // color: Colors.red,
                                                padding:
                                                EdgeInsets.only(
                                                    left: 20.w,
                                                    right:
                                                    15.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize:
                                                  MainAxisSize
                                                      .min,
                                                  children: [
                                                    tagNoteDetail.note !=
                                                        null &&
                                                        tagNoteDetail
                                                            .note
                                                            .isNotEmpty
                                                        ? SizedBox(
                                                      height:
                                                      11.h,
                                                    )
                                                        : Container(),
                                                    tagNoteDetail.note !=
                                                        null &&
                                                        tagNoteDetail
                                                            .note
                                                            .isNotEmpty
                                                        ? Body1AutoText(
                                                      text:
                                                      'Notes:',
                                                      color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                          ? Colors.white.withOpacity(0.8)
                                                          : HexColor.fromHex('#5D6A68'),
                                                      fontSize:
                                                      16.sp,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      // align: TextAlign.right,
                                                      minFontSize:
                                                      6,
                                                    )
                                                        : Container(),
                                                    tagNoteDetail.note !=
                                                        null &&
                                                        tagNoteDetail
                                                            .note
                                                            .isNotEmpty
                                                        ? Body1AutoText(
                                                      text: tagNoteDetail
                                                          .note,
                                                      color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                          ? Colors.white.withOpacity(0.8)
                                                          : HexColor.fromHex('#384341'),
                                                      fontSize:
                                                      16.sp,
                                                      // fontWeight: FontWeight.bold,
                                                      // align: TextAlign.right,
                                                      minFontSize:
                                                      6,
                                                      maxLine:
                                                      10,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    )
                                                        : Container(),
                                                    tagNoteDetail.tagImageList !=
                                                        null &&
                                                        tagNoteDetail
                                                            .tagImageList!
                                                            .isNotEmpty
                                                        ? SizedBox(
                                                      height:
                                                      22.h,
                                                    )
                                                        : Container(),
                                                    tagNoteDetail.tagImageList !=
                                                        null &&
                                                        tagNoteDetail
                                                            .tagImageList!
                                                            .isNotEmpty
                                                        ? imagesWidget(
                                                        tagNoteDetail
                                                            .tagImageList!)
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                        : Container()
                                  ],
                                ),
                              );
                            } else {
                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: index == (dayTagList.length - 1)
                                            ? 16.h
                                            : 0),
                                    child: IconSlideAction(
                                      color: HexColor.fromHex('#FF6259'),
                                      onTap: () async {
                                          deleteDialog(
                                          onClickYes: () async {
                                            if (Navigator.canPop(context)) {
                                              Navigator.of(context, rootNavigator: true)
                                                  .pop();
                                            }
                                            var isInternet = await Constants
                                                .isInternetAvailable();
                                            var d = dayTagList[index];
                                            dayTagList.removeAt(index);

                                            if (isInternet) {
                                              deleteDataCallApi(
                                                  int.parse(d.apiId ?? '0'),
                                                  d.id ?? 0);
                                            } else {
                                              dbHelper
                                                  .deleteTagNoteDetail(d.id ?? 0);
                                            }
                                            CustomSnackBar.buildSnackbar(
                                                context,
                                                StringLocalization.of(context)
                                                    .getText(StringLocalization
                                                    .tagNoteDeletedSuccessfully),
                                                3);
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          }
                                        );
                                      },
                                      height: 56.h,
                                      topMargin: 16.h,
                                      iconWidget: Text(
                                        StringLocalization.of(context)
                                            .getText(StringLocalization.delete),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                      rightMargin: 13.w,
                                      leftMargin: 0,
                                    ),
                                  )
                                ],
                                child: GestureDetector(
                                  key: Key('item_$index'),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 13.w,
                                        right: 13.w,
                                        top: 16.h,
                                        bottom: index == dayTagList.length - 1
                                            ? 16.h
                                            : 0.0),
                                    height: 56.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? HexColor.fromHex('#111B1A')
                                            : AppColor.backgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(10.h),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .brightness ==
                                                Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
                                                .withOpacity(0.1)
                                                : Colors.white,
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(-5, -5),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .brightness ==
                                                Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#9F2DBC')
                                                .withOpacity(0.15),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(5, 5),
                                          ),
                                        ]),
                                    child: Container(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 13.h),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                              Brightness.dark
                                              ? HexColor.fromHex('#111B1A')
                                              : AppColor.backgroundColor,
                                          borderRadius:
                                          BorderRadius.circular(10.h),
                                          gradient: Theme.of(context)
                                              .brightness ==
                                              Brightness.dark
                                              ? LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                HexColor.fromHex(
                                                    '#CC0A00')
                                                    .withOpacity(0.15),
                                                HexColor.fromHex(
                                                    '#9F2DBC')
                                                    .withOpacity(0.15),
                                              ])
                                              : LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                HexColor.fromHex(
                                                    '#FF9E99')
                                                    .withOpacity(0.1),
                                                HexColor.fromHex(
                                                    '#9F2DBC')
                                                    .withOpacity(0.023),
                                              ])),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.only(left: 15.w),
                                            child: tagIcon(
                                              tag: tagMap[dayTagList[index].label],
                                              height: 33.h,
                                              width: 33.h,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(left: 12.w),
                                            child: Container(
                                              width: 100.w,
                                              height: 30.h,
                                              alignment: Alignment.centerLeft,
                                              child: Body1Text(
                                                text: dayTagList[index].label!,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness.dark
                                                    ? Colors.white
                                                    .withOpacity(0.87)
                                                    : HexColor.fromHex(
                                                    '384341'),
                                                textOverflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              EdgeInsets.only(right: 14.w),
                                              child: Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Body1Text(
                                                      text: DateFormat(DateUtil
                                                          .MMMddhhmma)
                                                          .format(
                                                        // DateTime.parse(
                                                        //     tagList[index]
                                                        //         .date
                                                        //         .toString()),
                                                          getDateInFormat(
                                                              dayTagList[
                                                              index])),
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .brightness ==
                                                          Brightness.dark
                                                          ? Colors.white
                                                          .withOpacity(0.87)
                                                          : HexColor.fromHex(
                                                          '384341'),
                                                    ),
                                                    SizedBox(
                                                      width: 13.w,
                                                    ),
                                                    Image.asset(
                                                      'asset/down_icon_small.png',
                                                      height: 26.h,
                                                      width: 26.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showDetails = true;
                                    currentListIndex = index;
                                    tagNoteDetail =
                                        updateDetailList(index,0, dayTagList[index]);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            }
                          })
                      : Container(
                        margin: EdgeInsets.only(top: 100.h),
                        child: Body1Text(
                          text: stringLocalization.getText(
                            StringLocalization.noDataFound,
                          ),
                          fontSize: 16,
                        ),
                      )
                  : tagList.isNotEmpty
                      ? ListView.builder(
                      itemCount: tagList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: 13.w,
                              right: 13.w,
                              top: 16.h,
                              bottom:
                              index == tagList.length - 1 ? 16.h : 0.0),
                          decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .brightness ==
                                  Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6')
                                      .withOpacity(0.1)
                                      : Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(-4, -4),
                                ),
                                BoxShadow(
                                  color: Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.dark
                                      ? Colors.black.withOpacity(0.75)
                                      : HexColor.fromHex('#9F2DBC')
                                      .withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ]),
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .brightness ==
                                          Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                      borderRadius:
                                      BorderRadius.circular(10.h),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme
                                              .of(context)
                                              .brightness ==
                                              Brightness.dark
                                              ? HexColor.fromHex(
                                              '#D1D9E6')
                                              .withOpacity(0.1)
                                              : Colors.white,
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                          offset: Offset(-5, -5),
                                        ),
                                        BoxShadow(
                                          color: Theme
                                              .of(context)
                                              .brightness ==
                                              Brightness.dark
                                              ? Colors.black
                                              .withOpacity(0.75)
                                              : HexColor.fromHex(
                                              '#9F2DBC')
                                              .withOpacity(0.15),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                          offset: Offset(5, 5),
                                        ),
                                      ]),
                                  child: Container(
                                    height: 56.h,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13.h),
                                    decoration: BoxDecoration(
                                        color: Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? HexColor.fromHex('#111B1A')
                                            : AppColor.backgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(10.h),
                                        gradient: Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? LinearGradient(
                                            begin:
                                            Alignment.topCenter,
                                            end: Alignment
                                                .bottomCenter,
                                            colors: [
                                              HexColor.fromHex(
                                                  '#CC0A00')
                                                  .withOpacity(
                                                  0.15),
                                              HexColor.fromHex(
                                                  '#9F2DBC')
                                                  .withOpacity(
                                                  0.15),
                                            ])
                                            : LinearGradient(
                                            begin:
                                            Alignment.topCenter,
                                            end: Alignment
                                                .bottomCenter,
                                            colors: [
                                              HexColor.fromHex(
                                                  '#FF9E99')
                                                  .withOpacity(0.1),
                                              HexColor.fromHex(
                                                  '#9F2DBC')
                                                  .withOpacity(
                                                  0.023),
                                            ])),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.w),
                                            child: Body1Text(
                                              text: DateFormat(
                                                  DateUtil.MMMddyyyy)
                                                  .format(DateTime.parse(
                                                  tagList[index][0]
                                                      .date
                                                      .toString())),
                                              fontSize: 16.sp,
                                              color: Theme
                                                  .of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? Colors.white
                                                  .withOpacity(0.87)
                                                  : HexColor.fromHex(
                                                  '384341'),
                                              fontWeight: FontWeight.bold,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 14.w),
                                          child: Image.asset(
                                            showListDetails &&
                                                currentOuterListIndex ==
                                                    index
                                                ? 'asset/up_icon_small.png'
                                                : 'asset/down_icon_small.png',
                                            height: 26.h,
                                            width: 26.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (currentOuterListIndex !=
                                      index ||
                                      (currentOuterListIndex ==
                                          index &&
                                          !showListDetails)) {
                                    showListDetails = true;
                                    currentOuterListIndex = index;
                                    setState(() {});
                                  } else {
                                    showListDetails = false;
                                    setState(() {});
                                  }
                                },
                              ),
                              showListDetails && currentOuterListIndex == index
                                  ? SizedBox(height: 16.h,)
                                  : Container(),
                              Visibility(
                                visible: showListDetails &&
                                    currentOuterListIndex == index,
                                child : ListView.builder(
                                    itemCount: tagList[index].length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context,
                                        int innerIndex) {
                                      if (showDetails &&
                                          currentListIndex == innerIndex) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 13.w,
                                              right: 13.w,
                                              top: 16.h,
                                              bottom: innerIndex ==
                                                  tagList[index].length - 1
                                                  ? 16.h
                                                  : 0.0),
                                          decoration: BoxDecoration(
                                              color: Theme
                                                  .of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius: BorderRadius
                                                  .circular(10.h),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme
                                                      .of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? HexColor.fromHex(
                                                      '#D1D9E6')
                                                      .withOpacity(0.1)
                                                      : Colors.white,
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(-4, -4),
                                                ),
                                                BoxShadow(
                                                  color: Theme
                                                      .of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? Colors.black
                                                      .withOpacity(0.75)
                                                      : HexColor.fromHex(
                                                      '#9F2DBC')
                                                      .withOpacity(0.15),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(4, 4),
                                                ),
                                              ]),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                  height: 56.h,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.h),
                                                  decoration: BoxDecoration(
                                                      color: Theme
                                                          .of(context)
                                                          .brightness ==
                                                          Brightness.dark
                                                          ? HexColor.fromHex(
                                                          '#111B1A')
                                                          : AppColor
                                                          .backgroundColor,
                                                      borderRadius: BorderRadius
                                                          .only(
                                                          topLeft: Radius
                                                              .circular(10.h),
                                                          topRight:
                                                          Radius.circular(
                                                              10.h)),
                                                      gradient: Theme
                                                          .of(context)
                                                          .brightness ==
                                                          Brightness.dark
                                                          ? LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            HexColor.fromHex(
                                                                '#CC0A00')
                                                                .withOpacity(
                                                                0.15),
                                                            HexColor.fromHex(
                                                                '#9F2DBC')
                                                                .withOpacity(
                                                                0.15),
                                                          ])
                                                          : LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            HexColor.fromHex(
                                                                '#FF9E99')
                                                                .withOpacity(
                                                                0.1),
                                                            HexColor.fromHex(
                                                                '#9F2DBC')
                                                                .withOpacity(
                                                                0.023),
                                                          ])),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 15.w),
                                                        child: tagIcon(
                                                          tag: tagMap[
                                                          tagList[index][innerIndex].label],
                                                          height: 33.h,
                                                          width: 33.h,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 12.w),
                                                        child: Container(
                                                          width: 100.w,
                                                          height: 30.h,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child:
                                                          Body1Text(
                                                            text: tagList[index][innerIndex]
                                                                .label ??
                                                                '',
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: Theme
                                                                .of(context)
                                                                .brightness ==
                                                                Brightness.dark
                                                                ? Colors.white
                                                                .withOpacity(
                                                                0.87)
                                                                : HexColor
                                                                .fromHex(
                                                                '384341'),
                                                            textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              right: 10.w),
                                                          child: Align(
                                                            alignment:
                                                            Alignment
                                                                .centerRight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Body1Text(
                                                                  text: DateFormat(
                                                                      DateUtil
                                                                          .MMMddhhmma)
                                                                      .format(
                                                                    // DateTime.parse(
                                                                    //     tagList[index]
                                                                    //         .date
                                                                    //         .toString()),
                                                                      getDateInFormat(
                                                                          tagList[index][innerIndex])),
                                                                  fontSize: 14.sp,
                                                                  color: Theme
                                                                      .of(
                                                                      context)
                                                                      .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                      ? Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0.87)
                                                                      : HexColor
                                                                      .fromHex(
                                                                      '384341'),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                ),
                                                                Image.asset(
                                                                  'asset/up_icon_small.png',
                                                                  height: 26.h,
                                                                  width: 26.h,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDetails = false;
                                                  setState(() {});
                                                },
                                              ),
                                              tagNoteDetail != null
                                                  ? GestureDetector(
                                                onTap: () async {
                                                  var tag = await databaseHelper
                                                      .getTagById(
                                                      tagList[index][innerIndex].tagId ?? 0,
                                                      apiId: tagList[index][innerIndex]
                                                          .tagApiId,
                                                      label:
                                                      tagList[index][innerIndex].label);
                                                  if (tag != null) {
                                                    Constants.navigatePush(
                                                        TagNoteScreen(
                                                          tag: tag,
                                                          tagNote: tagList[index][innerIndex],
                                                        ),
                                                        context);
                                                  }
                                                },
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width -
                                                      26.w,
                                                  decoration: BoxDecoration(
                                                      color: Theme
                                                          .of(context)
                                                          .brightness ==
                                                          Brightness.dark
                                                          ? HexColor.fromHex(
                                                          '#111B1A')
                                                          : AppColor
                                                          .backgroundColor,
                                                      borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                          Radius.circular(
                                                              10.h),
                                                          bottomRight:
                                                          Radius.circular(
                                                              10.h))),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .only(
                                                          left: 15.w,
                                                        ),
                                                        height: 52.5.h,
                                                        child: tagByValue(
                                                            tagMap[
                                                            tagList[index][innerIndex]
                                                                .label]
                                                                ?.tagType) !=
                                                            TagType.bloodGlucose
                                                            ? Row(
                                                          children: [
                                                            Body1AutoText(
                                                              text:
                                                              tagNoteDetail.label.toString() == 'Glucose Patch' ? "${tagNoteDetail.label} :" : tagNoteDetail
                                                                  .heading ,
                                                              color: Theme
                                                                  .of(context)
                                                                  .brightness ==
                                                                  Brightness
                                                                      .dark
                                                                  ? Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.8)
                                                                  : HexColor
                                                                  .fromHex(
                                                                  '#5D6A68'),
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              // align: TextAlign.right,
                                                              minFontSize: 6,
                                                            ),
                                                            Body1AutoText(
                                                              text:tagNoteDetail.label.toString() == 'Glucose Patch' ? tagNoteDetail.patchLocation! : tagNoteDetail
                                                                  .value
                                                                  .toString(),
                                                              color: Theme
                                                                  .of(context)
                                                                  .brightness ==
                                                                  Brightness
                                                                      .dark
                                                                  ? Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.8)
                                                                  : HexColor
                                                                  .fromHex(
                                                                  '#384341'),
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              // align: TextAlign.right,
                                                              minFontSize: 6,
                                                            ),
                                                          ],
                                                        )
                                                            : Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Body1AutoText(
                                                                  text:
                                                                  '${stringLocalization
                                                                      .getText(
                                                                      StringLocalization
                                                                          .MMOLPerLiter)}: ',
                                                                  color: Theme
                                                                      .of(
                                                                      context)
                                                                      .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                      ? Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0.8)
                                                                      : HexColor
                                                                      .fromHex(
                                                                      '#5D6A68'),
                                                                  fontSize:
                                                                  16.sp,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  // align: TextAlign.right,
                                                                  minFontSize:
                                                                  6,
                                                                ),
                                                                Body1AutoText(
                                                                  text: tagNoteDetail
                                                                      .unitType ==
                                                                      '1'
                                                                      ? tagNoteDetail
                                                                      .value
                                                                      .toString()
                                                                      : (tagNoteDetail
                                                                      .value /
                                                                      18)
                                                                      .toStringAsFixed(
                                                                      1),
                                                                  color: Theme
                                                                      .of(
                                                                      context)
                                                                      .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                      ? Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0.8)
                                                                      : HexColor
                                                                      .fromHex(
                                                                      '#384341'),
                                                                  fontSize:
                                                                  16.sp,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  // align: TextAlign.right,
                                                                  minFontSize:
                                                                  6,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  right: 66
                                                                      .h),
                                                              child: Row(
                                                                children: [
                                                                  Body1AutoText(
                                                                    text:
                                                                    '${stringLocalization
                                                                        .getText(
                                                                        StringLocalization
                                                                            .MGDL)}: ',
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                        ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                        0.8)
                                                                        : HexColor
                                                                        .fromHex(
                                                                        '#5D6A68'),
                                                                    fontSize:
                                                                    16.sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    // align: TextAlign.right,
                                                                    minFontSize:
                                                                    6,
                                                                  ),
                                                                  Body1AutoText(
                                                                    text: tagNoteDetail
                                                                        .unitType ==
                                                                        '2'
                                                                        ? tagNoteDetail
                                                                        .value
                                                                        .toString()
                                                                        : (tagNoteDetail
                                                                        .value *
                                                                        18)
                                                                        .toStringAsFixed(
                                                                        1),
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                        ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                        0.8)
                                                                        : HexColor
                                                                        .fromHex(
                                                                        '#384341'),
                                                                    fontSize:
                                                                    16.sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    // align: TextAlign.right,
                                                                    minFontSize:
                                                                    6,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      (tagNoteDetail.note !=
                                                          null &&
                                                          tagNoteDetail.note
                                                              .isNotEmpty) ||
                                                          (tagNoteDetail
                                                              .tagImageList !=
                                                              null &&
                                                              tagNoteDetail
                                                                  .tagImageList!
                                                                  .isNotEmpty)
                                                          ? Container(
                                                        height: 1.h,
                                                        color: Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness
                                                                .dark
                                                            ? Colors.white
                                                            .withOpacity(
                                                            0.15)
                                                            : HexColor
                                                            .fromHex(
                                                            'D9E0E0'),
                                                      )
                                                          : Container(),
                                                      (tagNoteDetail.note !=
                                                          null &&
                                                          tagNoteDetail.note
                                                              .isNotEmpty) ||
                                                          (tagNoteDetail
                                                              .tagImageList !=
                                                              null &&
                                                              tagNoteDetail
                                                                  .tagImageList!
                                                                  .isNotEmpty)
                                                          ? Container(
                                                        decoration:
                                                        BoxDecoration(
                                                            borderRadius:
                                                            // 2 >=
                                                            //         tagNoteDetail.length
                                                            //     ?
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(10
                                                                    .h),
                                                                bottomRight:
                                                                Radius.circular(
                                                                    10.h))
                                                          // : BorderRadius.circular(0.0),
                                                        ),
                                                        // height: 52.5.h,
                                                        child: Container(
                                                          margin:
                                                          EdgeInsets.only(
                                                              bottom:
                                                              21.h),
                                                          // color: Colors.red,
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 20.w,
                                                              right:
                                                              15.w),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                            children: [
                                                              tagNoteDetail
                                                                  .note !=
                                                                  null &&
                                                                  tagNoteDetail
                                                                      .note
                                                                      .isNotEmpty
                                                                  ? SizedBox(
                                                                height:
                                                                11.h,
                                                              )
                                                                  : Container(),
                                                              tagNoteDetail
                                                                  .note !=
                                                                  null &&
                                                                  tagNoteDetail
                                                                      .note
                                                                      .isNotEmpty
                                                                  ? Body1AutoText(
                                                                text:
                                                                'Notes:',
                                                                color: Theme
                                                                    .of(context)
                                                                    .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                    ? Colors
                                                                    .white
                                                                    .withOpacity(
                                                                    0.8)
                                                                    : HexColor
                                                                    .fromHex(
                                                                    '#5D6A68'),
                                                                fontSize:
                                                                16.sp,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                // align: TextAlign.right,
                                                                minFontSize:
                                                                6,
                                                              )
                                                                  : Container(),
                                                              tagNoteDetail
                                                                  .note !=
                                                                  null &&
                                                                  tagNoteDetail
                                                                      .note
                                                                      .isNotEmpty
                                                                  ? Body1AutoText(
                                                                text: tagNoteDetail
                                                                    .note,
                                                                color: Theme
                                                                    .of(context)
                                                                    .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                    ? Colors
                                                                    .white
                                                                    .withOpacity(
                                                                    0.8)
                                                                    : HexColor
                                                                    .fromHex(
                                                                    '#384341'),
                                                                fontSize:
                                                                16.sp,
                                                                // fontWeight: FontWeight.bold,
                                                                // align: TextAlign.right,
                                                                minFontSize:
                                                                6,
                                                                maxLine:
                                                                10,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              )
                                                                  : Container(),
                                                              tagNoteDetail
                                                                  .tagImageList !=
                                                                  null &&
                                                                  tagNoteDetail
                                                                      .tagImageList!
                                                                      .isNotEmpty
                                                                  ? SizedBox(
                                                                height:
                                                                22.h,
                                                              )
                                                                  : Container(),
                                                              tagNoteDetail
                                                                  .tagImageList !=
                                                                  null &&
                                                                  tagNoteDetail
                                                                      .tagImageList!
                                                                      .isNotEmpty
                                                                  ? imagesWidget(
                                                                  tagNoteDetail
                                                                      .tagImageList!)
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              )
                                                  : Container()
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Slidable(
                                          actionPane: SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          secondaryActions: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: innerIndex ==
                                                      (tagList[index].length - 1)
                                                      ? 16.h
                                                      : 0),
                                              child: IconSlideAction(
                                                color: HexColor.fromHex(
                                                    '#FF6259'),
                                                onTap: () async {
                                                  deleteDialog(
                                                      onClickYes: () async {
                                                        if (Navigator.canPop(context)) {
                                                          Navigator.of(context, rootNavigator: true)
                                                              .pop();
                                                        }
                                                        var isInternet = await Constants
                                                            .isInternetAvailable();
                                                        var d = tagList[index][innerIndex];
                                                        tagList[index].removeAt(innerIndex);
                                                        if(tagList[index].isEmpty){
                                                          tagList.removeAt(index);
                                                          showListDetails = false;
                                                        }
                                                        if (isInternet) {
                                                          deleteDataCallApi(
                                                              int.parse(d.apiId ?? '0'),
                                                              d.id ?? 0);
                                                        } else {
                                                          dbHelper
                                                              .deleteTagNoteDetail(d.id ?? 0);
                                                        }
                                                        CustomSnackBar.buildSnackbar(
                                                            context,
                                                            StringLocalization.of(context)
                                                                .getText(StringLocalization
                                                                .tagNoteDeletedSuccessfully),
                                                            3);
                                                        if (mounted) {
                                                          setState(() {});
                                                        }
                                                      }
                                                  );

                                                },
                                                height: 56.h,
                                                topMargin: 16.h,
                                                iconWidget: Text(
                                                  StringLocalization.of(context)
                                                      .getText(
                                                      StringLocalization
                                                          .delete),
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor
                                                        .backgroundColor,
                                                  ),
                                                ),
                                                rightMargin: 13.w,
                                                leftMargin: 0,
                                              ),
                                            )
                                          ],
                                          child: GestureDetector(
                                            key: Key('item_$index'),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 13.w,
                                                  right: 13.w,
                                                  top: 16.h,
                                                  bottom: innerIndex ==
                                                      tagList[index].length - 1
                                                      ? 16.h
                                                      : 0.0),
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                  color: Theme
                                                      .of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? HexColor.fromHex(
                                                      '#111B1A')
                                                      : AppColor
                                                      .backgroundColor,
                                                  borderRadius:
                                                  BorderRadius.circular(10.h),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme
                                                          .of(context)
                                                          .brightness ==
                                                          Brightness.dark
                                                          ? HexColor.fromHex(
                                                          '#D1D9E6')
                                                          .withOpacity(0.1)
                                                          : Colors.white,
                                                      blurRadius: 5,
                                                      spreadRadius: 0,
                                                      offset: Offset(-5, -5),
                                                    ),
                                                    BoxShadow(
                                                      color: Theme
                                                          .of(context)
                                                          .brightness ==
                                                          Brightness.dark
                                                          ? Colors.black
                                                          .withOpacity(0.75)
                                                          : HexColor.fromHex(
                                                          '#9F2DBC')
                                                          .withOpacity(0.15),
                                                      blurRadius: 5,
                                                      spreadRadius: 0,
                                                      offset: Offset(5, 5),
                                                    ),
                                                  ]),
                                              child: Container(
                                                padding:
                                                EdgeInsets.symmetric(
                                                    vertical: 13.h),
                                                decoration: BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .brightness ==
                                                        Brightness.dark
                                                        ? HexColor.fromHex(
                                                        '#111B1A')
                                                        : AppColor
                                                        .backgroundColor,
                                                    borderRadius:
                                                    BorderRadius.circular(10.h),
                                                    gradient: Theme
                                                        .of(context)
                                                        .brightness ==
                                                        Brightness.dark
                                                        ? LinearGradient(
                                                        begin: Alignment
                                                            .topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          HexColor.fromHex(
                                                              '#CC0A00')
                                                              .withOpacity(
                                                              0.15),
                                                          HexColor.fromHex(
                                                              '#9F2DBC')
                                                              .withOpacity(
                                                              0.15),
                                                        ])
                                                        : LinearGradient(
                                                        begin: Alignment
                                                            .topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          HexColor.fromHex(
                                                              '#FF9E99')
                                                              .withOpacity(0.1),
                                                          HexColor.fromHex(
                                                              '#9F2DBC')
                                                              .withOpacity(
                                                              0.023),
                                                        ])),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 15.w),
                                                      child: tagIcon(
                                                        tag: tagMap[tagList[index][innerIndex]
                                                            .label],
                                                        height: 33.h,
                                                        width: 33.h,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 12.w),
                                                      child: Container(
                                                        width: 100.w,
                                                        height: 30.h,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Body1Text(
                                                          text: tagList[index][innerIndex]
                                                              .label!,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Theme
                                                              .of(context)
                                                              .brightness ==
                                                              Brightness.dark
                                                              ? Colors.white
                                                              .withOpacity(0.87)
                                                              : HexColor
                                                              .fromHex(
                                                              '384341'),
                                                          textOverflow:
                                                          TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            right: 10.w),
                                                        child: Align(
                                                          alignment:
                                                          Alignment.centerRight,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Body1Text(
                                                                text: DateFormat(
                                                                    DateUtil
                                                                        .MMMddhhmma)
                                                                    .format(
                                                                  // DateTime.parse(
                                                                  //     tagList[index]
                                                                  //         .date
                                                                  //         .toString()),
                                                                    getDateInFormat(
                                                                        tagList[index][innerIndex])),
                                                                fontSize: 14.sp,
                                                                color: Theme
                                                                    .of(context)
                                                                    .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                    ? Colors
                                                                    .white
                                                                    .withOpacity(
                                                                    0.87)
                                                                    : HexColor
                                                                    .fromHex(
                                                                    '384341'),
                                                              ),
                                                              SizedBox(
                                                                width: 8.w,
                                                              ),
                                                              Image.asset(
                                                                'asset/down_icon_small.png',
                                                                height: 26.h,
                                                                width: 26.h,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              showDetails = true;
                                              currentListIndex = innerIndex;
                                              tagNoteDetail =
                                                  updateDetailList(
                                                      index, innerIndex, tagList[index][innerIndex]);
                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        );
                                      }
                                    }),
                              )
                            ],
                          ),
                        );
                      })
                      : Container(
                          margin: EdgeInsets.only(top: 100.h),
                          child: Body1Text(
                            text: stringLocalization.getText(
                              StringLocalization.noDataFound,
                            ),
                            fontSize: 16,
                          ),
                        ),
                )
        ],
      ),
    );
  }

  DateTime getDateInFormat(TagNote tagNote) {
    try {
      if (tagNote.createdDateTimeStamp != null) {
        return DateUtil().toDateFromTimestamp(tagNote.createdDateTimeStamp!);
      }
      return DateTime.parse(tagNote.date.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  TagHistoryListItems updateDetailList(int index,int innerIndex, TagNote tagNote) {
    TagHistoryListItems tempTagList;
    String str;
    int tagType;
    if(currentIndex == 0){
      tagType = (tagMap[dayTagList[index].label]?.tagType ?? tagNote.tagType)!;
    } else {
      tagType = (tagMap[tagList[index][innerIndex].label]?.tagType ?? tagNote.tagType)!;
    }

    str = '${getTagHeading(tagType, tagNote)}: ';
    tempTagList = TagHistoryListItems(
        heading: str,
        value: getValue(tagNote, tagType),
        note: tagNote.note != null ? tagNote.note! : '',
        patchLocation: tagNote.patchLocation != null ? tagNote.patchLocation! : '',
        label: tagNote.label != null ? tagNote.label! : '',

        unitType: tagNote.unitSelectedType != null ? tagNote.unitSelectedType! : '1');
    if (tagNote.imageFiles != null &&
        tagNote.imageFiles!.isNotEmpty ) {
      tempTagList.tagImageList = [];
    //  tempTagList.tagImageList =
      tagNote.imageFiles!.split(',').forEach((element) {
        tempTagList.tagImageList?.add(element.toString());
      });
    }

    return tempTagList;
  }

  double getValue(TagNote tagNote, int tagType) {
    var value = tagNote.value ?? 0.0;
    if (tagType == TagType.temperature.value && tagNote.value != null) {
      if (tempUnit == 0) {
        if (tagNote.unitSelectedType == '2') {
          value = double.parse(((tagNote.value! - 32) * 5 / 9).toStringAsFixed(1));
        }
      } else {
        if (tagNote.unitSelectedType == '1') {
          value = double.parse(((tagNote.value! * (9 / 5)) + 32).toStringAsFixed(1));
        }
      }
    }
    return value;
  }

  getTagDataFromDb({bool? isDay, bool? isWeek, bool? isMonth}) async {
    if (!isPagePushed) {
      setState(() {
        isLoading = true;
      });
    } else {
      isPagePushed = false;
    }
    showDetails = false;
    tagList.clear();
    dayTagList.clear();
    late DateTime startDate;
    late DateTime endDate;
    if (isDay != null && isDay) {
      startDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      endDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
    } else if (isWeek != null && isWeek) {
      startDate = DateTime(
          firstDateOfWeek.year, firstDateOfWeek.month, firstDateOfWeek.day);
      endDate = DateTime(
          lastDateOfWeek.year, lastDateOfWeek.month, lastDateOfWeek.day + 1);
    } else if (isMonth != null && isMonth) {
      startDate = DateTime(selectedDate.year, selectedDate.month, 1);
      endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
      endDate = endDate.add(Duration(days: 1));
    }

    String strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    String strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);

    await dbHelper
        .getTagNoteList(strFirst, strLast, userId)
        .then((List<TagNote> tagModelList) {
      if (tagModelList.isNotEmpty) {
        dayTagList = tagModelList;
       // data = tagModelList.first;
      }
    });


    dayTagList.forEach((element) {
        print('get_tagList ${element.toMap()}');
      if (element.label == 'Body temperature') {
        element.label = 'Temperature';
      }
    });

    var list = <List<TagNote>>[];
    try {
      if(dayTagList.isNotEmpty) {
        list = WeekAndMonthHistoryData(distinctList: dayTagList).getTagData();
      }
    } catch (e) {
      LoggingService().printLog(tag: 'tag history screen', message: e.toString());
    }
    tagList = list;
    print(tagList.toString());
    if (mounted) {
      isLoading = false;
      setState(() {});
    }
  }

  Widget imagesWidget(List<String> imageList) {
    print(imageList.toString());

    if (imageList != null && imageList.isNotEmpty) {
      return Container(
        // margin: EdgeInsets.only(left: 23.w, right: 23.w),
        child: Center(
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 15.h,
                crossAxisSpacing: 15.w,
              ),
              itemCount: imageList.last.isNotEmpty?imageList.length:imageList.length-1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Uint8List? image;
                String? imageLink;
                if(imageList[index]!=null &&!imageList[index].startsWith("https") && imageList[index]!=""){
                 image = base64Decode(imageList[index]);
                }
                else{
                  imageLink = imageList[index];
                }
                if(imageList[index]==null || imageList[index]==""){
                  return Container();
                }
               else if(image==null && imageLink==null){
                  return Container();
                }
               else{ return   Container(
                  // margin: EdgeInsets.only(
                  //     left: 10.w, right: 10.w, bottom: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.w),
                    child: imageList[index].startsWith("https")?  Image.network(
                      imageLink!,
                      height: 72.h,
                      fit: BoxFit.cover,
                    ):Image.memory(
                      image!,
                      height: 72.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
               }
              }),
        ),
      );
    }

    return Container();
  }

  Future deleteDataCallApi(int recordId, int id) async {
    dbHelper.deleteTagNoteDetail(id);
    var result = await TagRepository().deleteTagRecordByID(recordId);
    if (result.hasData) {
      if (result.getData!.result ?? false) {
        dbHelper.deleteTagNote(id);
      }
    }
    // DeleteTagLabelApi()
    //     .deleteRecord(Constants.baseUrl + 'DeleteTagRecordByID', recordId)
    //     .then((result) {
    //   if (!result['isError']) {
    //     dbHelper.deleteTagNote(id);
    //   }
    // });
  }

  onClickNext() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + 1);
        getTagDataFromDb(isDay: true);
        break;
      case 1:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + 7);
        selectWeek(selectedDate);
        getTagDataFromDb(isWeek: true);
        break;
      case 2:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month + 1, selectedDate.day);
        getTagDataFromDb(isMonth: true);
        break;
    }
  }

  onClickBefore() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day - 1);
        getTagDataFromDb(isDay: true);
        break;
      case 1:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day - 7);
        selectWeek(selectedDate);
        getTagDataFromDb(isWeek: true);
        break;
      case 2:
        if (selectedDate.month == 3 && selectedDate.day > 28) {
          selectedDate =
              DateTime(selectedDate.year, selectedDate.month - 1, 28);
        } else {
          selectedDate = DateTime(
              selectedDate.year, selectedDate.month - 1, selectedDate.day);
        }
        getTagDataFromDb(isMonth: true);
        break;
    }
  }

  selectWeek(DateTime selectedDate) {
    var dayNr = (selectedDate.weekday + 7) % 7;

    firstDateOfWeek = selectedDate.subtract(new Duration(days: (dayNr)));

    lastDateOfWeek = firstDateOfWeek.add(new Duration(days: 6));
  }

  selectedValueText() {
    if (currentIndex == 0) {
      return txtSelectedDate();
    } else if (currentIndex == 1) {
      String first = DateFormat(DateUtil.ddMMyyyy).format(firstDateOfWeek);
      String last = DateFormat(DateUtil.ddMMyyyy).format(lastDateOfWeek);
      return '$first   to   $last';
    } else if (currentIndex == 2) {
      String date = DateFormat(DateUtil.MMMMyyyy).format(selectedDate);
      String year = date.split(' ')[1];
      date = Date().getSelectedMonthLocalization(date) + ' $year';
      return '$date';
    }
  }

  String txtSelectedDate() {
    String title = DateFormat(DateUtil.ddMMyyyyDashed).format(selectedDate);

    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final selected =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selected == today) {
      title = StringLocalization.of(context).getText(StringLocalization.today);
    } else if (selected == yesterday) {
      title =
          StringLocalization.of(context).getText(StringLocalization.yesterday);
    } else if (selected == tomorrow) {
      title =
          StringLocalization.of(context).getText(StringLocalization.tomorrow);
    }
    return '$title';
  }

  Future<bool> makeTagMap(String userId) async {
    List<Tag> tag = await databaseHelper.getAllTagList(userId);
    if (tag.isNotEmpty) {
      tag.forEach((element) {
        tagMap[element.label!] = element;
      });
      return true;
    }
    return false;
  }

  String getTagHeading(int value, TagNote tagNote) {
    switch (value) {
      case 1: //TagType.exercise;
        return stringLocalization.getText(StringLocalization.intensity);
      case 2: //TagType.health;
        return stringLocalization.getText(StringLocalization.value);
      case 3: //TagType.smoke;
        return stringLocalization.getText(StringLocalization.numberOfSmoke);
      case 4: //TagType.bloodGlucose
        return '${stringLocalization.getText(StringLocalization.MMOLPerLiter)} ${stringLocalization.getText(StringLocalization.MGDL)}';
      case 5: //TagType.stress
        return '${stringLocalization.getText(StringLocalization.tagLevel)}${tagNote.label}';
      // return 'Level of Stress';
      case 6: //TagType.fatigue
        return '${stringLocalization.getText(StringLocalization.tagLevel)}${tagNote.label}';
      //return 'Level of Fatigue';
      case 7: //TagType.running;
        return stringLocalization.getText(StringLocalization.intensity);
      case 8: //TagType.temperature;
        if (tempUnit == 0) {
          return stringLocalization.getText(StringLocalization.celsius);
        }
        return stringLocalization.getText(StringLocalization.fahrenheit);
      case 9: //TagType.sleep;
        return stringLocalization.getText(StringLocalization.sleep);
      case 10: //TagType.medicine;
        return stringLocalization.getText(StringLocalization.numberOfPills);
      case 11: //TagType.CORONA;
        return stringLocalization.getText(StringLocalization.corona);
      case 12: //TagType.Alcohol;
        return stringLocalization.getText(StringLocalization.glassOf);
      default: //TagType.health; //
        return stringLocalization.getText(StringLocalization.value);
    }
  }

  Future getPreference() async {
    if (preferences != null)
      userId = preferences!.getString(Constants.prefUserIdKeyInt) ?? '';
  }

   void deleteDialog({required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
        title: stringLocalization.getText(StringLocalization.delete),
        subTitle: stringLocalization.getText(StringLocalization.tagNoteDeleteInfo),
        onClickYes: onClickYes,
        maxLine: 2,
        onClickNo: onClickDeleteNo);
     showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6) : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  void onClickDeleteNo() {
    if (context != null) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }


//
//   Future<void> onclickTag(TagNote tagNote) async {
//     Tag tag =
//         await databaseHelper.getTagById(tagNote.tagId, apiId: tagNote.tagApiId);
//     if (tag != null) {
//       await Constants.navigatePush(
//           TagNoteScreen(tag: tag, tagNote: tagNote), context);
//       await getDayData();
//       await getWeekData();
//       await getMonthData();
//       if (this.mounted) {
//         setState(() {});
//       }
//     }
//   }
}

class TagHistoryListItems {
  String heading;
  double value;
  String note;
  String unitType;
  String label;
  List<String>? tagImageList;
  String? patchLocation;

  TagHistoryListItems(
      {required this.heading,
      required this.value,
      required this.note,
      required this.label,
        this.patchLocation,
      this.tagImageList,
      required this.unitType});
}
