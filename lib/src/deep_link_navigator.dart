import 'dart:async';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/no_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:math' as math;


/// ...
class DeepLinkNavigator with ChangeNotifier {
  /// ...
  final NavigatorState navigator;

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

  DeepLinkNavigator({
    @required this.navigator,
    @required this.linkDispatchers,
    @required this.errorDispatchers,
    @required this.defaultRoute
  }) : assert(defaultRoute.isNotEmpty);

  /// ...
  void handleRouteChanged() {
    //
    final commonElementsCount = indexOfLastCommonElement(previousRoute ?? [], currentRoute);

    // Pop to lowest common ancestor
    if (commonElementsCount < (previousRoute?.length ?? 0)) {
      // Pop the extra deep links in the previous route
      for (final deepLink in previousRoute?.sublist(commonElementsCount) ?? []) {
        navigator.pop();
        print("popping $deepLink");
      }
    }

    //
    var accumulatedRoute = currentRoute.sublist(0, commonElementsCount);

    //
    var currentDispatchers = linkDispatchers;

    print("comon element count: $commonElementsCount");
    print("prev: $previousRoute");
    print("current: $currentRoute");
    print("accumulated: $accumulatedRoute");
    print("current dispatcher $currentDispatchers");

    try {
      // Push the new deep links in the current route
      for (final deepLink in currentRoute.sublist(commonElementsCount)) {
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
            // Conditionally animate transition
            final pageRoute = shouldAnimateTransition
                // REUSE CONTEXT -- FIXME
                ? MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget)
                : NoAnimationPageRoute<dynamic>(builder: (BuildContext context) => widget);

            print("pushing $accumulatedPath");
            navigator.push(pageRoute);
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

  /// Push the given [deepLink] onto the navigator.
  Future<T> push<T extends Object>(DeepLink deepLink) async {
//    final completer = Completer<T>();

    _previousRoute = currentRoute;
    currentRoute.add(deepLink); // , completer

    handleRouteChanged();
    notifyListeners();

    return null; // completer.future
  }

  ///
//  void replaceWithDefault() {
//    // Ensure exceptions can be properly caught and avoid entering an infinite loop
//    if (!errorDispatchers.containsKey(RouteNotFound)) {
//      // TODO: give example implementation in error message
//      throw UnimplementedError("Please specify a deep link dispatcher for `RouteExceptionDL`");
//    }
//    if (!errorDispatchers.containsKey(Exception)) {
//      throw UnimplementedError("Please specify a deep link dispatcher for `RouteNotFoundDL`");
//    }
//
//    _previousRoute = currentRoute;
//    _currentRoute = defaultRoute;
//
//    if (linkDispatchers == null || !linkDispatchers.containsKey(deepLink.runtimeType)) {
//      throw RouteNotFound(accumulatedPath);
//    }
//
//    final dispatcher = currentDispatchers[deepLink.runtimeType];
//
//    navigator.push(NoAnimationPageRoute<dynamic>(builder: (BuildContext context) => widget));
//
//    handleRouteChanged();
//    notifyListeners();
//  }

  /// ...
  void navigateTo(List<DeepLink> route) {
    _previousRoute = currentRoute;
    _currentRoute = route;

    handleRouteChanged();
    notifyListeners();
  }

  /// ...
  T pop<T>() {
    _previousRoute = currentRoute;
    currentRoute.removeLast();

    // Don't handle pops
    notifyListeners();
    return null; // TODO: completer
  }

  /// ...
  @override
  String toString() => currentRoute.join("/");

//  static final DeepLinkNavigator _singleton = DeepLinkNavigator._internal();
//
//  factory DeepLinkNavigator() => _singleton;
//
//  DeepLinkNavigator._internal(this.navigator, this.linkDispatchers, this.errorDispatchers, this.defaultRoute) {}

//  DeepLinkNavigator.navigateTo()
//  DeepLinkNavigator.navigateTo()

}

int indexOfLastCommonElement(Iterable a, Iterable b) {
  int smallerLength = math.min(a.length, b.length);
  for (int i = 0; i < smallerLength; i++) {
    if (a.elementAt(i) != b.elementAt(i)) {
      // inclusive
      return i + 1;
    }
  }
  return smallerLength;
}