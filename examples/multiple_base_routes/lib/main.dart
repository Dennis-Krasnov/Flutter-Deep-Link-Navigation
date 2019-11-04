import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:multiple_base_routes/data.dart';

import 'package:multiple_base_routes/deep_links.dart';
import 'package:multiple_base_routes/dispatchers.dart';
import 'package:multiple_base_routes/widgets/splash_page.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(
  // State management of your choice
  ChangeNotifierProvider<AuthenticationService>(
    builder: (_) => AuthenticationService(),
    child: MusicApp(),
  )
);

/// [DeepLink]s associated with the bottom navigation.
final bottomNavigationDeepLinks = [LibraryDL(), FavoritesDL(), UserDL()];

/// Current index of bottom navigation based on [currentRoute].
int currentIndex(List<DeepLink> currentRoute) {
  final index = bottomNavigationDeepLinks.indexOf(currentRoute?.first);
  return index != -1 ? index : 0;
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DeepLinkMaterialApp(
    // This is where the magic happens
    linkDispatchers: linkDispatchers,
    routeNotFoundErrorMapping: (RouteNotFound exception, _) => [ErrorDL(exception)],
    defaultRoute: [LibraryDL()],
    splashScreen: SplashPage(),
    // Exceptions are thrown by custom deep link mixins
    customErrorRouteMappings: {
      Unauthenticated: (exception, _) => [LoginDL()],
    },
    // Optionally specify always visible widgets
    childBuilder: (BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) => Scaffold(
      body: child,
      // Don't show bottom navigation while [currentRoute] is null, or any deep list is [FullScreen]
      bottomNavigationBar: deepLinkNavigator.currentRoute?.any((dl) => dl is FullScreen) ?? true ? null : BottomNavigationBar(
        currentIndex: currentIndex(deepLinkNavigator.currentRoute),
        onTap: (int index) => deepLinkNavigator.navigateTo([bottomNavigationDeepLinks[index]]),
        items: [
          BottomNavigationBarItem(title: Text("Library"), icon: Icon(Icons.queue_music)),
          BottomNavigationBarItem(title: Text("Favorites"), icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(title: Text("User"), icon: Icon(Icons.person)),
        ],
      ),
    ),
    // Non-navigation related fields are still available
    themeMode: ThemeMode.light,
  );
}