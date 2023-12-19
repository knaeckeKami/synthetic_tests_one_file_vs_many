import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'test_wrapper.dart';

void main(List<String> arguments) {

  final  argParser = ArgParser()
      ..addOption("test_count", abbr: "t", defaultsTo: "1", help: "Number of tests to generate");

  final  argResults = argParser.parse(arguments);

  final testCount = int.parse(argResults["test_count"]);

  print("Generating $testCount tests");

  //get working directory
  final workingDirectory = Directory.current.path;

  final libDir = Directory(path.join(workingDirectory, "lib"));

  final testDir = Directory(path.join(workingDirectory, "test"));

  if(!libDir.existsSync()) {
    throw StateError("lib directory does not exist, please run this script from the root of the project");
  }

  if(!testDir.existsSync()) {
    throw StateError("test directory does not exist, please run this script from the root of the project");
  }

  print("Generating tests in ${libDir.path}");

  for(int i = 0; i < testCount; i++) {
    final templateFile = File(path.joinAll([libDir.path, "generated", "template$i.dart"]));

    templateFile.writeAsStringSync(generateTemplate(i));

    final testFile = File(path.join(testDir.path, "template${i}_test.dart"));

    testFile.writeAsStringSync(generateTest(i));

    print("Generated test ${testFile.path}");

  }

  generateTestWrapper();
}


String generateTest(int testNumber) {
  return """
import 'package:synthetic_tests_one_file_vs_many/shared.dart';
import 'package:synthetic_tests_one_file_vs_many/generated/template$testNumber.dart';
import 'package:test/test.dart';

void main() {

  test('calculate', () {

    final value1 = SharedClass().sharedMethod();
    final value2 = templateMethod();

    expect(value1, value2);

  });

}""";
}

String generateTemplate(int testNumber) {
  return """
 
int templateMethod() {
  return _calculate();
}

int _calculate() {
  return 6 * 7;
}
  """;
}

