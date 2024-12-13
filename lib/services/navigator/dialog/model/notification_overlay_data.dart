class NotificationOverlayData {
  String? message;
  String? positiveButtonText;
  String? negativeButtonText;
  Function? positiveCallback;
  Function? negativeCallback;
  bool autoHide;
  bool isNegativeButtonRequire;

  NotificationOverlayData({
    this.message,
    this.positiveButtonText,
    this.positiveCallback,
    this.negativeButtonText,
    this.negativeCallback,
    this.autoHide = true,
    this.isNegativeButtonRequire = false,
  });
}
