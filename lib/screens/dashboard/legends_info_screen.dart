import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

import '../webview_screen.dart';

class LegendsInfoScreen extends StatefulWidget {
  final String title;
  final String info;
  final String? link;

  LegendsInfoScreen({required this.title, required this.info, this.link});

  @override
  _LegendsInfoScreenState createState() => _LegendsInfoScreenState();
}

class _LegendsInfoScreenState extends State<LegendsInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
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
                Navigator.of(context).pop(true);
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
            title: SizedBox(
                height: 28.h,
                child: TitleText(
                    text: stringLocalization.getText(widget.title),
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(child: dataLayout()),
    );
  }

  Widget dataLayout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 20.h),
      child: Column(children: [
        Text(
          stringLocalization.getText(widget.info),
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
            fontSize: 16.sp,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        widget.link != null ? url() : Container(),
      ]),
    );
  }

  Widget url() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            child: Text(
              '${widget.link}',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16.sp,
                  color: AppColor.primaryColor),
            ),
            onTap: () {
              Constants.navigatePush(
                  WebViewScreen(
                    title: '${widget.title}',
                    url: widget.link,
                  ),
                  context);
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
