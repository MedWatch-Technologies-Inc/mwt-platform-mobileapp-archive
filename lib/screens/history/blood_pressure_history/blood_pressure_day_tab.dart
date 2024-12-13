import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/screens/history/blood_pressure_history/providers/blood_pressure_day_data_provider.dart';
import 'package:health_gauge/screens/history/history_item_details.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'blood_pressure_list_item.dart';

class BloodPressureDayTab extends StatefulWidget {
  const BloodPressureDayTab({Key? key}) : super(key: key);

  @override
  _BloodPressureDayTabState createState() => _BloodPressureDayTabState();
}

class _BloodPressureDayTabState extends State<BloodPressureDayTab> with AutomaticKeepAliveClientMixin{
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var provider = Provider.of<BloodPressureDayDataProvider>(context, listen: false);
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
    return Consumer<BloodPressureDayDataProvider>(
      builder: (BuildContext context, BloodPressureDayDataProvider provider,
          Widget? child) {
        var list = distinctList(provider.modelList);
        return Stack(
          children: [
            if (!(provider.isLoading) &&
                (provider.modelList.isNotEmpty) &&
                (provider.bloodPressureList.isNotEmpty) &&
                (provider.graphTypeList.isNotEmpty) &&
                (provider.selectedGraphTypeList.isNotEmpty) &&
                (provider.bloodPressureLineSeries.isNotEmpty))
              HistoryItemDetails(
                chartData:  provider.bloodPressureLineSeries,
                historyItemType: HistoryItemType.BloodPressure,
                chartDatas: [],
                lowestRestingHeartRate: 0,
                graphWidget: LineGraph(
                  graphList: provider.selectedGraphTypeList,
                  startDate: provider.startDate,
                  context: context,
                  endDate: provider.endDate,
                  graphTab: GraphTab.day,
                  isNormalization: false,
                  lineChartSeries: provider.bloodPressureLineSeries,
                  showXGridLines: true,
                ).getLineGraph(),
                avgRate: provider.findAvgBloodPressure(),
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
              visible: provider.isLoading ,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Visibility(
              visible: !(provider.isLoading) && (provider.modelList.isEmpty),
              child: Center(
                child: Center(
                  child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound)),
                ),
              ),
            )
          ],
        );
        return Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              itemCount: list.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index != list.length) {
                  return BloodPressureListItem(
                    bpModel: list.elementAt(index),
                  );
                }
                return Visibility(
                  // visible: false,
                  visible: provider.isPageLoading,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
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
            Provider.of<BloodPressureDayDataProvider>(context, listen: false);
        var load = !(provider.isPageLoading) && !(provider.isLoading);
        if (load && scrollPosition >= endPosition) {
          provider.isPageLoading = true;
          provider.getHistoryData(context);
        }
      });
    } catch (e) {
      print('Exception ar onPageEnd $e');
    }
  }

  List<BPModel> distinctList(List<BPModel> dataList) {
    var distinctList = <BPModel>[];

    try {
      var format = DateFormat('yyyy-MM-dd hh:mm');
      for(var element in dataList) {
        if (element.date != null) {
          var date = format.format(DateTime.parse(element.date!));
          var isExist = distinctList.any((e) {
            if (e.date != null) {
              var dateE = format.format(DateTime.parse(e.date!));
              return date == dateE;
            }
            return false;
          });
          if (!isExist) {
            distinctList.add(BPModel.clone(element));
          }
          print('distinctList ${distinctList.length}');
        }
      }
    } catch (e) {
      print('Exception at distinct list in temp $e');
    }
    return distinctList;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
