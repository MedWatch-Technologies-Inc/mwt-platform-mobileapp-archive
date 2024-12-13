import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/SavePreferenceScreen/models/set_backup_time_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

class ChatBackupScreen extends StatefulWidget {
  @override
  _ChatBackupScreenState createState() => _ChatBackupScreenState();
}

class _ChatBackupScreenState extends State<ChatBackupScreen> {
  SetBackupTimeModel setBackupTimeModel = SetBackupTimeModel();

  Widget customRadio({int index = -1,Color? color, String? unitText}) {
    return GestureDetector(
      onTap: () {
        setBackupTimeModel.setIndex(index);
      },
      child: Container(
        height: 28,
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: ConcaveDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  depression: 4,
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex("#D1D9E6"),
                    Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                        : Colors.white,
                  ]),
              child: Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#111B1A")
                        : AppColor.backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex("#D1D9E6"),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(3, 3),
                      ),
                    ]),
                child: Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    )),
              ),
            ),
            SizedBox(
              width: 9,
            ),
            unitText != ""
                ? TitleText(
                    text: unitText ?? '',
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex("#384341"),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget bottomButton() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      padding: EdgeInsets.only(bottom: 25.h,left: 15.w,right: 15.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: HexColor.fromHex("#FF6259").withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5, -5),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex("#D1D9E6"),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                  child: Container(
                    decoration: ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        depression: 11,
                        colors: [
                          Colors.white,
                          HexColor.fromHex("#D1D9E6"),
                        ]),
                    child: Center(
                      child: Text(
                        StringLocalization.of(context)
                            .getText(StringLocalization.cancel)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#111B1A")
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                }),
          ),
          SizedBox(width: 17),
          Expanded(
              child: GestureDetector(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: HexColor.fromHex("#00AFAA"),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(-5, -5),
                          ),
                          BoxShadow(
                            color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.75)
                                : HexColor.fromHex("#D1D9E6"),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: Container(
                      decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          depression: 11,
                          colors: [
                            Colors.white,
                            HexColor.fromHex("#D1D9E6"),
                          ]),
                      child: Center(
                        child: Text(
                          StringLocalization.of(context)
                              .getText(StringLocalization.save)
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex("#111B1A")
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                   setBackupTimeModel.savePreference();
                    Navigator.of(context).pop();
                    // save all the changes in set preferences.
                  })),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: setBackupTimeModel,
      child: Consumer<SetBackupTimeModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            title: Text('Chat Backup',
                style: TextStyle(
                    fontSize: 18,
                    color: HexColor.fromHex("62CBC9"),
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      "asset/dark_leftArrow.png",
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      "asset/leftArrow.png",
                      width: 13,
                      height: 22,
                    ),
            ),
          ),
          body: Container(
            child: Container(
              margin: EdgeInsets.only(top: 24.0),
              child: Column(
                children: <Widget>[
                  Body1AutoText(
                    text: 'Choose Backup Period',
                    maxLine: 3,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.87)
                        : HexColor.fromHex("#384341"),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: model.optionList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 24,left: 15,right: 15),
                            child: customRadio(
                              index: index,
                                unitText: model.optionList[index],
                                color: model.optionList[model.selectedIndex] == model.optionList[index]
                                    ? HexColor.fromHex("FF6259")
                                    : Colors.transparent),
                          );
                        }),
                  ),
                  bottomButton(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
