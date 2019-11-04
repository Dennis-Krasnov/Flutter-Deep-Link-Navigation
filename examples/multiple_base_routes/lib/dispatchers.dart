import 'package:deep_link_navigation/deep_link_navigation.dart';

import 'package:multiple_base_routes/deep_links.dart';
import 'package:multiple_base_routes/widgets/artist_page.dart';
import 'package:multiple_base_routes/widgets/error_page.dart';
import 'package:multiple_base_routes/widgets/favorites_page.dart';
import 'package:multiple_base_routes/widgets/library_page.dart';
import 'package:multiple_base_routes/widgets/login_page.dart';
import 'package:multiple_base_routes/widgets/song_page.dart';
import 'package:multiple_base_routes/widgets/user_page.dart';

/// Representation of deep link navigation hierarchy.
final linkDispatchers = <Type, DeepLinkDispatcher>{
  ErrorDL: DeepLinkDispatcher.value((path, exception, push) {
    push(ErrorPage(exception));
    return;
  }),
  LoginDL: DeepLinkDispatcher((path, push) {
    push(LoginPage());
    return;
  }),
  LibraryDL: DeepLinkDispatcher((path, push) {
    push(LibraryPage());

    return {
      ArtistDL: DeepLinkDispatcher.value((path, artist, push) {
        push(ArtistPage(artist: artist));

        return {
          SongDL: DeepLinkDispatcher.value((path, song, push) {
            push(SongPage(song: song));
            return;
          }),
        };
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
  UserDL: DeepLinkDispatcher((path, push) {
    push(UserPage());
    return;
  }),
};