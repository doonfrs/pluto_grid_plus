import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';
import '../../helper/test_helper_util.dart';

void main() {
  testWidgets(
      'When two columns are frozen, '
      'the cells should move correctly when the direction keys are pressed.',
      (WidgetTester tester) async {
    await TestHelperUtil.changeWidth(
      tester: tester,
      width: 1000,
      height: 500,
    );

    // given
    final columns = [
      ColumnHelper.textColumn('headerL', frozen: PlutoColumnFrozen.start).first,
      ...ColumnHelper.textColumn('headerB', count: 3),
      ColumnHelper.textColumn('headerR', frozen: PlutoColumnFrozen.end).first,
    ];
    final rows = RowHelper.count(10, columns);

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
    // Third column frozen to the left
    stateManager!.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

    await tester.pumpAndSettle();

    // First cell of first column
    Finder firstCell = find.byKey(rows.first.cells['headerL0']!.key);

    // Select first cell
    await tester.tap(
        find.descendant(of: firstCell, matching: find.byType(GestureDetector)));

    // First cell value check
    expect(stateManager!.currentCell!.value, 'headerL0 value 0');

    await tester.pumpAndSettle();

    // Move cell right
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    // Left frozen column second column (headerB1) first cell value check
    expect(stateManager!.currentCell!.value, 'headerB1 value 0');

    // Move cell right
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    // Left frozen columns (2 columns) and first column of Body (headerB0) first cell value check
    expect(stateManager!.currentCell!.value, 'headerB0 value 0');

    // Move cell left
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();

    // Left frozen column second column (headerB1) first cell value check
    expect(stateManager!.currentCell!.value, 'headerB1 value 0');

    // 셀 우측 끝으로 이동해서 우측 고정 된 셀 값 확인
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    // 우측 끝 고정 컬럼 값 확인
    expect(stateManager!.currentCell!.value, 'headerR0 value 0');

    // Move cell left
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();

    // Right frozen column last column (headerR0) first cell value check
    expect(stateManager!.currentCell!.value, 'headerR0 value 0');
  });

  testWidgets(
      'WHEN frozen one column on the right when there are no frozen columns in the grid.'
      'THEN showFrozenColumn changes to true and the column is moved to the right and should disappear from its original position.',
      (WidgetTester tester) async {
    // given
    final columns = [
      ...ColumnHelper.textColumn('header', count: 10),
    ];
    final rows = RowHelper.count(10, columns);

    PlutoGridStateManager? stateManager;

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
    // first cell of first column
    Finder firstCell = find.byKey(rows.first.cells['header0']!.key);

    // select first cell
    await tester.tap(
        find.descendant(of: firstCell, matching: find.byType(GestureDetector)));

    // Check first cell value of first column
    expect(stateManager!.currentCell!.value, 'header0 value 0');

    // Check showFrozenColumn before freezing column.
    expect(stateManager!.showFrozenColumn, false);

    // Freeze the 3rd column
    stateManager!.toggleFrozenColumn(columns[2], PlutoColumnFrozen.end);

    // Await re-build by toggleFrozenColumn
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Check showFrozenColumn after freezing column.
    expect(stateManager!.showFrozenColumn, true);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(stateManager!.currentColumn!.title, 'header0');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(stateManager!.currentColumn!.title, 'header1');

    // Move current cell position to 10rd column (1 -> 9)
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(stateManager!.currentColumn!.title, 'header9');

    // Right frozen column
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(stateManager!.currentColumn!.title, 'header2');
  });
}
