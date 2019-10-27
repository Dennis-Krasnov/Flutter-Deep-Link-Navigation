import 'package:after_layout/after_layout.dart';
import 'package:deep_link_navigation/src/deep_link_navigator.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DefaultPageLoader extends StatefulWidget {
  final Widget child;

  const DefaultPageLoader({Key key, this.child}) : super(key: key);

  @override
  _DefaultPageLoaderState createState() => _DefaultPageLoaderState();
}

class _DefaultPageLoaderState extends State<DefaultPageLoader> with AfterLayoutMixin<DefaultPageLoader> {
  @override
  void afterFirstLayout(BuildContext context) {
    final nav = Provider.of<DeepLinkNavigator>(context, listen: false); // TODO
    print("NAVIGATING TO DEFAULT ROUTE: ${nav.defaultRoute}");
    nav.navigateTo(nav.defaultRoute);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}