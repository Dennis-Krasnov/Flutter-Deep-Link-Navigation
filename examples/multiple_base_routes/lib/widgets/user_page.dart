import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:multiple_base_routes/data.dart';
import 'package:multiple_base_routes/deep_links.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User",
          key: Key("title"),
        ),
      ),
      body: Center(
        child: RaisedButton(
          key: Key("authentication chooser"),
          child: Text("Choose authentication status"),
          onPressed: () async {
            final isNowAuthenticated = await DeepLinkNavigator.of(context).push<bool>(AuthenticationDL());

            if (isNowAuthenticated != null) {
              if (isNowAuthenticated) {
                Provider.of<AuthenticationService>(context).login();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("You're already authenticated, nothing should change")
                ));
              }
              else {
                Provider.of<AuthenticationService>(context).logout();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Try navigating to a page that requires authentication")
                ));
              }
            }
          },
        ),
      ),
    );
  }
}
