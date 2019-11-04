import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

class NavigateToArtist extends WhenWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I navigate to the song's artist");

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.text("Go to artist"));
  }
}