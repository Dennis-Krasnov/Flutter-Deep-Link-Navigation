import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';

import 'package:multiple_base_routes/data.dart';
import 'package:multiple_base_routes/deep_links.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Library",
          key: Key("title"),
        ),
      ),
      body: ListView(
        children: <Widget>[
          for (final artist in Data.artists.values)
            ListTile(
              key: Key(artist.name),
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(artist.name),
              subtitle: Text("${artist.songs.length} songs"),
              onTap: () => DeepLinkNavigator.of(context).push(ArtistDL(artist)),
            ),
          Divider(),
          ListTile(
            key: Key("Non-existant push"),
            leading: CircleAvatar(child: Icon(Icons.bug_report)),
            title: Text("Non-existant push"),
            // Route doesn't exist
            onTap: () => DeepLinkNavigator.of(context).push(SongDL(Data.favoriteSongs[0])),
          ),
          ListTile(
            key: Key("Non-existant navigate"),
            leading: CircleAvatar(child: Icon(Icons.bug_report)),
            title: Text("Non-existant navigate"),
            // Route doesn't exist
            onTap: () => DeepLinkNavigator.of(context).navigateTo([LibraryDL(), SongDL(Data.favoriteSongs[1])]),
          )
        ],
      ),
    );
  }
}
