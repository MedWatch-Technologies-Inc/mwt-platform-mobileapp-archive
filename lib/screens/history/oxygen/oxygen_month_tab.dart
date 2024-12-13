import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/screens/history/history_item_tile.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/screens/history/model/history_graph_model.dart';
import 'package:health_gauge/screens/history/model/history_tile_model.dart';
import 'package:health_gauge/screens/history/oxygen/providers/oxygen_month_data_provider.dart';
import 'package:health_gauge/screens/history/week_and_month_history_data.dart';
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

import 'oxygen_list_item.dart';

class OxygenMonthTab extends StatefulWidget {
  const OxygenMonthTab({Key? key}) : super(key: key);

  @override
  _OxygenMonthTabState createState() => _OxygenMonthTabState();
}

class _OxygenMonthTabState extends State<OxygenMonthTab> with AutomaticKeepAliveClientMixin{
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var provider =
          Provider.of<OxygenMonthDataProvider>(context, listen: false);
      provider.getHistoryData(context);
    });
    //onPageEnd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OxygenMonthDataProvider>(
      builder: (BuildContext context, OxygenMonthDataProvider provider,
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
                    return Theme(
                      data: ThemeData()
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          '${DateFormat('yyyy-MM-dd').format(model.startDate)} to ${DateFormat('yyyy-MM-dd').format(model.endDate)}',
                        ),
                        children: List.generate(
                            model.endDate.difference(model.startDate).inDays +
                                1, (index) {
                          return Column(
                            children: [
                              HistoryItemTile(
                                isWeek: false,
                                data: HistoryTileModel(
                                  historyItemType: HistoryItemType.Oxygen,
                                  dateTime: model.startDate
                                      .add(Duration(days: index)),
                                  subTitle: Strings().restingString,
                                  avgRate: model.findAverage(
                                      list,
                                      model.startDate
                                          .add(Duration(days: index))),
                                  graphWidget: !(provider.isLoading) &&
                                          (model.data.isNotEmpty) &&
                                          (model
                                              .graphItemDataList.isNotEmpty) &&
                                          (model.graphTypeList.isNotEmpty) &&
                                          (model.selectedGraphTypeList
                                              .isNotEmpty) &&
                                          (model.graphDataLineSeries.isNotEmpty)
                                      ? HistoryGraphModel(
                                          graphList:
                                              model.getSelectedGraphTypeList(),
                                          startDate: model.startDate
                                              .add(Duration(days: index)),
                                          context: ctx,
                                          endDate: model.startDate
                                              .add(Duration(days: index + 1)),
                                          graphTab: GraphTab.day,
                                          isNormalization: false,
                                          lineChartSeries:
                                              model.getGraphLineSeries(
                                                  model.startDate.add(
                                                      Duration(days: index)),
                                                  model.startDate.add(Duration(
                                                      days: index + 1))),
                                          showXGridLines: true,
                                        )
                                      : null,
                                ),
                              ),
                              if (index <
                                  model.endDate
                                      .difference(model.startDate)
                                      .inDays)
                                Divider(
                                  height: 5.h,
                                  indent: 8.0.w,
                                  endIndent: 8.0.w,
                                  color: Colors.grey,
                                )
                            ],
                          );
                        }),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 5.h,
                  indent: 8.0.w,
                  endIndent: 8.0.w,
                  color: Colors.grey,
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
              visible: !(provider.isLoading) && (provider.monthWeekDataList.isEmpty),
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
                                  return OxygenListItem(
                                    tempModel: list[index][innerIndex],
                                  );
                                })
                            : Container()
                      ],
                    ),
                  );
                }
                if (!(provider.isPageLoading) && list.length < 7) {
                  if (!(provider.isAllFetched)) {
                    provider.isPageLoading = true;
                    provider.getHistoryData(context);
                  }
                }
                return Visibility(
                  visible: false,
                  //visible: provider?.isPageLoading,
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
            Provider.of<OxygenMonthDataProvider>(context, listen: false);
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

  List<List<TempModel>> distinctList(var dataList) {
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
    var list = <List<TempModel>>[];
    try {
      list = WeekAndMonthHistoryData(distinctList: distinctList)
          .getOxygenAndTempData();
    } catch (e) {
      LoggingService()
          .printLog(tag: 'oxygen history screen', message: e.toString());
    }
    return list;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
