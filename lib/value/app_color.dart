import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

class AppColor {
  static Color primaryColor = Color(0xFF009C92);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color trans = Colors.transparent;
  static Color gray = Colors.grey[100]!;
  static Color graydark = Colors.grey[400]!;

  static Color orangeColor = primaryColor.withOpacity(0.5);
  static Color green = primaryColor;
  static Color red = Colors.redAccent;
  // static Color darkRed = Color(0xFF883c46);
  static Color darkRed = HexColor.fromHex("#883c46");
  // static Color darkRed = Color(0xFF6A56A6);

  static Color stayUp = Colors.redAccent;
  static Color sleep = primaryColor;
  static Color lightSleep = primaryColor.withOpacity(0.5);
  static Color allSleep = Colors.brown;
  static Color deepSleep = primaryColor;
  static Color wakeUpHalfWay = primaryColor.withOpacity(0.5);
  static Color getUp = primaryColor.withOpacity(0.5);

  static Color hrColor = Colors.red;
  static Color hrVColor = Colors.teal;
  static Color bpColor = Colors.green;
  static Color stepColor = Colors.blue;

  static Color progressColor = Color(0XFF81D6D4);
  static Color purpleColor = Color(0XFF9F2DBC);
  static Color deepSleepColor = Color(0XFF00AFAA);
  static Color lightSleepColor = Color(0XFF99D9D9);
  static Color selectedItemColor = Color(0XFFFF6259);
  static Color selectedProgress = Color(0XFF00AFAA);

  static Color unSelectedItemColor = Color(0XFFFF9E99);

  static Color backgroundColor = HexColor.fromHex("#EEF1F1");
  static Color darkBackgroundColor = HexColor.fromHex("#111B1A");
  static Color lowBpColor = HexColor.fromHex("#99D9D9");
  static Color normalBpColor = HexColor.fromHex("#00AFAA");
  static Color preBpColor = HexColor.fromHex("#BD78CE");
  static Color hyperBpColor = HexColor.fromHex("#9F2DBC");

  // colors used in app
  static Color white87 = Colors.white.withOpacity(0.87);
  static Color white60 = Colors.white.withOpacity(0.6);
  static Color white38 = Colors.white.withOpacity(0.38);
  static Color white15 = Colors.white.withOpacity(0.15);
  static Color color384341 = HexColor.fromHex('#384341');
  static Color color5D6A68 = HexColor.fromHex('#5D6A68');
  static Color appBarTitleColor = HexColor.fromHex('#62CBC9');
  static Color colorFFDFDE = HexColor.fromHex('#FFDFDE');
  static Color colorFF9E99 = HexColor.fromHex('#FF9E99');
  static Color colorFF6259 = HexColor.fromHex('#FF6259');
  static Color colorCC0A00 = HexColor.fromHex('#CC0A00');
  static Color color980C23 = HexColor.fromHex('#980C23');
  static Color color7F8D8C = HexColor.fromHex('#7F8D8C');
  static Color color9F2DBC = HexColor.fromHex('#9F2DBC');
  static Color colorBD78CE = HexColor.fromHex('#BD78CE');
  static Color color00AFAA = HexColor.fromHex("#00AFAA");
  static Color color62CBC9 = HexColor.fromHex("#62CBC9");
  static Color color111B1A = HexColor.fromHex("#111B1A");
  static Color colorD9E0E0 = HexColor.fromHex("#D9E0E0");
}

extension HexColor on material.Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
