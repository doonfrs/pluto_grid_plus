import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../../helper/column_helper.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  group('getColumnsAutoSizeHelper', () {
    test('When columns is empty, assertion should be thrown', () {
      final stateManager = PlutoGridStateManager(
        columns: [],
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
          ),
        ),
      );

      expect(() {
        stateManager.getColumnsAutoSizeHelper(
          columns: [],
          maxWidth: 500,
        );
      }, throwsAssertionError);
    });

    test('When PlutoAutoSizeMode is none, assertion should be thrown', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      final stateManager = PlutoGridStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.none,
          ),
        ),
      );

      expect(() {
        stateManager.getColumnsAutoSizeHelper(
          columns: columns,
          maxWidth: 500,
        );
      }, throwsAssertionError);
    });

    test('When PlutoAutoSizeMode is equal, should return PlutoAutoSize', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      final stateManager = PlutoGridStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
          ),
        ),
      );

      final helper = stateManager.getColumnsAutoSizeHelper(
        columns: columns,
        maxWidth: 500,
      );

      expect(helper, isA<PlutoAutoSize>());
    });

    test('When PlutoAutoSizeMode is scale, should return PlutoAutoSize', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      final stateManager = PlutoGridStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
          ),
        ),
      );

      final helper = stateManager.getColumnsAutoSizeHelper(
        columns: columns,
        maxWidth: 500,
      );

      expect(helper, isA<PlutoAutoSize>());
    });
  });

  group('getColumnsResizeHelper', () {
    test('When PlutoResizeMode is none, assertion should be thrown', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      final stateManager = PlutoGridStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            resizeMode: PlutoResizeMode.none,
          ),
        ),
      );

      expect(() {
        stateManager.getColumnsResizeHelper(
          columns: columns,
          column: columns.first,
          offset: 10,
        );
      }, throwsAssertionError);
    });

    test('When PlutoResizeMode is normal, assertion should be thrown', () {
      final columns = ColumnHelper.textColumn('title', count: 5);

      final stateManager = PlutoGridStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            resizeMode: PlutoResizeMode.normal,
          ),
        ),
      );

      expect(() {
        stateManager.getColumnsResizeHelper(
          columns: columns,
          column: columns.first,
          offset: 10,
        );
      }, throwsAssertionError);
    });

    test('When columns is empty, assertion should be thrown', () {
      final columns = <PlutoColumn>[];

      final stateManager = PlutoGridStateManager(
        columns: columns,
        rows: [],
        gridFocusNode: MockFocusNode(),
        scroll: MockPlutoGridScrollController(),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            resizeMode: PlutoResizeMode.normal,
          ),
        ),
      );

      expect(() {
        stateManager.getColumnsResizeHelper(
          columns: columns,
          column: ColumnHelper.textColumn('title').first,
          offset: 10,
        );
      }, throwsAssertionError);
    });
  });
}
