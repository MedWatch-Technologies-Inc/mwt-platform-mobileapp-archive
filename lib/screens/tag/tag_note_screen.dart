import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' as slider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/binding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/covid_19_tag_type_model.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/models/tag_note_screen_model.dart';
import 'package:health_gauge/repository/tag/request/edit_tag_record_detail_request.dart';
import 'package:health_gauge/repository/tag/request/store_tag_record_detail_request.dart';
import 'package:health_gauge/repository/tag/tag_repository.dart';
import 'package:health_gauge/screens/history/tag_history_screen.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_event.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_provider.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_state.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_shared_preference_manager_model.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/time_picker.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'add_tag_dialog.dart';

enum MODE { ASR, MANUAL }

class TagNoteScreen extends StatefulWidget {
  Tag? tag;
  final TagNote? tagNote;
  final PassTagParams? tagParams;
  int? tagCount;
  final int? index;
  final MODE? mode;
  final String? keyword;
  final List<Tag>? tagList;

  TagNoteScreen(
      {this.tag,
      this.tagNote,
      this.tagCount,
      this.index,
      this.tagParams,
      this.keyword,
      this.mode,
      this.tagList});

  @override
  _TagNoteScreenState createState() => _TagNoteScreenState();
}

class _TagNoteScreenState extends State<TagNoteScreen> {
  //bool isShowLoadingScreen = true;

  List<Tag> tagList = [];
  List<Covid19TagTypeModel> unitItemListForCovid = [];

  //List list = [];
  List<TagNote> tagNoteList = [];

  // String userId;
  DatabaseHelper helper = DatabaseHelper.instance;
  FixedExtentScrollController scrollCntrl = FixedExtentScrollController();

//  double value = 0;
//  bool isLoading = true;
//
//  DateTime selectedDate = DateTime.now();
//  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController noteTextEdit = TextEditingController();
  TextEditingController patchlocationController = TextEditingController();

  TextEditingController maxValueController = TextEditingController();

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  //String unitSelectedType = '1';
  List unitSelectedTypeList = [];

  // double selectedValue;
  bool writingNotes = false;

  bool isUnitSelected = false;
  FocusNode focusNode = FocusNode();
  String selectedImage = '';

  //Tag tag = new Tag();
  // List<Uint8List> tagImagesList = [];
  bool isEditTagImages = false;

  //bool isGraphExist = false;
  late NlpEventBloc _ttsProviderBloc;
  Uint8List? base64DecodedImage;
  Timer? ttsTimer;

  late TagNoteScreenModel tagNoteScreenModel;
  bool isPressed = false;

  bool isAnyUpdate = false;

