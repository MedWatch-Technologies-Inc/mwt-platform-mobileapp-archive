import 'package:flutter/material.dart';

class CustomMapDivider extends StatelessWidget {
  const CustomMapDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.15)
          : Color(0xffD9E0E0),
    );
  }
}
