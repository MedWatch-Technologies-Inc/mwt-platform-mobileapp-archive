import 'package:flutter/material.dart';

import 'navigator_utils.dart';

class NavigatorTransition extends StatefulWidget {
  final Widget child;
  final EnumPageIntent? pageIntent;

  const NavigatorTransition({required this.child, this.pageIntent});

  @override
  State<StatefulWidget> createState() => _NavigatorTransitionState();
}

class _NavigatorTransitionState extends State<NavigatorTransition>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageIntent == EnumPageIntent.homePage) {
      // If home perform simple fade animation
      return FadeTransition(
        opacity: _animation,
        child: widget.child,
      );
    }
    // Perform zoom for other than Home pages
    return _ZoomTransition(
      child: widget.child,
      animationController: controller,
    );
  }
}


class _ZoomTransition extends StatefulWidget {
  _ZoomTransition({
    required this.child,
    required this.animationController,
    Key? key,
  })  : super(key: key);

  final Widget child;
  final AnimationController animationController;

  @override
  _ZoomTransitionState createState() => _ZoomTransitionState();
}

class _ZoomTransitionState extends State<_ZoomTransition>
    with SingleTickerProviderStateMixin {
  Animation<double>? _fadeAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    // _fadeAnimation = widget.animationController.drive(Tween(begin: 0, end: 1));
    // _scaleAnimation =
    //     widget.animationController.drive(Tween(begin: 0.8, end: 1));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
    // return FadeTransition(
    //   opacity: _fadeAnimation,
    //   child: ScaleTransition(
    //     scale: _scaleAnimation,
    //     child: widget.child,
    //   ),
    // );
  }
}
