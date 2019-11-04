import 'package:flutter/material.dart';

import 'package:multiple_base_routes/model.dart';

/// Dummy state management.
class AuthenticationService with ChangeNotifier {
  bool _authenticated = false;
  bool get authenticated => _authenticated;

  void login() {
    _authenticated = true;
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }
}

/// Random placeholder data meant to be replaced with a database.
class Data {
  static final artists = <String, Artist>{
    "1234": Artist(
      "1234",
      "John Lennon",
      [
        Song(
          "4312",
          "1234",
          "Yesterday",
        ),
        Song(
          "4313",
          "1234",
          "Yellow Submarine",
        ),
      ],
    ),
    "1235": Artist(
      "1235",
      "Ludwig van beethoven",
      [
        Song(
          "6363",
          "1235",
          "Symphony No. 5",
        ),
        Song(
          "6364",
          "1235",
          "Symphony No. 9",
        ),
      ],
    ),
  };

  static final favoriteSongs = [
    artists["1234"].songs[0],
    artists["1235"].songs[0],
    artists["1235"].songs[1],
  ];
}