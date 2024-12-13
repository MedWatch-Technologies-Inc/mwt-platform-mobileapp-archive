import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'concave_decoration.dart';

class DrawerItems extends StatelessWidget {
  final String iconPath;
  final String title;
  final int? num;
  final String selectedItem;

  DrawerItems({
    required this.iconPath,
    required this.title,
    required this.selectedItem,
    this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      margin: EdgeInsets.only(right: 7, top: 5),
      decoration: BoxDecoration(
          //color: Theme.of(context).brightness == Brightness.dark ? selectedScreen == title ? HexColor.fromHex("#9F2DBC").withOpacity(0.15) : AppColor.darkBackgroundColor : selectedScreen == title ? HexColor.fromHex("#FFDFDE").withOpacity(0.6) : AppColor.backgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? selectedItem == title
                    ? HexColor.fromHex("#9F2DBC").withOpacity(0.15)
                    : AppColor.darkBackgroundColor
                    : selectedItem == title
                    ? HexColor.fromHex("#FFDFDE").withOpacity(0.6)
                    : AppColor.backgroundColor,
                Theme.of(context).brightness == Brightness.dark
                    ? selectedItem == title
                    ? HexColor.fromHex("#CC0A00").withOpacity(0.15)
                    : AppColor.darkBackgroundColor
                    : selectedItem == title
                    ? HexColor.fromHex("#FFDFDE").withOpacity(0.6)
                    : AppColor.backgroundColor,
              ])),
      child: Container(
        decoration: selectedItem == title
            ? ConcaveDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            depression: 7,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : HexColor.fromHex("#D1D9E6"),
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#E7EBF2").withOpacity(0.30)
                  : Colors.white
            ])
            : BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor),
        child: Center(
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.only(
                  left: title == StringLocalization.kOutBox ? 6.0 : 0),
              child: Image.asset(
                iconPath,
                height: title == StringLocalization.kOutBox ? 23 : 33,
                width: title == StringLocalization.kOutBox ? 24 : 33,
              ),
            ),
            title: Text(
              StringLocalization.of(context).getText(title),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex("#384341")),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: num != null ? Text(
              num != 0 ? num.toString() : "",
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.60)
                      : HexColor.fromHex("#5D6A68")),
            ) : Container(),
          ),
        ),
      ),
    );
  }
}
