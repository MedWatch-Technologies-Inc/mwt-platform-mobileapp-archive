import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/hr_day_item.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/hr_history_appbar.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class HRListing extends StatelessWidget {
  HRListing({super.key});

  final HRHelper _helper = HRHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: HRHistoryAppbar(
            showAction: false,
            title: _helper.appbarTitle,
          ),
        ),
        body: _helper.dayData.value.isEmpty
            ? Container(
                height: 250.h,
                child: Center(
                  child: Body1AutoText(
                    text: StringLocalization.of(context).getText(StringLocalization.noDataFound),
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 5.h),
                itemCount: _helper.dayData.value.length,
                itemBuilder: (BuildContext context, int index) {
                  var e = _helper.dayData.value.elementAt(index);
                  return HRDayItem(
                    syncHRModel: e,
                    sizeDifference: 0.h,
                    isDay: true,
                  );
                },
              ),
      ),
    );
  }
}
