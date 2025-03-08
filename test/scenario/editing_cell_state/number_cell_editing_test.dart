import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../mock/mock_methods.dart';

void main() {
  late PlutoGridStateManager stateManager;

  Widget buildGrid({
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    void Function(PlutoGridOnChangedEvent)? onChanged,
  }) {
    return MaterialApp(
      home: Material(
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
          },
          onChanged: onChanged,
        ),
      ),
    );
  }

  group('Number Cell Editing Test', () {
    testWidgets('Decimal points should be used as the decimal separator in the default locale.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      expect(find.text('12,345.01'), findsOneWidget);
      expect(find.text('12,345.02'), findsOneWidget);
      expect(find.text('12,345.11'), findsOneWidget);
    });

    testWidgets('Decimal points should be used as the decimal separator when editing a cell.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      await tester.tap(find.text('12,345.01'));
      await tester.tap(find.text('12,345.01'));
      await tester.pump();

      expect(stateManager.isEditing, true);

      expect(find.text('12345.01'), findsOneWidget);
    });

    testWidgets('The onChanged callback should not be called when the value is not changed.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      final mock = MockMethods();

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        onChanged: mock.oneParamReturnVoid,
      ));

      final cellWidget = find.text('12,345.01');

      await tester.tap(cellWidget);
      await tester.tap(cellWidget);
      await tester.pump();

      expect(stateManager.isEditing, true);

      await tester.enterText(find.text('12345.01'), '12345.01');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      verifyNever(mock.oneParamReturnVoid(any));
      expect(stateManager.rows.first.cells['column']?.value, 12345.01);
    });

    testWidgets('The onChanged callback should be called when the value is changed.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      final mock = MockMethods();

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        onChanged: mock.oneParamReturnVoid,
      ));

      final cellWidget = find.text('12,345.01');

      await tester.tap(cellWidget);
      await tester.tap(cellWidget);
      await tester.pump();

      expect(stateManager.isEditing, true);

      await tester.enterText(find.text('12345.01'), '12345.99');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      verify(mock.oneParamReturnVoid(any)).called(1);
      expect(stateManager.rows.first.cells['column']?.value, 12345.99);
    });
  });

  group('Countries that use commas as decimal separators', () {
    setUpAll(() {
      PlutoGrid.setDefaultLocale('da_DK');
    });

    testWidgets('Decimal points should be used as the decimal separator in the default locale.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      expect(find.text('12.345,01'), findsOneWidget);
      expect(find.text('12.345,02'), findsOneWidget);
      expect(find.text('12.345,11'), findsOneWidget);
    });

    testWidgets('Decimal points should be used as the decimal separator when editing a cell.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      await tester.tap(find.text('12.345,01'));
      await tester.tap(find.text('12.345,01'));
      await tester.pump();

      expect(stateManager.isEditing, true);

      expect(find.text('12345,01'), findsOneWidget);
    });

    testWidgets('The onChanged callback should not be called when the value is not changed.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      final mock = MockMethods();

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        onChanged: mock.oneParamReturnVoid,
      ));

      final cellWidget = find.text('12.345,01');

      await tester.tap(cellWidget);
      await tester.tap(cellWidget);
      await tester.pump();

      expect(stateManager.isEditing, true);

      await tester.enterText(find.text('12345,01'), '12345,01');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      verifyNever(mock.oneParamReturnVoid(any));
      expect(stateManager.rows.first.cells['column']?.value, 12345.01);
    });

    testWidgets('The onChanged callback should be called when the value is changed.', (tester) async {
      final columns = [
        PlutoColumn(
          title: 'column',
          field: 'column',
          type: PlutoColumnType.number(format: '#,###.##'),
        ),
      ];

      final rows = [
        PlutoRow(cells: {'column': PlutoCell(value: 12345.01)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.02)}),
        PlutoRow(cells: {'column': PlutoCell(value: 12345.11)}),
      ];

      final mock = MockMethods();

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        onChanged: mock.oneParamReturnVoid,
      ));

      final cellWidget = find.text('12.345,01');

      await tester.tap(cellWidget);
      await tester.tap(cellWidget);
      await tester.pump();

      expect(stateManager.isEditing, true);

      await tester.enterText(find.text('12345,01'), '12345,99');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      verify(mock.oneParamReturnVoid(any)).called(1);
      expect(stateManager.rows.first.cells['column']?.value, 12345.99);
    });
  });
}
