import 'package:deep_link_navigation/deep_link_navigation.dart';

import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/widgets/artist_page.dart';
import 'package:single_base_route/widgets/error_page.dart';
import 'package:single_base_route/widgets/favorites_page.dart';
import 'package:single_base_route/widgets/library_page.dart';
import 'package:single_base_route/widgets/song_page.dart';

/// Representation of deep link navigation hierarchy.
final linkDispatchers = <Type, DeepLinkDispatcher>{
  LibraryDL: DeepLinkDispatcher((path, push) {
    push(LibraryPage());

    return {
      ErrorDL: DeepLinkDispatcher.value((path, exception, push) {
        push(ErrorPage(exception));
        return;
      }),
      ArtistDL: DeepLinkDispatcher.value((path, artist, push) {
        push(ArtistPage(artist: artist));

        return {
          SongDL: DeepLinkDispatcher.value((path, song, push) {
            push(SongPage(song: song));
            return;
          }),
        };
      }),
      FavoritesDL: DeepLinkDispatcher((path, push) {
        push(FavoritesPage());

        return {
          SongDL: DeepLinkDispatcher.value((path, song, push) {
            push(SongPage(song: song));
            return;
          }),
        };
      }),
    };
  }),
};