import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:rxdart/rxdart.dart';

import '../../helper/pluto_widget_test_helper.dart';
import '../../mock/shared_mocks.mocks.dart';

void main() {
  late MockPlutoGridStateManager stateManager;

  late PublishSubject<PlutoNotifierEvent> subject;

  buildWidget({
    required PlutoColumn column,
    required FilteredList<PlutoRow> rows,
    required PlutoAggregateColumnType type,
    PlutoAggregateColumnGroupedRowType groupedRowType =
        PlutoAggregateColumnGroupedRowType.all,
    PlutoAggregateColumnIterateRowType iterateRowType =
        PlutoAggregateColumnIterateRowType.filteredAndPaginated,
    PlutoAggregateFilter? filter,
    String? locale,
    String? format,
    List<InlineSpan> Function(String)? titleSpanBuilder,
    AlignmentGeometry? alignment,
    EdgeInsets? padding,
    bool enabledRowGroups = false,
  }) {
    return PlutoWidgetTestHelper('PlutoAggregateColumnFooter : ',
        (tester) async {
      stateManager = MockPlutoGridStateManager();

      subject = PublishSubject<PlutoNotifierEvent>();

      when(stateManager.streamNotifier).thenAnswer((_) => subject);

      when(stateManager.configuration)
          .thenReturn(const PlutoGridConfiguration());

      when(stateManager.refRows).thenReturn(rows);

      when(stateManager.enabledRowGroups).thenReturn(enabledRowGroups);

      when(stateManager.iterateAllMainRowGroup)
          .thenReturn(rows.originalList.where((r) => r.isMain));

      when(stateManager.iterateFilteredMainRowGroup)
          .thenReturn(rows.filterOrOriginalList.where((r) => r.isMain));

      when(stateManager.iterateMainRowGroup)
          .thenReturn(rows.where((r) => r.isMain));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoAggregateColumnFooter(
              rendererContext: PlutoColumnFooterRendererContext(
                stateManager: stateManager,
                column: column,
              ),
              type: type,
              groupedRowType: groupedRowType,
              iterateRowType: iterateRowType,
              filter: filter,
              format: format ?? '#,###',
              locale: locale,
              titleSpanBuilder: titleSpanBuilder,
              alignment: alignment,
              padding: padding,
            ),
          ),
        ),
      );
    });
  }

  group('number column.', () {
    final columns = [
      PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(),
      ),
    ];

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: []),
      type: PlutoAggregateColumnType.sum,
    ).test(
        'When sum is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('0');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: []),
      type: PlutoAggregateColumnType.average,
    ).test(
        'When average is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('0');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: []),
      type: PlutoAggregateColumnType.min,
    ).test(
        'When min is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: []),
      type: PlutoAggregateColumnType.max,
    ).test(
        'When max is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: []),
      type: PlutoAggregateColumnType.count,
    ).test(
        'When count is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('0');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
    ).test(
        'When sum is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('6,000');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.average,
    ).test(
        'When average is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('2,000');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.min,
    ).test(
        'When min is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('1,000');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.max,
    ).test(
        'When max is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('3,000');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.count,
    ).test(
        'When count is set, the value should be displayed in the specified format.',
        (tester) async {
      final found = find.text('3');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.count,
      filter: (cell) => cell.value > 1000,
    ).test(
        'When filter is set, the count value should be displayed based on the filter condition.',
        (tester) async {
      final found = find.text('2');

      expect(found, findsOneWidget);
    });

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.count,
      format: 'Total : #,###',
    ).test(
      'When count is set, the value should be displayed in the specified format.',
      (tester) async {
        final found = find.text('Total : 3');

        expect(found, findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      titleSpanBuilder: (text) {
        return [
          const WidgetSpan(child: Text('Left ')),
          WidgetSpan(child: Text('Value : $text')),
          const WidgetSpan(child: Text(' Right')),
        ];
      },
    ).test(
      'When titleSpanBuilder is set, the sum value should be displayed in the specified widget.',
      (tester) async {
        expect(find.text('Left '), findsOneWidget);
        expect(find.text('Value : 6,000'), findsOneWidget);
        expect(find.text(' Right'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilter((element) => element.cells['column']!.value > 1000),
      type: PlutoAggregateColumnType.sum,
    ).test(
      'When filter is applied, only the filtered results should be aggregated.',
      (tester) async {
        expect(find.text('5,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilterRange(FilteredListRange(0, 2)),
      type: PlutoAggregateColumnType.sum,
    ).test(
      'When pagination is applied, only the paginated results should be aggregated.',
      (tester) async {
        expect(find.text('3,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilterRange(FilteredListRange(0, 2)),
      type: PlutoAggregateColumnType.sum,
      iterateRowType: PlutoAggregateColumnIterateRowType.all,
    ).test(
      'When iterateRowType is all, even if pagination is applied, all rows should be included in the aggregation.',
      (tester) async {
        expect(find.text('6,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilter((element) => element.cells['column']!.value > 1000)
        ..setFilterRange(FilteredListRange(0, 2)),
      type: PlutoAggregateColumnType.sum,
      iterateRowType: PlutoAggregateColumnIterateRowType.filtered,
    ).test(
      'When iterateRowType is filtered, pagination should be ignored and only the filtered results should be included in the aggregation.',
      (tester) async {
        expect(find.text('5,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(cells: {'column': PlutoCell(value: 1000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilter((element) => element.cells['column']!.value > 1000),
      type: PlutoAggregateColumnType.sum,
      iterateRowType: PlutoAggregateColumnIterateRowType.all,
    ).test(
      'When iterateRowType is all, even if the filter is applied, all rows should be included in the aggregation.',
      (tester) async {
        expect(find.text('6,000'), findsOneWidget);
      },
    );
  });

  group('RowGroups', () {
    final columns = [
      PlutoColumn(
        title: 'column',
        field: 'column',
        type: PlutoColumnType.number(),
      ),
    ];

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
                children: FilteredList(
              initialList: [
                PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
              ],
            ))),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.all,
      enabledRowGroups: true,
      titleSpanBuilder: (text) {
        return [
          WidgetSpan(child: Text('Value : $text')),
        ];
      },
    ).test(
      'When GroupedRowType is all, '
      'Value : 10,000 should be displayed.',
      (tester) async {
        expect(find.text('Value : 10,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
                children: FilteredList(
              initialList: [
                PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
              ],
            ))),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.expandedAll,
      enabledRowGroups: true,
      titleSpanBuilder: (text) {
        return [
          WidgetSpan(child: Text('Value : $text')),
        ];
      },
    ).test(
      'When GroupedRowType is expandedAll and the group row is collapsed, '
      'Value : 6,000 should be displayed.',
      (tester) async {
        expect(find.text('Value : 6,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.expandedAll,
      enabledRowGroups: true,
      titleSpanBuilder: (text) {
        return [
          WidgetSpan(child: Text('Value : $text')),
        ];
      },
    ).test(
      'When GroupedRowType is expandedAll and the group row is expanded, '
      'Value : 10,000 should be displayed.',
      (tester) async {
        expect(find.text('Value : 10,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.rows,
      enabledRowGroups: true,
      titleSpanBuilder: (text) {
        return [
          WidgetSpan(child: Text('Value : $text')),
        ];
      },
    ).test(
      'When GroupedRowType is rows, '
      'Value : 9,000 should be displayed.',
      (tester) async {
        expect(find.text('Value : 9,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: false,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.expandedRows,
      enabledRowGroups: true,
      titleSpanBuilder: (text) {
        return [
          WidgetSpan(child: Text('Value : $text')),
        ];
      },
    ).test(
      'When GroupedRowType is expandedRows and the group row is collapsed, '
      'Value : 5,000 should be displayed.',
      (tester) async {
        expect(find.text('Value : 5,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ]),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.expandedRows,
      enabledRowGroups: true,
      titleSpanBuilder: (text) {
        return [
          WidgetSpan(child: Text('Value : $text')),
        ];
      },
    ).test(
      'When GroupedRowType is expandedRows and the group row is expanded, '
      'Value : 9,000 should be displayed.',
      (tester) async {
        expect(find.text('Value : 9,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilter((element) => element.cells['column']!.value > 1000),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.all,
      enabledRowGroups: true,
    ).test(
      'When the filter is applied, only the filtered results should be included in the aggregation.',
      (tester) async {
        expect(find.text('5,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilterRange(FilteredListRange(0, 2)),
      type: PlutoAggregateColumnType.sum,
      groupedRowType: PlutoAggregateColumnGroupedRowType.all,
      enabledRowGroups: true,
    ).test(
      'When pagination is set, only the paginated results should be included in the aggregation.',
      (tester) async {
        expect(find.text('7,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilter((element) => element.cells['column']!.value > 1000),
      type: PlutoAggregateColumnType.sum,
      iterateRowType: PlutoAggregateColumnIterateRowType.all,
      groupedRowType: PlutoAggregateColumnGroupedRowType.all,
      enabledRowGroups: true,
    ).test(
      'When iterateRowType is all, even if the filter is applied, all rows should be included in the aggregation.',
      (tester) async {
        expect(find.text('10,000'), findsOneWidget);
      },
    );

    buildWidget(
      column: columns.first,
      rows: FilteredList<PlutoRow>(initialList: [
        PlutoRow(
            cells: {'column': PlutoCell(value: 1000)},
            type: PlutoRowType.group(
              children: FilteredList(
                initialList: [
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                  PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
                ],
              ),
              expanded: true,
            )),
        PlutoRow(cells: {'column': PlutoCell(value: 2000)}),
        PlutoRow(cells: {'column': PlutoCell(value: 3000)}),
      ])
        ..setFilter((element) => element.cells['column']!.value > 1000)
        ..setFilterRange(FilteredListRange(0, 2)),
      type: PlutoAggregateColumnType.sum,
      iterateRowType: PlutoAggregateColumnIterateRowType.filtered,
      groupedRowType: PlutoAggregateColumnGroupedRowType.all,
      enabledRowGroups: true,
    ).test(
      'When iterateRowType is filtered, pagination should be ignored and only the filtered results should be included in the aggregation.',
      (tester) async {
        expect(find.text('5,000'), findsOneWidget);
      },
    );
  });
}
