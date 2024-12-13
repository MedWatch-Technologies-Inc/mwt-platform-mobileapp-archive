import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_event.dart';
import 'package:health_gauge/bloc/activity/activity_state.dart';
import 'package:health_gauge/resources/db/app_preferences_handler.dart';
import 'package:health_gauge/screens/map_screen/providers/history_list_provider.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';//todo

class ActivityHistory extends StatefulWidget {
  @override
  _ActivityHistoryState createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  ScrollController scrollController = ScrollController();
  ActivityBloc activityBloc = ActivityBloc();
  AppPreferencesHandler preferenceHandler = AppPreferencesHandler();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      var provider = Provider.of<HistoryListProvider>(context, listen: false);
      provider.isScreenLoad = true;
      provider.getHistoryData();
    });
    activityBloc.add(GetActivityDataEvent(userId: globalUser!.userId!));
    super.initState();
  }

  //this method is used when controller reach to the end of the page.
  void onEndOfPage() {
    if (scrollController.position.extentAfter < 100) {
      var provider = Provider.of<HistoryListProvider>(context, listen: false);
      if (!provider.isPageLoad && !provider.isScreenLoad) {
        provider.getHistoryData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex('#384341').withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                'asset/dark_leftArrow.png',
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              StringLocalization.of(context)
                  .getText(StringLocalization.activityHistory),
              style: TextStyle(
                  color: HexColor.fromHex('62CBC9'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: BlocListener<ActivityBloc, ActivityState>(
        listener: (BuildContext context, state) {},
        child: Container(),
      ),
      // body: Consumer<HistoryListProvider>(
      //   builder:
      //       (BuildContext? context, HistoryListProvider? value, Widget? child) {
      //     return Stack(
      //       children: [
      //         Visibility(
      //           visible: !(value!.isScreenLoad),
      //           child: RefreshIndicator(
      //             onRefresh: () {
      //               if (!value.isPageLoad && !value.isScreenLoad) {
      //                 value.isScreenLoad = true;
      //                 value.lstDocument = null;
      //                 value.getHistoryData();
      //               }
      //               return Future.value(false);
      //             },
      //             child: value.historyList.isEmpty
      //                 ? Center(
      //                   child: Text(stringLocalization
      //                       .getText(StringLocalization.noDataFound)),
      //                 )
      //                 : ListView(
      //                     controller: scrollController,
      //                     shrinkWrap: true,
      //                     physics: AlwaysScrollableScrollPhysics(),
      //                     children: [
      //                       Column(
      //                         mainAxisSize: MainAxisSize.min,
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         crossAxisAlignment: CrossAxisAlignment.stretch,
      //                         children: List.generate(
      //                           value.historyList.length,
      //                           (index) {
      //                             var model =
      //                                 value.historyList[index];
      //                             var endTime = '';
      //                             try {
      //                             } catch (e) {
      //                               print('Exception at parsing startTime $e');
      //                             }
      //                             try {
      //                               if (model.endTime == null) {
      //                                 endTime =
      //                                     DateTime.fromMillisecondsSinceEpoch(
      //                                             model.locationList!.last.time!
      //                                                 .toInt())
      //                                         .toUtc()
      //                                         .toLocal()
      //                                         .toString();
      //                               } else {
      //                                 endTime =
      //                                     DateTime.fromMillisecondsSinceEpoch(
      //                                             model.endTime!)
      //                                         .toUtc()
      //                                         .toLocal()
      //                                         .toString();
      //                               }
      //                             } catch (e) {
      //                               print('Exception at parsing endTime $e');
      //                             }
      //                             return HistoryItemCard(activityModel: model);
      //                           },
      //                         ),
      //                       ),
      //                       Visibility(
      //                         visible: value.isPageLoad,
      //                         child: Padding(
      //                           padding: EdgeInsets.symmetric(vertical: 8),
      //                           child: Center(
      //                             child: CircularProgressIndicator(),
      //                           ),
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //           ),
      //         ),
      //         Visibility(
      //           visible: value.isScreenLoad,
      //           child: Center(
      //             child: CircularProgressIndicator(),
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
