import 'package:flutter/material.dart';

/// Syncs flutter's native navigator pop events with [navigationBloc].
/// Only relays pop event when a real pop event occurs (not part of deep linking).
/// eg. Navigator(observers: [NavigationPopObserver(BlocProvider.of<NavigationBloc>(context))])
//class PopObserver extends NavigatorObserver {
//  final NavigationBloc navigationBloc;
//
//  PopObserver(this.navigationBloc);
//
//  @override
//  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
//    // [route.settings.name] is the path from which the pop was initiated
//    // Route's path is different from current path only when popping to lowest common ancestor
//    if (route.settings.name == (navigationBloc.currentState as NavigationRoute).currentPath()) {
//      navigationBloc.dispatch(Pop());
//    }
//  }
//}