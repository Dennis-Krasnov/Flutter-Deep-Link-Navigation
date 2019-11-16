import 'package:flutter/widgets.dart';

import 'package:deep_link_navigation/src/deep_link.dart';

/// Widget for route.
typedef PathBuilder = Widget Function(String path);

/// Widget for route with [value].
typedef ValueBuilder<T> = Widget Function(T value, String path);

/// Route mapping for [exception].
typedef ErrorMapping = List<DeepLink> Function(Exception exception, String path);

/// Dispatcher for this level of navigation.
typedef NavigationBuilder = Dispatcher Function(BuildContext context);

/// Dispatcher for this level of navigation with [value].
typedef NavigationValueBuilder<T> = Dispatcher Function(BuildContext context, T value);

/// A non-leaf node in the navigation hierarchy tree.
class Dispatcher {
  /// Internal representation of widget builders.
  /// Values must be dynamic since function parameter types don't upcast.
  /// Ideally, the value type would be `ValueBuilder<dynamic>`.
  Map<Type, dynamic> _routeBuilders = {};
  Map<Type, dynamic> get routeBuilders => _routeBuilders;

  /// Internal representation of error mappings.
  Map<Type, ErrorMapping> _errorMappers = {};
  Map<Type, ErrorMapping> get errorMappers => _errorMappers;

  /// Internal representation of deep link navigation hierarchy.
  /// Ideally the value type would be `NavigationValueBuilder<dynamic>`.
  Map<Type, dynamic> _subNavigations = {};
  Map<Type, dynamic> get subNavigations => _subNavigations;

  /// Add a path widget builder to this level of hierarchy.
  void path<DL extends DeepLink>(
    PathBuilder builder,
    {NavigationBuilder subNavigation}
  ) {
    assert(DL != dynamic, "A deep link type must be specified.");
    assert(!routeBuilders.containsKey(DL), "A widget builder for ${DL.runtimeType} has already beed defined.");
    assert(builder != null);

    _routeBuilders[DL] = (_, path) => builder(path);

    if (subNavigation != null) {
      _subNavigations[DL] = (context, _) => subNavigation(context);
    }
  }

  /// Add a value widget builder to this level of hierarchy.
  void value<T, DL extends ValueDeepLink<T>>(
    Widget Function(T value, String path) builder,
    {NavigationValueBuilder<T> subNavigation}
  ) {
    assert(T != dynamic, "Data type must be specified.");
    assert(DL != dynamic, "A deep link type must be specified.");
    assert(!routeBuilders.containsKey(DL), "A widget builder for ${DL.runtimeType} has already beed defined.");
    assert(builder != null);

    _routeBuilders[DL] = builder;

    if (subNavigation != null) {
      _subNavigations[DL] = subNavigation;
    }
  }

  /// Add a exception mapping to this level of hierarchy.
  void exception<E extends Exception>(ErrorMapping mapper) {
    assert(E != dynamic, "An error type must be specified.");
    assert(!routeBuilders.containsKey(E), "An error mapping for ${E.runtimeType} has already beed defined.");
    assert(mapper != null);

    _errorMappers[E] = mapper;
  }
}