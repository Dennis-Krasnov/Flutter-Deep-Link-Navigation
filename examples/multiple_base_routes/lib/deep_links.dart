import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/cupertino.dart';

import 'package:multiple_base_routes/model.dart';
import 'package:provider/provider.dart';

import 'data.dart';

/// Custom mixins

mixin FullScreen on DeepLink {}

mixin Authenticated on DeepLink {
  @override
  void onDispatch(BuildContext context) {
    // Get state from context or global/static variable
    final isAuthenticated = Provider.of<AuthenticationService>(context, listen: false).authenticated;

    // Throw custom exception
    if (!isAuthenticated) {
      throw Unauthenticated();
    }
  }
}

/// Custom exceptions

class Unauthenticated implements Exception {
  @override
  String toString() => "Unauthenticated :(";
}

/// Deep links

class LoginDL extends DeepLink with FullScreen {
  LoginDL() : super("login");
}

class LibraryDL extends DeepLink with Authenticated {
  LibraryDL() : super("library");
}

class FavoritesDL extends DeepLink with Authenticated {
  FavoritesDL() : super("favorites");
}

class UserDL extends DeepLink with Authenticated {
  UserDL() : super("user");
}

class ArtistDL extends ValueDeepLink<Artist> {
  ArtistDL(Artist artist) : super("artist", artist, toString: (artist) => artist.id);
}

class SongDL extends ValueDeepLink<Song> {
  SongDL(Song song) : super("song", song, toString: (song) => song.id);
}

class ErrorDL<E extends Exception> extends ValueDeepLink<E> with FullScreen {
  ErrorDL(E e) : super("error", e);
}