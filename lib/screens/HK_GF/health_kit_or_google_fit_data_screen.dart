import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/screens/HK_GF/helper_widgets/select_type_item.dart';
import 'package:health_gauge/screens/HK_GF/hk_gf_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HealthKitOrGoogleFitDataScreen extends StatefulWidget {
  final String screenTitle;
  final String typeName;
  final String unit;
  final Vital vital;

  HealthKitOrGoogleFitDataScreen({
    required this.screenTitle,
    required this.typeName,
    required this.unit,
    required this.vital,
  });

  @override
  _HealthKitOrGoogleFitDataScreenState createState() => _HealthKitOrGoogleFitDataScreenState();
}

class _HealthKitOrGoogleFitDataScreenState extends State<HealthKitOrGoogleFitDataScreen> {
  bool isLoading = false;
  bool isLoadMore = false;
  final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now();
  Duration timeZoneOffset = DateTime.now().timeZoneOffset;
  int loadMoreLoop = 1;

  String? userId;
  List<HealthKitOrGoogleFitModel> data = <HealthKitOrGoogleFitModel>[];

  List idList = [];

  @override
  void initState() {
    HKGFHelper.instance.fetchLocalData(typeName: widget.typeName, isInIt: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        HKGFHelper.instance.dataList.value.clear();
        HKGFHelper.instance.dataList.notifyListeners();
        return true;
      },
      child: Scaffold(
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
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              centerTitle: true,
              actions: [
                ValueListenableBuilder(
                  valueListenable: HKGFHelper.instance.getPercentageNotifier(widget.vital),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Visibility(
                      visible: value > 0.0 && value <= 100.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: value == 100.0
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: HexColor.fromHex('62CBC9'),
                                    size: 12.0,
                                  )
                                : CircularProgressIndicator(
                                    color: HexColor.fromHex('62CBC9'),
                                    strokeWidth: 2.0,
                                  ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${value.toStringAsFixed(0)} %',
                            style: TextStyle(
                              color: HexColor.fromHex('#62CBC9'),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  HKGFHelper.instance.dataList.value.clear();
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
              title: Text(widget.screenTitle ?? '',
                  style: TextStyle(
                      color: HexColor.fromHex('#62CBC9'),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        body: isLoading ? Center(child: CircularProgressIndicator()) : displayData(),
        //  ),
      ),
    );
  }

  Widget displayData() {
    return ValueListenableBuilder(
      valueListenable: HKGFHelper.instance.dataList,
      builder: (BuildContext context, List<HealthKitOrGoogleFitModel> value, Widget? child) {
        return SmartRefresher(
          controller: HKGFHelper.instance.refreshController,
          enablePullDown: true,
          enablePullUp: HKGFHelper.instance.hasData.value,
          onLoading: () {
            HKGFHelper.instance.fetchLocalData(typeName: widget.typeName);
          },
          onRefresh: () async {
            await HKGFHelper.instance.fetchIndividualVital(vital: widget.vital);
            HKGFHelper.instance.fetchLocalData(typeName: widget.typeName, isInIt: true, limit: 100);
          },
          child: Column(
            children: [
              headingOfTitles(),
              Expanded(
                child: value.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: Body1Text(
                          text: stringLocalization.getText(
                            StringLocalization.noDataFound,
                          ),
                          fontSize: 14.0,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                          left: 25.0,
                          right: 25.0,
                        ),
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return listItem(value[index]) ?? Container();
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget headingOfTitles() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Body2Text(
                  text: widget.screenTitle ?? '',
                  align: TextAlign.start,
                  fontWeight: FontWeight.bold,
                  maxLine: 2,
                ),
              ),
              Expanded(
                child: Body2Text(
                  text: widget.typeName == Constants.healthKitBloodGlucose ? 'Time' : 'Start Time',
                  align: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.typeName == Constants.healthKitBloodGlucose
                  ? Container()
                  : Expanded(
                      child: Body2Text(
                        text: 'End Time',
                        align: TextAlign.right,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
          Divider(
            height: 35.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// below widget modify as per add unit type add in all list of data.
  /// also add unit conversion to display data (exp. Distance in KM and Miles, etc.)
  Widget? listItem(HealthKitOrGoogleFitModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: widget.typeName == Constants.healthKitSleep
                ? Body2Text(
                    text: '${DateUtil().getSleepValue(double.tryParse(model.value.toString()))}')
                : Body2Text(
                    text: widget.typeName == Constants.healthKitTemperature
                        ? widget.unit == ' °F'
                            ? (((model.value!) * 1.8) + 32).toStringAsFixed(1) + (widget.unit!)
                            : model.value!.toStringAsFixed(1) + (widget.unit!)
                        : widget.typeName == Constants.healthKitWeight
                            ? widget.unit == ' lb'
                                ? ((model.value!) / 0.45359237).toStringAsFixed(2) + (widget.unit!)
                                : model.value!.toStringAsFixed(2) + (widget.unit!)
                            : widget.typeName == Constants.healthKitDistance
                                ? widget.unit == ' mile'
                                    ? ((model.value!) * 0.6214).toStringAsFixed(3) + (widget.unit!)
                                    : model.value!.toStringAsFixed(3) + (widget.unit!)
                                : widget.typeName == Constants.healthKitBloodGlucose
                                    ? widget.unit == ' mmol/l'
                                        ? ((model.value!) / 18).toStringAsFixed(1) + (widget.unit!)
                                        : model.value!.toStringAsFixed(1) + (widget.unit!)
                                    : widget.typeName == Constants.healthKitActiveCalories ||
                                            widget.typeName == Constants.healthKitRestingCalories
                                        ? model.value!.toStringAsFixed(2) + (widget.unit!)
                                        : model.value!.toInt().toString(),
                    align: TextAlign.start,
                  ),
          ),
          Expanded(
            child: Body2Text(
              text: DateFormat('dd-MM-yyyy HH:mm'
                      '')
                  .format(model.startTime ?? DateTime.now()),
              align: TextAlign.center,
              fontSize: 10.0,
            ),
          ),
          widget.typeName == 'BloodGlucose'
              ? Container()
              : Expanded(
                  child: Body2Text(
                    text: DateFormat('dd-MM-yyyy HH:mm').format(model.endTime ?? DateTime.now()),
                    align: TextAlign.right,
                    fontSize: 10.0,
                  ),
                ),
        ],
      ),
    );
  }
}
