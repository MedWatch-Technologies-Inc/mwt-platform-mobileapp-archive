class HelpItemModel {
  String title;
  String detail;
  String image;
  List<HelpItemModel> listInfo;
  bool showDivider;

  HelpItemModel({
    required this.title,
    required this.detail,
    required this.image,
    this.listInfo = const <HelpItemModel>[],
    this.showDivider = true,
  });
}
