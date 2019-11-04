import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/utils.dart';

/// Internal state which orchestrates native navigator though [navigatorKey].
class DeepLinkNavigator with ChangeNotifier {
  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState> navigatorKey;

  /// Recursive data structure to represent deep link navigation hierarchy.
  final Map<Type, DeepLinkDispatcher> linkDispatchers;

  /// Route mapping for route not found exception.
  final ErrorMapping<RouteNotFound> routeNotFoundErrorMapping;

  /// Route mappings for custom exception handling.
  final Map<Type, ErrorMapping> customErrorRouteMappings;

  /// Initial route of application.
  /// [RouteNotFound] exception defaults back to this route.
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

  /// Whether currently handling pops for a deep link.
  /// Typical pop handling should be temporarily disabled.
  bool _poppingForDeepNavigation = false;

  DeepLinkNavigator({
    @required this.navigatorKey,
    @required this.linkDispatchers,
    @required this.routeNotFoundErrorMapping,
    this.customErrorRouteMappings,
    @required this.defaultRoute
  }) :
    assert(linkDispatchers != null),
    assert(routeNotFoundErrorMapping != null, "RouteNotFoundErrorMapping must be defined to a valid route to avoid recursion."),
    assert(customErrorRouteMappings == null || !customErrorRouteMappings.containsKey(RouteNotFound), "Please specify RouteNotFound in routeNotFoundErrorMapping"),
    assert(defaultRoute != null && defaultRoute.isNotEmpty);

  /// Handle a significant change of the current route.
  void handleRouteChanged() {
    _poppingForDeepNavigation = true;
    // Pop to lowest common ancestor (pop extra deep links in the previous route)
    for (final deepLink in previousRoute.sublist(commonElementsInRoutes).reversed) {
      if (navigatorKey.currentState.canPop()) {
        navigatorKey.currentState.pop();
        print("popping $deepLink");
      } // TODO: else clause: assert this doesn't happen more than once (internal counter)
        // document why (going to 'splash page' is below base routes technically)
    }
    _poppingForDeepNavigation = false;

    // Mutable route built up incrementally for full control
    var accumulatedRoute = <DeepLink>[];

    // Mutable route the deep link dispatchers at this level of navigation hierarchy
    var currentDispatchers = linkDispatchers;

    try {
      // Retrace deep links to reach current route
      for (final deepLink in currentRoute) {
        // Set current route to represent real navigator state on failure
        // If not set, handleRouteChanged popping would pop too many times
        try {
          if (!currentDispatchers.containsKey(deepLink.runtimeType)) {
            throw(RouteNotFound(currentRoute));
          }

          // May throw custom errors
          deepLink.onDispatch(navigatorKey.currentContext);
        } catch (_) {
          _currentRoute = accumulatedRoute;
          rethrow;
        }

        accumulatedRoute.add(deepLink);

        // Current path of route
        final accumulatedPath = accumulatedRoute.join("/");

        // Dispatcher for current [deepLink]
        final dispatcher = currentDispatchers[deepLink.runtimeType];

        // Iterate through the recursive graph data structure
        currentDispatchers = dispatcher.dispatchers(
          accumulatedPath,
          deepLink is ValueDeepLink ? deepLink.data : null,
          (Widget widget) {
            // Only push new deep links // FIXME, exclusive index edge case if previous route exists
            // sublist(e) if same base route
            // sublist
            if (previousRoute.isEmpty || currentRoute.sublist(commonElementsInRoutes).contains(deepLink)) {
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
          },
        );
      }
    } on RouteNotFound catch(e) {
      navigateTo(routeNotFoundErrorMapping(e, currentRoute));
    } on Exception catch(e) {
      if (!customErrorRouteMappings.containsKey(e.runtimeType)) {
        print("Couldn't catch ${e.runtimeType}!!!");
        rethrow;
      }

      navigateTo(customErrorRouteMappings[e.runtimeType](e, currentRoute));
    }
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
    _currentRoute = route;
    _shouldAnimateTransition = false;

    handleRouteChanged();
    notifyListeners();
  }

  /// Resets navigation to user's default page.
  void replaceWithDefault() => navigateTo(defaultRoute);

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