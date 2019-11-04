import 'package:flutter/material.dart';

import 'package:multiple_base_routes/data.dart';
import 'package:multiple_base_routes/widgets/song_list_tile.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My favorites (${Data.favoriteSongs.length})",
          key: Key("title"),
        ),
      ),
      body: ListView(
        children: <Widget>[
          for (final song in Data.favoriteSongs)
            SongListTile(song: song),
        ],
      ),
    );
  }
}