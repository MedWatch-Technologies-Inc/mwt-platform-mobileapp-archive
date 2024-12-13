import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class IconsScreen extends StatefulWidget {
  final int? tagCategory;
  IconsScreen({
    Key? key,
    this.tagCategory,
  }) : super(key: key);
  @override
  _IconsScreenState createState() => _IconsScreenState();
}

class _IconsScreenState extends State<IconsScreen> {
  bool searchEmpty = false;
  List<String> listOfIcons = [];
  TextEditingController searchController = new TextEditingController();

  void initState() {
    super.initState();
    listOfIcons = widget.tagCategory == 3
        ? [
            'asset/Sport/tennisBall_icon.png',
            'asset/Sport/dumbbell_icon.png',
            'asset/Sport/football_icon.png',
            'asset/Sport/pingpong_icon.png',
            'asset/Sport/skating_icon.png',
            'asset/Sport/baseball_icon.png',
            'asset/Sport/soccer_icon.png',
            'asset/Sport/hockey_icon.png',
            'asset/Sport/tennis_icon.png',
            'asset/Sport/skiing_icon.png',
            'asset/Sport/swimming_icon.png',
            'asset/Sport/golf_icon.png',
            'asset/Sport/walking_icon.png',
            'asset/Sport/volleyball_icon.png',
            'asset/Sport/basketball_icon.png',
            'asset/Sport/ice_skating_icon.png',
            'asset/Sport/biking_icon.png',
            'asset/Sport/boxing_icon.png',
            'asset/Sport/hiking_icon.png',
            'asset/Wellness/bone_break_icon.png',
            'asset/Wellness/brain_icon.png',
            'asset/Wellness/frown_icon.png',
            'asset/Wellness/smile_icon.png',
            'asset/Wellness/bloodpressure_icon.png',
            'asset/Wellness/weightIcon.png',
            'asset/Wellness/hr_icon.png',
            'asset/Wellness/injured_icon.png',
            'asset/Wellness/sleepIcon.png',
            'asset/Wellness/band_icon.png',
            'asset/Wellness/wellness_icon.png',
            'asset/Wellness/syringe_icon.png',
            'asset/Wellness/wc_icon.png',
          ]
        : widget.tagCategory == 1
            ? [
                'asset/Sport/tennisBall_icon.png',
                'asset/Sport/dumbbell_icon.png',
                'asset/Sport/football_icon.png',
                'asset/Sport/pingpong_icon.png',
                'asset/Sport/skating_icon.png',
                'asset/Sport/baseball_icon.png',
                'asset/Sport/soccer_icon.png',
                'asset/Sport/hockey_icon.png',
                'asset/Sport/tennis_icon.png',
                'asset/Sport/skiing_icon.png',
                'asset/Sport/swimming_icon.png',
                'asset/Sport/golf_icon.png',
                'asset/Sport/walking_icon.png',
                'asset/Sport/volleyball_icon.png',
                'asset/Sport/basketball_icon.png',
                'asset/Sport/ice_skating_icon.png',
                'asset/Sport/biking_icon.png',
                'asset/Sport/boxing_icon.png',
                'asset/Sport/hiking_icon.png',
              ]
            : [
                'asset/Wellness/bone_break_icon.png',
                'asset/Wellness/brain_icon.png',
                'asset/Wellness/frown_icon.png',
                'asset/Wellness/smile_icon.png',
                'asset/Wellness/bloodpressure_icon.png',
                'asset/Wellness/weightIcon.png',
                'asset/Wellness/hr_icon.png',
                'asset/Wellness/injured_icon.png',
                'asset/Wellness/sleepIcon.png',
                'asset/Wellness/band_icon.png',
                'asset/Wellness/wellness_icon.png',
                'asset/Wellness/syringe_icon.png',
                'asset/Wellness/wc_icon.png',
              ];
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
              titleSpacing: 0.0,
              leading: IconButton(
                key: Key('backButtonIconScreen'),
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
              title: Body1Text(
                  text: stringLocalization.getText(StringLocalization.selectImage),
                  color: HexColor.fromHex('#62CBC9'),
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              centerTitle: true,
            ),
          )),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 56,
                decoration: ConcaveDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    depression: 7,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#000000').withOpacity(0.8)
                          : HexColor.fromHex('#D1D9E6'),
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white,
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Center(
                  child: Padding(
                    key: Key('searchIcon'),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: searchEmpty
                              ? 'Please type in search field'
                              : StringLocalization.of(context)
                                  .getText(StringLocalization.searchIcon),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: searchEmpty
                                ? HexColor.fromHex('FF6259')
                                : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF')
                                        .withOpacity(0.38)
                                    : HexColor.fromHex('#7F8D8C'),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              searchController.text.isEmpty
                                  ? searchEmpty = true
                                  : searchEmpty = false;
                              setState(() {});
                            },
                            child: Image.asset(
                              'asset/search_icon.png',
                              color: HexColor.fromHex('#00AFAA'),
                            ),
                          )),
                      inputFormatters: [
                        FilteringTextInputFormatter(regExForRestrictEmoji(),
                            allow: false),
                      ],
                      onChanged: (value) {
                        if (value != null || value.length > 0) {
                          searchEmpty = false;
                        } else {
                          searchEmpty = true;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                )),
            SizedBox(height: 23.h),
            Expanded(
              child: dataView(),
            ),
          ],
        ),
      ),
    );
  }

