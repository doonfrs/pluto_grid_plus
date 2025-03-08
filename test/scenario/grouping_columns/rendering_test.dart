import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';
import '../../helper/test_helper_util.dart';

void main() {
  late PlutoGridStateManager stateManager;

  Future<void> buildGrid({
    required WidgetTester tester,
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    List<PlutoColumnGroup>? columnGroups,
  }) async {
    await TestHelperUtil.changeWidth(tester: tester, width: 1200, height: 800);

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            columnGroups: columnGroups,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Column groups grouped by 1 level should be rendered', (tester) async {
    final columns = ColumnHelper.textColumn('column', count: 5, start: 1);

    final rows = RowHelper.count(10, columns);

    final columnGroups = <PlutoColumnGroup>[
      PlutoColumnGroup(title: 'groupA', fields: ['column1', 'column2']),
      PlutoColumnGroup(title: 'groupB', fields: ['column3', 'column4']),
      PlutoColumnGroup(title: 'groupC', fields: ['column5']),
    ];

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    expect(find.text('groupA'), findsOneWidget);
    expect(find.text('groupB'), findsOneWidget);
    expect(find.text('groupC'), findsOneWidget);
  });

  testWidgets('Expanded group columns should not be rendered', (tester) async {
    final columns = ColumnHelper.textColumn('column', count: 5, start: 1);

    final rows = RowHelper.count(10, columns);

    final columnGroups = <PlutoColumnGroup>[
      PlutoColumnGroup(title: 'groupA', fields: ['column1', 'column2']),
      PlutoColumnGroup(title: 'groupB', fields: ['column3', 'column4']),
      PlutoColumnGroup(
        title: 'groupC',
        fields: ['column5'],
        expandedColumn: true,
      ),
    ];

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    expect(find.text('groupA'), findsOneWidget);
    expect(find.text('groupB'), findsOneWidget);
    expect(find.text('groupC'), findsNothing);
  });

  testWidgets('If column3 is hidden, groupB should not be hidden', (tester) async {
    final columns = ColumnHelper.textColumn('column', count: 5, start: 1);

    final rows = RowHelper.count(10, columns);

    final columnGroups = <PlutoColumnGroup>[
      PlutoColumnGroup(title: 'groupA', fields: ['column1', 'column2']),
      PlutoColumnGroup(title: 'groupB', fields: ['column3', 'column4']),
      PlutoColumnGroup(title: 'groupC', fields: ['column5']),
    ];

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    expect(find.text('groupB'), findsOneWidget);
    expect(find.text('column3'), findsOneWidget);
    expect(find.text('column4'), findsOneWidget);
    stateManager.hideColumn(columns[2], true);
    await tester.pumpAndSettle();

    expect(find.text('groupB'), findsOneWidget);
    expect(find.text('column3'), findsNothing);
    expect(find.text('column4'), findsOneWidget);
  });

  testWidgets('If column5 is hidden, groupC should also be hidden', (tester) async {
    final columns = ColumnHelper.textColumn('column', count: 5, start: 1);

    final rows = RowHelper.count(10, columns);

    final columnGroups = <PlutoColumnGroup>[
      PlutoColumnGroup(title: 'groupA', fields: ['column1', 'column2']),
      PlutoColumnGroup(title: 'groupB', fields: ['column3', 'column4']),
      PlutoColumnGroup(title: 'groupC', fields: ['column5']),
    ];

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    expect(find.text('groupC'), findsOneWidget);
    stateManager.hideColumn(columns[4], true);
    await tester.pumpAndSettle();

    expect(find.text('groupC'), findsNothing);
  });
}
