import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/activity_history.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:provider/provider.dart';

class ActivityList extends StatefulWidget {
  final ValueChanged<int>? onChangeActivity;

  const ActivityList({
    @required this.onChangeActivity,
    Key? key,
  }) : super(key: key);

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  AppImages images = AppImages();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: material.Size.fromHeight(kToolbarHeight),
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
                Navigator.of(context).pop();
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                images.leftArrowDark,
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                images.leftArrowLight,
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              stringLocalization.getText(StringLocalization.workoutRecord),
              style: TextStyle(color: HexColor.fromHex('62CBC9')),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Constants.navigatePush(ActivityHistory(), context);
                },
                icon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? images.historyDarkIcon
                      : images.historyIcon,
                  // height: 33,
                  // width: 33,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Selector<SaveActivityScreenModel, int>(
                selector: (context, model) =>
                    model.currentSelectedActivityIndex!,
                builder: (context, value, _) {
                  return Container(
                    padding:
                        EdgeInsets.only(top: 19.h, bottom: 11.h, left: 31.w),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    child: Row(
                      children: [
                        Container(
                          height: 43.h,
                          width: 43.h,
                          child: Image.asset(
                            provider
                                .activityOptions[
                                    provider.currentSelectedActivityIndex!]
                                .image!,
                            height: 43.h,
                            width: 43.h,
                          ),
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Text(
                          '${provider.activityOptions[provider.currentSelectedActivityIndex!].title!.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : AppColor.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white.withOpacity(0.7),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4, -4),
                    ),
                  ]),
              child: Container(
                // height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 10.h),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: ListView.builder(
                    itemCount: provider.activityOptions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.onChangeActivity!(index);
                          provider.updateActivityIndex(index);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 22.h, left: 26.w),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Image.asset(
                                provider.activityOptions[index].image!,
                                height: 33.w,
                                width: 33.w,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Text(provider.activityOptions[index].title!),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
