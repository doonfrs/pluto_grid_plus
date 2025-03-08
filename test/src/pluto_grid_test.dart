import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../helper/column_helper.dart';
import '../helper/row_helper.dart';
import '../helper/test_helper_util.dart';

void main() {
  const columnWidth = PlutoGridSettings.columnWidth;

  const ValueKey<String> sortableGestureKey = ValueKey(
    'ColumnTitleSortableGesture',
  );

  testWidgets(
    'When Directionality is rtl, rtl state should be applied',
    (WidgetTester tester) async {
      // given
      late final PlutoGridStateManager stateManager;
      final columns = ColumnHelper.textColumn('header');
      final rows = RowHelper.count(3, columns);

      // when
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PlutoGrid(
                columns: columns,
                rows: rows,
                onLoaded: (e) => stateManager = e.stateManager,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(stateManager.isLTR, false);
      expect(stateManager.isRTL, true);
    },
  );

  testWidgets(
    'When Directionality is rtl, columns should be positioned according to their frozen state',
    (WidgetTester tester) async {
      // given
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1400,
        height: 600,
      );
      final columns = ColumnHelper.textColumn('header', count: 6);
      final rows = RowHelper.count(3, columns);

      columns[0].frozen = PlutoColumnFrozen.start;
      columns[1].frozen = PlutoColumnFrozen.end;
      columns[2].frozen = PlutoColumnFrozen.start;
      columns[3].frozen = PlutoColumnFrozen.end;

      // when
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PlutoGrid(
                columns: columns,
                rows: rows,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstStartColumn = find.text('header0');
      final secondStartColumn = find.text('header2');
      final firstBodyColumn = find.text('header4');
      final secondBodyColumn = find.text('header5');
      final firstEndColumn = find.text('header1');
      final secondEndColumn = find.text('header3');

      final firstStartColumnDx = tester.getTopRight(firstStartColumn).dx;
      final secondStartColumnDx = tester.getTopRight(secondStartColumn).dx;
      final firstBodyColumnDx = tester.getTopRight(firstBodyColumn).dx;
      final secondBodyColumnDx = tester.getTopRight(secondBodyColumn).dx;
      // Check position of frozen.end column from left due to total width causing center gap
      final firstEndColumnDx = tester.getTopLeft(firstEndColumn).dx;
      final secondEndColumnDx = tester.getTopLeft(secondEndColumn).dx;

      double expectOffset = columnWidth;
      expect(firstStartColumnDx - secondStartColumnDx, expectOffset);

      expectOffset = columnWidth + PlutoGridSettings.gridBorderWidth;
      expect(secondStartColumnDx - firstBodyColumnDx, expectOffset);

      expectOffset = columnWidth;
      expect(firstBodyColumnDx - secondBodyColumnDx, expectOffset);

      // end column should be positioned to the left of center column
      expect(firstEndColumnDx, lessThan(secondBodyColumnDx - columnWidth));

      expectOffset = columnWidth;
      expect(firstEndColumnDx - secondEndColumnDx, expectOffset);
    },
  );

  testWidgets('When createFooter is set, footer should be displayed',
      (WidgetTester tester) async {
    // given
    final columns = ColumnHelper.textColumn('header');
    final rows = RowHelper.count(3, columns);

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            createFooter: (stateManager) {
              return const Text('Footer widget.');
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // then
    final footer = find.text('Footer widget.');
    expect(footer, findsOneWidget);
  });

  testWidgets(
      'When PlutoPagination is set in header, it should be rendered',
      (WidgetTester tester) async {
    // given
    final columns = ColumnHelper.textColumn('header');
    final rows = RowHelper.count(3, columns);

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            createHeader: (stateManager) {
              return PlutoPagination(stateManager);
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // then
    final found = find.byType(PlutoPagination);
    expect(found, findsOneWidget);
  });

  testWidgets(
      'When PlutoPagination is set in footer, it should be rendered',
      (WidgetTester tester) async {
    // given
    final columns = ColumnHelper.textColumn('header');
    final rows = RowHelper.count(3, columns);

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            createFooter: (stateManager) {
              return PlutoPagination(stateManager);
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // then
    final found = find.byType(PlutoPagination);
    expect(found, findsOneWidget);
  });

  testWidgets('Cell values should be displayed', (WidgetTester tester) async {
    // given
    final columns = ColumnHelper.textColumn('header');
    final rows = RowHelper.count(3, columns);

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // then
    final cell1 = find.text('header0 value 0');
    expect(cell1, findsOneWidget);

    final cell2 = find.text('header0 value 1');
    expect(cell2, findsOneWidget);

    final cell3 = find.text('header0 value 2');
    expect(cell3, findsOneWidget);
  });

  testWidgets('Tapping header should trigger sorting', (WidgetTester tester) async {
    // given
    final columns = ColumnHelper.textColumn('header');
    final rows = RowHelper.count(3, columns);

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    Finder sortableGesture = find.descendant(
      of: find.byKey(columns.first.key),
      matching: find.byKey(sortableGestureKey),
    );

    // then
    await tester.tap(sortableGesture);
    // Ascending
    expect(rows[0].cells['header0']!.value, 'header0 value 0');
    expect(rows[1].cells['header0']!.value, 'header0 value 1');
    expect(rows[2].cells['header0']!.value, 'header0 value 2');

    await tester.tap(sortableGesture);
    // Descending
    expect(rows[0].cells['header0']!.value, 'header0 value 2');
    expect(rows[1].cells['header0']!.value, 'header0 value 1');
    expect(rows[2].cells['header0']!.value, 'header0 value 0');

    await tester.tap(sortableGesture);
    // Original
    expect(rows[0].cells['header0']!.value, 'header0 value 0');
    expect(rows[1].cells['header0']!.value, 'header0 value 1');
    expect(rows[2].cells['header0']!.value, 'header0 value 2');
  });

  testWidgets('After changing cell value and tapping header, sorting should reflect the updated value',
      (WidgetTester tester) async {
    // given
    final columns = ColumnHelper.textColumn('header');
    final rows = RowHelper.count(3, columns);

    PlutoGridStateManager? stateManager;

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    Finder firstCell = find.byKey(rows.first.cells['header0']!.key);

    // Select cell
    await tester.tap(
        find.descendant(of: firstCell, matching: find.byType(GestureDetector)));

    expect(stateManager!.isEditing, false);

    // Enter edit mode
    await tester.tap(
        find.descendant(of: firstCell, matching: find.byType(GestureDetector)));

    // Verify edit mode
    expect(stateManager!.isEditing, true);

    // TODO: Cell value change (1) not working, (2) forced
    // (1)
    // await tester.pump(Duration(milliseconds:800));
    //
    // await tester.enterText(
    //     find.descendant(of: firstCell, matching: find.byType(TextField)),
    //     'cell value4');
    // (2)
    stateManager!
        .changeCellValue(stateManager!.currentCell!, 'header0 value 4');

    // Move to next row
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);

    expect(rows[0].cells['header0']!.value, 'header0 value 4');
    expect(rows[1].cells['header0']!.value, 'header0 value 1');
    expect(rows[2].cells['header0']!.value, 'header0 value 2');

    Finder sortableGesture = find.descendant(
      of: find.byKey(columns.first.key),
      matching: find.byKey(sortableGestureKey),
    );

    await tester.tap(sortableGesture);
    // Ascending
    expect(rows[0].cells['header0']!.value, 'header0 value 1');
    expect(rows[1].cells['header0']!.value, 'header0 value 2');
    expect(rows[2].cells['header0']!.value, 'header0 value 4');

    await tester.tap(sortableGesture);
    // Descending
    expect(rows[0].cells['header0']!.value, 'header0 value 4');
    expect(rows[1].cells['header0']!.value, 'header0 value 2');
    expect(rows[2].cells['header0']!.value, 'header0 value 1');

    await tester.tap(sortableGesture);
    // Original
    expect(rows[0].cells['header0']!.value, 'header0 value 4');
    expect(rows[1].cells['header0']!.value, 'header0 value 1');
    expect(rows[2].cells['header0']!.value, 'header0 value 2');
  });

  testWidgets(
      'Without frozen columns, '
      'move column 0 to position 2',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('body', count: 10, width: 100),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager? stateManager;

    // when
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // when
    stateManager!.moveColumn(column: columns[0], targetColumn: columns[2]);

    // then
    expect(columns[0].title, 'body1');
    expect(columns[1].title, 'body2');
    expect(columns[2].title, 'body0');
  });

  // ... rest of the code remains the same ...
}
