import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

// TODO: make private, move to utils
// inclusive
int indexOfLastCommonElement(Iterable a, Iterable b) {
  int smallerLength = math.min(a.length, b.length);
  for (int i = 0; i < smallerLength; i++) {
    if (a.elementAt(i) != b.elementAt(i)) {
      return i + 1;
    }
  }
  return smallerLength;
}

/// ...
class DeepLinkConsumer extends Consumer<DeepLinkNavigator> {
  /// ...
  final Map<Type, DeepLinkDispatcher> baseDispatchers;

  /// ...
  final Map<Type, DeepLinkDispatcher> errorDispatchers;

  DeepLinkConsumer(this.baseDispatchers, {Key key, @required this.errorDispatchers}) : super(
    key: key,
    builder: (BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) {
      // Ensure exceptions can be properly caught and avoid entering an infinite loop
      if (!errorDispatchers.containsKey(RouteNotFound)) {
        // TODO: give example implementation in error message
        // TODO: remove errorDispatchers???...?
        throw UnimplementedError("Please specify a deep link dispatcher for `RouteExceptionDL`");
      }
      if (!errorDispatchers.containsKey(Exception)) {
        throw UnimplementedError("Please specify a deep link dispatcher for `RouteNotFoundDL`");
      }

      // 
      final commonElementsCount = indexOfLastCommonElement(deepLinkNavigator.previousRoute ?? [], deepLinkNavigator.currentRoute);
      print("previous route: ${deepLinkNavigator.previousRoute ?? []}");
      print("current route: ${deepLinkNavigator.currentRoute ?? []}");
      print("common elements count $commonElementsCount");

      // Pop to lowest common ancestor
      if (commonElementsCount < (deepLinkNavigator?.previousRoute?.length ?? 0)) {
        // Pop the extra deep links in the previous route
        for (final deepLink in deepLinkNavigator.previousRoute?.sublist(commonElementsCount) ?? []) {
          deepLinkNavigator.navigator.pop();
          print("popping $deepLink");
        }
      }
      
      //
      var accumulatedRoute = deepLinkNavigator.currentRoute.sublist(0, commonElementsCount);
    
      //
      var currentDispatchers = baseDispatchers;
      
      try {
        // Push the new deep links in the current route
        for (final deepLink in deepLinkNavigator.currentRoute.sublist(commonElementsCount)) {
          accumulatedRoute.add(deepLink);

          // Current path of route
          final accumulatedPath = accumulatedRoute.join("/");

          if (currentDispatchers == null || !currentDispatchers.containsKey(deepLink.runtimeType)) {
            throw RouteNotFound(accumulatedPath);
          }

          // Custom logic
          final customErrorWidget = deepLink.onDispatch(context);
//          if (customErrorWidget != null) {
//            FIXME: easier to throw, do catching logic with matchers !!!
//          }

          // Dispatcher for current [deepLink]
          final dispatcher = currentDispatchers[deepLink.runtimeType];

          // Iterate through the recursive graph data structure
          currentDispatchers = dispatcher.dispatchers(
            accumulatedPath,
            deepLink is ValueDeepLink ? deepLink.data : null,
            (Widget widget) {
              // Conditionally animate transition
              final pageRoute = deepLinkNavigator.shouldAnimateTransition
                ? MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget)
                : NoAnimationMaterialPageRoute<dynamic>(builder: (BuildContext context) => widget);

              // FIXME: move this to https://pub.dev/packages/after_layout
              // TODO: recreate Consumer but as a stateful widget, it would also hold its global navigator key (for multiple pages)
              // TODO: ^^ might not work, see how bloc listener works!!!
              print("pushing $accumulatedPath");
              deepLinkNavigator.navigator.push(pageRoute);
            },
          );
        }
      } on UnimplementedError catch(e) {
        // avoid recursion with unspecified routes...
        throw e;
//        print(e);
      } on Exception catch(e) {
        // TODO: pop to /, push specified routeExceptionWidget
        // TODO: type matching here too!
        // includes routenotfound case ^^
        print(e);
      }

      // The user should never see this widget but for a sliver at the start (until first frame) ...
      return Container();
//      return child; // TODO: make this the child as specified splashWidget
    },
  );
}

/// Page route without animations.
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false, // TODO
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => child;
}

/// ...
class RouteNotFound implements Exception {
  /// ...
  String path;

  RouteNotFound(this.path);

  @override
  String toString() => "Route not found: $path";
}