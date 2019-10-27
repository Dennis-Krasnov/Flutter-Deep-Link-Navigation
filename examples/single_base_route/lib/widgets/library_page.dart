import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_base_route/data.dart';
import 'package:single_base_route/widgets/artist_page.dart';
import 'package:single_base_route/widgets/favorites_page.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
//            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FavoritesPage()))
            onPressed: () {
              final nav = Provider.of<DeepLinkNavigator>(context);
              print("NAV IS $nav");
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
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArtistPage(artist: artist))),
            ),
        ],
      ),
    );
  }
}
