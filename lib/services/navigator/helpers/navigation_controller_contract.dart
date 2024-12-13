import 'package:flutter/material.dart';

import 'navigator_helper.dart';
import 'navigator_utils.dart';

abstract class NavigationControllerContract {
  NavigationDomains getDomainName(EnumPageIntent enumPageIntent);

  String getRootNavigatorRoute(EnumPageIntent intent);

  Map<String, Widget Function(BuildContext? context)>? getRouteBuilder(
      BuildContext? context,
      EnumPageIntent pageIntent,
      NavigationDomains navigationDomain,
      dynamic modelReference);

  NavigatorModel getNavigationProperties(EnumPageIntent pageIntent,
      {dynamic modelRef});

  String? getNavigatorRoute(EnumPageIntent intent);
}
