import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helper/pluto_widget_test_helper.dart';
import '../../../helper/test_helper_util.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  late MockPlutoGridStateManager stateManager;
  late MockPlutoGridScrollController scroll;
  late MockLinkedScrollControllerGroup horizontalScroll;
  late MockScrollController horizontalScrollController;
  late PublishSubject<PlutoNotifierEvent> subject;
  late PlutoGridEventManager eventManager;
  late PlutoGridConfiguration configuration;

  const ValueKey<String> sortableGestureKey = ValueKey(
    'ColumnTitleSortableGesture',
  );

  setUp(() {
    stateManager = MockPlutoGridStateManager();
    scroll = MockPlutoGridScrollController();
    horizontalScroll = MockLinkedScrollControllerGroup();
    horizontalScrollController = MockScrollController();
    subject = PublishSubject<PlutoNotifierEvent>();
    eventManager = PlutoGridEventManager(stateManager: stateManager);
    configuration = const PlutoGridConfiguration();

    when(stateManager.configuration).thenReturn(configuration);
    when(stateManager.columnMenuDelegate).thenReturn(
      const PlutoColumnMenuDelegateDefault(),
    );
    when(stateManager.style).thenReturn(configuration.style);
    when(stateManager.eventManager).thenReturn(eventManager);
    when(stateManager.streamNotifier).thenAnswer((_) => subject);
    when(stateManager.localeText).thenReturn(const PlutoGridLocaleText());
    when(stateManager.hasCheckedRow).thenReturn(false);
    when(stateManager.hasUnCheckedRow).thenReturn(false);
    when(stateManager.hasFilter).thenReturn(false);
    when(stateManager.columnHeight).thenReturn(45);
    when(stateManager.isHorizontalOverScrolled).thenReturn(false);
    when(stateManager.correctHorizontalOffset).thenReturn(0);
    when(stateManager.scroll).thenReturn(scroll);
    when(stateManager.maxWidth).thenReturn(1000);
    when(stateManager.textDirection).thenReturn(TextDirection.ltr);
    when(stateManager.isRTL).thenReturn(false);
    when(stateManager.isLTR).thenReturn(true);
    when(stateManager.enoughFrozenColumnsWidth(any)).thenReturn(true);
    when(scroll.maxScrollHorizontal).thenReturn(0);
    when(scroll.horizontal).thenReturn(horizontalScroll);
    when(scroll.bodyRowsHorizontal).thenReturn(horizontalScrollController);
    when(horizontalScrollController.offset).thenReturn(0);
    when(horizontalScroll.offset).thenReturn(0);
    when(stateManager.isFilteredColumn(any)).thenReturn(false);
  });

  tearDown(() {
    subject.close();
  });

  MaterialApp buildApp({
    required PlutoColumn column,
  }) {
    return MaterialApp(
      home: Material(
        child: PlutoColumnTitle(
          stateManager: stateManager,
          column: column,
        ),
      ),
    );
  }

  testWidgets('Column title should be displayed', (WidgetTester tester) async {
    // given
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
    );

    // when
    await tester.pumpWidget(
      buildApp(column: column),
    );

    // then
    expect(find.text('column title'), findsOneWidget);
  });

  testWidgets('ColumnIcon should be displayed', (WidgetTester tester) async {
    // given
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
    );

    // when
    await tester.pumpWidget(
      buildApp(column: column),
    );

    // then
    expect(find.byType(PlutoGridColumnIcon), findsOneWidget);
  });

  testWidgets(
      'When enableSorting is true (default), '
      'tapping title should call toggleSortColumn function',
      (WidgetTester tester) async {
    // given
    final PlutoColumn column = PlutoColumn(
      title: 'header',
      field: 'header',
      type: PlutoColumnType.text(),
    );

    // when
    await tester.pumpWidget(
      buildApp(column: column),
    );

    await tester.tap(find.byKey(sortableGestureKey));

    // then
    verify(stateManager.toggleSortColumn(captureAny)).called(1);
  });

  testWidgets(
      'When enableSorting is false, '
      'GestureDetector widget should not exist',
      (WidgetTester tester) async {
    // given
    final PlutoColumn column = PlutoColumn(
      title: 'header',
      field: 'header',
      type: PlutoColumnType.text(),
      enableSorting: false,
    );

    // when
    await tester.pumpWidget(
      buildApp(column: column),
    );

    Finder gestureDetector = find.byKey(sortableGestureKey);

    // then
    expect(gestureDetector, findsNothing);

    verifyNever(stateManager.toggleSortColumn(captureAny));
  });

  testWidgets(
      'WHEN Column has enableDraggable false '
      'THEN Draggable should not be visible',
      (WidgetTester tester) async {
    // given
    final PlutoColumn column = PlutoColumn(
      title: 'header',
      field: 'header',
      type: PlutoColumnType.text(),
      enableColumnDrag: false,
    );

    // when
    await tester.pumpWidget(
      buildApp(column: column),
    );

    // then
    final draggable = find.byType(Draggable);

    expect(draggable, findsNothing);
  });

  testWidgets(
      'WHEN Column has enableDraggable true '
      'THEN Draggable should be visible',
      (WidgetTester tester) async {
    // given
    final PlutoColumn column = PlutoColumn(
      title: 'header',
      field: 'header',
      type: PlutoColumnType.text(),
      enableColumnDrag: true,
    );

    // when
    await tester.pumpWidget(
      buildApp(column: column),
    );

    // then
    final draggable = find.byType(
      TestHelperUtil.typeOf<Draggable<PlutoColumn>>(),
    );

    expect(draggable, findsOneWidget);
  });

  testWidgets(
    'When enableContextMenu is false and enableDropToResize is false, '
    'ColumnIcon should not be displayed',
    (WidgetTester tester) async {
      // given
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        enableContextMenu: false,
        enableDropToResize: false,
      );

      // when
      await tester.pumpWidget(
        buildApp(column: column),
      );

      // then
      expect(find.byType(PlutoGridColumnIcon), findsNothing);
    },
  );

  testWidgets(
    'When enableContextMenu is true and enableDropToResize is true, '
    'ColumnIcon should be displayed',
    (WidgetTester tester) async {
      // given
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        enableContextMenu: true,
        enableDropToResize: true,
      );

      // when
      await tester.pumpWidget(
        buildApp(column: column),
      );

      final found = find.byType(PlutoGridColumnIcon);

      final foundWidget = found.evaluate().first.widget as PlutoGridColumnIcon;

      // then
      expect(found, findsOneWidget);
      expect(foundWidget.icon, configuration.style.columnContextIcon);
    },
  );

  testWidgets(
    'When enableContextMenu is true and enableDropToResize is false, '
    'ColumnIcon should be displayed',
    (WidgetTester tester) async {
      // given
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        enableContextMenu: true,
        enableDropToResize: false,
      );

      // when
      await tester.pumpWidget(
        buildApp(column: column),
      );

      // then
      final found = find.byType(PlutoGridColumnIcon);

      final foundWidget = found.evaluate().first.widget as PlutoGridColumnIcon;

      // then
      expect(found, findsOneWidget);
      expect(foundWidget.icon, configuration.style.columnContextIcon);
    },
  );

  testWidgets(
    'When enableContextMenu is false and enableDropToResize is true, '
    'ColumnIcon should be displayed',
    (WidgetTester tester) async {
      // given
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        enableContextMenu: false,
        enableDropToResize: true,
      );

      // when
      await tester.pumpWidget(
        buildApp(column: column),
      );

      // then
      final found = find.byType(PlutoGridColumnIcon);

      final foundWidget = found.evaluate().first.widget as PlutoGridColumnIcon;

      // then
      expect(found, findsOneWidget);
      expect(foundWidget.icon, configuration.style.columnResizeIcon);
    },
  );

  group('enableRowChecked', () {
    buildColumn(bool enable) {
      final column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        enableRowChecked: enable,
      );

      return PlutoWidgetTestHelper('build column.', (tester) async {
        await tester.pumpWidget(
          buildApp(column: column),
        );
      });
    }

    final columnHasNotCheckbox = buildColumn(false);

    columnHasNotCheckbox.test(
      'Checkbox widget should not be displayed',
      (tester) async {
        expect(find.byType(Checkbox), findsNothing);
      },
    );

    final columnHasCheckbox = buildColumn(true);

    columnHasCheckbox.test(
      'Checkbox widget should be displayed',
      (tester) async {
        expect(find.byType(Checkbox), findsOneWidget);
      },
    );

    columnHasCheckbox.test(
      'Tapping checkbox should call toggleAllRowChecked',
      (tester) async {
        await tester.tap(find.byType(Checkbox));

        verify(stateManager.toggleAllRowChecked(true)).called(1);
      },
    );
  });

  group('Non-frozen column', () {
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
    );

    final tapColumn = PlutoWidgetTestHelper('Tap column.', (tester) async {
      when(stateManager.refColumns)
          .thenReturn(FilteredList(initialList: [column]));

      await tester.pumpWidget(
        buildApp(column: column),
      );

      final columnIcon = find.byType(PlutoGridColumnIcon);

      final gesture = await tester.startGesture(tester.getCenter(columnIcon));

      await gesture.up();
    });

    tapColumn.test('Default menu should be displayed', (tester) async {
      expect(find.text('Freeze to start'), findsOneWidget);
      expect(find.text('Freeze to end'), findsOneWidget);
      expect(find.text('Auto fit'), findsOneWidget);
    });

    tapColumn.test('Tapping Freeze to start should call toggleFrozenColumn',
        (tester) async {
      await tester.tap(find.text('Freeze to start'));

      verify(stateManager.toggleFrozenColumn(
        column,
        PlutoColumnFrozen.start,
      )).called(1);
    });

    tapColumn.test('Tapping Freeze to end should call toggleFrozenColumn',
        (tester) async {
      await tester.tap(find.text('Freeze to end'));

      verify(stateManager.toggleFrozenColumn(
        column,
        PlutoColumnFrozen.end,
      )).called(1);
    });

    tapColumn.test('Tapping Auto fit should call autoFitColumn', (tester) async {
      when(stateManager.rows).thenReturn([
        PlutoRow(cells: {
          'column_field_name': PlutoCell(value: 'cell value'),
        }),
      ]);

      await tester.tap(find.text('Auto fit'));

      verify(stateManager.autoFitColumn(
        argThat(isA<BuildContext>()),
        column,
      )).called(1);
    });
  });

  group('Frozen column at the start', () {
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.start,
    );

    final tapColumn = PlutoWidgetTestHelper('Tap column.', (tester) async {
      when(stateManager.refColumns)
          .thenReturn(FilteredList(initialList: [column]));

      await tester.pumpWidget(
        buildApp(column: column),
      );

      final columnIcon = find.byType(PlutoGridColumnIcon);

      final gesture = await tester.startGesture(tester.getCenter(columnIcon));

      await gesture.up();
    });

    tapColumn.test('Frozen column menu should be displayed', (tester) async {
      expect(find.text('Unfreeze'), findsOneWidget);
      expect(find.text('Freeze to start'), findsNothing);
      expect(find.text('Freeze to end'), findsNothing);
      expect(find.text('Auto fit'), findsOneWidget);
    });

    tapColumn.test('Tapping Unfreeze should call toggleFrozenColumn',
        (tester) async {
      await tester.tap(find.text('Unfreeze'));

      verify(stateManager.toggleFrozenColumn(
        column,
        PlutoColumnFrozen.none,
      )).called(1);
    });

    tapColumn.test('Tapping Auto fit should call autoFitColumn', (tester) async {
      when(stateManager.rows).thenReturn([]);

      await tester.tap(find.text('Auto fit'));

      verify(stateManager.autoFitColumn(
        argThat(isA<BuildContext>()),
        column,
      )).called(1);
    });
  });

  group('Frozen column at the end', () {
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.end,
    );

    final tapColumn = PlutoWidgetTestHelper('Tap column.', (tester) async {
      when(stateManager.refColumns)
          .thenReturn(FilteredList(initialList: [column]));

      await tester.pumpWidget(
        buildApp(column: column),
      );

      final columnIcon = find.byType(PlutoGridColumnIcon);

      final gesture = await tester.startGesture(tester.getCenter(columnIcon));

      await gesture.up();
    });

    tapColumn.test('Frozen column menu should be displayed', (tester) async {
      expect(find.text('Unfreeze'), findsOneWidget);
      expect(find.text('Freeze to start'), findsNothing);
      expect(find.text('Freeze to end'), findsNothing);
      expect(find.text('Auto fit'), findsOneWidget);
    });

    tapColumn.test('Tapping Unfreeze should call toggleFrozenColumn',
        (tester) async {
      await tester.tap(find.text('Unfreeze'));

      verify(stateManager.toggleFrozenColumn(
        column,
        PlutoColumnFrozen.none,
      )).called(1);
    });

    tapColumn.test('Tapping Auto fit should call autoFitColumn', (tester) async {
      when(stateManager.rows).thenReturn([]);

      await tester.tap(find.text('Auto fit'));

      verify(stateManager.autoFitColumn(
        argThat(isA<BuildContext>()),
        column,
      )).called(1);
    });
  });

  group('Drag a column', () {
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.end,
    );

    final aColumn = PlutoWidgetTestHelper('a column.', (tester) async {
      await tester.pumpWidget(
        buildApp(column: column),
      );
    });

    aColumn.test(
      'When dragging and dropping to the same column, moveColumn should not be called.',
      (tester) async {
        await tester.drag(
          find.byType(TestHelperUtil.typeOf<Draggable<PlutoColumn>>()),
          const Offset(50.0, 0.0),
        );

        verifyNever(stateManager.moveColumn(
          column: column,
          targetColumn: column,
        ));
      },
    );
  });

  group('Drag a button', () {
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.text(),
    );

    dragAColumn(Offset offset) {
      return PlutoWidgetTestHelper('a column.', (tester) async {
        await tester.pumpWidget(
          buildApp(column: column),
        );

        final columnIcon = find.byType(PlutoGridColumnIcon);

        await tester.drag(columnIcon, offset);
      });
    }

    /**
     * (Default value is 4, Positioned widget right -3)
     */
    dragAColumn(
      const Offset(50.0, 0.0),
    ).test(
      'resizeColumn should be called with a value greater than or equal to 30',
      (tester) async {
        verify(stateManager.resizeColumn(
          column,
          argThat(greaterThanOrEqualTo(30)),
        ));
      },
    );

    dragAColumn(
      const Offset(-50.0, 0.0),
    ).test(
      'resizeColumn should be called with a value less than or equal to -30',
      (tester) async {
        verify(stateManager.resizeColumn(
          column,
          argThat(lessThanOrEqualTo(-30)),
        ));
      },
    );
  });

  group('configuration', () {
    aColumnWithConfiguration(
      PlutoGridConfiguration configuration, {
      PlutoColumn? column,
    }) {
      return PlutoWidgetTestHelper('a column.', (tester) async {
        when(stateManager.configuration).thenReturn(configuration);
        when(stateManager.style).thenReturn(configuration.style);

        await tester.pumpWidget(
          buildApp(
            column: column ??
                PlutoColumn(
                  title: 'column title',
                  field: 'column_field_name',
                  type: PlutoColumnType.text(),
                  frozen: PlutoColumnFrozen.end,
                ),
          ),
        );
      });
    }

    aColumnWithConfiguration(const PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        enableColumnBorderVertical: true,
        borderColor: Colors.deepOrange,
      ),
    )).test(
      'If enableColumnBorder is true, border should be set',
      (tester) async {
        expect(
          stateManager.configuration.style.enableColumnBorderVertical,
          true,
        );

        final target = find.descendant(
          of: find.byKey(sortableGestureKey),
          matching: find.byType(DecoratedBox),
        );

        final container = target.evaluate().single.widget as DecoratedBox;

        final BoxDecoration decoration = container.decoration as BoxDecoration;

        final BorderDirectional border = decoration.border as BorderDirectional;

        expect(border.end.width, 1.0);
        expect(border.end.color, Colors.deepOrange);
      },
    );

    aColumnWithConfiguration(const PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        enableColumnBorderVertical: false,
        borderColor: Colors.deepOrange,
      ),
    )).test(
      'If enableColumnBorder is false, border should not be set',
      (tester) async {
        expect(
          stateManager.configuration.style.enableColumnBorderVertical,
          false,
        );

        final target = find.descendant(
          of: find.byKey(sortableGestureKey),
          matching: find.byType(DecoratedBox),
        );

        final container = target.evaluate().single.widget as DecoratedBox;

        final BoxDecoration decoration = container.decoration as BoxDecoration;

        final BorderDirectional border = decoration.border as BorderDirectional;

        expect(border.end, BorderSide.none);
      },
    );

    aColumnWithConfiguration(
      const PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          columnAscendingIcon: Icon(
            Icons.arrow_upward,
            color: Colors.cyan,
          ),
        ),
      ),
      column: PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        sort: PlutoColumnSort.ascending,
      ),
    ).test(
      'If columnAscendingIcon is set, the set icon should appear',
      (tester) async {
        final target = find.descendant(
          of: find.byType(PlutoColumnTitle),
          matching: find.byType(Icon),
        );

        final icon = target.evaluate().first.widget as Icon;

        expect(icon.icon, Icons.arrow_upward);
        expect(icon.color, Colors.cyan);
      },
    );

    aColumnWithConfiguration(
      const PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          columnDescendingIcon: Icon(
            Icons.arrow_downward,
            color: Colors.pink,
          ),
        ),
      ),
      column: PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.text(),
        sort: PlutoColumnSort.descending,
      ),
    ).test(
      'If columnDescendingIcon is set, the set icon should appear',
      (tester) async {
        final target = find.descendant(
          of: find.byType(PlutoColumnTitle),
          matching: find.byType(Icon),
        );

        final icon = target.evaluate().first.widget as Icon;

        expect(icon.icon, Icons.arrow_downward);
        expect(icon.color, Colors.pink);
      },
    );
  });
}
