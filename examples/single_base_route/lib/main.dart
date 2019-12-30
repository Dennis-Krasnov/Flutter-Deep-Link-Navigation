import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';

import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/model.dart';
import 'package:single_base_route/widgets/artist_page.dart';
import 'package:single_base_route/widgets/error_page.dart';
import 'package:single_base_route/widgets/favorites_page.dart';
import 'package:single_base_route/widgets/library_page.dart';
import 'package:single_base_route/widgets/song_page.dart';
import 'package:single_base_route/widgets/splash_page.dart';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DeepLinkMaterialApp(
    // This is where the magic happens
    navigation: Dispatcher()
      ..path<LibraryDL>(
        (route) => LibraryPage(),
        subNavigation: Dispatcher()
          ..value<Artist, ArtistDL>(
            (artist, route) => ArtistPage(artist: artist),
            subNavigation: (artist) => Dispatcher()
              ..song()
          )
          ..path<FavoritesDL>(
            (route) => FavoritesPage(),
            subNavigation: Dispatcher()
              ..song()
          )
          ..value<RouteNotFound, ErrorDL<RouteNotFound>>((exception, route) => ErrorPage(exception)),
      )
      // Exception handling mappings and route dispatchers are specified independently
      ..exception<RouteNotFound>((exception, route) => [LibraryDL(), ErrorDL<RouteNotFound>(exception)]),
    defaultRoute: [LibraryDL()],
    splashScreen: SplashPage(),
    // Non-navigation related fields are still available
    themeMode: ThemeMode.light,
  );
}

/// Reusing code through static extension methods.
extension DispatcherExtensions on Dispatcher {
  void song() => value<Song, SongDL>((song, route) => SongPage(song: song));
}