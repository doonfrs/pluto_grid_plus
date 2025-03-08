import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

void main() {
  group('sum', () {
    test('When the column is not a number, 0 should be returned.', () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.text(),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: '10.001')}),
        PlutoRow(cells: {'column': PlutoCell(value: '10.001')}),
        PlutoRow(cells: {'column': PlutoCell(value: '10.001')}),
        PlutoRow(cells: {'column': PlutoCell(value: '10.001')}),
        PlutoRow(cells: {'column': PlutoCell(value: '10.001')}),
      ];

      expect(PlutoAggregateHelper.sum(rows: rows, column: column), 0);
    });

    test(
        'When sum is called without a condition, the total sum should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10)}),
        PlutoRow(cells: {'column': PlutoCell(value: 20)}),
        PlutoRow(cells: {'column': PlutoCell(value: 30)}),
        PlutoRow(cells: {'column': PlutoCell(value: 40)}),
        PlutoRow(cells: {'column': PlutoCell(value: 50)}),
      ];

      expect(PlutoAggregateHelper.sum(rows: rows, column: column), 150);
    });

    test(
        'When sum is called without a condition, the total sum should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: -10)}),
        PlutoRow(cells: {'column': PlutoCell(value: -20)}),
        PlutoRow(cells: {'column': PlutoCell(value: -30)}),
        PlutoRow(cells: {'column': PlutoCell(value: -40)}),
        PlutoRow(cells: {'column': PlutoCell(value: -50)}),
      ];

      expect(PlutoAggregateHelper.sum(rows: rows, column: column), -150);
    });

    test(
        'When sum is called without a condition, the total sum should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
      ];

      expect(PlutoAggregateHelper.sum(rows: rows, column: column), 50.005);
    });

    test(
        'When a condition is present, the sum of the items that match the condition should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
      ];

      expect(
        PlutoAggregateHelper.sum(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value == 10.001,
        ),
        30.003,
      );
    });

    test(
        'When a condition is present, if there are no matching items, 0 should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
      ];

      expect(
        PlutoAggregateHelper.sum(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value == 10.003,
        ),
        null,
      );
    });
  });

  group('average', () {
    test(
        'When average is called without a condition, the total average should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10)}),
        PlutoRow(cells: {'column': PlutoCell(value: 20)}),
        PlutoRow(cells: {'column': PlutoCell(value: 30)}),
        PlutoRow(cells: {'column': PlutoCell(value: 40)}),
        PlutoRow(cells: {'column': PlutoCell(value: 50)}),
      ];

      expect(PlutoAggregateHelper.average(rows: rows, column: column), 30);
    });

    test(
        'When average is called without a condition, the total average should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: -10)}),
        PlutoRow(cells: {'column': PlutoCell(value: -20)}),
        PlutoRow(cells: {'column': PlutoCell(value: -30)}),
        PlutoRow(cells: {'column': PlutoCell(value: -40)}),
        PlutoRow(cells: {'column': PlutoCell(value: -50)}),
      ];

      expect(PlutoAggregateHelper.average(rows: rows, column: column), -30);
    });

    test(
        'When average is called without a condition, the total average should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(PlutoAggregateHelper.average(rows: rows, column: column), 10.003);
    });
  });

  group('min', () {
    test(
        'When min is called without a condition, the minimum value should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 101)}),
        PlutoRow(cells: {'column': PlutoCell(value: 102)}),
        PlutoRow(cells: {'column': PlutoCell(value: 103)}),
        PlutoRow(cells: {'column': PlutoCell(value: 104)}),
        PlutoRow(cells: {'column': PlutoCell(value: 105)}),
      ];

      expect(PlutoAggregateHelper.min(rows: rows, column: column), 101);
    });

    test(
        'When min is called without a condition, the minimum value should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: -101)}),
        PlutoRow(cells: {'column': PlutoCell(value: -102)}),
        PlutoRow(cells: {'column': PlutoCell(value: -103)}),
        PlutoRow(cells: {'column': PlutoCell(value: -104)}),
        PlutoRow(cells: {'column': PlutoCell(value: -105)}),
      ];

      expect(PlutoAggregateHelper.min(rows: rows, column: column), -105);
    });

    test(
        'When min is called without a condition, the minimum value should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(PlutoAggregateHelper.min(rows: rows, column: column), 10.001);
    });

    test(
        'When a condition is present, the minimum value of the items that match the condition should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(
        PlutoAggregateHelper.min(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value >= 10.003,
        ),
        10.003,
      );
    });

    test(
        'When a condition is present, if there are no matching items, null should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
      ];

      expect(
        PlutoAggregateHelper.min(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value == 10.003,
        ),
        null,
      );
    });
  });

  group('max', () {
    test(
        'When a condition is present, the maximum value of the items that match the condition should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(
        PlutoAggregateHelper.max(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value >= 10.003,
        ),
        10.005,
      );
    });

    test(
        'When a condition is present, if there are no matching items, null should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(
        PlutoAggregateHelper.max(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value >= 10.006,
        ),
        null,
      );
    });
  });

  group('count', () {
    test(
        'When count is called without a condition, the total count should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(PlutoAggregateHelper.count(rows: rows, column: column), 5);
    });

    test(
        'When a condition is present, the count of the items that match the condition should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(
        PlutoAggregateHelper.count(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value >= 10.003,
        ),
        3,
      );
    });

    test(
        'When a condition is present, if there are no matching items, 0 should be returned.',
        () {
      final column = PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(format: '#,###.###'),
      );

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 10.001)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.002)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.003)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.004)}),
        PlutoRow(cells: {'column': PlutoCell(value: 10.005)}),
      ];

      expect(
        PlutoAggregateHelper.count(
          rows: rows,
          column: column,
          filter: (PlutoCell cell) => cell.value >= 10.006,
        ),
        0,
      );
    });
  });
}
