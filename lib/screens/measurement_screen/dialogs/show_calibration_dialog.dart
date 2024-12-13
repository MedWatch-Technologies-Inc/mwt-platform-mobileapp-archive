import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class ShowCalibrationDialog extends StatelessWidget {
  final GestureTapCallback onClickOk;
  final bool isOs;
  final bool isTrng;
  final VoidCallback getCallibrationDataFromHealthKit;
  bool openKeyboardSbp;
  bool openKeyboardHr;
  bool openKeyboardDbp;
  String errorMessageForSBP;
  String errorMessageForHeart;
  var sbpCalibrationTextEditController;
  var dbpCalibrationTextEditController;
  var hrCalibrationTextEditController;
  String errorMessageForDBP;
  bool writingNotes;
  bool isCalibration;
  ValueNotifier<bool?> isSavedFromOscillometric;
  bool isCancelClicked;
  Function uploadDataInServer;
  Function uploadDatatoServerOnCancel;
  Function navigateToTagScreen;
  ShowCalibrationDialog(
      this.uploadDatatoServerOnCancel,
      this.navigateToTagScreen,
      this.uploadDataInServer,
      this.errorMessageForHeart,
      this.isCalibration,
      this.isCancelClicked,
      this.hrCalibrationTextEditController,
      this.isSavedFromOscillometric,
      this.sbpCalibrationTextEditController,
      this.writingNotes,
      this.errorMessageForDBP,
      this.dbpCalibrationTextEditController,
    this.errorMessageForSBP,

    this.openKeyboardDbp,
    this.openKeyboardSbp,
    this.openKeyboardHr,
    this.onClickOk,
    this.isOs,
    this.isTrng,
    this.getCallibrationDataFromHealthKit, {
    Key? key,
  }) : super(key: key);

  // var focusNodeHr = FocusNode();
  // var focusNodeSbp = FocusNode();
  // var focusNodeDbp = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          elevation: 0,
          backgroundColor: isDarkMode(context)
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          child: Container(
            decoration: BoxDecoration(
                color: isDarkMode(context)
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : HexColor.fromHex('#DDE3E3').withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#000000').withOpacity(0.75)
                        : HexColor.fromHex('#7F8D8C'),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ]),
            padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
            // height: 400.h,
            width: 309.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 25.h,
                              child: Body1AutoText(
                                text: isOs
                                    ? StringLocalization.of(context).getText(
                                        StringLocalization.oscillometric)
                                    : isTrng
                                        ? StringLocalization.of(context)
                                            .getText(
                                                StringLocalization.training)
                                        : StringLocalization.of(context)
                                            .getText(
                                                StringLocalization.calibration),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode(context)
                                    ? HexColor.fromHex('#FFFFFF')
                                        .withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                                minFontSize: 12,
                              ),
                            ),
                          ),
                          // (!isOs && !isTrng ) ?
                          IconButton(
                            icon: Image.asset('asset/health_kit_icon.png'),
                            onPressed: getCallibrationDataFromHealthKit,
                            iconSize: 20.w,
                          ),
                        ]),
                  ),
