import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';

void main() {
  group('Auto Editing Test', () {
    List<PlutoColumn> columns;

    List<PlutoRow> rows;

    PlutoGridStateManager? stateManager;

    final plutoGrid = PlutoWidgetTestHelper(
      '5 columns and 10 rows are created',
      (tester) async {
        columns = [
          ...ColumnHelper.textColumn('header', count: 5),
        ];

        rows = RowHelper.count(10, columns);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoGrid(
                columns: columns,
                rows: rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  stateManager!.setAutoEditing(true);
                },
              ),
            ),
          ),
        );
      },
    );

    plutoGrid.test(
      'When clicking the first cell, the editing state should be true.',
      (tester) async {
        expect(stateManager!.isEditing, false);

        await tester.tap(find.text('header0 value 0'));

        expect(stateManager!.currentCell!.value, 'header0 value 0');

        expect(stateManager!.isEditing, true);
      },
    );

    plutoGrid.test(
      'When clicking the first cell and pressing the tab key, the second cell should be in editing state.',
      (tester) async {
        expect(stateManager!.isEditing, false);

        await tester.tap(find.text('header0 value 0'));

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);

        expect(stateManager!.currentCell!.value, 'header1 value 0');

        expect(stateManager!.isEditing, true);
      },
    );

    plutoGrid.test(
      'When clicking the first cell and pressing the enter key, the first cell of the second row should be in editing state.',
      (tester) async {
        expect(stateManager!.isEditing, false);

        await tester.tap(find.text('header0 value 0'));

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        expect(stateManager!.currentCell!.value, 'header0 value 1');

        expect(stateManager!.isEditing, true);
      },
    );

    plutoGrid.test(
      'When clicking the first cell and pressing the ESC key, the editing state should change from true to false.',
      (tester) async {
        expect(stateManager!.isEditing, false);

        await tester.tap(find.text('header0 value 0'));

        expect(stateManager!.isEditing, true);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        expect(stateManager!.currentCell!.value, 'header0 value 0');

        expect(stateManager!.isEditing, false);
      },
    );

    plutoGrid.test(
      'When clicking the first cell and pressing the ESC key, then pressing the end key, the last cell should be in editing state.',
      (tester) async {
        await tester.tap(find.text('header0 value 0'));

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        await tester.sendKeyEvent(LogicalKeyboardKey.end);

        expect(stateManager!.currentCell!.value, 'header4 value 0');

        expect(stateManager!.isEditing, true);
      },
    );

    plutoGrid.test(
      'When clicking the first cell and pressing the ESC key, then pressing the down arrow key, the second cell should be in editing state.',
      (tester) async {
        await tester.tap(find.text('header0 value 0'));

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);

        expect(stateManager!.currentCell!.value, 'header0 value 1');

        expect(stateManager!.isEditing, true);
      },
    );

    plutoGrid.test(
      'When clicking the first cell and pressing the ESC key, then pressing the right arrow key, the second cell should be in editing state.',
      (tester) async {
        await tester.tap(find.text('header0 value 0'));

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);

        expect(stateManager!.currentCell!.value, 'header1 value 0');

        expect(stateManager!.isEditing, true);
      },
    );
  });
}
