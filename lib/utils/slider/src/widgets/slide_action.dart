import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/value/app_color.dart';


const bool _kCloseOnTap = true;

/// Abstract class for slide actions that can close after [onTap] occurred.
abstract class ClosableSlideAction extends StatelessWidget {
  /// Creates a slide that closes when a tap has occurred if [closeOnTap]
  /// is [true].
  ///
  /// The [closeOnTap] argument must not be null.
  const ClosableSlideAction({
    Key? key,
    this.color,
     this.onTap,
     this.height,
     this.leftMargin,
     this.rightMargin,
     this.topMargin,
    this.closeOnTap = _kCloseOnTap,
    this.boxDecoration,
  })  : assert(closeOnTap != null),
        super(key: key);

  final BoxDecoration? boxDecoration;
  /// The background color of this action.
  final Color? color;

  /// A tap has occurred.
  final VoidCallback? onTap;

  /// Whether close this after tap occurred.
  ///
  /// Defaults to true.
  final bool closeOnTap;

  /// height of conatiner
  final double? height;

  ///margin from top
  final double? topMargin;

  ///margin from left
  final double? leftMargin;
  ///margin from right
  final double? rightMargin;


  /// Calls [onTap] if not null and closes the closest [Slidable]
  /// that encloses the given context.
  void _handleCloseAfterTap(BuildContext context) {
    onTap?.call();
    Slidable.of(context)?.close();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding:  EdgeInsets.only(top: topMargin ?? 0,right: rightMargin ?? 0, left: leftMargin ?? 0),
        child: Container(
          height: height,
          width: 86,
          decoration: boxDecoration??BoxDecoration(
            color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(-4, -4),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex("#9F2DBC").withOpacity(0.15),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(4, 4),
                ),
              ]
          ),
          child: InkWell(
            onTap: !closeOnTap ? onTap : () => _handleCloseAfterTap(context),
            child: buildAction(context),
          ),
        ),
      ),
    );
  }

  /// Builds the action.
  @protected
  Widget buildAction(BuildContext context);
}

/// A basic slide action with a background color and a child that will
/// be center inside its area.
class SlideAction extends ClosableSlideAction {
  /// Creates a slide action with a child.
  ///
  /// The `color` argument is a shorthand for `decoration:
  /// BoxDecoration(color: color)`, which means you cannot supply both a `color`
  /// and a `decoration` argument. If you want to have both a `color` and a
  /// `decoration`, you can pass the color as the `color` argument to the
  /// `BoxDecoration`.
  ///
  /// The [closeOnTap] argument must not be null.
  SlideAction({
    Key? key,
    required this.child,
    required VoidCallback onTap,
    Color? color,
    Decoration? decoration,
    bool closeOnTap = _kCloseOnTap,
  })  : assert(child != null),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'The color argument is just a shorthand for "decoration:  BoxDecoration(color: color)".'),
        decoration =
            decoration ?? (color != null ? BoxDecoration(color: color) : null),
        super(
          key: key,
          onTap: onTap,
          closeOnTap: closeOnTap,
          color: color ?? Colors.transparent,
        );

  /// The decoration to paint behind the [child].
  ///
  /// A shorthand for specifying just a solid color is available in the
  /// constructor: set the `color` argument instead of the `decoration`
  /// argument.
  final Decoration? decoration;

  /// The [child] contained by the slide action.
  final Widget child;

  @override
  Widget buildAction(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Center(
        child: child,
      ),
    );
  }
}

/// A basic slide action with an icon, a caption and a background color.
class IconSlideAction extends ClosableSlideAction {
  /// Creates a slide action with an icon, a [caption] if set and a
  /// background color.
  ///
  /// The [closeOnTap] argument must not be null.
  /// The icon to show.

  const IconSlideAction({
    Key? key,
    this.icon,
    this.iconWidget,
    this.caption,
     Color? color,
     this.height,
     this.topMargin,
    this.leftMargin,
    this.rightMargin,
    this.foregroundColor,
    VoidCallback? onTap,
    bool closeOnTap = _kCloseOnTap,
    final BoxDecoration? boxDecoration,
  })  : color = color ?? Colors.white,
        assert(icon != null || iconWidget != null,
            'Either set icon or iconWidget.'),
        super(
          key: key,
          color: color,
          onTap: onTap,
          closeOnTap: closeOnTap,
          boxDecoration: boxDecoration,
        );
  final IconData? icon;

  /// A custom widget to represent the icon.
  /// If both [icon] and [iconWidget] are set, they will be shown at the same
  /// time.
  final Widget? iconWidget;

  /// The caption below the icon.
  final String? caption;

  /// The background color.
  ///
  /// Defaults to [Colors.white].
  final Color color;

  /// The color used for [icon] and [caption].
  final Color? foregroundColor;

  /// height of container
  final double? height;

  ///margin from top
  final double? topMargin;

  ///margin from left
  final double? leftMargin;
  ///margin from right
  final double? rightMargin;

  @override
  Widget buildAction(BuildContext context) {
    final Color estimatedColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white;

    final List<Widget> widgets = [];

    if (icon != null) {
      widgets.add(
        Flexible(
          child: new Icon(
            icon,
            color: foregroundColor ?? estimatedColor,
          ),
        ),
      );
    }

    if (iconWidget != null) {
      widgets.add(
        Flexible(child: iconWidget!),
      );
    }

    if (caption != null) {
      widgets.add(
        Flexible(
          child: Text(
            caption!,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .primaryTextTheme
                .bodySmall!
                .copyWith(color: foregroundColor ?? estimatedColor),
          ),
        ),
      );
    }

    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      ),
    );
  }
}
