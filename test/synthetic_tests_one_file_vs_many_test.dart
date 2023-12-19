import 'package:synthetic_tests_one_file_vs_many/synthetic_tests_one_file_vs_many.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });
}
