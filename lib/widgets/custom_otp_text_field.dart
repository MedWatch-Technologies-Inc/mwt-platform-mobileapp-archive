import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/custom_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
// import 'package:otp_text_field/style.dart';

class CustomOTPTextField extends StatefulWidget {
  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  // final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String> onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String> onCompleted;

  final double spaceBetweenFields;

  final double fieldHeight;

  CustomOTPTextField(
      {this.length = 4,
      this.width = 10,
      this.fieldWidth = 30,
      this.style = const TextStyle(),
      this.textFieldAlignment = MainAxisAlignment.spaceBetween,
      this.obscureText = false,
      // this.fieldStyle = FieldStyle.underline,
      required this.onChanged,
      required this.onCompleted,
      required this.spaceBetweenFields,
      required this.fieldHeight})
      : assert(length > 1);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<CustomOTPTextField> {
  late List<FocusNode> _focusNodes;

  late List<TextEditingController> _textControllers;

  late List<Widget> _textFields;
  late List<String> _pin;

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>.generate(widget.length, (index) => new FocusNode());
    _textControllers =
        List<TextEditingController>.generate(widget.length, (index) => new TextEditingController());

    _pin = List.generate(widget.length, (int i) {
      return '';
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textFields = List.generate(widget.length, (int i) {
      return buildTextField(context, i);
    });
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return Container(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _textFields,
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int i) {
    if (_focusNodes[i] == null) _focusNodes[i] = new FocusNode();

    if (_textControllers[i] == null) _textControllers[i] = new TextEditingController();

    return Row(
      children: [
        Container(
          key: Key('researcherPassword$i'),
          // alignment: Alignment.topCenter,
          width: widget.fieldWidth,
          height: widget.fieldHeight,
          // margin: EdgeInsets.only(right: i== widget.length - 1 ? 0 : 15.w),
          decoration: CustomDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            outerColor: isDarkMode() ? Colors.white : Colors.black,
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _textControllers[i],
              textAlign: TextAlign.center,
              maxLength: 1,
              textAlignVertical: TextAlignVertical.center,
              style: widget.style,
              focusNode: _focusNodes[i],
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                // border: widget.fieldStyle == FieldStyle.box
                //     ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                //     : null
              ),
              onChanged: (String str) {
                // Check if the current value at this position is empty
                // If it is move focus to previous text field.
                if (str.isEmpty) {
                  if (i == 0) return;
                  _focusNodes[i].unfocus();
                  _focusNodes[i - 1].requestFocus();
                }

                // Update the current pin
                setState(() {
                  _pin[i] = str;
                });

                // Remove focus
                if (str.isNotEmpty) _focusNodes[i].unfocus();
                // Set focus to the next field if available
                if (i + 1 != widget.length && str.isNotEmpty)
                  FocusScope.of(context).requestFocus(_focusNodes[i + 1]);

                String currentPin = "";
                _pin.forEach((String value) {
                  currentPin += value;
                });

                // if there are no null values that means otp is completed
                // Call the `onCompleted` callback function provided
                if (!_pin.contains(null) &&
                    !_pin.contains('') &&
                    currentPin.length == widget.length) {
                  widget.onCompleted(currentPin);
                }

                // Call the `onChanged` callback function
                widget.onChanged(currentPin);
              },
            ),
          ),
        ),
        i == widget.length - 1
            ? Container()
            : SizedBox(
                width: widget.spaceBetweenFields,
              ),
      ],
    );
  }
}
