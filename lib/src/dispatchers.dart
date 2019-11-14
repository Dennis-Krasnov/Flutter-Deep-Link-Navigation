import 'package:flutter/widgets.dart';

import 'package:deep_link_navigation/src/deep_link.dart';

/// Dispatcher for single route.
typedef PathBuilder = Widget Function(BuildContext context, String path);

/// Dispatcher for single route with [value].
typedef ValueBuilder<T> = Widget Function(BuildContext context, T value, String path);

///
typedef ErrorMapping = List<DeepLink> Function(BuildContext context, Exception exception, String path);

/// Mutate [dispatcher] to build next level of navigation.
typedef NavigationBuilder = Dispatcher Function(Dispatcher dispatcher);

/// A non-leaf node in the navigation hierarchy tree.
class Dispatcher {
  /// Internal representation of route dispatchers.
  Map<Type, dynamic> _routeBuilders = {};
  Map<Type, dynamic> get routeBuilders => _routeBuilders;

  /// Internal representation of error dispatchers.
  Map<Type, ErrorMapping> _errorMappers = {};
  Map<Type, ErrorMapping> get errorMappers => _errorMappers;

  /// Internal representation of deep link navigation hierarchy.
  Map<Type, NavigationBuilder> _subNavigationBuilders = {};
  Map<Type, NavigationBuilder> get subNavigationBuilders => _subNavigationBuilders;

  // TODO: merge ^^ into most recent dispatcher of errors

  /// Add a path route dispatcher to this level of hierarchy.
  void path<DL extends DeepLink>(
    PathBuilder builder,
    {NavigationBuilder subNavigationBuilder}
  ) {
    assert(DL != dynamic, "A deep link type must be specified.");
    assert(!routeBuilders.containsKey(DL), "A dispatcher for ${DL.runtimeType} has already beed defined.");
    assert(builder != null); // TODO: later check that resulting widget isn't null
//    assert(subNavigation == null || subNavigation) // TODO: later check that resulting subNavigation isn't null

    _routeBuilders[DL] = (context, _, path) => builder(context, path);// as dynamic;
//    _routeBuilders.putIfAbsent(DL, (context, _, path) => builder(context, path));

    if (subNavigationBuilder != null) {
      _subNavigationBuilders[DL] = subNavigationBuilder;
    }
  }

  /// Add a value route dispatcher to this level of hierarchy.
  void value<T, DL extends ValueDeepLink<T>>(
    Widget Function(BuildContext context, T value, String path) builder,
    {NavigationBuilder subNavigationBuilder}
  ) {
    assert(T != dynamic, "Data type must be specified.");
    assert(DL != dynamic, "A deep link type must be specified.");
    assert(!routeBuilders.containsKey(DL), "A dispatcher for ${DL.runtimeType} has already beed defined.");
    assert(builder != null); // TODO: later check that resulting widget isn't null
//    assert(subNavigation == null || subNavigation) // TODO: later check that resulting subNavigation isn't null

    _routeBuilders[DL] = builder;
//    _routeBuilders.putIfAbsent(DL, builder as dynamic);

    if (subNavigationBuilder != null) {
      _subNavigationBuilders[DL] = subNavigationBuilder;
    }
  }

  // TAKES TOP-MOST (keep updating map though iterations)
  void exception<E extends Exception>(ErrorMapping mapper) {
    assert(E != dynamic, "An error type must be specified.");
    assert(!routeBuilders.containsKey(E), "A dispatcher for ${E.runtimeType} has already beed defined.");
    assert(mapper != null); // TODO: later check that resulting widget isn't null

    _errorMappers[E] = mapper;
  }
}

// voided functions solve problem with . vs ..
//void main() {
//  App(
//    // ...
//    // FIXME: Don't provide context ?! - context would allow BlocProvider.of<Bloc>(context).currentState... !!!
//    navigation: (baseDispatcher) => baseDispatcher
//      ..path<TestDL>((context, path) => Container())
//      ..path<TestDL>(
//        (context, path) => Container(),
//        subNavigation: (dispatcher) => dispatcher
//          ..value<int, VTestDL>((context, value, path) => Container())
//          ..path<TestDL>((context, path) => Container()),
//      ),
//    // ...
//  );
//}

// TODO: use extension methods to condense large sub dispatcher builders (bring return close to definition)