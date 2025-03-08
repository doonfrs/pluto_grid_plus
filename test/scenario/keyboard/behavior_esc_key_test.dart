import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';
import '../../mock/mock_methods.dart';

void main() {
  group('ESC Key Test', () {
    List<PlutoColumn> columns;

    List<PlutoRow> rows;

    PlutoGridStateManager? stateManager;

    late MockMethods mock = MockMethods();

    setUp(() {
      mock = MockMethods();
    });

    withTheCellSelected([PlutoGridMode mode = PlutoGridMode.normal]) {
      return PlutoWidgetTestHelper(
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
                  mode: mode,
                  onSelected: mock.oneParamReturnVoid,
                ),
              ),
            ),
          );

          await tester.pump();

          await tester.tap(find.text('header0 value 0'));
        },
      );
    }

    withTheCellSelected(PlutoGridMode.select).test(
      'When the grid is in Select mode, the onSelected event should be triggered.',
      (tester) async {
        verify(mock.oneParamReturnVoid(any)).called(1);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      },
    );

    withTheCellSelected().test(
      'When the grid is not in Select mode and is in editing state, '
      'editing should be set to false.',
      (tester) async {
        expect(stateManager!.mode.isSelect, isFalse);

        stateManager!.setEditing(true);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        expect(stateManager!.isEditing, false);
      },
    );

    withTheCellSelected().test(
      'When the grid is not in Select mode and the cell value has changed, '
      'the cell value should be restored to its original value.',
      (tester) async {
        expect(stateManager!.mode.isSelect, isFalse);

        expect(stateManager!.currentCell!.value, 'header0 value 0');

        await tester.sendKeyEvent(LogicalKeyboardKey.keyA);

        await tester.pumpAndSettle();

        expect(stateManager!.textEditingController!.text, 'a');

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        expect(stateManager!.currentCell!.value, isNot('a'));

        expect(stateManager!.currentCell!.value, 'header0 value 0');
      },
    );
  });
}
