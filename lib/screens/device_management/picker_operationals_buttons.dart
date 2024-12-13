import 'package:flutter/material.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';

class PickerOperationalButtons extends StatelessWidget {
  const PickerOperationalButtons({
    this.positiveTitle = 'Confirm',
    this.negativeTitle = 'Cancel',
    this.positiveCallback,
    this.negativeCallback,
    super.key,
  });

  final String? positiveTitle;
  final String? negativeTitle;
  final VoidCallback? positiveCallback;
  final VoidCallback? negativeCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatBtn(
            onPressed: positiveCallback ??
                () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
            text: positiveTitle ?? stringLocalization.getText(StringLocalization.confirm).toUpperCase(),
            color: Colors.white,
            backgroundColor: AppColor.primaryColor.withOpacity(0.75),
            padding: EdgeInsets.symmetric(horizontal: 12.5,vertical: 1),
            radius: 5,
          ),
          FlatBtn(
            onPressed: negativeCallback ??
                () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
            text: negativeTitle ?? stringLocalization.getText(StringLocalization.cancel).toUpperCase(),
            color: Colors.white,
            backgroundColor: Colors.redAccent.withOpacity(0.75),
            padding: EdgeInsets.symmetric(horizontal: 12.5,vertical: 1),
            radius: 5,
          ),
        ],
      ),
    );
  }
}
