import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/SavePreferenceScreen/models/set_tts_and_stt_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:provider/provider.dart';

class SetTtsAndSttScreen extends StatefulWidget {
  @override
  _SetTtsAndSttScreenState createState() => _SetTtsAndSttScreenState();
}

class _SetTtsAndSttScreenState extends State<SetTtsAndSttScreen> {
  SetTtsAndSttModel setTtsAndSttModel = SetTtsAndSttModel();

  languagePicker() {
    return Container(
      height: 200.0.h,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                key:Key('cancelButton'),
                onTap: () {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1Text(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.cancel)
                          .toUpperCase()),
                ),
              ),
              InkWell(
                key: Key("confirmButton"),
                onTap: () {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1Text(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.confirm)
                          .toUpperCase()),
                ),
              ),
            ],
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150.0.w,
                  child: CustomCupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: setTtsAndSttModel.languages
                            .indexOf(setTtsAndSttModel.selectedLanguage)),
                    backgroundColor: Theme.of(context).cardColor,
                    children: List.generate(setTtsAndSttModel.languages.length,
                        (index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                        child: TitleText(
                          text: setTtsAndSttModel.languages[index]
                              .toString()
                              .toUpperCase(),
                        ),
                      );
                    }),
                    onSelectedItemChanged: (index) {
                      setTtsAndSttModel.isEdit = true;
                      setTtsAndSttModel
                          .changeLanguage(setTtsAndSttModel.languages[index]);
                    },
                    itemExtent: 28,
                    looping: false,
                  ),
                ),
                SizedBox(width: 5.0.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  localePicker() {
    return Container(
      height: 250.0.h,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1Text(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.confirm)
                          .toUpperCase()),
                ),
              ),
              InkWell(
                onTap: () {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1Text(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.cancel)
                          .toUpperCase()),
                ),
              ),

            ],
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150.0.w,
                  child: CustomCupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: setTtsAndSttModel.localeNames!
                            .indexOf(setTtsAndSttModel.currentLocale!)),
                    backgroundColor: Theme.of(context).cardColor,
                    children: List.generate(
                        setTtsAndSttModel.localeNames!.length, (index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                        child: TitleText(
                          text:
                              '${setTtsAndSttModel.localeNames?[index].name} (${setTtsAndSttModel.localeNames?[index].localeId})',
                        ),
                      );
                    }),
                    onSelectedItemChanged: (index) {
                      setTtsAndSttModel.isEdit = true;
                      setTtsAndSttModel
                          .changeLocale(setTtsAndSttModel.localeNames![index]);
                    },
                    itemExtent: 40,
                    looping: false,
                  ),
                ),
                SizedBox(width: 5.0.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  voicesPicker() {
    return Container(
      height: 250.0.h,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1Text(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.confirm)
                          .toUpperCase()),
                ),
              ),
              InkWell(
                onTap: () {
                  if (context != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 8.w), // constant given
                  child: Body1Text(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.cancel)
                          .toUpperCase()),
                ),
              ),

            ],
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150.0.w,
                  child: CustomCupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: setTtsAndSttModel.voiceOptions
                            .indexOf(setTtsAndSttModel.selectedVoice)),
                    backgroundColor: Theme.of(context).cardColor,
                    children: List.generate(
                        setTtsAndSttModel.voiceOptions.length, (index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                        child: TitleText(
                          text:
                              '${setTtsAndSttModel.voiceOptions[index]["voiceName"]}'
                                  .toUpperCase(),
                        ),
                      );
                    }),
                    onSelectedItemChanged: (index) {
                      setTtsAndSttModel.isEdit = true;
                      setTtsAndSttModel
                          .changeVoice(setTtsAndSttModel.voiceOptions[index]);
                    },
                    itemExtent: 40,
                    looping: false,
                  ),
                ),
                SizedBox(width: 5.0.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: setTtsAndSttModel,
      child:
      // Consumer<SetTtsAndSttModel>(
      //   builder: (context, model, child) {
      //     return
      Selector<SetTtsAndSttModel, bool>(
        selector: (context, model) => model.isLoading,
        builder: (context, isLoading, child) {
          return isLoading
              ? Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                    title: SizedBox(
                      height: 28,
                      child: AutoSizeText(
                        StringLocalization.of(context)
                            .getText(StringLocalization.voiceConfiguration),
                        style: TextStyle(
                            fontSize: 18,
                            color: HexColor.fromHex("62CBC9"),
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        minFontSize: 2,
                      ),
//                      child: FittedTitleText(
//                        text: StringLocalization.of(context)
//                            .getText(StringLocalization.voiceConfiguration),
//                        fontSize: 18,
//                        color: HexColor.fromHex("62CBC9"),
//                        fontWeight: FontWeight.bold,
//                        // maxLine: 1,
//                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      padding: EdgeInsets.only(left: 10),
                      onPressed: () {
                        Navigator.of(context).pop();
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
                  ),
                  body: Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.darkBackgroundColor
                          : AppColor.backgroundColor,
                      child: Center(child: CircularProgressIndicator())))
              : Scaffold(
                  // bottomNavigationBar:
                  //     model.isLoading ? Container() : bottomButton(),
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                    title: SizedBox(
                      height: 28,
                      child: AutoSizeText(
                        StringLocalization.of(context)
                            .getText(StringLocalization.voiceConfiguration),
                        style: TextStyle(
                            fontSize: 18,
                            color: HexColor.fromHex("62CBC9"),
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
//                      child: FittedTitleText(
//                        text: StringLocalization.of(context)
//                            .getText(StringLocalization.voiceConfiguration),
//                        fontSize: 18,
//                        color: HexColor.fromHex("62CBC9"),
//                        fontWeight: FontWeight.bold,
//                        // maxLine: 1,
//                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      padding: EdgeInsets.only(left: 10),
                      onPressed: () {
                        Navigator.of(context).pop();
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
                    actions: [
                      IconButton(
                        onPressed: () async {
                          setTtsAndSttModel.resetValues();
                          Navigator.of(context).pop();
                        },
                        icon: Image.asset(
                          "asset/reload.png",
                          height: 33.h,
                          width: 33.h,
                        ),
                      ),
                    ],
                  ),
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 33.w),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15.h),
                          child: Center(
                            child: TitleText(
                              text: stringLocalization
                                  .getText(StringLocalization.tts),
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex("#384341"),
                            ),
                          ),
                        ),
                        Container(
                          // height: 25.h,
                          margin: EdgeInsets.only(bottom: 15.h),
                          child: Center(
                            child: TitleText(
                              text: 'Volume',
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex("#384341"),
                            ),
                          ),
                        ),
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(bottom: 25.h),
                          height: 35.h,
                          width: 259.w,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.8)
                                  : HexColor.fromHex("#D1D9E6"),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, 2.h),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.8)
                                  : HexColor.fromHex("#D1D9E6"),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, -2.h),
                            ),
                          ]),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex("#111B1A")
                                  : HexColor.fromHex("#F2F2F2"),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#212D2B")
                                        : HexColor.fromHex("#FFFFFF"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                  ]),
                            ),
                            height: 35.h,
                            width: 259.w,
                            child: RotatedBox(
                              quarterTurns: 135,
                              child: Selector<SetTtsAndSttModel, int>(
                                selector: (context, model) => setTtsAndSttModel
                                    .volumeList
                                    .indexOf(setTtsAndSttModel.volume!),
                                builder: (context, currentIndex, child) =>
                                    CustomCupertinoPicker(
                                  // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                                  backgroundColor: Colors.transparent,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: currentIndex),
                                  itemExtent: 60.w,
                                  children: List.generate(
                                      setTtsAndSttModel.volumeList.length,
                                      (index) {
                                    return RotatedBox(
                                      quarterTurns: 45,
                                      child: Container(
                                
                                        //margin: EdgeInsets.all(7.0.sp),
                                        child: Center(
                                          child: TitleText(
                                            text: double.parse(setTtsAndSttModel
                                                    .volumeList[index]
                                                    .toStringAsFixed(2))
                                                .toString()
                                                .padLeft(2, "0")
                                            /*.replaceAll(regex, "")*/,
                                            color: setTtsAndSttModel.volume ==
                                                    setTtsAndSttModel
                                                        .volumeList[index]
                                                ? HexColor.fromHex("#FF6259")
                                                : Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            "#FFFFFF")
                                                        .withOpacity(0.6)
                                                    : HexColor.fromHex(
                                                        "#5D6A68"),
                                            fontWeight:
                                                setTtsAndSttModel.volume ==
                                                        setTtsAndSttModel
                                                            .volumeList[index]
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  onSelectedItemChanged: (int value) {
                                    setTtsAndSttModel.isEdit = true;
                                    setTtsAndSttModel.changeVolume(
                                        setTtsAndSttModel.volumeList[value]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        )),
                        Container(
                          // height: 25.h,
                          margin: EdgeInsets.only(bottom: 15.h),
                          child: Center(
                            child: TitleText(
                              text: 'Pitch',
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex("#384341"),
                            ),
                          ),
                        ),
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(bottom: 25),
                          height: 35.h,
                          width: 259.w,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.8)
                                  : HexColor.fromHex("#D1D9E6"),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, 2.h),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.8)
                                  : HexColor.fromHex("#D1D9E6"),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, -2.h),
                            ),
                          ]),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex("#111B1A")
                                  : HexColor.fromHex("#F2F2F2"),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#212D2B")
                                        : HexColor.fromHex("#FFFFFF"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                  ]),
                            ),
                            height: 35.h,
                            width: 259.w,
                            child: RotatedBox(
                              quarterTurns: 135,
                              child: Selector<SetTtsAndSttModel, int>(
                                selector: (context, model) => setTtsAndSttModel
                                    .pitchList
                                    .indexOf(setTtsAndSttModel.pitch!),
                                builder: (context, currentIndex, child) =>
                                    CustomCupertinoPicker(
                                  // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                                  backgroundColor: Colors.transparent,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: currentIndex),
                                  itemExtent: 60.w,

                                  children: List.generate(
                                      setTtsAndSttModel.pitchList.length,
                                      (index) {
                                    return RotatedBox(
                                      quarterTurns: 45,
                                      child: Container(
                                        //margin: EdgeInsets.all(7.0.sp),
                                        child: Center(
                                          child: TitleText(
                                            text: double.parse(setTtsAndSttModel
                                                    .pitchList[index]
                                                    .toStringAsFixed(2))
                                                .toString()
                                                .padLeft(2, "0")
                                            /*.replaceAll(regex, "")*/,
                                            color: setTtsAndSttModel.pitch ==
                                                    setTtsAndSttModel
                                                        .pitchList[index]
                                                ? HexColor.fromHex("#FF6259")
                                                : Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            "#FFFFFF")
                                                        .withOpacity(0.6)
                                                    : HexColor.fromHex(
                                                        "#5D6A68"),
                                            fontWeight:
                                                setTtsAndSttModel.pitch ==
                                                        setTtsAndSttModel
                                                            .pitchList[index]
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  onSelectedItemChanged: (int value) {
                                    setTtsAndSttModel.isEdit = true;
                                    setTtsAndSttModel.changePitch(
                                        setTtsAndSttModel.pitchList[value]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        )),
                        Container(
                          // height: 25.h,
                          margin: EdgeInsets.only(bottom: 15.h),
                          child: Center(
                            child: TitleText(
                              text: stringLocalization
                                  .getText(StringLocalization.speed),
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex("#384341"),
                            ),
                          ),
                        ),
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(bottom: 25),
                          height: 35.h,
                          width: 259.w,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.8)
                                  : HexColor.fromHex("#D1D9E6"),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, 2.h),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.8)
                                  : HexColor.fromHex("#D1D9E6"),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, -2.h),
                            ),
                          ]),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex("#111B1A")
                                  : HexColor.fromHex("#F2F2F2"),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#212D2B")
                                        : HexColor.fromHex("#FFFFFF"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : HexColor.fromHex("#E7EBF2"),
                                  ]),
                            ),
                            height: 35.h,
                            width: 259.w,
                            child: RotatedBox(
                              quarterTurns: 135,
                              child: Selector<SetTtsAndSttModel, int>(
                                selector: (context, model) => setTtsAndSttModel
                                    .rateList
                                    .indexOf(setTtsAndSttModel.rate!),
                                builder: (context, currentIndex, child) =>
                                    CustomCupertinoPicker(
                                  // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                                  backgroundColor: Colors.transparent,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: currentIndex),
                                  itemExtent: 60.w,

                                  children: List.generate(
                                      setTtsAndSttModel.rateList.length,
                                      (index) {
                                    return RotatedBox(
                                      quarterTurns: 45,
                                      child: Container(
                                        //margin: EdgeInsets.all(7.0.sp),
                                        child: Center(
                                          child: TitleText(
                                            text: double.parse(setTtsAndSttModel
                                                    .rateList[index]
                                                    .toStringAsFixed(2))
                                                .toString()
                                                .padLeft(2, "0")
                                            /*.replaceAll(regex, "")*/,
                                            color: setTtsAndSttModel.rate ==
                                                    setTtsAndSttModel
                                                        .rateList[index]
                                                ? HexColor.fromHex("#FF6259")
                                                : Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            "#FFFFFF")
                                                        .withOpacity(0.6)
                                                    : HexColor.fromHex(
                                                        "#5D6A68"),
                                            fontWeight:
                                                setTtsAndSttModel.rate ==
                                                        setTtsAndSttModel
                                                            .rateList[index]
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  onSelectedItemChanged: (int value) {
                                    setTtsAndSttModel.isEdit = true;
                                    setTtsAndSttModel.changeRate(
                                        setTtsAndSttModel.rateList[value]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        )),
                        Container(
                          margin: EdgeInsets.only(
                              top: 15.h, left: 18.w, right: 18.w, bottom: 25.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Body1AutoText(
                                  text: stringLocalization.getText(
                                      StringLocalization.selectLanguage),
                                  maxLine: 3,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex("#384341"),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Selector<SetTtsAndSttModel, String>(
                                selector: (context, model) =>
                                    model.selectedLanguage != null
                                        ? model.selectedLanguage!.toUpperCase()
                                        : '',
                                builder: (context, selectedLanguage, child) =>
                                    Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              Theme.of(context).cardColor,
                                          useRootNavigator: true,
                                          builder: (context) {
                                            return languagePicker();
                                          },
                                        );
                                      },
                                      child: Text(
                                        selectedLanguage,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 15.h, left: 18.w, right: 18.w, bottom: 25.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Body1AutoText(
                                  text: stringLocalization
                                      .getText(StringLocalization.selectVoice),
                                  maxLine: 3,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex("#384341"),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Selector<SetTtsAndSttModel, String>(
                                selector: (context, model) =>
                                    model.selectedVoice != null
                                        ? model.selectedVoice['voiceName']
                                            .toUpperCase()
                                        : '',
                                builder: (context, selectedVoice, child) =>
                                    Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              Theme.of(context).cardColor,
                                          useRootNavigator: true,
                                          builder: (context) {
                                            return voicesPicker();
                                          },
                                        );
                                      },
                                      child: Text(
                                        selectedVoice,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15.h),
                          child: Center(
                            key: Key('changeLanguageButton'),
                            child: TitleText(
                              text: stringLocalization
                                  .getText(StringLocalization.stt),
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex("#384341"),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 15.h, left: 20.w, right: 20.w, bottom: 39.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Body1AutoText(
                                  text: 'Locale',
                                  maxLine: 3,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex("#384341"),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Selector<SetTtsAndSttModel, String>(
                                selector: (context, model) =>
                                    model.currentLocale != null
                                        ? model.currentLocale!.name
                                        : '',
                                builder: (context, currentLocaleName, child) =>
                                    Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              Theme.of(context).cardColor,
                                          useRootNavigator: true,
                                          builder: (context) {
                                            return localePicker();
                                          },
                                        );
                                      },
                                      child: Text(
                                        currentLocaleName,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex("#384341"),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text('Set pitch to be 1 or less for male voice'),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                                'Set pitch to be 1.2 or more for female voice'),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        isLoading ? Container() : bottomButton(),
                      ],
                    ),
                  )

                  // SingleChildScrollView(
                  //   child: model.isLoading
                  //       ? Center(child: CircularProgressIndicator())
                  //       : Container(
                  //           height: MediaQuery.of(context).size.height,
                  //           padding: EdgeInsets.symmetric(horizontal: 33.w),
                  //           color:
                  //               Theme.of(context).brightness == Brightness.dark
                  //                   ? AppColor.darkBackgroundColor
                  //                   : AppColor.backgroundColor,
                  //           child: Column(children: [
                  //             Container(
                  //               margin: EdgeInsets.symmetric(vertical: 15.h),
                  //               child: Center(
                  //                 child: TitleText(
                  //                   text: 'Text To Speech',
                  //                   align: TextAlign.center,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 20.sp,
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.white.withOpacity(0.87)
                  //                       : HexColor.fromHex("#384341"),
                  //                 ),
                  //               ),
                  //             ),
                  //             Container(
                  //               height: 25.h,
                  //               margin: EdgeInsets.only(bottom: 15.h),
                  //               child: Center(
                  //                 child: TitleText(
                  //                   text: 'Set Volume',
                  //                   align: TextAlign.center,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 16.sp,
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.white.withOpacity(0.87)
                  //                       : HexColor.fromHex("#384341"),
                  //                 ),
                  //               ),
                  //             ),
                  //             Center(
                  //                 child: Container(
                  //               margin: EdgeInsets.only(bottom: 25.h),
                  //               height: 35.h,
                  //               width: 259.w,
                  //               decoration: BoxDecoration(boxShadow: [
                  //                 BoxShadow(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.black.withOpacity(0.8)
                  //                       : HexColor.fromHex("#D1D9E6"),
                  //                   blurRadius: 3,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(0, 2.h),
                  //                 ),
                  //                 BoxShadow(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.black.withOpacity(0.8)
                  //                       : HexColor.fromHex("#D1D9E6"),
                  //                   blurRadius: 3,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(0, -2.h),
                  //                 ),
                  //               ]),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? HexColor.fromHex("#111B1A")
                  //                       : HexColor.fromHex("#F2F2F2"),
                  //                   gradient: LinearGradient(
                  //                       begin: Alignment.centerLeft,
                  //                       end: Alignment.centerRight,
                  //                       colors: [
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? HexColor.fromHex("#212D2B")
                  //                             : HexColor.fromHex("#FFFFFF"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                       ]),
                  //                 ),
                  //                 height: 35.h,
                  //                 width: 259.w,
                  //                 child: RotatedBox(
                  //                   quarterTurns: 135,
                  //                   child: CustomCupertinoPicker(
                  //                     // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                  //                     backgroundColor: Colors.transparent,
                  //                     scrollController:
                  //                         FixedExtentScrollController(
                  //                             initialItem: model.volumeList
                  //                                     .indexOf(model.volume) ??
                  //                                 0),
                  //                     itemExtent: 60.w,
                  //
                  //                     children: List.generate(
                  //                         model.volumeList.length, (index) {
                  //                       return RotatedBox(
                  //                         quarterTurns: 45,
                  //                         child: Container(
                  //                           //margin: EdgeInsets.all(7.0.sp),
                  //                           child: Center(
                  //                             child: TitleText(
                  //                               text: double.parse(model
                  //                                       .volumeList[index]
                  //                                       .toStringAsFixed(2))
                  //                                   .toString()
                  //                                   .padLeft(2, "0")
                  //                               /*.replaceAll(regex, "")*/,
                  //                               color: model.volume ==
                  //                                       model.volumeList[index]
                  //                                   ? HexColor.fromHex(
                  //                                       "#FF6259")
                  //                                   : Theme.of(context)
                  //                                               .brightness ==
                  //                                           Brightness.dark
                  //                                       ? HexColor.fromHex(
                  //                                               "#FFFFFF")
                  //                                           .withOpacity(0.6)
                  //                                       : HexColor.fromHex(
                  //                                           "#5D6A68"),
                  //                               fontWeight: model.volume ==
                  //                                       model.volumeList[index]
                  //                                   ? FontWeight.bold
                  //                                   : FontWeight.normal,
                  //                               fontSize: 18.sp,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     }),
                  //                     onSelectedItemChanged: (int value) {
                  //                       model.changeVolume(
                  //                           model.volumeList[value]);
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //             )),
                  //             Container(
                  //               height: 25.h,
                  //               margin: EdgeInsets.only(bottom: 15.h),
                  //               child: Center(
                  //                 child: TitleText(
                  //                   text: 'Set Pitch',
                  //                   align: TextAlign.center,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 16.sp,
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.white.withOpacity(0.87)
                  //                       : HexColor.fromHex("#384341"),
                  //                 ),
                  //               ),
                  //             ),
                  //             Center(
                  //                 child: Container(
                  //               margin: EdgeInsets.only(bottom: 25),
                  //               height: 35.h,
                  //               width: 259.w,
                  //               decoration: BoxDecoration(boxShadow: [
                  //                 BoxShadow(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.black.withOpacity(0.8)
                  //                       : HexColor.fromHex("#D1D9E6"),
                  //                   blurRadius: 3,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(0, 2.h),
                  //                 ),
                  //                 BoxShadow(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.black.withOpacity(0.8)
                  //                       : HexColor.fromHex("#D1D9E6"),
                  //                   blurRadius: 3,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(0, -2.h),
                  //                 ),
                  //               ]),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? HexColor.fromHex("#111B1A")
                  //                       : HexColor.fromHex("#F2F2F2"),
                  //                   gradient: LinearGradient(
                  //                       begin: Alignment.centerLeft,
                  //                       end: Alignment.centerRight,
                  //                       colors: [
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? HexColor.fromHex("#212D2B")
                  //                             : HexColor.fromHex("#FFFFFF"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                       ]),
                  //                 ),
                  //                 height: 35.h,
                  //                 width: 259.w,
                  //                 child: RotatedBox(
                  //                   quarterTurns: 135,
                  //                   child: CustomCupertinoPicker(
                  //                     // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                  //                     backgroundColor: Colors.transparent,
                  //                     scrollController:
                  //                         FixedExtentScrollController(
                  //                             initialItem: model.pitchList
                  //                                     .indexOf(model.pitch) ??
                  //                                 0),
                  //                     itemExtent: 60.w,
                  //
                  //                     children: List.generate(
                  //                         model.pitchList.length, (index) {
                  //                       return RotatedBox(
                  //                         quarterTurns: 45,
                  //                         child: Container(
                  //                           //margin: EdgeInsets.all(7.0.sp),
                  //                           child: Center(
                  //                             child: TitleText(
                  //                               text: double.parse(model
                  //                                       .pitchList[index]
                  //                                       .toStringAsFixed(2))
                  //                                   .toString()
                  //                                   .padLeft(2, "0")
                  //                               /*.replaceAll(regex, "")*/,
                  //                               color: model.pitch ==
                  //                                       model.pitchList[index]
                  //                                   ? HexColor.fromHex(
                  //                                       "#FF6259")
                  //                                   : Theme.of(context)
                  //                                               .brightness ==
                  //                                           Brightness.dark
                  //                                       ? HexColor.fromHex(
                  //                                               "#FFFFFF")
                  //                                           .withOpacity(0.6)
                  //                                       : HexColor.fromHex(
                  //                                           "#5D6A68"),
                  //                               fontWeight: model.pitch ==
                  //                                       model.pitchList[index]
                  //                                   ? FontWeight.bold
                  //                                   : FontWeight.normal,
                  //                               fontSize: 18.sp,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     }),
                  //                     onSelectedItemChanged: (int value) {
                  //                       model.changePitch(
                  //                           model.pitchList[value]);
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //             )),
                  //             Container(
                  //               height: 25.h,
                  //               margin: EdgeInsets.only(bottom: 15.h),
                  //               child: Center(
                  //                 child: TitleText(
                  //                   text: 'Set Rate',
                  //                   align: TextAlign.center,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 16.sp,
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.white.withOpacity(0.87)
                  //                       : HexColor.fromHex("#384341"),
                  //                 ),
                  //               ),
                  //             ),
                  //             Center(
                  //                 child: Container(
                  //               margin: EdgeInsets.only(bottom: 25),
                  //               height: 35.h,
                  //               width: 259.w,
                  //               decoration: BoxDecoration(boxShadow: [
                  //                 BoxShadow(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.black.withOpacity(0.8)
                  //                       : HexColor.fromHex("#D1D9E6"),
                  //                   blurRadius: 3,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(0, 2.h),
                  //                 ),
                  //                 BoxShadow(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.black.withOpacity(0.8)
                  //                       : HexColor.fromHex("#D1D9E6"),
                  //                   blurRadius: 3,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(0, -2.h),
                  //                 ),
                  //               ]),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? HexColor.fromHex("#111B1A")
                  //                       : HexColor.fromHex("#F2F2F2"),
                  //                   gradient: LinearGradient(
                  //                       begin: Alignment.centerLeft,
                  //                       end: Alignment.centerRight,
                  //                       colors: [
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? HexColor.fromHex("#212D2B")
                  //                             : HexColor.fromHex("#FFFFFF"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                         Theme.of(context).brightness ==
                  //                                 Brightness.dark
                  //                             ? Colors.black
                  //                             : HexColor.fromHex("#E7EBF2"),
                  //                       ]),
                  //                 ),
                  //                 height: 35.h,
                  //                 width: 259.w,
                  //                 child: RotatedBox(
                  //                   quarterTurns: 135,
                  //                   child: CustomCupertinoPicker(
                  //                     // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                  //                     backgroundColor: Colors.transparent,
                  //                     scrollController:
                  //                         FixedExtentScrollController(
                  //                             initialItem: model.rateList
                  //                                     .indexOf(model.rate) ??
                  //                                 0),
                  //                     itemExtent: 60.w,
                  //
                  //                     children: List.generate(
                  //                         model.rateList.length, (index) {
                  //                       return RotatedBox(
                  //                         quarterTurns: 45,
                  //                         child: Container(
                  //                           //margin: EdgeInsets.all(7.0.sp),
                  //                           child: Center(
                  //                             child: TitleText(
                  //                               text: double.parse(model
                  //                                       .rateList[index]
                  //                                       .toStringAsFixed(2))
                  //                                   .toString()
                  //                                   .padLeft(2, "0")
                  //                               /*.replaceAll(regex, "")*/,
                  //                               color: model.rate ==
                  //                                       model.rateList[index]
                  //                                   ? HexColor.fromHex(
                  //                                       "#FF6259")
                  //                                   : Theme.of(context)
                  //                                               .brightness ==
                  //                                           Brightness.dark
                  //                                       ? HexColor.fromHex(
                  //                                               "#FFFFFF")
                  //                                           .withOpacity(0.6)
                  //                                       : HexColor.fromHex(
                  //                                           "#5D6A68"),
                  //                               fontWeight: model.rate ==
                  //                                       model.rateList[index]
                  //                                   ? FontWeight.bold
                  //                                   : FontWeight.normal,
                  //                               fontSize: 18.sp,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     }),
                  //                     onSelectedItemChanged: (int value) {
                  //                       model.changeRate(model.rateList[value]);
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //             )),
                  //             Container(
                  //               margin: EdgeInsets.only(
                  //                   top: 15.h,
                  //                   left: 18.w,
                  //                   right: 18.w,
                  //                   bottom: 25.h),
                  //               child: Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 1,
                  //                     child: Body1AutoText(
                  //                       text: 'Select Language',
                  //                       maxLine: 3,
                  //                       color: Theme.of(context).brightness ==
                  //                               Brightness.dark
                  //                           ? Colors.white.withOpacity(0.87)
                  //                           : HexColor.fromHex("#384341"),
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 1,
                  //                     child: InkWell(
                  //                         onTap: () {
                  //                           showModalBottomSheet(
                  //                             context: context,
                  //                             backgroundColor:
                  //                                 Theme.of(context).cardColor,
                  //                             useRootNavigator: true,
                  //                             builder: (context) {
                  //                               return languagePicker();
                  //                             },
                  //                           );
                  //                         },
                  //                         child: Text(
                  //                           model.selectedLanguage != null
                  //                               ? model.selectedLanguage
                  //                               : '',
                  //                           style: TextStyle(
                  //                             fontSize: 16,
                  //                           ),
                  //                         )),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Divider(),
                  //             Container(
                  //               margin: EdgeInsets.symmetric(vertical: 15.h),
                  //               child: Center(
                  //                 child: TitleText(
                  //                   text: 'Speech To Text',
                  //                   align: TextAlign.center,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 20.sp,
                  //                   color: Theme.of(context).brightness ==
                  //                           Brightness.dark
                  //                       ? Colors.white.withOpacity(0.87)
                  //                       : HexColor.fromHex("#384341"),
                  //                 ),
                  //               ),
                  //             ),
                  //             Container(
                  //               margin: EdgeInsets.only(
                  //                   top: 15.h,
                  //                   left: 20.w,
                  //                   right: 20.w,
                  //                   bottom: 25.h),
                  //               child: Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 1,
                  //                     child: Body1AutoText(
                  //                       text: 'Locale',
                  //                       maxLine: 3,
                  //                       color: Theme.of(context).brightness ==
                  //                               Brightness.dark
                  //                           ? Colors.white.withOpacity(0.87)
                  //                           : HexColor.fromHex("#384341"),
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 1,
                  //                     child: InkWell(
                  //                         onTap: () {
                  //                           showModalBottomSheet(
                  //                             context: context,
                  //                             backgroundColor:
                  //                                 Theme.of(context).cardColor,
                  //                             useRootNavigator: true,
                  //                             builder: (context) {
                  //                               return localePicker();
                  //                             },
                  //                           );
                  //                         },
                  //                         child: Text(
                  //                           model.currentLocale != null
                  //                               ? model.currentLocale.name
                  //                               : '',
                  //                           style: TextStyle(
                  //                             fontSize: 16,
                  //                           ),
                  //                         )),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ]),
                  //         ),
                  // ),
                  );
        },
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget bottomButton() {
    return Selector<SetTtsAndSttModel, bool>(
        selector: (context, model) => model.isEdit,
        builder: (context, isLoading, child) {
          return Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            padding: EdgeInsets.only(bottom: 25.h),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.h),
                            color: setTtsAndSttModel.isEdit
                                ? HexColor.fromHex("#FF6259").withOpacity(0.8)
                                : Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex("#D1D9E6")
                                        .withOpacity(0.1)
                                    : Colors.white,
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(-5, -5),
                              ),
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black.withOpacity(0.75)
                                    : HexColor.fromHex("#D1D9E6"),
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(5, 5),
                              ),
                            ]),
                        child: Container(
                          decoration: ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.h),
                              ),
                              depression: 11,
                              colors: [
                                Colors.white,
                                HexColor.fromHex("#D1D9E6"),
                              ]),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: TitleText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.cancel)
                                    .toUpperCase(),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex("#111B1A")
                                    : Colors.white,
                              ),
                              // child: FittedBox(
                              //   fit: BoxFit.scaleDown,
                              //   child: Text(
                              //     StringLocalization.of(context)
                              //         .getText(StringLocalization.cancel)
                              //         .toUpperCase(),
                              //     style: TextStyle(
                              //       fontSize: 16.sp,
                              //       fontWeight: FontWeight.bold,
                              //       color: Theme.of(context).brightness == Brightness.dark
                              //           ? HexColor.fromHex("#111B1A")
                              //           : Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      onTap: setTtsAndSttModel.isEdit
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : null),
                ),
                SizedBox(width: 17.w),
                Expanded(
                    child: GestureDetector(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.h),
                              color: setTtsAndSttModel.isEdit
                                  ? HexColor.fromHex("#00AFAA")
                                  : Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#D1D9E6")
                                          .withOpacity(0.1)
                                      : Colors.white,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(-5, -5),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black.withOpacity(0.75)
                                      : HexColor.fromHex("#D1D9E6"),
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(5, 5),
                                ),
                              ]),
                          child: Container(
                            decoration: ConcaveDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.h),
                                ),
                                depression: 11,
                                colors: [
                                  Colors.white,
                                  HexColor.fromHex("#D1D9E6"),
                                ]),
                            child: Center(
                              child: Padding(
                                key:Key('clickOnSaveButton'),
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                // child: FittedBox(
                                //   fit: BoxFit.scaleDown,
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     StringLocalization.of(context)
                                //         .getText(StringLocalization.save)
                                //         .toUpperCase(),
                                //     style: TextStyle(
                                //       fontSize: 16.sp,
                                //       fontWeight: FontWeight.bold,
                                //       color: Theme.of(context).brightness ==
                                //               Brightness.dark
                                //           ? HexColor.fromHex("#111B1A")
                                //           : Colors.white,
                                //     ),
                                //     // minFontSize: 8,
                                //     maxLines: 1,
                                //   ),
                                // ),
                                child: TitleText(
                                  text: StringLocalization.of(context)
                                      .getText(StringLocalization.save)
                                      .toUpperCase(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#111B1A")
                                      : Colors.white,
                                  // maxLine: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: setTtsAndSttModel.isEdit
                            ? () async {
                                setTtsAndSttModel.savePreferences();
                                CustomSnackBar.buildSnackbar(
                                    context,
                                    'Saved voice configuration successfully',
                                    3);
                                Navigator.of(context).pop();
                                // save all the changes in set preferences.
                              }
                            : null)),
              ],
            ),
          );
        });
  }
}