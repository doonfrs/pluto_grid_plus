import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../../helper/column_helper.dart';
import '../../../helper/row_helper.dart';
import '../../../mock/mock_methods.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  final PlutoGridScrollController scroll = MockPlutoGridScrollController();
  final LinkedScrollControllerGroup horizontal =
      MockLinkedScrollControllerGroup();
  final ScrollController scrollController = MockScrollController();
  final ScrollPosition scrollPosition = MockScrollPosition();
  final PlutoGridEventManager eventManager = MockPlutoGridEventManager();

  when(scroll.horizontal).thenReturn(horizontal);
  when(scroll.horizontalOffset).thenReturn(0);
  when(scroll.maxScrollHorizontal).thenReturn(0);
  when(scroll.bodyRowsHorizontal).thenReturn(scrollController);
  when(scrollController.hasClients).thenReturn(true);
  when(scrollController.offset).thenReturn(0);
  when(scrollController.position).thenReturn(scrollPosition);
  when(scrollPosition.viewportDimension).thenReturn(0.0);
  when(scrollPosition.hasViewportDimension).thenReturn(true);

  PlutoGridStateManager getStateManager({
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    required FocusNode? gridFocusNode,
    required PlutoGridScrollController scroll,
    List<PlutoColumnGroup>? columnGroups,
    PlutoGridConfiguration configuration = const PlutoGridConfiguration(),
  }) {
    return PlutoGridStateManager(
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
      gridFocusNode: MockFocusNode(),
      scroll: scroll,
      configuration: configuration,
    )..setEventManager(eventManager);
  }

  testWidgets('columnIndexes - columns should return the index list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.columnIndexes;

    // then
    expect(result.length, 3);
    expect(result, [0, 1, 2]);
  });

  testWidgets(
      'columnIndexesForShowFrozen - frozen columns should return the index list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.columnIndexesForShowFrozen;

    // then
    expect(result.length, 3);
    expect(result, [2, 1, 0]);
  });

  testWidgets('columnsWidth - columns should return the sum of column widths.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          width: 150,
        ),
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          width: 200,
        ),
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          width: 250,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.columnsWidth;

    // then
    expect(result, 600);
  });

  testWidgets('leftFrozenColumns - left frozen columns should return the list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'left1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'left2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<PlutoColumn> result = stateManager.leftFrozenColumns;

    // then
    expect(result.length, 2);
    expect(result[0].title, 'left1');
    expect(result[1].title, 'left2');
  });

  testWidgets(
      'leftFrozenColumnIndexes - left frozen column indexes should return the list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'left2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.leftFrozenColumnIndexes;

    // then
    expect(result.length, 1);
    expect(result[0], 2);
  });

  testWidgets(
      'leftFrozenColumnsWidth - left frozen columns width should return the sum of column widths.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        PlutoColumn(
          title: 'body',
          field: '',
          type: PlutoColumnType.text(),
          width: 150,
        ),
        PlutoColumn(
          title: 'left2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.leftFrozenColumnsWidth;

    // then
    expect(result, 300);
  });

  testWidgets(
      'rightFrozenColumns - right frozen columns should return the list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'left1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<PlutoColumn> result = stateManager.rightFrozenColumns;

    // then
    expect(result.length, 1);
    expect(result[0].title, 'right1');
  });

  testWidgets(
      'rightFrozenColumnIndexes - right frozen column indexes should return the list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
        PlutoColumn(title: 'body', field: '', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'right2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.rightFrozenColumnIndexes;

    // then
    expect(result.length, 2);
    expect(result[0], 0);
    expect(result[1], 2);
  });

  testWidgets(
      'rightFrozenColumnsWidth - right frozen columns width should return the sum of column widths.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        PlutoColumn(
          title: 'right1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 120,
        ),
        PlutoColumn(
          title: 'right2',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 120,
        ),
        PlutoColumn(
          title: 'body',
          field: '',
          type: PlutoColumnType.text(),
          width: 100,
        ),
        PlutoColumn(
          title: 'left1',
          field: '',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 120,
        ),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.rightFrozenColumnsWidth;

    // then
    expect(result, 240);
  });

  testWidgets('bodyColumns - body columns should return the list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    stateManager.setLayout(const BoxConstraints(maxWidth: 1800));

    // when
    final List<PlutoColumn> result = stateManager.bodyColumns;

    // then
    expect(result.length, 3);
    expect(result[0].title, 'body0');
    expect(result[1].title, 'body1');
    expect(result[2].title, 'body2');
  });

  testWidgets('bodyColumnIndexes - body column indexes should return the list.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final List<int> result = stateManager.bodyColumnIndexes;

    // then
    expect(result.length, 3);
    expect(result[0], 3);
    expect(result[1], 4);
    expect(result[2], 5);
  });

  testWidgets(
      'bodyColumnsWidth - body columns width should return the sum of column widths.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    final double result = stateManager.bodyColumnsWidth;

    // then
    expect(result, 450);
  });

  testWidgets('When currentColumnField is null, return null.',
      (WidgetTester tester) async {
    // given
    PlutoGridStateManager stateManager = getStateManager(
      columns: [
        ...ColumnHelper.textColumn('left',
            count: 3, frozen: PlutoColumnFrozen.start),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, frozen: PlutoColumnFrozen.end),
      ],
      rows: [],
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    PlutoColumn? currentColumn = stateManager.currentColumn;

    // when
    expect(currentColumn, null);
  });

  testWidgets('currentColumn - currentCell is selected, return currentColumn',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('left',
          count: 3, frozen: PlutoColumnFrozen.start),
      ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ...ColumnHelper.textColumn('right',
          count: 3, frozen: PlutoColumnFrozen.end),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager stateManager = getStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: null,
      scroll: scroll,
    );

    stateManager.setLayout(
      const BoxConstraints(maxWidth: 1000, maxHeight: 600),
    );

    // when
    String selectColumnField = 'body2';
    stateManager.setCurrentCell(rows[2].cells[selectColumnField], 2);

    PlutoColumn currentColumn = stateManager.currentColumn!;

    // when
    expect(currentColumn, isNot(null));
    expect(currentColumn.field, selectColumnField);
    expect(currentColumn.width, 150);
  });

  testWidgets(
      'currentColumnField - currentCell is not selected, null should be returned',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('left',
          count: 3, frozen: PlutoColumnFrozen.start),
      ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ...ColumnHelper.textColumn('right',
          count: 3, frozen: PlutoColumnFrozen.end),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager stateManager = getStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: null,
      scroll: scroll,
    );

    // when
    String? currentColumnField = stateManager.currentColumnField;

    // when
    expect(currentColumnField, null);
  });

  testWidgets(
      'currentColumnField - currentCell is selected, return the field of the selected column',
      (WidgetTester tester) async {
    // given
    List<PlutoColumn> columns = [
      ...ColumnHelper.textColumn('left',
          count: 3, frozen: PlutoColumnFrozen.start),
      ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ...ColumnHelper.textColumn('right',
          count: 3, frozen: PlutoColumnFrozen.end),
    ];

    List<PlutoRow> rows = RowHelper.count(10, columns);

    PlutoGridStateManager stateManager = getStateManager(
      columns: columns,
      rows: rows,
      gridFocusNode: null,
      scroll: scroll,
    );

    stateManager.setLayout(const BoxConstraints());

    // when
    String selectColumnField = 'body1';
    stateManager.setCurrentCell(rows[2].cells[selectColumnField], 2);

    String? currentColumnField = stateManager.currentColumnField;

    // when
    expect(currentColumnField, isNot(null));
    expect(currentColumnField, selectColumnField);
  });

  group('getSortedColumn', () {
    test('If there is no sort column, return null', () {
      final columns = ColumnHelper.textColumn('title', count: 3);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.getSortedColumn, null);
    });

    test('When there is a sort column, return the sorted column.', () {
      final columns = ColumnHelper.textColumn('title', count: 3);
      columns[1].sort = PlutoColumnSort.ascending;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.getSortedColumn!.key, columns[1].key);
    });
  });

  group('columnIndexesByShowFrozen', () {
    testWidgets(
        'If there are no frozen columns, '
        'columnIndexes should be returned.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints());

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 2]);
    });

    testWidgets(
        'If there are no frozen columns, '
        '3rd column toggle left frozen and '
        'If the width is sufficient, '
        'columnIndexesForShowFrozen should be returned.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('body', count: 5, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 1000, maxHeight: 600),
      );

      // when
      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 1000, maxHeight: 600),
      );

      // then
      expect(stateManager.showFrozenColumn, true);
      expect(stateManager.columnIndexesByShowFrozen, [2, 0, 1, 3, 4]);
    });

    testWidgets(
        'If there are no frozen columns, '
        '3rd column toggle left frozen and '
        'If the width is insufficient, '
        'columnIndexes should be returned.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('body', count: 5, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 300, maxHeight: 600),
      );

      // when
      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 300, maxHeight: 600),
      );

      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 2, 3, 4]);
    });

    testWidgets(
        'If there are frozen columns, '
        'If the width is sufficient, '
        'columnIndexes should be returned.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager
          .setLayout(const BoxConstraints(maxWidth: 500, maxHeight: 600));

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 2, 3, 4]);
    });

    testWidgets(
        'If there are frozen columns, '
        'If one frozen column is toggled to the left, '
        'If the width is sufficient, '
        'columnIndexesForShowFrozen should be returned.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.start);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 2, 1, 3, 4]);
    });

    testWidgets(
        'If there are frozen columns, '
        'If one frozen column is toggled to the right, '
        'If the width is sufficient, '
        'columnIndexesForShowFrozen should be returned.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      stateManager.toggleFrozenColumn(columns[2], PlutoColumnFrozen.end);

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 700, maxHeight: 600),
      );

      // when
      // then
      expect(stateManager.columnIndexesByShowFrozen, [0, 1, 3, 2, 4]);
    });
  });

  testWidgets(
    'If there are frozen columns, '
    'If one frozen column is toggled to the right, '
    'If the width is sufficient, '
    'columnIndexesForShowFrozen should be returned.',
    (WidgetTester tester) async {
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      // 150 + 200 + 150 = minimum width 500
      stateManager
          .setLayout(const BoxConstraints(maxWidth: 550, maxHeight: 600));

      expect(stateManager.showFrozenColumn, true);
      expect(columns.first.width, 150);

      // When the width is 550, the columns and cells should be displayed in the correct width.
      stateManager.resizeColumn(columns.first, 60);

      expect(stateManager.showFrozenColumn, true);
      expect(columns.first.width, 150);
    },
  );

  testWidgets(
    'If there are frozen columns, '
    'If one frozen column is toggled to the right, '
    'If the width is insufficient, '
    'columnIndexesForShowFrozen should be returned.',
    (WidgetTester tester) async {
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn(
          'left',
          count: 1,
          frozen: PlutoColumnFrozen.start,
          width: 150,
        ),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn(
          'right',
          count: 1,
          frozen: PlutoColumnFrozen.end,
          width: 150,
        ),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      // 150 + 200 + 150 = 최소 500 필요
      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.showFrozenColumn, false);
      expect(stateManager.columns[0].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[1].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[2].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[3].frozen, PlutoColumnFrozen.none);
      expect(stateManager.columns[4].frozen, PlutoColumnFrozen.none);
    },
  );

  group('toggleFrozenColumn', () {
    test(
        'columnSizeConfig.restoreAutoSizeAfterFrozenColumn is false, '
        'activatedColumnsAutoSize should be false.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterFrozenColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.toggleFrozenColumn(columns.first, PlutoColumnFrozen.start);

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('insertColumns', () {
    testWidgets(
      'When there are no columns, a column should be added at index 0',
      (WidgetTester tester) async {
        const columnIdxToInsert = 0;

        final List<PlutoColumn> columnsToInsert = ColumnHelper.textColumn(
          'column',
          count: 1,
        );

        final List<PlutoColumn> columns = [];

        final List<PlutoRow> rows = [];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.insertColumns(columnIdxToInsert, columnsToInsert);

        expect(stateManager.refColumns.length, 1);
      },
    );

    testWidgets(
      'When there is one column, a column should be added at index 0',
      (WidgetTester tester) async {
        const columnIdxToInsert = 0;

        final List<PlutoColumn> columnsToInsert = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 1,
        );

        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 0,
        );

        final List<PlutoRow> rows = [];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.insertColumns(columnIdxToInsert, columnsToInsert);

        expect(stateManager.refColumns.length, 2);

        expect(stateManager.refColumns[0].key, columnsToInsert[0].key);
      },
    );

    testWidgets(
      'When there is one column, the cell of the inserted column should be added to the row',
      (WidgetTester tester) async {
        const columnIdxToInsert = 0;

        const defaultValue = 'inserted column';

        final List<PlutoColumn> columnsToInsert = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 1,
          defaultValue: defaultValue,
        );

        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 1,
          start: 0,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.insertColumns(columnIdxToInsert, columnsToInsert);

        expect(
          stateManager.refRows[0].cells['column1']!.value,
          defaultValue,
        );

        expect(
          stateManager.refRows[1].cells['column1']!.value,
          defaultValue,
        );
      },
    );

    test(
        'When columnSizeConfig.restoreAutoSizeAfterInsertColumn is false, '
        'activatedColumnsAutoSize should be false after inserting a column',
        () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterInsertColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.insertColumns(0, ColumnHelper.textColumn('title'));

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('removeColumns', () {
    testWidgets(
      'When the 0th column is deleted, the column should be removed',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.refColumns.length, 9);
      },
    );

    testWidgets(
      'When the 0th column is deleted, the cells of that column should be removed',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        expect(stateManager.refRows[0].cells.entries.length, 10);

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.refRows[0].cells.entries.length, 9);
      },
    );

    testWidgets(
      'When the 8th column is deleted, the cells of that column should be removed',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        expect(stateManager.refRows[0].cells.entries.length, 10);

        stateManager.removeColumns([columns[8], columns[9]]);

        expect(stateManager.refRows[0].cells.entries.length, 8);
      },
    );

    testWidgets(
      'When there is a column group, deleting a column should remove the empty group',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoColumnGroup> columnGroups = [
          PlutoColumnGroup(title: 'a', fields: ['column0']),
          PlutoColumnGroup(
              title: 'b',
              fields: columns
                  .where((element) => element.field != 'column0')
                  .map((e) => e.field)
                  .toList()),
        ];

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          columnGroups: columnGroups,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.columnGroups.length, 1);

        expect(stateManager.columnGroups[0].title, 'b');
      },
    );

    testWidgets(
      'When there is a column group, deleting a column should remove the column from the group',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoColumnGroup> columnGroups = [
          PlutoColumnGroup(title: 'a', fields: ['column0']),
          PlutoColumnGroup(
              title: 'b',
              fields: columns
                  .where((element) => element.field != 'column0')
                  .map((e) => e.field)
                  .toList()),
        ];

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          columnGroups: columnGroups,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.removeColumns([columns[1]]);

        expect(stateManager.columnGroups.length, 2);

        expect(
          stateManager.columnGroups[1].fields!.contains('column1'),
          false,
        );

        expect(stateManager.columnGroups[1].fields!.length, 8);
      },
    );

    testWidgets(
      'When there is a column group with sub groups, deleting a column should remove the empty sub group',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoColumnGroup> columnGroups = [
          PlutoColumnGroup(title: 'a', fields: ['column0']),
          PlutoColumnGroup(
            title: 'b',
            children: [
              PlutoColumnGroup(title: 'c', fields: ['column1']),
              PlutoColumnGroup(
                  title: 'd',
                  fields: columns
                      .where((element) =>
                          !['column0', 'column1'].contains(element.field))
                      .map((e) => e.field)
                      .toList()),
            ],
          ),
        ];

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          columnGroups: columnGroups,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        expect(stateManager.columnGroups[1].children!.length, 2);

        stateManager.removeColumns([columns[1]]);

        expect(stateManager.columnGroups[1].children!.length, 1);

        expect(stateManager.columnGroups[1].children![0].title, 'd');
      },
    );

    testWidgets(
      'When a column with a filter is deleted, the filter should be removed',
      (WidgetTester tester) async {
        final List<PlutoColumn> columns = ColumnHelper.textColumn(
          'column',
          count: 10,
        );

        final List<PlutoRow> rows = RowHelper.count(2, columns);

        final List<PlutoRow> filterRows = [
          FilterHelper.createFilterRow(
            columnField: columns[0].field,
            filterType: const PlutoFilterTypeContains(),
            filterValue: 'filter',
          ),
          FilterHelper.createFilterRow(
            columnField: columns[0].field,
            filterType: const PlutoFilterTypeContains(),
            filterValue: 'filter',
          ),
        ];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.setFilterWithFilterRows(filterRows);

        expect(stateManager.filterRows.length, 2);

        stateManager.removeColumns([columns[0]]);

        expect(stateManager.filterRows.length, 0);
      },
    );

    test(
        'columnSizeConfig.restoreAutoSizeAfterRemoveColumn is false, '
        'activatedColumnsAutoSize should be false.', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterRemoveColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.removeColumns([columns.first]);

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('moveColumn', () {
    test(
        'If the column movement is not possible due to frozen column limit, notifyListeners should not be called.',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      final listeners = MockMethods();

      stateManager.addListener(listeners.noParamReturnVoid);

      final column = columns[0];

      final targetColumn = columns[1]..frozen = PlutoColumnFrozen.start;

      stateManager.moveColumn(
        column: column,
        targetColumn: targetColumn,
      );

      verifyNever(listeners.noParamReturnVoid());
    });

    test(
        'When the frozen column width is sufficient, notifyListeners should be called',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      final listeners = MockMethods();

      stateManager.addListener(listeners.noParamReturnVoid);

      final column = columns[0]..width = 50;

      final targetColumn = columns[1]..frozen = PlutoColumnFrozen.start;

      stateManager.moveColumn(
        column: column,
        targetColumn: targetColumn,
      );

      verify(listeners.noParamReturnVoid()).called(1);
    });

    test(
        'When the 0th column is moved to the 4th right frozen column, the column order should be changed',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.none;
      columns[2].frozen = PlutoColumnFrozen.start;
      columns[3].frozen = PlutoColumnFrozen.start;
      columns[4].frozen = PlutoColumnFrozen.end;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[0],
        targetColumn: columns[4],
      );

      expect(stateManager.refColumns[0].title, 'title1');
      expect(stateManager.refColumns[1].title, 'title2');
      expect(stateManager.refColumns[2].title, 'title3');
      expect(stateManager.refColumns[3].title, 'title4');
      expect(stateManager.refColumns[4].title, 'title0');
    });

    test(
        'When the 4th column is moved to the 1st left frozen column, the column order should be changed',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.start;
      columns[2].frozen = PlutoColumnFrozen.none;
      columns[3].frozen = PlutoColumnFrozen.none;
      columns[4].frozen = PlutoColumnFrozen.none;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[4],
        targetColumn: columns[1],
      );

      expect(stateManager.refColumns[0].title, 'title0');
      expect(stateManager.refColumns[1].title, 'title4');
      expect(stateManager.refColumns[2].title, 'title1');
      expect(stateManager.refColumns[3].title, 'title2');
      expect(stateManager.refColumns[4].title, 'title3');
    });

    test(
        'When the 3rd left frozen column is moved to the 1st non-frozen column, the column order should be changed',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.none;
      columns[2].frozen = PlutoColumnFrozen.none;
      columns[3].frozen = PlutoColumnFrozen.start;
      columns[4].frozen = PlutoColumnFrozen.none;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[3],
        targetColumn: columns[1],
      );

      // 3rd is left frozen and is to the right of 1st.
      // When the 3rd column moves to the right of the 1st column,
      // the 3rd column will be removed from the left of the 1st column.
      expect(stateManager.refColumns[0].title, 'title0');
      expect(stateManager.refColumns[1].title, 'title1');
      expect(stateManager.refColumns[2].title, 'title3');
      expect(stateManager.refColumns[3].title, 'title2');
      expect(stateManager.refColumns[4].title, 'title4');
    });

    test(
        'When the 1st right frozen column is moved to the 4th non-frozen column, the column order should be changed',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      columns[0].frozen = PlutoColumnFrozen.none;
      columns[1].frozen = PlutoColumnFrozen.end;
      columns[2].frozen = PlutoColumnFrozen.none;
      columns[3].frozen = PlutoColumnFrozen.none;
      columns[4].frozen = PlutoColumnFrozen.none;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 1200));

      stateManager.moveColumn(
        column: columns[1],
        targetColumn: columns[4],
      );

      // 1st is right frozen and is to the right of 4th.
      // When the 1st column moves to the right of the 4th column,
      // the 1st column will be removed from the left of the 4th column.
      expect(stateManager.refColumns[0].title, 'title0');
      expect(stateManager.refColumns[1].title, 'title2');
      expect(stateManager.refColumns[2].title, 'title3');
      expect(stateManager.refColumns[3].title, 'title1');
      expect(stateManager.refColumns[4].title, 'title4');
    });

    test(
        'When columnSizeConfig.restoreAutoSizeAfterMoveColumn is false, '
        'activatedColumnsAutoSize should be false after moving a column', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
            restoreAutoSizeAfterMoveColumn: false,
          ),
        ),
      );

      stateManager.setLayout(
        const BoxConstraints(maxWidth: 450, maxHeight: 600),
      );

      expect(stateManager.activatedColumnsAutoSize, true);

      stateManager.moveColumn(
        column: columns.first,
        targetColumn: columns.last,
      );

      expect(stateManager.activatedColumnsAutoSize, false);
    });
  });

  group('resizeColumn', () {
    test(
        'When columnsResizeMode is none, notifyResizingListeners should not be called',
        () {
      final columns = ColumnHelper.textColumn('title', count: 5);
      final mockListener = MockMethods();

      PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              resizeMode: PlutoResizeMode.none,
            ),
          ));

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.resizingChangeNotifier.addListener(
        mockListener.noParamReturnVoid,
      );

      stateManager.resizeColumn(columns.first, 10);

      verifyNever(mockListener.noParamReturnVoid());

      stateManager.resizingChangeNotifier.removeListener(
        mockListener.noParamReturnVoid,
      );
    });

    test(
        'When column.enableDropToResize is false, notifyResizingListeners should not be called',
        () {
      final columns = ColumnHelper.textColumn('title', count: 5);
      final mockListener = MockMethods();

      PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              resizeMode: PlutoResizeMode.normal,
            ),
          ));

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.resizingChangeNotifier.addListener(
        mockListener.noParamReturnVoid,
      );

      stateManager.resizeColumn(columns.first..enableDropToResize = false, 10);

      verifyNever(mockListener.noParamReturnVoid());

      stateManager.resizingChangeNotifier.removeListener(
        mockListener.noParamReturnVoid,
      );
    });

    test('When offset is 10, the column width should increase', () {
      final columns = ColumnHelper.textColumn('title', count: 5);
      final mockListener = MockMethods();

      PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              resizeMode: PlutoResizeMode.normal,
            ),
          ));

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.resizingChangeNotifier.addListener(
        mockListener.noParamReturnVoid,
      );

      expect(columns.first.width, 200);

      stateManager.resizeColumn(columns.first, 10);

      verify(mockListener.noParamReturnVoid()).called(1);
      expect(columns.first.width, 210);

      stateManager.resizingChangeNotifier.removeListener(
        mockListener.noParamReturnVoid,
      );
    });

    test(
      'When PlutoResizeMode.pushAndPull, scroll.horizontal.notifyListeners should be called',
      () {
        final columns = ColumnHelper.textColumn('title', count: 5);

        PlutoGridStateManager stateManager = getStateManager(
            columns: columns,
            rows: [],
            gridFocusNode: null,
            scroll: scroll,
            configuration: const PlutoGridConfiguration(
              columnSize: PlutoGridColumnSizeConfig(
                resizeMode: PlutoResizeMode.pushAndPull,
              ),
            ));

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        reset(horizontal);

        stateManager.resizeColumn(columns.first, 10);

        verify(horizontal.notifyListeners()).called(1);
      },
    );
  });

  group('autoFitColumn', () {
    testWidgets(
        'When the widest cell is smaller than the column minimum width, '
        'it should be changed to the minimum width', (tester) async {
      final columns = ColumnHelper.textColumn('title');

      final rows = RowHelper.count(3, columns);
      rows[0].cells['title0']!.value = 'a';
      rows[1].cells['title0']!.value = 'ab';
      rows[2].cells['title0']!.value = 'abc';

      late final BuildContext context;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (builderContext) {
                context = builderContext;
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: PlutoBaseColumn(
                    stateManager: stateManager,
                    column: columns.first,
                  ),
                );
              },
            ),
          ),
        ),
      );

      double oldWidth = columns.first.width;
      stateManager.autoFitColumn(context, columns.first);

      expect(columns.first.width, lessThan(oldWidth));
    });

    testWidgets(
        'When the widest cell is larger than the column minimum width, '
        'it should be changed to the minimum width', (tester) async {
      final columns = ColumnHelper.textColumn('title');

      final rows = RowHelper.count(3, columns);
      rows[0].cells['title0']!.value = 'a';
      rows[1].cells['title0']!.value = 'ab';
      rows[2].cells['title0']!.value = 'abc abc abc';

      late final BuildContext context;

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: scroll,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (builderContext) {
                context = builderContext;
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: PlutoBaseColumn(
                    stateManager: stateManager,
                    column: columns.first,
                  ),
                );
              },
            ),
          ),
        ),
      );

      stateManager.autoFitColumn(context, columns.first);

      expect(columns.first.width, greaterThan(columns.first.minWidth));
    });
  });

  group('hideColumn', () {
    testWidgets('When the flag is true, the column hide should be true',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      // when
      expect(stateManager.columns.first.hide, isFalse);

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.hideColumn(columns.first, true);

      // then
      expect(stateManager.refColumns.originalList.first.hide, isTrue);
    });

    testWidgets('When the flag is false, the column hide should be false',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(
          title: '',
          field: '',
          type: PlutoColumnType.text(),
          hide: true,
        ),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      // when
      expect(stateManager.refColumns.originalList.first.hide, isTrue);

      stateManager.hideColumn(columns.first, false);

      // then
      expect(stateManager.columns.first.hide, isFalse);
    });

    testWidgets(
      'When calling hideColumn with flag false on a fixed column with hide true, '
      'if the constraint width of the fixed column is narrow, the column should be unfrozen.',
      (WidgetTester tester) async {
        // given
        var columns = [
          PlutoColumn(
            title: '',
            field: '',
            width: 700,
            type: PlutoColumnType.text(),
            hide: true,
          ),
          PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
          PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        ];

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 800));

        stateManager.columns.first.frozen = PlutoColumnFrozen.start;

        // when
        expect(stateManager.refColumns.originalList.first.hide, isTrue);

        stateManager.hideColumn(columns.first, false);

        // then
        expect(stateManager.columns.first.hide, isFalse);

        expect(stateManager.columns.first.frozen, PlutoColumnFrozen.none);
      },
    );

    testWidgets('If the flag is true, notifyListeners should be called.',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      var listeners = MockMethods();

      stateManager.addListener(listeners.noParamReturnVoid);

      // when
      expect(stateManager.columns.first.hide, isFalse);

      stateManager.hideColumn(columns.first, true);

      // then
      verify(listeners.noParamReturnVoid()).called(1);
    });

    testWidgets('If hide is false, notifyListeners should not be called.',
        (WidgetTester tester) async {
      // given
      var columns = [
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
        PlutoColumn(title: '', field: '', type: PlutoColumnType.text()),
      ];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      var listeners = MockMethods();

      stateManager.addListener(listeners.noParamReturnVoid);

      // when
      expect(stateManager.columns.first.hide, isFalse);

      stateManager.hideColumn(columns.first, false);

      // then
      verifyNever(listeners.noParamReturnVoid());
    });
  });

  group('hideColumns', () {
    test('If columns is empty, notifyListeners should not be called.',
        () async {
      final columns = <PlutoColumn>[];

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      var listeners = MockMethods();

      stateManager.addListener(listeners.noParamReturnVoid);

      stateManager.hideColumns(columns, true);

      verifyNever(listeners.noParamReturnVoid());
    });

    test('If columns is not empty, notifyListeners should be called.',
        () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      var listeners = MockMethods();

      stateManager.addListener(listeners.noParamReturnVoid);

      stateManager.hideColumns(columns, true);

      verify(listeners.noParamReturnVoid()).called(1);
    });

    test('When hide is true, columns should be updated.', () async {
      final columns = ColumnHelper.textColumn('title', count: 5);

      PlutoGridStateManager stateManager = getStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 800));

      stateManager.hideColumns(columns, true);

      final hideList = stateManager.refColumns.originalList.where(
        (element) => element.hide,
      );

      expect(hideList.length, 5);
    });

    test(
      'When hide is false, columns should be updated.',
      () async {
        final columns = ColumnHelper.textColumn('title', count: 5, hide: true);

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 1000));

        stateManager.hideColumns(columns.getRange(0, 2).toList(), false);

        // called columns
        expect(columns[0].hide, false);
        expect(columns[1].hide, false);
        // not called columns
        expect(columns[2].hide, true);
        expect(columns[3].hide, true);
        expect(columns[4].hide, true);
      },
    );

    test(
      'When hide is false, frozen columns should be none.',
      () async {
        final columns = ColumnHelper.textColumn(
          'title',
          count: 5,
          hide: true,
          frozen: PlutoColumnFrozen.start,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: columns,
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 300));

        // Initialize all columns' frozen to none for testing purposes.
        for (final column in columns) {
          column.frozen = PlutoColumnFrozen.start;
        }

        stateManager.hideColumns(columns.getRange(0, 2).toList(), false);

        // called columns
        expect(columns[0].hide, false);
        expect(columns[0].frozen, PlutoColumnFrozen.none);
        expect(columns[1].hide, false);
        expect(columns[1].frozen, PlutoColumnFrozen.none);
        // not called columns
        expect(columns[2].hide, true);
        expect(columns[2].frozen, PlutoColumnFrozen.start);
        expect(columns[3].hide, true);
        expect(columns[3].frozen, PlutoColumnFrozen.start);
        expect(columns[4].hide, true);
        expect(columns[4].frozen, PlutoColumnFrozen.start);
      },
    );
  });

  group('limitResizeColumn', () {
    test('When offset is less than 0, false should be returned.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
      );

      const offset = -1.0;

      PlutoGridStateManager stateManager = getStateManager(
        columns: [column],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.limitResizeColumn(column, offset), false);
    });

    test('When column frozen is none, false should be returned.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.none,
      );

      const offset = 1.0;

      PlutoGridStateManager stateManager = getStateManager(
        columns: [column],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      expect(stateManager.limitResizeColumn(column, offset), false);
    });

    test('When column frozen is start, false should be returned.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        width: 100,
      );

      PlutoGridStateManager stateManager = getStateManager(
        columns: [
          column,
          ...ColumnHelper.textColumn('title', count: 3, width: 100),
        ],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      // The size can be increased by up to 194, which is less than 500 - 306.
      // print(stateManager.maxWidth);
      // One left frozen column of 100
      // print(stateManager.leftFrozenColumnsWidth);
      // No right frozen columns, so 0
      // print(stateManager.rightFrozenColumnsWidth);
      // 200
      // print(PlutoGridSettings.bodyMinWidth);
      // 6
      // print(PlutoGridSettings.totalShadowLineWidth);

      expect(stateManager.limitResizeColumn(column, 193.0), false);
    });

    test('When column frozen is end, false should be returned.', () {
      final PlutoColumn column = PlutoColumn(
        title: 'title',
        field: 'field',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        width: 100,
      );

      PlutoGridStateManager stateManager = getStateManager(
        columns: [
          column,
          ...ColumnHelper.textColumn('title', count: 3, width: 100),
        ],
        rows: [],
        gridFocusNode: null,
        scroll: scroll,
      );

      stateManager.setLayout(const BoxConstraints(maxWidth: 500));

      // The size can be increased by up to 194, which is less than 500 - 306.
      // print(stateManager.maxWidth);
      // One left frozen column of 100
      // print(stateManager.leftFrozenColumnsWidth);
      // No right frozen columns, so 0
      // print(stateManager.rightFrozenColumnsWidth);
      // 200
      // print(PlutoGridSettings.bodyMinWidth);
      // 6
      // print(PlutoGridSettings.totalShadowLineWidth);

      expect(stateManager.limitResizeColumn(column, 194.0), true);
    });
  });

  group('limitMoveColumn', () {
    test(
      'When column frozen is start, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // The size can be increased by up to 194, which is less than 500 - 306.
        // print(stateManager.maxWidth);
        // One left frozen column of 100
        // print(stateManager.leftFrozenColumnsWidth);
        // One right frozen column of 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          false,
        );
      },
    );

    test(
      'When column frozen is none, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // The size can be increased by up to 294, which is less than 500 - 306.
        // print(stateManager.maxWidth);
        // One left frozen column of 100
        // print(stateManager.leftFrozenColumnsWidth);
        // One right frozen column of 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          false,
        );
      },
    );

    test(
      'When column frozen is none, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 100,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // The size can be increased by up to 294, which is less than 500 - 306.
        // print(stateManager.maxWidth);
        // One left frozen column of 100
        // print(stateManager.leftFrozenColumnsWidth);
        // One right frozen column of 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          false,
        );
      },
    );

    test(
      'When column frozen is none, true should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 294,
        );

        final PlutoColumn targetColumn = PlutoColumn(
          title: 'title2',
          field: 'field2',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // The size can be increased by up to 294, which is less than 500 - 306.
        // print(stateManager.maxWidth! - column.width);
        // One left frozen column of 100
        // print(stateManager.leftFrozenColumnsWidth);
        // One right frozen column of 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitMoveColumn(
            column: column,
            targetColumn: targetColumn,
          ),
          true,
        );
      },
    );
  });

  group('limitToggleFrozenColumn', () {
    test(
      'When column frozen is start, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        expect(
          stateManager.limitToggleFrozenColumn(column, PlutoColumnFrozen.none),
          false,
        );
      },
    );

    test(
      'When column frozen is none, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 100,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // The size can be increased by up to 394, which is less than 500 - 206.
        // print(stateManager.maxWidth! - column.width);
        // One left frozen column of 100
        // print(stateManager.leftFrozenColumnsWidth);
        // One right frozen column of 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitToggleFrozenColumn(column, PlutoColumnFrozen.start),
          false,
        );
      },
    );

    test(
      'When column frozen is none, true should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        // The size can be increased by up to 394, which is less than 500 - 206.
        // print(stateManager.maxWidth! - column.width);
        // One left frozen column of 100
        // print(stateManager.leftFrozenColumnsWidth);
        // One right frozen column of 100
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(
          stateManager.limitToggleFrozenColumn(column, PlutoColumnFrozen.start),
          true,
        );
      },
    );
  });

  group('limitHideColumn', () {
    test(
      'When column hidden is true, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.end,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        expect(stateManager.limitHideColumn(column, true), false);
      },
    );

    test(
      'When column frozen is none, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.none,
          hide: true,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));

        expect(stateManager.limitHideColumn(column, false), false);
      },
    );

    test(
      'When column frozen is start, false should be returned.',
      () async {
        final PlutoColumn column = PlutoColumn(
          title: 'title1',
          field: 'field1',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          hide: true,
          width: 394,
        );

        PlutoGridStateManager stateManager = getStateManager(
          columns: [
            column,
            ...ColumnHelper.textColumn('title', count: 3, width: 100),
          ],
          rows: [],
          gridFocusNode: null,
          scroll: scroll,
        );

        stateManager.setLayout(const BoxConstraints(maxWidth: 500));
        // If showFrozenColumn is false in stateManager.setLayout,
        // Force the column's frozen state to none and change it to left.
        column.frozen = PlutoColumnFrozen.start;

        // Column width should be greater than 394 for column unhide.
        // print(stateManager.maxWidth! - column.width);
        // No left frozen column 0
        // print(stateManager.leftFrozenColumnsWidth);
        // No right frozen column 0
        // print(stateManager.rightFrozenColumnsWidth);
        // 200
        // print(PlutoGridSettings.bodyMinWidth);
        // 6
        // print(PlutoGridSettings.totalShadowLineWidth);

        expect(stateManager.limitHideColumn(column, false), true);
      },
    );
  });
}
