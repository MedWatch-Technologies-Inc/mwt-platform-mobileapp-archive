import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/get_hr_data_response.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_month_data_provider.dart';
import 'package:health_gauge/screens/history/history_item_tile.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/screens/history/model/history_graph_model.dart';
import 'package:health_gauge/screens/history/model/history_tile_model.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/keep_alive_future_builder.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../week_and_month_history_data.dart';
import 'heart_rate_list_item.dart';

class HeartRateMonthTab extends StatefulWidget {
  const HeartRateMonthTab({Key? key}) : super(key: key);

  @override
  _HeartRateMonthTabState createState() => _HeartRateMonthTabState();
}

class _HeartRateMonthTabState extends State<HeartRateMonthTab>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var provider =
          Provider.of<HeartRateMonthDataProvider>(context, listen: false);
      provider.getHistoryData(context);
    });
    //onPageEnd();
    Map<String, dynamic> mp = {};
    mp.values.toList();

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
    return Consumer<HeartRateMonthDataProvider>(
      builder: (BuildContext context, HeartRateMonthDataProvider provider,
          Widget? child) {
        var list = distinctList(provider.modelList);
        return Stack(
          children: [
            ListView.separated(
              itemCount: provider.monthWeekDataList.length,
              itemBuilder: (ctx, index) {
                var model = provider.monthWeekDataList.elementAt(index);
                return KeepAliveFutureBuilder(
                  future: model.initializeData(),
                  builder: (context, snapshot) {
                    var list = model.distinctList(model.data);
                    var key = Key(index.toString());
                    return Container(
                      //Theme(
                      // data: ThemeData()
                      //     .copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 13.w, right: 13.w, top: 13.h, bottom: 8.h),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                            borderRadius: BorderRadius.circular(10.h),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#D1D9E6')
                                        .withOpacity(0.1)
                                    : Colors.white,
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: Offset(-4, -4),
                              ),
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black.withOpacity(0.75)
                                    : HexColor.fromHex('#9F2DBC')
                                        .withOpacity(0.15),
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: Offset(4, 4),
                              ),
                            ]),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(10.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6')
                                          .withOpacity(0.1)
                                      : Colors.white,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(-5, -5),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black.withOpacity(0.75)
                                      : HexColor.fromHex('#9F2DBC')
                                          .withOpacity(0.15),
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(5, 5),
                                ),
                              ]),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                borderRadius: BorderRadius.circular(10.h),
                                gradient: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            HexColor.fromHex('#CC0A00')
                                                .withOpacity(0.15),
                                            HexColor.fromHex('#9F2DBC')
                                                .withOpacity(0.15),
                                          ])
                                    : LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            HexColor.fromHex('#FF9E99')
                                                .withOpacity(0.1),
                                            HexColor.fromHex('#9F2DBC')
                                                .withOpacity(0.023),
                                          ])),
                            child: ExpansionTile(
                              // collapsedTextColor: Colors.black,
                              // textColor: Colors.black,
                              iconColor: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#646869') ,
                              key: key,
                              title: Text(
                                '${DateFormat('yyyy-MM-dd').format(model.startDate)} to ${DateFormat('yyyy-MM-dd').format(model.endDate)}',
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#646869')
                                ),
                              ),
                              children: List.generate(
                                  model.endDate
                                          .difference(model.startDate)
                                          .inDays +
                                      1, (index) {
                                var dt =
                                    model.startDate.add(Duration(days: index));
                                return HistoryItemTile(
                                  isWeek: true,
                                  data: HistoryTileModel(
                                    historyItemType:
                                    HistoryItemType.HeartRate,
                                    dateTime: dt,
                                    subTitle: Strings().restingString,
                                    avgRate: model.findAverage(list, dt),
                                    graphWidget: !(provider.isLoading) &&
                                        (model.data.isNotEmpty) &&
                                        (model.graphItemDataList
                                            .isNotEmpty) &&
                                        (model.graphTypeList
                                            .isNotEmpty) &&
                                        (model.selectedGraphTypeList
                                            .isNotEmpty) &&
                                        (model.graphDataLineSeries
                                            .isNotEmpty)
                                        ? HistoryGraphModel(
                                      // graphList: model
                                      //     .getSelectedGraphTypeList(),
                                      graphList:
                                      model.selectedGraphTypeList,
                                      startDate: dt,
                                      context: ctx,
                                      endDate:
                                      dt.add(Duration(days: 1)),
                                      graphTab: GraphTab.day,
                                      isNormalization: false,
                                      lineChartSeries:
                                      model.getGraphLineSeries(
                                          dt,
                                          dt.add(
                                              Duration(days: 1))),
                                      showXGridLines: true,
                                    )
                                        : null,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Container();
                // return Divider(
                //   height: 5.h,
                //   indent: 8.0.w,
                //   endIndent: 8.0.w,
                //   color: Colors.grey,
                // );
              },
            ),
            Visibility(
              visible: provider.isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Visibility(
              visible:
                  !(provider.isLoading) && (provider.monthWeekDataList.isEmpty),
              child: Center(
                child: Center(
                  child: Text(StringLocalization.of(context)
                      .getText(StringLocalization.noDataFound)),
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
                  return Container(
                    margin: EdgeInsets.only(
                        left: 13.w,
                        right: 13.w,
                        top: 16.h,
                        bottom: index == list.length - 1 ? 16.h : 0.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                        borderRadius: BorderRadius.circular(10.h),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(-4, -4),
                          ),
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.black.withOpacity(0.75)
                                : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(4, 4),
                          ),
                        ]),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                borderRadius: BorderRadius.circular(10.h),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#D1D9E6')
                                            .withOpacity(0.1)
                                        : Colors.white,
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(-5, -5),
                                  ),
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black.withOpacity(0.75)
                                        : HexColor.fromHex('#9F2DBC')
                                            .withOpacity(0.15),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(5, 5),
                                  ),
                                ]),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(10.h),
                                  gradient: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                              HexColor.fromHex('#CC0A00')
                                                  .withOpacity(0.15),
                                              HexColor.fromHex('#9F2DBC')
                                                  .withOpacity(0.15),
                                            ])
                                      : LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                              HexColor.fromHex('#FF9E99')
                                                  .withOpacity(0.1),
                                              HexColor.fromHex('#9F2DBC')
                                                  .withOpacity(0.023),
                                            ])),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: Body1Text(
                                        text: DateFormat(DateUtil.MMMddyyyy)
                                            .format(DateTime.parse(list[index]
                                                    [0]
                                                .date
                                                .toString())),
                                        fontSize: 16.sp,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('384341'),
                                        fontWeight: FontWeight.bold,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 14.w),
                                    child: Image.asset(
                                      provider.showDetails &&
                                              provider.currentListIndex == index
                                          ? 'asset/up_icon_small.png'
                                          : 'asset/down_icon_small.png',
                                      height: 26.h,
                                      width: 26.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            if (provider.currentListIndex != index ||
                                (provider.currentListIndex == index &&
                                    !provider.showDetails)) {
                              provider.showDetails = true;
                              provider.currentListIndex = index;
                            } else {
                              provider.showDetails = false;
                            }
                          },
                        ),
                        provider.showDetails &&
                                provider.currentListIndex == index
                            ? SizedBox(
                                height: 8.h,
                              )
                            : Container(),
                        provider.showDetails &&
                                provider.currentListIndex == index
                            ? ListView.builder(
                                controller: scrollController,
                                itemCount: list[index].length,
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int innerIndex) {
                                  return HeartRateListItem(
                                    model: list[index][innerIndex],
                                  );
                                })
                            : Container()
                      ],
                    ),
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
            Provider.of<HeartRateMonthDataProvider>(context, listen: false);
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

  List<List<HrDataModel>> distinctList(List<HrDataModel> dataList) {
    assert(dataList != null);
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
    var list = <List<HrDataModel>>[];
    try {
      list = WeekAndMonthHistoryData(distinctList: distinctList).getHRData();
    } catch (e) {
      LoggingService()
          .printLog(tag: 'hr history screen', message: e.toString());
    }
    return list;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
