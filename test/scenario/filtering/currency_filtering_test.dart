import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

void main() {
  late PlutoGridStateManager stateManager;

  Widget buildGrid({
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
  }) {
    return MaterialApp(
      home: Material(
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (e) {
            stateManager = e.stateManager;
            stateManager.setShowColumnFilter(true);
          },
        ),
      ),
    );
  }

  Finder findFilterTextField() {
    return find.descendant(
      of: find.byType(PlutoColumnFilter),
      matching: find.byType(TextField),
    );
  }

  Future<void> tapAndEnterTextColumnFilter(
    WidgetTester tester,
    String? enterText,
  ) async {
    final textField = findFilterTextField();

    // To receive focus, tap the text box twice.
    await tester.tap(textField);
    await tester.tap(textField);

    if (enterText != null) {
      await tester.enterText(textField, enterText);
    }
  }

  group('Currency Column Filtering Test', () {
    final columns = [
      PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.currency(),
      ),
    ];

    final rows = [
      PlutoRow(cells: {'column': PlutoCell(value: 0)}),
      PlutoRow(cells: {'column': PlutoCell(value: -100)}),
      PlutoRow(cells: {'column': PlutoCell(value: -123000)}),
      PlutoRow(cells: {'column': PlutoCell(value: 123000)}),
      PlutoRow(cells: {'column': PlutoCell(value: 1)}),
      PlutoRow(cells: {'column': PlutoCell(value: -1)}),
      PlutoRow(cells: {'column': PlutoCell(value: 300)}),
      PlutoRow(cells: {'column': PlutoCell(value: 311)}),
      PlutoRow(cells: {'column': PlutoCell(value: -999)}),
      PlutoRow(cells: {'column': PlutoCell(value: 3133)}),
    ];

    testWidgets('Rendering Test', (tester) async {
      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      expect(find.text('USD0.00'), findsOneWidget);
      expect(find.text('-USD100.00'), findsOneWidget);
      expect(find.text('-USD123,000.00'), findsOneWidget);
      expect(find.text('USD123,000.00'), findsOneWidget);
      expect(find.text('USD1.00'), findsOneWidget);
      expect(find.text('-USD1.00'), findsOneWidget);
      expect(find.text('USD300.00'), findsOneWidget);
      expect(find.text('USD311.00'), findsOneWidget);
      expect(find.text('-USD999.00'), findsOneWidget);
      expect(find.text('USD3,133.00'), findsOneWidget);
    });

    testWidgets('Filtering numbers greater than 300', (tester) async {
      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));
      await tester.pump();

      columns.first.setDefaultFilter(const PlutoFilterTypeGreaterThan());

      await tapAndEnterTextColumnFilter(tester, '300');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final values = stateManager.refRows.map((e) => e.cells['column']!.value);

      expect(values, [123000, 311, 3133]);
    });

    testWidgets('Filtering numbers greater than or equal to 300',
        (tester) async {
      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));
      await tester.pump();

      columns.first.setDefaultFilter(
        const PlutoFilterTypeGreaterThanOrEqualTo(),
      );

      await tapAndEnterTextColumnFilter(tester, '300');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final values = stateManager.refRows.map((e) => e.cells['column']!.value);

      expect(values, [123000, 300, 311, 3133]);
    });

    testWidgets('Filtering numbers greater than 300.01', (tester) async {
      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));
      await tester.pump();

      columns.first.setDefaultFilter(const PlutoFilterTypeGreaterThan());

      await tapAndEnterTextColumnFilter(tester, '300.01');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final values = stateManager.refRows.map((e) => e.cells['column']!.value);

      expect(values, [123000, 311, 3133]);
    });

    testWidgets('Filtering numbers greater than USD300.01', (tester) async {
      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));
      await tester.pump();

      columns.first.setDefaultFilter(const PlutoFilterTypeGreaterThan());

      await tapAndEnterTextColumnFilter(tester, 'USD300.01');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final values = stateManager.refRows.map((e) => e.cells['column']!.value);

      expect(values, [123000, 311, 3133]);
    });
  });
}