  @override
  void initState() {
    tagNoteScreenModel = TagNoteScreenModel();
    setDataInit();
    tagNoteScreenModel.tag = widget.tag != null ? widget.tag! : null;
    tagNoteScreenModel.selectedValue = tagNoteScreenModel.value;
    if (tagNoteScreenModel.tag != null) {
      if (tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value) {
        tagNoteScreenModel.unitSelectedType = (bloodGlucoseUnit + 1).toString();
      } else if (tagNoteScreenModel.tag!.tagType == TagType.temperature.value) {
        tagNoteScreenModel.unitSelectedType = (tempUnit + 1).toString();
      }
    }
    print("tag_name${widget.tag!.label}");
//    tag = widget.tag != null ? widget.tag : null;
    //  selectedValue = value;
//    if (widget.tag.tagType == TagType.exercise.value) {
//      exerciseImage();
//    }
    _ttsProviderBloc = BlocProvider.of<NlpEventBloc>(context);
    getTagImageList();
    focusNode = FocusNode();
    focusNode.addListener(() {
      print('Listener');
    });

    if (widget.mode != null && widget.mode == MODE.ASR) {
      // _ttsProviderBloc.sendSaveCommand(NlpOperation.TAG);
      _ttsProviderBloc.askTtsConfirmtion(text: 'Do you want to save it please say yes or no');
    }
    super.initState();
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild()));
  }

  @override
  void dispose() {
    focusNode.dispose();
    if (widget.mode != null && widget.mode == MODE.ASR) {}
    maxValueController.dispose();
    noteTextEdit.dispose();
    patchlocationController.dispose();
    super.dispose();
  }

  void startListing() {
    _ttsProviderBloc.add(UserConfirmationNewEvent());
  }

  makeCovidItems() {
    unitItemListForCovid.add(Covid19TagTypeModel(
        id: '1',
        itemName: 'Shortness of breath to trouble breathing (new or worsening)',
        isSelected: unitSelectedTypeList.contains('1')));
    unitItemListForCovid.add(Covid19TagTypeModel(
        id: '2',
        itemName: 'Cough (new or worsening)',
        isSelected: unitSelectedTypeList.contains('2')));
    unitItemListForCovid.add(Covid19TagTypeModel(
        id: '3', itemName: 'Fever', isSelected: unitSelectedTypeList.contains('3')));
    unitItemListForCovid.add(Covid19TagTypeModel(
        id: '4',
        itemName: 'Chest pain (new or worsening)',
        isSelected: unitSelectedTypeList.contains('4')));
    unitItemListForCovid.add(Covid19TagTypeModel(
        id: '5',
        itemName: 'Nausea and/or vomiting',
        isSelected: unitSelectedTypeList.contains('5')));
    unitItemListForCovid.add(Covid19TagTypeModel(
        id: '6',
        itemName: 'Diarrhea (more than 3 loose stools per day)',
        isSelected: unitSelectedTypeList.contains('6')));
  }

  Future setDataInit() async {
    await getPreference();
    if (tagNoteScreenModel.tag != null && tagNoteScreenModel.tag!.defaultValue != null) {
      tagNoteScreenModel.value =
          double.parse(tagNoteScreenModel.tag!.defaultValue!.toStringAsFixed(2));
      //selectedValue = value;
    }
    // ###########################
    if (tagNoteScreenModel.tag != null) {
//      if (widget.tagParams != null &&
//          widget.tagParams.unitSelectedType != null) {
//        tagNoteScreenModel.unitSelectedType =
//            '${widget.tagParams.unitSelectedType}';
//      }
      await setValueInPicker();
    }

//    if (tagNoteScreenModel.tag != null &&
//        (tagNoteScreenModel.tag.tagType == TagType.bloodGlucose.value ||
//            tagNoteScreenModel.tag.tagType == TagType.temperature.value ||
//            tagNoteScreenModel.tag.tagType == TagType.running.value)) {
//      if (widget.tagNote != null && widget.tagNote.unitSelectedType != null) {
//        tagNoteScreenModel.unitSelectedType =
//            '${widget.tagNote.unitSelectedType}';
//      }
//      await setValueInPicker();
//    }
    if (tagNoteScreenModel.tag!.tagType == TagType.CORONA.value) {
      if (widget.tagNote != null && widget.tagNote!.unitSelectedType != null) {
        unitSelectedTypeList = widget.tagNote!.unitSelectedType!.split(',');
      }
    }
    // #################################
    if (widget.tagParams != null) {
      if (widget.tagParams!.value != null) {
        tagNoteScreenModel.value = widget.tagParams!.value!;
        tagNoteScreenModel.selectedValue = tagNoteScreenModel.value;
      }
      if (widget.tagParams!.time != null) {
        widget.tagParams!.time = widget.tagParams!.time!.replaceAll('TimeOfDay(', '');
        widget.tagParams!.time = widget.tagParams!.time!.replaceAll(')', '');
        tagNoteScreenModel.selectedTime = TimeOfDay(
            hour: int.parse(widget.tagParams!.time!.split(':')[0]),
            minute: int.parse(widget.tagParams!.time!.split(':')[1]));
      }
      if (widget.tagParams!.date != null) {
        selectedDate = DateTime.parse(widget.tagParams!.date!);
        // selectedDate = DateTime.now();
      }
      if (widget.tagParams!.note != null) {
        noteTextEdit.text = widget.tagParams!.note!;
      }
    }
    // #####################################
    if (widget.tagNote != null) {
      if (widget.tagNote!.value != null) {
        tagNoteScreenModel.value = widget.tagNote!.value!;
        tagNoteScreenModel.selectedValue = tagNoteScreenModel.value;
      }

      if (widget.tagNote!.time != null) {
        widget.tagNote!.time = widget.tagNote!.time!.replaceAll('TimeOfDay(', '');
        widget.tagNote!.time = widget.tagNote!.time!.replaceAll(')', '');
        tagNoteScreenModel.selectedTime = TimeOfDay(
            hour: int.parse(widget.tagNote!.time!.split(':')[0]),
            minute: int.parse(widget.tagNote!.time!.split(':')[1]));
      }

      if (widget.tagNote!.date != null) {
        selectedDate = DateTime.parse(widget.tagNote!.date!);
      }

      if (widget.tagNote!.note != null) {
        noteTextEdit.text = widget.tagNote!.note!;
      }
      if (widget.tagNote!.patchLocation != null) {
        patchlocationController.text = widget.tagNote!.patchLocation!;
      }
    }

    // tagNoteList = await getValueForTagNotes();
    // if (list != null) {
    //   if (tag != null &&
    //       tag.tagType != null &&
    //       tag.tagType == TagType.smoke.value) {
    //     value = tagNoteList.length.toDouble();
    //   }
    // }

    tagNoteScreenModel.updateIsLoadingScreen(false);
//    makeCovidItems();
//    setState(() {});
  }

  Future getValueForTagNotes() async {
    if (tagNoteScreenModel.tag != null &&
        tagNoteScreenModel.tag!.tagType != null &&
        tagNoteScreenModel.tag!.tagType == TagType.smoke.value &&
        tagNoteScreenModel.userId != null) {
      var nextDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
      var first = DateFormat(DateUtil.yyyyMMdd).format(selectedDate);
      var last = DateFormat(DateUtil.yyyyMMdd).format(nextDay);
      var tagNoteList = await dbHelper.getTagNoteList(first, last, tagNoteScreenModel.userId!);
      return tagNoteList;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: tagNoteScreenModel,
      child: Consumer<TagNoteScreenModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                leading: IconButton(
                  key: Key('backButtonTagSelection'),
                  padding: EdgeInsets.only(left: 10.w),
                  onPressed: () {
                    Navigator.of(context).pop(isAnyUpdate);
                  },
                  icon: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                          'asset/dark_leftArrow.png',
                          width: 13.w,
                          height: 22.h,
                        )
                      : Image.asset(
                          'asset/leftArrow.png',
                          width: 13.w,
                          height: 22.h,
                        ),
                ),
                title: tagLabel(),
                centerTitle: true,
                actions: [
                  (Platform.isIOS &&
                          tagNoteScreenModel.tag != null &&
                          (tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value ||
                              tagNoteScreenModel.tag!.tagType == TagType.temperature.value))
                      ? IconButton(
                          onPressed: () async {
                            double healthKitValue = 0.0;
                            DateTime endDate = DateTime.now();
                            DateTime startDate =
                                new DateTime(endDate.year, endDate.month - 1, endDate.day);
                            final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmmss);

                            if (model.tag!.tagType == TagType.bloodGlucose.value) {
                              List hkBloodGlucoseList =
                                  await connections.readBloodGlucoseDataFromHealthKitOrGoogleFit(
                                      formatter.format(startDate), formatter.format(endDate));
                              if (hkBloodGlucoseList.isNotEmpty) {
                                if (model.unitSelectedType == '2') {
                                  healthKitValue = (double.parse(hkBloodGlucoseList.last['value']))
                                      .truncateToDouble();
                                  selectedDate = DateTime.parse(
                                      convertUtcToLocal(hkBloodGlucoseList.last['startTime']));
                                  tagNoteScreenModel.selectedDates(selectedDate);
                                  TimeOfDay temp = TimeOfDay(
                                      hour: selectedDate.hour, minute: selectedDate.minute);
                                  tagNoteScreenModel.selectedTimes(temp);
                                } else {
                                  healthKitValue = double.parse(
                                      ((double.parse(hkBloodGlucoseList.last['value'])) / 18)
                                          .toStringAsFixed(1));
                                  selectedDate = DateTime.parse(
                                      convertUtcToLocal(hkBloodGlucoseList.last['startTime']));
                                  tagNoteScreenModel.selectedDates(selectedDate);
                                  TimeOfDay temp = TimeOfDay(
                                      hour: selectedDate.hour, minute: selectedDate.minute);
                                  tagNoteScreenModel.selectedTimes(temp);
                                }
                              }
                              model.changeListPicker(healthKitValue);
                            } else if (model.tag!.tagType == TagType.temperature.value) {
                              List hkBodyTempList =
                                  await connections.readBodyTemperatureDataFromHealthKitOrGoogleFit(
                                      formatter.format(startDate), formatter.format(endDate));
                              if (hkBodyTempList.isNotEmpty) {
                                if (model.unitSelectedType == '1') {
                                  healthKitValue = (double.parse(hkBodyTempList.last['value']));
                                  selectedDate = DateTime.parse(
                                      convertUtcToLocal(hkBodyTempList.last['startTime']));
                                  tagNoteScreenModel.selectedDates(selectedDate);
                                  TimeOfDay temp = TimeOfDay(
                                      hour: selectedDate.hour, minute: selectedDate.minute);
                                  tagNoteScreenModel.selectedTimes(temp);
                                } else {
                                  healthKitValue =
                                      (((double.parse(hkBodyTempList.last['value'])) * (9 / 5)) +
                                          32);
                                  selectedDate = DateTime.parse(
                                      convertUtcToLocal(hkBodyTempList.last['startTime']));
                                  tagNoteScreenModel.selectedDates(selectedDate);
                                  TimeOfDay temp = TimeOfDay(
                                      hour: selectedDate.hour, minute: selectedDate.minute);
                                  tagNoteScreenModel.selectedTimes(temp);
                                }
                              }
                              model.changeListPicker(
                                  double.parse(healthKitValue.toStringAsFixed(1)));
                            }

                            if (model.tag!.tagType == TagType.bloodGlucose.value) {
                              if (scrollCntrl.hasClients) {
                                scrollCntrl.animateTo(
                                    55.w *
                                        tagNoteScreenModel.listPicker
                                            .indexOf(tagNoteScreenModel.selectedValue),
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease);
                              }
                            } else if (model.tag!.tagType == TagType.temperature.value) {
                              if (tagNoteScreenModel.unitSelectedType == '2') {
                                if (scrollCntrl.hasClients) {
                                  scrollCntrl.animateTo(
                                      65.w *
                                          tagNoteScreenModel.listPicker
                                              .indexOf(tagNoteScreenModel.selectedValue),
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.ease);
                                }
                              } else {
                                if (scrollCntrl.hasClients) {
                                  scrollCntrl.animateTo(
                                      55.w *
                                          tagNoteScreenModel.listPicker
                                              .indexOf(tagNoteScreenModel.selectedValue),
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.ease);
                                }
                              }
                            }
                            model.value = double.parse(healthKitValue.toStringAsFixed(1));
                          },
                          icon: Image.asset(
                            'asset/health_kit_icon.png',
                            height: 33.h,
                            width: 33.h,
                          ),
                        )
                      : Container(),
                  model.isGraphExist
                      ? IconButton(
                          onPressed: () {
                            int index = -1;
                            index = isExistInGraph();
                            // if (index > -1) {
                            //   homeScreenStateKey.currentState!
                            //       .navigateToGraphScreen(graphIndex: index);
                            // }
                          },
                          icon: Image.asset(
                            'asset/graph_icon_unselected.png',
                            height: 33.h,
                            width: 33.h,
                          ),
                        )
                      : Container(),
                  IconButton(
                    key: Key('clickonHistoryIcon'),
                    onPressed: () {
                      Constants.navigatePush(TagHistoryScreen(), context)
                          .then((value) => screen = Constants.settings);
                    },
                    icon: Image.asset(
                      'asset/reload.png',
                      height: 33,
                      width: 33,
                    ),
                  ),
                  IconButton(
                    key: Key('clickEdit'),
                    icon: Image.asset(
                      'asset/edit_pencil.png',
                      height: 22,
                      width: 22,
                    ),
                    onPressed: () async {
                      // await Constants.navigatePush(
                      //     AddTagDialog(
                      //       tag: model.tag!,
                      //       category: model.tag!.tagType ?? 1,
                      //       title: model.tag!.label ?? 'TAG',
                      //     ),
                      //     context)
                      //     .then(
                      //       (value) {
                      //     if (value != null) {
                      //       if (value is String && value == 'delete') {
                      //         Navigator.of(context).pop(0);
                      //       } else {
                      //         CustomSnackBar.buildSnackbar(
                      //             context, 'Updated Tag Successfully', 3);
                      //         isAnyUpdate = true;
                      //         updateTag(value);
                      //         model.updateIsLoading(true);
                      //       }
                      //     }
                      //   },
                      // );
                    },
                  ),
                  widget.tag != null && widget.tag!.tagType != null && widget.tag!.tagType! <= 3
                      ? widget.tagNote != null
                          ? Container()
                          : IconButton(
                              key: Key('clickEdit'),
                              icon: Image.asset(
                                'asset/edit_pencil.png',
                                height: 22,
                                width: 22,
                              ),
                              onPressed: () async {
                                // await Constants.navigatePush(
                                //         AddTagDialog(
                                //           tag: model.tag!,
                                //           category: model.tag!.tagType ?? 1,
                                //           title: model.tag!.label ?? 'TAG',
                                //         ),
                                //         context)
                                //     .then(
                                //   (value) {
                                //     if (value != null) {
                                //       if (value is String && value == 'delete') {
                                //         Navigator.of(context).pop(0);
                                //       } else {
                                //         CustomSnackBar.buildSnackbar(
                                //             context, 'Updated Tag Successfully', 3);
                                //         isAnyUpdate = true;
                                //         updateTag(value);
                                //         model.updateIsLoading(true);
                                //       }
                                //     }
                                //   },
                                // );
                              },
                            )
                      : Container(),
                ],
                //actions: <Widget>[allowanceBtn()],
              ),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                child: dataLayout()),
          );
        },
      ),
    );
  }

  void afterBuild() {
    double slideValue = 55.w;
    double defaultValue = widget.tag!.defaultValue!;
    if (widget.tagNote == null && widget.tag != null && widget.tag!.defaultValue != null) {
      slideValue = (widget.tag!.tagType == TagType.bloodGlucose.value ||
              widget.tag!.tagType == TagType.temperature.value)
          ? widget.tag!.tagType == TagType.temperature.value &&
                  tagNoteScreenModel.unitSelectedType == '2'
              ? 65.w
              : 55.w
          : 40.w;
      if (widget.tag!.tagType == TagType.temperature.value &&
          tagNoteScreenModel.unitSelectedType == '2') {
        defaultValue =
            double.parse(((widget.tag!.defaultValue! * (9 / 5)) + 32).toStringAsFixed(1));
      } else if (widget.tag!.tagType == TagType.bloodGlucose.value &&
          tagNoteScreenModel.unitSelectedType == '2') {
        defaultValue = ((widget.tag!.defaultValue! * 18).truncateToDouble());
      }
      tagNoteScreenModel.changeListPicker(defaultValue);
      if (scrollCntrl.hasClients) {
        scrollCntrl.animateTo(slideValue * tagNoteScreenModel.listPicker.indexOf(defaultValue),
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    } else {
      slideValue = (widget.tag!.tagType == TagType.bloodGlucose.value ||
              widget.tag!.tagType == TagType.temperature.value)
          ? (widget.tag!.tagType == TagType.temperature.value &&
                  tagNoteScreenModel.unitSelectedType == '2')
              ? 65.w
              : 55.w
          : 40.w;
      defaultValue = widget.tagNote!.value!;
      if (widget.tag!.tagType == TagType.temperature.value) {
        if (tempUnit == 0) {
          if (widget.tagNote!.unitSelectedType == '2') {
            defaultValue = double.parse(((widget.tagNote!.value! - 32) * 5 / 9).toStringAsFixed(1));
          }
        } else {
          if (widget.tagNote!.unitSelectedType == '1') {
            defaultValue =
                double.parse(((widget.tagNote!.value! * (9 / 5)) + 32).toStringAsFixed(1));
          }
        }
      } else if (widget.tag!.tagType == TagType.bloodGlucose.value) {
        if (bloodGlucoseUnit == 0) {
          if (widget.tagNote!.unitSelectedType == '2') {
            defaultValue = double.parse((widget.tagNote!.value! / 18).toStringAsFixed(1));
          }
        } else {
          if (widget.tagNote!.unitSelectedType == '1') {
            defaultValue = (widget.tagNote!.value! * 18).roundToDouble();
          }
        }
      }
      tagNoteScreenModel.changeListPicker(defaultValue);
      if (scrollCntrl.hasClients) {
        scrollCntrl.animateTo(slideValue * tagNoteScreenModel.listPicker.indexOf(defaultValue),
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    }
  }

  String convertUtcToLocal(String date) {
    DateTime utcDate = DateTime.parse(date);
    DateTime localDate = utcDate.toLocal();
    return localDate.toString();
  }

  int isExistInGraph() {
    int index = -1;
    try {
      List<String>? graphPreString;
      if (preferences != null)
        graphPreString = preferences!.getStringList(Constants.prefKeyForGraphPages) ?? [];
      if (graphPreString != null && graphPreString.isNotEmpty) {
        List<GraphSharedPreferenceManagerModel> graphList = graphPreString
            .map((e) => GraphSharedPreferenceManagerModel.fromMap(jsonDecode(e)))
            .toList();
        if (graphList.isNotEmpty) {
          index = graphList.indexWhere((GraphSharedPreferenceManagerModel element) {
            int index = -1;
            try {
              index = element.windowList.indexWhere((WindowModel? windowModel) {
                int i = -1;
                i = windowModel?.selectedType.indexWhere((GraphTypeModel graphTypeModel) {
                      return graphTypeModel.fieldName.toLowerCase().trim().contains(
                          tagNoteScreenModel.tag!.label != null
                              ? tagNoteScreenModel.tag!.label!.toLowerCase().trim()
                              : ' ');
                    }) ??
                    -1;

                return i > -1;
              });
            } on Exception catch (e) {
              print(e);
            }

            return index > -1;
          });
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    return index;
  }

  getTagList() async {
    if (tagNoteScreenModel.userId == null || tagNoteScreenModel.userId!.isEmpty) {
      await getPreferences();
    } else {
      tagNoteScreenModel.tagList = await dbHelper.getTagList(tagNoteScreenModel.userId!);
      tagNoteScreenModel.isLoading = false;
    }
    //setState(() {});
  }

  Future getPreferences() async {
    if (preferences != null) {
      tagNoteScreenModel.userId = preferences!.getString(Constants.prefUserIdKeyInt)!;
    }
    tagNoteScreenModel.isLoading = true;
    getTagList();
//    setState(() {});
  }

  void updateTag(Tag updatedTag) {
    tagNoteScreenModel.tag = updatedTag;
    tagNoteScreenModel.isLoading = false;
    tagNoteScreenModel.selectedValue = tagNoteScreenModel.tag!.defaultValue!;
    setDataInit();
//    setState(() {});
  }

  Widget tagLabel() {
    if (tagNoteScreenModel.tag == null || tagNoteScreenModel.tag!.label == null) {
      return Text('');
    }
    return Text(
      StringLocalization.of(context).getTextFromEnglish(tagNoteScreenModel.tag!.label ?? ''),
      style: slider.TextStyle(
        fontSize: 18.sp,
        color: HexColor.fromHex('#62CBC9'),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  allowanceBtn() {
    if (tagNoteScreenModel.tag != null &&
        tagNoteScreenModel.tag!.tagType != null &&
        tagByValue(tagNoteScreenModel.tag!.tagType!) == TagType.smoke) {
      return FlatBtn(
        onPressed: () {
          resetMaximumValue(tagNoteScreenModel.tag!);
        },
        text: stringLocalization.getText(StringLocalization.allowance).toUpperCase(),
        color: Colors.white,
      );
    }
    return Container();
  }

  void voiceInsert() async {
    await insert();
    if (patchlocationController.text.toString().isNotEmpty &&
        tagNoteScreenModel.tag!.tagType == TagType.GlucosePatch.value) {
    } else {
      Navigator.of(context).pop(isAnyUpdate);
    }
  }

  Widget dataLayout() {
    if (tagNoteScreenModel.isShowLoadingScreen) {
      return LoadingScreen();
    }
    print(
        'value ${tagNoteScreenModel.value} index ${tagNoteScreenModel.listPicker.indexOf(tagNoteScreenModel.value)}');
    return SingleChildScrollView(
      child: Consumer<TagNoteScreenModel>(builder: (context, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 32.h),
              height: 105.h,
              width: 105.h,
              child: imageWidget(),
            ),
            if ((tagNoteScreenModel.tag?.shortDescription ?? '').isNotEmpty) ...[
              Divider(
                thickness: 0.5,
                color: Colors.black12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Body1Text(
                    text:
                        '${StringLocalization.of(context).getText(StringLocalization.noteDescription)}: ',
                    maxLine: 1,
                    align: TextAlign.center,
                    fontSize: 14.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                        : HexColor.fromHex('#5D6A68'),
                    fontWeight: FontWeight.w700,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 25.0, top: 5.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Body1Text(
                    text: tagNoteScreenModel.tag?.shortDescription ?? '',
                    maxLine: 10,
                    align: TextAlign.left,
                    fontSize: 12.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                        : HexColor.fromHex('#5D6A68'),
                    fontWeight: FontWeight.w700,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black12,
              ),
            ],
            contentLayout(),
            button(),
          ],
        );
      }),
    );
  }

  Widget contentLayout() {
    if (tagNoteScreenModel.tag != null && tagNoteScreenModel.tag!.tagType == TagType.CORONA.value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(unitItemListForCovid.length, (index) {
                return Column(
                  children: [
                    SizedBox(
                      height: index == 0 ? 27.h : 17.h,
                    ),
                    Container(
                      height: index == 0 || index == unitItemListForCovid.length - 1 ? 76.h : 49.h,
                      margin: EdgeInsets.symmetric(horizontal: 33.w),
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                  : Colors.white,
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: Offset(-5, -5),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.75)
                                  : HexColor.fromHex('#D1D9E6'),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: Offset(5, 5),
                            ),
                          ]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Body1AutoText(
                              text: unitItemListForCovid[index].itemName,
                              maxLine:
                                  index == 0 || index == unitItemListForCovid.length - 1 ? 2 : 1,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.8)
                                  : HexColor.fromHex('#384341'),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            )),
                            customRadio(
                                index: index,
                                list: unitItemListForCovid,
                                color: unitItemListForCovid[index].isSelected != null &&
                                        unitItemListForCovid[index].isSelected
                                    ? HexColor.fromHex('FF6259')
                                    : Colors.transparent,
                                unitText: ''),
                          ],
                        ),
                      ),
//                  ),
                    ),
                  ],
                );
              }),
            ),
            dateWidget(),
            timeWidget(),
          ],
        ),
      );
    }
    return Column(
      children: [
        sliderWidget(),
        dateWidget(),
        timeWidget(),
        note(),
        imagesWidget(),
      ],
    );
  }

  Widget imageWidget() {
    print('tagIcon :: ${tagNoteScreenModel.tag?.icon ?? ''}');
    print('tagIcon :: ${base64Decode(tagNoteScreenModel.tag?.icon ?? '')}');
    try {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 105.h,
              width: 105.h,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'asset/imageBackground_dark.png'
                    : 'asset/imageBackground_light.png',
              )),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if ((tagNoteScreenModel.tag?.icon ?? '').isEmpty) ...[
                Padding(
                  padding: EdgeInsets.all(15.0.h),
                  child: Image.asset(
                    'asset/placeholder.png',
                  ),
                ),
              ] else if ((tagNoteScreenModel.tag?.icon ?? '').contains('asset')) ...[
                Image.asset(
                  tagNoteScreenModel.tag?.icon ?? '',
                  errorBuilder: (context, object, stackTrace) {
                    return Padding(
                      padding: EdgeInsets.all(15.0.h),
                      child: Image.asset(
                        'asset/placeholder.png',
                      ),
                    );
                  },
                ),
              ] else ...[
                Image.memory(
                  base64Decode(tagNoteScreenModel.tag?.icon ?? ''),
                  errorBuilder: (context, object, stackTrace) {
                    return Padding(
                      padding: EdgeInsets.all(15.0.h),
                      child: Image.asset(
                        'asset/placeholder.png',
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ],
      );
    } on Exception catch (e) {
      print(e);
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 105.h,
              width: 105.h,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'asset/imageBackground_dark.png'
                    : 'asset/imageBackground_light.png',
              )),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15.0.h),
                child: Image.asset(
                  'asset/placeholder.png',
                ),
              )
            ],
          )
        ],
      );
    }
  }

