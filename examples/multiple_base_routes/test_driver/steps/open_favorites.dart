import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

class OpenFavorites extends WhenWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I open my favorite songs");

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byType("IconButton"));
  }
}