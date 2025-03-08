import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';
import '../../helper/test_helper_util.dart';

void main() {
  late PlutoGridStateManager stateManager;
  late List<PlutoColumn> columns;
  late List<PlutoColumnGroup> columnGroups;
  late List<PlutoRow> rows;

  setUp(() {
    columns = ColumnHelper.textColumn('column', count: 5);
    rows = RowHelper.count(10, columns);
    columnGroups = [
      PlutoColumnGroup(title: 'group1', children: [
        PlutoColumnGroup(title: 'group1-1', fields: ['column0', 'column1']),
      ]),
    ];
  });

  Future<void> buildGrid({
    required WidgetTester tester,
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    List<PlutoColumnGroup>? columnGroups,
    bool? showColumnFilter,
  }) async {
    await TestHelperUtil.changeWidth(tester: tester, width: 1200, height: 800);

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoGrid(
            columns: columns,
            columnGroups: columnGroups,
            rows: rows,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;

              if (showColumnFilter == true) {
                stateManager.setShowColumnFilter(true);
              }
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Finder findPlutoBaseColumn(String title) {
    return find.ancestor(
      of: find.text(title),
      matching: find.byType(PlutoBaseColumn),
    );
  }

  testWidgets(
      'When the column group is hidden, the column area height should be changed.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    expect(
      tester.getSize(find.byType(PlutoLeftFrozenColumns)).height,
      stateManager.columnHeight * 3,
    );
    expect(
      tester.getSize(find.byType(PlutoBodyColumns)).height,
      stateManager.columnHeight * 3,
    );
    expect(
      tester.getSize(find.byType(PlutoRightFrozenColumns)).height,
      stateManager.columnHeight * 3,
    );

    stateManager.setShowColumnGroups(false);
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(PlutoLeftFrozenColumns)).height,
      stateManager.columnHeight,
    );
    expect(
      tester.getSize(find.byType(PlutoBodyColumns)).height,
      stateManager.columnHeight,
    );
    expect(
      tester.getSize(find.byType(PlutoRightFrozenColumns)).height,
      stateManager.columnHeight,
    );
  });

  testWidgets(
      'When the column group is hidden, the column group should be removed.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    expect(find.text('group1'), findsOneWidget);
    expect(find.text('group1-1'), findsOneWidget);

    stateManager.setShowColumnGroups(false);
    await tester.pumpAndSettle();

    expect(find.text('group1'), findsNothing);
    expect(find.text('group1-1'), findsNothing);
  });

  testWidgets(
      'When the column group is hidden, the column height should be changed.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    // group columns
    expect(
      tester.getSize(findPlutoBaseColumn('column0')).height,
      stateManager.columnHeight,
    );
    expect(
      tester.getSize(findPlutoBaseColumn('column1')).height,
      stateManager.columnHeight,
    );
    // expanded columns
    expect(
      tester.getSize(findPlutoBaseColumn('column2')).height,
      stateManager.columnHeight * 3,
    );
    expect(
      tester.getSize(findPlutoBaseColumn('column3')).height,
      stateManager.columnHeight * 3,
    );
    expect(
      tester.getSize(findPlutoBaseColumn('column4')).height,
      stateManager.columnHeight * 3,
    );

    stateManager.setShowColumnGroups(false);
    await tester.pumpAndSettle();

    // group columns
    expect(
      tester.getSize(findPlutoBaseColumn('column0')).height,
      stateManager.columnHeight,
    );
    expect(
      tester.getSize(findPlutoBaseColumn('column1')).height,
      stateManager.columnHeight,
    );
    // expanded columns
    expect(
      tester.getSize(findPlutoBaseColumn('column2')).height,
      stateManager.columnHeight,
    );
    expect(
      tester.getSize(findPlutoBaseColumn('column3')).height,
      stateManager.columnHeight,
    );
    expect(
      tester.getSize(findPlutoBaseColumn('column4')).height,
      stateManager.columnHeight,
    );
  });

  testWidgets(
      'When the column group is hidden, the row area height should be changed.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    final changedSize = Size(0, stateManager.columnHeight * 2);

    final leftSize = tester.getSize(find.byType(PlutoLeftFrozenRows));
    final bodySize = tester.getSize(find.byType(PlutoBodyRows));
    final rightSize = tester.getSize(find.byType(PlutoRightFrozenRows));

    stateManager.setShowColumnGroups(false);
    await tester.pumpAndSettle();

    final afterLeftSize = tester.getSize(find.byType(PlutoLeftFrozenRows));
    final afterBodySize = tester.getSize(find.byType(PlutoBodyRows));
    final afterRightSize = tester.getSize(find.byType(PlutoRightFrozenRows));

    expect(afterLeftSize.height - changedSize.height, leftSize.height);
    expect(afterBodySize.height - changedSize.height, bodySize.height);
    expect(afterRightSize.height - changedSize.height, rightSize.height);

    expect(afterLeftSize.width - changedSize.width, leftSize.width);
    expect(afterBodySize.width - changedSize.width, bodySize.width);
    expect(afterRightSize.width - changedSize.width, rightSize.width);
  });

  testWidgets(
      'When the screen size is narrowed, the frozen columns should be removed.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    // 시작 고정 컬럼
    expect(
      tester.getTopLeft(findPlutoBaseColumn('column2')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column0')).dx),
    );
    expect(
      tester.getTopLeft(findPlutoBaseColumn('column0')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column1')).dx),
    );
    expect(
      tester.getTopLeft(findPlutoBaseColumn('column1')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column4')).dx),
    );
    // 끝 고정 컬럼
    expect(
      tester.getTopLeft(findPlutoBaseColumn('column4')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column3')).dx),
    );

    await TestHelperUtil.changeWidth(tester: tester, width: 500, height: 800);
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(findPlutoBaseColumn('column0')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column1')).dx),
    );
    expect(
      tester.getTopLeft(findPlutoBaseColumn('column1')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column2')).dx),
    );

    stateManager.moveScrollByColumn(PlutoMoveDirection.right, 3);
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(findPlutoBaseColumn('column2')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column3')).dx),
    );
    expect(
      tester.getTopLeft(findPlutoBaseColumn('column3')).dx,
      lessThan(tester.getTopLeft(findPlutoBaseColumn('column4')).dx),
    );
  });

  testWidgets('When the column is hidden, the column area height should be 0.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    stateManager.setShowColumnTitle(false);
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(PlutoLeftFrozenColumns)).height, 0);
    expect(tester.getSize(find.byType(PlutoBodyColumns)).height, 0);
    expect(tester.getSize(find.byType(PlutoRightFrozenColumns)).height, 0);
  });

  testWidgets(
      'When the column is hidden, the row area height should be changed.',
      (tester) async {
    columns[2].frozen = PlutoColumnFrozen.start;
    columns[3].frozen = PlutoColumnFrozen.end;

    await buildGrid(
      tester: tester,
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
    );

    final changedSize = Size(0, stateManager.columnHeight * 3);

    final leftSize = tester.getSize(find.byType(PlutoLeftFrozenRows));
    final bodySize = tester.getSize(find.byType(PlutoBodyRows));
    final rightSize = tester.getSize(find.byType(PlutoRightFrozenRows));

    stateManager.setShowColumnTitle(false);
    await tester.pumpAndSettle();

    final afterLeftSize = tester.getSize(find.byType(PlutoLeftFrozenRows));
    final afterBodySize = tester.getSize(find.byType(PlutoBodyRows));
    final afterRightSize = tester.getSize(find.byType(PlutoRightFrozenRows));

    expect(afterLeftSize.height - changedSize.height, leftSize.height);
    expect(afterBodySize.height - changedSize.height, bodySize.height);
    expect(afterRightSize.height - changedSize.height, rightSize.height);

    expect(afterLeftSize.width - changedSize.width, leftSize.width);
    expect(afterBodySize.width - changedSize.width, bodySize.width);
    expect(afterRightSize.width - changedSize.width, rightSize.width);
  });
}
