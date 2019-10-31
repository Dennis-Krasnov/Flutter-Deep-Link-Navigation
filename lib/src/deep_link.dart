import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Base class for all deep links.
/// eg. final deepLink = XYZDeepLink();
@immutable
abstract class DeepLink {
  /// ...
  final String path;

  DeepLink(this.path);

  /// for custom behaviour/mixins ... throw stuff
  /// Does nothing by default...
  @mustCallSuper
  void onDispatch(BuildContext context) {}

  @override
  String toString() => path;
}

/// ...
/// eg. final deepLink = XYZValueDeepLink<int>(42);
abstract class ValueDeepLink<T> extends DeepLink {
  /// ...
  final T data;

  ValueDeepLink(String path, this.data, {String Function(T) toString})
    : super("$path/${toString != null ? toString(data) : data}");
}

/// ... ONLY MAKES THE toString prettier!!!! (no long json)
/// eg. final deepLink = XYZBase64DeepLink(data);
abstract class Base64DeepLink extends ValueDeepLink<String> {
  /// ...
  static String _base64Encoded(String original) {
    final bytes = utf8.encode(original);
    return base64.encode(bytes);
  }

  Base64DeepLink(String path, String data) : super(path, data, toString: (data) => _base64Encoded(data));
}