//              content:
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 5.h,
                      ),
                      width: 309.w,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: SizedBox(
                              height: 58.h,
                              child: Body1AutoText(
                                  text: StringLocalization.of(context).getText(
                                      StringLocalization.shortDescription),
                                  maxLine: 2,
                                  fontSize: 16.sp,
                                  color: isDarkMode(context)
                                      ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.87)
                                      : HexColor.fromHex('#384341')),
                            ),
                          ),
                          Container(
                            // height: 48.h,
                            margin: EdgeInsets.only(
                                top: 10.h, left: 10.w, right: 10.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.h)),
                                color: isDarkMode(context)
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode(context)
                                        ? HexColor.fromHex('#D1D9E6')
                                            .withOpacity(0.1)
                                        : Colors.white.withOpacity(0.7),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(-4, -4),
                                  ),
                                  BoxShadow(
                                    color: isDarkMode(context)
                                        ? Colors.black.withOpacity(0.75)
                                        : HexColor.fromHex('#9F2DBC')
                                            .withOpacity(0.15),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(4, 4),
                                  ),
                                ]),
                            child: Container(
                                decoration: openKeyboardSbp
                                    ? ConcaveDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        depression: 10,
                                        colors: [
                                            isDarkMode(context)
                                                ? Colors.black
                                                    .withOpacity(0.5)
                                                : HexColor.fromHex('#D1D9E6'),
                                            isDarkMode(context)
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.07)
                                                : Colors.white,
                                          ])
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.h)),
                                        color: isDarkMode(context)
                                            ? HexColor.fromHex('#111B1A')
                                            : AppColor.backgroundColor,
                                      ),
                                child: TextFormField(
                                  // autofocus: openKeyboardSbp,
                                  // focusNode: focusNodeSbp,
                                  controller:
                                      sbpCalibrationTextEditController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 16.w,
                                        bottom: 11.h,
                                        top: 11.h,
                                        right: 16.w),
                                    hintText: errorMessageForSBP.isNotEmpty
                                        ? errorMessageForSBP
                                        : StringLocalization.of(context)
                                            .getText(
                                                StringLocalization.sbd),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: errorMessageForSBP.isNotEmpty
                                            ? HexColor.fromHex('FF6259')
                                            : HexColor.fromHex('7F8D8C')),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  // Only number
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                )),
                          ),
                          Container(
                              // height: 48.h,
                              margin: EdgeInsets.only(
                                  top: 17.h, left: 10.w, right: 10.w),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.h)),
                                  color: isDarkMode(context)
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDarkMode(context)
                                          ? HexColor.fromHex('#D1D9E6')
                                              .withOpacity(0.1)
                                          : Colors.white.withOpacity(0.7),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(-4, -4),
                                    ),
                                    BoxShadow(
                                      color: isDarkMode(context)
                                          ? Colors.black.withOpacity(0.75)
                                          : HexColor.fromHex('#9F2DBC')
                                              .withOpacity(0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(4, 4),
                                    ),
                                  ]),
                              child: Container(
                                  decoration: openKeyboardDbp
                                      ? ConcaveDecoration(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.h)),
                                          depression: 10,
                                          colors: [
                                              isDarkMode(context)
                                                  ? Colors.black
                                                      .withOpacity(0.5)
                                                  : HexColor.fromHex(
                                                      '#D1D9E6'),
                                              isDarkMode(context)
                                                  ? HexColor.fromHex(
                                                          '#D1D9E6')
                                                      .withOpacity(0.07)
                                                  : Colors.white,
                                            ])
                                      : BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.h)),
                                          color: isDarkMode(context)
                                              ? HexColor.fromHex('#111B1A')
                                              : AppColor.backgroundColor,
                                        ),
                                  child: TextFormField(
                                    // autofocus: openKeyboardDbp,
                                    // focusNode: focusNodeDbp,
                                    controller:
                                        dbpCalibrationTextEditController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 16.w,
                                        bottom: 11.h,
                                        top: 11.h,
                                        right: 16.w,
                                      ),
                                      hintText: errorMessageForDBP
                                              .isNotEmpty
                                          ? errorMessageForDBP
                                          : StringLocalization.of(context)
                                              .getText(
                                                  StringLocalization.dbp),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 16.sp,
                                          color: errorMessageForDBP
                                                  .isNotEmpty
                                              ? HexColor.fromHex('FF6259')
                                              : HexColor.fromHex('7F8D8C')),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly
                                    ],
                                    // Only number
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                  ))),
                          Container(
                            // height: 48.h,
                            margin: EdgeInsets.only(
                                top: 17.h, left: 10.w, right: 10.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.h)),
                                color: isDarkMode(context)
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode(context)
                                        ? HexColor.fromHex('#D1D9E6')
                                            .withOpacity(0.1)
                                        : Colors.white.withOpacity(0.7),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(-4, -4),
                                  ),
                                  BoxShadow(
                                    color: isDarkMode(context)
                                        ? Colors.black.withOpacity(0.75)
                                        : HexColor.fromHex('#9F2DBC')
                                            .withOpacity(0.15),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(4, 4),
                                  ),
                                ]),
                            child: Container(
                                decoration: openKeyboardHr
                                    ? ConcaveDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        depression: 10,
                                        colors: [
                                            isDarkMode(context)
                                                ? Colors.black
                                                    .withOpacity(0.5)
                                                : HexColor.fromHex('#D1D9E6'),
                                            isDarkMode(context)
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.07)
                                                : Colors.white,
                                          ])
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: isDarkMode(context)
                                            ? HexColor.fromHex('#111B1A')
                                            : AppColor.backgroundColor,
                                      ),
                                child: TextFormField(
                                  // autofocus: openKeyboardHr,
                                  // focusNode: focusNodeHr,
                                  controller:
                                      hrCalibrationTextEditController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 16.w,
                                        bottom: 11.h,
                                        top: 11.h,
                                        right: 16.w),
                                    hintText: errorMessageForHeart
                                            .isNotEmpty
                                        ? errorMessageForHeart
                                        : StringLocalization.of(context)
                                            .getText(StringLocalization.hr),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: errorMessageForHeart
                                                .isNotEmpty
                                            ? HexColor.fromHex('FF6259')
                                            : HexColor.fromHex('7F8D8C')),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  // Only number
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                )),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Expanded(
                                  child: GestureDetector(
                                      key: Key('clickonAddButton'),
                                      child: Container(
                                        height: 34.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(30.h),
                                          color: HexColor.fromHex('#00AFAA'),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isDarkMode(context)
                                                  ? HexColor.fromHex('#D1D9E6')
                                                  .withOpacity(0.1)
                                                  : Colors.white,
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset(-5, -5),
                                            ),
                                            BoxShadow(
                                              color: isDarkMode(context)
                                                  ? Colors.black
                                                  .withOpacity(0.75)
                                                  : HexColor.fromHex('#D1D9E6'),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset(5, 5),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: ConcaveDecoration(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(30.h),
                                              ),
                                              depression: 10,
                                              colors: [
                                                Colors.white,
                                                HexColor.fromHex('#D1D9E6'),
                                              ]),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Body1AutoText(
                                                text: isOs || isTrng
                                                    ? StringLocalization.of(
                                                    context)
                                                    .getText(
                                                    StringLocalization
                                                        .add)
                                                    .toUpperCase()
                                                    : StringLocalization.of(
                                                    context)
                                                    .getText(
                                                    StringLocalization
                                                        .ok)
                                                    .toUpperCase(),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode(context)
                                                    ? HexColor.fromHex(
                                                    '#111B1A')
                                                    : Colors.white,
                                                minFontSize: 6,
                                                // maxLine: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        var validate = true;
                                        if (hrCalibrationTextEditController
                                            .text ==
                                            '') {
                                          errorMessageForHeart =
                                          'Enter Heart Rate';
                                          validate = false;
                                        }
                                        if (sbpCalibrationTextEditController
                                            .text ==
                                            '') {
                                          errorMessageForSBP = 'Enter SBP';
                                          validate = false;
                                        }
                                        if (dbpCalibrationTextEditController
                                            .text ==
                                            '') {
                                          errorMessageForDBP = 'Enter DBP';
                                          validate = false;
                                        }
                                        try {
                                          if (hrCalibrationTextEditController
                                              .text.length >
                                              3 ||
                                              (int.tryParse(
                                                  hrCalibrationTextEditController
                                                      .text) ??
                                                  0) <
                                                  10) {
                                            errorMessageForHeart =
                                            'Enter valid Heart Rate';
                                            hrCalibrationTextEditController
                                                .text = '';
                                            validate = false;
                                          }
                                        } catch (e) {
                                          LoggingService().warning(
                                              'Measurement', 'Exception ',
                                              error: e);
                                        }
                                        try {
                                          if (sbpCalibrationTextEditController
                                              .text.length >
                                              3 ||
                                              (int.tryParse(
                                                  sbpCalibrationTextEditController
                                                      .text) ??
                                                  0) <
                                                  10) {
                                            errorMessageForSBP =
                                            'Enter valid SBP';
                                            sbpCalibrationTextEditController
                                                .text = '';
                                            validate = false;
                                          }
                                        } catch (e) {
                                          LoggingService().warning(
                                              'Measurement', 'Exception ',
                                              error: e);
                                        }
                                        try {
                                          if (dbpCalibrationTextEditController
                                              .text.length >
                                              3 ||
                                              (int.tryParse(
                                                  dbpCalibrationTextEditController
                                                      .text) ??
                                                  0) <
                                                  10) {
                                            errorMessageForDBP =
                                            'Enter valid DBP';
                                            dbpCalibrationTextEditController
                                                .text = '';
                                            validate = false;
                                          }
                                        } catch (e) {
                                          LoggingService().warning(
                                              'Measurement', 'Exception ',
                                              error: e);
                                        }
                                        setState(() {});
                                        if (validate) {
                                          openKeyboardHr = false;
                                          openKeyboardSbp = false;
                                          openKeyboardDbp = false;
                                          onClickOk();
                                        }
                                        print('validation check :: ${sbpCalibrationTextEditController.text.toString()}');
                                        print('validation check :: ${dbpCalibrationTextEditController.text.toString()}');
                                        print('validation check :: ${hrCalibrationTextEditController.text.toString()}');
                                      }),
                                ),
                                SizedBox(width: 11.w),
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      height: 34.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.h),
                                          color: HexColor.fromHex('#FF6259')
                                              .withOpacity(0.8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isDarkMode(context)
                                                  ? HexColor.fromHex('#D1D9E6')
                                                      .withOpacity(0.1)
                                                  : Colors.white,
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset(-5, -5),
                                            ),
                                            BoxShadow(
                                              color: isDarkMode(context)
                                                  ? Colors.black
                                                      .withOpacity(0.75)
                                                  : HexColor.fromHex('#D1D9E6'),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset(5, 5),
                                            ),
                                          ]),
                                      child: Container(
                                        decoration: ConcaveDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.h),
                                            ),
                                            depression: 10,
                                            colors: [
                                              Colors.white,
                                              HexColor.fromHex('#D1D9E6'),
                                            ]),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Body1AutoText(
                                              text: StringLocalization.of(
                                                      context)
                                                  .getText(
                                                      StringLocalization.cancel)
                                                  .toUpperCase(),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode(context)
                                                  ? HexColor.fromHex('#111B1A')
                                                  : Colors.white,
                                              minFontSize: 6,
                                              // maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      errorMessageForDBP = '';
                                      errorMessageForSBP = '';
                                      errorMessageForHeart = '';
                                      hrCalibrationTextEditController.text = '';
                                      sbpCalibrationTextEditController.text =
                                          '';
                                      dbpCalibrationTextEditController.text =
                                          '';
                                      writingNotes = false;
                                      openKeyboardDbp = false;
                                      openKeyboardSbp = false;
                                      openKeyboardHr = false;
                                      var aiDBP = 0;
                                      var aiSBP = 0;
                                      // isOscillometricOn=false;
                                      if (isOs || isTrng) {
                                        isCancelClicked = true;
                                      }
                                      print('Navigate Calibration :: ${!isCalibration}');
                                      Navigator.of(context, rootNavigator: false).pop(false);
                                      if (!isCalibration) {
                                        isCalibration = false;
                                        isSavedFromOscillometric.value =
                                            false;
                                        uploadDatatoServerOnCancel();
                                      }
                                                                        },
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  )
                ],
              ),
            ),
          ));
    });
  }
}


