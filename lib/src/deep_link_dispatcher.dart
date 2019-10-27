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