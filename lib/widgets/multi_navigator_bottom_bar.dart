library multi_navigator_bottom_bar;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

late int currentIndex;

class BottomBarTab {
  final WidgetBuilder? routePageBuilder;
  final WidgetBuilder initPageBuilder;
  final WidgetBuilder tabIconBuilder;
  final String? tabTitle;
  final GlobalKey<NavigatorState> _navigatorKey;

  BottomBarTab({
    required this.initPageBuilder,
    required this.tabIconBuilder,
    this.tabTitle,
    this.routePageBuilder,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
}

class MultiNavigatorBottomBar extends StatefulWidget {
  final int? initTabIndex;
  final List<BottomBarTab> tabs;
  final PageRoute? pageRoute;
  final ValueChanged<int>? onTap;
  final Widget Function(Widget)? pageWidgetDecorator;
  final BottomNavigationBarType? type;
  final Color? fixedColor;
  final double? iconSize;
  final ValueGetter? shouldHandlePop;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final bool? changeScreenOnTap;

  MultiNavigatorBottomBar({
    Key? key,
    required this.initTabIndex,
    required this.tabs,
    this.onTap,
    this.pageRoute,
    this.pageWidgetDecorator,
    this.type,
    this.fixedColor,
    this.iconSize = 24.0,
    this.shouldHandlePop = _defaultShouldHandlePop,
    this.selectedItemColor,
    this.backgroundColor,
    this.changeScreenOnTap,
  }) : super(key: key);

  static bool _defaultShouldHandlePop() => true;

  @override
  State<StatefulWidget> createState() => MultiNavigatorBottomBarState(initTabIndex);
}

class MultiNavigatorBottomBarState extends State<MultiNavigatorBottomBar> {
  MultiNavigatorBottomBarState(index) {
    currentIndex = index;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          return widget.shouldHandlePop!()
              ? !await widget.tabs[currentIndex]._navigatorKey.currentState!.maybePop()
              : false;
        },
        child: Scaffold(
          body: widget.pageWidgetDecorator == null
              ? _buildPageBody()
              : widget.pageWidgetDecorator!(_buildPageBody()),
          bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.6)
                        : Colors.black.withOpacity(0.25),
                    offset: Offset(2.0, 0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: _buildBottomBar()),
        ),
      );

  Widget _buildPageBody() => Stack(
        children: widget.tabs.map((tab) => _buildOffstageNavigator(tab)).toList(),
      );

  Widget _buildOffstageNavigator(BottomBarTab tab) => Offstage(
        offstage: widget.tabs.indexOf(tab) != currentIndex,
        child: TabPageNavigator(
          navigatorKey: tab._navigatorKey,
          initPageBuilder: tab.initPageBuilder,
          pageRoute: widget.pageRoute,
        ),
      );

  Widget _buildBottomBar() => BottomNavigationBar(
        type: widget.type,
        backgroundColor: widget.backgroundColor,
        selectedItemColor: Colors.transparent,
        unselectedItemColor: Colors.transparent,
        items: widget.tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: tab.tabIconBuilder(context),
                  label: tab.tabTitle!,
                ))
            .toList(),
        onTap: (index) {
          onTapItem(index);
        },
        currentIndex:
            (currentIndex != null && 0 <= currentIndex && currentIndex < widget.tabs.length)
                ? currentIndex
                : 0,
      );

  onTapItem(index) {
    if (widget.onTap != null) widget.onTap!(index);
    setState(() => currentIndex = index);
  }
}

class TabPageNavigator extends StatelessWidget {
  TabPageNavigator({required this.navigatorKey, required this.initPageBuilder, this.pageRoute});

  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder initPageBuilder;
  final PageRoute? pageRoute;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        observers: [HeroController()],
        onGenerateRoute: (routeSettings) =>
            pageRoute ??
            MaterialPageRoute(
              // settings: RouteSettings(isInitialRoute: true),
              builder: (context) => _defaultPageRouteBuilder(routeSettings.name ?? '')(context),
            ),
      );

  WidgetBuilder _defaultPageRouteBuilder(String routName, {String? heroTag}) =>
      (context) => initPageBuilder(context);
}
