import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GoBack extends When1WithWorld<int, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I go back {int} time(s)");

  @override
  Future<void> executeStep(int times) async {
    for (var i = 0; i < times; i++) {
      await world.driver.tap(find.pageBack(), timeout: timeout);
      await FlutterDriverUtils.waitForFlutter(world.driver, timeout: timeout);
    }
  }
}