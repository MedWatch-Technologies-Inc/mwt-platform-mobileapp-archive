import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../ui/graph_screen/graph_item_data.dart';
import 'heart_rate_item_details.dart';
import 'model/heart_rate_tile_model.dart';

class HeartRateItemTile extends StatelessWidget {
  HeartRateItemTile({
    required this.data,
    Key? key,
  }) : super(key: key);

  final HeartRateTileModel data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.avgHeartRate != null
          ? () {
              Constants.navigatePush(
                HeartRateItemDetails(
                  avgHeartRate: data.avgHeartRate,
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
                                (index) => data.graphWidget!
                                        .lineChartSeries[index].data.isEmpty
                                    ? Colors.white
                                    : HexColor.fromHex(data
                                        .graphWidget!
                                        .lineChartSeries[index]
                                        .data
                                        .first
                                        .colorCode
                                        .toString()))
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
                              enablePanning: true, // Enable double tap zooming
                              zoomMode: ZoomMode.x,
                              maximumZoomLevel: 0.15
                              // Enable zooming on the x-axis
                              ),
                        )

                      // LineGraph(
                      //   graphList: data.graphWidget!.graphList,
                      //   startDate: data.graphWidget!.startDate,
                      //   context: data.graphWidget!.context,
                      //   endDate: data.graphWidget!.endDate,
                      //   graphTab: data.graphWidget!.graphTab,
                      //   isNormalization: data.graphWidget!.isNormalization,
                      //   lineChartSeries: data.graphWidget!.lineChartSeries,
                      //   showXGridLines: data.graphWidget!.showXGridLines,
                      // ).getLineGraph()
                      : SizedBox.shrink(),
                  pageHeading: getDateHeading(data.dateTime),
                ),
                context,
              );
            }
          : null,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Body1Text(
                    text: data.dateTime != null
                        ? '${data.dateTime!.month}-${data.dateTime!.day}'
                        : 'N/A',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex('#646869'),
                    align: TextAlign.center,
                    fontSize: 15.sp,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: data.avgHeartRate != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Rich1Text(
                              text1: data.avgHeartRate.toString(),
                              text2:
                                  data.unit != null ? ' ${data.unit}' : 'N/A',
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
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Body1Text(
                                  text: data.subTitle ?? 'N/A',
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#646869'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              if (data.graphWidget != null)
                                // Container(
                                //   width: 233.w,
                                //   child: SfCartesianChart(
                                //     series: [
                                //       ...List.generate( data.graphWidget!.lineChartSeries.length, (index) {
                                //         return LineSeries<GraphItemData, double>(
                                //           dataSource:  data.graphWidget!.lineChartSeries[index].data
                                //               .where((element) => element.yValue > 0)
                                //               .toList(),
                                //           xValueMapper: (GraphItemData data, _) => data.xValue,
                                //           yValueMapper: (GraphItemData data, _) => data.yValue,
                                //         );
                                //       })
                                //       // Renders spline chart
                                //
                                //       // Renders spline chart
                                //     ],
                                //     palette: [
                                //       ...List.generate(
                                //           data.graphWidget!.lineChartSeries.length,
                                //               (index) => data.graphWidget!.lineChartSeries[index].data.isEmpty
                                //               ? Colors.white
                                //               : HexColor.fromHex(data.graphWidget!.lineChartSeries[index].data.first.colorCode
                                //               .toString()))
                                //     ],
                                //     primaryXAxis: NumericAxis(
                                //         decimalPlaces: 0, minimum: 0, maximum: 24, interval: 4),
                                //     primaryYAxis: NumericAxis(minimum: 0),
                                //     zoomPanBehavior: ZoomPanBehavior(
                                //       enablePinching: true, // Enable pinch zooming
                                //       // enableDoubleTapZooming: false,
                                //       enablePanning: true, // Enable double tap zooming
                                //       zoomMode: ZoomMode.x,
                                //       maximumZoomLevel: 0.15,
                                //
                                //       // Enable zooming on the x-axis
                                //     ),
                                //   )

                                LineGraph(
                                  graphList: data.graphWidget!.graphList,
                                  startDate: data.graphWidget!.startDate,
                                  context: data.graphWidget!.context,
                                  endDate: data.graphWidget!.endDate,
                                  graphTab: data.graphWidget!.graphTab,
                                  isNormalization:
                                      data.graphWidget!.isNormalization,
                                  lineChartSeries:
                                      data.graphWidget!.lineChartSeries,
                                  showXGridLines: false,
                                  showYGridLines: false,
                                ).getLineGraph(),
                              // )
                            ],
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Body1Text(
                        text: 'N/A',
                        color: HexColor.fromHex('#646869'),
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
    );
  }

  String getDateHeading(DateTime? date) {
    if (date != null) {
      return DateFormat(DateUtil.EEEEMMMdd).format(date);
    }
    return 'N/A';
  }
}
