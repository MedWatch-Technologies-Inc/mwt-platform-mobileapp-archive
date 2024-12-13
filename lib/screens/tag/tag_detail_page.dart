import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/covid_19_tag_type_model.dart';
import 'package:health_gauge/repository/tag/tag_repository.dart';
import 'package:health_gauge/screens/tag/add_tag_dialog.dart';
import 'package:health_gauge/screens/tag/helper_widgets/app_button.dart';
import 'package:health_gauge/screens/tag/helper_widgets/tag_detail_tabbar.dart';
import 'package:health_gauge/screens/tag/model/tag_detail.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/screens/tag/model/tag_record_detail.dart';
import 'package:health_gauge/screens/tag/tag_note_screen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/time_picker.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/loading_indicator_overlay.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../repository/tag/request/store_tag_record_detail_request.dart';

class TagDetailPage extends StatelessWidget {
  TagDetailPage({
    required this.tagLabel,
    this.mode = MODE.MANUAL,
    this.tagCount = 0,
    this.isForEdit = false,
    super.key,
  }) {
    tagLabelWork = ValueNotifier(tagLabel);
    if (tagLabel.precisionDigit > 0) {
      setRangeList();
    } else {
      defaultRangeValue.value = tagLabel.defaultValue.toDouble();
    }
    if (tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value) {
      unitSelectedType = (bloodGlucoseUnit + 1).toString();
    } else if (tagLabel.fKTagLabelTypeID == TagType.temperature.value) {
      unitSelectedType = (tempUnit + 1).toString();
    }
    // setListOfCovid();
    print('TagLabelPage JSON :: ${tagLabel.toJson()}');
    print('TagLabelPage JSON :: ${tagLabel.tagVType}');
  }

  TagLabel tagLabel;
  final MODE mode;
  final int tagCount;
  final bool isForEdit;

  late ValueNotifier<TagLabel> tagLabelWork;

