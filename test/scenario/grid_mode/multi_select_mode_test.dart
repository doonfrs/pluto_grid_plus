import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/build_grid_helper.dart';
import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';
import '../../matcher/pluto_object_matcher.dart';
import '../../mock/mock_methods.dart';

void main() {
  late PlutoGridStateManager stateManager;

  final MockMethods mock = MockMethods();

  setUp(() {
    reset(mock);
  });

  buildGrid({
    int numberOfRows = 10,
    void Function(PlutoGridOnLoadedEvent)? onLoaded,
    void Function(PlutoGridOnSelectedEvent)? onSelected,
  }) {
    // given
    final columns = ColumnHelper.textColumn('column');
    final rows = RowHelper.count(numberOfRows, columns);

    return PlutoWidgetTestHelper(
      'build with selecting rows.',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoGrid(
                mode: PlutoGridMode.multiSelect,
                columns: columns,
                rows: rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  if (onLoaded != null) onLoaded(event);
                },
                onSelected: onSelected,
              ),
            ),
          ),
        );
      },
    );
  }

  buildGrid().test(
    'When the first cell is focused',
    (tester) async {
      expect(stateManager.currentCell, isNot(null));
      expect(stateManager.currentCellPosition?.rowIdx, 0);
      expect(stateManager.currentCellPosition?.columnIdx, 0);
    },
  );

  buildGrid(numberOfRows: 0).test(
    'When there are no rows, no error should occur and the grid should be focused',
    (tester) async {
      expect(stateManager.refRows.length, 0);
      expect(stateManager.currentCell, null);
      expect(stateManager.hasFocus, true);
    },
  );

  buildGrid(
    onLoaded: (e) => e.stateManager.setCurrentCell(
      e.stateManager.refRows[1].cells['column0'],
      1,
    ),
  ).test(
    'When selected in onLoaded, the second cell should be focused',
    (tester) async {
      expect(stateManager.currentCell, isNot(null));
      expect(stateManager.currentCellPosition?.rowIdx, 1);
      expect(stateManager.currentCellPosition?.columnIdx, 0);
    },
  );

  buildGrid().test(
    'When running in grid mode, the grid should be focused.',
    (tester) async {
      expect(stateManager.hasFocus, true);
    },
  );

  buildGrid().test(
    'When running in multiSelect mode, the selectingMode should be row.',
    (tester) async {
      expect(stateManager.selectingMode.isRow, true);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When 0, 2, 4 rows are selected, the selectedRows of the onSelected callback should contain the selected rows.',
    (tester) async {
      await tester.tap(find.text('column0 value 0'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 1 &&
              selectedKeys.contains(stateManager.refRows[0].key);
        }))),
      ).called(1);

      await tester.tap(find.text('column0 value 2'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 2 &&
              selectedKeys.contains(stateManager.refRows[0].key) &&
              selectedKeys.contains(stateManager.refRows[2].key);
        }))),
      ).called(1);

      await tester.tap(find.text('column0 value 4'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 3 &&
              selectedKeys.contains(stateManager.refRows[0].key) &&
              selectedKeys.contains(stateManager.refRows[2].key) &&
              selectedKeys.contains(stateManager.refRows[4].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 3);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When 0, 2, 4 rows are selected and 0, 2 are selected again, '
    '4th row should be the only one in the selectedRows of the onSelected callback.',
    (tester) async {
      await tester.tap(find.text('column0 value 0'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('column0 value 2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('column0 value 4'));
      await tester.pumpAndSettle();

      reset(mock);

      await tester.tap(find.text('column0 value 0'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 2 &&
              selectedKeys.contains(stateManager.refRows[2].key) &&
              selectedKeys.contains(stateManager.refRows[4].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 2);

      reset(mock);

      await tester.tap(find.text('column0 value 2'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 1 &&
              selectedKeys.contains(stateManager.refRows[4].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 1);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When the first cell is selected, '
    'press shift + arrowDown 3 times and enter to input, '
    'the onSelected callback should contain rows 0, 1, 2, 3.',
    (tester) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 4 &&
              selectedKeys.contains(stateManager.refRows[0].key) &&
              selectedKeys.contains(stateManager.refRows[1].key) &&
              selectedKeys.contains(stateManager.refRows[2].key) &&
              selectedKeys.contains(stateManager.refRows[3].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 4);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When the first cell is selected, '
    'press shift + tap row 2, '
    'the onSelected callback should contain rows 0, 1, 2.',
    (tester) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.tap(find.text('column0 value 2'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 3 &&
              selectedKeys.contains(stateManager.refRows[0].key) &&
              selectedKeys.contains(stateManager.refRows[1].key) &&
              selectedKeys.contains(stateManager.refRows[2].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 3);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When the first cell is selected, '
    'control + tap row 3, '
    'the onSelected callback should contain row 3.',
    (tester) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
      await tester.tap(find.text('column0 value 3'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 1 &&
              selectedKeys.contains(stateManager.refRows[3].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 1);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When rows 1, 3, 5 are selected, '
    'press escape to clear selection, '
    'the onSelected callback should have null selectedRows.',
    (tester) async {
      await tester.tap(find.text('column0 value 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('column0 value 3'));
      await tester.pumpAndSettle();
      reset(mock);
      await tester.tap(find.text('column0 value 5'));
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 3 &&
              selectedKeys.contains(stateManager.refRows[1].key) &&
              selectedKeys.contains(stateManager.refRows[3].key) &&
              selectedKeys.contains(stateManager.refRows[5].key);
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 3);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          return event.selectedRows == null;
        }))),
      ).called(1);

      expect(stateManager.currentSelectingRows.length, 0);
    },
  );

  buildGrid(onSelected: mock.oneParamReturnVoid<PlutoGridOnSelectedEvent>).test(
    'When rows 2 ~ 5 are selected by drag, '
    'the onSelected callback should contain rows 2 ~ 5.',
    (tester) async {
      final gridHelper = BuildGridHelper();

      await gridHelper.selectRows(
        columnTitle: 'column0',
        startRowIdx: 2,
        endRowIdx: 5,
        tester: tester,
      );
      await tester.pumpAndSettle();

      verify(
        mock.oneParamReturnVoid(
            argThat(PlutoObjectMatcher<PlutoGridOnSelectedEvent>(rule: (event) {
          final selectedKeys = event.selectedRows!.map((e) => e.key);

          return event.selectedRows?.length == 4 &&
              selectedKeys.contains(stateManager.refRows[2].key) &&
              selectedKeys.contains(stateManager.refRows[3].key) &&
              selectedKeys.contains(stateManager.refRows[4].key) &&
              selectedKeys.contains(stateManager.refRows[5].key);
        }))),
      ).called(1);
    },
  );
}
