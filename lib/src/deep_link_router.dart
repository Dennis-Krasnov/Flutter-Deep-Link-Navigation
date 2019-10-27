import 'package:deep_link_navigation/src/default_page_loader.dart';
import 'package:flutter/widgets.dart';

import 'package:deep_link_navigation/src/error_dispatcher.dart';
import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:provider/provider.dart';

/// ...
class DeepLinkRouter extends StatelessWidget {
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

  const DeepLinkRouter({
    Key key,
    @required this.linkDispatchers,
    @required this.errorDispatchers,
    @required this.splashScreen,
    @required this.defaultRoute,
    // TODO: this.bottomNavigationBuilder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<DeepLinkNavigator>(
      builder: (BuildContext context) => DeepLinkNavigator(
        navigator: Navigator.of(context),
        linkDispatchers: linkDispatchers,
        errorDispatchers: errorDispatchers,
        defaultRoute: defaultRoute,
      ),
      dispose: (BuildContext context, DeepLinkNavigator value) => null,
      child: DefaultPageLoader(child: splashScreen),
    );
  }
}

