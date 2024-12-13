import 'package:flutter/material.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class NoDatFoundScreen extends StatefulWidget {
  @override
  _NoDatFoundScreenState createState() => _NoDatFoundScreenState();
}

class _NoDatFoundScreenState extends State<NoDatFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(new AppImages().empty, height: 50, width: 50.0),
          SizedBox(height: 20.0),
          Display1Text(text: "Opps!", color: Colors.red),
          SizedBox(height: 10.0),
          Body1AutoText(text: "Something Went Wrong"),
        ],
      ),
    );
  }
}
