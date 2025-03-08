import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../../helper/column_helper.dart';
import '../../../helper/row_helper.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  PlutoGridStateManager createStateManager({
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    FocusNode? gridFocusNode,
    PlutoGridScrollController? scroll,
    BoxConstraints? layout,
    PlutoGridConfiguration configuration = const PlutoGridConfiguration(),
  }) {
    final stateManager = PlutoGridStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: gridFocusNode ?? MockFocusNode(),
      scroll: scroll ?? MockPlutoGridScrollController(),
      configuration: configuration,
    );

    stateManager.setEventManager(MockPlutoGridEventManager());

    if (layout != null) {
      stateManager.setLayout(layout);
    }

    return stateManager;
  }

  group('When there are frozen columns, needMovingScroll', () {
    late PlutoGridStateManager stateManager;

    List<PlutoColumn> columns;

    List<PlutoRow> rows;

    setUp(() {
      columns = [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ];

      rows = RowHelper.count(10, columns);

      stateManager = createStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
        layout: const BoxConstraints(maxWidth: 300, maxHeight: 500),
      );

      stateManager.setGridGlobalOffset(Offset.zero);
    });

    testWidgets(
      'When scroll offset.dx is less than bodyLeftScrollOffset'
      'but selectingMode is None, should return false.',
      (WidgetTester tester) async {
        stateManager.setSelectingMode(PlutoGridSelectingMode.none);

        expect(stateManager.selectingMode.isNone, true);

        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyLeftScrollOffset - 1, 0),
            PlutoMoveDirection.left,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is less than bodyLeftScrollOffset, should return true.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyLeftScrollOffset - 1, 0),
            PlutoMoveDirection.left,
          ),
          true,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is equal to bodyLeftScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyLeftScrollOffset, 0),
            PlutoMoveDirection.left,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is greater than bodyLeftScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyLeftScrollOffset + 1, 0),
            PlutoMoveDirection.left,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is greater than bodyRightScrollOffset'
      'but selectingMode is None, should return false.',
      (WidgetTester tester) async {
        stateManager.setSelectingMode(PlutoGridSelectingMode.none);

        expect(stateManager.selectingMode.isNone, true);

        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyRightScrollOffset + 1, 0),
            PlutoMoveDirection.right,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is greater than bodyRightScrollOffset, should return true.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyRightScrollOffset + 1, 0),
            PlutoMoveDirection.right,
          ),
          true,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is equal to bodyRightScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyRightScrollOffset, 0),
            PlutoMoveDirection.right,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dx is less than bodyRightScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(stateManager.bodyRightScrollOffset - 1, 0),
            PlutoMoveDirection.right,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dy is less than bodyUpScrollOffset, should return true.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(0, stateManager.bodyUpScrollOffset - 1),
            PlutoMoveDirection.up,
          ),
          true,
        );
      },
    );

    testWidgets(
      'When scroll offset.dy is equal to bodyUpScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(0, stateManager.bodyUpScrollOffset),
            PlutoMoveDirection.up,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dy is greater than bodyUpScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(0, stateManager.bodyUpScrollOffset + 1),
            PlutoMoveDirection.up,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dy is greater than bodyDownScrollOffset, should return true.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(0, stateManager.bodyDownScrollOffset + 1),
            PlutoMoveDirection.down,
          ),
          true,
        );
      },
    );

    testWidgets(
      'When scroll offset.dy is equal to bodyDownScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(0, stateManager.bodyDownScrollOffset),
            PlutoMoveDirection.down,
          ),
          false,
        );
      },
    );

    testWidgets(
      'When scroll offset.dy is less than bodyDownScrollOffset, should return false.',
      (WidgetTester tester) async {
        expect(
          stateManager.needMovingScroll(
            Offset(0, stateManager.bodyDownScrollOffset - 1),
            PlutoMoveDirection.down,
          ),
          false,
        );
      },
    );
  });
}
