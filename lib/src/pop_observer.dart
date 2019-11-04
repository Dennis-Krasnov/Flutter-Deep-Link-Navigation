import 'package:flutter/material.dart';

import 'package:deep_link_navigation/deep_link_navigation.dart';

/// Notifies [DeepLinkNavigator] of a pop that occurred from the native flutter navigator.
/// Handles android back button, back arrow, and [DeepLinkNavigator.pop()] calls native pop.
///
/// eg. Navigator(observers: [PopObserver()])
class PopObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) => DeepLinkNavigator.of(route.navigator.context).notifyPopped();
}