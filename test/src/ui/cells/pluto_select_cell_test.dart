import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../../helper/pluto_widget_test_helper.dart';
import '../../../helper/row_helper.dart';
import '../../../mock/shared_mocks.mocks.dart';

const selectItems = ['a', 'b', 'c'];

void main() {
  late MockPlutoGridStateManager stateManager;

  setUp(() {
    stateManager = MockPlutoGridStateManager();

    when(stateManager.configuration).thenReturn(
      const PlutoGridConfiguration(
        enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
        enableMoveDownAfterSelecting: false,
      ),
    );
    when(stateManager.keyPressed).thenReturn(PlutoGridKeyPressed());
    when(stateManager.columnHeight).thenReturn(
      stateManager.configuration.style.columnHeight,
    );
    when(stateManager.rowHeight).thenReturn(
      stateManager.configuration.style.rowHeight,
    );
    when(stateManager.headerHeight).thenReturn(
      stateManager.configuration.style.columnHeight,
    );
    when(stateManager.rowTotalHeight).thenReturn(
      RowHelper.resolveRowTotalHeight(
        stateManager.configuration.style.rowHeight,
      ),
    );
    when(stateManager.localeText).thenReturn(const PlutoGridLocaleText());
    when(stateManager.keepFocus).thenReturn(true);
    when(stateManager.hasFocus).thenReturn(true);
  });

  group('Suffix icon rendering', () {
    final PlutoCell cell = PlutoCell(value: 'A');

    final PlutoRow row = PlutoRow(
      cells: {
        'column_field_name': cell,
      },
    );

    testWidgets('Default dropdown icon should be rendered', (tester) async {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.select(['A']),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoSelectCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('Custom icon should be rendered', (tester) async {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.select(
          ['A'],
          popupIcon: Icons.add,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoSelectCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('When popupIcon is null, icon should not be rendered', (tester) async {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.select(
          ['A'],
          popupIcon: null,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoSelectCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });
  });

  group(
    'When enterKeyAction is PlutoGridEnterKeyAction.toggleEditing and '
    'enableMoveDownAfterSelecting is false',
    () {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.select(selectItems),
      );

      final PlutoCell cell = PlutoCell(value: selectItems.first);

      final PlutoRow row = PlutoRow(
        cells: {
          'column_field_name': cell,
        },
      );

      final cellWidget =
          PlutoWidgetTestHelper('Build and tap cell.', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoSelectCell(
                stateManager: stateManager,
                cell: cell,
                column: column,
                row: row,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextField));
      });

      cellWidget.test('Pressing F2 should open the popup', (tester) async {
        await tester.sendKeyEvent(LogicalKeyboardKey.f2);

        expect(find.byType(PlutoGrid), findsOneWidget);
      });

      cellWidget.test('After closing popup with ESC and pressing F2 again, popup should reopen',
          (tester) async {
        await tester.sendKeyEvent(LogicalKeyboardKey.f2);

        expect(find.byType(PlutoGrid), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);

        await tester.pumpAndSettle();

        expect(find.byType(PlutoGrid), findsNothing);

        await tester.sendKeyEvent(LogicalKeyboardKey.f2);

        await tester.pumpAndSettle();

        expect(find.byType(PlutoGrid), findsOneWidget);
      });

      cellWidget.test(
          'After selecting an item with arrow keys and enter, popup should be displayed again',
          (tester) async {
        await tester.sendKeyEvent(LogicalKeyboardKey.f2);

        expect(find.byType(PlutoGrid), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        await tester.pumpAndSettle();

        expect(find.byType(PlutoGrid), findsNothing);
        expect(find.text(selectItems[1]), findsNothing);

        await tester.sendKeyEvent(LogicalKeyboardKey.f2);

        await tester.pumpAndSettle();

        expect(find.byType(PlutoGrid), findsOneWidget);
      });
    },
  );
}
