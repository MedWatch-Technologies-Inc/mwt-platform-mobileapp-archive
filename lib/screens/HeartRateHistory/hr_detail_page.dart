import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/hr_history_appbar.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../MeasurementHistory/m_history_helper.dart';

class HRDetailPage extends StatefulWidget {
  HRDetailPage({super.key});

  @override
  State<HRDetailPage> createState() => _HRDetailPageState();
}

class _HRDetailPageState extends State<HRDetailPage> {
  final HRHelper _helper = HRHelper();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      var isSynced = _helper.refreshMap[_helper.dayFromTime.toString()] ?? false;
      if (!isSynced) {
        _helper.weekRefreshController.requestRefresh();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ValueListenableBuilder(
              valueListenable: _helper.dayData,
              builder: (BuildContext context, List<SyncHRModel> value, Widget? child) {
                return HRHistoryAppbar(
                  showAction: _helper.dayData.value.isNotEmpty,
                  title: _helper.appbarTitle,
                );
              }),
        ),
        body: SmartRefresher(
          controller: _helper.weekRefreshController,
          onRefresh: _helper.fetchDay,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
            physics: BouncingScrollPhysics(),
            child: ValueListenableBuilder(
                valueListenable: _helper.dayData,
                builder: (BuildContext context, List<SyncHRModel> value, Widget? child) {
                  return Column(
                    children: [
                      HeartGraphWidget(
                        list: value,
                        zoneLines: _helper.zoneLines,
                        isGraphPage: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Body1Text(
                                          text: 'Resting Heart Rate',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        if (value.isEmpty) ...[
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                        Rich1Text(
                                          text1: value.isNotEmpty
                                              ? _helper.avgRestingHR.toStringAsFixed(0)
                                              : 'No Data',
                                          text2: value.isNotEmpty ? ' bpm' : '',
                                          fontSize1: value.isNotEmpty ? 30.sp : 15.sp,
                                          fontSize2: 15.sp,
                                          color1: Theme.of(context).textTheme.bodyText1!.color,
                                          color2: Theme.of(context).textTheme.bodyText1!.color,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Body1Text(
                                          text: 'Lowest Resting Heart Rate',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        if (value.isEmpty) ...[
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                        Rich1Text(
                                          text1: value.isNotEmpty
                                              ? _helper.lowestRestingHR.toStringAsFixed(0)
                                              : 'No Data',
                                          text2: value.isNotEmpty ? ' bpm' : '',
                                          fontSize1: value.isNotEmpty ? 30.sp : 15.sp,
                                          fontSize2: 15.sp,
                                          color1: Theme.of(context).textTheme.bodyText1!.color,
                                          color2: Theme.of(context).textTheme.bodyText1!.color,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: MHistoryHelper().getDayLastMHistory(
                          startTimestamp: _helper.dayFromTime,
                          endTimestamp: _helper.dayToTime,
                        ),
                        builder: (BuildContext context, AsyncSnapshot<double> snapshotHRV) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'asset/strees_55.png',
                                  height: 24,
                                  width: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Body1Text(
                                              text: 'HR Variability',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            Rich1Text(
                                              text1: snapshotHRV.data!.toInt().toString(),
                                              text2: '  ms',
                                              fontSize1: 30.sp,
                                              fontSize2: 15.sp,
                                              color1: Theme.of(context).textTheme.bodyText1!.color,
                                              color2: Theme.of(context).textTheme.bodyText1!.color,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
