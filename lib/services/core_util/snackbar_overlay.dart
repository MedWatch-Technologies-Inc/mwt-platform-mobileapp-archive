import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/services/theme/change_theme_state.dart';
import 'package:health_gauge/services/theme/theme_bloc.dart';

class SnackbarOverlayHandler {
  final BuildContext context;

  OverlayState? _overlayState;
  OverlayEntrySafeRemove? _currentOverlayEntry;
  bool _isOverlayDisplayed = false;

  SnackbarOverlayHandler({
    required this.context,
  }) {
    _overlayState = Overlay.of(context);
  }

  /// Will display snackbar overlay (1 at a time).
  ///
  /// autoDismiss: is set to true then it will display for 2 secs only
  /// autoDismiss: is set to false by default, and will display for 2 secs only
  Future<void> showSnackbarOverlay(
      {String? message,
      double bottomOffset = 0.0,
      bool autoDismiss = false,
      Duration autoDismissDuration = const Duration(seconds: 4)}) async {
    // we close any existing overlay
    if (_isOverlayDisplayed && _currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
    }

    final overlayEntry = OverlayEntrySafeRemove(
        builder: (context) => SnackbarOverlay(
              message: message!,
              bottomOffset: bottomOffset,
              onDismiss: () {
                if (_currentOverlayEntry != null) {
                  _currentOverlayEntry!.remove();
                }
                _isOverlayDisplayed = false;
              },
            ));
    _currentOverlayEntry = overlayEntry;
    _overlayState!.insert(_currentOverlayEntry!);
    _isOverlayDisplayed = true;

    // if we need to autoDismiss after we waiting for x seconds
    if (autoDismiss) {
      await Future.delayed(autoDismissDuration);

      // if the overlayEntry we created above is still not removed
      // then we remove it
      // if the _currentOverlayEntry is the one we created, then we
      // considered there is no overlay displayed
      if (overlayEntry != null && overlayEntry.removed == false) {
        overlayEntry.remove();
        if (overlayEntry == _currentOverlayEntry) {
          _isOverlayDisplayed = false;
          _currentOverlayEntry = null;
        }
      }
    }
  }
}

class SnackbarOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;
  final double bottomOffset;

  SnackbarOverlay({
    required this.message,
    required this.onDismiss,
    this.bottomOffset = 0.0,
  });

  @override
  _SnackbarOverlayState createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<SnackbarOverlay> {
  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bottomPadding = bottomPadding > 0.0 ? bottomPadding : 20.0;
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState themeState) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20.0, 20.0, 20.0, bottomPadding + widget.bottomOffset),
            child: _buildCard(themeState.themeData),
          ),
        );
      },
    );
  }

  Widget _buildCard(ThemeData themeData) {
    return Material(
      type: MaterialType.card,
      color: themeData.primaryColorDark,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildMessage(themeData.primaryColor),
            _buildButton(themeData),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Color textColor) {
    return Expanded(
      child: AutoSizeText(widget.message,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: textColor,
              )),
    );
  }

  Widget _buildButton(ThemeData themeData) {
    return TextButton(
      onPressed: widget.onDismiss,
      child: Text(
        'button_dismiss',
        style: TextStyle(color: themeData.colorScheme.secondary),
      ),
    );
  }
}

///
/// https://github.com/flutter/flutter/issues/30479
class OverlayEntrySafeRemove extends OverlayEntry {
  bool removed = false;

  OverlayEntrySafeRemove({
    required WidgetBuilder builder,
    bool opaque = false,
    bool maintainState = false,
  }) : super(builder: builder, opaque: opaque, maintainState: maintainState);

  @override
  void remove() {
    if (!removed) {
      super.remove();
      removed = true;
    }
  }
}
