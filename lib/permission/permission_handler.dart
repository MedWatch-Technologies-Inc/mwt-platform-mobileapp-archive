import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';

abstract class PermissionHandler {
  final bool showDialogForIOS;
  final bool showDialogForAndroid;

  PermissionHandler({
    this.showDialogForAndroid = true,
    this.showDialogForIOS = false,
  });

  Future<bool> isPermissionGranted();

  Future<bool> handlePermissionFlow(BuildContext context);

  @protected
  Future makeDialog(BuildContext context, String title, String content,
      {bool showNegativeButton = false,
      String? negativeBtnText,
      String? positiveBtnText,
      Function? negativeBtnFn,
      Function? positiveBtnFn}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                key: Key('agreeKey'),
                child: Text(
                  positiveBtnText ?? 'Agree',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: HexColor.fromHex('#00AFAA'),
                  ),
                ),
                onPressed: () {
                  // Close the dialog
                  if (positiveBtnFn != null) {
                    positiveBtnFn();
                  }
                  Navigator.of(context).pop(true);
                },
              ),
              if (showNegativeButton)
                TextButton(
                  key: Key('disagreeKey'),
                  child: Text(
                    negativeBtnText ?? 'Disagree',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex('#00AFAA'),
                    ),
                  ),
                  onPressed: () {
                    // Close the dialog
                    if (negativeBtnFn != null) {
                      negativeBtnFn();
                    }
                    Navigator.of(context).pop(false);
                  },
                ),

            ],
          );
        });
  }
}
