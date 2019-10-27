import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

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