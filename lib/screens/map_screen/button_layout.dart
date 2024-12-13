import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/map_screen/providers/location_track_provider.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:provider/provider.dart';

class ButtonLayout extends StatefulWidget {
  final GestureTapCallback? onClickFinishButton;
  final GestureTapCallback? onClickStartButton;
  // final GestureTapCallback onClickMapButton;

  const ButtonLayout({
    @required this.onClickFinishButton,
    @required this.onClickStartButton,
    Key? key,
    // @required this.onClickMapButton
  }) : super(key: key);

  @override
  _ButtonLayoutState createState() => _ButtonLayoutState();
}

class _ButtonLayoutState extends State<ButtonLayout> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);

    return Consumer<LocationTrackProvider>(
      builder:
          (BuildContext? context, LocationTrackProvider? value, Widget? child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                startButton(),
                // mapButton(),
                playPauseStopButton(),
                // playPauseStopButton(),
                // finishButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget startButton() {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);

    if (!provider.isStarted) {
      return InkWell(
        child: Container(
          height: 40.h,
          width: 309.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.h),
            color: HexColor.fromHex('#00AFAA'),
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
                    : HexColor.fromHex('#D1D9E6'),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.h),
              ),
              depression: 11,
              colors: [
                Colors.white,
                HexColor.fromHex('#D1D9E6'),
              ],
            ),
            child: Center(
              child: Text(
                stringLocalization
                    .getText(StringLocalization.startWorkout)
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
        onTap: widget.onClickStartButton,
      );
    }
    return Container();
  }

  Widget playPauseStopButton() {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    if (provider.isStarted) {
      if (!provider.isPause) {
        return InkWell(
          child: Container(
            height: 40.h,
            width: 309.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: HexColor.fromHex('#FF6259'),
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
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.h),
                ),
                depression: 11,
                colors: [
                  Colors.white,
                  HexColor.fromHex('#D1D9E6'),
                ],
              ),
              child: Center(
                child: Text(
                  stringLocalization
                      .getText(StringLocalization.pause)
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            provider.isPause = true;
            provider.manuallyPause = true;
            if (!provider.timer!.isActive) {
              provider.cancelTimer();
            }
          },
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                height: 40.h,
                width: 146.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.h),
                  color: HexColor.fromHex('#FF6259'),
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
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: ConcaveDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.h),
                    ),
                    depression: 11,
                    colors: [
                      Colors.white,
                      HexColor.fromHex('#D1D9E6'),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      stringLocalization
                          .getText(StringLocalization.finish)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: widget.onClickFinishButton,
            ),
            SizedBox(
              width: 17.w,
            ),
            InkWell(
              child: Container(
                height: 40.h,
                width: 146.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.h),
                  color: HexColor.fromHex('#00AFAA'),
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
                          : HexColor.fromHex('#D1D9E6'),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: ConcaveDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.h),
                    ),
                    depression: 11,
                    colors: [
                      Colors.white,
                      HexColor.fromHex('#D1D9E6'),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      stringLocalization
                          .getText(StringLocalization.resume)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                provider.isPause = false;
                provider.manuallyPause = false;
                if (provider.timer != null && !provider.timer!.isActive) {
                  provider.timer =
                      Timer.periodic(Duration(seconds: 1), (timer) {
                    if (provider.isPause) {
                      provider.cancelTimer();
                    } else {
                      provider.updateTimeCount(1);
                    }
                  });
                }
              },
            ),
          ],
        );
      }
    }
    return Container();
  }

  Widget playPauseButton() {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    print('isStarted ${provider.isStarted}');
    if (provider.isStarted) {
      if (!provider.isPause) {
        return InkWell(
          child: Container(
            height: 40.h,
            width: 309.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: HexColor.fromHex('#FF6259'),
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
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.h),
                ),
                depression: 11,
                colors: [
                  Colors.white,
                  HexColor.fromHex('#D1D9E6'),
                ],
              ),
              child: Center(
                child: Text(
                  stringLocalization
                      .getText(StringLocalization.pause)
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            provider.isPause = true;
            provider.manuallyPause = true;
            if (provider.timer != null) {
              provider.cancelTimer();
            }
          },
        );
      } else {
        return InkWell(
          child: Container(
            height: 40.h,
            width: 309.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: HexColor.fromHex('#00AFAA'),
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
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.h),
                ),
                depression: 11,
                colors: [
                  Colors.white,
                  HexColor.fromHex('#D1D9E6'),
                ],
              ),
              child: Center(
                child: Text(
                  stringLocalization
                      .getText(StringLocalization.resume)
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            provider.isPause = false;
            provider.manuallyPause = false;
            if (provider.manuallyPauseTimer != null &&
                provider.manuallyPauseTimer!.isActive) {
              provider.manuallyPauseTimer!.cancel();
            }
            provider.timer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (provider.isPause) {
                provider.cancelTimer();
              } else {
                provider.updateTimeCount(1);
              }
            });
          },
        );
      }
    }
    return Container();
  }

  Widget finishButton() {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);

    if (provider.isStarted) {
      return InkWell(
        onTap: widget.onClickFinishButton,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(Icons.stop),
          ),
        ),
      );
    }
    return Container();
  }

  String getButtonText() {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    if (provider.isStarted) {
      return StringLocalization.finish;
    } else {
      return StringLocalization.start;
    }
  }
}
