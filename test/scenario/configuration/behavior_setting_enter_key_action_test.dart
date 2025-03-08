import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';

/// When enterKeyAction is set, test.
void main() {
  group('Enter key test.', () {
    List<PlutoColumn> columns;

    List<PlutoRow> rows;

    PlutoGridStateManager? stateManager;

    withEnterKeyAction(PlutoGridEnterKeyAction enterKeyAction) {
      return PlutoWidgetTestHelper(
        '2, 2 cell is selected',
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
                  configuration: PlutoGridConfiguration(
                    enterKeyAction: enterKeyAction,
                  ),
                ),
              ),
            ),
          );

          await tester.pump();

          await tester.tap(find.text('header2 value 2'));
        },
      );
    }

    withEnterKeyAction(PlutoGridEnterKeyAction.none).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.none, '
      'pressing enter should not edit cell or move',
      (tester) async {
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        expect(stateManager!.currentCellPosition!.rowIdx, 2);
        expect(stateManager!.currentCellPosition!.columnIdx, 2);
      },
    );

    withEnterKeyAction(PlutoGridEnterKeyAction.toggleEditing).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.toggleEditing, '
      'pressing enter should toggle edit mode',
      (tester) async {
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        expect(stateManager!.isEditing, isFalse);
        expect(stateManager!.currentCellPosition!.rowIdx, 2);
        expect(stateManager!.currentCellPosition!.columnIdx, 2);
      },
    );

    withEnterKeyAction(PlutoGridEnterKeyAction.toggleEditing).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.toggleEditing, '
      'pressing enter should toggle edit mode',
      (tester) async {
        stateManager!.setEditing(false);
        expect(stateManager!.isEditing, false);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        expect(stateManager!.isEditing, isTrue);
        expect(stateManager!.currentCellPosition!.rowIdx, 2);
        expect(stateManager!.currentCellPosition!.columnIdx, 2);
      },
    );

    withEnterKeyAction(PlutoGridEnterKeyAction.editingAndMoveDown).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.editingAndMoveDown, '
      'pressing enter should edit cell and move down',
      (tester) async {
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        expect(stateManager!.isEditing, isTrue);
        expect(stateManager!.currentCellPosition!.rowIdx, 3);
        expect(stateManager!.currentCellPosition!.columnIdx, 2);
      },
    );

    withEnterKeyAction(PlutoGridEnterKeyAction.editingAndMoveDown).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.editingAndMoveDown, '
      'pressing enter with shift should edit cell and move up',
      (tester) async {
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);

        expect(stateManager!.isEditing, isTrue);
        expect(stateManager!.currentCellPosition!.rowIdx, 1);
        expect(stateManager!.currentCellPosition!.columnIdx, 2);
      },
    );

    withEnterKeyAction(PlutoGridEnterKeyAction.editingAndMoveRight).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.editingAndMoveRight, '
      'pressing enter should edit cell and move right',
      (tester) async {
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        expect(stateManager!.isEditing, isTrue);
        expect(stateManager!.currentCellPosition!.rowIdx, 2);
        expect(stateManager!.currentCellPosition!.columnIdx, 3);
      },
    );

    withEnterKeyAction(PlutoGridEnterKeyAction.editingAndMoveRight).test(
      'When enterKeyAction is PlutoGridEnterKeyAction.editingAndMoveRight, '
      'pressing enter with shift should edit cell and move left',
      (tester) async {
        stateManager!.setEditing(true);
        expect(stateManager!.isEditing, true);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);

        expect(stateManager!.isEditing, isTrue);
        expect(stateManager!.currentCellPosition!.rowIdx, 2);
        expect(stateManager!.currentCellPosition!.columnIdx, 1);
      },
    );
  });
}
