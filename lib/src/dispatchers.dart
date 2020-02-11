import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:deep_link_navigation/src/deep_link.dart';

/// Path Transition builder for path
typedef PathTransitionBuilder = Route Function(Widget widget);

/// Widget for deeplink route.
typedef PathBuilder = Widget Function(List<DeepLink> route);

/// Widget for deeplink route with [value].
typedef ValueBuilder<T> = Widget Function(T value, List<DeepLink> route);

/// Route mapping for [exception].
typedef ErrorMapping = List<DeepLink> Function(
    Exception exception, List<DeepLink> route);

/// Dispatcher for this level of navigation with [value].
typedef NavigationValueBuilder<T> = Dispatcher Function(T value);

/// A non-leaf node in the navigation hierarchy tree.
class Dispatcher {
  /// Internal representation of widget builders.
  /// Values must be dynamic since function parameter types don't upcast.
  /// Ideally, the value type would be `ValueBuilder<dynamic>`.
  Map<Type, dynamic> _routeBuilders = {};
  Map<Type, dynamic> get routeBuilders => _routeBuilders;

  /// Internal representation of transition builders.
  /// Values must be dynamic since function parameter types don't upcast.
  /// Ideally, the value type would be `PathTransitionBuilder<dynamic>`.
  Map<Type, dynamic> _transitionBuilders = {};
  Map<Type, dynamic> get transitionBuilders => _transitionBuilders;

  /// Internal representation of error mappings.
  Map<Type, ErrorMapping> _errorMappers = {};
  Map<Type, ErrorMapping> get errorMappers => _errorMappers;

  /// Internal representation of deep link navigation hierarchy.
  /// Ideally the value type would be `NavigationValueBuilder<dynamic>`.
  Map<Type, dynamic> _subNavigations = {};
  Map<Type, dynamic> get subNavigations => _subNavigations;

  /// Add a path widget builder to this level of hierarchy.
  void path<DL extends DeepLink>(
    PathBuilder builder, {
    PathTransitionBuilder transition,
    Dispatcher subNavigation,
  }) {
    assert(DL != dynamic, "A deep link type must be specified.");
    assert(!routeBuilders.containsKey(DL),
        "A path builder for ${DL.runtimeType} has already beed defined.");
    assert(builder != null);

    _routeBuilders[DL] = (_, route) => builder(route);

    if (transition != null) {
      transitionBuilders[DL] = transition;
    }

    if (subNavigation != null) {
      _subNavigations[DL] = (_) => subNavigation;
    }
  }

  /// Add a value widget builder to this level of hierarchy.
  void value<T, DL extends ValueDeepLink<T>>(
    ValueBuilder<T> builder, {
    PathTransitionBuilder transition,
    NavigationValueBuilder<T> subNavigation,
  }) {
    assert(T != dynamic, "Data type must be specified.");
    assert(DL != dynamic, "A deep link type must be specified.");
    assert(!routeBuilders.containsKey(DL),
        "A widget builder for ${DL.runtimeType} has already beed defined.");
    assert(builder != null);

    _routeBuilders[DL] = builder;

    if (transition != null) {
      transitionBuilders[DL] = transition;
    }

    if (subNavigation != null) {
      _subNavigations[DL] = subNavigation;
    }
  }

  /// Add a exception mapping to this level of hierarchy.
  void exception<E extends Exception>(ErrorMapping mapper) {
    assert(E != dynamic, "An error type must be specified.");
    assert(!routeBuilders.containsKey(E),
        "An error mapping for ${E.runtimeType} has already beed defined.");
    assert(mapper != null);

    _errorMappers[E] = mapper;
  }
}
