import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/map_screen/model/workout_image_model.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkoutImageContainer extends StatefulWidget {
  final WorkoutImageModel? model;
  late final int index;

  WorkoutImageContainer(this.model, this.index, {Key? key}) : super(key: key);

  @override
  _WorkoutImageContainerState createState() => _WorkoutImageContainerState();
}

class _WorkoutImageContainerState extends State<WorkoutImageContainer> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.model!.description);
    super.initState();
  }

  String getDateInFormat(String date, String outputFormat) {
    return DateFormat(outputFormat).format(DateTime.parse(date));
    // "dd-MM-yyyy"
  }

  String formattedDate(DateTime date, String outputFormat) {
    return DateFormat(outputFormat).format(date);
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(left: 13.w, right: 13.w, top: 17.h),
      // height: 312.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              widget.model!.image!,
              height: 252.h,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w),
              child: Text(
                formattedDate(widget.model!.time!, 'MMM dd - h:mm a')
                    .replaceAll('AM', 'am')
                    .replaceAll('PM', 'pm'),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Say something about this photo',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#7F8D8C')),
                ),
                onChanged: (value) {
                  provider.activityImageModelList![widget.index].description =
                      value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
