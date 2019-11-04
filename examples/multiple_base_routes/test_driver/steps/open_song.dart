import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class OpenSong extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I open the song {string}");

  @override
  Future<void> executeStep(String key) async => FlutterDriverUtils.tap(world.driver, find.byValueKey(key));
}