import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/widgets/artist_page.dart';
import 'package:single_base_route/widgets/favorites_page.dart';
import 'package:single_base_route/widgets/library_page.dart';
import 'package:single_base_route/widgets/song_page.dart';

/// ...
final linkDispatchers = <Type, DeepLinkDispatcher>{
  LibraryDL: DeepLinkDispatcher((path, push) {
    push(LibraryPage());

    return {
      ArtistDL: DeepLinkDispatcher.value((path, artist, push) {
        push(ArtistPage(artist: artist));

        return {
          SongDL: DeepLinkDispatcher.value((path, song, push) {
            push(SongPage(song: song));
            return null;
          }),
        };
      }),
      FavoritesDL: DeepLinkDispatcher((path, push) {
        push(FavoritesPage());

        return {
          SongDL: DeepLinkDispatcher.value((path, song, push) {
            push(SongPage(song: song));
            return null;
          }),
        };
      }),
    };
  }),
};

/// ...
final errorDispatchers = <Type, ErrorDispatcher>{
  RouteNotFound: ErrorDispatcher<RouteNotFound>((path, error, push) {
    return null;
  }),
  Exception: ErrorDispatcher<Exception>((path, error, push) {
    return null;
  }),
};