// Keeps every translated ARB file (lib/src/l10n/app_*.arb) in step with the
// template, app_en.arb:
// - the same message keys, in the template's order, and no @metadata
//   (descriptions and placeholder types live in the template only);
// - every message parses as ICU (balanced braces, well-formed plural and
//   select arguments) with the template's placeholder names;
// - the same plural/select arguments as the template, select branches
//   matching the template's, every plural/select with an `other` branch,
//   only CLDR plural categories, and never both `=1` and `one` (gen-l10n
//   treats them as one slot);
// - every locale is listed in ObaLocalizations.supportedLocales.
//
// Each failure names the file, the key and what to fix. gen-l10n here runs
// without ICU apostrophe escaping (`use-escaping` is off), so apostrophes
// are literal text.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

const _arbDir = 'lib/src/l10n';
const _pluralCategories = {'zero', 'one', 'two', 'few', 'many', 'other'};

/// One plural, select or selectordinal argument in a message.
class IcuArgument {
  IcuArgument(this.name, this.kind, this.branches);
  final String name;
  final String kind;
  final List<String> branches;
}

/// A parsed ICU message: its placeholder names and complex arguments.
class IcuMessage {
  final Set<String> placeholders = {};
  final List<IcuArgument> arguments = [];
}

/// Thrown by [parseIcu] for a malformed message.
class IcuSyntaxError implements Exception {
  IcuSyntaxError(this.message);
  final String message;
  @override
  String toString() => message;
}

final _identifier = RegExp(r'\s*([A-Za-z_][A-Za-z0-9_]*)\s*');
final _argumentType = RegExp(r'\s*([a-z]+)\s*,');
final _branchKey = RegExp(r'(=\d+|[A-Za-z_][A-Za-z0-9_]*)\s*\{');
final _space = RegExp(r'\s*');

/// Parses [source] as an ICU message (the subset gen-l10n accepts).
IcuMessage parseIcu(String source) {
  final result = IcuMessage();
  final n = source.length;

  String near(int i) => '"${source.substring(i, i + 20 > n ? n : i + 20)}"';

  late int Function(int i) parseArgument;

  // Literal text up to the closing brace of the current level.
  int parseText(int i, int depth) {
    while (i < n) {
      final c = source[i];
      if (c == '{') {
        i = parseArgument(i + 1);
      } else if (c == '}') {
        if (depth == 0) throw IcuSyntaxError('unbalanced "}" at $i');
        return i;
      } else {
        i++;
      }
    }
    if (depth > 0) throw IcuSyntaxError('unbalanced "{" (missing "}")');
    return i;
  }

  parseArgument = (int i) {
    final name = _identifier.matchAsPrefix(source, i);
    if (name == null) throw IcuSyntaxError('bad placeholder near ${near(i)}');
    final argName = name.group(1)!;
    result.placeholders.add(argName);
    i = name.end;
    if (i < n && source[i] == '}') return i + 1;
    if (i >= n || source[i] != ',') {
      throw IcuSyntaxError('bad argument {$argName near ${near(i)}');
    }
    final type = _argumentType.matchAsPrefix(source, i + 1);
    const kinds = {'plural', 'select', 'selectordinal'};
    if (type == null || !kinds.contains(type.group(1))) {
      throw IcuSyntaxError('bad argument type for {$argName}: ${near(i)}');
    }
    i = type.end;
    final branches = <String>[];
    while (true) {
      i = _space.matchAsPrefix(source, i)!.end;
      if (i < n && source[i] == '}') {
        result.arguments.add(IcuArgument(argName, type.group(1)!, branches));
        return i + 1;
      }
      final key = _branchKey.matchAsPrefix(source, i);
      if (key == null) {
        throw IcuSyntaxError('bad branch in {$argName} near ${near(i)}');
      }
      branches.add(key.group(1)!);
      i = parseText(key.end, 1);
      if (i >= n || source[i] != '}') {
        throw IcuSyntaxError('unterminated branch in {$argName}');
      }
      i++;
    }
  };

  parseText(0, 0);
  return result;
}

