import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/row_helper.dart';

void main() {
  group('titleWithGroup', () {
    test(
        'When group is null'
        'then titleWithGroup should be title.', () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.text(),
      );

      expect(column.group, null);
      expect(column.titleWithGroup, 'column');
    });

    test(
        'When group has one element'
        'then titleWithGroup should be group name and column name.', () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.text(),
      );

      column.group = PlutoColumnGroup(title: 'group', fields: ['column']);

      expect(column.titleWithGroup, 'group column');
    });

    test(
        'When group has multiple elements'
        'then titleWithGroup should be group name and column name.', () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.text(),
      );

      final group = PlutoColumnGroup(
        title: 'groupA2-1',
        fields: ['column'],
      );

      PlutoColumnGroup(
        title: 'groupA',
        children: [
          PlutoColumnGroup(
            title: 'groupA1',
            fields: ['DUMMY_COLUMN'],
          ),
          PlutoColumnGroup(
            title: 'groupA2',
            children: [group],
          ),
        ],
      );

      column.group = group;

      expect(column.titleWithGroup, 'groupA groupA2 groupA2-1 column');
    });

    test(
        'When group has multiple elements'
        'and expandedColumn is true'
        'then titleWithGroup should be group name and column name.', () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.text(),
      );

      final group = PlutoColumnGroup(
        title: 'groupA2-1',
        fields: ['column'],
        expandedColumn: true,
      );

      PlutoColumnGroup(
        title: 'groupA',
        children: [
          PlutoColumnGroup(
            title: 'groupA1',
            fields: ['DUMMY_COLUMN'],
          ),
          PlutoColumnGroup(
            title: 'groupA2',
            children: [group],
          ),
        ],
      );

      column.group = group;

      expect(column.titleWithGroup, 'groupA groupA2 column');
    });
  });

  group(
    'PlutoColumnTextAlign',
    () {
      test(
        'isStart',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.start;
          // when
          // then
          expect(textAlign.isStart, isTrue);
        },
      );

      test(
        'isLeft',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.left;
          // when
          // then
          expect(textAlign.isLeft, isTrue);
        },
      );

      test(
        'isCenter',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.center;
          // when
          // then
          expect(textAlign.isCenter, isTrue);
        },
      );

      test(
        'isRight',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.right;
          // when
          // then
          expect(textAlign.isRight, isTrue);
        },
      );

      test(
        'isEnd',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.end;
          // when
          // then
          expect(textAlign.isEnd, isTrue);
        },
      );

      test(
        'value is TextAlign.start',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.start;
          // when
          // then
          expect(textAlign.value, TextAlign.start);
        },
      );

      test(
        'value is TextAlign.left',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.left;
          // when
          // then
          expect(textAlign.value, TextAlign.left);
        },
      );

      test(
        'value is TextAlign.center',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.center;
          // when
          // then
          expect(textAlign.value, TextAlign.center);
        },
      );

      test(
        'value is TextAlign.right',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.right;
          // when
          // then
          expect(textAlign.value, TextAlign.right);
        },
      );

      test(
        'value is TextAlign.end',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.end;
          // when
          // then
          expect(textAlign.value, TextAlign.end);
        },
      );

      test(
        'alignmentValue is AlignmentDirectional.centerStart',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.start;
          // when
          // then
          expect(textAlign.alignmentValue, AlignmentDirectional.centerStart);
        },
      );

      test(
        'alignmentValue is Alignment.centerLeft',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.left;
          // when
          // then
          expect(textAlign.alignmentValue, Alignment.centerLeft);
        },
      );

      test(
        'alignmentValue is Alignment.center',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.center;
          // when
          // then
          expect(textAlign.alignmentValue, Alignment.center);
        },
      );

      test(
        'alignmentValue is Alignment.centerRight',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.right;
          // when
          // then
          expect(textAlign.alignmentValue, Alignment.centerRight);
        },
      );

      test(
        'alignmentValue is AlignmentDirectional.centerEnd',
        () {
          // given
          const PlutoColumnTextAlign textAlign = PlutoColumnTextAlign.end;
          // when
          // then
          expect(textAlign.alignmentValue, AlignmentDirectional.centerEnd);
        },
      );
    },
  );

  group(
    'PlutoColumnSort',
    () {
      test(
        'isNone',
        () {
          // given
          const PlutoColumnSort columnSort = PlutoColumnSort.none;
          // when
          // then
          expect(columnSort.isNone, isTrue);
        },
      );

      test(
        'isAscending',
        () {
          // given
          const PlutoColumnSort columnSort = PlutoColumnSort.ascending;
          // when
          // then
          expect(columnSort.isAscending, isTrue);
        },
      );

      test(
        'isDescending',
        () {
          // given
          const PlutoColumnSort columnSort = PlutoColumnSort.descending;
          // when
          // then
          expect(columnSort.isDescending, isTrue);
        },
      );
    },
  );

  group('PlutoColumnTypeText 의 defaultValue', () {
    test(
      'When defaultValue is set'
      'then defaultValue should be set.',
      () {
        final PlutoColumnTypeText column = PlutoColumnType.text(
          defaultValue: 'default',
        ) as PlutoColumnTypeText;

        expect(column.defaultValue, 'default');
      },
    );

    test(
      'When defaultValue is set'
      'then defaultValue should be set.',
      () {
        final PlutoColumnTypeNumber column = PlutoColumnType.number(
          defaultValue: 123,
        ) as PlutoColumnTypeNumber;

        expect(column.defaultValue, 123);
      },
    );

    test(
      'When defaultValue is set'
      'then defaultValue should be set.',
      () {
        final PlutoColumnTypeSelect column = PlutoColumnType.select(
          <String>['One'],
          defaultValue: 'One',
        ) as PlutoColumnTypeSelect;

        expect(column.defaultValue, 'One');
      },
    );

    test(
      'When defaultValue is set'
      'then defaultValue should be set.',
      () {
        final PlutoColumnTypeDate column = PlutoColumnType.date(
          defaultValue: DateTime.parse('2020-01-01'),
        ) as PlutoColumnTypeDate;

        expect(column.defaultValue, DateTime.parse('2020-01-01'));
      },
    );

    test(
      'When defaultValue is set'
      'then defaultValue should be set.',
      () {
        final PlutoColumnTypeTime column = PlutoColumnType.time(
          defaultValue: '20:30',
        ) as PlutoColumnTypeTime;

        expect(column.defaultValue, '20:30');
      },
    );
  });

  group(
    'PlutoColumnTypeText',
    () {
      test(
        'text',
        () {
          final PlutoColumnTypeText textColumn =
              PlutoColumnType.text() as PlutoColumnTypeText;
          expect(textColumn.text, textColumn);
        },
      );

      test(
        'time',
        () {
          final PlutoColumnTypeText textColumn =
              PlutoColumnType.text() as PlutoColumnTypeText;
          expect(() {
            textColumn.time;
          }, throwsA(isA<TypeError>()));
        },
      );

      group(
        'isValid',
        () {
          test(
            'When value is string'
            'then isValid should be true.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.isValid('text'), isTrue);
            },
          );

          test(
            'When value is number'
            'then isValid should be true.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.isValid(1234), isTrue);
            },
          );

          test(
            'When value is empty'
            'then isValid should be true.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.isValid(''), isTrue);
            },
          );

          test(
            'When value is null'
            'then isValid should be false.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.isValid(null), isFalse);
            },
          );
        },
      );

      group(
        'compare',
        () {
          test(
            'When value1 is less than value2'
            'then compare should return -1.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.compare('가', '나'), -1);
            },
          );

          test(
            'When value1 is greater than value2'
            'then compare should return 1.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.compare('나', '가'), 1);
            },
          );

          test(
            'When value1 is equal to value2'
            'then compare should return 0.',
            () {
              final PlutoColumnTypeText textColumn =
                  PlutoColumnType.text() as PlutoColumnTypeText;
              expect(textColumn.compare('가', '가'), 0);
            },
          );
        },
      );
    },
  );

  group('PlutoColumnTypeNumber', () {
    group('locale', () {
      test('numberFormat should have the default locale set.', () {
        final PlutoColumnTypeNumber numberColumn =
            PlutoColumnType.number() as PlutoColumnTypeNumber;
        expect(numberColumn.numberFormat.locale, 'en_US');
      });

      test('numberFormat should have the denmark locale set.', () {
        final PlutoColumnTypeNumber numberColumn =
            PlutoColumnType.number(locale: 'da_DK') as PlutoColumnTypeNumber;
        expect(numberColumn.numberFormat.locale, 'da');
      });

      test('numberFormat should have the korea locale set.', () {
        final PlutoColumnTypeNumber numberColumn =
            PlutoColumnType.number(locale: 'ko_KR') as PlutoColumnTypeNumber;
        expect(numberColumn.numberFormat.locale, 'ko');
      });
    });

    group('isValid', () {
      test(
        'When value is string'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeNumber numberColumn =
              PlutoColumnType.number() as PlutoColumnTypeNumber;
          expect(numberColumn.isValid('text'), isFalse);
        },
      );

      test(
        'When value is number'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeNumber numberColumn =
              PlutoColumnType.number() as PlutoColumnTypeNumber;
          expect(numberColumn.isValid(123), isTrue);
        },
      );

      test(
        'When value is negative'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeNumber numberColumn =
              PlutoColumnType.number() as PlutoColumnTypeNumber;
          expect(numberColumn.isValid(-123), isTrue);
        },
      );

      test(
        'When negative is false'
        'and value is negative'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeNumber numberColumn = PlutoColumnType.number(
            negative: false,
          ) as PlutoColumnTypeNumber;
          expect(numberColumn.isValid(-123), isFalse);
        },
      );
    });

    group(
      'compare',
      () {
        test(
          'When value1 is less than value2'
          'then compare should return -1.',
          () {
            final PlutoColumnTypeNumber column =
                PlutoColumnType.number() as PlutoColumnTypeNumber;
            expect(column.compare(1, 2), -1);
          },
        );

        test(
          'When value1 is greater than value2'
          'then compare should return 1.',
          () {
            final PlutoColumnTypeNumber column =
                PlutoColumnType.number() as PlutoColumnTypeNumber;
            expect(column.compare(2, 1), 1);
          },
        );

        test(
          'When value1 is equal to value2'
          'then compare should return 0.',
          () {
            final PlutoColumnTypeNumber column =
                PlutoColumnType.number() as PlutoColumnTypeNumber;
            expect(column.compare(1, 1), 0);
          },
        );
      },
    );
  });

  group('PlutoColumnTypeSelect', () {
    group('isValid', () {
      test(
        'When item is in items'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeSelect selectColumn =
              PlutoColumnType.select(<String>[
            'A',
            'B',
            'C',
          ]) as PlutoColumnTypeSelect;
          expect(selectColumn.isValid('A'), isTrue);
        },
      );

      test(
        'When item is not in items'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeSelect selectColumn =
              PlutoColumnType.select(<String>[
            'A',
            'B',
            'C',
          ]) as PlutoColumnTypeSelect;
          expect(selectColumn.isValid('D'), isFalse);
        },
      );
    });

    group(
      'compare',
      () {
        test(
          'When value1 is less than value2'
          'then compare should return -1.',
          () {
            final PlutoColumnTypeSelect column =
                PlutoColumnType.select(<String>[
              'One',
              'Two',
              'Three',
            ]) as PlutoColumnTypeSelect;
            expect(column.compare('Two', 'Three'), -1);
          },
        );

        test(
          'When value1 is greater than value2'
          'then compare should return 1.',
          () {
            final PlutoColumnTypeSelect column =
                PlutoColumnType.select(<String>[
              'One',
              'Two',
              'Three',
            ]) as PlutoColumnTypeSelect;
            expect(column.compare('Three', 'Two'), 1);
          },
        );

        test(
          'When value1 is equal to value2'
          'then compare should return 0.',
          () {
            final PlutoColumnTypeSelect column =
                PlutoColumnType.select(<String>[
              'One',
              'Two',
              'Three',
            ]) as PlutoColumnTypeSelect;
            expect(column.compare('Two', 'Two'), 0);
          },
        );
      },
    );
  });

  group('PlutoColumnTypeDate', () {
    group('isValid', () {
      test(
        'When value is not date'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeDate dateColumn =
              PlutoColumnType.date() as PlutoColumnTypeDate;
          expect(dateColumn.isValid('Not a date'), isFalse);
        },
      );

      test(
        'When value is date'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeDate dateColumn =
              PlutoColumnType.date() as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-01-01'), isTrue);
        },
      );

      test(
        'When value is date'
        'and startDate is not null'
        'and value is less than startDate'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            startDate: DateTime.parse('2020-02-01'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-01-01'), isFalse);
        },
      );

      test(
        'When value is date'
        'and startDate is not null'
        'and value is equal to startDate'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            startDate: DateTime.parse('2020-02-01'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-02-01'), isTrue);
        },
      );

      test(
        'When value is date'
        'and startDate is not null'
        'and value is greater than startDate'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            startDate: DateTime.parse('2020-02-01'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-02-03'), isTrue);
        },
      );

      test(
        'When value is date'
        'and endDate is not null'
        'and value is less than endDate'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            endDate: DateTime.parse('2020-02-01'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-01-01'), isTrue);
        },
      );

      test(
        'When value is date'
        'and endDate is not null'
        'and value is equal to endDate'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            endDate: DateTime.parse('2020-02-01'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-02-01'), isTrue);
        },
      );

      test(
        'When value is date'
        'and endDate is not null'
        'and value is greater than endDate'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            endDate: DateTime.parse('2020-02-01'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-02-03'), isFalse);
        },
      );

      test(
        'When value is date'
        'and startDate is not null'
        'and endDate is not null'
        'and value is in range'
        'then isValid should be true.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            startDate: DateTime.parse('2020-02-01'),
            endDate: DateTime.parse('2020-02-05'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-02-03'), isTrue);
        },
      );

      test(
        'When value is date'
        'and startDate is not null'
        'and endDate is not null'
        'and value is less than startDate'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            startDate: DateTime.parse('2020-02-01'),
            endDate: DateTime.parse('2020-02-05'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-01-03'), isFalse);
        },
      );

      test(
        'When value is date'
        'and startDate is not null'
        'and endDate is not null'
        'and value is greater than endDate'
        'then isValid should be false.',
        () {
          final PlutoColumnTypeDate dateColumn = PlutoColumnType.date(
            startDate: DateTime.parse('2020-02-01'),
            endDate: DateTime.parse('2020-02-05'),
          ) as PlutoColumnTypeDate;
          expect(dateColumn.isValid('2020-02-06'), isFalse);
        },
      );
    });

    group(
      'compare',
      () {
        test(
          'When value1 is less than value2'
          'then compare should return -1.',
          () {
            final PlutoColumnTypeDate column =
                PlutoColumnType.date() as PlutoColumnTypeDate;
            expect(column.compare('2019-12-30', '2020-01-01'), -1);
          },
        );

        // When the date format is applied, the behavior of the column's compare function is different from the intended behavior.
        // You need to change the format when calling the compare function. The compare function converts the format appropriately
        // and the format change is processed when the function is called from outside.
        test(
          '12/30/2019, 01/01/2020 인 경우 1',
          () {
            final PlutoColumnTypeDate column =
                PlutoColumnType.date(format: 'MM/dd/yyyy')
                    as PlutoColumnTypeDate;
            expect(column.compare('12/30/2019', '01/01/2020'), 1);
          },
        );

        test(
          'When value1 is greater than value2'
          'then compare should return 1.',
          () {
            final PlutoColumnTypeDate column =
                PlutoColumnType.date() as PlutoColumnTypeDate;
            expect(column.compare('2020-01-01', '2019-12-30'), 1);
          },
        );

        // When the date format is applied, the behavior of the column's compare function is different from the intended behavior.
        // You need to change the format when calling the compare function. The compare function converts the format appropriately
        // and the format change is processed when the function is called from outside.
        test(
          '01/01/2020, 12/30/2019  인 경우 -1',
          () {
            final PlutoColumnTypeDate column =
                PlutoColumnType.date(format: 'MM/dd/yyyy')
                    as PlutoColumnTypeDate;
            expect(column.compare('01/01/2020', '12/30/2019'), -1);
          },
        );

        test(
          'When value1 is equal to value2'
          'then compare should return 0.',
          () {
            final PlutoColumnTypeDate column =
                PlutoColumnType.date() as PlutoColumnTypeDate;
            expect(column.compare('2020-01-01', '2020-01-01'), 0);
          },
        );

        test(
          'When value1 is equal to value2'
          'then compare should return 0.',
          () {
            final PlutoColumnTypeDate column =
                PlutoColumnType.date(format: 'MM/dd/yyyy')
                    as PlutoColumnTypeDate;
            expect(column.compare('01/01/2020', '01/01/2020'), 0);
          },
        );
      },
    );
  });

  group(
    'PlutoColumnTypeTime',
    () {
      group('isValid', () {
        test(
          'When value is not time'
          'then isValid should be false.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('24:00'), isFalse);
          },
        );

        test(
          'When value is not time'
          'then isValid should be false.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('00:60'), isFalse);
          },
        );

        test(
          'When value is not time'
          'then isValid should be false.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('24:60'), isFalse);
          },
        );

        test(
          'When value is time'
          'then isValid should be true.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('00:00'), isTrue);
          },
        );

        test(
          'When value is time'
          'then isValid should be true.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('00:59'), isTrue);
          },
        );

        test(
          'When value is time'
          'then isValid should be true.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('23:00'), isTrue);
          },
        );

        test(
          'When value is time'
          'then isValid should be true.',
          () {
            final PlutoColumnTypeTime timeColumn =
                PlutoColumnType.time() as PlutoColumnTypeTime;
            expect(timeColumn.isValid('23:59'), isTrue);
          },
        );
      });
    },
  );

  group('formattedValueForType', () {
    test(
      'When column type is number'
      'then formatted value should be formatted by default format.',
      () {
        final PlutoColumn column = PlutoColumn(
          title: 'number column',
          field: 'number_column',
          type: PlutoColumnType.number(), // 기본 포멧 (#,###)
        );

        expect(column.formattedValueForType(12345), '12,345');
      },
    );

    test(
      'When column type is number'
      'then formatted value should be formatted by default format.',
      () {
        final PlutoColumn column = PlutoColumn(
          title: 'number column',
          field: 'number_column',
          type: PlutoColumnType.number(), // 기본 포멧 (#,###)
        );

        expect(column.formattedValueForType(12345678), '12,345,678');
      },
    );

    test(
      'When column type is not number'
      'then formatted value should not be formatted by default format.',
      () {
        final PlutoColumn column = PlutoColumn(
          title: 'number column',
          field: 'number_column',
          type: PlutoColumnType.text(), // 기본 포멧 (#,###)
        );

        expect(column.formattedValueForType('12345'), '12345');
      },
    );
  });

  group('formattedValueForDisplay', () {
    test(
      'When formatter is null'
      'then formatted value should be formatted by default format.',
      () {
        final PlutoColumn column = PlutoColumn(
          title: 'number column',
          field: 'number_column',
          type: PlutoColumnType.number(), // 기본 포멧 (#,###)
        );

        expect(column.formattedValueForDisplay(12345), '12,345');
      },
    );

    test(
      'When formatter is not null'
      'then formatted value should be formatted by formatter.',
      () {
        final PlutoColumn column = PlutoColumn(
          title: 'number column',
          field: 'number_column',
          type: PlutoColumnType.number(), // 기본 포멧 (#,###)
          formatter: (dynamic value) => '\$ $value',
        );

        expect(column.formattedValueForDisplay(12345), '\$ 12345');
      },
    );
  });

  group('checkReadOnly', () {
    makeColumn({
      required bool readOnly,
      PlutoColumnCheckReadOnly? checkReadOnly,
    }) {
      return PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        readOnly: readOnly,
        checkReadOnly: checkReadOnly,
      );
    }

    makeRow(PlutoColumn column) {
      return RowHelper.count(1, [column]).first;
    }

    test(
      'When readOnly is false'
      'and checkReadOnly is null'
      'then checkReadOnly should return false.',
      () {
        final column = makeColumn(readOnly: false);

        expect(column.readOnly, false);
      },
    );

    test(
      'When readOnly is true'
      'and checkReadOnly is null'
      'then checkReadOnly should return true.',
      () {
        final column = makeColumn(readOnly: true);

        expect(column.readOnly, true);
      },
    );

    test(
        'When readOnly is false'
        'and checkReadOnly is not null'
        'then checkReadOnly should return true.', () {
      final column =
          makeColumn(readOnly: false, checkReadOnly: (_, __) => true);

      final row = makeRow(column);

      final cell = row.cells['field'];

      expect(column.checkReadOnly(row, cell!), true);
    });

    test(
        'When readOnly is true'
        'and checkReadOnly is not null'
        'then checkReadOnly should return false.', () {
      final column =
          makeColumn(readOnly: true, checkReadOnly: (_, __) => false);

      final row = makeRow(column);

      final cell = row.cells['field'];

      expect(column.checkReadOnly(row, cell!), false);
    });
  });

  group('formattedValueForDisplayInEditing', () {
    group('When column type is not PlutoColumnTypeWithNumberFormat', () {
      test(
          'When formatter is not null'
          'and readOnly is true'
          'then formatted value should be formatted by formatter.', () {
        final column = PlutoColumn(
          title: 'column',
          field: 'column',
          applyFormatterInEditing: true,
          readOnly: true,
          type: PlutoColumnType.text(),
          formatter: (s) => '$s changed',
        );

        expect(
          column.formattedValueForDisplayInEditing('original'),
          'original changed',
        );
      });

      test(
        'When readOnly is false'
        'and formatter is not null'
        'and type is select'
        'then formatted value should be formatted by formatter.',
        () {
          final column = PlutoColumn(
            title: 'column',
            field: 'column',
            applyFormatterInEditing: true,
            readOnly: false,
            type: PlutoColumnType.select(['one', 'two', 'three']),
            formatter: (s) => '$s changed',
          );

          expect(
            column.formattedValueForDisplayInEditing('original'),
            'original changed',
          );
        },
      );

      test(
        'When readOnly is false'
        'and formatter is not null'
        'and type is time'
        'then formatted value should be formatted by formatter.',
        () {
          final column = PlutoColumn(
            title: 'column',
            field: 'column',
            applyFormatterInEditing: true,
            readOnly: false,
            type: PlutoColumnType.time(),
            formatter: (s) => '$s changed',
          );

          expect(
            column.formattedValueForDisplayInEditing('original'),
            'original changed',
          );
        },
      );

      test(
        'When readOnly is false'
        'and formatter is not null'
        'and type is date'
        'then formatted value should be formatted by formatter.',
        () {
          final column = PlutoColumn(
            title: 'column',
            field: 'column',
            applyFormatterInEditing: true,
            readOnly: false,
            type: PlutoColumnType.date(),
            formatter: (s) => '$s changed',
          );

          expect(
            column.formattedValueForDisplayInEditing('original'),
            'original changed',
          );
        },
      );

      test(
        'When readOnly is false'
        'and formatter is not null'
        'and type is date'
        'then formatted value should be formatted by formatter.',
        () {
          final column = PlutoColumn(
            title: 'column',
            field: 'column',
            applyFormatterInEditing: true,
            readOnly: false,
            type: PlutoColumnType.date(),
            formatter: (s) => '$s changed',
          );

          expect(
            column.formattedValueForDisplayInEditing('original'),
            'original changed',
          );
        },
      );

      test(
        'When readOnly is false'
        'and formatter is not null'
        'and applyFormatterInEditing is false'
        'then formatted value should not be formatted by formatter.',
        () {
          final column = PlutoColumn(
            title: 'column',
            field: 'column',
            applyFormatterInEditing: false,
            readOnly: true,
            type: PlutoColumnType.text(),
            formatter: (s) => '$s changed',
          );

          expect(
            column.formattedValueForDisplayInEditing('original'),
            'original',
          );
        },
      );
    });
  });
}
