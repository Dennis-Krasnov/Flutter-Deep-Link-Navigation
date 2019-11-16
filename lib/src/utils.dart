import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Used to compare how many deep links in a route match another route.
int indexOfLastCommonElement(Iterable a, Iterable b) {
  int smallerLength = math.min(a.length, b.length);
  for (int i = 0; i < smallerLength; i++) {
    if (a.elementAt(i) != b.elementAt(i)) {
      return i;
    }
  }
  return smallerLength;
}

/// Page route transition without an animation.
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false, // TODO makes 'x' icon instead of '<-'
  }) : super(
    builder: builder,
    maintainState: maintainState,
    settings: settings,
    fullscreenDialog: fullscreenDialog
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => child;
}