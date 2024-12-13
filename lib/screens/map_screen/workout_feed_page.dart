import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_history/activity_history_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_history/event/activity_history_event.dart';
import 'package:health_gauge/bloc/activity/activity_history/state/activity_history_state.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/screens/map_screen/model/workout_model.dart';
import 'package:health_gauge/screens/map_screen/workout_feeds.dart';
import 'package:health_gauge/services/bloc/bloc_common_state.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import '../../utils/constants.dart';

class WorkoutFeedPage extends StatefulWidget {
  WorkoutFeedPage({Key? key}) : super(key: key);

  @override
  _WorkoutFeedPageState createState() => _WorkoutFeedPageState();
}

class _WorkoutFeedPageState extends State<WorkoutFeedPage> {
  AppImages images = AppImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
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
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                images.darkClose,
                height: 33,
                width: 33,
              )
                  : Image.asset(
                images.lightClose,
                height: 33,
                width: 33,
              ),
            ),
            title: Text(
              'Workout Feeds',
              style: TextStyle(color: HexColor.fromHex('#62CBC9')),
              // .toUpperCase(),
            ),
            centerTitle: true,
            actions: [],
          ),
        ),
      ),
      body: WorkoutFeedPageHelper(),
    );
  }
}

class WorkoutFeedPageHelper extends StatefulWidget {
  WorkoutFeedPageHelper({
    Key? key,
  }) : super(key: key);

  @override
  _WorkoutFeedPageHelperState createState() => _WorkoutFeedPageHelperState();
}

class _WorkoutFeedPageHelperState extends State<WorkoutFeedPageHelper> {
  late ActivityHistoryBloc activityHistoryBloc;
  CalculateActivityItems activityItems = CalculateActivityItems();
  AppImages images = AppImages();
  List<ActivityModel> model = [];
  ScrollController controller = ScrollController();
  int? unit;

  @override
  void initState() {
    // TODO: implement initState
    unit = preferences?.getInt(Constants.mDistanceUnitKey) ?? 10;
    activityHistoryBloc = ActivityHistoryBloc();
    activityHistoryBloc.add(GetHistoryListEvent());
    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          if (!activityHistoryBloc.allFetched) {
            activityHistoryBloc.add(GetHistoryListEvent());
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    activityHistoryBloc.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> getWidgetList(List<ActivityModel> model) {
    //   return List.generate(model.length, (index) {
    //     var activityModel = model[index];
    //     return WorkOutFeedData(WorkoutModel(
    //       name: '${globalUser!.firstName!} ${globalUser!.lastName!}',
    //       image: images.runningIcon,
    //       userImage: images.maleAvatar,
    //       date: DateTime.fromMillisecondsSinceEpoch(
    //           activityModel.endTime ?? DateTime.now().millisecondsSinceEpoch),
    //       place: '',
    //       title: activityModel.title ?? 'Untitled',
    //       pace: activityItems.getSpeed(activityModel.locationList ?? []),
    //       avgPace: activityItems.getAvgSpeed(activityModel.locationList ?? []),
    //       calorie: '0',
    //       duration: activityItems
    //           .convertSecToFormattedTime(activityModel.totalTime ?? 0),
    //       distance: activityItems.getDistance(activityModel.locationList ?? []),
    //       likes: 0,
    //       commentLength: 0,
    //       activityModel: activityModel,
    //     ));
    //   });
    // }

    return BlocConsumer(
      bloc: activityHistoryBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ActivityHistoryInitialState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ActivityHistoryPageState &&
            state.status == Status.loading &&
            state.isFirstFetch) {
          return Center(child: CircularProgressIndicator());
        }
        var items = <ActivityModel>[];
        var isLoading = false;

        if (state is ActivityHistoryPageState &&
            state.status == Status.loading) {
          items = state.model ?? [];
          isLoading = true;
        } else if (state is ActivityHistoryPageState &&
            state.status == Status.completed) {
          items = state.model ?? [];
        }

        if (items.isEmpty) {
          return Center(
            child: Text(
                stringLocalization.getText(StringLocalization.noDataFound)),
          );
        }

        return ListView.builder(
            controller: controller,
            itemCount: items.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < items.length) {
                var activityModel = items[index];
                return WorkOutFeedData(
                  WorkoutModel(
                      name:
                      '${globalUser!.firstName!} ${globalUser!.lastName!}',
                      image: images.runningIcon,
                      userImage: images.maleAvatar,
                      date: DateTime.fromMillisecondsSinceEpoch(
                          activityModel.endTime ??
                              DateTime.now().millisecondsSinceEpoch),
                      place: '',
                      title: activityModel.title ?? 'Untitled',
                      pace: activityItems
                          .getSpeed(activityModel.locationList ?? []),
                      avgPace: activityItems
                          .getAvgSpeed(activityModel.locationList ?? []),
                      calorie: '0',
                      duration: activityItems.convertSecToFormattedTime(
                          activityModel.totalTime ?? 0),
                      distance: activityItems
                          .getDistance(activityModel.locationList ?? []),
                      likes: 0,
                      commentLength: 0,
                      maxPace: activityItems
                          .getMaxSpeed(activityModel.locationList ?? []),
                      activityModel: activityModel,
                      unit: unit),
                );
              } else {
                Timer(Duration(milliseconds: 30), () {
                  controller.jumpTo(controller.position.maxScrollExtent);
                });

                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            });

        // if (state is ActivityHistoryPageState) {
        //   if (state.status == Status.loading && state.isFirstFetch) {
        //     return Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   } else if (state.status == Status.completed || state.status == Status.loading) {
        //     if (state.model == null || state.model!.isEmpty) {
        //       return Center(
        //         child: Text(
        //             stringLocalization.getText(StringLocalization.noDataFound)),
        //       );
        //     } else {
        //       return ListView.builder(
        //         itemCount: state.model!.length,
        //         controller: controller,
        //         itemBuilder: (context,index){
        //           var activityModel = model[index];
        //           return WorkOutFeedData(WorkoutModel(
        //             name: '${globalUser!.firstName!} ${globalUser!.lastName!}',
        //             image: images.runningIcon,
        //             userImage: images.maleAvatar,
        //             date: DateTime.fromMillisecondsSinceEpoch(
        //                 activityModel.endTime ?? DateTime.now().millisecondsSinceEpoch),
        //             place: '',
        //             title: activityModel.title ?? 'Untitled',
        //             pace: activityItems.getSpeed(activityModel.locationList ?? []),
        //             avgPace: activityItems.getAvgSpeed(activityModel.locationList ?? []),
        //             calorie: '0',
        //             duration: activityItems
        //                 .convertSecToFormattedTime(activityModel.totalTime ?? 0),
        //             distance: activityItems.getDistance(activityModel.locationList ?? []),
        //             likes: 0,
        //             commentLength: 0,
        //             activityModel: activityModel,
        //           ));
        //         },
        //       );
        //     }
        //   } else if (state.status == Status.error) {}
        // }
        // return Center(child: Text('Error'));
      },
    );
  }
}