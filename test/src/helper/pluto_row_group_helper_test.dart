import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../mock/mock_methods.dart';

void main() {
  final mock = MockMethods();

  group('applyFilter', () {
    test('When the rows is empty, the filter should not be called.', () {
      final FilteredList<PlutoRow> rows = FilteredList();

      final mockFilter = mock.oneParamReturnBool<PlutoRow>;

      expect(rows.originalList.length, 0);

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: mockFilter);

      verifyNever(mockFilter(any));
    });

    test('When the rows is not empty, the filter should be called.', () {
      final FilteredList<PlutoRow> rows = FilteredList(initialList: [
        PlutoRow(cells: {}),
      ]);

      final mockFilter = mock.oneParamReturnBool<PlutoRow>;

      expect(rows.originalList.length, 1);

      when(mockFilter(any)).thenReturn(true);

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: mockFilter);

      verify(mockFilter(any)).called(1);
    });

    test('When the filter is set, calling null should remove the filter.', () {
      final FilteredList<PlutoRow> rows = FilteredList(initialList: [
        PlutoRow(cells: {'column1': PlutoCell(value: 'test1')}),
        PlutoRow(cells: {'column1': PlutoCell(value: 'test2')}),
        PlutoRow(cells: {'column1': PlutoCell(value: 'test3')}),
      ]);

      filter(PlutoRow row) => row.cells['column1']!.value == 'test1';

      expect(rows.length, 3);

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: filter);

      expect(rows.length, 1);

      expect(rows.hasFilter, true);

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: null);

      expect(rows.length, 3);

      expect(rows.hasFilter, false);
    });

    test('When the group row is included, the filter should be included.', () {
      final FilteredList<PlutoRow> rows = FilteredList(initialList: [
        PlutoRow(cells: {'column1': PlutoCell(value: 'test1')}),
        PlutoRow(cells: {'column1': PlutoCell(value: 'test2')}),
        PlutoRow(
          cells: {'column1': PlutoCell(value: 'test3')},
          type: PlutoRowType.group(
            children: FilteredList(initialList: [
              PlutoRow(cells: {'column1': PlutoCell(value: 'group1')}),
              PlutoRow(cells: {'column1': PlutoCell(value: 'group2')}),
            ]),
          ),
        ),
      ]);

      final mockFilter = mock.oneParamReturnBool<PlutoRow>;

      when(mockFilter(any)).thenReturn(true);

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: mockFilter);

      verify(mockFilter(any)).called(greaterThanOrEqualTo(2));
    });

    test(
        'When the child rows of the group are filtered and the filter is removed, '
        'the child rows should be included in the list.', () {
      final FilteredList<PlutoRow> rows = FilteredList(initialList: [
        PlutoRow(cells: {'column1': PlutoCell(value: 'test1')}),
        PlutoRow(cells: {'column1': PlutoCell(value: 'test2')}),
        PlutoRow(
          cells: {'column1': PlutoCell(value: 'test3')},
          type: PlutoRowType.group(
            children: FilteredList(initialList: [
              PlutoRow(cells: {'column1': PlutoCell(value: 'group1')}),
              PlutoRow(cells: {'column1': PlutoCell(value: 'group2')}),
            ]),
          ),
        ),
      ]);

      filter(PlutoRow row) =>
          !row.cells['column1']!.value.toString().startsWith('group');

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: filter);

      expect(rows[2].type.group.children.length, 0);

      PlutoRowGroupHelper.applyFilter(rows: rows, filter: null);

      expect(rows[2].type.group.children.length, 2);
    });
  });
}
