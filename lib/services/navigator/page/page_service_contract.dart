import 'package:health_gauge/services/navigator/dialog/model/dialog_configuration.dart';

import '../helpers/navigator_helper.dart';

abstract class PageServiceContract<PageModel> {
  bool isVoiceSupported();

  // Method to get actual page with it's other navigation properties
  NavigatorModel getNavigationProperties({PageModel? model});

  // Method to get the navigator route
  String? getNavigatorRoute();

  // Method to get the page model
  PageModel getPageModel(
    PageModel model, {
    PageModelType pageModelType = PageModelType.uiModel,
  });

  // Method to get the bloc model
  dynamic getBlocModel({
    bool forceCreateNewInstance = true,
    bool getASRBloc = false,
  });

  // DialogConfiguration getDialogConfiguration({
  //   required DialogConfiguration configuration,
  // });
}

enum PageModelType { uiModel }
