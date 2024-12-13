import 'package:flutter/material.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';

class CustomSearchWidget extends StatelessWidget {
  final String? hintText;
  final double? fontSize;
  final FontWeight? fontWeight;
  final prefixIcon;
  final Function(String?) onChanged;
  final bool? isDense;
  final TextEditingController textEditingController;

  const CustomSearchWidget(
      {this.isDense,
      required this.onChanged,
      required this.textEditingController,
      this.prefixIcon,
      this.hintText,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    // TextEditingController textEditingController = TextEditingController();
    return Container(
      padding: EdgeInsets.only(top: 16, left: 13, right: 13, bottom: 10),
      child: Container(
        height: 56,
        decoration: ConcaveDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            depression: 7,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#000000").withOpacity(0.8)
                  : HexColor.fromHex("#D1D9E6"),
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : Colors.white,
            ]),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: TextField(
            controller: textEditingController,
            style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.w500,
                fontSize: fontSize ?? 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                    : HexColor.fromHex("#384341")),
            onChanged: onChanged,
            decoration: InputDecoration(
                isDense: isDense ?? false,
                prefixIcon: prefixIcon ?? null,
filled: true,
                fillColor: Theme.of(context).brightness != Brightness.dark ? Colors.black12  :Colors.white10,
                // prefixStyle: TextStyle(),
                //
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hintText ?? 'Search',
                hintStyle: TextStyle(
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontSize: (fontSize ?? 14),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                      : HexColor.fromHex("#7F8D8C"),
                )),
          ),
        ),
      ),
    );
  }
}
