import 'package:after_layout/after_layout.dart';
import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/widgets.dart';

class DefaultPageLoader extends StatefulWidget {
  final Widget child;

  const DefaultPageLoader({Key key, this.child}) : super(key: key);

  @override
  _DefaultPageLoaderState createState() => _DefaultPageLoaderState();
}

class _DefaultPageLoaderState extends State<DefaultPageLoader> with AfterLayoutMixin<DefaultPageLoader> {
  @override
  void afterFirstLayout(BuildContext context) {
    print("After first layout :3");
    DeepLinkNavigator.of(context).replaceWithDefault();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}