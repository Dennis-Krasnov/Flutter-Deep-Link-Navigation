import 'dart:async';
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

  ValueDeepLink(String path, this.data) : super("$path/$data");
}

/// ...
/// eg. final deepLink = XYZBase64DeepLink(serialize(data));
/// eg. final deserialized = deserialize(deepLink.decode());
abstract class Base64DeepLink extends ValueDeepLink<String> {
  /// ...
  static String _base64Encoded(String original) {
    final bytes = utf8.encode(original);
    return base64.encode(bytes);
  }

  String decode() {
    final bytes = base64.decode(data);
    return String.fromCharCodes(bytes);
  }

  Base64DeepLink(String path, String data) : super("$path/${_base64Encoded(data)}", _base64Encoded(data));
}

// FIXME: how does one serialize a function - just use base64, manually deserialize!!


// TODO: ValueDeepLink2<T1, T2> extends DeepLink ... (upto 5?)
// https://github.com/dart-lang/sdk/issues/16253 (can easily do: List<dynamic> arguments ... "${arguments.join("/")}")

/// ...
// TODO: question: how do I make this full screen if it's a custom parameter...?
// TODO: must specify exception handlers instead!
//class RouteNotFoundDL extends ValueDeepLink<String> {
//  RouteNotFoundDL(String routePath) : super("route-not-found", routePath);
//}
//
///// ...
//class RouteExceptionDL extends ValueDeepLink<Object> {
//  RouteExceptionDL(Object error) : super("route-exception", error);
//}