//  exerciseImage() {
//    if (int.parse(unitSelectedType) == 1) {
//      imageConversion('asset/walking.png');
//    } else if (int.parse(unitSelectedType) == 2) {
//      imageConversion('asset/hiking.png');
//    } else if (int.parse(unitSelectedType) == 3) {
//      imageConversion('asset/running_icon.png');
//    } else if (int.parse(unitSelectedType) == 4) {
//      imageConversion('asset/biking.png');
//    }
//  }

  Uint8List imageConversion(String image) {
    return image as Uint8List;
  }

  bool patchlocation = false;

  Widget sliderWidget() {
    try {
      if (tagNoteScreenModel.tag != null &&
          tagNoteScreenModel.tag!.tagType != null &&
          (tagNoteScreenModel.tag!.tagType == TagType.running.value ||
              tagNoteScreenModel.tag!.tagType == TagType.exercise.value)) {
        if (tagNoteScreenModel.tag!.precision != null && tagNoteScreenModel.tag!.precision != 0) {
          tagNoteScreenModel.precision =
              tagNoteScreenModel.max ~/ tagNoteScreenModel.tag!.precision!.toInt();
        } else {
          tagNoteScreenModel.precision = 1;
        }
        return Container(
          margin: EdgeInsets.only(top: 29.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                stringLocalization.getText(StringLocalization.intensity),
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 21.h, left: 33.w, right: 33.w),
                        height: 16.h,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 11,
                            crossAxisSpacing: 28.w,
                            childAspectRatio: 0.1,
                          ),
                          itemCount: 11,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 5.w, top: 4.h, right: 5.w),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 8.h,
                              width: 1.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.38)
                                    : HexColor.fromHex('#A7B2AF'),
                                borderRadius: BorderRadius.circular(2.h),
                              ),
                            );
                          },
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbColor: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#99D9D9')
                                    : HexColor.fromHex('#62CBC9'),
                                activeTrackColor: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#62CBC9')
                                    : HexColor.fromHex('#99D9D9'),
                                inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : HexColor.fromHex('#D9E0E0'),
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.w),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 24.w),
                                overlayColor: HexColor.fromHex('#99D9D9').withOpacity(0.5),
                                inactiveTickMarkColor: Colors.transparent,
                                activeTickMarkColor: Colors.transparent,
                                valueIndicatorColor: HexColor.fromHex('#FF6259'),
                                valueIndicatorTextStyle: TextStyle(
                                    color: HexColor.fromHex('#FFDFDE'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.h,
                              ),
                              child: Consumer<TagNoteScreenModel>(
                                builder: (context, model, child) {
                                  return Slider(
                                    value: model.value,
                                    min: model.min,
                                    max: model.max,
                                    divisions: model.precision,
                                    label: model.value.round().toString(),
                                    onChanged: (double selectedValue) {
                                      model.onChange(selectedValue);
//                                  model.value = selectedValue;
//                                  setState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 33.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(
                          text: stringLocalization.getText(StringLocalization.easy).toUpperCase(),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68'),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                        TitleText(
                          text:
                              stringLocalization.getText(StringLocalization.moderate).toUpperCase(),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68'),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                        TitleText(
                          text: stringLocalization.getText(StringLocalization.max).toUpperCase(),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68'),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      setValueInPicker();

      Widget slider = Center(
        child: Container(
          margin: EdgeInsets.only(top: 18.h),
          height: 35.h,
          width: 259.w,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.8)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 2.h),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.8)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, -2.h),
            ),
          ]),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : HexColor.fromHex('#F2F2F2'),
              gradient:
                  LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : HexColor.fromHex('#E7EBF2'),
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : HexColor.fromHex('#E7EBF2'),
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#212D2B')
                    : HexColor.fromHex('#FFFFFF'),
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : HexColor.fromHex('#E7EBF2'),
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : HexColor.fromHex('#E7EBF2'),
              ]),
            ),
            height: 35.h,
            width: 259.w,
            child: RotatedBox(
              quarterTurns: 135,
              child: CustomCupertinoPicker(
                scrollController: scrollCntrl,
                // squeeze: (tag != null && tag.tagType != null &&(tag.tagType == TagType.bloodGlucose.value || tag.tagType == TagType.temperature.value )) ? 1.3 :1.8,
                children: List.generate(tagNoteScreenModel.listPicker.length, (index) {
                  return RotatedBox(
                    quarterTurns: 45,
                    child: Center(
                      child: TitleText(
                        text: (widget.tag != null &&
                                ((widget.tag!.tagType == TagType.bloodGlucose.value &&
                                        tagNoteScreenModel.unitSelectedType == '1') ||
                                    widget.tag!.tagType == TagType.temperature.value))
                            ? double.parse(tagNoteScreenModel.listPicker[index].toStringAsFixed(2))
                                .toString()
                                .padLeft(2, '0')
                            : tagNoteScreenModel.listPicker[index]
                                .toStringAsFixed(1) /*.replaceAll(regex, '')*/,
                        color:
                            tagNoteScreenModel.selectedValue == tagNoteScreenModel.listPicker[index]
                                ? HexColor.fromHex('#FF6259')
                                : Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                    : HexColor.fromHex('#5D6A68'),
                        fontWeight:
                            tagNoteScreenModel.selectedValue == tagNoteScreenModel.listPicker[index]
                                ? FontWeight.bold
                                : FontWeight.normal,
                        fontSize: 18.sp,
                      ),
                    ),
                  );
                }),
                backgroundColor: Colors.transparent,
//              FixedExtentScrollController(
//                  initialItem: tagNoteScreenModel.listPicker
//                          .indexOf(tagNoteScreenModel.selectedValue.toInt()) ??
//                      0)..animateToItem(tagNoteScreenModel.listPicker
//                  .indexOf(tagNoteScreenModel.selectedValue.toInt()), duration: Duration(milliseconds: 500), curve: Curves.easeIn),
                itemExtent: (tagNoteScreenModel.tag != null &&
                        tagNoteScreenModel.tag!.tagType != null &&
                        (tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value ||
                            tagNoteScreenModel.tag!.tagType == TagType.temperature.value))
                    ? tagNoteScreenModel.tag!.tagType == TagType.temperature.value &&
                            tagNoteScreenModel.unitSelectedType == '2'
                        ? 65.w
                        : 55.w
                    : widget.tag!.max.toString().length > 2
                        ? 50.w
                        : 40.w,
                onSelectedItemChanged: (int value) {
                  tagNoteScreenModel.changeListPicker(tagNoteScreenModel.listPicker[value]);
                  tagNoteScreenModel.value = tagNoteScreenModel.listPicker[value];
//                    selectedValue = list[value];
//                    this.value = list[value].toDouble();
                  // setState(() {});

                  //  setValueInPicker();
                },
              ),
            ),
          ),
        ),
      );
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 29.h),
          unitWidget(),
          tagNoteScreenModel.tag!.label == 'Glucose Patch'
              ? GestureDetector(
                  onTap: () {
                    patchlocation = true;
                    setState(() {});
                  },
                  child: Container(
                      height: 49,
                      margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 20.w),
                      decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                          depression: 10,
                          colors: [
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.5)
                                : HexColor.fromHex('#D1D9E6'),
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                : Colors.white,
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IgnorePointer(
                            ignoring: patchlocation ? false : true,
                            child: TextFormField(
                              autofocus: patchlocation,
                              controller: patchlocationController,
                              minLines: 1,
                              maxLines: 10,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 16.w, right: 16.w),
                                hintText: StringLocalization.of(context)
                                    .getText(StringLocalization.glucosepatchlocation),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white.withOpacity(0.38)
                                        : HexColor.fromHex('#7F8D8C')),
                              ),
                              textInputAction: TextInputAction.newline,
                            ),
                          ),
                        ],
                      )),
                )
              : slider,
        ],
      );
    } on Exception catch (e) {
      print(e);
      return Container();
    }
  }

  Widget unitWidget() {
    if (tagNoteScreenModel.tag == null || tagNoteScreenModel.tag!.unit == null) {
      return Container();
    }

    if (tagNoteScreenModel.tag!.tagType != null &&
        tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value &&
        tagNoteScreenModel.unitSelectedType != '0') {
      return Container(
          margin: EdgeInsets.only(left: 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: tagNoteScreenModel.bloodGlucoseList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                      height: 28.h,
                      child: customRadio(
                          index: index,
                          color: index + 1 == int.parse(tagNoteScreenModel.unitSelectedType)
                              ? HexColor.fromHex('FF6259')
                              : Colors.transparent,
                          unitText: tagNoteScreenModel.bloodGlucoseList[index].text));
                })
          ]));
