import 'package:flutter/widgets.dart';

/// Base class for all deep links.
///
/// eg. final deepLink = XYZDeepLink();
@immutable
abstract class DeepLink {
  /// Human-readable representation of deep link.
  final String path;

  DeepLink(this.path);

  /// Mixins on [DeepLink] may override [onDispatch] to perform validation that throws custom errors.
  /// May validate against state accessed through context, or defined as a global/static variable.
  /// Does nothing by default.
  void onDispatch(BuildContext context) {}

  @override
  String toString() => path;
}

/// Deep link that also stores typed data.
/// May override [toString()] to provide human-readable data representation.
///
/// eg. final deepLink = XYZValueDeepLink<int>(42);
/// eg. class SongDL extends ValueDeepLink<Song> {
///         SongDL(Song song) : super("song", song, toString: (song) => song.id);
///     }
abstract class ValueDeepLink<T> extends DeepLink {
  final T data;

  ValueDeepLink(String path, this.data, {String Function(T) toString})
    : super("$path/${toString != null ? toString(data) : data}");
}

/// Value deep link that base64 encodes its [toString] representation.
/// Shouldn't manually override toString().
///
/// eg. final deepLink = XYZBase64DeepLink(data);
/// TODO: test this deep link
//import 'dart:convert';
//abstract class Base64DeepLink extends ValueDeepLink<String> {
//  /// Converts [original] to base64 representation.
//  static String _base64Encoded(String original) {
//    final bytes = utf8.encode(original);
//    return base64.encode(bytes);
//  }
//
//  Base64DeepLink(String path, String data) : super(path, data, toString: (data) => _base64Encoded(data));
//}