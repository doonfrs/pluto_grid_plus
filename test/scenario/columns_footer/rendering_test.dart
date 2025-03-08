import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';
import '../../helper/test_helper_util.dart';

void main() {
  late PlutoGridStateManager stateManager;

  buildGrid({
    required WidgetTester tester,
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
  }) async {
    await TestHelperUtil.changeWidth(tester: tester, width: 1200, height: 800);

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

    await tester.pumpAndSettle();
  }

  testWidgets(
    'When footerRenderer is not set, column footer widgets should not be rendered',
    (tester) async {
      final columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 2,
          frozen: PlutoColumnFrozen.start,
        ),
        ...ColumnHelper.textColumn(
          'body',
          count: 2,
        ),
        ...ColumnHelper.textColumn(
          'right',
          count: 2,
          frozen: PlutoColumnFrozen.end,
        ),
      ];

      final rows = RowHelper.count(3, columns);

      await buildGrid(tester: tester, columns: columns, rows: rows);

      expect(find.byType(PlutoLeftFrozenColumnsFooter), findsNothing);
      expect(find.byType(PlutoBodyColumnsFooter), findsNothing);
      expect(find.byType(PlutoRightFrozenColumnsFooter), findsNothing);
      expect(find.byType(PlutoBaseColumnFooter), findsNothing);
    },
  );

  testWidgets(
    'When footerRenderer is not set, setShowColumnFooter is called with true, '
    'column footer widgets should be rendered.',
    (tester) async {
      final columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 2,
          frozen: PlutoColumnFrozen.start,
        ),
        ...ColumnHelper.textColumn(
          'body',
          count: 2,
        ),
        ...ColumnHelper.textColumn(
          'right',
          count: 2,
          frozen: PlutoColumnFrozen.end,
        ),
      ];

      final rows = RowHelper.count(3, columns);

      await buildGrid(tester: tester, columns: columns, rows: rows);

      stateManager.setShowColumnFooter(true);

      await tester.pumpAndSettle();

      expect(find.byType(PlutoLeftFrozenColumnsFooter), findsOneWidget);
      expect(find.byType(PlutoBodyColumnsFooter), findsOneWidget);
      expect(find.byType(PlutoRightFrozenColumnsFooter), findsOneWidget);
      expect(find.byType(PlutoBaseColumnFooter), findsNWidgets(6));
    },
  );

  testWidgets(
    'When footerRenderer is set, column footer widgets should be rendered',
    (tester) async {
      final columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 2,
          frozen: PlutoColumnFrozen.start,
          footerRenderer: (ctx) => Text(ctx.column.title),
        ),
        ...ColumnHelper.textColumn(
          'body',
          count: 2,
        ),
        ...ColumnHelper.textColumn(
          'right',
          count: 2,
          frozen: PlutoColumnFrozen.end,
        ),
      ];

      final rows = RowHelper.count(3, columns);

      await buildGrid(tester: tester, columns: columns, rows: rows);

      expect(find.byType(PlutoLeftFrozenColumnsFooter), findsOneWidget);
      expect(find.byType(PlutoBodyColumnsFooter), findsOneWidget);
      expect(find.byType(PlutoRightFrozenColumnsFooter), findsOneWidget);
      expect(find.byType(PlutoBaseColumnFooter), findsNWidgets(6));
    },
  );
}
