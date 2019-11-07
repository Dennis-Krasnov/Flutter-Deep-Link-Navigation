import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

class TextDisappears extends Then1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the text {string} disappears");

  @override
  Future<void> executeStep(String input1) async {
    expect(await FlutterDriverUtils.isAbsent(world.driver, find.text(input1)), true);
  }
}