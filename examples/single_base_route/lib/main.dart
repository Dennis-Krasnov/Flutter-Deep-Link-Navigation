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
    navigation: (context) => Dispatcher()
      ..path<LibraryDL>(
        (path) => LibraryPage(),
        subNavigation: (context) => Dispatcher()
          ..value<Artist, ArtistDL>(
            (artist, path) => ArtistPage(artist: artist),
            subNavigation: (context, artist) => Dispatcher()..value<Song, SongDL>((song, path) => SongPage(song: song)) // TODO: static extension method
          )
          ..path<FavoritesDL>(
            (path) => FavoritesPage(),
            subNavigation: (context) => Dispatcher()..value<Song, SongDL>((song, path) => SongPage(song: song)) // TODO: static extension method
          )
          ..value<RouteNotFound, ErrorDL<RouteNotFound>>((exception, path) => ErrorPage(exception)),
      )
      // Exception handling mappings and route dispatchers are specified independently
      ..exception<RouteNotFound>((exception, path) => [LibraryDL(), ErrorDL<RouteNotFound>(exception)]),
    defaultRoute: [LibraryDL()],
    splashScreen: SplashPage(),
    // Non-navigation related fields are still available
    themeMode: ThemeMode.light,
  );
}