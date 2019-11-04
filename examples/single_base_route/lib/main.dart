import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';

import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/dispatchers.dart';
import 'package:single_base_route/widgets/splash_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DeepLinkMaterialApp(
    // This is where the magic happens
    linkDispatchers: linkDispatchers,
    routeNotFoundErrorMapping: (RouteNotFound exception, _) => [LibraryDL(), ErrorDL(exception)],
    defaultRoute: [LibraryDL()],
    splashScreen: SplashPage(),
    // Non-navigation related fields are still available
    themeMode: ThemeMode.light,
  );
}