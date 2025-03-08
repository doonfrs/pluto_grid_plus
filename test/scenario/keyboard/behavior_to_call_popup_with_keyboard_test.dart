import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/pluto_widget_test_helper.dart';

/// Test for calling a popup grid with a keyboard and selecting a date
void main() {
  PlutoGridStateManager? stateManager;

  buildGrid({
    int numberOfRows = 10,
    int numberOfColumns = 10,
    PlutoGridConfiguration configuration = const PlutoGridConfiguration(),
  }) {
    // given
    final columns = [
      PlutoColumn(
        title: 'date',
        field: 'date',
        type: PlutoColumnType.date(
          startDate: DateTime.parse('2020-01-01'),
          endDate: DateTime.parse('2020-01-31'),
        ),
      )
    ];

    final rows = [
      PlutoRow(cells: {'date': PlutoCell(value: '2020-01-01')}),
      PlutoRow(cells: {'date': PlutoCell(value: '2020-01-02')}),
      PlutoRow(cells: {'date': PlutoCell(value: '2020-01-03')}),
      PlutoRow(cells: {'date': PlutoCell(value: '2020-01-04')}),
      PlutoRow(cells: {'date': PlutoCell(value: '2020-01-05')}),
    ];

    return PlutoWidgetTestHelper(
      'build with selecting cells.',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoGrid(
                columns: columns,
                rows: rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                },
                configuration: configuration,
              ),
            ),
          ),
        );
      },
    );
  }

  buildGrid(
    configuration: const PlutoGridConfiguration(
      enableMoveDownAfterSelecting: true,
    ),
  ).test(
    'When the first cell is selected, '
    'the first cell should be focused.',
    (tester) async {
      // Select the 0th row, which is January 1st, 2020
      await tester.tap(find.text('2020-01-01'));

      // After selecting the date below 2020-01-01, select 2020-01-08 and press enter to move to the next row.
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      expect(stateManager!.isEditing, isTrue);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      // The cell value should be changed to 2020-01-08.
      expect(stateManager!.rows[0].cells['date']!.value, '2020-01-08');

      // The current cell position should be changed to the next row.
      expect(stateManager!.currentCellPosition!.rowIdx, 1);

      // The editing state should be maintained.
      expect(stateManager!.isEditing, isTrue);

      // Enter the string to call the popup again and select 2020-01-09,
      // which is below 2020-01-02, and press enter to move to the next row.
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      // The cell value should be changed to 2020-01-09.
      expect(stateManager!.rows[1].cells['date']!.value, '2020-01-09');

      // The current cell position should be changed to the next row.
      expect(stateManager!.currentCellPosition!.rowIdx, 2);

      // The editing state should be maintained.
      expect(stateManager!.isEditing, isTrue);
    },
  );
}
