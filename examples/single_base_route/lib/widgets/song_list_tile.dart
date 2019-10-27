import 'package:flutter/material.dart';
import 'package:single_base_route/model.dart';
import 'package:single_base_route/widgets/song_page.dart';

class SongListTile extends StatelessWidget {
  final Song song;

  const SongListTile({Key key, this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.music_note),
      title: Text(song.name),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SongPage(song: song))),
    );
  }
}