import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:single_base_route/data.dart';
import 'package:single_base_route/deep_links.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              DeepLinkNavigator.of(context).push(FavoritesDL());
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (final artist in Data.artists.values)
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(artist.name),
              subtitle: Text("${artist.songs.length} songs"),
              onTap: () => DeepLinkNavigator.of(context).push(ArtistDL(artist)),
            ),
        ],
      ),
    );
  }
}
