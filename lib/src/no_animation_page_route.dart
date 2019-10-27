import 'package:flutter/material.dart';

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
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => child;
}