import 'package:after_layout/after_layout.dart';
import 'package:flutter/widgets.dart';

import 'package:deep_link_navigation/deep_link_navigation.dart';

/// Navigates to default route after first build.
class DefaultRouteLoader extends StatefulWidget {
  /// The widget that is below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  const DefaultRouteLoader({Key key, this.child}) : super(key: key);

  @override
  _DefaultRouteLoaderState createState() => _DefaultRouteLoaderState();
}

class _DefaultRouteLoaderState extends State<DefaultRouteLoader> with AfterLayoutMixin<DefaultRouteLoader> {
  @override
  void afterFirstLayout(BuildContext context) => DeepLinkNavigator.of(context).replaceWithDefault();

  @override
  Widget build(BuildContext context) => widget.child;
}