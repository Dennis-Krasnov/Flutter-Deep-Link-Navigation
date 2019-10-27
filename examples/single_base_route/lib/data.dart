import 'package:single_base_route/model.dart';

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