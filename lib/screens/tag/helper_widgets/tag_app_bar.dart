import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class TagAppBar extends StatelessWidget {
  const TagAppBar({super.key, this.showNavigators = false});

  final bool showNavigators;

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
        leading: showNavigators
            ? IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  connections.disconnectWeightDevice();
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
              )
            : SizedBox(),
        title: TitleText(
            text: StringLocalization.of(context).getText(StringLocalization.tagScreenSlctn),
            fontSize: 18.sp,
            color: HexColor.fromHex('62CBC9'),
            fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
    );
  }
}
