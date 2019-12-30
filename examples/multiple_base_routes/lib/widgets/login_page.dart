import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          key: Key("title"),
        )
      ),
      body: Center(
        child: RaisedButton(
          key: Key("login"),
          child: Text("Login"),
          onPressed: () {
            Provider.of<AuthenticationService>(context, listen: false).login();
            DeepLinkNavigator.of(context).replaceWithDefault();
          }
        ),
      ),
    );
  }
}
