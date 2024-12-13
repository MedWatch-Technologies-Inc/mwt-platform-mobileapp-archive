import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/screens/tag/tag_select_category_screen.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_provider.dart';
import 'package:health_gauge/speech_to_text/model/nlp_bloc_model.dart';
import 'package:health_gauge/speech_to_text/model/nlp_speech_event_model.dart';
import 'package:health_gauge/speech_to_text/model/nlp_tag_option_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/tag_list_screen_model.dart';
import '../loading_screen.dart';
import 'tag_note_screen.dart';

class TagListScreen extends StatefulWidget {
  List<Tag>? tagList;

  TagListScreen({Key? key, this.tagList}) : super(key: key);

  @override
  TagListScreenState createState() => TagListScreenState();
}

class TagListScreenState extends State<TagListScreen> {
  //List<Tag> tagList = [];
  NlpTagOptionModel nlpTagOptionModel = NlpTagOptionModel();
  late String userId;
  late NlpEventBloc nlpBloc;
  bool isTagSelectionPossible = false;
  NlpSpeechEventModel? nlpData;

  bool isTagSet = false;
  // bool isLoading = true;

  int currentPage = 1;
  int pageSize = 20;

  late TagListScreenModel tagListScreenModel;

  @override
  void dispose() {
    isTagSelectionPossible = false;
    nlpData = null;
    super.dispose();
  }

