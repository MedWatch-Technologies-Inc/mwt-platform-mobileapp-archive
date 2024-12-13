import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_day_data_provider.dart';
import 'package:health_gauge/screens/history/history_item_details.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../repository/heart_rate_monitor/model/get_hr_data_response.dart';
import '../../../ui/graph_screen/graph_item_data.dart';

class HeartRateDayTab extends StatefulWidget {
  const HeartRateDayTab({Key? key}) : super(key: key);

  @override
  _HeartRateDayTabState createState() => _HeartRateDayTabState();
}

class _HeartRateDayTabState extends State<HeartRateDayTab>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  List<GraphItemData> temphrList = [];
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var provider =
          Provider.of<HeartRateDayDataProvider>(context, listen: false);
      provider.getHistoryData(context);

      temphrList = provider.hrList;
      temphrList.removeWhere((element) =>
          element.label != "approxHr" || element.label != "HeartRate");
    });
    //onPageEnd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //   context,
    //   width: Constants.staticWidth,
    //   height: Constants.staticHeight,
    //   allowFontScaling: true,
    // );

    return Consumer<HeartRateDayDataProvider>(
      builder: (BuildContext context, HeartRateDayDataProvider provider,
          Widget? child) {
        var list = distinctList(provider.modelList);
        // dateTime = list.isNotEmpty ? getDate(list[0].date) : DateTime.now();

        return Stack(
          children: [
            if (!(provider.isLoading) &&
                // (provider.modelList.isNotEmpty) &&
                // (temphrList.isNotEmpty) &&
                provider.hrListNo.isNotEmpty &&
                (provider.graphTypeList.isNotEmpty) &&
                (provider.selectedGraphTypeList.isNotEmpty) &&
                (provider.hrLineSeries.isNotEmpty))
              HistoryItemDetails(
                chartData: provider.hrLineSeries,
                historyItemType: HistoryItemType.HeartRate,
                chartDatas: temphrList,
                lowestRestingHeartRate: provider.findLowestHeartRate(),
                graphWidget: SfCartesianChart(
                  series: [
                    ...List.generate(provider.hrLineSeries.length, (index) {
                      return LineSeries<GraphItemData, double>(
                        dataSource: provider.hrLineSeries[index].data
                            .where((element) => element.yValue > 0)
                            .toList(),
                        xValueMapper: (GraphItemData data, _) => data.xValue,
                        yValueMapper: (GraphItemData data, _) => data.yValue,
                      );
                    })
                    // Renders spline chart

                    // Renders spline chart
                  ],
                  palette: [
                    ...List.generate(
                        provider.hrLineSeries.length,
                        (index) => provider.hrLineSeries[index].data.isEmpty
                            ? Colors.white
                            : HexColor.fromHex(provider
                                .hrLineSeries[index].data.first.colorCode
                                .toString()))
                  ],
                  primaryXAxis: NumericAxis(
                      decimalPlaces: 0, minimum: 0, maximum: 24, interval: 4),
                  primaryYAxis: NumericAxis(minimum: 0),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true, // Enable pinch zooming
                    // enableDoubleTapZooming: false,
                    enablePanning: true, // Enable double tap zooming
                    zoomMode: ZoomMode.x,
                    maximumZoomLevel: 0.15,

                    // Enable zooming on the x-axis
                  ),
                ),

                // LineGraph(
                //   graphList: provider.selectedGraphTypeList,
                //   startDate: provider.startDate,
                //   context: context,
                //   endDate: provider.endDate,
                //   graphTab: GraphTab.day,
                //   isNormalization: false,
                //   lineChartSeries: provider.hrLineSeries,
                //   showXGridLines: true,
                // ).getLineGraph(),
                avgRate: provider.findAvgHeartRate(),
              ),
            // ListView.builder(
            //   controller: scrollController,
            //   itemCount: list.length + 1,
            //   shrinkWrap: true,
            //   itemBuilder: (BuildContext context, int index) {
            //     if (index != list.length) {
            //       return HeartRateItemTile(
            //         data: list[index],
            //         heartRate: 68,
            //         unit: 'bpm',
            //         title: 'Resting',
            //         graph: null,
            //         dateTime: getDate(list[index].date),
            //       );
            //       // return HeartRateListItem(
            //       //   model: list.elementAt(index),
            //       // );
            //     }
            //
            //     return Visibility(
            //       // visible: false,
            //       visible: !(provider.isLoading) && provider.isPageLoading,
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(vertical: 20.h),
            //         child: Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            Visibility(
              visible: provider.isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Visibility(
              visible: !(provider.isLoading) && (provider.hrListNo.isEmpty),
              child: Center(
                child: Center(
                  child: Text(StringLocalization.of(context)
                      .getText(StringLocalization.noDataFound)),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void onPageEnd() {
    try {
      scrollController.addListener(() {
        var endPosition = (scrollController.position.maxScrollExtent - 200);
        var scrollPosition = scrollController.position.pixels;

        var provider =
            Provider.of<HeartRateDayDataProvider>(context, listen: false);
        var load = !(provider.isPageLoading) &&
            !(provider.isLoading) &&
            provider.modelList.isNotEmpty;
        if (load && scrollPosition >= endPosition) {
          provider.isPageLoading = true;
          provider.getHistoryData(context);
        }
      });
    } catch (e) {
      print('Exception ar onPageEnd $e');
    }
  }

  List<HrDataModel> distinctList(List<HrDataModel> dataList) {
    var distinctList = <HrDataModel>[];
    try {
      dataList.removeWhere((element) {
        if (element.hr != null && element.hr == 0) {
          return true;
        }
        return false;
      });
    } catch (e) {
      LoggingService().printLog(message: e.toString());
    }
    try {
      dataList.forEach((HrDataModel element) {
        if (element.date != null) {
          String date = DateFormat(DateUtil.yyyyMMddhhmm)
              .format(DateTime.parse(element.date!));
          bool isExist = distinctList.any((e) {
            if (e.date != null) {
              String dateE = DateFormat(DateUtil.yyyyMMddhhmm)
                  .format(DateTime.parse(e.date!));
              return date == dateE;
            }
            return false;
          });
          if (!isExist) {
            distinctList.add(HrDataModel.clone(element));
          }
        }
      });
    } catch (e) {
      print('Exception at distinct list in temp $e');
    }
    return distinctList;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
