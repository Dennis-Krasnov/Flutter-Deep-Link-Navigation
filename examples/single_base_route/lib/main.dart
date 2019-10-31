import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';

import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/model.dart';
import 'package:single_base_route/widgets/artist_page.dart';
import 'package:single_base_route/widgets/favorites_page.dart';
import 'package:single_base_route/widgets/library_page.dart';
import 'package:single_base_route/widgets/song_page.dart';
import 'package:single_base_route/widgets/splash_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(BankingApp());

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeepLinkNavigator(
      navigatorKey: navigatorKey,
      linkDispatchers: {
        LibraryDL: DeepLinkDispatcher((path, push) {
          push(LibraryPage());

          return {
            ArtistDL: DeepLinkDispatcher<Artist>.value((path, value, push) {
              push(ArtistPage(artist: value));

              return {
                SongDL: DeepLinkDispatcher<Song>.value((path, value, push) {
                  push(SongPage(song: value));
                  return null;
                }),
              };
            })
          };
        }),
        FavoritesDL: DeepLinkDispatcher((path, push) {
          push(FavoritesPage());

          return {
            SongDL: DeepLinkDispatcher<Song>.value((path, value, push) {
              push(SongPage(song: value));
              return null;
            }),
          };
        }),
      },
      errorDispatchers: {
        RouteNotFound: ErrorDispatcher<RouteNotFound>((path, error, push) {
          return null;
        }),
        Exception: ErrorDispatcher<Exception>((path, error, push) {
          return null;
        }),
      },
      splashScreen: MaterialApp(
        // TODO: always create custom Navigator(), need to specify observers (take in as optional params, ...spread user defined observers!)
        // TODO: think about how to make bottom navigation easily (extra field won't work, can't wrap material app with scaffold)
        navigatorKey: navigatorKey,
        home: SplashPage(),
      ),
      defaultRoute: [LibraryDL()],
    );
  }
}