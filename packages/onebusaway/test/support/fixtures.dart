import 'dart:io';

/// Reads `test/fixtures/<name>`. Tests run with the package as the working
/// directory.
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
