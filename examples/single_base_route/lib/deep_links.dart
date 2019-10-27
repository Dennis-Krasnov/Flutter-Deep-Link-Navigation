import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:single_base_route/model.dart';

/// ...
class LibraryDL extends DeepLink {
  LibraryDL() : super("library");
}

/// ...
class FavoritesDL extends DeepLink {
  FavoritesDL() : super("favorites");
}

/// ...
class ArtistDL extends ValueDeepLink {
  ArtistDL(Artist artist) : super("artist", artist, toString: (artist) => artist.id);
}

/// ...
class SongDL extends ValueDeepLink {
  SongDL(Song song) : super("song", song, toString: (song) => song.id);
}

// TODO: add on google analytics listener on callback 'routeChanged'