  @override
  void initState() {

    print('tag_list_screen ${widget.tagList.toString()}');
    getPreferences();
    //getTagListFromApi(); todo remaining
    tagListScreenModel = TagListScreenModel();
    tagListScreenModel.tagList = widget.tagList ?? [];
    super.initState();
    nlpBloc = BlocProvider.of<NlpEventBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    //  nlpBloc.speakTTS(text: 'I Don\'t found the tag for tts. Please create a new one.');
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    //changed for Provider
    return ChangeNotifierProvider.value(
      value: tagListScreenModel,
      child: Consumer<TagListScreenModel>(
        builder: (context, model, child) {
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
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                    leading: widget.tagList != null
                        ? IconButton(
                            padding: EdgeInsets.only(left: 10),
                            onPressed: () {
                              connections.disconnectWeightDevice();
                              Navigator.of(context).pop();
                            },
                            icon:
                                Theme.of(context).brightness == Brightness.dark
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
                          )
                        : Container(),
                    title: TitleText(
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.tagScreenSlctn),
                        fontSize: 18.sp,
                        color: HexColor.fromHex('62CBC9'),
                        fontWeight: FontWeight.bold),
                    centerTitle: true,
                  ),
                )),
            body: Container(
                padding: EdgeInsets.only(top: 22.h),
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                child: dataLayout()),
            floatingActionButton: widget.tagList != null
                ? Container()
                : FloatingActionButton(
                    elevation: 0,
                    child: Container(
                      height: 57,
                      width: 57,
                      decoration: BoxDecoration(
                          color: HexColor.fromHex('#00AFAA'),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.2)
                                  : Colors.transparent,
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : HexColor.fromHex('#BD78CE')
                                      .withOpacity(0.8),
                              blurRadius: 5,
                              spreadRadius: 0,
                              offset: Offset(4, 4),
                            ),
                          ]),
                      child: Container(
                          key: Key('addTagButton'),
                  decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(57),
                      ),
                      depression: 15,
                      colors: [Colors.white, HexColor.fromHex('#D1D9E6')
                              ]),
                          padding: EdgeInsets.all(18),
                          child: Image.asset(
                            'asset/plus_icon.png',
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : Colors.white,
                          )),
                    ),
                    onPressed: () {
                      // Constants.navigatePush(
                      //         TagSelectCategoryScreen(
                      //           tagList: tagListScreenModel.tagList,
                      //         ),
                      //         context)
                      //     .then((value) {
                      //   getTagList();
                      //   if (value != null && value) {
                      //     CustomSnackBar.buildSnackbar(
                      //         context, 'Tag Added Successfully', 3);
                      //   }
                      // });
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget dataLayout() {
    if (tagListScreenModel.isLoading) {

      getTagList();
      if (widget.tagList == null) return LoadingScreen();
    }
    return Stack(
      children: [
        tagListScreenModel.tagList.isEmpty
            ? Center(
              // child: FittedBox(
              //   fit: BoxFit.scaleDown,
              //   alignment: Alignment.centerLeft,
              //   child: Text('No tags found'),
              // ),
              child: TitleText(
                text: 'No tags found',
              ),
            )
            : GridView.builder(
                key: Key('long_list'),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: tagListScreenModel.tagList.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                itemBuilder: (context, index) {
                  Tag tag = tagListScreenModel.tagList[index];
                  if (tag == null ||
                      (tag.tagType != null &&
                          tag.tagType == TagType.sleep.value)) {
                    return Container();
                  }                  //crossAxisSpacing: 27.w,

                  return Container(
                    margin: EdgeInsets.only(bottom: 5.h),
                    height: 119.h,
                    child: Column(children: [
                      InkWell(
                        key: Key('icon_$index'),
                        onTap: () {
                          LoggingService().info(
                               'Open Tagnote Screen',  'Tag');
                          // key:
                          // Key('tagNoteScreen');
                          // Constants.navigatePush(TagNoteScreen(tag: tag), context);
                          moveToTagnoteScreen(context, tag, index);
                        },
                        child: Container(
                          height: 85.w,
                          width: 85.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6')
                                          .withOpacity(0.1)
                                      : Colors.white.withOpacity(0.7),
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
                          child: Padding(
                            key: imageWidget(tag) == Image.memory(base64Decode(tag.icon!))
                                ? Key('imageIcon1')
                                : Key('imageIcon2'),
                            padding: EdgeInsets.all(12.h),
                            child: imageWidget(tag),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.0.h),
                      Expanded(
                        child: SizedBox(
                          height: 23.w,
                          width: 85.w,
                          child: Body1Text(
                            text: StringLocalization.of(context)
                                .getTextFromEnglish(tag.label ?? ''),
                            maxLine: 1,
                            align: TextAlign.center,
                            fontSize: 14.sp,
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                : HexColor.fromHex('#5D6A68'),
                            fontWeight: FontWeight.w700,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ]),
                  );
                },
              ),
        ChangeNotifierProvider<NlpTagOptionModel>.value(
          value: nlpTagOptionModel,
          child: Consumer<NlpTagOptionModel>(
            builder: (context, model, child) {
              return Visibility(
                visible: model.showList,
                child: ClipRect(
                  child: BackdropFilter(
                    filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                model.changeVisibility(false);
                              },
                              iconSize: 24,
                            ),
                          ),
                          TitleText(
                              text: 'Did you mean?',
                              fontSize: 24.h,
                              fontWeight: FontWeight.w600),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: model.optionList.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        moveToTagnoteScreen(context,
                                            model.optionList[index].tag!, index);
                                        model.changeVisibility(false);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // child: FittedBox(
                                        //   fit: BoxFit.scaleDown,
                                        //   alignment: Alignment.centerLeft,
                                        //   child: Text(
                                        //     model
                                        //         .optionList[index].optionString,
                                        //     style: TextStyle(
                                        //         fontSize: 18.h,
                                        //         fontWeight: FontWeight.w600),
                                        //   ),
                                        // ),
                                        child: TitleText(
                                            text: model
                                                .optionList[index].optionString ?? '',
                                            fontSize: 18.h,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  })),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget? imageWidget(Tag tag) {
    try {
      if (tag.icon != null && tag.icon!.isNotEmpty) {
        if (tag.icon!.contains('asset')) {
          return Image.asset(
            'asset/strees_icon.png',
            //color: Colors.red,
            //Theme.of(context).brightness == Brightness.dark ?  HexColor.fromHex('#00AFAA') : HexColor.fromHex('#62CBC9'),
            height: 40.0.h,
          );
        } else {
          try {
            return Image.memory(
              base64Decode(tag.icon!),
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#00AFAA')
                  : null,
              height: 40.0.h,
            );
          } catch (e) {
            print(e);
            return Image.asset(
              'asset/placeholder.png',
              height: 40.0.h,
            );
          }
        }
      }

      return Image.asset(
        'asset/placeholder.png',
        height: 40.0.h,
      );

    } catch (e) {
      // print(e);
      return Image.asset(
        'asset/placeholder.png',
        height: 40.0.h,
      );
    }
  }

  String getDateInFormat(String date, String outputFormat) {
    try {
      DateTime brazilianDate = new DateFormat('MM/dd/yyyy').parse(date);
      return DateFormat(outputFormat).format(brazilianDate);
    } catch (e) {
      return '';
    }
    // 'dd-MM-yyyy'
  }

  void moveToTagnoteScreen(BuildContext context, Tag tag, int index,
      {MODE mode = MODE.MANUAL}) async {
    try {
      var keyword;
      if (isTagSelectionPossible) {
        if (nlpData!.type!.trim().toLowerCase() == 'other') {
          keyword = nlpData!.otherType!.trim().toLowerCase();
        } else {
          keyword = nlpData!.type!.trim().toLowerCase();
        }
        isTagSelectionPossible = false;
        nlpData = null;
      }
      bool value = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => TagNoteScreen(
                  tag: tag,
                  tagCount: widget.tagList != null ? widget.tagList!.length : 0,
                  index: index,
                  mode: mode,
                  keyword: keyword,
                  tagList: tagListScreenModel.tagList,
                )),
      ).then((value) {
        if(value is String && value == 'delete'){
          tagListScreenModel.removeTag(tag, mounted);
          CustomSnackBar.buildSnackbar(
              context, 'Tag Deleted Successfully',
              3);
          return false;
        } else {
          getTagList();
          return value;
        }
      });
      if (value != null && value) {
        print(value);

        tagListScreenModel.removeTag(tag, mounted);
        if(tagListScreenModel.tagList.isEmpty){
          Navigator.of(context).pop();
        }
        // tagList.remove(tag);
        // if (mounted) setState(() {});
      }


    } catch (e) {
      print(e);
    }
  }

  String getUnitSelectedType(String quantity) {
    if (quantity.toLowerCase() == 'celcius') return '1';
    if (quantity.toLowerCase() == 'fahrenheit') return '2';
    if (quantity.toLowerCase() == 'mmol') {
      return '1';
    }
    if (quantity.toLowerCase() == 'mm/dL') return '2';
    return '1';
  }

  double getValue(double min, double max, dynamic nlpEventData) {
    if (nlpEventData.unitQuantity == 'fahrenheit') {
      var minFar = (min * (9 / 5)) + 32;
      var maxFar = (max * (9 / 5)) + 32;
      var mFar = (double.parse(
                  nlpEventData.amount != '' ? nlpEventData.amount : '30') *
              (9 / 5)) +
          32;
      return mFar < minFar
          ? minFar
          : min > maxFar
              ? max
              : double.parse(
                  nlpEventData.amount != '' ? nlpEventData.amount : '30');
    }
    return double.parse(nlpEventData.amount != '' ? nlpEventData.amount : '1') <
            min
        ? min
        : double.parse(nlpEventData.amount != '' ? nlpEventData.amount : '1') >
                max
            ? max
            : double.parse(
                nlpEventData.amount != '' ? nlpEventData.amount : '1');
  }

  void moveToTagNoteScreenASR(
      BuildContext context, Tag tag, int index, dynamic nlpEventData,
      {MODE mode = MODE.MANUAL}) async {
    try {
      // mmddyyyy
      // 2021-01-22
      PassTagParams tagParams = PassTagParams(
        date: getDateInFormat(nlpEventData.date, DateUtil.yyyyMMdd),
        // pass the value according to tag page.
        value: getValue(tag.min ?? 0, tag.max ?? 10, nlpEventData),
        // pass the selected index of the checkbox according to the options.
        // unitSelectedType: '1'
        unitSelectedType: getUnitSelectedType(nlpEventData.unitQuantity),
      );
      bool value = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => TagNoteScreen(
                  tag: tag,
                  tagCount: widget.tagList != null ? widget.tagList!.length : 0,
                  tagParams: tagParams,
                  index: index,
                  mode: mode,
                )),
      ).then((value) => getTagList());
      if (value != null && value) {
        print(value);

        tagListScreenModel.removeTag(tag, mounted);

        // tagListScreenModel.tagList.remove(tag);
        // if (mounted) setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  getTagList() async {
    try {
      if (userId == null || userId.isEmpty) {
        await getPreferences();
      }
      if (widget.tagList != null) {
        widget.tagList=tagListScreenModel.tagList;
        // tagListScreenModel.tagList = widget.tagList;
      } else {
        tagListScreenModel.tagList = await dbHelper.getTagList(userId);
        print('tagListScreenModel :: ${tagListScreenModel.tagList}');
        if (tagListScreenModel.tagList == null ||
            tagListScreenModel.tagList.isEmpty) {}
      }
    } catch (e) {
      print(e);
    }

    List<Tag> distinctList = [];
    tagListScreenModel.tagList.forEach((element) {
      try {
        if (!distinctList.any((e) =>
            e.tagType == element.tagType &&
            stringLocalization.getTextFromEnglish(e.label ?? '') ==
                stringLocalization.getTextFromEnglish(element.label ?? ''))) {
          distinctList.add(element);
        }
      } catch (e) {
        print(e);
      }
    });
    tagListScreenModel.tagList = distinctList;
    try {
      List indexList = tagListScreenModel.tagList.where((tag) {
        return (tag == null ||
            (tag.tagType != null &&
                (tag.tagType == TagType.sleep.value ||
                    tag.tagType == TagType.CORONA.value)));
      }).toList();

      for (int i = 0; i < indexList.length; i++) {
        tagListScreenModel.tagList.remove(indexList[i]);

      }
    } catch (e) {
      print(e);
    }

    tagListScreenModel.changeLoading(false);

    tagListScreenModel.tagList.forEach((element) {
      print("Tag_add ${element.label}");
    });

    // isLoading = false;
    // setState(() {});
  }

  Future getPreferences() async {
    if(preferences != null) userId = preferences!.getString(Constants.prefUserIdKeyInt) ?? '';
  }

  void popTillThis() {
    try {
      if (context != null) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      print(e);
    }
    tagListScreenModel.changeLoading(true);
  }


  Tag? getAvailableTag(String type) {
    try {
      var matchedTag;

      for (var tag in tagListScreenModel.tagList) {
        if (type.trim().toLowerCase().contains(tag.label!.toLowerCase())) {
          return tag;
        } else if (tag.keyword != null) {
          List out = tag.keyword!.split(',');
          bool find = out.any((element) => element
              .toString()
              .trim()
              .toLowerCase()
              .contains(type.trim().toLowerCase()));
          if (find) {
            return tag;
          }
        }
      }
      return matchedTag;
    } catch (e) {

    }
  }

  Future<void> setAsrParam(
      BuildContext localContext, NlpBlocModel nlpBlocModel) async {
    var nlpEventData = nlpBlocModel.operationModel as NlpSpeechEventModel;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!tagListScreenModel.isLoading) {
        timer.cancel();
        var matchedTag = getAvailableTag(
            nlpEventData.type!.trim().toLowerCase() == 'other'
                ? nlpEventData.otherType!
                : nlpEventData.type!);
        if (matchedTag != null) {
          var index = tagListScreenModel.tagList.indexOf(matchedTag);
          try {
            matchedTag.defaultValue = double.tryParse(nlpEventData.amount!)!;
          } catch (e) {
            matchedTag.defaultValue =
                int.tryParse(nlpEventData.amount!)!.toDouble();
          }
          print('*****************');
          print(nlpEventData.type);
          print('*********************');
          moveToTagNoteScreenASR(localContext, matchedTag, index, nlpEventData,
              mode: MODE.ASR);
        } else {
          print('*****************');
          print(nlpEventData.type);
          print(nlpEventData.otherType);
          print('*********************');
          nlpBloc.speakTTS(
              text:
                  'You said a phrase and it doesn\'t match.Did you mean any of these?');
          isTagSelectionPossible = true;
          nlpData = nlpBlocModel.operationModel;
          // nlpTagOptionModel.changeVisibility(true);
          // nlpTagOptionModel.fillTagList(tagListScreenModel.tagList);
          // SpeechTextUtil _speechTextUtil = SpeechTextUtil.initTTS();
          // _speechTextUtil.newVoiceText = 'I Don\'t found the tag for ${nlpEventData.type}. Please create a new one.';
          // _speechTextUtil.setLanguageForTts('en-IN');
          // await _speechTextUtil.speak();
        }
      }
    });
  }
}
