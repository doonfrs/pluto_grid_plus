import 'package:demo/dummy_data/development.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../widget/pluto_example_button.dart';
import '../../widget/pluto_example_screen.dart';

class FrozenRowsScreen extends StatefulWidget {
  static const routeName = 'feature/frozen-rows';

  const FrozenRowsScreen({super.key});

  @override
  _FrozenRowsScreenState createState() => _FrozenRowsScreenState();
}

class _FrozenRowsScreenState extends State<FrozenRowsScreen> {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  late final PlutoGridStateManager stateManager;

  void setColumnSizeConfig(PlutoGridColumnSizeConfig config) {
    stateManager.setColumnSizeConfig(config);
  }

  @override
  void initState() {
    super.initState();

    final dummyData = DummyData(10, 1000);

    columns.addAll(dummyData.columns);

    rows.addAll(dummyData.rows);

    rows.insert(
        0,
        PlutoRow(
          cells: Map.fromIterables(columns.map((e) => e.field),
              columns.map((e) => PlutoCell(value: 'frozen'))),
          frozen: PlutoRowFrozen.start,
        ));

    rows.insert(
        rows.length - 1,
        PlutoRow(
          cells: Map.fromIterables(columns.map((e) => e.field),
              columns.map((e) => PlutoCell(value: 'frozen'))),
          frozen: PlutoRowFrozen.end,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PlutoExampleScreen(
      title: 'Frozen Rows',
      topTitle: 'Frozen Rows',
      topContents: const [
        Text(
          'You can freeze the row by setting the frozen property to PlutoRowFrozen.start or PlutoRowFrozen.end.',
        ),
      ],
      topButtons: [
        PlutoExampleButton(
          url:
              'https://github.com/doonfrs/pluto_grid_plus/blob/master/demo/lib/screen/feature/frozen_rows_screen.dart',
        ),
      ],
      body: PlutoGrid(
        columns: columns,
        rows: rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        createHeader: (stateManager) => _Header(
          setConfig: setColumnSizeConfig,
        ),
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.none,
            resizeMode: PlutoResizeMode.normal,
          ),
        ),
        createFooter: (stateManager) {
          stateManager.setPageSize(100, notify: false); // default 40
          return PlutoPagination(stateManager);
        },
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.setConfig,
  });

  final void Function(PlutoGridColumnSizeConfig) setConfig;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  PlutoGridColumnSizeConfig columnSizeConfig =
      const PlutoGridColumnSizeConfig();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
