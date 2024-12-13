import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/history/history_item_details.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../ui/graph_screen/graph_item_data.dart';
import 'model/history_tile_model.dart';

class HistoryItemTile extends StatelessWidget {
  HistoryItemTile({
    required this.data,
    Key? key,
    required this.isWeek,
  }) : super(key: key);

  final HistoryTileModel data;
  final bool isWeek;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: data.avgRate != null
            ? () {
                Constants.navigatePush(
                  HistoryItemDetails(
                    chartData: data.graphWidget!.lineChartSeries ?? [],
                    historyItemType: data.historyItemType,
                    avgRate: data.avgRate,
                    chartDatas: [],
                    lowestRestingHeartRate: 0,
                    // lowestRestingHeartRate: data.,
                    graphWidget: data.graphWidget != null
                        ? SfCartesianChart(
                            series: [
                              ...List.generate(
                                  data.graphWidget!.lineChartSeries.length,
                                  (index) {
                                // log(provider.hrLineSeries[index].data
                                //     .map((e) =>
                                //         "dsdsdsdsd  y ${e.yValue} :  ${e.xValue} \n")
                                //     .toList()
                                //     .toString());
                                return LineSeries<GraphItemData, double>(
                                  dataSource: data
                                      .graphWidget!.lineChartSeries[index].data
                                      .where((element) => element.yValue > 0)
                                      .toList(),
                                  xValueMapper: (GraphItemData data, _) =>
                                      data.xValue,
                                  yValueMapper: (GraphItemData data, _) =>
                                      data.yValue,
                                );
                              })
                              // Renders spline chart

                              // Renders spline chart
                            ],
                            palette: [
                              ...List.generate(
                                  data.graphWidget!.lineChartSeries.length,
                                  (index) => data
                                              .graphWidget!
                                              .lineChartSeries[index]
                                              .data
                                              .isEmpty ||
                                          data
                                              .graphWidget!
                                              .lineChartSeries[index]
                                              .data
                                              .isEmpty
                                      ? Colors.white
                                      : HexColor.fromHex(data
                                              .graphWidget!
                                              .lineChartSeries[index]
                                              .data
                                              .first
                                              .colorCode ??
                                          "#ff9e99"))
                            ],
                            primaryXAxis: NumericAxis(
                                decimalPlaces: 0,
                                minimum: 0,
                                maximum: 24,
                                interval: 4),
                            primaryYAxis: NumericAxis(minimum: 0),
                            zoomPanBehavior: ZoomPanBehavior(
                                enablePinching: true, // Enable pinch zooming
                                // enableDoubleTapZooming: false,
                                enablePanning:
                                    true, // Enable double tap zooming
                                zoomMode: ZoomMode.x,
                                maximumZoomLevel: 0.15
                                // Enable zooming on the x-axis
                                ),
                          )

                        // LineGraph(
                        //         graphList: data.graphWidget!.graphList,
                        //         startDate: data.graphWidget!.startDate,
                        //         context: data.graphWidget!.context,
                        //         endDate: data.graphWidget!.endDate,
                        //         graphTab: data.graphWidget!.graphTab,
                        //         isNormalization: data.graphWidget!.isNormalization,
                        //         lineChartSeries: data.graphWidget!.lineChartSeries,
                        //         showXGridLines: data.graphWidget!.showXGridLines,
                        //       ).getLineGraph()
                        : SizedBox.shrink(),
                    pageHeading: getDateHeading(data.dateTime),
                  ),
                  context,
                );
              }
            : null,
        child: Container(
          margin:
              EdgeInsets.only(left: 13.w, right: 13.w, top: 13.h, bottom: 8.h),
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(-4, -4),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(4, 4),
                ),
              ]),
          child: Container(
              padding: EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10.h),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(-5, -5),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.75)
                          : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(5, 5),
                    ),
                  ]),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10.h),
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                              HexColor.fromHex('#CC0A00').withOpacity(0.15),
                              HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                            ])
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                              HexColor.fromHex('#FF9E99').withOpacity(0.1),
                              HexColor.fromHex('#9F2DBC').withOpacity(0.023),
                            ]),
                ),
                child: SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.5,
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Body1Text(
                          text: data.dateTime != null
                              ? '${data.dateTime!.month}-${data.dateTime!.day}\n${data.dateTime!.year}'
                              : 'N/A',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('#646869'),
                          // HexColor.fromHex('#646869'),
                          align: TextAlign.center,
                          fontSize: 15.sp,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: data.avgRate != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Rich1Text(
                                        text1: data.avgValue(),
                                        text2: unitFromHistoryType(
                                            data.historyItemType),
                                        fontWeight1: FontWeight.bold,
                                        fontWeight2: FontWeight.bold,
                                        fontSize1: 25.sp,
                                        fontSize2: 15.sp,
                                        color1: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#00272C'),
                                        color2: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#00272C'),
                                      ),
                                      Body1Text(
                                        text: data.subTitle ?? 'N/A',
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#646869'),
                                      ),
                                    ],
                                  ),
                                  // Expanded(
                                  //   child: data.graphWidget != null
                                  //       ? Container(
                                  //           margin:
                                  //               EdgeInsets.only(left: 8, top: 4),
                                  //           decoration: BoxDecoration(
                                  //               border: Border(
                                  //                   left: BorderSide(
                                  //                       width: 0.5,
                                  //                       color: Colors.grey),
                                  //                   bottom: BorderSide(
                                  //                       width: 0.5,
                                  //                       color: Colors.grey))),
                                  //           child:  SfCartesianChart(
                                  //             series: [
                                  //               ...List.generate(data
                                  //                   .graphWidget!.lineChartSeries.length, (index) {
                                  //                 return LineSeries<GraphItemData, double>(
                                  //                   dataSource: data
                                  //                       .graphWidget!.lineChartSeries[index].data
                                  //                       .where((element) => element.yValue > 0)
                                  //                       .toList(),
                                  //                   xValueMapper: (GraphItemData data, _) => data.xValue,
                                  //                   yValueMapper: (GraphItemData data, _) => data.yValue,
                                  //                 );
                                  //               })
                                  //               // Renders spline chart
                                  //
                                  //               // Renders spline chart
                                  //             ],
                                  //             palette: [
                                  //               ...List.generate(
                                  //                   data
                                  //                       .graphWidget!.lineChartSeries.length,
                                  //                       (index) => data
                                  //                           .graphWidget!.lineChartSeries[index].data.isEmpty
                                  //                       ? Colors.white
                                  //                       : HexColor.fromHex(data
                                  //                           .graphWidget!.lineChartSeries[index].data.first.colorCode
                                  //                       .toString()))
                                  //             ],
                                  //             primaryXAxis: NumericAxis(
                                  //                 decimalPlaces: 0, minimum: 0, maximum: 24, interval: 4),
                                  //             primaryYAxis: NumericAxis(minimum: 0),
                                  //             zoomPanBehavior: ZoomPanBehavior(
                                  //               enablePinching: true, // Enable pinch zooming
                                  //               // enableDoubleTapZooming: false,
                                  //               enablePanning: true, // Enable double tap zooming
                                  //               zoomMode: ZoomMode.x,
                                  //               maximumZoomLevel: 0.15,
                                  //
                                  //               // Enable zooming on the x-axis
                                  //             ),
                                  //           ),
                                  //
                                  //
                                  //           // LineGraph(
                                  //           //   graphList:
                                  //           //       data.graphWidget!.graphList,
                                  //           //   startDate:
                                  //           //       data.graphWidget!.startDate,
                                  //           //   context: data.graphWidget!.context,
                                  //           //   endDate: data.graphWidget!.endDate,
                                  //           //   graphTab:
                                  //           //       data.graphWidget!.graphTab,
                                  //           //   isNormalization: data
                                  //           //       .graphWidget!.isNormalization,
                                  //           //   lineChartSeries: data
                                  //           //       .graphWidget!.lineChartSeries,
                                  //           //   showXGridLines: false,
                                  //           //   showYGridLines: false,
                                  //           // ).getLineGraph(),
                                  //         )
                                  //       : Container(),
                                  // )
                                ],
                              )
                            : Center(
                                child: Body1Text(
                                  text: 'N/A',
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#646869'),
                                ),
                              ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: (22 / 7) / 180 * 180.0,
                              child: Image.asset(
                                'asset/leftArrow.png',
                                width: 16,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }

  String getDateHeading(DateTime? date) {
    if (date != null) {
      return DateFormat(DateUtil.EEEEMMMdd).format(date);
    }
    return 'N/A';
  }
}
