import 'package:flutter/material.dart';

OverlayEntry showOverlay(BuildContext context) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: CircularProgressIndicator()),
        color: Colors.black26,
      ),
    ),
  );
  if(overlayState != null) overlayState.insert(overlayEntry);
  return overlayEntry;
}