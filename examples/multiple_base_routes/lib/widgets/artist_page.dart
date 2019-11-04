import 'package:flutter/material.dart';

import 'package:multiple_base_routes/model.dart';
import 'package:multiple_base_routes/widgets/song_list_tile.dart';

class ArtistPage extends StatelessWidget {
  final Artist artist;

  const ArtistPage({Key key, this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          artist.name,
          key: Key("title"),
        ),
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
