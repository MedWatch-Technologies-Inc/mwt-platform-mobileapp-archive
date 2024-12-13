import 'package:flutter/material.dart';
import 'package:health_gauge/models/covid_19_tag_type_model.dart';
import 'package:health_gauge/repository/tag/request/get_tag_label_list_request.dart';
import 'package:health_gauge/repository/tag/tag_repository.dart';
import 'package:health_gauge/screens/tag/model/pre_configured_tag.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagHelper {
  static final TagHelper _singleton = TagHelper._internal();

  factory TagHelper() {
    return _singleton;
  }

  TagHelper._internal();

  int pageCount = 1;
  final RefreshController controller = RefreshController();
  ValueNotifier<List<TagLabel>> tagList = ValueNotifier([]);
  ValueNotifier<List<PreConfiguredTag>> preConfigTagList = ValueNotifier([]);

  String get userID => preferences!.getString(Constants.prefUserIdKeyInt) ?? '';

  String get prefStart => preferences!.getString('${userID}_tag_start') ?? '';

  void getPreConfigTagList() async {
    var response = await TagRepository().getPreConfigTagLabelList({
      'UserID': 0,
      'PageNumber': 1,
      'PageSize': 100,
    });
    if (response.getData != null &&
        response.getData!.data != null &&
        response.getData!.data!.isNotEmpty) {
      var list = response.getData!.data!;
      var tempList = <PreConfiguredTag>[];
      for (var element in list) {
        var tagLabel = PreConfiguredTag.fromJson(element.toJson());
        tempList.add(tagLabel);
      }
      preConfigTagList.value.clear();
      preConfigTagList.value.addAll(tempList);
    }
  }

  void getTagList({int type = 1}) async {
    var request = getRequest(type: type);
    var response = await TagRepository().getTagLabelList(request);
    if (response.getData != null &&
        response.getData!.data != null &&
        response.getData!.data!.isNotEmpty) {
      var list = response.getData!.data!;
      var tempList = <TagLabel>[];
      for (var element in list) {
        var tagLabel = TagLabel.fromJson(element.toJson());
        tempList.add(tagLabel);
      }
      await dbHelper.insertTagLabel(tempList, userID);
      fetchTagFromLocal();
    }
    if (controller.isRefresh) {
      controller.refreshCompleted();
    }
  }

  GetTagLabelListRequest getRequest({required int type}) {
    var startDate = DateTime.now();
    switch (type) {
      case 1:
        startDate = DateTime.now().subtract(Duration(days: 150));
        break;
      case 2:
        startDate = prefStart.isNotEmpty
            ? DateTime.parse(prefStart)
            : DateTime.now().subtract(Duration(days: 150));
        break;
      default:
        startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }
    var endDate = DateTime.now();
    return GetTagLabelListRequest(
      userID: userID,
      pageIndex: pageCount,
      pageSize: 100,
      iDs: [],
      fromDate: DateFormat(DateUtil.yyyyMMdd).format(startDate),
      toDate: DateFormat(DateUtil.yyyyMMdd).format(endDate),
      fromDateStamp: startDate.millisecondsSinceEpoch.toString(),
      toDateStamp: endDate.millisecondsSinceEpoch.toString(),
    );
  }

  void deleteFromLocal(TagLabel tagLabel, BuildContext context) async {
    var result = await dbHelper.deleteTagLabel(tagLabel.userID, tagLabel.iD);
    if (result > 0) {
      CustomSnackBar.buildSnackbar(context, 'Deleted Tag Successfully', 3);
      tagList.value.remove(tagLabel);
      tagList.notifyListeners();
    }
  }

  void fetchTagFromLocal() async {
    var tempList = await dbHelper.fetchTagLabel(userID);
    if (tempList.isNotEmpty) {
      tagList.value.clear();
      tagList.value.addAll(tempList);
      tagList.notifyListeners();
    }
  }

  /*List<PreConfiguredTag> preConfigTagList = [
    PreConfiguredTag(
      id: 1,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/band_icon.png',
      labelName: 'Stress',
      unitName: 'Level',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
    PreConfiguredTag(
      id: 2,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 100.0,
      imageName: 'asset/Wellness/frown_icon.png',
      labelName: 'Fever',
      unitName: 'Celsius',
      tagLabelTypeID: 3,
      maxRange: 110.0,
      minRange: 97.0,
      precisionDigit: 0.5,
    ),
    PreConfiguredTag(
      id: 3,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/injured_icon.png',
      labelName: 'Dizziness',
      unitName: 'Level',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
    PreConfiguredTag(
      id: 4,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/brain_icon.png',
      labelName: 'Headache',
      unitName: 'Intensity',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
    PreConfiguredTag(
      id: 5,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 7.0,
      imageName: 'asset/Wellness/sleepIcon.png',
      labelName: 'Sleep Disturbances',
      unitName: 'Hours',
      tagLabelTypeID: 3,
      maxRange: 15.0,
      minRange: 0.5,
      precisionDigit: 0.5,
    ),
    PreConfiguredTag(
      id: 6,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/bone_break_icon.png',
      labelName: 'Body Pain',
      unitName: 'Level',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
    PreConfiguredTag(
      id: 7,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/wc_icon.png',
      labelName: 'Diarrhea',
      unitName: 'Level',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
    PreConfiguredTag(
      id: 8,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/injured_icon.png',
      labelName: 'Injured',
      unitName: 'Level',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
    PreConfiguredTag(
      id: 9,
      createdDateTime: DateTime.now().toString(),
      createdDateTimeStamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      defaultValue: 5.0,
      imageName: 'asset/Wellness/hr_icon.png',
      labelName: 'Chest Pain',
      unitName: 'Level',
      tagLabelTypeID: 3,
      maxRange: 1.0,
      minRange: 10.0,
      precisionDigit: 0.0,
    ),
  ];*/
}
