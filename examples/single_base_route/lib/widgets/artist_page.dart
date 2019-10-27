import 'package:flutter/material.dart';
import 'package:single_base_route/model.dart';
import 'package:single_base_route/widgets/song_list_tile.dart';

class ArtistPage extends StatelessWidget {
  final Artist artist;

  const ArtistPage({Key key, this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name),
      ),
      body: ListView(
        children: <Widget>[
          for (final song in artist.songs)
            SongListTile(song: song),
        ],
      ),
    );
  }
}
