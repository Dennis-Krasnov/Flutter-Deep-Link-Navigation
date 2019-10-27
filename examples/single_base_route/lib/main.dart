import 'package:flutter/material.dart';
import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:provider/provider.dart';
import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/model.dart';
import 'package:single_base_route/widgets/artist_page.dart';
import 'package:single_base_route/widgets/favorites_page.dart';
import 'package:single_base_route/widgets/library_page.dart';
import 'package:single_base_route/widgets/song_page.dart';

void main() => runApp(BankingApp());

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeepLinkRouter( // TODO: rename to DeepLinkNavigator (other to _state)
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
        splashScreen: SplashScreen(),
        defaultRoute: [LibraryDL()],
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("splash")
      ),
      body: IconButton(
        icon: Icon(Icons.favorite),
        onPressed: () {

//          final nav = Provider.of<DeepLinkNavigator>(context, listen: false);
//          print("path: $nav");
//          print("current route: ${nav.currentRoute}");
//          print("prev: ${nav.previousRoute}");
//          print("animate: ${nav.shouldAnimateTransition}");
        },
    ),
    );
  }
}
