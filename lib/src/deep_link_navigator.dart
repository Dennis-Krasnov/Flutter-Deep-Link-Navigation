import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merge_map/merge_map.dart';
import 'package:provider/provider.dart' show Provider;

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/utils.dart';
import 'package:deep_link_navigation/src/dispatchers.dart';

/// Internal state which orchestrates native navigator though [navigatorKey].
class DeepLinkNavigator with ChangeNotifier {
  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState> navigatorKey;

  /// Top-level dispatcher to represent deep link navigation hierarchy.
  final Dispatcher navigation;

  /// Initial route of application.
  /// [RouteNotFound] exception defaults back to this route.
  /// If null, must manually navigate from the splash screen.
  /// If specified, must contain at least one deep link.
  final List<DeepLink> defaultRoute;

  /// Current location within navigation hierarchy.
  List<DeepLink> _currentRoute;
  List<DeepLink> get currentRoute => _currentRoute;

  /// Previous location within navigation hierarchy.
  List<DeepLink> _previousRoute;
  List<DeepLink> get previousRoute => _previousRoute;

  /// Only return promises and animate transitions when pushing.
  bool _actionWasPush = false;
  bool get actionWasPush => _actionWasPush;

  /// Whether currently handling pops for a deep link navigation.
  /// Typical pop handling should be temporarily disabled.
  bool _poppingForDeepNavigation = false;

  DeepLinkNavigator(
      {@required this.navigatorKey,
      @required this.navigation,
      this.defaultRoute})
      : assert(navigation != null),
        assert(defaultRoute == null || defaultRoute.isNotEmpty);

  /// Handle a significant change of the current route.
  /// Optionally handles [promise] for pushes.
  @optionalTypeArgs
  Future<T> _handleRouteChanged<T extends Object>(
      [PathTransitionBuilder transition, Future<T> promise]) {
    handlePop();

    // Mutable route built up level-by-level
    var accumulatedRoute = <DeepLink>[];

    // Deep link dispatcher at the next level of navigation hierarchy
    var nextDispatcher = navigation;

    // Whether this is the last level of navigation hierarchy
    // This doesn't affect the base (first level) navigation
    var endOfNavigationHierarchy = false;

    // Mutable exception handling uses deepest level possible
    var errors = <Type, ErrorMapping>{};

    try {
      // Trace each deep link to reach current route
      for (final deepLink in currentRoute) {
        // Throw if further navigation can't be found
        if (endOfNavigationHierarchy) {
          throw (RouteNotFound(currentRoute));
        }

        // Deep link dispatcher at this level of navigation hierarchy
        final currentDispatcher = nextDispatcher;
        assert(currentDispatcher.routeBuilders.isNotEmpty);

        // Attempt to go deeper in navigation
        if (currentDispatcher.subNavigations
            .containsKey(deepLink.runtimeType)) {
          nextDispatcher =
              currentDispatcher.subNavigations[deepLink.runtimeType](
                  deepLink is ValueDeepLink ? deepLink.data : null);
          assert(nextDispatcher != null);
        } else {
          endOfNavigationHierarchy = true;
        }

        // Merge and override error mappings
        errors = mergeMap([errors, currentDispatcher.errorMappers]);
        assert(errors.containsKey(RouteNotFound),
            "Must specify `exception<RouteNotFound>` on base navigation builder.");

        // Attempt to find deep link
        try {
          if (!currentDispatcher.routeBuilders
              .containsKey(deepLink.runtimeType)) {
            throw (RouteNotFound(currentRoute));
          }

          // Custom logic can throw custom exceptions
          deepLink.onDispatch(navigatorKey.currentContext);
        } catch (_) {
          // Set current route to represent real navigator state on failure
          // Otherwise, handleRouteChanged would pop too many times
          _currentRoute = accumulatedRoute;
          rethrow;
        }

        // Append deep link to accumulated route
        accumulatedRoute.add(deepLink);

        // Only return push promise on last deep link
        if (actionWasPush && deepLink == currentRoute.last) {
          return _pushNavigatorIfNecessary<T>(
            deepLink,
            currentDispatcher,
            accumulatedRoute,
            transition,
          );
        }
        _pushNavigatorIfNecessary<T>(
          deepLink,
          currentDispatcher,
          accumulatedRoute,
          deepLink == currentRoute.last ? transition : null,
        );
      }
    } on RouteNotFound catch (exception) {
      final route =
          errors[exception.runtimeType](exception, List.from(accumulatedRoute));
      assert(route != null && route.isNotEmpty);

      navigateTo(route, transition: transition);
    } on Exception catch (exception) {
      if (!errors.containsKey(exception.runtimeType)) rethrow;

      final route =
          errors[exception.runtimeType](exception, List.from(accumulatedRoute));
      assert(route != null && route.isNotEmpty);

      navigateTo(route, transition: transition);
    }
    return null;
  }

