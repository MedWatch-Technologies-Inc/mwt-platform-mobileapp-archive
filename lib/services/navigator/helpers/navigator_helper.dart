import 'package:flutter/widgets.dart';

import 'navigator_utils.dart';

// Default navigation attributes
EnumPageIntent defaultNavPage = EnumPageIntent.homePage;

Map<NavigationDomains, GlobalKey<NavigatorState>> navigatorKeys = {
  NavigationDomains.common: GlobalKey<NavigatorState>(),
  NavigationDomains.home: GlobalKey<NavigatorState>(),
};

List<NavigationDomains> getSupportedDomains() {
  return [
    NavigationDomains.home,
  ];
}

// Get the domain name
NavigationDomains getDomainName(EnumPageIntent? enumPageIntent) {
  var navigationDomains = NavigationDomains.home;
  switch (enumPageIntent) {
    case EnumPageIntent.homePage:
      navigationDomains = NavigationDomains.home;
      break;
    default:
      break;
  }
  return navigationDomains;
}
/// Which,
///
/// Extract the domain name string from enum
String getDomainNameString(NavigationDomains domain) {
  return domain
      .toString()
      .substring(domain.toString().indexOf('.') + 1)
      .toLowerCase();
}

// Get the domain root page to control the back navigation
EnumPageIntent getDomainRootPage(EnumPageIntent? intent) {
  var _domainRootPage = EnumPageIntent.homePage;
  switch (intent) {
    case EnumPageIntent.homePage:
      _domainRootPage = EnumPageIntent.homePage;
      break;
    default:
      break;
  }
  return _domainRootPage;
}

class NavigatorData {
  final EnumPageIntent intent;
  final dynamic pageModel;

  const NavigatorData({required this.intent, this.pageModel});
}

class NavigatorModel {
  final NavigationDomains? navDomain;
  final Map<String, Widget Function(BuildContext?)>? routeBuilders;
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? rootNavigatorRoute;

  const NavigatorModel(
      {this.navDomain,
      this.routeBuilders,
      this.navigatorKey,
      this.rootNavigatorRoute});
}