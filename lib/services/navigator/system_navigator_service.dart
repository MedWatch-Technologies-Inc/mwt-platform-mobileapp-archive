import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_gauge/services/navigator/page/page_service_contract.dart';
import 'package:health_gauge/services/navigator/page/page_service_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';

import 'helpers/navigator_helper.dart';
import 'helpers/navigator_utils.dart';

class NavigatorService {
  // Navigation stack to get the current displayed page
  List<EnumPageIntent> navigationStack = <EnumPageIntent>[];
  NavigationDomains? navigationDomain;
  late PageServiceContract pageServiceContract;
  late NavigatorModel navigatorModel;

  EnumPageIntent currentPageIntent = EnumPageIntent.homePage;

  EnumPageIntent? previousPageIntent;

  Duration kNavServiceDelay = Duration(milliseconds: 50);

  // Stream to update navigator
  Stream<NavigatorData> get navigatorData => _navigatorData.stream;
  final _navigatorData = BehaviorSubject<NavigatorData>();

  // Stream for the current page intent
  ValueStream<EnumPageIntent> get currentPageIntentStream =>
      setCurrentIntent.stream;
  BehaviorSubject<EnumPageIntent> setCurrentIntent =
      BehaviorSubject<EnumPageIntent>();

  static final NavigatorService _singleton = NavigatorService._internal();

  factory NavigatorService() {
    return _singleton;
  }

  NavigatorService._internal() {
    currentPageIntentStream.listen((enumPageIntent) {
      currentPageIntent = enumPageIntent;
    });
  }

  // Get's the context of the key
  BuildContext? get currentContext => _getNavigatorKey().currentContext;

  void setCurrentPageIntent(EnumPageIntent pageIntent) async {
    currentPageIntent = pageIntent;
    // Notify the current intent
    setCurrentIntent.add(currentPageIntent);
    await Future.delayed(kNavServiceDelay);
  }

  ///
  /// Method to perform Push operation
  ///
  void push(
    EnumPageIntent pageIntent,
    dynamic pageModel, {
    PageTransitionType? pageTransitionType = PageTransitionType.fade,
    bool withTransition = true,
    Duration transitionDuration = const Duration(milliseconds: 500),
    bool isUIAction = true,
    bool refreshNavigator = false,
    void Function(dynamic value)? thenValue,
    bool isReplace = false,
    bool keepHomePageAsFirstRoute = true,
  }) async {
    transitionDuration = Duration(milliseconds: 250);
    String? navigatorRoute;

    // Update the current page
    currentPageIntent = getCurrentPage();

    if (pageIntent == EnumPageIntent.homePage &&
        currentPageIntent == pageIntent) {
      return;
    }

    // Save current intent before update
    previousPageIntent = currentPageIntent;
    currentPageIntent = pageIntent;

    // Notify the current intent
    setCurrentIntent.add(currentPageIntent);
    await Future.delayed(kNavServiceDelay);

    // Get the current navigation domain
    var currentNavigationDomain = getDomainName(currentPageIntent);

    // Check for the flag and refresh the navigator, if SET
    if (!refreshNavigator) {
      // Get the page service and navigation domain
      pageServiceContract =
          PageServiceHandler(currentPageIntent).getPageService();

      // Get the navigator model
      navigatorModel =
          pageServiceContract.getNavigationProperties(model: pageModel);

      // Get the required navigator route
      navigatorRoute = pageServiceContract.getNavigatorRoute();

      // Get the page to display
      var pageToDisplay = navigatorModel.routeBuilders![navigatorRoute!]!(null);

      // Get the navigator key
      var navigatorKey = _getNavigatorKey();

      // Check for the domain change
      // If yes, then pop to the first screen
      _checkIfDifferentNavigation(currentNavigationDomain, navigatorKey);

      ///
      /// Prepare for the push
      ///

      // Update the stack
      navigationStack.add(currentPageIntent);
      await Future.delayed(kNavServiceDelay);

      // Update the Intent
      _updateIntentForOtherServices();

      // Get the route settings
      var routeSettings = RouteSettings(name: currentPageIntent.toString());

      if (isReplace) {
        await navigatorKey.currentState!
            .pushAndRemoveUntil(
                withTransition
                    ? _createRoute(
                        pageToDisplay,
                        pageTransitionType ?? PageTransitionType.fade,
                        routeSettings,
                        transitionDuration)
                    : ForkedPageTransition(
                        type: ForkedPageTransitionType.none,
                        child: pageToDisplay,
                        settings: routeSettings,
                        duration: transitionDuration,
                      ),
                (route) => false)
            .then((value) {
          var arguments = routeSettings.arguments as Map?;
          if (arguments != null) {
            thenValue!(arguments['result']);
          } else {
            if (value != null) {
              thenValue!(value);
            }
            return;
          }
        });
      } else {
        await navigatorKey.currentState!
            .push(
          withTransition
              ? _createRoute(
                  pageToDisplay,
                  pageTransitionType ?? PageTransitionType.fade,
                  routeSettings,
                  transitionDuration)
              : ForkedPageTransition(
                  type: ForkedPageTransitionType.none,
                  child: pageToDisplay,
                  settings: routeSettings,
                  duration: transitionDuration,
                ),
        )
            .then((value) {
          var arguments = routeSettings.arguments as Map?;
          if (arguments != null) {
            thenValue!(arguments['result']);
          } else {
            if (value != null) {
              thenValue!(value);
            }
            return;
          }
        });
      }
    } else {
      // Reset and add the page to the navigation stack
      navigationStack = <EnumPageIntent>[];
      navigationStack.add(currentPageIntent);

      // Notify bloc to refresh the parent Navigator
      _navigatorData
          .add(NavigatorData(intent: currentPageIntent, pageModel: pageModel));
    }
  }

