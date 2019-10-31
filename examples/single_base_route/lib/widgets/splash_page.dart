import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("splash")
      ),
      body: IconButton(
        icon: Icon(Icons.favorite),
      ),
    );
  }
}
