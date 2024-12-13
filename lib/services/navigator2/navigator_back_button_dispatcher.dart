import 'package:flutter/widgets.dart';

import 'navigator_router_delegate.dart';

class NavigatorButtonDispatcher<NRD extends NavigatorRouterDelegate>
    extends RootBackButtonDispatcher {
  final NRD _routerDelegate;

  NavigatorButtonDispatcher(this._routerDelegate) : super();

  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}
