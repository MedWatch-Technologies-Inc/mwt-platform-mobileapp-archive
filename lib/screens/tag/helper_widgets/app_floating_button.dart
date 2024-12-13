import 'package:flutter/material.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';

class AppFloatingButton extends StatelessWidget {
  const AppFloatingButton({
    required this.onPressed,
    this.widgetKey,
    this.child,
    this.iconPath = '',
    super.key,
  });

  final VoidCallback onPressed;
  final Key? widgetKey;
  final Widget? child;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
      ),
      elevation: 0,
      backgroundColor: HexColor.fromHex('62CBC9'),
      child: Padding(
        key: widgetKey,
        padding: EdgeInsets.all(18),
        child: child ??
            Image.asset(
              iconPath,
              color: Colors.white,
            ),
      ),
      onPressed: onPressed,
    );
  }
}
