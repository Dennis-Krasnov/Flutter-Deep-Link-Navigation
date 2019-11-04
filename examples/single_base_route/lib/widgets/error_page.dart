import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Exception e;

  ErrorPage(this.e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ERROR",
          key: Key("title"),
        )
      ),
      body: Center(
        child: Text("$e"),
      ),
    );
  }
}
