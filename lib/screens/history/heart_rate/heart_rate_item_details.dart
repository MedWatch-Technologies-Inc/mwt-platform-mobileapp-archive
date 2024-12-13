import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class HeartRateItemDetails extends StatefulWidget {
  const HeartRateItemDetails({
    required this.graphWidget,
    required this.avgHeartRate,
    this.pageHeading,
    this.notification,
    this.unit = 'bpm',
    // this.isDayView = false,
    // required this.data,
    // required this.dateTime,
    // this.calories = 0,
    // this.exerciseData,
    // this.exerciseTime = 0,
    // this.startDate,
    // this.endDate,
    Key? key,
  }) : super(key: key);

  final String? pageHeading;
  final List<String>? notification;
  final Widget? graphWidget;
  final int? avgHeartRate;
  final String unit;

  // final bool isDayView;
  // final List<MeasurementHistoryModel> data;
  // final DateTime? dateTime;
  // final DateTime? startDate;
  // final DateTime? endDate;
  // final int exerciseTime;
  // final int calories;
  // final Map<String, int>? exerciseData;

  @override
  _HeartRateItemDetailsState createState() => _HeartRateItemDetailsState();
}

class _HeartRateItemDetailsState extends State<HeartRateItemDetails> {
  // int totalTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.pageHeading != null
          ? AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
                  );
                },
              ),
              title: Center(
                child: HeadlineText(
                  text: widget.pageHeading!,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.graphWidget != null)
              Container(
                padding: EdgeInsets.all(8.0.w),
                height: 200.h,
                child: widget.graphWidget,
              ),
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Body1Text(
                      text: Strings().heartRateNotifications,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  (widget.notification != null &&
                          widget.notification!.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 8.0.w, top: 8.0.h, bottom: 8.0.h),
                          child: Row(
                            children: [
                              for (var item in widget.notification!)
                                Body1AutoText(text: item),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              left: 8.0.w, top: 8.0.h, bottom: 8.0.h),
                          child: Body1Text(
                            text: Strings().emptyHeartRateNotifications,
                            color: Colors.grey,
                          ),
                        ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Body1Text(
                          text: Strings().restingHeartRate,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 8.0.h, bottom: 8.0.h, left: 4.0.w),
                    child: Rich1Text(
                      text1: widget.avgHeartRate != 0
                          ? widget.avgHeartRate.toString()
                          : 'N/A',
                      text2: ' ${widget.unit}',
                      fontSize1: 30.sp,
                      fontSize2: 15.sp,
                      color1: Colors.black,
                      color2: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  /*
                 Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bar_chart,
                        ),
                        SizedBox(width: 4.0.w),
                        Body1Text(
                          text: Strings().exerciseZone,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (getTime(widget.exerciseTime)[0] != 0)
                              Rich1Text(
                                text1:
                                    getTime(widget.exerciseTime)[0].toString(),
                                text2: ' ${Strings().hourShort}',
                                color1: Colors.black,
                                color2: Colors.black,
                                fontSize1: 30.sp,
                                fontSize2: 15.sp,
                              ),
                            SizedBox(width: 4.0.w,),
                            Rich1Text(
                              text1: getTime(widget.exerciseTime)[1].toString(),
                              text2: ' ${Strings().minShort}',
                              color1: Colors.black,
                              color2: Colors.black,
                              fontSize1: 30.sp,
                              fontSize2: 15.sp,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Rich1Text(
                          text1: widget.calories.toString(),
                          text2: ' ${Strings().calories.toLowerCase()}',
                          color1: Colors.black,
                          color2: Colors.black,
                          fontSize1: 30.sp,
                          fontSize2: 15.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  for (var item in widget.exerciseData.keys)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.0.h,
                            width: (MediaQuery.of(context).size.width * 0.6 * (widget.exerciseData[item]!/totalTime))+1,
                            decoration: BoxDecoration(
                              color: getBarColor(item)
                            ),
                          ),
                          SizedBox(width: 4.0.w,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (getTime(widget.exerciseData[item])[0] != 0)
                                    Rich1Text(
                                      text1: getTime(widget.exerciseData[item])[0]
                                          .toString(),
                                      text2: ' ${Strings().hourShort}',
                                      color1: Colors.black,
                                      color2: Colors.black,
                                      fontSize1: 16.sp,
                                      fontSize2: 15.sp,
                                    ),
                                  if (getTime(widget.exerciseData[item])[0] != 0)
                                    SizedBox(width: 4.0.w,),
                                  Rich1Text(
                                    text1: getTime(widget.exerciseData[item])[1]
                                        .toString(),
                                    text2: ' ${Strings().minShort}',
                                    color1: Colors.black,
                                    color2: Colors.black,
                                    fontSize1: 16.sp,
                                    fontSize2: 15.sp,
                                  ),
                                ],
                              ),
                              Body1Text(
                                text: item,
                                align: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

/*
  List<int> getTime(int? t) {
    return t != null ? [t ~/ 60, t % 60] : [0, 0];
  }

  void setHighestTimeValue(Map<String, int> data) {
    for (var val in data.values) {
      totalTime += val;
    }
  }

  Color getBarColor(String item) {
    switch (item) {
      case 'peak':
        return Colors.red;
      case 'cardio':
        return Colors.orange;
      case 'fat burn':
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }
   */
}
