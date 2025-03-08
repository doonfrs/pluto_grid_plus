import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';

class _MockScrollController extends Mock implements ScrollController {}

void main() {
  group('selectingModes', () {
    test('Square, Row, None should be returned.', () {
      const selectingModes = PlutoGridSelectingMode.values;

      expect(selectingModes.contains(PlutoGridSelectingMode.cell), isTrue);
      expect(selectingModes.contains(PlutoGridSelectingMode.row), isTrue);
      expect(selectingModes.contains(PlutoGridSelectingMode.none), isTrue);
    });
  });

  group('PlutoScrollController', () {
    test('bodyRowsVertical', () {
      final PlutoGridScrollController scrollController =
          PlutoGridScrollController();

      ScrollController scroll = _MockScrollController();
      ScrollController anotherScroll = _MockScrollController();

      scrollController.setBodyRowsVertical(scroll);

      expect(scrollController.bodyRowsVertical == scroll, isTrue);
      expect(scrollController.bodyRowsVertical == anotherScroll, isFalse);
      expect(scroll == anotherScroll, isFalse);
    });
  });

  group('PlutoCellPosition', () {
    testWidgets('null comparison should return false.',
        (WidgetTester tester) async {
      // given
      const cellPositionA = PlutoGridCellPosition(
        columnIdx: 1,
        rowIdx: 1,
      );

      PlutoGridCellPosition? cellPositionB;

      // when
      final bool compare = cellPositionA == cellPositionB;
      // then

      expect(compare, false);
    });

    testWidgets('values are different, comparison should return false.',
        (WidgetTester tester) async {
      // given
      const cellPositionA = PlutoGridCellPosition(
        columnIdx: 1,
        rowIdx: 1,
      );

      const cellPositionB = PlutoGridCellPosition(
        columnIdx: 2,
        rowIdx: 1,
      );

      // when
      final bool compare = cellPositionA == cellPositionB;
      // then

      expect(compare, false);
    });

    testWidgets('values are same, comparison should return true.',
        (WidgetTester tester) async {
      // given
      const cellPositionA = PlutoGridCellPosition(
        columnIdx: 1,
        rowIdx: 1,
      );

      const cellPositionB = PlutoGridCellPosition(
        columnIdx: 1,
        rowIdx: 1,
      );

      // when
      final bool compare = cellPositionA == cellPositionB;
      // then

      expect(compare, true);
    });
  });

  group('initializeRows', () {
    test('The sortIdx of the row passed should be set.', () {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
        forceApplySortIdx: true,
      );

      expect(rows.first.sortIdx, 0);
      expect(rows.last.sortIdx, 4);
    });

    test(
        'forceApplySortIdx is false and sortIdx is already set, sortIdx should be preserved.',
        () {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = [
        PlutoRow(
          cells: {'title0': PlutoCell(value: 'test')},
          sortIdx: 3,
        ),
        PlutoRow(
          cells: {'title0': PlutoCell(value: 'test')},
          sortIdx: 4,
        ),
        PlutoRow(
          cells: {'title0': PlutoCell(value: 'test')},
          sortIdx: 5,
        ),
      ];

      expect(rows.first.sortIdx, 3);
      expect(rows.last.sortIdx, 5);

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
        forceApplySortIdx: false,
      );

      expect(rows.first.sortIdx, 3);
      expect(rows.last.sortIdx, 5);
    });

    test('forceApplySortIdx is true, sortIdx should be reset to 0.', () {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = [
        PlutoRow(
          cells: {'title0': PlutoCell(value: 'test')},
          sortIdx: 3,
        ),
        PlutoRow(
          cells: {'title0': PlutoCell(value: 'test')},
          sortIdx: 4,
        ),
        PlutoRow(
          cells: {'title0': PlutoCell(value: 'test')},
          sortIdx: 5,
        ),
      ];

      expect(rows.first.sortIdx, 3);
      expect(rows.last.sortIdx, 5);

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
        forceApplySortIdx: true,
      );

      expect(rows.first.sortIdx, 0);
      expect(rows.last.sortIdx, 2);
    });

    test('increase is false, values should be set from 0 to negative.', () {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
        increase: false,
        forceApplySortIdx: true,
      );

      expect(rows.first.sortIdx, 0);
      expect(rows.last.sortIdx, -4);
    });

    test(
        'increase is false, start is -10, values should be set from -10 to negative.',
        () {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
        PlutoRow(cells: {'title0': PlutoCell(value: 'test')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
        increase: false,
        start: -10,
        forceApplySortIdx: true,
      );

      expect(rows.first.sortIdx, -10);
      expect(rows.last.sortIdx, -14);
    });

    test(
        'When the column type is number, the cell value should be cast to number.',
        () {
      final List<PlutoColumn> columns = [
        PlutoColumn(
          title: 'title',
          field: 'field',
          type: PlutoColumnType.number(),
        )
      ];

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'field': PlutoCell(value: '10')}),
        PlutoRow(cells: {'field': PlutoCell(value: '300')}),
        PlutoRow(cells: {'field': PlutoCell(value: 1000)}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
      );

      expect(rows[0].cells['field']!.value, 10);
      expect(rows[1].cells['field']!.value, 300);
      expect(rows[2].cells['field']!.value, 1000);
    });

    test('When applyFormatOnInit is false, the cell value should not be cast.',
        () {
      final List<PlutoColumn> columns = [
        PlutoColumn(
          title: 'title',
          field: 'field',
          type: PlutoColumnType.number(
            applyFormatOnInit: false,
          ),
        )
      ];

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'field': PlutoCell(value: '10')}),
        PlutoRow(cells: {'field': PlutoCell(value: '300')}),
        PlutoRow(cells: {'field': PlutoCell(value: 1000)}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
      );

      expect(rows[0].cells['field']!.value, '10');
      expect(rows[1].cells['field']!.value, '300');
      expect(rows[2].cells['field']!.value, 1000);
    });

    test('When the column type is Date, the cell value should be formatted.',
        () {
      final List<PlutoColumn> columns = [
        PlutoColumn(
          title: 'title',
          field: 'field',
          type: PlutoColumnType.date(),
        )
      ];

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-01 12:30:51')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-03 12:40:52')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-04 12:50:53')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
      );

      expect(rows[0].cells['field']!.value, '2021-01-01');
      expect(rows[1].cells['field']!.value, '2021-01-03');
      expect(rows[2].cells['field']!.value, '2021-01-04');
    });

    test(
        'When applyFormatOnInit is false, the cell value should not be formatted.',
        () {
      final List<PlutoColumn> columns = [
        PlutoColumn(
          title: 'title',
          field: 'field',
          type: PlutoColumnType.date(
            applyFormatOnInit: false,
          ),
        )
      ];

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-01 12:30:51')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-03 12:40:52')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-04 12:50:53')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
      );

      expect(rows[0].cells['field']!.value, '2021-01-01 12:30:51');
      expect(rows[1].cells['field']!.value, '2021-01-03 12:40:52');
      expect(rows[2].cells['field']!.value, '2021-01-04 12:50:53');
    });

    test('When format is set, the cell value should be formatted.', () {
      final List<PlutoColumn> columns = [
        PlutoColumn(
          title: 'title',
          field: 'field',
          type: PlutoColumnType.date(format: 'yyyy-MM-dd'),
        )
      ];

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-01 12:30:51')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-03 12:40:52')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-04 12:50:53')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
      );

      expect(rows[0].cells['field']!.value, '2021-01-01');
      expect(rows[1].cells['field']!.value, '2021-01-03');
      expect(rows[2].cells['field']!.value, '2021-01-04');
    });

    test('When the cell value is set, the row and column should be set.', () {
      final List<PlutoColumn> columns = [
        PlutoColumn(
          title: 'title',
          field: 'field',
          type: PlutoColumnType.date(format: 'yyyy-MM-dd'),
        )
      ];

      final List<PlutoRow> rows = [
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-01')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-03')}),
        PlutoRow(cells: {'field': PlutoCell(value: '2021-01-04')}),
      ];

      PlutoGridStateManager.initializeRows(
        columns,
        rows,
      );

      expect(rows[0].cells['field']!.row, rows[0]);
      expect(rows[0].cells['field']!.column, columns.first);

      expect(rows[1].cells['field']!.row, rows[1]);
      expect(rows[1].cells['field']!.column, columns.first);

      expect(rows[2].cells['field']!.row, rows[2]);
      expect(rows[2].cells['field']!.column, columns.first);
    });
  });

  group('initializeRowsAsync', () {
    test('When chunkSize is 0, an assertion error should be thrown.', () async {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = RowHelper.count(1, columns);

      expect(
        () async {
          await PlutoGridStateManager.initializeRowsAsync(
            columns,
            rows,
            chunkSize: 0,
          );
        },
        throwsAssertionError,
      );
    });

    test('When chunkSize is -1, an assertion error should be thrown.',
        () async {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = RowHelper.count(1, columns);

      expect(
        () async {
          await PlutoGridStateManager.initializeRowsAsync(
            columns,
            rows,
            chunkSize: -1,
          );
        },
        throwsAssertionError,
      );
    });

    test(
        'When the sortIdx is 0, '
        'the rows should be sorted with the start value changed.', () async {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = RowHelper.count(100, columns);

      final Iterable<Key> rowKeys = rows.map((e) => e.key);

      expect(rows.first.sortIdx, 0);
      expect(rows.last.sortIdx, 99);

      final initializedRows = await PlutoGridStateManager.initializeRowsAsync(
        columns,
        rows,
        forceApplySortIdx: true,
        start: 10,
        chunkSize: 10,
        duration: const Duration(milliseconds: 1),
      );

      for (int i = 0; i < initializedRows.length; i += 1) {
        expect(initializedRows[i].sortIdx, 10 + i);
        expect(initializedRows[i].key, rowKeys.elementAt(i));
      }
    });

    test(
        'When the sortIdx is 0, '
        'the rows should be sorted with the start value changed.', () async {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = RowHelper.count(100, columns);

      final Iterable<Key> rowKeys = rows.map((e) => e.key);

      expect(rows.first.sortIdx, 0);
      expect(rows.last.sortIdx, 99);

      final initializedRows = await PlutoGridStateManager.initializeRowsAsync(
        columns,
        rows,
        forceApplySortIdx: true,
        start: -10,
        chunkSize: 10,
        duration: const Duration(milliseconds: 1),
      );

      for (int i = 0; i < initializedRows.length; i += 1) {
        expect(initializedRows[i].sortIdx, -10 + i);
        expect(initializedRows[i].key, rowKeys.elementAt(i));
      }
    });

    test(
        'When the sortIdx is 0, '
        'the rows should be sorted with the start value changed.', () async {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = RowHelper.count(100, columns);

      final Iterable<Key> rowKeys = rows.map((e) => e.key);

      expect(rows.first.sortIdx, 0);
      expect(rows.last.sortIdx, 99);

      final initializedRows = await PlutoGridStateManager.initializeRowsAsync(
        columns,
        rows,
        forceApplySortIdx: true,
        start: -10,
        chunkSize: 10,
        duration: const Duration(milliseconds: 1),
      );

      for (int i = 0; i < initializedRows.length; i += 1) {
        expect(initializedRows[i].sortIdx, -10 + i);
        expect(initializedRows[i].key, rowKeys.elementAt(i));
      }
    });

    test(
        'When a single row is passed and chunkSize is 10, '
        'it should return normally.', () async {
      final List<PlutoColumn> columns = ColumnHelper.textColumn('title');

      final List<PlutoRow> rows = RowHelper.count(1, columns);

      final initializedRows = await PlutoGridStateManager.initializeRowsAsync(
        columns,
        rows,
        forceApplySortIdx: true,
        start: 99,
        chunkSize: 10,
        duration: const Duration(milliseconds: 1),
      );

      expect(initializedRows.first.sortIdx, 99);
    });
  });
}
