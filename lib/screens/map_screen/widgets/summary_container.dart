import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  final String unit;
  final String title;
  final String stringUnit;
  SummaryContainer(this.unit, this.title, this.stringUnit, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          unit,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        if (stringUnit == '')
          Text('')
        else
          Text('($stringUnit)',
              style: TextStyle(
                fontSize: 10,
              ))
      ],
    );
  }
}
