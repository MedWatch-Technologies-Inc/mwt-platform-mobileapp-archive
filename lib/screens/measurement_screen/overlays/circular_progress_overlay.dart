


import 'package:flutter/material.dart';

class CircularProgressOverlay extends StatelessWidget {
  const CircularProgressOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: CircularProgressIndicator()),
        color: Colors.black26,
      ),
    );
  }
}
