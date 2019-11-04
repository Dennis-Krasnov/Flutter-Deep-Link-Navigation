import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Wrapper for recursive definition of [DeepLinkDispatcher]s.
/// [value] is optional.
/// Return to signify end of route hierarchy.
typedef RecursiveDeepLinkDispatcher = Map<Type, DeepLinkDispatcher> Function(
  String path,
  dynamic value,
  void Function(Widget) push
);

/// Recursive data structure to represent deep link navigation hierarchy.
@immutable
class DeepLinkDispatcher {
  /// Method that pushes current page and generates sub-navigation hierarchy.
  final RecursiveDeepLinkDispatcher dispatchers;

  /// eg. XYZDeepLink: DeepLinkDispatcher((path, push) => null);
  DeepLinkDispatcher(Map<Type, DeepLinkDispatcher> Function(String path, void Function(Widget) push) dispatchers)
    : dispatchers = ((String path, dynamic value, void Function(Widget) push) => dispatchers(path, push));

  /// eg. XYZDeepLink: DeepLinkDispatcher<Data>.value((path, value, push) => null);
  DeepLinkDispatcher.value(this.dispatchers);
}