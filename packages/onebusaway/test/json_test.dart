import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/json.dart';
import 'package:test/test.dart';

void main() {
  group('readString / readOptString', () {
    test('reads a string', () {
      expect(readString({'a': 'x'}, 'a'), 'x');
    });

    test('throws ObaFormatException naming the field when missing', () {
      expect(
        () => readString({}, 'name'),
        throwsA(isA<ObaFormatException>()
            .having((e) => e.message, 'message', contains('"name"'))),
      );
    });

    test('optional: empty string and null become null', () {
      expect(readOptString({'a': ''}, 'a'), isNull);
      expect(readOptString({'a': null}, 'a'), isNull);
      expect(readOptString({}, 'a'), isNull);
      expect(readOptString({'a': 'SW'}, 'a'), 'SW');
    });

    test('optional: wrong type throws', () {
      expect(() => readOptString({'a': 3}, 'a'),
          throwsA(isA<ObaFormatException>()));
    });
  });

  group('numbers and bools', () {
    test('readInt accepts ints and integral doubles', () {
      expect(readInt({'a': 3}, 'a'), 3);
      expect(readInt({'a': 3.0}, 'a'), 3);
    });

    test('readOptInt / readOptDouble', () {
      expect(readOptInt({}, 'a'), isNull);
      expect(readOptDouble({'a': 745.76}, 'a'), 745.76);
      expect(readOptDouble({'a': 2}, 'a'), 2.0);
    });

    test('readBool uses default when missing, throws on wrong type', () {
      expect(readBool({}, 'a'), isFalse);
      expect(readBool({}, 'a', defaultValue: true), isTrue);
      expect(readBool({'a': true}, 'a'), isTrue);
      expect(() => readBool({'a': 'yes'}, 'a'),
          throwsA(isA<ObaFormatException>()));
    });
  });

  group('readEpochMs', () {
    test('converts epoch ms to UTC DateTime', () {
      final t = readEpochMs({'t': 1790228579290}, 't')!;
      expect(t.isUtc, isTrue);
      expect(t.millisecondsSinceEpoch, 1790228579290);
    });

    test('0 and missing mean "no value"', () {
      expect(readEpochMs({'t': 0}, 't'), isNull);
      expect(readEpochMs({}, 't'), isNull);
    });
  });

  group('collections', () {
    test('readList maps items and treats missing as empty', () {
      expect(readList({'a': [1, 2]}, 'a', (v) => (v as int) * 2), [2, 4]);
      expect(readList({}, 'a', (v) => v), isEmpty);
    });

    test('readStringList', () {
      expect(readStringList({'ids': ['A', 'B']}, 'ids'), ['A', 'B']);
    });

    test('readMap requires an object', () {
      expect(readMap({'m': {'x': 1}}, 'm'), {'x': 1});
      expect(() => readMap({'m': []}, 'm'), throwsA(isA<ObaFormatException>()));
      expect(readOptMap({}, 'm'), isNull);
    });
  });
}
