import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.onChange,
     this.onTap,
    required this.controller,
    this.inputFormatter,
    this.hintText = '',
    this.hintColor,
    this.errorColor = Colors.redAccent,
    this.maxLength,
    this.prefix,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.textInputAction,
    this.margin,
    this.validator,
    this.isError = false,
    this.isReadOnly = false,
    this.errorMessage = '',
    this.onEditComplete,
    super.key,
  });

  final Function(String) onChange;
  final Function()? onTap;
  final Function()? onEditComplete;
  final List<TextInputFormatter>? inputFormatter;
  final TextEditingController controller;
  final String hintText;
  final Widget? prefix;
  final TextAlign textAlign;
  final Color? hintColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? margin;
  final String? Function(String?)? validator;
  final bool isError;
  final bool isReadOnly;
  final int? maxLength;
  final Color errorColor;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5.w, -5.h),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5.w, 5.h),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  key: Key('minValueText'),
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: ConcaveDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                    depression: 7,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.5)
                          : HexColor.fromHex('#D1D9E6'),
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                          : Colors.white,
                    ],
                  ),
                  child: TextFormField(
                    readOnly: isReadOnly,
                    controller: controller,
                    // autocorrect: true,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: hintColor,
                      ),
                      prefix: prefix,
                      // errorText: errorMessage
                      
                      
                    ),
                    validator: validator,
                    maxLength: maxLength,
                    textAlign: textAlign! ,
                    inputFormatters: inputFormatter,
                    keyboardType: keyboardType,
                    onChanged: onChange,
                    onTap: onTap,
                    onEditingComplete: onEditComplete,
                    textInputAction: textInputAction,
                    
                  ),
                ),
              ],
            ),
          ),
          if(isError)...[
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(
                errorMessage,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: errorColor ,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
