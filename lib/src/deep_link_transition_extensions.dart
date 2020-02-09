import 'package:flutter/material.dart';
import 'package:deep_link_navigation/src/deep_link_transition.dart';

extension PageTransitionExtension on Widget {
  PageTransition fadeTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.fade,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition rightToLeftTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.rightToLeft,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition leftToRightTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.leftToRight,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition upToDownTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.upToDown,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );
  
  PageTransition downToUpTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.downToUp,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition scaleTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.scale,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition rotateTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.rotate,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition sizeTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.size,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition rightToLeftWithFadeTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.rightToLeftWithFade,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition leftToRightWithFadeTransition({
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: PageTransitionType.leftToRightWithFade,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );

  PageTransition customTransition(
    PageTransitionType type, {
    Key key,
    Curve curve = Curves.linear,
    Alignment alignment,
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      PageTransition(
        key: key,
        type: type,
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: this,
      );
}
