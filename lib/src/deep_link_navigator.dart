import 'dart:async';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/widgets.dart';

/// ...
class DeepLinkNavigator with ChangeNotifier {
  /// ...
  final NavigatorState navigator;

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

  DeepLinkNavigator({@required this.navigator, @required this.defaultRoute})
    : assert(defaultRoute.isNotEmpty), _currentRoute = defaultRoute;

  /// Push the given [deepLink] onto the navigator.
  Future<T> push<T extends Object>(DeepLink deepLink) async {
    //
//    final completer = Completer<T>();

    //
    _previousRoute = currentRoute;
    currentRoute.add(deepLink); // , completer
    notifyListeners();

    return null; // completer.future
    //
//    return navigator.pushNamed<T>(currentRoute.join("/"));
  }

  void switchBaseRoute() {
    // TODO: separate class?
  }

  void goTo(List<DeepLink> route) {
    _previousRoute = currentRoute;
    _currentRoute = route;
    notifyListeners();
  }

  T pop<T>() {
    _previousRoute = currentRoute;
    currentRoute.removeLast();
    // DON'T NOTIFY
    return null;
  }

  @override
  String toString() => currentRoute.join("/");
}

//@immutable
//class DeepLinkDispatcher {
//  final RecursiveDeepLinkDispatcher dispatcher;
//  DeepLinkDispatcher(this.dispatcher);
//}
//
//@immutable
//class PathDeepLinkHandler extends DeepLinkHandler{
////  final Map<Type, DeepLinkHandler> Function(String path, dynamic value, void Function(Widget) push) router;
//
//  PathDeepLinkHandler(Map<Type, DeepLinkHandler> Function(String path, void Function(Widget) push) router) : super(router);
//}