  void _checkIfDifferentNavigation(
    NavigationDomains currentNavigationDomain,
    GlobalKey<NavigatorState> navigatorKey, {
    bool isUIAction = true,
    bool forceAssumeDifferentDomain = false,
  }) {
    var isHomeRoute = true;
    // Check for the domain change
    // If yes, then pop to the first screen
    if (navigationDomain != currentNavigationDomain) {
      // Perform the DM cancel operation
      if (isUIAction || currentPageIntent == EnumPageIntent.homePage) {
        // cancel operations when switching pages
      }
      // Update the navigation domain
      navigationDomain = currentNavigationDomain;

      // Perform pop
      navigatorKey.currentState!.popUntil((route) {
        if (!route.isFirst) {
          // Update the stack, by removing all but not the first element
          if (navigationStack.isNotEmpty) {
            navigationStack.removeLast();
          }
        } else {
          // Check for the first route and raise the flag if it's not the Home
          // Note: This is to handle progressive intent where all the stack is destroyed
          if (route.settings.name != 'EnumPageIntent.HomePage') {
            isHomeRoute = false;
          }
        }

        return route.isFirst;
      });

      if (!isHomeRoute) {
        // Drop the last route as we have to start with the Home again
        pop(isExternalPop: false);
      } else {
        // Stop, in case if it's navigating to the Home screen
        if (currentNavigationDomain == NavigationDomains.home) {
          return;
        }
      }
    }
  }

  ///
  /// Method to perform Push replacement operation
  ///
  void pushReplacement(
    EnumPageIntent pageIntent,
    dynamic pageModel, {
    PageTransitionType pageTransitionType = PageTransitionType.fade,
    Duration transitionDuration = const Duration(milliseconds: 50),
    void Function(dynamic value)? thenValue,
  }) async {
    String? navigatorRoute;

    // Return, if current and new page-intent is same
    if (pageIntent == EnumPageIntent.homePage &&
        currentPageIntent == pageIntent) {
      return;
    }
    // Save current intent as previous before update
    previousPageIntent = currentPageIntent;
    currentPageIntent = pageIntent;

    // Get the current navigation domain
    NavigationDomains? currentNavigationDomain = getDomainName(pageIntent);

    setCurrentIntent.add(pageIntent);
    await Future.delayed(kNavServiceDelay);

    // For Common navigation domain, stick to the domain we have been to
    if (currentNavigationDomain == NavigationDomains.common) {
      currentNavigationDomain = navigationDomain;
    }

    // Check for the domain change, if not then push the page
    // else refresh the Navigator with the updated navigation properties
    if (navigationDomain == currentNavigationDomain) {
      // Update the stack
      navigationStack.removeLast();
      navigationStack.add(pageIntent);

      // Get the page service and navigation domain
      pageServiceContract = PageServiceHandler(pageIntent).getPageService();

      // Get the navigator model
      navigatorModel =
          pageServiceContract.getNavigationProperties(model: pageModel);

      // Get the required navigator route
      navigatorRoute = pageServiceContract.getNavigatorRoute();

      // Get the page to display
      var pageToDisplay = navigatorModel.routeBuilders![navigatorRoute!]!(null);

      var navigatorKey = _getNavigatorKey();

      // TODO: Add page transition support
      // Make a push
      var routeSettings = RouteSettings(name: pageIntent.toString());
      await navigatorKey.currentState!
          .pushReplacement(_createRoute(pageToDisplay, pageTransitionType,
              routeSettings, transitionDuration))
          .then((value) {
        var arguments = routeSettings.arguments as Map?;
        if (arguments != null) {
          thenValue!(arguments['result']);
        } else {
          if (value != null) {
            thenValue!(value);
          }
          return;
        }
      });
    }
  }

  ///
  /// Creates the route
  ///
  Route _createRoute(
      Widget pageToDisplay,
      PageTransitionType pageTransitionType,
      RouteSettings settings,
      Duration transitionDuration) {
    return PageTransition(
      type: pageTransitionType,
      child: pageToDisplay,
      settings: settings,
      duration: transitionDuration,
    );
  }

  ///
  /// Method to check whether Pop operation can be performed or not
  ///
  bool canPop() {
    // Get the navigator key
    var navigatorKey = _getNavigatorKey();

    return (navigatorKey.currentState != null &&
        navigatorKey.currentState!.canPop());
  }