/// The problems in one translated ARB file compared with [template].
List<String> checkArb(Map<String, dynamic> template, Map<String, dynamic> arb) {
  final errors = <String>[];
  final templateKeys = [
    for (final k in template.keys)
      if (!k.startsWith('@')) k,
  ];
  final keys = [
    for (final k in arb.keys)
      if (!k.startsWith('@')) k,
  ];
  if (arb['@@locale'] is! String) errors.add('missing "@@locale"');
  final metadata = [
    for (final k in arb.keys)
      if (k.startsWith('@') && k != '@@locale') k,
  ];
  if (metadata.isNotEmpty) {
    errors.add(
      '${metadata.length} @metadata entries (only app_en.arb has them), '
      'e.g. ${metadata.first}',
    );
  }
  final missing = [
    for (final k in templateKeys)
      if (!arb.containsKey(k)) k,
  ];
  final extra = [
    for (final k in keys)
      if (!template.containsKey(k)) k,
  ];
  if (missing.isNotEmpty) {
    errors.add(
      'missing ${missing.length} keys: ${missing.take(20).join(', ')}',
    );
  }
  if (extra.isNotEmpty) {
    errors.add('keys not in app_en.arb: ${extra.take(20).join(', ')}');
  }
  if (missing.isEmpty && extra.isEmpty && !_listEquals(keys, templateKeys)) {
    var i = 0;
    while (keys[i] == templateKeys[i]) {
      i++;
    }
    errors.add(
      'keys are not in app_en.arb order: "${keys[i]}" where the template '
      'has "${templateKeys[i]}"',
    );
  }

  for (final key in templateKeys) {
    final value = arb[key];
    if (value == null) continue;
    if (value is! String || value.trim().isEmpty) {
      errors.add('$key: empty or not a string');
      continue;
    }
    final IcuMessage expected;
    try {
      expected = parseIcu(template[key] as String);
    } on IcuSyntaxError catch (e) {
      errors.add('$key: the TEMPLATE does not parse: $e');
      continue;
    }
    final IcuMessage actual;
    try {
      actual = parseIcu(value);
    } on IcuSyntaxError catch (e) {
      errors.add('$key: not valid ICU: $e\n    "$value"');
      continue;
    }
    if (!_setEquals(actual.placeholders, expected.placeholders)) {
      errors.add(
        '$key: placeholders ${_sorted(actual.placeholders)} but the template '
        'has ${_sorted(expected.placeholders)}\n    "$value"',
      );
    }
    final expectedArgs = {
      for (final a in expected.arguments) '${a.name}:${a.kind}',
    };
    final actualArgs = {
      for (final a in actual.arguments) '${a.name}:${a.kind}',
    };
    if (!_setEquals(actualArgs, expectedArgs)) {
      errors.add(
        '$key: plural/select arguments ${_sorted(actualArgs)} but the '
        'template has ${_sorted(expectedArgs)}',
      );
    }
    for (final a in actual.arguments) {
      final label = '$key: ${a.kind} on {${a.name}}';
      if (!a.branches.contains('other')) {
        errors.add('$label has no "other" branch');
      }
      final duplicates = {
        for (final b in a.branches)
          if (a.branches.where((x) => x == b).length > 1) b,
      };
      if (duplicates.isNotEmpty) {
        errors.add('$label repeats branches ${_sorted(duplicates)}');
      }
      if (a.kind != 'select') {
        final bad = [
          for (final b in a.branches)
            if (!b.startsWith('=') && !_pluralCategories.contains(b)) b,
        ];
        if (bad.isNotEmpty) {
          errors.add(
            '$label uses $bad; plural categories are '
            '${_sorted(_pluralCategories)} or =N',
          );
        }
        if (a.branches.contains('=1') && a.branches.contains('one')) {
          errors.add(
            '$label has both "=1" and "one"; gen-l10n treats them as the '
            'same case, so keep one of them',
          );
        }
      } else {
        final templateBranches = {
          for (final t in expected.arguments)
            if (t.name == a.name && t.kind == 'select') ...t.branches,
        };
        if (templateBranches.isNotEmpty &&
            !_setEquals(a.branches.toSet(), templateBranches)) {
          errors.add(
            '$label has branches ${_sorted(a.branches.toSet())} but the '
            'template has ${_sorted(templateBranches)}',
          );
        }
      }
    }
  }
  return errors;
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _setEquals(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

List<String> _sorted(Iterable<String> s) => s.toList()..sort();

Map<String, dynamic> _readArb(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

void main() {
  final template = _readArb(File('$_arbDir/app_en.arb'));
  final translations =
      Directory(_arbDir)
          .listSync()
          .whereType<File>()
          .where(
            (f) =>
                RegExp(r'app_\w+\.arb$').hasMatch(f.path) &&
                !f.path.endsWith('app_en.arb'),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  test('there are translations to check', () {
    expect(translations, isNotEmpty);
  });

  test('the template parses and its plurals have "other"', () {
    final errors = <String>[];
    for (final e in template.entries) {
      if (e.key.startsWith('@')) continue;
      try {
        for (final a in parseIcu(e.value as String).arguments) {
          if (!a.branches.contains('other')) {
            errors.add('${e.key}: {${a.name}} has no "other" branch');
          }
        }
      } on IcuSyntaxError catch (err) {
        errors.add('${e.key}: $err');
      }
    }
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  for (final file in translations) {
    final name = file.uri.pathSegments.last;
    test('$name matches app_en.arb', () {
      final errors = checkArb(template, _readArb(file));
      expect(
        errors,
        isEmpty,
        reason:
            '${errors.length} problems in $_arbDir/$name:\n  '
            '${errors.join('\n  ')}',
      );
    });

    test('$name is a supported locale', () {
      final tag = _readArb(file)['@@locale'] as String;
      final fileTag = RegExp(r'app_(\w+)\.arb$').firstMatch(name)!.group(1);
      expect(tag, fileTag, reason: '@@locale must match the file name');
      final parts = tag.split('_');
      final supported = obaSupportedLocales.any(
        (l) =>
            l.languageCode == parts[0] &&
            (parts.length == 1 ||
                l.scriptCode == parts[1] ||
                l.countryCode == parts[1]),
      );
      expect(supported, isTrue, reason: 'run `flutter gen-l10n`');
    });
  }

  group('the checker itself', () {
    final tmpl = {
      'a': 'Hello {name}',
      'b': '{count, plural, =1{One stop} other{{count} stops}}',
      'c': '{kind, select, bus{Bus} other{Other}}',
    };

    test('accepts a good translation', () {
      expect(
        checkArb(tmpl, {
          '@@locale': 'xx',
          'a': 'Hola {name}',
          'b': '{count, plural, one{Una parada} other{{count} paradas}}',
          'c': '{kind, select, bus{Autobús} other{Otro}}',
        }),
        isEmpty,
      );
    });

    test('reports each kind of drift', () {
      final errors = checkArb(tmpl, {
        '@@locale': 'xx',
        '@a': {},
        'a': 'Hola {nombre}',
        'b': '{count, plural, =1{x} one{y} few{z}}',
        'c': '{kind, select, bus{Autobús} tram{Tranvía} other{Otro}}',
        'd': 'extra',
      });
      final text = errors.join('\n');
      expect(text, contains('@metadata'));
      expect(text, contains('keys not in app_en.arb: d'));
      expect(text, contains('a: placeholders [nombre]'));
      expect(text, contains('no "other" branch'));
      expect(text, contains('both "=1" and "one"'));
      expect(text, contains('c: select on {kind} has branches'));
    });

    test('reports broken ICU and missing keys', () {
      final errors = checkArb(tmpl, {
        '@@locale': 'xx',
        'a': 'Hola {name',
        'b': '{count, plural, uno{x} other{y}}',
      });
      final text = errors.join('\n');
      expect(text, contains('missing 1 keys: c'));
      expect(text, contains('a: not valid ICU'));
      expect(text, contains('uses [uno]'));
    });
  });
}
