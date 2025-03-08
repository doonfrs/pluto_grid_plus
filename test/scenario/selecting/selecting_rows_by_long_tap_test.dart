import 'package:flutter_test/flutter_test.dart';

import '../../helper/build_grid_helper.dart';

void main() {
  final grid = BuildGridHelper();

  const columnTitle = 'column1';

  group('With 10 rows and selecting 3~5th row, ', () {
    selectRowsFrom3To5(
      String description,
      Future<void> Function(WidgetTester tester) testWithSelectedRowsFrom3To5,
    ) {
      const numberOfRows = 10;
      const startRowIdx = 3;
      const endRowIdx = 5;

      grid
          .buildSelectedRows(
        numberOfRows: numberOfRows,
        startRowIdx: startRowIdx,
        endRowIdx: endRowIdx,
      )
          .test(description, (tester) async {
        await testWithSelectedRowsFrom3To5(tester);
      });
    }

    selectRowsFrom3To5(
      'When another row is tapped, the previous selected row should be invalidated.',
      (tester) async {
        final nonSelectedRow = grid.stateManager.refRows[0];

        final nonSelectedRowWidget = find.text(
          nonSelectedRow.cells[columnTitle]!.value,
        );

        expect(grid.stateManager.isSelectedRow(nonSelectedRow.key), false);

        await tester.tap(nonSelectedRowWidget);

        expect(grid.stateManager.currentSelectingRows.length, 0);
      },
    );

    selectRowsFrom3To5(
      'When another row is long-tapped, the previous selected row should be invalidated and the long-tapped row should be selected.',
      (tester) async {
        await grid.selectRows(
          columnTitle: columnTitle,
          startRowIdx: 1,
          endRowIdx: 1,
          tester: tester,
        );

        expect(grid.stateManager.currentSelectingRows.length, 1);

        expect(
          grid.stateManager.currentSelectingRows[0],
          grid.stateManager.refRows[0],
        );
      },
    );

    selectRowsFrom3To5(
      'When setCurrentCell is called to change the current cell, the selected rows should be invalidated.',
      (tester) async {
        final cell = grid.stateManager.refRows[8].cells[columnTitle];

        expect(grid.stateManager.isCurrentCell(cell), false);

        grid.stateManager.setCurrentCell(cell, 8);

        await tester.pumpAndSettle();

        expect(grid.stateManager.isCurrentCell(cell), true);

        expect(grid.stateManager.currentSelectingRows.length, 0);
      },
    );

    selectRowsFrom3To5(
      'When a cell is tapped to change the current cell, the selected rows should be invalidated.',
      (tester) async {
        final cell = grid.stateManager.refRows[7].cells[columnTitle];

        await tester.tap(find.text(cell!.value));

        await tester.pumpAndSettle();

        expect(grid.stateManager.isCurrentCell(cell), true);

        expect(grid.stateManager.currentSelectingRows.length, 0);
      },
    );

    selectRowsFrom3To5(
      'When setEditing is called to change the editing state, the selected rows should be invalidated.',
      (tester) async {
        final currentCell = grid.stateManager.currentCell;

        expect(currentCell, isNotNull);

        grid.stateManager.setEditing(true);

        await tester.pumpAndSettle();

        expect(grid.stateManager.currentSelectingRows.length, 0);
      },
    );

    selectRowsFrom3To5(
      'When a cell is tapped to change the editing state, the selected rows should be invalidated.',
      (tester) async {
        expect(grid.stateManager.isEditing, false);

        final currentCell = grid.stateManager.currentCell;

        expect(currentCell, isNotNull);

        await tester.tap(find.text(currentCell!.value));

        await tester.tap(find.text(currentCell.value));

        expect(grid.stateManager.isEditing, true);

        expect(grid.stateManager.currentSelectingRows.length, 0);
      },
    );
  });
}
