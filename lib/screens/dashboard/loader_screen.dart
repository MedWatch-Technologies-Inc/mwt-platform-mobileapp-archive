import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class CircularProgressIndicatorScreen extends StatefulWidget {
  final GestureTapCallback onClickBackgroundBtn;

  const CircularProgressIndicatorScreen(
      {Key? key, required this.onClickBackgroundBtn})
      : super(key: key);

  @override
  _CircularProgressIndicatorScreenState createState() =>
      _CircularProgressIndicatorScreenState();
}

class _CircularProgressIndicatorScreenState
    extends State<CircularProgressIndicatorScreen> {
  bool allowFetchInBackground = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 12)).then((value) {
      if (mounted) {
        allowFetchInBackground = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.5),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    radius: 20.r,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Body1Text(
                      text: 'Fetching data from the watch...',
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: kToolbarHeight, horizontal: 30.w),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: allowFetchInBackground,
                  child: GestureDetector(
                    child: RaisedBtn(
                      text: stringLocalization
                          .getText(StringLocalization.doItInTheBackground),
                      onPressed: widget.onClickBackgroundBtn,
                      radius: 14.r,
                      // color: Colors.black,
                      // elevation: 0,
                    ),
                    onTap: widget.onClickBackgroundBtn,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