//  Widget dataView() {
//    List list = listOfIcons;
//    if (searchController.text.trim().length > 0) {
//      list = listOfIcons
//          .where((s) =>
//              s.toLowerCase().contains(searchController.text.toLowerCase()))
//          .toList();
//    }
//    return GridView.builder(
//      scrollDirection: Axis.vertical,
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 4,
//      ),
//      itemCount: list.length,
//      shrinkWrap: true,
//      //padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
//      itemBuilder: (context, index) {
//        return Container(
//          height: 67.h,
//          child: Column(children: [
//            InkWell(
//              onTap: () {
//
//              },
//              child: Container(
//                height: 67.h,
//                width: 67.h,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
//                    color: Theme
//                        .of(context)
//                        .brightness == Brightness.dark
//                        ? HexColor.fromHex('#111B1A')
//                        : AppColor.backgroundColor,
//                    boxShadow: [
//                      BoxShadow(
//                        color: Theme
//                            .of(context)
//                            .brightness == Brightness.dark
//                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
//                            : Colors.white.withOpacity(0.7),
//                        blurRadius: 2,
//                        spreadRadius: 0,
//                        offset: Offset(-2.5, -2.5),
//                      ),
//                      BoxShadow(
//                        color: Theme
//                            .of(context)
//                            .brightness == Brightness.dark
//                            ? Colors.black.withOpacity(0.75)
//                            : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
//                        blurRadius: 2,
//                        spreadRadius: 0,
//                        offset: Offset(2.5, 2.5),
//                      ),
//                    ]),
//                child: Padding(
//                  padding:
//                  EdgeInsets.all(12.h),
//                  child: Image.asset(list[index]),
//                ),
//              ),
//            ),
//          ]),
//        );
//      },
//    );
//  }

  regExForRestrictEmoji() => RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  Widget dataView() {
    List list = listOfIcons;
    if (searchController.text.trim().length > 0) {
      String temp = searchController.text;
      temp = temp.replaceAll(' ', '');
      list = listOfIcons
          .where((s) => s.toLowerCase().contains(temp.toLowerCase()))
          .toList();
    }
    if (list != null && list.isNotEmpty) {
      return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 17.w,
            mainAxisSpacing: 17.w,
          ),
          itemCount: list.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (context != null) {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(list[index]);
                  }
                }
              },
              child: Container(
                height: 67.w,
                width: 67.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white.withOpacity(0.7),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(-2.5, -2.5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(2.5, 2.5),
                      ),
                    ]),
                child: Padding(
                    padding: EdgeInsets.all(12.w),
                    key: index == 0 ? Key('icon_0') : Key('randomIcon'),
                    child: Image.asset(list[index],
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#00AFAA')
                            : null)),
              ),
            );
          });
    }
    return Container(
      child: Center(
        // child: FittedBox(
        //   child: Text(stringLocalization.getText(StringLocalization.noIconFound),
        //   style: TextStyle(
        //       fontWeight: FontWeight.w800,
        //   fontSize: 14.sp),
        // ),
        // ),
        child: TitleText(
          text: stringLocalization.getText(StringLocalization.noIconFound),
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
//    return Container(
//      alignment: Alignment.topCenter,
//      child: Wrap(
//        direction: Axis.horizontal,
//        alignment: WrapAlignment.start,
//        spacing: 50.h,
//        runSpacing: 50.h,
//        children: List<Widget>.generate(list.length, (index) {
//          return GestureDetector(
//            onTap: () {
//              if (context != null) {
//                Navigator.of(context).pop(list[index]);
//              }
//            },
//            child: Image.asset(
//              list[index],
//              height: 30.h,
//              width: 30.h,
//            ),
//          );
//        }),
//      ),
//    );
  }
}
