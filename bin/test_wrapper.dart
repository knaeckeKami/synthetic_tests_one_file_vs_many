import 'dart:io';

import 'package:collection/collection.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;

final _sep = path.separator;

// ignore_for_file: depend_on_referenced_packages
class _TestFileInfo {
  final File testFile;
  final String alias;
  final String import;

  _TestFileInfo._(this.testFile, this.alias, this.import);

  factory _TestFileInfo.forFile(File testFile) {
    final parts = testFile.absolute.path.split(_sep).toList();
    var relative = <String>[];
    while (parts.last != 'test') {
      relative.add(parts.last);
      parts.removeLast();
    }
    relative = relative.reversed.toList();
    final alias = relative.join('_').replaceFirst('.dart', '');
    final importPath = relative.join('/');
    final import = "import '$importPath' as $alias;";
    return _TestFileInfo._(testFile, alias, import);
  }
}

void generateTestWrapper() {
  final packageRoot = Directory.current;
  generateMainScript(packageRoot, findTestFiles(packageRoot));
}

List<File> findTestFiles(Directory packageRoot, {Glob? excludeGlob}) {
  final testsPath = path.join(packageRoot.absolute.path, 'test');
  final testsRoot = Directory(testsPath);
  final contents = testsRoot.listSync(recursive: true);
  final result = <File>[];
  for (final item in contents) {
    if (item is! File) continue;
    if (!item.path.endsWith('_test.dart')) continue;
    final relativePath = item.path.substring(packageRoot.path.length + 1);
    if (excludeGlob != null && excludeGlob.matches(relativePath)) {
      continue;
    }
    result.add(item);
  }
  result.sortBy((element) => element.absolute.path);
  return result;
}

void generateMainScript(Directory packageRoot, List<File> testFiles) {
  final imports = <String>[];
  final mainBody = <String>[];

  for (final test in testFiles) {
    final info = _TestFileInfo.forFile(test);
    imports.add(info.import);
    mainBody.add('  ${info.alias}.main();');
  }
  imports.sort();

  final buffer = StringBuffer()
    ..writeln('// Auto-generated by test_wrapper. Do not edit by hand.')
    ..writeln('// Consider adding this file to your .gitignore.')
    ..writeln();
  imports.forEach(buffer.writeln);
  buffer
    ..writeln()
    ..writeln('void main() {');
  mainBody.forEach(buffer.writeln);
  buffer.writeln('}');
  File(
    path.join(packageRoot.path, 'test', 'test_wrapper.g.dart'),
  ).writeAsStringSync(buffer.toString());
}



