import 'package:flutter/material.dart';
import 'package:health_gauge/services/navigator/page/page_service_handler.dart';

import '../system_navigator_service.dart';
import 'navigator_helper.dart';
import 'navigator_utils.dart';

class NavigatorServiceBase extends StatefulWidget {
  const NavigatorServiceBase();

  @override
  _NavigatorServiceBaseState createState() => _NavigatorServiceBaseState();
}

class _NavigatorServiceBaseState extends State<NavigatorServiceBase> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NavigatorData>(
      stream: NavigatorService().navigatorData,
      initialData: NavigatorData(intent: defaultNavPage, pageModel: null),
      builder: (context, snapshot) {

        // Update the navigation domain info with the Navigator widget class
        NavigatorService().updateNavigationDomain(snapshot.data!.intent);

        // Update the navigation stack
        NavigatorService().updateNavigationStack(snapshot.data!.intent);

        // Get the page service and navigation domain
        var pageServiceContract =
            PageServiceHandler(snapshot.data!.intent).getPageService();

        // Set the default values and handle the domain change
        var navigatorModel = pageServiceContract.getNavigationProperties(
            model: snapshot.data!.pageModel);

        // Get the required navigator route
        var navigatorRoute = pageServiceContract.getNavigatorRoute();

        // Create a new instance for the common key
        navigatorKeys[NavigationDomains.common] = GlobalKey<NavigatorState>();

        // Update the root navigator page
        // Note: Navigator will always have the Navigation root page
        return Navigator(
          key: navigatorKeys[NavigationDomains.common],
          initialRoute: navigatorModel.rootNavigatorRoute,
          observers: [
            HeroController(),
          ],
          onGenerateRoute: (routeSettings) {
            return PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return navigatorModel.routeBuilders![navigatorRoute!]!(context);
                },
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
                settings: RouteSettings(name: snapshot.data!.intent.toString()));
          },
        );
      },
    );
  }
}
