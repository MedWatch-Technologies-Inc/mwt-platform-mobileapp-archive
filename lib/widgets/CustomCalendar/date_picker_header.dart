// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//import '../color_scheme.dart';
//import '../icon_button.dart';
//import '../material.dart';
//import '../text_theme.dart';
//import '../theme.dart';


//import 'date_picker_common.dart';

// This is an internal implementation file. Even though there are public
// classes and functions defined here, they are only meant to be used by the
// date picker implementation and are not exported as part of the Material library.
// See pickers.dart for exactly what is considered part of the public API.

 double _datePickerHeaderLandscapeWidth = 152.0.w;
 double _datePickerHeaderPortraitHeight = 95.0.h;
 double _headerPaddingLandscape = 16.0.h;

/// Re-usable widget that displays the selected date (in large font) and the
/// help text above it.
///
/// These types include:
///
/// * Single Date picker with calendar mode.
/// * Single Date picker with manual input mode.
/// * Date Range picker with manual input mode.
///
/// [helpText], [orientation], [icon], [onIconPressed] are required and must be
/// non-null.
class CustomDatePickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  const CustomDatePickerHeader({
    Key? key,
    required this.helpText,
    required this.titleText,
    this.titleSemanticsLabel,
    required this.titleStyle,
    required this.orientation,
    this.isShort = false,
    this.mode,
    required this.icon,
    required this.iconTooltip,
    required this.onIconPressed,
  }) : assert(helpText != null),
       assert(orientation != null),
       assert(isShort != null),
       super(key: key);


  final DatePickerEntryMode? mode;
  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// The text that is displayed at the center of the header.
  final String titleText;

  /// The semantic label associated with the [titleText].
  final String? titleSemanticsLabel;

  /// The [TextStyle] that the title text is displayed with.
  final TextStyle titleStyle;

  /// The orientation is used to decide how to layout its children.
  final Orientation orientation;

  /// Indicates the header is being displayed in a shorter/narrower context.
  ///
  /// This will be used to tighten up the space between the help text and date
  /// text if `true`. Additionally, it will use a smaller typography style if
  /// `true`.
  ///
  /// This is necessary for displaying the manual input mode in
  /// landscape orientation, in order to account for the keyboard height.
  final bool isShort;

  /// The mode-switching icon that will be displayed in the lower right
  /// in portrait, and lower left in landscape.
  ///
  /// The available icons are described in [Icons].
  final IconData icon;

  /// The text that is displayed for the tooltip of the icon.
  final String iconTooltip;

  /// Callback when the user taps the icon in the header.
  ///
  /// The picker will use this to toggle between entry modes.
  final VoidCallback onIconPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // The header should use the primary color in light themes and surface color in dark
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color primarySurfaceColor = isDark ? colorScheme.surface : colorScheme.primary;
    final Color onPrimarySurfaceColor = isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    final TextStyle? helpStyle = textTheme.labelSmall?.copyWith(
      color: isDark ?  Color(0xffffffff).withOpacity(0.87) : Color(0xff384341),
      fontSize: 10.sp,
    );

    final Text help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final Text title = Text(
      titleText,
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: TextStyle(
        color: isDark ?  Color(0xffffffff).withOpacity(0.87) :Color(0xff384341),
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      ),
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );
    final IconButton icon = IconButton(
      key: Key('datePickerEdit'),
      padding: EdgeInsets.all(0),
      icon: mode == DatePickerEntryMode.calendar ?
      Image.asset(
        'asset/edit_icon.png',
        width: 26,
        height: 26,
      ) : Image.asset(
        'asset/setting_calendar.png',
        width: 26,
        height: 26,
      ),
      // color: onPrimarySurfaceColor,
      tooltip: iconTooltip,
      onPressed: onIconPressed,
    );

    switch (orientation) {
      case Orientation.portrait:
         return SizedBox(
           height: _datePickerHeaderPortraitHeight,
           child: Material(
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
             ),
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                 color: isDark ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
               ),
               child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [
                         isDark ? HexColor.fromHex('#9F2DBC').withOpacity(0.2) : Color.fromRGBO(159, 45, 188, 0.0345),
                         isDark ? HexColor.fromHex('#CC0A00').withOpacity(0.2)  :  Color.fromRGBO(255, 158, 153, 0.15),
                       ]
                   ),
                 ),
                 child: Padding(
                 padding: const EdgeInsetsDirectional.only(
                   start: 23,
                   end: 12,
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                      SizedBox(height: 15.h),
                     Container(height: 25.h,child: help),
                      SizedBox(height: 15.h),
                     Container(
                       height: 35.h,
                       child: Row(
                         children: <Widget>[
                           Expanded(
                             child: Container(
                                   width: 196.w,
                                 child: title),
                           ),
                           SizedBox(width: 30.w,),
                           icon,
                         ],
                       ),
                     ),
                     SizedBox(height: 5.h),
                   ],
                 ),
               ),
           ),
             ),)
         );
      case Orientation.landscape:
        return SizedBox(
          width: _datePickerHeaderLandscapeWidth,
          child: Material(
            color: primarySurfaceColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 SizedBox(height: 16.h),
                Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: help,
                ),
                SizedBox(height: isShort ? 16.h : 56.h),
                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal: _headerPaddingLandscape,
                    ),
                    child: title,
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 4.w,
                  ),
                  child: icon,
                ),
              ],
            ),
          ),
        );
    }
  }
}
