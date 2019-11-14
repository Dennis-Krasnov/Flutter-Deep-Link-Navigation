import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merge_map/merge_map.dart';
import 'package:provider/provider.dart' show Provider;

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/utils.dart';
import 'package:deep_link_navigation/src/dispatchers.dart';

/// Internal state which orchestrates native navigator though [navigatorKey].
class DeepLinkNavigator with ChangeNotifier {
  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState> navigatorKey;

  /// Recursive data structure to represent deep link navigation hierarchy.
  final NavigationBuilder navigationBuilder;

  /// Initial route of application.
  /// [RouteNotFound] exception defaults back to this route. // TODO: what to do if not defined?
  /// Must contain at least one deep link.
  final List<DeepLink> defaultRoute;

  /// Current location within navigation hierarchy.
  List<DeepLink> _currentRoute;
  List<DeepLink> get currentRoute => _currentRoute;

  /// Previous location within navigation hierarchy.
  List<DeepLink> _previousRoute;
  List<DeepLink> get previousRoute => _previousRoute;

  /// Only animate transition when pushing.
  bool _shouldAnimateTransition = false;
  bool get shouldAnimateTransition => _shouldAnimateTransition;

  /// Whether currently handling pops for a deep link navigation.
  /// Typical pop handling should be temporarily disabled.
  bool _poppingForDeepNavigation = false;

  DeepLinkNavigator({
    @required this.navigatorKey,
    @required this.navigationBuilder,
    this.defaultRoute
  }) :
    assert(navigationBuilder != null),
    assert(defaultRoute == null || defaultRoute.isNotEmpty);

  /// Handle a significant change of the current route.
  void handleRouteChanged() {
    handlePop();

    // Mutable route built up level-by-level
    var accumulatedRoute = <DeepLink>[];

    // Deep link dispatcher at the next level of navigation hierarchy
    var nextDispatcher = navigationBuilder(Dispatcher());

    // Whether this is the last level of navigation hierarchy
    // This doesn't affect the base (first level) navigation
    var endOfNavigationHierarchy = false;

    // Mutable exception handling uses deepest level possible (merge/override)
    var errors = <Type, ErrorMapping>{};

    try {
      // Trace each deep link to reach current route
      for (final deepLink in currentRoute) {
        // Throw if further navigation can't be found
        if (endOfNavigationHierarchy) {
          throw(RouteNotFound(currentRoute));
        }

        // Deep link dispatcher at this level of navigation hierarchy
        final currentDispatcher = nextDispatcher;

        // Attempt to go deeper in navigation
        if (currentDispatcher.subNavigationBuilders.containsKey(deepLink.runtimeType)) {
          nextDispatcher = currentDispatcher.subNavigationBuilders[deepLink.runtimeType](Dispatcher());
        }
        else {
          endOfNavigationHierarchy = true;
        }

        // ...
        errors = mergeMap([errors, currentDispatcher.errorMappers]);
        assert(errors.containsKey(RouteNotFound), "Must specify `exception<RouteNotFound>` on base navigation builder.");

        try {
          if (!currentDispatcher.routeBuilders.containsKey(deepLink.runtimeType)) {
            throw(RouteNotFound(currentRoute));
          }

          // Custom logic can throw custom exceptions
          deepLink.onDispatch(navigatorKey.currentContext);
        } catch (_) {
          // Set current route to represent real navigator state on failure
          // Otherwise, handleRouteChanged would pop too many times
          _currentRoute = accumulatedRoute;
          rethrow;
        }

        // ...
        accumulatedRoute.add(deepLink);
        final accumulatedPath = accumulatedRoute.join("/");

        // Only push new deep links
        if (previousRoute.isEmpty || currentRoute.sublist(commonElementsInRoutes).contains(deepLink)) {
          // ...
          final widget = currentDispatcher.routeBuilders[deepLink.runtimeType](
            navigatorKey.currentContext,
            deepLink is ValueDeepLink ? deepLink.data : null,
            accumulatedPath,
          );

          // Animate push (and thus pop) transitions
          final pageRoute = shouldAnimateTransition
            ? MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget)
            : NoAnimationPageRoute<dynamic>(builder: (BuildContext context) => widget);

          // Replace root level pages
          final action = accumulatedRoute.length == 1
            ? (pageRoute) => navigatorKey.currentState.pushReplacement(pageRoute)
            : (pageRoute) => navigatorKey.currentState.push(pageRoute);

          action(pageRoute);
        }
      }
    } on RouteNotFound catch(exception) {
      navigateTo(errors[exception.runtimeType](
        navigatorKey.currentContext,
        exception,
        exception.route.join("/")
      ));
    } on Exception catch(exception) {
      if (!errors.containsKey(exception.runtimeType)) rethrow;

      navigateTo(errors[exception.runtimeType](
        navigatorKey.currentContext,
        exception,
        accumulatedRoute.join("/")
      ));
    }
  }

  /// Handle navigation pops.
  void handlePop() {
    _poppingForDeepNavigation = true;
    var _timesDidNotPop = 0;
    // Pop to lowest common ancestor (pop extra deep links in the previous route)
    for (final deepLink in previousRoute.sublist(commonElementsInRoutes).reversed) {
      // Allow base routes to be conceptually popped once since they're replaced instead of pushed
      if (navigatorKey.currentState.canPop()) {
        navigatorKey.currentState.pop();
      } else assert(++_timesDidNotPop <= 1, "$deepLink caused a second pop to a base route");
      // TODO: document why (going to 'splash page' is below base routes technically)
    }
    _poppingForDeepNavigation = false;
  }

  /// Number of common deep links in [previousRoute] and [currentRoute].
  int get commonElementsInRoutes => indexOfLastCommonElement(previousRoute ?? [], currentRoute);

  /// Pushes the given [deepLink] onto the navigator.
  Future<T> push<T extends Object>(DeepLink deepLink) async {
//   TODO final completer = Completer<T>();

    _previousRoute = List.from(currentRoute);
    currentRoute.add(deepLink); // , completer
    _shouldAnimateTransition = true;

    handleRouteChanged();
    notifyListeners();

    return null; // completer.future
  }

  /// Navigates to a specific route anywhere in the navigation hierarchy.
  void navigateTo(List<DeepLink> route) {
    _previousRoute = List.from(currentRoute ?? []);
    _currentRoute = List.from(route);
    _shouldAnimateTransition = false;

    handleRouteChanged();
    notifyListeners();
  }

  /// Resets navigation to user's default page.
  /// Does nothing if [defaultRoute] is null.
  void replaceWithDefault() {
    if (defaultRoute != null) {
      navigateTo(defaultRoute);
    }
  }

  /// Pops the topmost route from the native navigator.
  bool pop<T>(T value) => navigatorKey.currentState.pop(value);

  /// Handles deep link popping logic.
  /// Notified exclusively from native navigator's [PopObserver].
  void notifyPopped() {
    // Only processes if not currently popping routes for [navigateTo].
    if (!_poppingForDeepNavigation) {
      _previousRoute = List.from(currentRoute);
      currentRoute.removeLast();

      notifyListeners();
    }
  }

  /// Method that allows widgets to access [DeepLinkNavigator] as their `BuildContext`
  /// contains a [DeepLinkNavigator] instance.
  ///
  /// TODO: other examples using dart code notation
  /// ```dart
  /// DeepLinkNavigator.of(context);
  /// ```
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

  /// URL-friendly representation of current route.
  @override
  String toString() => currentRoute.join("/");
}

// TODO: add on google analytics listener on callback 'routeChanged'