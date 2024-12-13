import 'package:flutter/material.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/screens/history/history_item_details.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_day_data_provider.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OxygenDayTab extends StatefulWidget {
  const OxygenDayTab({Key? key}) : super(key: key);

  @override
  _OxygenDayTabState createState() => _OxygenDayTabState();
}

class _OxygenDayTabState extends State<OxygenDayTab> with AutomaticKeepAliveClientMixin{
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var provider = Provider.of<OxygenDayDataProvider>(context, listen: false);
      provider.getHistoryData(context);
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
    return Consumer<OxygenDayDataProvider>(
      builder: (BuildContext context, OxygenDayDataProvider provider,
          Widget? child) {
        return Stack(
          children: [
            if (!(provider.isLoading) &&
                (provider.modelList.isNotEmpty) &&
                (provider.oxygenList.isNotEmpty) &&
                (provider.graphTypeList.isNotEmpty) &&
                (provider.selectedGraphTypeList.isNotEmpty) &&
                (provider.oxygenLineSeries.isNotEmpty))
              HistoryItemDetails(
                chartData:  provider.oxygenLineSeries,
                historyItemType: HistoryItemType.Oxygen,
                chartDatas: [],
                lowestRestingHeartRate: 0,
                graphWidget: LineGraph(
                  graphList: provider.selectedGraphTypeList,
                  startDate: provider.startDate,
                  context: context,
                  endDate: provider.endDate,
                  graphTab: GraphTab.day,
                  isNormalization: false,
                  lineChartSeries: provider.oxygenLineSeries,
                  showXGridLines: true,
                ).getLineGraph(minPointSize: true),
                avgRate: provider.findAvgOxygenRate(),
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
              visible: !(provider.isLoading) && (provider.modelList.isEmpty),
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
            Provider.of<OxygenDayDataProvider>(context, listen: false);
        var load = !(provider.isPageLoading) && !(provider.isLoading);
        if (load && scrollPosition >= endPosition) {
          provider.isPageLoading = true;
          // provider?.getHistoryData(context);
        }
      });
    } catch (e) {
      print('Exception ar onPageEnd $e');
    }
  }

  List<TempModel> distinctList(List<TempModel> dataList) {
    var distinctList = <TempModel>[];
    try {
      dataList.removeWhere((element) {
        if (element.oxygen != null && element.oxygen == 0) {
          return true;
        }
        return false;
      });
    } catch (e) {
      LoggingService().printLog(message: e.toString());
    }

    try {
      dataList.forEach((TempModel element) {
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
            distinctList.add(TempModel.clone(element));
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