  /// TODO: Add support to perform route until
  ///
  /// Pop's until the required page
  ///
  void popUntilFirstRoute() async {
    var navigatorKey = _getNavigatorKey();
    navigatorKey.currentState!.popUntil((route) {
      if (!route.isFirst) {
        // Update the stack, by removing all but not the first element
        navigationStack.removeLast();
      }
      return route.isFirst;
    });

    // Update Local ML service with current intent
    setCurrentIntent.add(getCurrentPage());
    await Future.delayed(kNavServiceDelay);
  }

  ///
  /// Pop's to a particular route
  ///
  void popTo(
      EnumPageIntent pageIntent, BuildContext? context, dynamic data) async {
    var navigatorKey = _getNavigatorKey();
    navigatorKey.currentState!.popUntil((route) {
      var routeName = route.settings.name;
      if (routeName == pageIntent.toString()) {
        if (route.settings.arguments != null) {
          (route.settings.arguments as Map)['result'] = data;
        }
        return true;
      }

      // Remove stack item
      if (navigationStack.isNotEmpty &&
          routeName != null &&
          routeName.trim().isNotEmpty) {
        navigationStack.removeLast();
      }

      return false;
    });

    // Update Local ML service with current intent
    setCurrentIntent.add(getCurrentPage());
    await Future.delayed(kNavServiceDelay);
  }

  ///
  /// Method to perform Pop operation
  ///
  void pop({bool isExternalPop = true, dynamic result}) async {
    // Get the navigator key
    var navigatorKey = _getNavigatorKey();

    if (isExternalPop) {
      if (NavigatorService().canPop()) {
        // Perform the pop operation
        navigatorKey.currentState!.pop(result);
      } else {
        //TODO create nav key in App class and pop if needed
        // App.navKey.currentState!.maybePop();
      }
    } else {
      navigatorKey.currentState!.pop();
    }

    // Remove stack item
    if (navigationStack.isNotEmpty) {
      navigationStack.removeLast();
      setCurrentIntent.add(getCurrentPage());
      await Future.delayed(kNavServiceDelay);
    }

    // Update the Intent
    _updateIntentForOtherServices();
  }

  void _updateIntentForOtherServices() {}

  ///
  /// Method to get the current page
  ///
  EnumPageIntent getCurrentPage() {
    return (navigationStack.isNotEmpty)
        ? navigationStack.last
        : getDomainRootPage(currentPageIntent);
  }

  ///
  ///  Pattern                        Result
  ///  ----------------------          -------
  ///  NavigationDomains.Home     ->   home
  ///
  String getCurrentDomainName() {
    var navigationDomain = getDomainName(currentPageIntent);

    return navigationDomain
        .toString()
        .replaceAll('${navigationDomain.runtimeType.toString()}.', '')
        .toLowerCase();
  }

  ///
  /// Method to get the current page service
  ///
  PageServiceContract getCurrentPageService(EnumPageIntent pageIntent) {
    return pageServiceContract =
        PageServiceHandler(pageIntent).getPageService();
  }

  ///
  /// Update the navigation domain
  ///
  /// Note: This is called by the navigator widget
  void updateNavigationDomain(EnumPageIntent pageIntent) {
    navigationDomain = getDomainName(pageIntent);
  }

  ///
  /// Update the navigation stack
  ///
  /// Note: This is done by the navigator widget for the very initial page
  void updateNavigationStack(EnumPageIntent pageIntent) async {
    navigationStack = <EnumPageIntent>[];
    navigationStack.add(pageIntent);
    await Future.delayed(kNavServiceDelay);
  }

  ///
  /// Gets the Navigator key
  ///
  GlobalKey<NavigatorState> _getNavigatorKey() {
    // Set the navigator key
    return navigatorKeys[NavigationDomains.common]!;
  }
}

class ForkedPageTransition<T> extends PageRouteBuilder<T> {
  /// Child for your next page
  final Widget child;

  /// Transition types
  final ForkedPageTransitionType type;

  /// Curves for transitions
  final Curve curve;

  /// Aligment for transitions
  final Alignment? alignment;

  /// Durationf for your transition default is 300 ms
  final Duration duration;

  /// Context for inheret theme
  final BuildContext? ctx;

  /// Optional inheret teheme
  final bool inheritTheme;

  /// Page transition constructor. We can pass the next page as a child,
  ForkedPageTransition({
    required this.child,
    required this.type,
    Key? key,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : assert(inheritTheme ? ctx != null : true,
            "'ctx' cannot be null when 'inheritTheme' is true, set ctx: context"),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return inheritTheme
                ? InheritedTheme.captureAll(
                    ctx!,
                    child,
                  )
                : child;
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          settings: settings,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            switch (type) {

              /// PageTransitionType.none

              case ForkedPageTransitionType.none:
                return child;
                break;

              /// FadeTransitions which is the fade transition

              default:
                return FadeTransition(opacity: animation, child: child);
            }
          },
        );
}

/// Transition enum
enum ForkedPageTransitionType {
  /// No Animation
  none,
}