  num hkValue = 0.0;
  bool anyUpdate = false;
  String unitSelectedType = '1';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: tagLabelWork,
      builder: (BuildContext context, TagLabel value, Widget? child) {
        return Scaffold(
          appBar: TagDetailAppbar(
            tagLabel: tagLabel,
            result: anyUpdate,
            onUpdate: (TagLabel tagLabel) async {
              this.tagLabel = tagLabel;
              tagLabelWork.value = tagLabel;
              if (tagLabel.precisionDigit > 0) {
                setRangeList();
              } else {
                defaultRangeValue.value = tagLabel.defaultValue.toDouble();
              }
              if (tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value) {
                unitSelectedType = (bloodGlucoseUnit + 1).toString();
              } else if (tagLabel.fKTagLabelTypeID == TagType.temperature.value) {
                unitSelectedType = (tempUnit + 1).toString();
              }
              anyUpdate = true;
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 105.h,
                    width: 105.h,
                    margin: EdgeInsets.only(top: 32.h, left: 33.w, right: 33.w),
                    child: selectedImageView(context),
                  ),
                ),
                if (tagLabel.shortDescription.isNotEmpty) ...[
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
                        text: tagLabel.shortDescription,
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
                if (tagLabel.tagVType == TagVType.slider) ...[
                  ValueListenableBuilder(
                    valueListenable: defaultRangeValue,
                    builder: (BuildContext context, double value, Widget? child) {
                      return slider(context);
                    },
                  ),
                ] else ...[
                  // unitWidget(context),
                  if (tagLabel.labelName == 'Glucose Patch') ...[
                    Container(
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
                        ],
                      ),
                      child: TextFormField(
                        controller: patchLocationController,
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
                                : HexColor.fromHex('#7F8D8C'),
                          ),
                        ),
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ] else ...[
                    ValueListenableBuilder(
                      valueListenable: defaultRangeValue,
                      builder: (BuildContext context, double value, Widget? child) {
                        return selectDefaultValue(context);
                      },
                    ),
                  ]
                ],
                SizedBox(
                  height: 8.h,
                ),
                dateWidget(context),
                SizedBox(
                  height: 6.h,
                ),
                timeWidget(context),
                SizedBox(
                  height: 8.h,
                ),
                note(context),
                ValueListenableBuilder(
                  valueListenable: tagFileList,
                  builder: (BuildContext context, List<Uint8List> imageByteList, Widget? child) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 29.h),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: imageByteList.length == 1
                            ? 1
                            : imageByteList.length == 2
                                ? 2
                                : 3,
                        childAspectRatio: imageByteList.length == 1 ? 1.8 : 1,
                      ),
                      itemCount: imageByteList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var uInt8List = imageByteList.elementAt(index);
                        return Stack(
                          children: [
                            imageItem(context, uInt8List, imageType: 2),
                            ValueListenableBuilder(
                              valueListenable: isImageEditing,
                              builder: (BuildContext context, bool value, Widget? child) {
                                if (!value) {
                                  return SizedBox();
                                }
                                return removeImageIcon(
                                  onTap: () {
                                    tagFileList.value.removeAt(index);
                                    tagFileList.notifyListeners();
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 8.h,
                ),
                ValueListenableBuilder(
                  valueListenable: tagHTTPImageList,
                  builder: (BuildContext context, List<String> imageHTTPList, Widget? child) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 29.h),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: imageHTTPList.length == 1
                            ? 1
                            : imageHTTPList.length == 2
                                ? 2
                                : 3,
                        childAspectRatio: imageHTTPList.length == 1 ? 1.8 : 1,
                      ),
                      itemCount: imageHTTPList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var image = imageHTTPList.elementAt(index);
                        if (image.contains('http')) {
                          return Stack(
                            children: [
                              imageItem(context, image, imageType: 1),
                              ValueListenableBuilder(
                                valueListenable: isImageEditing,
                                builder: (BuildContext context, bool value, Widget? child) {
                                  if (!value) {
                                    return SizedBox();
                                  }
                                  return removeImageIcon(
                                    onTap: () {
                                      tagHTTPImageList.value.removeAt(index);
                                      tagHTTPImageList.notifyListeners();
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    );
                  },
                ),
                AppButton(
                  title: (isForEdit
                          ? StringLocalization.of(context).getText(StringLocalization.updateNote)
                          : StringLocalization.of(context).getText(StringLocalization.addNote))
                      .toUpperCase(),
                  onTap: () async {
                    await addTagNote(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<RadioModel> bloodGlucoseList = [RadioModel(false, 'mmol/L'), RadioModel(false, 'mg/dL')];
  List<RadioModel> temperatureList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.celsius)),
    RadioModel(false, stringLocalization.getText(StringLocalization.fahrenheit)),
  ];
  TextEditingController patchLocationController = TextEditingController();

  Widget unitWidget(BuildContext context) {
    if (tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value && unitSelectedType != '0') {
      return Container(
        margin: EdgeInsets.only(left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: bloodGlucoseList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  height: 28.h,
                  child: customRadio(
                    context,
                    index: index,
                    color: index + 1 == int.parse(unitSelectedType)
                        ? HexColor.fromHex('FF6259')
                        : Colors.transparent,
                    unitText: bloodGlucoseList[index].text,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
    if (tagLabel.fKTagLabelTypeID == TagType.temperature.value && unitSelectedType != '0') {
      return Container(
        margin: EdgeInsets.only(left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: temperatureList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  height: 40,
                  child: customRadio(
                    context,
                    index: index,
                    color: index + 1 == int.parse(unitSelectedType)
                        ? HexColor.fromHex('FF6259')
                        : Colors.transparent,
                    unitText: temperatureList[index].text,
                  ),
                );
              },
            )
          ],
        ),
      );
    }

    return Container(
      height: 25.h,
      child: Center(
        child: TitleText(
          text: tagLabel.fKTagLabelTypeID == TagType.GlucosePatch.value
              ? '${StringLocalization.of(context).getText(StringLocalization.glucosepatchlocation)}'
              : tagLabel.fKTagLabelTypeID == TagType.medicine.value
                  ? '${StringLocalization.of(context).getText(StringLocalization.numberOfPills)}'
                  : tagLabel.fKTagLabelTypeID == TagType.Alcohol.value
                      ? '${StringLocalization.of(context).getText(StringLocalization.glassOf)}'
                      : tagLabel.fKTagLabelTypeID == TagType.smoke.value
                          ? '${StringLocalization.of(context).getText(StringLocalization.numberOfSmoke)}'
                          : '${StringLocalization.of(context).getText(StringLocalization.tagLevel)}${tagLabel.labelName}',
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

  ValueNotifier<num> selectedValue = ValueNotifier<num>(0);
  ValueNotifier<num> minRange = ValueNotifier<num>(0);
  ValueNotifier<num> maxRange = ValueNotifier<num>(0);
  ValueNotifier<num> precisionRange = ValueNotifier<num>(0);
  ValueNotifier<num> precisionPicker = ValueNotifier<num>(0);
  ValueNotifier<List<num>> rangeList = ValueNotifier<List<num>>([]);
  FixedExtentScrollController scrollController = FixedExtentScrollController();

  Future setValueInPicker() async {
    try {
      if (tagLabel.minRange > 0.0) {
        minRange.value = double.parse(tagLabel.minRange.toDouble().toStringAsFixed(2));
      }
      if (tagLabel.maxRange > 0.0) {
        maxRange.value = double.parse(tagLabel.maxRange.toDouble().toStringAsFixed(2));
      }
      precisionPicker.value = tagLabel.precisionDigit;
      if (tagLabel.precisionDigit == 0) {
        precisionPicker.value = 1;
      }
    } on Exception catch (e) {
      print(e);
    }
    try {
      if (unitSelectedType == '1' && tagLabel.fKTagLabelTypeID == TagType.temperature.value) {
        rangeList.value.clear();
        for (double i = 30; i <= 40; i += 0.1) {
          rangeList.value.add(double.parse(i.toStringAsFixed(2)));
        }
      } else if (unitSelectedType == '2' &&
          tagLabel.fKTagLabelTypeID == TagType.temperature.value) {
        rangeList.value.clear();
        for (double i = 86; i <= 104; i = i + 0.1) {
          rangeList.value.add(double.parse(i.toStringAsFixed(2)));
        }
      } else if (unitSelectedType == '2' &&
          tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value) {
        rangeList.value.clear();
        for (int i = 0; i <= 720; i += 1) {
          rangeList.value.add(double.parse(i.toStringAsFixed(2)));
        }
      } else if (unitSelectedType == '1' &&
          tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value) {
        rangeList.value.clear();
        for (double i = 0; i <= 40; i += 0.1) {
          rangeList.value.add(double.parse(i.toStringAsFixed(2)));
        }
      } else {
        rangeList.value.clear();
        for (double i = tagLabel.minRange.toDouble();
            i <= tagLabel.maxRange.toDouble();
            i += tagLabel.precisionDigit.toDouble()) {
          rangeList.value.add(double.parse(i.toStringAsFixed(2)));
        }
      }
      rangeList.notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  void checkListNull(int index) {
    unitSelectedType = (index + 1).toString();
    if (unitSelectedType == '2') {
      if (tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value) {
        selectedValue.value = ((selectedValue.value * 18).truncateToDouble());
      } else if (tagLabel.fKTagLabelTypeID == TagType.temperature.value) {
        selectedValue.value =
            double.parse(((selectedValue.value * (9 / 5)) + 32).toStringAsFixed(1));
      }
    } else {
      if (tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value) {
        selectedValue.value = double.parse((selectedValue.value / 18).toStringAsFixed(1));
        print(selectedValue);
      } else if (tagLabel.fKTagLabelTypeID == TagType.temperature.value) {
        selectedValue.value = double.parse(((selectedValue.value - 32) * 5 / 9).toStringAsFixed(1));
      }
    }
    selectedValue.notifyListeners();
  }

  Widget customRadio(BuildContext context,
      {int? index, List<Covid19TagTypeModel>? list, Color? color, String? unitText}) {
    return GestureDetector(
      onTap: () async {
        checkListNull(index!);
        await setValueInPicker();
        if (tagLabel.fKTagLabelTypeID == TagType.temperature.value && unitSelectedType == '2') {
          if (scrollController.hasClients) {
            scrollController.animateTo(65.w * rangeList.value.indexOf(selectedValue.value),
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          }
        } else {
          if (scrollController.hasClients) {
            scrollController.animateTo(55.w * rangeList.value.indexOf(selectedValue.value),
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          }
        }
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
  }

  Future<void> addTagNote(BuildContext context) async {
    var entry = showOverlay(context);
    try {
      var requestMap = addTagRequestData(context);
      var requestData = StoreTagRecordDetailRequest.fromJson(requestMap);
      var response = await TagRepository().storeTagRecordDetails(requestData);
      if (response.hasData) {
        if (response.getData!.result!) {
          var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(
              DateTime.fromMillisecondsSinceEpoch(int.parse(requestMap['CreatedDateTimeStamp'])));

          requestMap.addAll({'ID': response.getData!.iD.toString()});
          requestMap.addAll({'FKTagLabelID': tagLabel.iD});
          requestMap.addAll({'TagValue': requestMap['value']});
          requestMap.addAll({'Note': requestMap['note']});
          requestMap.addAll({'FKUserID': requestMap['userId']});
          requestMap.addAll({'TypeName': tagLabel.labelName});
          requestMap.addAll({'CreatedDateTime': dateTime});
          requestMap.addAll({'CreatedDateTimeTimestamp': requestMap['CreatedDateTimeStamp']});
          requestMap.addAll({'TagImage': tagLabel.imageName});
          requestMap.addAll({'TagLabelName': tagLabel.labelName});
          requestMap.addAll({'AttachFiles': requestMap['AttachFile']});
          requestMap.addAll({'Date': requestMap['date']});
          requestMap.addAll({'Time': requestMap['time']});
          requestMap.addAll({'FKTagLabelTypeID': tagLabel.fKTagLabelTypeID});
          requestMap.addAll({'Short_description': tagLabel.shortDescription});

          var tagRecord = TagRecordDetail.fromJson(requestMap);
          await dbHelper.insertTagRecord([tagRecord]);
          CustomSnackBar.buildSnackbar(context, 'Note added Successfully', 3);
        }
      }
    } catch (e) {
      print('AppException :: addTagNote :: $e');
      CustomSnackBar.buildSnackbar(context, e.toString(), 3);
    } finally {
      entry.remove();
    }
  }

  Map<String, dynamic> addTagRequestData(BuildContext context) {
    var requestData = <String, dynamic>{};
    var time =
        '${sTime.value.hour.toString().padLeft(2, '0')}:${sTime.value.minute.toString().padLeft(2, '0')}:00';
    var date = DateFormat(DateUtil.yyyyMMdd).format(sDate.value);
    var dateTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    var patchLocation = '';
    if (patchLocationController.text.toString().isEmpty &&
        tagLabel.fKTagLabelTypeID == TagType.GlucosePatch.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter Glucose Patch Location'),
        ),
      );
    } else {
      patchLocation = patchLocationController.text.toString();
    }
    requestData = <String, dynamic>{
      'date': date,
      'note': notesController.text.trim(),
      'time': time,
      'type': tagLabel.labelName,
      'userId': tagLabel.userID.toString(),
      'value': defaultRangeValue.value,
      'UnitSelectedType': getUnitSelectedValue(),
      'AttachFile': convertImageToListAPI(),
      'CreatedDateTimeStamp': dateTimeStamp,
      'Location': patchLocation,
    };
    return requestData;
  }

  List unitSelectedTypeList = <String>[];
  ValueNotifier<List<Covid19TagTypeModel>> unitItemListForCovid =
      ValueNotifier<List<Covid19TagTypeModel>>([]);

  List<String> convertImageToListAPI() {
    var temp = <String>[];
    for (var i = 0; i < tagFileList.value.length; i++) {
      var base64Image = base64Encode(tagFileList.value.elementAt(i));
      temp.add(base64Image);
    }
    for (var i = 0; i < tagHTTPImageList.value.length; i++) {
      temp.add(tagHTTPImageList.value.elementAt(i));
    }
    return temp;
  }

  void setListOfCovid() {
    unitItemListForCovid.value.addAll([
      Covid19TagTypeModel(
        id: '1',
        itemName: 'Shortness of breath to trouble breathing (new or worsening)',
        isSelected: unitSelectedTypeList.contains('1'),
      ),
      Covid19TagTypeModel(
        id: '2',
        itemName: 'Cough (new or worsening)',
        isSelected: unitSelectedTypeList.contains('2'),
      ),
      Covid19TagTypeModel(
        id: '3',
        itemName: 'Fever',
        isSelected: unitSelectedTypeList.contains('3'),
      ),
      Covid19TagTypeModel(
        id: '4',
        itemName: 'Chest pain (new or worsening)',
        isSelected: unitSelectedTypeList.contains('4'),
      ),
      Covid19TagTypeModel(
        id: '5',
        itemName: 'Nausea and/or vomiting',
        isSelected: unitSelectedTypeList.contains('5'),
      ),
      Covid19TagTypeModel(
        id: '6',
        itemName: 'Diarrhea (more than 3 loose stools per day)',
        isSelected: unitSelectedTypeList.contains('6'),
      ),
    ]);
    unitItemListForCovid.notifyListeners();
  }

  String getUnitSelectedValue() {
    if (tagLabel.fKTagLabelTypeID == TagType.CORONA.value) {
      return unitItemListForCovid.value
          .where((element) => element.isSelected)
          .toList()
          .map((e) => e.id)
          .toList()
          .join(',');
    }
    if (tagLabel.fKTagLabelTypeID == TagType.bloodGlucose.value ||
        tagLabel.fKTagLabelTypeID == TagType.temperature.value ||
        tagLabel.fKTagLabelTypeID == TagType.running.value) {
      return unitSelectedType;
    }
    return '1';
  }

  Widget removeImageIcon({required VoidCallback onTap}) {
    return Align(
      alignment: Alignment.topRight,
      child: ValueListenableBuilder(
        valueListenable: isImageEditing,
        builder: (BuildContext context, bool value, Widget? child) {
          return InkWell(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(top: 22, right: 15),
              height: 21.h,
              width: 21.h,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(2.5),
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
    );
  }

  Widget imageItem(BuildContext context, dynamic image, {required int imageType}) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 17.h, bottom: 8.h),
      width: MediaQuery.of(context).size.width,
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
      child: InkWell(
        onLongPress: () {
          HapticFeedback.vibrate();
          isImageEditing.value = true;
        },
        onTap: () {
          if (isImageEditing.value) {
            isImageEditing.value = false;
          } else {
            /*showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return fullImage(model.tagImagesListString[index]);
              },
            );*/
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.w),
          child: imageListItem(image, imageType),
        ),
      ),
    );
  }

  Widget imageListItem(dynamic image, int imageType) {
    switch (imageType) {
      case 1:
        return Image.network(
          image,
          height: 241.h,
          fit: BoxFit.cover,
        );
      case 2:
        return Image.memory(
          image,
          height: 241.h,
          fit: BoxFit.cover,
        );
      default:
        return SizedBox();
    }
  }

  Widget selectedImageView(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'asset/imageBackground_dark.png'
              : 'asset/imageBackground_light.png',
        ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.h),
              child: imageWidget(context, tagLabel.imageName),
            )
          ],
        ),
      ],
    );
  }

  Widget imageWidget(BuildContext context, String imageName) {
    if (imageName.isEmpty) {
      imageName = 'asset/placeholder.png';
    }
    if (imageName.contains('asset')) {
      return Image.asset(
        imageName,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#62CBC9')
            : HexColor.fromHex('00AFAA'),
      );
    }
    if (imageName.contains('https') || imageName.contains('http')) {
      return Image.network(
        imageName,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#62CBC9')
            : HexColor.fromHex('00AFAA'),
      );
    }
    return Image.memory(
      base64Decode(imageName),
      color: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#62CBC9')
          : HexColor.fromHex('00AFAA'),
      gaplessPlayback: true,
    );
  }

  ValueNotifier<double> defaultRangeValue = ValueNotifier(1.0);

  Widget slider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 23.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 33.w,
            ),
            child: Text(
              stringLocalization.getText(StringLocalization.intensity),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                key: Key('exerciseSliderKey'),
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
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 26.0),
                    overlayColor: HexColor.fromHex('#99D9D9').withOpacity(0.5),
                    inactiveTickMarkColor: Colors.transparent,
                    activeTickMarkColor: Colors.transparent,
                    valueIndicatorColor: HexColor.fromHex('#FF6259'),
                    valueIndicatorTextStyle: TextStyle(
                        color: HexColor.fromHex('#FFDFDE'),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    key: Key('exerciseSlider'),
                    value: defaultRangeValue.value,
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    label: defaultRangeValue.value.round().toString(),
                    //widget.tag != null ? widget.tag.defaultValue.round().toString() : "0",
                    onChanged: (double selectedValue) {
                      defaultRangeValue.value = selectedValue;
                    },
                  ),
                ),
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
                  text: stringLocalization.getText(StringLocalization.moderate).toUpperCase(),
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
    );
  }

  Widget selectDefaultValue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 33.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 23.h),
          ValueListenableBuilder(
            valueListenable: defaultRangeValue,
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                '${stringLocalization.getText(StringLocalization.defaultValueTag)} ${value.toStringAsFixed(1)}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          SizedBox(height: 13.h),
          Center(
            child: Container(
              height: 35.h,
              width: 259.w,
              decoration: BoxDecoration(
                boxShadow: [
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
                ],
              ),
              child: Container(
                key: Key('addTagScroller'),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : HexColor.fromHex('#F2F2F2'),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
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
                    ],
                  ),
                ),
                height: 35.h,
                width: 259.w,
                child: RotatedBox(
                  quarterTurns: 135,
                  child: ValueListenableBuilder(
                    valueListenable: rangeList,
                    builder: (context, valueList, widget) {
                      return CustomCupertinoPicker(
                        backgroundColor: Colors.transparent,
                        scrollController: FixedExtentScrollController(
                            initialItem: valueList.indexOf(defaultRangeValue.value)),
                        itemExtent:
                            tagLabel.maxRange.toDouble().toStringAsFixed(0).toString().length == 3
                                ? 50.w
                                : 45.w,
                        children: List.generate(
                          valueList.length,
                          (index) {
                            return RotatedBox(
                              quarterTurns: 45,
                              child: Center(
                                child: ValueListenableBuilder(
                                  valueListenable: defaultRangeValue,
                                  builder: (context, selectedValue, widget) {
                                    return TitleText(
                                      text: valueList[index].toStringAsFixed(
                                          tagLabel.precisionDigit.toString().contains('.') ? 1 : 0),
                                      color: selectedValue == valueList[index]
                                          ? HexColor.fromHex('#FF6259')
                                          : Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                              : HexColor.fromHex('#5D6A68'),
                                      fontWeight: selectedValue == valueList[index]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: valueList[index].toString().length > 2
                                          ? 14.sp
                                          : valueList[index].toString().length > 1
                                              ? 16.sp
                                              : 18.sp,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        onSelectedItemChanged: (int value) {
                          defaultRangeValue.value = rangeList.value[value].toDouble();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setRangeList() {
    var min = 1.0;
    var max = 10.0;
    var precision = 1.0;

    if (tagLabel.minRange.toString().trim().isNotEmpty) {
      try {
        min = tagLabel.minRange.toDouble();
      } catch (e) {
        print(e);
      }
    }
    if (tagLabel.maxRange.toString().trim().isNotEmpty) {
      try {
        max = tagLabel.maxRange.toDouble();
      } catch (e) {
        print(e);
      }
    }
    if (tagLabel.precisionDigit.toString().trim().isNotEmpty) {
      try {
        precision = tagLabel.precisionDigit.toDouble();
      } catch (e) {
        print(e);
      }
    }
    if (precision <= 0) {
      precision = 1.0;
    }

    var temp = <double>[];
    for (var i = min; i <= max; i = i + precision) {
      temp.add(i);
    }

    rangeList.value.clear();
    rangeList.value.addAll(temp);
    rangeList.notifyListeners();

    defaultRangeValue.value = tagLabel.defaultValue.toDouble();

    if (!rangeList.value.contains(defaultRangeValue.value)) {
      defaultRangeValue.value = rangeList.value.first.toDouble();
    }
  }

  ValueNotifier<DateTime> sDate = ValueNotifier(DateTime.now());
  ValueNotifier<TimeOfDay> sTime = ValueNotifier(TimeOfDay.now());

  Widget dateWidget(BuildContext context) {
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
        ],
      ),
      child: Row(
        children: [
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
            width: 100,
            child: ValueListenableBuilder(
              valueListenable: sDate,
              builder: (BuildContext context, DateTime dateValue, Widget? child) {
                return Body1AutoText(
                  text: DateFormat(DateUtil.ddMMyyyy).format(dateValue),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16,
                  minFontSize: 9,
                );
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: Container(
                  height: 20,
                  child: GestureDetector(
                    onTap: () async {
                      var date = await Date().selectDate(context, sDate.value);
                      sDate.value = date;
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
          ),
        ],
      ),
    );
  }

  Widget timeWidget(BuildContext context) {
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
      child: Row(
        children: [
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
            width: 100,
            child: ValueListenableBuilder(
              valueListenable: sTime,
              builder: (BuildContext context, TimeOfDay timeValue, Widget? child) {
                return Body1AutoText(
                  text:
                      '${timeValue.hour.toString().padLeft(2, '0')} : ${timeValue.minute.toString().padLeft(2, '0')}',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  minFontSize: 9,
                  fontSize: 16,
                );
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: Container(
                  // width: 59,
                  height: 20,
                  child: GestureDetector(
                    onTap: () async {
                      var time = await Time().selectTime(context, sTime.value);
                      sTime.value = time;
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController notesController = TextEditingController();

  Widget note(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80.h,
            child: TextFormField(
              controller: notesController,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16.w, right: 16.w),
                hintText: StringLocalization.of(context).getText(StringLocalization.notes),
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
              onChanged: (value) {
                // isTagEdit = true;
                // setState(() {});
              },
              textInputAction: TextInputAction.newline,
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
                onTap: () {
                  pickGallery(context);
                },
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  height: 33.h,
                  width: 33.h,
                  child: Image.asset('asset/camera_icon.png'),
                ),
                onTap: () {
                  pickCamera(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  ValueNotifier<PickedFile?> imageFile = ValueNotifier(null);
  ValueNotifier<File?> croppedImageFile = ValueNotifier(null);
  ValueNotifier<List<Uint8List>> tagFileList = ValueNotifier([]);
  ValueNotifier<List<String>> tagHTTPImageList = ValueNotifier([]);
  ValueNotifier<bool> isImageEditing = ValueNotifier(false);

  void pickGallery(BuildContext context) async {
    var pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    );
    if (pickedImage != null) {
      await _cropImage(File(pickedImage.path));
    }
  }

  void pickCamera(BuildContext context) async {
    var pickedImage = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      imageQuality: 100,
    );
    if (pickedImage != null) {
      await _cropImage(File(pickedImage.path));
    }
  }

  Future<void> _cropImage(File imageFile) async {
    var croppedFile = await ImageCropper.platform.cropImage(
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
      File? imageFile = File(croppedFile.path);
      croppedImageFile.value = imageFile;
      var base64DecodedImage = imageFile.readAsBytesSync();
      tagFileList.value.add(base64DecodedImage);
      tagFileList.notifyListeners();
    }
  }
}
