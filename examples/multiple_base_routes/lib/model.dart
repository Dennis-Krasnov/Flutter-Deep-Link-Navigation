import 'package:meta/meta.dart';

@immutable
class Artist {
  final String id;

  final String name;

  final List<Song> songs;

  Artist(this.id, this.name, this.songs);
}

@immutable
class Song {
  final String id;

  /// Foreign key for artist
  final String artistId;

  final String name;

  Song(this.id, this.artistId, this.name);
}