import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:multiple_base_routes/data.dart';
import 'package:multiple_base_routes/deep_links.dart';
import 'package:multiple_base_routes/model.dart';
import 'package:multiple_base_routes/widgets/artist_page.dart';
import 'package:multiple_base_routes/widgets/authentication_page.dart';
import 'package:multiple_base_routes/widgets/error_page.dart';
import 'package:multiple_base_routes/widgets/favorites_page.dart';
import 'package:multiple_base_routes/widgets/library_page.dart';
import 'package:multiple_base_routes/widgets/login_page.dart';
import 'package:multiple_base_routes/widgets/song_page.dart';
import 'package:multiple_base_routes/widgets/splash_page.dart';
import 'package:multiple_base_routes/widgets/user_page.dart';

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
    navigation: (context) => Dispatcher()
      // RouteNotFound error page
      ..exception<RouteNotFound>((exception, path) => [ErrorDL<RouteNotFound>(exception)])
      ..value<RouteNotFound, ErrorDL<RouteNotFound>>((exception, path) => ErrorPage(exception))
      // Unauthenticated login page
      ..exception<Unauthenticated>((exception, path) => [LoginDL()])
      ..path<LoginDL>((path) => LoginPage())
      // The rest of the app
      ..path<LibraryDL>(
        (path) => LibraryPage(),
        subNavigation: (context) => Dispatcher()
          ..value<Artist, ArtistDL>(
            (artist, path) => ArtistPage(artist: artist),
            subNavigation: (context, artist) => Dispatcher()..value<Song, SongDL>((song, path) => SongPage(song: song)), // TODO: static extension method
          ),
      )
      ..path<FavoritesDL>(
        (path) => FavoritesPage(),
        subNavigation: (context) => Dispatcher()..value<Song, SongDL>((song, path) => SongPage(song: song)), // TODO: static extension method
      )
      ..path<UserDL>(
        (path) => UserPage(),
        subNavigation: (context) => Dispatcher()..path<AuthenticationDL>((path) => AuthenticationPage()),
      ),
    defaultRoute: [LibraryDL()],
    splashScreen: SplashPage(),
    // Optionally specify always visible widgets
    childBuilder: (BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) => Scaffold(
      body: child,
      // Don't show bottom navigation while [currentRoute] is null, or any deep list is [FullScreen]
      bottomNavigationBar: deepLinkNavigator.currentRoute?.any((dl) => dl is FullScreen) ?? true ? null : BottomNavigationBar(
        currentIndex: currentIndex(deepLinkNavigator.currentRoute),
        onTap: (int index) => deepLinkNavigator.navigateTo([bottomNavigationDeepLinks[index]]),
        items: [
          BottomNavigationBarItem(title: Text("Library"), icon: Icon(Icons.queue_music, key: Key("library"))),
          BottomNavigationBarItem(title: Text("Favorites"), icon: Icon(Icons.favorite, key: Key("favorites"))),
          BottomNavigationBarItem(title: Text("User"), icon: Icon(Icons.person, key: Key("user"))),
        ],
      ),
    ),
    // Non-navigation related fields are still available
    themeMode: ThemeMode.light,
  );
}
