import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/OxygenHistory/HelperWidgets/o_history_appbar.dart';
import 'package:health_gauge/screens/OxygenHistory/HelperWidgets/ot_graph_widget.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_listing.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OTDetailPage extends StatefulWidget {
  OTDetailPage({super.key});

  @override
  State<OTDetailPage> createState() => _OTDetailPageState();
}

class _OTDetailPageState extends State<OTDetailPage> {
  final OTHistoryHelper _helper = OTHistoryHelper();

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
            builder: (BuildContext context, List<OTHistoryModel> value, Widget? child) {
              return OHistoryAppbar(
                showAction: _helper.dayData.value.isNotEmpty,
                title: _helper.appbarTitle,
                onPressed: () {
                  Constants.navigatePush(OTListing(), context);
                },
              );
            },
          ),
        ),
        body: SmartRefresher(
          controller: _helper.weekRefreshController,
          onRefresh: _helper.fetchDay,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
            physics: BouncingScrollPhysics(),
            child: ValueListenableBuilder(
                valueListenable: _helper.dayData,
                builder: (BuildContext context, List<OTHistoryModel> value, Widget? child) {
                  return Column(
                    children: [
                      OTGraphWidget(
                        list: value,
                        isGraphPage: false,
                        type: 'spo2',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'asset/oxygen.png',
                              height: 24.h,
                              width: 24.h,
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
                                          text: 'Average SPO2',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        if (value.isEmpty) ...[
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                        Rich1Text(
                                          text1: value.isNotEmpty
                                              ? _helper.avgOxygen.toStringAsFixed(0)
                                              : 'No Data',
                                          text2: value.isNotEmpty ? ' %' : '',
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
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
