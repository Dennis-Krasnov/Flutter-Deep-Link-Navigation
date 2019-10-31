import 'package:deep_link_navigation/src/default_page_loader.dart';
import 'package:flutter/widgets.dart';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:provider/provider.dart';

/// ...
class DeepLinkNavigator extends StatelessWidget {
  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState> navigatorKey;

  /// ...
  final Map<Type, DeepLinkDispatcher> linkDispatchers;

  /// ...
  final Map<Type, ErrorDispatcher> errorDispatchers;

  /// ...
  final Widget splashScreen;

  /// ...
  final List<DeepLink> defaultRoute;

  ///
  // TODO: bottomNavigationBuilder

  const DeepLinkNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.linkDispatchers,
    @required this.errorDispatchers,
    @required this.splashScreen,
    @required this.defaultRoute,
    // TODO: this.bottomNavigationBuilder
  }) : super(key: key);

  /// ...
  static DeepLinkNavigatorState of(BuildContext context) {
    try {
      return Provider.of<DeepLinkNavigatorState>(context, listen: false);
    } on Object catch (_) {
      throw FlutterError(
        """
        DeepLinkNavigator.of() called with a context that does not contain a DeepLinkNavigator.
        No ancestor could be found starting from the context that was passed to DeepLinkNavigator.of().
        This can happen if the context you used comes from a widget above the DeepLinkRouter.
        """,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<DeepLinkNavigatorState>(
      builder: (BuildContext context) => DeepLinkNavigatorState(
        navigatorKey: navigatorKey,
        linkDispatchers: linkDispatchers,
        errorDispatchers: errorDispatchers,
        defaultRoute: defaultRoute,
      ),
      dispose: (BuildContext context, DeepLinkNavigatorState value) => null,
      child: DefaultPageLoader(child: splashScreen),
    );
  }
}
