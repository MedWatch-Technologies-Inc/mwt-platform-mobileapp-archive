class OverlayDialogData {
  String? dialogText;
  OverlayDialog? dialogType;

  OverlayDialogData({
    this.dialogText = '',
    this.dialogType = OverlayDialog.defaultDialog,
  });
}

enum OverlayDialog {
  defaultDialog,
  noInternetDialog,
  internetRecoverDialog,
  asrDialog,
}
