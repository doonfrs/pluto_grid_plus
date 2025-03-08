import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';

void main() {
  group('F2 Key Test', () {
    List<PlutoColumn> columns;

    List<PlutoRow> rows;

    PlutoGridStateManager? stateManager;

    final withTheCellSelected = PlutoWidgetTestHelper(
      'With the cell selected',
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
      'When F2 is pressed in non-editing state, cell should enter edit mode',
      (tester) async {
        expect(stateManager!.isEditing, false);

        await tester.sendKeyEvent(LogicalKeyboardKey.f2);

        expect(stateManager!.isEditing, true);
      },
    );
  });
}