//        SizedBox(
//        width: 100.w,
//        child: DropdownButton(
//          items: [
//            DropdownMenuItem(
//              child: TitleText(
//                  text: stringLocalization.getText(StringLocalization.MMOL),
//                  align: TextAlign.center,
//              ),
//              value: '1',
//            ),
//            DropdownMenuItem(
//              child: TitleText(
//                text: stringLocalization.getText(StringLocalization.MMGL),
//                align: TextAlign.center,
//              ),
//              value: '2',
//            ),
//          ],
//          onChanged: (selected) {
//            if(unitSelectedType == '1' && selected == 2){
//              this.value = this.value * 18;
//            }else if(unitSelectedType == '2' && selected == 1){
//              this.value = this.value / 18;
//            }
//            unitSelectedType = selected;
//            if (this.mounted) {
//              setState(() {});
//            }
//          },
//          value: unitSelectedType??'1',
//          isExpanded: false,
//          hint: TitleText(
//            text: stringLocalization.getText(StringLocalization.unit),
//            align: TextAlign.center,
//          ),
//        ),
//      );
    }
    if (tagNoteScreenModel.tag!.tagType != null &&
        tagNoteScreenModel.tag!.tagType == TagType.temperature.value &&
        tagNoteScreenModel.unitSelectedType != '0') {
      return Container(
          margin: EdgeInsets.only(left: 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: tagNoteScreenModel.temperatureList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 40,
                    child: customRadio(
                        index: index,
                        color: index + 1 == int.parse(tagNoteScreenModel.unitSelectedType)
                            ? HexColor.fromHex('FF6259')
                            : Colors.transparent,
                        unitText: tagNoteScreenModel.temperatureList[index].text),
                  );
                })
          ]));
    }

    return Container(
      height: 25.h,
      child: Center(
        child: TitleText(
          text: tagNoteScreenModel.tag!.tagType == TagType.GlucosePatch.value
              ? '${StringLocalization.of(context).getText(StringLocalization.glucosepatchlocation)}'
              : tagNoteScreenModel.tag!.tagType == TagType.medicine.value
                  ? '${StringLocalization.of(context).getText(StringLocalization.numberOfPills)}'
                  : tagNoteScreenModel.tag!.tagType == TagType.Alcohol.value
                      ? '${StringLocalization.of(context).getText(StringLocalization.glassOf)}'
                      : tagNoteScreenModel.tag!.tagType == TagType.smoke.value
                          ? '${StringLocalization.of(context).getText(StringLocalization.numberOfSmoke)}'
                          : '${StringLocalization.of(context).getText(StringLocalization.tagLevel)}${tagNoteScreenModel.tag!.label}',
          align: TextAlign.center,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
      ),
    );
  }

  Widget customRadio(
      {int? index, List<Covid19TagTypeModel>? list, Color? color, String? unitText}) {
    return Consumer<TagNoteScreenModel>(builder: (context, model, child) {
      return GestureDetector(
        onTap: () async {
          model.checkListNull(index!);
          await setValueInPicker();
          if (widget.tag!.tagType == TagType.temperature.value &&
              tagNoteScreenModel.unitSelectedType == '2') {
            if (scrollCntrl.hasClients) {
              scrollCntrl.animateTo(
                  65.w * tagNoteScreenModel.listPicker.indexOf(tagNoteScreenModel.selectedValue),
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease);
            }
          } else {
            if (scrollCntrl.hasClients) {
              scrollCntrl.animateTo(
                  55.w * tagNoteScreenModel.listPicker.indexOf(tagNoteScreenModel.selectedValue),
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease);
            }
          }

//        if (list != null) {
//          list[index].isSelected = !list[index].isSelected;
//        } else {
//          tagNoteScreenModel.updateSelectedUnit();
////          if (tag.tagType == TagType.exercise.value) {
////            exerciseImage();
////          }
//        }
//        // setState(() {});
        },
        child: Row(
          children: [
            Container(
              height: 28.h,
              width: 28.h,
              decoration: ConcaveDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
                  depression: 4,
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex('#D1D9E6'),
                    Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                  ]),
              child: Container(
                margin: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(3, 3),
                      ),
                    ]),
                child: Container(
                    margin: EdgeInsets.all(3.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    )),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            unitText != ''
                ? SizedBox(
                    width: 100.w,
                    child: Body1AutoText(
                      text: unitText!,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      minFontSize: 6,
                      maxLine: 1,
                    ),
                  )
                : Container()
          ],
        ),
      );
    });
  }

  Widget dateWidget() {
    String date = DateFormat(DateUtil.ddMMyyyy).format(tagNoteScreenModel.selectedDate);
    return Consumer<TagNoteScreenModel>(
      builder: (context, model, child) {
        return Container(
          height: 49,
          margin: EdgeInsets.only(top: 29.h, left: 33.w, right: 33.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.h)),
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white.withOpacity(0.9),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(-5.w, -5.h),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(5.w, 5.h),
                ),
              ]),
          child: Row(children: [
            SizedBox(
              width: 25.w,
            ),
            Image.asset(
              'asset/calendar.png',
              height: 20.h,
              width: 20.w,
            ),
            SizedBox(
              width: 36.w,
            ),
            SizedBox(
              // height: 25,
              width: 100,
              child: Body1AutoText(
                text: date,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                fontSize: 16,
                minFontSize: 9,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Container(
                    // width: 100,
                    height: 20,
                    child: GestureDetector(
                      // height: 20,

                      onTap: () async {
                        DateTime date =
                            await Date().selectDate(context, tagNoteScreenModel.selectedDate);
                        model.selectedDates(date);
//                      selectedDate = date;
                        if (model.tag!.tagType == TagType.smoke.value) {
                          tagNoteScreenModel.isShowLoadingScreen = true;
                          getValueForTagNotes().then((value) {
                            // tagNoteList = value;
                            // isShowLoadingScreen = false;
                            // this.value = tagNoteList.length.toDouble();
                            // setState(() {});
                          });
                        }
                      },
                      child: Body1AutoText(
                        text: StringLocalization.of(context)
                            .getText(StringLocalization.change)
                            .toUpperCase(),
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.6)
                            : HexColor.fromHex('#5D6A68'),
                        fontWeight: FontWeight.w500,
                        minFontSize: 9,
                        maxLine: 1,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        );
      },
    );
  }

  Widget timeWidget() {
    String date =
        '${tagNoteScreenModel.selectedTime.hour.toString().padLeft(2, '0')} : ${tagNoteScreenModel.selectedTime.minute.toString().padLeft(2, '0')}';
    return Container(
      height: 49,
      margin: EdgeInsets.only(top: 17.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.h)),
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : Colors.white.withOpacity(0.9),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(-5.w, -5.h),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(5.w, 5.h),
            ),
          ]),
      child: Row(children: [
        SizedBox(
          width: 25.w,
        ),
        Image.asset(
          'asset/time_icon.png',
          height: 20.h,
          width: 20.h,
        ),
        SizedBox(
          width: 36.w,
        ),
        SizedBox(
          // height: 25,
          width: 100,
          child: Body1AutoText(
            text: date,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
            minFontSize: 9,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: Consumer<TagNoteScreenModel>(builder: (context, model, child) {
                return Container(
                  // width: 59,
                  height: 20,
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay time = await Time().selectTime(context, timeofday);
                      model.selectedTimes(time);
                    },
                    child: Body1AutoText(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.change)
                          .toUpperCase(),
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      fontWeight: FontWeight.w500,
                      minFontSize: 6,
                      maxLine: 1,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ]),
    );
  }

  Widget note() {
    return Container(
      // height: 121.h,
      margin: EdgeInsets.only(top: 24.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.h)),
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(-5.w, -5.h),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.75)
                : HexColor.fromHex('#D1D9E6'),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(5.w, 5.h),
          ),
        ],
      ),
      child: Consumer<TagNoteScreenModel>(
        builder: (context, model, child) {
          return GestureDetector(
            key: Key('taponNotesField'),
            onTap: () {
              model.isWriting();
            },
            child: Container(
              decoration: model.writingNotes
                  ? ConcaveDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                      depression: 10,
                      colors: [
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.5)
                            : HexColor.fromHex('#D1D9E6'),
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                            : Colors.white,
                      ],
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                    ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 80.h,
                    child: IgnorePointer(
                      ignoring: model.writingNotes ? false : true,
                      child: TextFormField(
                        autofocus: model.writingNotes,
                        focusNode: focusNode,
                        controller: noteTextEdit,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 16.w, right: 16.w),
                          hintText:
                              StringLocalization.of(context).getText(StringLocalization.notes),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.38)
                                : HexColor.fromHex('#7F8D8C'),
                          ),
                        ),
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(right: 20.w),
                          height: 33.h,
                          width: 33.h,
                          child: Image.asset(
                            'asset/gallery_icon.png',
                          ),
                        ),
                        onTap: photoLibrary,
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(right: 8.w),
                          height: 33.h,
                          width: 33.h,
                          child: Image.asset('asset/camera_icon.png'),
                        ),
                        onTap: takePhoto,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imagesWidget() {
    if (tagNoteScreenModel.tagImagesList.isNotEmpty ||
        tagNoteScreenModel.tagImagesListString.isNotEmpty) {
      return Column(
        children: [
          tagNoteScreenModel.tagImagesListString.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 23.w, right: 23.w),
                  child: Center(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: tagNoteScreenModel.tagImagesListString.length == 1
                            ? 1
                            : tagNoteScreenModel.tagImagesListString.length == 2
                                ? 2
                                : 3,
                        childAspectRatio:
                            tagNoteScreenModel.tagImagesListString.length == 1 ? 1.8 : 1,
                      ),
                      itemCount: tagNoteScreenModel.tagImagesListString.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10.w, right: 10.w, top: 17.h, bottom: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                        : Colors.white.withOpacity(0.9),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(-5, -5),
                                  ),
                                  BoxShadow(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black.withOpacity(0.75)
                                        : HexColor.fromHex('#D1D9E6'),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Consumer<TagNoteScreenModel>(
                                builder: (context, model, child) {
                                  return InkWell(
                                    onLongPress: () {
                                      HapticFeedback.vibrate();
                                      model.imageEditing();
                                    },
                                    onTap: () {
                                      if (model.isImageEditing) {
                                        model.imageNotEditing();
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return fullImage(model.tagImagesListString[index]);
                                          },
                                        );
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.w),
                                      child: Image.network(
                                        model.tagImagesListString[index],
                                        height: 241.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            tagNoteScreenModel.isImageEditing
                                ? Stack(
                                    alignment: Alignment.topRight,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Consumer<TagNoteScreenModel>(
                                        builder: (context, model, child) {
                                          return InkWell(
                                            onTap: () {
                                              model.removeImageString(index);
                                              CustomSnackBar.buildSnackbar(
                                                  context, 'Image Removed', 3);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 11.h),
                                              height: 21.h,
                                              width: 21.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: HexColor.fromHex('#FF6259'),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColor.backgroundColor,
                                                  size: 15.h,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Container(),
          tagNoteScreenModel.tagImagesList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 23.w, right: 23.w),
                  child: Center(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: tagNoteScreenModel.tagImagesList.length == 1
                            ? 1
                            : tagNoteScreenModel.tagImagesList.length == 2
                                ? 2
                                : 3,
                        childAspectRatio: tagNoteScreenModel.tagImagesList.length == 1 ? 1.8 : 1,
                      ),
                      itemCount: tagNoteScreenModel.tagImagesList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10.w, right: 10.w, top: 17.h, bottom: 8.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                          : Colors.white.withOpacity(0.9),
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                      offset: Offset(-5, -5),
                                    ),
                                    BoxShadow(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.black.withOpacity(0.75)
                                          : HexColor.fromHex('#D1D9E6'),
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                      offset: Offset(5, 5),
                                    ),
                                  ]),
                              child: Consumer<TagNoteScreenModel>(builder: (context, model, child) {
                                return InkWell(
                                  onLongPress: () {
                                    HapticFeedback.vibrate();
                                    model.imageEditing();
                                  },
                                  onTap: () {
                                    if (model.isImageEditing) {
                                      model.imageNotEditing();
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return fullImage(model.tagImagesList[index]);
                                        },
                                      );
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.w),
                                    child: Image.memory(
                                      model.tagImagesList[index],
                                      height: 241.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            tagNoteScreenModel.isImageEditing
                                ? Stack(
                                    alignment: Alignment.topRight,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Consumer<TagNoteScreenModel>(
                                        builder: (context, model, child) {
                                          return InkWell(
                                            onTap: () {
                                              model.removeImage(index);
                                              CustomSnackBar.buildSnackbar(
                                                  context, 'Image Removed', 3);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 11.h),
                                              height: 21.h,
                                              width: 21.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: HexColor.fromHex('#FF6259'),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColor.backgroundColor,
                                                  size: 15.h,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Container()
        ],
      );
    }
    return Container();
  }

  OverlayEntry showOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator()),
          color: Colors.black26,
        ),
      ),
    );
    overlayState!.insert(overlayEntry);
    return overlayEntry;
  }

  Widget button() {
    return Container(
      margin: EdgeInsets.only(top: 23.h, bottom: 25.h, left: 33.w, right: 33.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: HexColor.fromHex('#00AFAA').withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(30.h)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(-5.w, -5.h),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.75)
                : HexColor.fromHex('#D1D9E6'),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(5.w, 5.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('clickonAddtagButton'),
          borderRadius: slider.BorderRadius.circular(30.h),
          splashColor: HexColor.fromHex('#00AFAA').withOpacity(0.8),
          onTap: doesSmokeReachLimit()
              ? null
              : () async {
                  OverlayEntry entry;
                  entry = showOverlay(context);
                  tagNoteScreenModel.writingNotes = false;
                  try {
                    tagNoteScreenModel.value =
                        double.parse(tagNoteScreenModel.value.toStringAsFixed(2));
                  } catch (e) {
                    print(e);
                  }
                  if (widget.tagNote != null) {
                    await update();
                    entry.remove();
                    CustomSnackBar.buildSnackbar(context, 'Tag updated Successfully', 3);
                  } else {
                    await insert();
                    entry.remove();
                    CustomSnackBar.buildSnackbar(context, 'Note added Successfully', 3);
                  }
                  if (widget.tagCount != null && widget.tagCount! > 1)
                    Navigator.pop(context, true);
                  else {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
          child: Container(
            decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.h)),
              depression: 10,
              colors: [
                Colors.white.withOpacity(0.8),
                HexColor.fromHex('#D1D9E6').withOpacity(0.8),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Center(
                child: AutoSizeText(
                  widget.tagNote != null
                      ? StringLocalization.of(context).getText(StringLocalization.updateNote)
                      : StringLocalization.of(context)
                          .getText(StringLocalization.addNote)
                          .toUpperCase(),
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : Colors.white),
                  maxLines: 1,
                  minFontSize: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  cameraDialog() {
    var dialog = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#000000').withOpacity(0.75)
                        : HexColor.fromHex('#384341').withOpacity(0.9),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ]),
            height: 134.h,
            width: 309.w,
            child: ListView(
              children: ListTile.divideTiles(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.15)
                    : HexColor.fromHex('#D9E0E0'),
                context: context,
                tiles: [
                  photoLibrary(),
                  takePhoto(),
                ],
              ).toList(),
              physics: NeverScrollableScrollPhysics(),
            )));
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  photoLibrary() async {
    tagNoteScreenModel.imageFile = (await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      // imageQuality: 100
    ))!;
    if (tagNoteScreenModel.imageFile != null) {
      tagNoteScreenModel.updateIsEdit(true);
//      isEdit = true;
      await _cropImage(File(tagNoteScreenModel.imageFile!.path));
      // base64DecodedImage = imageFile.readAsBytesSync();
    }
//    setState(() {});
  }

  Future<Null> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      // imageFile = croppedFile;
      // tagNoteScreenModel.base64DecodedImage = imageFile.readAsBytesSync();
      // tagImagesList.add(tagNoteScreenModel.base64DecodedImage);
      // tagNoteScreenModel.base64Image =
      //     base64Encode(tagNoteScreenModel.base64DecodedImage);
//      base64DecodedImage = imageFile.readAsBytesSync();
//      tagImagesList.add(base64DecodedImage);
//      String base64Image = base64Encode(base64DecodedImage);
      // setState(() {});
      File? imageFile = File(croppedFile.path);
      tagNoteScreenModel.updateImage(imageFile);
    }
  }

  takePhoto() async {
    tagNoteScreenModel.imageFile = (await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 100))!;
    if (tagNoteScreenModel.imageFile != null) {
      tagNoteScreenModel.updateIsEdit(true);
//      isEdit = true;
      await _cropImage(File(tagNoteScreenModel.imageFile!.path));
    }
//    setState(() {});
  }

  Widget fullImage(image) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.w),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          width: 309.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: image.toString().startsWith("https:")
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                  )
                : Image.memory(
                    image,
                    fit: BoxFit.cover,
                  ),
          ),
        ));
  }

  void showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  insert() async {
//    Constants.progressDialog(true, context);
    await getPreference();

    if (widget.keyword != null &&
        widget.tag != null &&
        widget.tag!.id != null &&
        widget.tag!.userId != null) {
      if (tagNoteScreenModel.tag!.keyword != null) {
        var x = tagNoteScreenModel.tag!.keyword!.split(',');
        var insertString = '';
        for (var val in x) {
          insertString = insertString + '$val,';
        }
        var out = insertString + '${widget.keyword}';

        dbHelper.updateTag(widget.tag!.id!, int.parse(widget.tag!.userId!), '$out');
      } else {
        dbHelper.updateTag(widget.tag!.id!, int.parse(widget.tag!.userId!), '${widget.keyword}');
      }
    }
    TagNote note = TagNote();
    note.date = tagNoteScreenModel.selectedDate.toString();
    note.time = tagNoteScreenModel.selectedTime.toString();
    note.value = tagNoteScreenModel.value;
    if (tagNoteScreenModel.tag != null &&
        tagNoteScreenModel.tag!.tagType != null &&
        tagByValue(tagNoteScreenModel.tag!.tagType!) == TagType.smoke) {
      note.value = tagNoteScreenModel.value;
    }
    note.label = tagNoteScreenModel.tag!.label;
    note.note = noteTextEdit.text;
    note.userId = tagNoteScreenModel.userId;
    note.tagId = tagNoteScreenModel.tag!.id;
    note.isRemove = 0;
    note.isSync = 0;
    if (patchlocationController.text.toString().isEmpty &&
        tagNoteScreenModel.tag!.tagType == TagType.GlucosePatch.value) {
      showToast('Enter Glucose Patch Location');
    } else {
      note.patchLocation = patchlocationController.text.toString();
    }
    //  note.imageFiles = tagNoteScreenModel.imageFiles;
    note.unitSelectedType = tagNoteScreenModel.unitSelectedType;

    note.note = getValue(note);
    note.unitSelectedType = getUnitSelectedValue();

    bool isInternet = await Constants.isInternetAvailable();
    if (tagNoteScreenModel.userId != null &&
        !tagNoteScreenModel.userId!.contains('Skip') &&
        isInternet) {
      String time =
          '${tagNoteScreenModel.selectedTime.hour.toString().padLeft(2, '0')}:${tagNoteScreenModel.selectedTime.minute.toString().padLeft(2, '0')}:00';
      String date = DateFormat(DateUtil.yyyyMMdd).format(selectedDate);
      // var map = {
      //   // 'id': 1,
      //   'date': '$date',
      //   'note': getValue(note),
      //   'time': '$time',
      //   'type': note.label,
      //   'userId': tagNoteScreenModel.userId,
      //   'value': note.value,
      //   'UnitSelectedType': getUnitSelectedValue(),
      //   'AttachFile': tagNoteScreenModel.tagImagesList
      //   // tagNoteScreenModel
      //   //     .convertImageToListAPI(tagNoteScreenModel.tagImagesList)
      //   // 'ImageList': tagNoteScreenModel.imageFiles.toString()
      // };
      var dateTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      var result = await TagRepository().storeTagRecordDetails(StoreTagRecordDetailRequest(
        date: '$date',
        note: getValue(note),
        time: '$time',
        type: note.label,
        userId: tagNoteScreenModel.userId,
        value: note.value,
        unitSelectedType: getUnitSelectedValue(),
        attachFile:
            //tagNoteScreenModel.tagImagesList,
            tagNoteScreenModel.convertImageToListAPI(
                tagNoteScreenModel.tagImagesList, tagNoteScreenModel.tagImagesListString),
        createdDateTimeStamp: dateTimeStamp,
        location: note.patchLocation,
      ));
      if (result.hasData) {
        if (result.getData!.result!) {
          note.isSync = 1;
          note.apiId = result.getData!.iD.toString();
        }
      } else {}
      note.createdDateTimeStamp = dateTimeStamp;
    }
    var map = note.toMap();
    // map['unitSelectedType'] = note.unitSelectedType;
    map['AttachFiles'] =
        //tagNoteScreenModel.tagImagesList;
        tagNoteScreenModel.convertImageToList(
            tagNoteScreenModel.tagImagesList, tagNoteScreenModel.tagImagesListString);
    map['TagIdForApi'] = widget.tag!.apiId;
    helper.insertTagNote(map);
  }

  getValue(TagNote note) {
    if (tagNoteScreenModel.tag!.tagType == TagType.CORONA.value) {
      return unitItemListForCovid
          .where((element) => element.isSelected)
          .toList()
          .map((e) => e.itemName)
          .toList()
          .join(', ');
    }

    return note.note;
  }

  getUnitSelectedValue() {
    if (tagNoteScreenModel.tag!.tagType == TagType.CORONA.value) {
      return unitItemListForCovid
          .where((element) => element.isSelected)
          .toList()
          .map((e) => e.id)
          .toList()
          .join(',');
    }
    if (tagNoteScreenModel.tag != null &&
        (tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value ||
            tagNoteScreenModel.tag!.tagType == TagType.temperature.value ||
            tagNoteScreenModel.tag!.tagType == TagType.running.value)) {
      return tagNoteScreenModel.unitSelectedType;
    }
    return '1';
  }

  update() async {
    await getPreference();

    var note = TagNote();
    note.date = tagNoteScreenModel.selectedDate.toString();
    note.apiId = widget.tagNote!.apiId.toString();
    note.time = tagNoteScreenModel.selectedTime.toString();
    note.value = tagNoteScreenModel.value;
    note.label = tagNoteScreenModel.tag!.label;
    note.note = noteTextEdit.text;
    note.userId = tagNoteScreenModel.userId;
    note.tagId = tagNoteScreenModel.tag!.id;
    note.isSync = 0;
    note.isRemove = 0;
    note.unitSelectedType = tagNoteScreenModel.unitSelectedType;

    note.note = getValue(note);
    note.unitSelectedType = getUnitSelectedValue();

    if (patchlocationController.text.toString().isEmpty &&
        tagNoteScreenModel.tag!.tagType == TagType.GlucosePatch.value) {
      showToast('Enter Glucose Patch Location');
    } else {
      note.patchLocation = patchlocationController.text.toString();
    }

    var isInternet = await Constants.isInternetAvailable();
    if (tagNoteScreenModel.userId != null &&
        !tagNoteScreenModel.userId!.contains('Skip') &&
        isInternet) {
      var time =
          '${tagNoteScreenModel.selectedTime.hour.toString().padLeft(2, '0')}:${tagNoteScreenModel.selectedTime.minute.toString().padLeft(2, '0')}:00';
      var date = DateFormat('yyyy/dd/MM').format(selectedDate);
      var map = {
        'id': note.apiId,
        'date': '$date',
        'note': getValue(note),
        'time': '$time',
        'type': note.label,
        'userId': tagNoteScreenModel.userId,
        'Location': note.patchLocation,
        'value': note.value,
        'AttachFile': tagNoteScreenModel.convertImageToListAPI(
            tagNoteScreenModel.tagImagesList, tagNoteScreenModel.tagImagesListString),
        'UnitSelectedType': getUnitSelectedValue(),
        'CreatedDateTimeStamp':
            note.createdDateTimeStamp ?? DateTime.now().millisecondsSinceEpoch.toString(),
      };
      print('post_updateData${map.toString()}');
      var result =
          await TagRepository().editTagRecordDetails(EditTagRecordDetailRequest.fromJson(map));
      if (result.hasData) {
        if (result.getData!.result!) {
          note.isSync = 1;
          note.apiId = result.getData!.iD!.toString();
        }
      }
    }

    Map<String, dynamic> map = note.toMap();
    map['Id'] = widget.tagNote!.id;

    map['AttachFiles'] = tagNoteScreenModel.convertImageToList(
        tagNoteScreenModel.tagImagesList, tagNoteScreenModel.tagImagesListString);

    helper.insertTagNote(map);
    print('update note $map');
  }

  Future getPreference() async {
    if (preferences != null)
      tagNoteScreenModel.userId = preferences!.getString(Constants.prefUserIdKeyInt)!;
    tagNoteScreenModel.isGraphExist = isExistInGraph() > -1;
//    if (mounted) {
//      setState(() {});
//    }
  }

  Future setValueInPicker() async {
//    double min = 0;
//    double max = 1;
//    double precision = 1;
    try {
      if (tagNoteScreenModel.tag != null) {
        if (tagNoteScreenModel.tag!.min != null) {
          tagNoteScreenModel.minPicker =
              double.parse(tagNoteScreenModel.tag!.min!.toDouble().toStringAsFixed(2));
        }
        if (tagNoteScreenModel.tag!.max != null) {
          tagNoteScreenModel.maxPicker =
              double.parse(tagNoteScreenModel.tag!.max!.toDouble().toStringAsFixed(2));
        }
        if (tagNoteScreenModel.tag!.precision != null) {
          tagNoteScreenModel.percisionPicker = tagNoteScreenModel.tag!.precision ?? 1;
          if (tagNoteScreenModel.tag!.precision == 0) {
            tagNoteScreenModel.percisionPicker = 1;
          }
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    try {
      if (tagNoteScreenModel.unitSelectedType == '1' &&
          tagNoteScreenModel.tag!.tagType == TagType.temperature.value) {
        tagNoteScreenModel.listPicker.clear();
        for (double i = 30; i <= 40; i += 0.1) {
          tagNoteScreenModel.listPicker.add(double.parse(i.toStringAsFixed(2)));
        }
      } else if (tagNoteScreenModel.unitSelectedType == '2' &&
          tagNoteScreenModel.tag!.tagType == TagType.temperature.value) {
        tagNoteScreenModel.listPicker.clear();
        for (double i = 86; i <= 104; i += 0.1) {
          tagNoteScreenModel.listPicker.add(double.parse(i.toStringAsFixed(2)));
        }
      } else if (tagNoteScreenModel.unitSelectedType == '2' &&
          tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value) {
        tagNoteScreenModel.listPicker.clear();
        for (int i = 0; i <= 720; i += 1) {
          tagNoteScreenModel.listPicker.add(double.parse(i.toStringAsFixed(2)));
        }
      } else if (tagNoteScreenModel.unitSelectedType == '1' &&
          tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value) {
        tagNoteScreenModel.listPicker.clear();
        for (double i = 0; i <= 40; i += 0.1) {
          tagNoteScreenModel.listPicker.add(double.parse(i.toStringAsFixed(2)));
        }
      } else {
        tagNoteScreenModel.listPicker.clear();
        for (double i = tagNoteScreenModel.minPicker;
            i <= tagNoteScreenModel.maxPicker;
            i += tagNoteScreenModel.percisionPicker) {
          tagNoteScreenModel.listPicker.add(double.parse(i.toStringAsFixed(2)));
        }
      }
    } on Exception catch (e) {
      print(e);
    }
//    tagNoteScreenModel.listPicker =
//        getValueListOfSelectedType(tagNoteScreenModel.listPicker);
//    list = getValueListOfSelectedType(list);
//    setState(() {});
  }

  resetMaximumValue(Tag tag) async {
    var dialog = AlertDialog(
      title: Text(stringLocalization.getText(StringLocalization.allowance)),
      content: TextFormField(
        controller: maxValueController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\\-|\\ ,|]'))],
        decoration: InputDecoration(
          hintText: stringLocalization.getText(StringLocalization.max),
          labelText: stringLocalization.getText(StringLocalization.max),
        ),
      ),
      actions: <Widget>[
        Consumer<TagNoteScreenModel>(builder: (context, model, child) {
          return FlatBtn(
            onPressed: () {
              tag.max = double.parse(maxValueController.text);
              Navigator.of(context, rootNavigator: true).pop();
              model.tag = tag;
              //updateTag(tag);
//              setState(() {});
            },
            text: stringLocalization.getText(StringLocalization.ok),
            color: AppColor.primaryColor,
          );
        }),
        FlatBtn(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          text: stringLocalization.getText(StringLocalization.cancel),
          color: IconTheme.of(context).color!,
        ),

      ],
    );
    await showDialog(context: context, builder: (context) => dialog, useRootNavigator: true);
  }

//  Future updateTag(Tag tag) async {
//    bool isInternet = await Constants.isInternetAvailable();
//    if (!userId.contains('Skip') && isInternet) {
//      Map map = {
//        'UserID': userId,
//        'ID': tag.apiId,
//        'ImageName': tag.icon,
//        'UnitName': tag.unit,
//        'LabelName': tag.label,
//        'MinRange': tag.min,
//        'MaxRange': tag.max,
//        'DefaultValue': tag.defaultValue,
//        'PrecisionDigit': tag.precision
//      };
//      await PostTagLabel()
//          .callApi(Constants.baseUrl + 'EditTagLabel', jsonEncode(map))
//          .then((result) {
//        if (!result['isError']) {
//          tag.apiId = result['value'].toString();
//          tag.isSync = 1;
//        }
//      });
//    }
//
//    Map map = tag.toMap();
//    map.putIfAbsent('Id', () => tag.id);
//    dbHelper.insertTag(map);
//    return Future.value();
//  }

  bool doesSmokeReachLimit() {
    if (tagNoteScreenModel.tag != null &&
        tagNoteScreenModel.tag!.tagType != null &&
        tagNoteScreenModel.tag!.tagType == TagType.smoke.value) {
      return tagNoteScreenModel.tag!.max == tagNoteList.length;
    }
    return false;
  }

  List getValueListOfSelectedType(List values) {
    List list = [];
    try {
      list = values.map((element) {
        double mMol = element;
        if (tagNoteScreenModel.unitSelectedType == '2') {
          if (tagNoteScreenModel.tag!.tagType == TagType.bloodGlucose.value) {
            mMol = element;
          } else if (tagNoteScreenModel.tag!.tagType == TagType.temperature.value) {
            mMol = element;
          }
        }
        return double.parse(mMol.toStringAsFixed(2));
      }).toList();
    } catch (e) {
      print(e);
    }
    return list;
  }

  // removeCharAtEndOfList() {
  //   List<String> splittedImages = [];
  //   List<String> result = [];
  //   if (widget.tagNote != null && widget.tagNote!.imageFiles != null) {
  //     splittedImages = widget.tagNote!.imageFiles!.split(',');
  //     splittedImages.forEach((element) {
  //       if (element != '') {
  //         result.add(element);
  //       }
  //     });
  //    // result = widget.tagNote!.imageFiles!;
  //   }
  //   return result;
  // }

  /// added by : Shahzad
  /// added on : 28th April 2021
  /// this function initialize the tag image list with images fetch from database.
  getTagImageList() {
    List<String> splittedImages = [];
    if (widget.tagNote != null && widget.tagNote!.imageFiles != null) {
      splittedImages = widget.tagNote!.imageFiles!.split(',');
      splittedImages.forEach((element) {
        if (element != '') {
          if (element.startsWith("http")) {
            tagNoteScreenModel.tagImagesListString.add(element);
          } else {
            tagNoteScreenModel.tagImagesList.add(base64Decode(element));
          }
        }
      });
    }
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}