  /// Pops until lowest common ancestor route.
  void handlePop() {
    _poppingForDeepNavigation = true;
    var _timesDidNotPop = 0;
    for (final deepLink
        in previousRoute.sublist(commonElementsInRoutes).reversed) {
      // Allow base routes to be conceptually popped once since they're replaced instead of pushed
      if (navigatorKey.currentState.canPop()) {
        navigatorKey.currentState.pop();
      } else
        assert(++_timesDidNotPop <= 1,
            "$deepLink caused a second pop to a base route");
    }
    _poppingForDeepNavigation = false;
  }

  /// Pushes widgets for deep links for deep links that didn't exist in previous route.
  @optionalTypeArgs
  Future<T> _pushNavigatorIfNecessary<T extends Object>(
    DeepLink deepLink,
    Dispatcher currentDispatcher,
    List<DeepLink> accumulatedRoute, [
    PathTransitionBuilder transitionBuilder,
  ]) {
    if (previousRoute.isEmpty ||
        currentRoute.sublist(commonElementsInRoutes).contains(deepLink)) {
      // Widget that corresponds with deep link
      final widget = currentDispatcher.routeBuilders[deepLink.runtimeType](
        deepLink is ValueDeepLink ? deepLink.data : null,
        accumulatedRoute,
      );
      assert(widget != null);

      // TransitionBuilder that coresponds with deep link
      final finalTransitionBuilder = transitionBuilder != null
          ? transitionBuilder
          : currentDispatcher.transitionBuilders
                  .containsKey(deepLink.runtimeType)
              ? currentDispatcher.transitionBuilders[deepLink.runtimeType]
              : null;

      // Animate only push (and thus pop) transitions
      final pageRoute = finalTransitionBuilder != null
          ? finalTransitionBuilder(widget)
          : actionWasPush
              ? MaterialPageRoute<T>(builder: (BuildContext context) => widget)
              : NoAnimationPageRoute<T>(
                  builder: (BuildContext context) => widget);

      // Replace root level pages
      final action = accumulatedRoute.length == 1
          ? (pageRoute) => navigatorKey.currentState.pushReplacement(pageRoute)
          : (pageRoute) => navigatorKey.currentState.push(pageRoute);

      // Reuse native navigator's completer
      return action(pageRoute);
    }
    return null;
  }

  /// Number of common deep links in [previousRoute] and [currentRoute].
  int get commonElementsInRoutes =>
      indexOfLastCommonElement(previousRoute ?? [], currentRoute);

  /// Pushes the given [deepLink] onto the navigator.
  /// Optionally returns a [T] value.
  @optionalTypeArgs
  Future<T> push<T extends Object>(
    DeepLink deepLink, {
    PathTransitionBuilder transition,
  }) async {
    _previousRoute = List.from(currentRoute);
    currentRoute.add(deepLink);
    _actionWasPush = true;

    notifyListeners();
    return _handleRouteChanged<T>(transition);
  }

  /// Navigates to a specific route anywhere in the navigation hierarchy.
  void navigateTo(
    List<DeepLink> route, {
    PathTransitionBuilder transition,
  }) {
    _previousRoute = List.from(currentRoute ?? []);
    _currentRoute = List.from(route);
    _actionWasPush = false;

    notifyListeners();
    _handleRouteChanged(transition);
  }

  /// Resets navigation to user's default page.
  /// Does nothing if [defaultRoute] is null.
  void replaceWithDefault({
    PathTransitionBuilder transition,
  }) {
    if (defaultRoute != null) {
      navigateTo(defaultRoute, transition: transition);
    }
  }

  /// Pop the top-most deep link off the navigator that most tightly encloses the given context.
  @optionalTypeArgs
  bool pop<T extends Object>([T result]) =>
      navigatorKey.currentState.pop(result);

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
