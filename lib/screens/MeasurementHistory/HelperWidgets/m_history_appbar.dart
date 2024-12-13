import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class MHistoryAppbar extends StatelessWidget {
  const MHistoryAppbar({super.key, this.dataCount = 0, this.isBack = true});

  final int dataCount;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        leading: isBack ? IconButton(
          padding: EdgeInsets.only(left: 10),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Theme.of(context).brightness == Brightness.dark
              ? Image.asset(
                  'asset/dark_leftArrow.png',
                  width: 13,
                  height: 18,
                )
              : Image.asset(
                  'asset/leftArrow.png',
                  width: 13,
                  height: 18,
                ),
        ) : SizedBox(),


        title: Text(
          StringLocalization.of(context).getText(StringLocalization.measurementHistory),
          style: TextStyle(
            fontSize: 18,
            color: HexColor.fromHex('62CBC9'),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (dataCount > 0) ...[
            IconButton(
              onPressed: null,
              icon: Text(
                dataCount.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex('62CBC9'),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
