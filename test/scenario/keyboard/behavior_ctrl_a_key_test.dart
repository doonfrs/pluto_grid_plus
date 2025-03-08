import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';

void main() {
  group('Ctrl+A Key Test', () {
    List<PlutoColumn> columns;

    List<PlutoRow> rows;

    PlutoGridStateManager? stateManager;

    final withTheCellSelected = PlutoWidgetTestHelper(
      '0, 0 cell is selected',
      (tester) async {
        columns = [
          ...ColumnHelper.textColumn('header', count: 10),
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
                },
              ),
            ),
          ),
        );

        await tester.pump();

        await tester.tap(find.text('header0 value 0'));
      },
    );

    withTheCellSelected.test(
      'When Ctrl+A is pressed in normal mode, all cells should be selected',
      (tester) async {
        expect(stateManager!.selectingMode.isCell, true);
        expect(stateManager!.isEditing, false);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.control);

        expect(stateManager!.currentCellPosition!.rowIdx, 0);
        expect(stateManager!.currentCellPosition!.columnIdx, 0);

        expect(stateManager!.currentSelectingPosition!.rowIdx, 9);
        expect(stateManager!.currentSelectingPosition!.columnIdx, 9);
      },
    );

    withTheCellSelected.test(
      'When Ctrl+A is pressed in editing mode, cell selection should not occur',
      (tester) async {
        expect(stateManager!.selectingMode.isCell, true);
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.control);

        expect(stateManager!.currentCellPosition!.rowIdx, 0);
        expect(stateManager!.currentCellPosition!.columnIdx, 0);

        expect(stateManager!.currentSelectingPosition, null);
      },
    );
  });
}
