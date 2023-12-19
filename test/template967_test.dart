import 'package:synthetic_tests_one_file_vs_many/shared.dart';
import 'package:synthetic_tests_one_file_vs_many/generated/template967.dart';
import 'package:test/test.dart';

void main() {

  test('calculate', () {

    final value1 = SharedClass().sharedMethod();
    final value2 = templateMethod();

    expect(value1, value2);

  });

}