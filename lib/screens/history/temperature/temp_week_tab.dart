import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/screens/history/history_item_tile.dart';
import 'package:health_gauge/screens/history/model/history_graph_model.dart';
import 'package:health_gauge/screens/history/model/history_tile_model.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_week_data_provider.dart';
import 'package:health_gauge/screens/history/temperature/temp_list_item.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../week_and_month_history_data.dart';

class TempWeekTab extends StatefulWidget {
  const TempWeekTab({Key? key}) : super(key: key);

  @override
  _TempWeekTabState createState() => _TempWeekTabState();
}

class _TempWeekTabState extends State<TempWeekTab>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var provider = Provider.of<TempWeekDataProvider>(context, listen: false);
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
    return Consumer<TempWeekDataProvider>(
      builder:
          (BuildContext context, TempWeekDataProvider provider, Widget? child) {
        var list = distinctList(provider.modelList);

        return Stack(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Divider(
                    height: 5.h,
                    color: Colors.grey,
                  ),
                );
              },
              controller: scrollController,
              itemCount: 7,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return HistoryItemTile(
                  isWeek: true,
                  data: HistoryTileModel(
                    historyItemType: HistoryItemType.Temperature,
                    dateTime: provider.startDate.add(Duration(days: index)),
                    subTitle: Strings().restingString,
                    avgRate: provider.findAvgTem(
                        list, provider.startDate.add(Duration(days: index))),
                    graphWidget: !(provider.isLoading) &&
                            (provider.modelList.isNotEmpty) &&
                            (provider.tempList.isNotEmpty) &&
                            (provider.graphTypeList.isNotEmpty) &&
                            (provider.selectedGraphTypeList.isNotEmpty) &&
                            (provider.tempLineSeries.isNotEmpty)
                        ? HistoryGraphModel(
                            graphList: provider.getSelectedGraphTypeList(),
                            startDate:
                                provider.startDate.add(Duration(days: index)),
                            context: context,
                            endDate: provider.startDate
                                .add(Duration(days: index + 1)),
                            graphTab: GraphTab.day,
                            isNormalization: false,
                            lineChartSeries: provider.getTempLineSeries(
                                provider.startDate.add(Duration(days: index)),
                                provider.startDate
                                    .add(Duration(days: index + 1))),
                            showXGridLines: true,
                          )
                        : null,
                  ),
                );
                /*
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
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 56.h,
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
                              padding: EdgeInsets.symmetric(vertical: 13.h),
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
                                      ])),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: Body1Text(
                                        text: DateFormat(DateUtil.MMMddyyyy)
                                            .format(DateTime.parse(list[index][0].date.toString())),
                                        fontSize: 16.sp,
                                        color: Theme.of(context).brightness == Brightness.dark
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
                                      provider.showDetails && provider.currentListIndex == index
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
                                (provider.currentListIndex == index && !provider.showDetails)) {
                              provider.showDetails = true;
                              provider.currentListIndex = index;
                            } else {
                              provider.showDetails = false;
                            }
                          },
                        ),
                        provider.showDetails && provider.currentListIndex == index
                            ? SizedBox(height: 8.h,): Container(),
                        provider.showDetails && provider.currentListIndex == index
                            ? ListView.builder(
                            controller: scrollController,
                            itemCount: list[index].length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int innerIndex) {
                              return HeartRateListItem(
                                model: list[index][innerIndex],
                              );
                            }) : Container()
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
                 */
              },
            ),
            Visibility(
              visible: provider.isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            // Visibility(
            //   visible: !(provider.isLoading ) &&
            //       (provider.modelList.isEmpty ),
            //   child: Center(
            //     child: Center(
            //       child: Text(StringLocalization.of(context)
            //           .getText(StringLocalization.noDataFound)),
            //     ),
            //   ),
            // )
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
                                  return TempListItem(
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
            Provider.of<TempWeekDataProvider>(context, listen: false);
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
        if (element.temperature != null &&
            (element.temperature == 0 || element.temperature < 0.5)) {
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
      LoggingService().printLog(
          tag: 'temperature history screen',
          message: 'combining all data for a single day in week tab view.');
    }
    return list;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
