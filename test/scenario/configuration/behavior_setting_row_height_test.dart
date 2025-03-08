import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';

/// Row height setting behavior test
void main() {
  const PlutoGridSelectingMode selectingMode = PlutoGridSelectingMode.row;

  PlutoGridStateManager? stateManager;

  buildRowsWithSettingRowHeight({
    int numberOfRows = 10,
    List<PlutoColumn>? columns,
    int columnIdx = 0,
    int rowIdx = 0,
    double rowHeight = 45.0,
  }) {
    // given
    final safetyColumns =
        columns ?? ColumnHelper.textColumn('header', count: 10);
    final rows = RowHelper.count(numberOfRows, safetyColumns);

    return PlutoWidgetTestHelper(
      'build with setting row height.',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoGrid(
                columns: safetyColumns,
                rows: rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  stateManager!.setSelectingMode(selectingMode);

                  stateManager!.setCurrentCell(
                    stateManager!.rows[rowIdx].cells['header$columnIdx'],
                    rowIdx,
                  );
                },
                configuration: PlutoGridConfiguration(
                  style: PlutoGridStyleConfig(
                    rowHeight: rowHeight,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(stateManager!.currentCell, isNotNull);
        expect(stateManager!.currentCellPosition!.columnIdx, columnIdx);
        expect(stateManager!.currentCellPosition!.rowIdx, rowIdx);
      },
    );
  }

  group('state', () {
    const rowHeight = 90.0;

    buildRowsWithSettingRowHeight(rowHeight: rowHeight).test(
      'When rowHeight is set to 90, rowTotalHeight should be 90 + PlutoDefaultSettings.rowBorderWidth',
      (tester) async {
        expect(
          stateManager!.rowTotalHeight,
          rowHeight + PlutoGridSettings.rowBorderWidth,
        );
      },
    );
  });

  group('widget', () {
    const rowHeight = 90.0;

    buildRowsWithSettingRowHeight(rowHeight: rowHeight).test(
      'CellWidget height should be equal to the set row height',
      (tester) async {
        final Size cellSize = tester.getSize(find.byType(PlutoBaseCell).first);

        expect(cellSize.height, rowHeight);
      },
    );

    buildRowsWithSettingRowHeight(
      rowHeight: rowHeight,
      columns: [
        PlutoColumn(
            title: 'header',
            field: 'header0',
            type: PlutoColumnType.select(<String>['one', 'two', 'three'])),
      ],
    ).test(
      'When row height is set, select column popup cell height should be equal to the set row height',
      (tester) async {
        // Editing 상태로 설정
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(stateManager!.isEditing, isTrue);

        // select 팝업 호출
        await tester.pumpAndSettle(const Duration(milliseconds: 300));
        await tester.sendKeyEvent(LogicalKeyboardKey.f2);
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        final popupGrid = find.byType(PlutoGrid).last;

        final Size cellPopupSize = tester.getSize(find
            .descendant(of: popupGrid, matching: find.byType(PlutoBaseCell))
            .first);

        // select 팝업 높이 확인
        expect(cellPopupSize.height, rowHeight);
      },
    );

    buildRowsWithSettingRowHeight(
      rowHeight: rowHeight,
      columns: ColumnHelper.dateColumn('header', count: 10),
    ).test(
      'When row height is set, date column popup cell height should be equal to the set row height',
      (tester) async {
        // Editing 상태로 설정
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(stateManager!.isEditing, isTrue);

        // date 팝업 호출
        await tester.pumpAndSettle(const Duration(milliseconds: 300));
        await tester.sendKeyEvent(LogicalKeyboardKey.f2);
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        final sundayColumn =
            find.text(stateManager!.configuration.localeText.sunday);

        expect(
          sundayColumn,
          findsOneWidget,
        );

        // date 팝업의 CellWidget 높이 확인
        final parent =
            find.ancestor(of: sundayColumn, matching: find.byType(PlutoGrid));

        final Size cellSize = tester.getSize(find
            .descendant(of: parent, matching: find.byType(PlutoBaseCell))
            .first);

        expect(cellSize.height, rowHeight);
      },
    );

    buildRowsWithSettingRowHeight(
      rowHeight: rowHeight,
      columns: ColumnHelper.timeColumn('header', count: 10),
    ).test(
      'When row height is set, time column popup cell height should be equal to the set row height',
      (tester) async {
        // Editing 상태로 설정
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(stateManager!.isEditing, isTrue);

        // time 팝업 호출
        await tester.pumpAndSettle(const Duration(milliseconds: 300));
        await tester.sendKeyEvent(LogicalKeyboardKey.f2);
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        final hourColumn =
            find.text(stateManager!.configuration.localeText.hour);

        expect(
          hourColumn,
          findsOneWidget,
        );

        // time 팝업의 CellWidget 높이 확인
        final parent =
            find.ancestor(of: hourColumn, matching: find.byType(PlutoGrid));

        final Size cellSize = tester.getSize(find
            .descendant(of: parent, matching: find.byType(PlutoBaseCell))
            .first);

        expect(cellSize.height, rowHeight);
      },
    );
  });
}
