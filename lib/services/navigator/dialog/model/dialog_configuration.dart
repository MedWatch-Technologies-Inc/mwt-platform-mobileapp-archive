import 'dart:ui';

import 'package:health_gauge/services/navigator/helpers/navigator_utils.dart';

class DialogConfiguration {
  Color? animationColor;
  Color? backgroundColor;
  EnumPageIntent pageIntent;
  bool isDarkThemeSupported;

  DialogConfiguration({
    required this.pageIntent,
    this.animationColor,
    this.backgroundColor,
    this.isDarkThemeSupported = true,
  });

}
