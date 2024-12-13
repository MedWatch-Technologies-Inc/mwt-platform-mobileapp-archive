import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/activity_history.dart';
import 'package:health_gauge/screens/map_screen/widgets/custom_map_divider.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  _WorkoutFeedsState createState() => _WorkoutFeedsState();
}

class _WorkoutFeedsState extends State<CommentScreen> {
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
                ? HexColor.fromHex('#111B1A')
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
              stringLocalization.getText(StringLocalization.workoutFeeds),
              style: TextStyle(color: HexColor.fromHex('62CBC9')),
              // .toUpperCase(),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Constants.navigatePush(ActivityHistory(), context);
                },
                icon: Stack(
                  children: [
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? images.darkNotificationIcon
                          : images.lightNotificationIcon,
                      height: 33.w,
                      width: 33.w,
                    ),
                    Positioned(
                      right: 0,
                      top: 2,
                      child: Container(
                        height: 18.w,
                        width: 18.w,
                        decoration: BoxDecoration(
                          color: HexColor.fromHex('#FF6259'),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white.withOpacity(0.7),
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
        margin:
            EdgeInsets.only(left: 13.w, right: 13.w, top: 13.h, bottom: 7.h),
        child: Column(
          children: [
            CommentScreenHeader(),
            SizedBox(
              height: 7.h,
            ),
            CustomMapDivider(),
            SizedBox(
              height: 6.h,
            ),
            CommentLikeSection(),
            SizedBox(
              height: 7.h,
            ),
            CustomMapDivider(),
            Expanded(
              child: CommentSection(),
            ),
            CommentTextBox(),
          ],
        ),
      ),
    );
  }
}

class CommentSection extends StatelessWidget {
  CommentSection({Key? key}) : super(key: key);

  final AppImages images = AppImages();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 43.h,
                width: 43.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                child: Image.asset(images.commentIcon),
              ),
              SizedBox(
                width: 16.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zohreh Valiary. May 16',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.6)
                            : HexColor.fromHex('#5D6A68')),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    'jhjhbhjv jhuvhhuiehihhvek mdvf KJJJ \nJbhbghjbshbsnc n dnb \njhjhbhjv jhuvh huiehihhvek',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                  )
                ],
              ),
              SizedBox(
                height: 17.h,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 17.h,
        ),
        CustomMapDivider(),
      ],
    );
  }
}

class CommentScreenHeader extends StatelessWidget {
  CommentScreenHeader({Key? key}) : super(key: key);

  final AppImages images = AppImages();

  LatLng target() {
    return LatLng(45.41534475925838, -75.70018300974971);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 11.w, right: 11.w, top: 8.h),
      child: Column(
        children: [
          Container(
              height: 105.h,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: target(), zoom: 16),
                mapType: MapType.normal,
                compassEnabled: false,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: (controller) {
                  // _setMapFitToTour(
                  //     widget.locationList, controller);
                },
              )),
          Container(
            margin: EdgeInsets.only(top: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'EVENING RUN',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#384341')),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      'Amir pournajib | May 6, 2021 | ',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68')),
                    ),
                    Image.asset(
                      images.runningIcon,
                      height: 26.h,
                      width: 26.h,
                    ),
                    Text(
                      '2.0 Km',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68')),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentLikeSection extends StatelessWidget {
  final AppImages images = AppImages();

  CommentLikeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 21.w, right: 15.w),
      child: Row(
        children: [
          Image.asset(
            images.thumbsUpIconDark,
            height: 30.h,
            width: 30.h,
          ),
          Spacer(),
          Text(
            '2 Likes 12 Comments',
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex('#384341')),
          )
        ],
      ),
    );
  }
}

class CommentTextBox extends StatelessWidget {
  final AppImages images = AppImages();

  CommentTextBox({Key? key}) : super(key: key);

  bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 21.w, right: 20.w, bottom: 13.h),
      child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          child: Container(
            // height: 40.h,
            decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                depression: 7,
                colors: [
                  Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.8)
                      : HexColor.fromHex('#D1D9E6'),
                  Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                ]),
            padding: EdgeInsets.only(left: 12.w, right: 10.w),
            child: Center(
              child: TextField(
                maxLines: 3,
                minLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341')),
                decoration: InputDecoration(
                    // contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    suffixIcon: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      child: Theme.of(context).brightness == Brightness.dark
                          ? Image.asset(
                              images.darkSendIcon,
                              height: 30.w,
                              width: 30.w,
                            )
                          : Image.asset(
                        images.lightSendIcon,
                              height: 30.w,
                              width: 30.w,
                            ),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Comment',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.38)
                          : HexColor.fromHex('#7F8D8C'),
                    )),
                onSubmitted: (value) {},
              ),
            ),
          )),
    );
  }
}
