import 'package:flutter/material.dart';
import 'package:health_gauge/screens/trends/helper_widgets/trend_switch.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class TrendTile extends StatelessWidget {
  const TrendTile({
    required this.title,
    required this.selectedValue,
    required this.trendType,
    super.key,
  });

  final String title;
  final bool selectedValue;
  final TrendType trendType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringLocalization.of(context).getText(title)),
      trailing: Padding(
        padding: EdgeInsets.zero,
        child: TrendSwitch(
          value: selectedValue,
          trendType: trendType,
        ),
      ),
    );
  }
}
