import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class HeartRateAppBar extends StatefulWidget {
  const HeartRateAppBar({Key? key}) : super(key: key);

  @override
  _HeartRateAppBarState createState() => _HeartRateAppBarState();
}

class _HeartRateAppBarState extends State<HeartRateAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.5)
              : HexColor.fromHex("#384341").withOpacity(0.2),
          offset: Offset(0, 2.0),
          blurRadius: 4.0,
        )
      ]),
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        leading: Visibility(
          visible: Navigator.of(context).canPop(),
          child: IconButton(
            padding: EdgeInsets.only(left: 10),
            onPressed: () {
              if(Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
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
        title: Text(
          StringLocalization.of(context).getText(StringLocalization.heartRateHistory),
          style: TextStyle(
              fontSize: 18,
              color: HexColor.fromHex("62CBC9"),
              fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
