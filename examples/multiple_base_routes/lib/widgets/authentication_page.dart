import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:multiple_base_routes/data.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Provider.of<AuthenticationService>(context).authenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Authentication",
          key: Key("title"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You're currently ${isAuthenticated ? "" : "un"}authenticated."),
            SizedBox(height: 10),
            RaisedButton(
              key: Key("authenticate"),
              child: Text("Authenticate"),
              onPressed: () => DeepLinkNavigator.of(context).pop(true),
            ),
            SizedBox(height: 10),
            RaisedButton(
              key: Key("unauthenticate"),
              child: Text("Unuthenticate"),
              onPressed: () => DeepLinkNavigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}
