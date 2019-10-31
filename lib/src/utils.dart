import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ...
int indexOfLastCommonElement(Iterable a, Iterable b) {
  int smallerLength = math.min(a.length, b.length);
  for (int i = 0; i < smallerLength; i++) {
    if (a.elementAt(i) != b.elementAt(i)) {
      // inclusive
      return i + 1;
    }
  }
  return smallerLength;
}

// TODO: on pop scope only needed for nested ...

/// Page route without animations.
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false, // TODO
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => child;
}