import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

void main() {
  group('text', () {
    const textTypeColumn = PlutoColumnTypeText();

    test('When accessing the text property, a TypeError should not be thrown.',
        () {
      expect(() => textTypeColumn.text, isNot(throwsA(isA<TypeError>())));
    });

    test('When accessing the number property, a TypeError should be thrown.',
        () {
      expect(() => textTypeColumn.number, throwsA(isA<TypeError>()));
    });

    test('When accessing the currency property, a TypeError should be thrown.',
        () {
      expect(() => textTypeColumn.currency, throwsA(isA<TypeError>()));
    });

    test('When accessing the select property, a TypeError should be thrown.',
        () {
      expect(() => textTypeColumn.select, throwsA(isA<TypeError>()));
    });

    test('When accessing the date property, a TypeError should be thrown.', () {
      expect(() => textTypeColumn.date, throwsA(isA<TypeError>()));
    });

    test('When accessing the time property, a TypeError should be thrown.', () {
      expect(() => textTypeColumn.time, throwsA(isA<TypeError>()));
    });
  });

  group('time', () {
    group('compare', () {
      const timeColumn = PlutoColumnTypeTime();

      test('When the values are the same, 0 should be returned.', () {
        expect(timeColumn.compare('00:00', '00:00'), 0);
      });

      test('When a is greater than b, 1 should be returned.', () {
        expect(timeColumn.compare('12:00', '00:00'), 1);
      });

      test('When b is greater than a, -1 should be returned.', () {
        expect(timeColumn.compare('12:00', '24:00'), -1);
      });

      test('When a is null and b is not null, -1 should be returned.', () {
        expect(timeColumn.compare(null, '00:00'), -1);
      });

      test('When b is null and a is not null, 1 should be returned.', () {
        expect(timeColumn.compare('00:00', null), 1);
      });
    });
  });
}
