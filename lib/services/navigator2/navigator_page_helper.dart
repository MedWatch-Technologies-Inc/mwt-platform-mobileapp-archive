import 'package:flutter/widgets.dart';

enum PageState {
  none,
  addPage,
  addAll,
  addWidget,
  pop,
  replace,
  replaceAll,
}

enum Pages {
  splash,
}

class PagesPath {
  static const String pathSplash = '/splash';
}

class PageAction {
  final PageState state;
  final PageConfiguration page;
  final List<PageConfiguration> pages;
  Widget widget;

  PageAction({
    required this.page,
    required this.pages,
    required this.widget,
    this.state = PageState.none,
  });
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction currentPageAction;

  PageConfiguration(
      {required this.key,
      required this.path,
      required this.uiPage,
      required this.currentPageAction});
}
