import 'package:deep_link_navigation/src/dispatchers.dart';
import 'package:flutter/material.dart';
import 'package:deep_link_navigation/src/deep_link_transition.dart';

class DeepLinkTransitions {
  static PathTransitionBuilder fade({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.fade,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder rightToLeft({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.rightToLeft,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder leftToRight({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.leftToRight,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder upToDown({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.upToDown,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );
  
  static PathTransitionBuilder downToUp({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.downToUp,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder scale({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.scale,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder rotate({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.rotate,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder size({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.size,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder rightToLeftWithFade({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.rightToLeftWithFade,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder leftToRightWithFade({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: DeepLinkTransitionType.leftToRightWithFade,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );

  static PathTransitionBuilder custom(
    DeepLinkTransitionType type, {
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) => (child) =>
      DeepLinkTransition(
        key: key,
        type: type,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: child,
      );
}
