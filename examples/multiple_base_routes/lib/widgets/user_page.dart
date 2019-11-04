import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';

import 'package:multiple_base_routes/model.dart';
import 'package:multiple_base_routes/widgets/song_list_tile.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Provider.of<AuthenticationService>(context).authenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User",
          key: Key("title"),
        ),
      ),
      body: Column(
        children: <Widget>[
          RadioListTile(
            key: Key("authenticated"),
            title: Text("Authenticated"),
            groupValue: isAuthenticated,
            value: true,
            onChanged: (bool value) => Provider.of<AuthenticationService>(context).login(),
          ),
          RadioListTile(
            key: Key("unauthenticated"),
            title: Text("Unuthenticated"),
            groupValue: isAuthenticated,
            value: false,
            onChanged: (bool value) {
              Provider.of<AuthenticationService>(context).logout();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Try navigating to a page that requires authentication")
              ));
            },
          ),
        ],
      ),
    );
  }
}
