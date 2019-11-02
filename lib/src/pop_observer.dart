import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';

/// Syncs flutter's native navigator pop events with [navigationBloc].
/// Only relays pop event when a real pop event occurs (not part of deep linking).
/// eg. Navigator(observers: [NavigationPopObserver(BlocProvider.of<NavigationBloc>(context))])
class PopObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) =>
    DeepLinkNavigator.of(route.navigator.context).notifyPopped();
}