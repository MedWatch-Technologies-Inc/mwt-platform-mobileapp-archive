import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/screens/map_screen/widgets/workout_image_container.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

class WorkoutPhotos extends StatefulWidget {
  const WorkoutPhotos({Key? key}) : super(key: key);

  @override
  _WorkoutPhotosState createState() => _WorkoutPhotosState();
}

class _WorkoutPhotosState extends State<WorkoutPhotos> {
  AppImages images = AppImages();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
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
              'Workout Photos',
              style: TextStyle(color: HexColor.fromHex('62CBC9')),
            ),
            actions: [],
            centerTitle: true,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [...showAllImages(), cancelSaveButton()],
        ),
      ),
    );
  }

  List<WorkoutImageContainer> showAllImages() {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    var list = List.generate(provider.activityImageModelList!.length, (index) {
      return WorkoutImageContainer(
          provider.activityImageModelList![index], index);
    });
    return list;
  }

  Widget cancelSaveButton() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      margin: EdgeInsets.only(left: 33.w, right: 33.w, bottom: 41.h, top: 25.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: HexColor.fromHex('#FF6259').withOpacity(0.8),
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
                      ]),
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
                        ]),
                    child: Center(
                      child: Body1AutoText(
                        text: stringLocalization
                            .getText(StringLocalization.cancel)
                            .toUpperCase(),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                        minFontSize: 10,
                        // maxLine: 1,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  onCancel();
                  Navigator.of(context).pop();
                }),
          ),
          SizedBox(width: 17.w),
          Expanded(
              child: GestureDetector(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        color: HexColor.fromHex('#00AFAA'),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(-5, -5),
                          ),
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black.withOpacity(0.75)
                                    : HexColor.fromHex('#D1D9E6'),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(5, 5),
                          ),
                        ]),
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
                          ]),
                      child: Center(
                        child: Body1AutoText(
                          text: stringLocalization
                              .getText(StringLocalization.save)
                              .toUpperCase(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                          minFontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    onSave();
                    Navigator.of(context).pop();
                    // onClickSave(context);
                  })),
        ],
      ),
    );
  }

  void onCancel() {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    for (var i = 0; i < provider.activityImageModelOldList!.length; i++) {
      provider.activityImageModelList![i].description =
          provider.activityImageModelOldList![i].description;
    }
  }

  void onSave() {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    for (var i = 0; i < provider.activityImageModelOldList!.length; i++) {
      provider.activityImageModelOldList![i].description =
          provider.activityImageModelList![i].description;
    }
  }
}
