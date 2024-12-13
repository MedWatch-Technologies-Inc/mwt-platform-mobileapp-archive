import 'package:flutter/material.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class OHistoryAppbar extends StatelessWidget {
  const OHistoryAppbar({
    required this.showAction,
    this.title = '',
    this.onPressed,
    super.key,
  });

  final String title;
  final bool showAction;
  final Function()? onPressed;

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
        leading: IconButton(
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
        ),
        actions: showAction
            ? [
          IconButton(
            onPressed: onPressed,
            icon: Image.asset(
              'asset/reload.png',
              height: 28,
              width: 28,
            ),
          ),
        ]
            : [],
        title: Text(
          title.isNotEmpty
              ? title
              : StringLocalization.of(context).getText(StringLocalization.temperatureHistory),
          style: TextStyle(
            fontSize: 18,
            color: HexColor.fromHex('62CBC9'),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
