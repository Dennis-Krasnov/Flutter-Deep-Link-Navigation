import 'dart:async';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// ...
class DeepLinkNavigatorState with ChangeNotifier {
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

  DeepLinkNavigatorState({
    @required this.navigatorKey,
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
        navigatorKey.currentState.pop();
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
              // pass navigator into new context -- FIXME
              ? MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget)
              : NoAnimationPageRoute<dynamic>(builder: (BuildContext context) => widget);

            print("pushing $accumulatedPath");
            navigatorKey.currentState.push(pageRoute);
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
  T pop<T>() {
    _previousRoute = List.from(currentRoute);
    currentRoute.removeLast();

    // Don't handle pops
    notifyListeners();
    return null; // TODO: completer
  }

  /// ...
  @override
  String toString() => currentRoute.join("/");
}

