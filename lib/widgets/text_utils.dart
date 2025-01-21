import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaptionText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;

  CaptionText({required this.text, this.color, this.align, this.maxLine});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      softWrap: true,
      textAlign: align,
      style: style(context)
          .copyWith(fontSize: 8, color: color ?? Theme.of(context).textTheme.bodySmall!.color),
      maxLines: maxLine,
      minFontSize: 6,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.bodySmall!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.bodySmall!;
    }
  }
}

class SmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int maxLine;

  SmallText({required this.text, this.color, this.align, required this.maxLine});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      softWrap: true,
      textAlign: align,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12.0, color: color ?? Theme.of(context).textTheme.bodySmall!.color),
      maxLines: maxLine,
      minFontSize: 10,
    );
  }
}

class Body1AutoText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final double? fontSize;
  final bool? softWrap;
  final FontWeight? fontWeight;
  final double? minFontSize;
  final TextDecoration? decoration;
  final TextOverflow? overflow;

  Body1AutoText(
      {required this.text,
      this.color,
      this.align,
      this.maxLine,
      this.softWrap,
      this.fontSize,
      this.fontWeight,
      this.minFontSize,
      this.decoration,
      this.overflow});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: decoration ?? TextDecoration.none,
      ),
      maxLines: maxLine ?? 1,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.bodyLarge!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.bodyLarge!;
    }
  }
}

class Body1Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final double? fontSize;
  final bool? softWrap;
  final TextOverflow? textOverflow;
  final double? minFontSize;
  final FontWeight? fontWeight;

  Body1Text(
      {required this.text,
      this.color,
      this.align,
      this.maxLine,
      this.softWrap,
      this.fontSize,
      this.textOverflow,
      this.minFontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize ?? 16.sp,
        color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
      overflow: textOverflow,
      // style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0175 , color: color),
      maxLines: maxLine,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.bodyLarge!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.bodyLarge!;
    }
  }
}

class Body2Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final double? fontSize;
  final FontWeight? fontWeight;

  Body2Text(
      {required this.text, this.color, this.align, this.maxLine, this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize ?? 14.sp,
        color: color ?? Theme.of(context).textTheme.bodyMedium!.color,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
      // style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, color: color, fontWeight: FontWeight.w500),
      maxLines: maxLine,
      minFontSize: 8,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.bodyLarge!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.bodyLarge!;
    }
  }
}

class SubTitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final FontWeight? fontWeight;

  SubTitleText({required this.text, this.color, this.align, this.maxLine, this.fontWeight});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      textAlign: align,
      style: style(context).copyWith(
        fontSize: 16,
        color: color ?? Theme.of(context).textTheme.titleSmall!.color,
        fontWeight: fontWeight,
      ),
      maxLines: maxLine,
      minFontSize: 12,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.bodySmall!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.bodySmall!;
    }
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final double? fontSize;
  final FontWeight? fontWeight;

  TitleText(
      {required this.text, this.color, this.align, this.maxLine, this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      textAlign: align,
      style: TextStyle(
          fontSize: fontSize ?? 18.0,
          fontStyle: FontStyle.normal,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? Theme.of(context).textTheme.headlineSmall!.color),
      maxLines: maxLine ?? 1,
      minFontSize: 8,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.headlineSmall!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.headlineSmall!;
    }
  }
}

class SubHeadText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;

  SubHeadText({required this.text, this.color, this.align, this.maxLine});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return Text(
      text,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style:
          TextStyle(fontSize: 20.0, color: color ?? Theme.of(context).textTheme.titleSmall!.color),
      maxLines: maxLine,
    );
  }
}

class HeadlineText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final double? fontSize;

  HeadlineText({required this.text, this.color, this.align, this.maxLine, this.fontSize});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      textAlign: align,
      style: style(context).copyWith(
          fontSize: fontSize ?? 22, color: color ?? Theme.of(context).textTheme.headlineSmall!.color),
      maxLines: maxLine,
      minFontSize: 8,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.displayLarge!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.displayLarge!;
    }
  }
}

class Display1Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final double? fontSize;

  Display1Text({required this.text, this.color, this.align, this.maxLine, this.fontSize});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      textAlign: align,
      style: style(context).copyWith(
          fontSize: fontSize ?? 24,
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).textTheme.headlineSmall!.color),
      maxLines: maxLine ?? 1,
      minFontSize: 15,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.displayLarge!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.displayLarge!;
    }
  }
}

class Display2Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final int? maxLine;
  final FontWeight? fontWeight;
  final double? fontSize;

  Display2Text(
      {required this.text, this.color, this.align, this.maxLine, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    return AutoSizeText(
      text,
      softWrap: true,
      textAlign: align,
      overflow: TextOverflow.ellipsis,
      style: style(context).copyWith(
          fontSize: fontSize ?? 34,
          fontWeight: fontWeight ?? FontWeight.bold,
          color: color ?? Theme.of(context).textTheme.headlineSmall!.color),
      maxLines: maxLine,
      minFontSize: 26,
    );
  }

  TextStyle style(BuildContext context) {
    if (color != null) {
      return Theme.of(context).textTheme.displayLarge!.copyWith(color: this.color);
    } else {
      return Theme.of(context).textTheme.displayLarge!;
    }
  }
}

class Rich1Text extends StatelessWidget {
  final String text1;
  final String text2;
  final Color? color1;
  final Color? color2;
  final TextAlign? align;
  final FontWeight? fontWeight1;
  final FontWeight? fontWeight2;
  final double? fontSize1;
  final double? fontSize2;

  Rich1Text(
      {required this.text1,
      required this.text2,
      this.color1,
      this.color2,
      this.align,
      this.fontWeight1,
      this.fontWeight2,
      this.fontSize1,
      this.fontSize2});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: align ?? TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: TextStyle(
              fontSize: fontSize1,
              color: color1,
              fontWeight: fontWeight2,
            ),
          ),
          TextSpan(
            text: text2,
            style: TextStyle(
              fontSize: fontSize2,
              color: color2,
              fontWeight: fontWeight2,
            ),
          )
        ],
      ),
    );
  }
}
