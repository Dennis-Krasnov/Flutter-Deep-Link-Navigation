import 'package:deep_link_navigation/src/dispatchers.dart';
import 'package:flutter/material.dart';
import 'package:deep_link_navigation/src/deep_link_transition.dart';

class DeepLinkTransitions {
  static PathTransitionBuilder fadeTransition({
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

  static PathTransitionBuilder rightToLeftTransition({
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

  static PathTransitionBuilder leftToRightTransition({
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

  static PathTransitionBuilder upToDownTransition({
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
  
  static PathTransitionBuilder downToUpTransition({
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

  static PathTransitionBuilder scaleTransition({
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

  static PathTransitionBuilder rotateTransition({
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

  static PathTransitionBuilder sizeTransition({
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

  static PathTransitionBuilder rightToLeftWithFadeTransition({
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

  static PathTransitionBuilder leftToRightWithFadeTransition({
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

  static PathTransitionBuilder customTransition(
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
