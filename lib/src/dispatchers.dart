import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Signature for the listener function which takes the [BuildContext] along with the bloc state
/// and is responsible for executing in response to state changes.
/// NULLABLE return ...
typedef RecursiveDeepLinkDispatcher<T> = Map<Type, DeepLinkDispatcher> Function(
  String path,
  T value,
  void Function(Widget) push
);

/// ...
@immutable
class DeepLinkDispatcher<T> {
  /// ...
  final RecursiveDeepLinkDispatcher<T> dispatchers;

  /// ...
  /// eg. XYZDeepLink: DeepLinkDispatcher((path, push) => null;
  DeepLinkDispatcher(Map<Type, DeepLinkDispatcher> Function(String path, void Function(Widget) push) dispatchers)
    : dispatchers = ((String path, T value, void Function(Widget) push) => dispatchers(path, push));

  /// ...
  /// eg. XYZDeepLink: DeepLinkDispatcher<Data>.value((path, value, push) => null;
  DeepLinkDispatcher.value(this.dispatchers);
}


/// Signature for the listener function which takes the [BuildContext] along with the bloc state
/// and is responsible for executing in response to state changes.
/// NULLABLE return ...
typedef RecursiveErrorDispatcher<T extends Exception> = Map<Type, ErrorDispatcher> Function(
    String path,
    T error,
    void Function(Widget) push
    );

/// ...
@immutable
class ErrorDispatcher<T extends Exception> {
  /// ...
  final RecursiveErrorDispatcher<T> dispatchers;

  /// ...
  /// eg. XYZDeepLink: DeepLinkDispatcher((path, error, push) => null;
  ErrorDispatcher(this.dispatchers);

/// ...
/// eg. XYZDeepLink: DeepLinkDispatcher<Data>.value((path, value, push) => null;
//  ErrorDispatcher.value(RecursiveErrorDispatcher<T> dispatchers)
//    : dispatchers = ((String path, T value, void Function(Widget) push) => dispatchers(path, value, push));
}

/// ...
class RouteNotFound implements Exception {
  /// ...
  String path;

  RouteNotFound(this.path);

  @override
  String toString() => "Route not found: $path";
}