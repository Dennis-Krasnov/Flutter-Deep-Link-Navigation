import 'package:flutter/material.dart';
import 'package:single_base_route/data.dart';
import 'package:single_base_route/widgets/song_list_tile.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My favorites (${Data.favoriteSongs.length})"),
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