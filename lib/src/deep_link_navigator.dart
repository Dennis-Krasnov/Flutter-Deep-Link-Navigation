import 'dart:async';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// ...
class DeepLinkNavigator with ChangeNotifier {
  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState> navigatorKey;

  /// ...
  final Map<Type, DeepLinkDispatcher> linkDispatchers;

  /// ...
  final Map<Type, ErrorDispatcher> errorDispatchers;

  /// ...
  final List<DeepLink> defaultRoute;

  /// ...
  List<DeepLink> _currentRoute;
  List<DeepLink> get currentRoute => _currentRoute;

  /// ...
  List<DeepLink> _previousRoute;
  List<DeepLink> get previousRoute => _previousRoute;

  /// ...
  bool _shouldAnimateTransition = false;
  bool get shouldAnimateTransition => _shouldAnimateTransition;

  /// ...
  bool _poppingForDeepNavigation = false;

  DeepLinkNavigator({
    @required this.navigatorKey,
    @required this.linkDispatchers,
    @required this.errorDispatchers,
    @required this.defaultRoute
  }) : assert(defaultRoute.isNotEmpty);

  /// ...
  void handleRouteChanged() {
    // Pop to lowest common ancestor
    if (commonElementsInRoutes < (previousRoute?.length ?? 0)) {
      _poppingForDeepNavigation = true;
      // Pop the extra deep links in the previous route
      for (final deepLink in previousRoute?.sublist(commonElementsInRoutes)?.reversed ?? []) {
        if (navigatorKey.currentState.canPop()) {
          navigatorKey.currentState.pop();
          print("popping $deepLink");
        } else {print("couldn't pop :3");}
      }
      _poppingForDeepNavigation = false;
    }

    //
    var accumulatedRoute = [];

    //
    var currentDispatchers = linkDispatchers;

    try {
      // Retrace deep links to reach current route
      for (final deepLink in currentRoute) {
        accumulatedRoute.add(deepLink);

        // Current path of route
        final accumulatedPath = accumulatedRoute.join("/");

        if (currentDispatchers == null || !currentDispatchers.containsKey(deepLink.runtimeType)) {
          throw RouteNotFound(accumulatedPath);
        }

        // Dispatcher for current [deepLink]
        final dispatcher = currentDispatchers[deepLink.runtimeType];

        // Iterate through the recursive graph data structure
        currentDispatchers = dispatcher.dispatchers(
          accumulatedPath,
          deepLink is ValueDeepLink ? deepLink.data : null,
          (Widget widget) {
            // Only push new deep links
            if (currentRoute.sublist(commonElementsInRoutes).contains(deepLink)) {
              // Conditionally animate transition (only pushes...)
              final pageRoute = shouldAnimateTransition // TODO actually set this
                ? MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget)
                : NoAnimationPageRoute<dynamic>(builder: (BuildContext context) => widget);

              // Replace root level pages
              final action = accumulatedRoute.length == 1
                ? (pageRoute) => navigatorKey.currentState.pushReplacement(pageRoute)
                : (pageRoute) => navigatorKey.currentState.push(pageRoute);

              action(pageRoute);
            }
          },
        );
      }
    } on UnimplementedError catch(e) {
      // avoid recursion with unspecified routes...
      throw e;
    } on Exception catch(e) {
      // TODO: pop to /, push specified routeExceptionWidget
      // TODO: type matching here too!
      // includes routenotfound case ^^
      print(e);
    }
  }

  /// ...
  int get commonElementsInRoutes => indexOfLastCommonElement(previousRoute ?? [], currentRoute);

  /// Push the given [deepLink] onto the navigator.
  Future<T> push<T extends Object>(DeepLink deepLink) async {
//    final completer = Completer<T>();

    _previousRoute = List.from(currentRoute);
    currentRoute.add(deepLink); // , completer

    handleRouteChanged();
    notifyListeners();

    return null; // completer.future
  }

  /// ...
  void navigateTo(List<DeepLink> route) {
    _previousRoute = List.from(currentRoute ?? []);
    _currentRoute = route;

    handleRouteChanged();
    notifyListeners();
  }

  /// ...
  void replaceWithDefault() => navigateTo(defaultRoute);

  /// ...
  bool pop<T>(T value) => navigatorKey.currentState.pop(value);

  /// Called exclusively from PopObserver
  void notifyPopped() {
    print("POP NOTIFIED");
    if (!_poppingForDeepNavigation) {
      _previousRoute = List.from(currentRoute);
      currentRoute.removeLast();

      notifyListeners();
      print("POP TRIGGERED");
    }
  }

    /// ...
  static DeepLinkNavigator of(BuildContext context) {
    try {
      return Provider.of<DeepLinkNavigator>(context, listen: false);
    } on Object catch (_) {
      throw FlutterError(
        """
        DeepLinkNavigator.of() called with a context that does not contain a DeepLinkNavigator.
        No ancestor could be found starting from the context that was passed to DeepLinkNavigator.of().
        This can happen if the context you used comes from a widget above the DeepLinkRouter.
        """,
      );
    }
  }

  /// ...
  @override
  String toString() => currentRoute.join("/");
}

