
import '../helpers/navigator_helper.dart';
import '../helpers/navigator_utils.dart';
import 'page_service_contract.dart';

class PageServiceHandler {
  EnumPageIntent pageIntent;
  late NavigationDomains _navigationDomains;

  PageServiceHandler(this.pageIntent) {
    _navigationDomains =
        getDomainName(pageIntent); // Update the navigation domain
  }

  PageServiceContract getPageService() {
    PageServiceContract pageServiceContract = _TempPageService();
    // switch (_navigationDomains) {
    // }
    return pageServiceContract;
  }
}

//TODO remove later
class _TempPageService extends PageServiceContract {
  @override
  dynamic getBlocModel(
      {bool forceCreateNewInstance = false, bool getASRBloc = false}) {
    // TODO: implement getBlocModel
    throw UnimplementedError();
  }

  @override
  NavigatorModel getNavigationProperties({dynamic model}) {
    // TODO: implement getNavigationProperties
    throw UnimplementedError();
  }

  @override
  String? getNavigatorRoute() {
    // TODO: implement getNavigatorRoute
    throw UnimplementedError();
  }

  @override
  dynamic getPageModel(model,
      {PageModelType pageModelType = PageModelType.uiModel}) {
    // TODO: implement getPageModel
    throw UnimplementedError();
  }

  @override
  bool isVoiceSupported() {
    // TODO: implement isVoiceSupported
    throw UnimplementedError();
  }
}
