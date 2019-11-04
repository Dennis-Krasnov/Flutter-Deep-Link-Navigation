import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

class TitleIs extends Then1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the title is {string}");

  @override
  Future<void> executeStep(String title) async {
    try {
      final text = await FlutterDriverUtils.getText(world.driver, find.byValueKey("title"));// .catchError(onError); default reporter message thing!
      expect(text, title);
    } catch (e) {
      await reporter.message("Step error '${pattern.pattern}': $e", MessageLevel.error);
      rethrow;
    }
  }
}