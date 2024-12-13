import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/tag/add_tag_dialog.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class TagSelectCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : HexColor.fromHex('#EEF1F1'),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              key: Key('backButtonTagSelectCategoryScreen'),
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
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
              stringLocalization.getText(StringLocalization.addNewTag),
              style: TextStyle(
                  color: HexColor.fromHex('#62CBC9'), fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 46.w, right: 46.w, top: 33.h),
              height: 74.h,
              child: Center(
                child: Body1AutoText(
                  text: stringLocalization.getText(StringLocalization.selectCategory).toUpperCase(),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  minFontSize: 10,
                ),
              ),
            ),
            SizedBox(
              height: 19.h,
            ),
            Container(
              height: 140.h,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      key: Key('addExerciseButton'),
                      child: containerDesign(
                        context: context,
                        iconPath: 'asset/exerciseIcon.png',
                        name: stringLocalization.getText(StringLocalization.exercise),
                        categoryType: 1,
                        title: stringLocalization.getText(StringLocalization.exerciseTitle),
                      ),
                    ),
                    SizedBox(
                      width: 23.w,
                    ),
                    Container(
                      key: Key('addHealthTag'),
                      child: containerDesign(
                        context: context,
                        iconPath: 'asset/medical_icon.png',
                        name: stringLocalization.getText(StringLocalization.health),
                        categoryType: 2,
                        title: stringLocalization.getText(StringLocalization.wellnessTitle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 19.h,
            ),
            Container(
              key: Key('addSymptomTag'),
              child: containerDesign(
                context: context,
                iconPath: 'asset/Fatigue.png',
                name: stringLocalization.getText(StringLocalization.symptoms),
                iconColor: HexColor.fromHex('#FF9E99'),
                categoryType: 2,
                title: stringLocalization.getText(StringLocalization.symptomsTitle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerDesign(
      {required BuildContext context,
      required String iconPath,
      required String name,
      required int categoryType,
      required String title,
      Color? iconColor}) {
    return Container(
      width: 104.h,
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 104.h,
              width: 104.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : HexColor.fromHex('#E5E5E5'),
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
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            HexColor.fromHex('#CC0A00').withOpacity(0.15),
                            HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                          ],
                        )
                      : RadialGradient(
                          colors: [
                            HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                            HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                          ],
                          stops: [0.7, 1],
                        ),
                ),
                child: Container(
                  color: Colors.transparent,
                  height: 20,
                  width: 20,
                  margin: EdgeInsets.all(14.5.h),
                  child: Image.asset(
                    iconPath,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            onTap: () async {
              await Constants.navigatePush(
                AddTagDialog(
                  category: categoryType,
                  title: title,
                ),
                context,
              ).then((value) {
                if (value != null && value) {
                  Navigator.of(context).pop(true);
                }
              });
            },
          ),
          SizedBox(
            height: 11.h,
          ),
          categoryName(context, name)
        ],
      ),
    );
  }

  Widget categoryName(BuildContext context, String name) {
    return Container(
      height: 25.h,
      child: TitleText(
        text: name.toUpperCase(),
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
            : HexColor.fromHex('#384341'),
        // maxLine: 1,
      ),
    );
  }
}
