import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/services/navigator/helpers/navigator_utils.dart';

class DeeplinkServiceHandler {
  DeeplinkServiceHandler._privateConstructor();

  static final DeeplinkServiceHandler instance =
      DeeplinkServiceHandler._privateConstructor();

  Future<void> initService() async {
    final urlData = await FirebaseDynamicLinks.instance.getInitialLink();
    await _handleDeeplinks(urlData);
    FirebaseDynamicLinks.instance.onLink.listen((linkData) {
      _handleDeeplinks(linkData);
    }, onError: (error) {
      LoggingService().printLog(
        tag: 'IncomingLink',
        message: error.message ?? '???',
      );
    });
  }

  Future<void> _handleDeeplinks(PendingDynamicLinkData? data) async {
    var link = data?.link;
    if (link != null) {
      var domain = _extractDomain(link);
      LoggingService()
          .printLogger(tag: 'DeeplinkHandler', message: link.toString());
      await selectDomain(domain, data);
    }
  }

  /// selecting domain name for using spesific handler.
  Future<void> selectDomain(
      NavigationDomains domain, PendingDynamicLinkData? urlData) async {
    switch (domain) {
      case NavigationDomains.common:
        // TODO: Handle this case.
        break;
      case NavigationDomains.home:
        // TODO: Handle this case.
        break;
    }
  }

  /// Extract the domain from dynamic links
  NavigationDomains _extractDomain(Uri deeplink) {
    var domain = _enumTypeFromString(deeplink.pathSegments.first);
    return domain;
  }

  /// Converting the domain name strint to enum
  NavigationDomains _enumTypeFromString(String typeString) => NavigationDomains
      .values
      .firstWhere((type) => type.toString() == 'NavigationDomains.$typeString');
}
