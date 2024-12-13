import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final GestureTapCallback onTap;
  CustomFloatingActionButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: Key('mailComposeScreen'),
      elevation: 0,
      child: Container(
        height: 57,
        width: 57,
        decoration: BoxDecoration(
            color: HexColor.fromHex("#00AFAA"),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#D1D9E6").withOpacity(0.12)
                    : Colors.transparent,
                blurRadius: 7,
                spreadRadius: 0,
                offset: Offset(-4, -4),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex("#BD78CE").withOpacity(0.8),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(4, 4),
              ),
            ]),
        child: Container(
            decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(57),
                ),
                depression: 20,
                colors: [
                  Colors.white.withOpacity(0.8),
                  HexColor.fromHex("#D1D9E6").withOpacity(0.8),
                ]),
            padding: EdgeInsets.all(18),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark ? "asset/plus_icon_dark.png" : "asset/plus_icon.png",
            )),
      ),
      onPressed: onTap
    );
  }
}
