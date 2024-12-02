import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../dummy_data/development.dart';

class CustomLoadingIndicatorScreen extends StatefulWidget {
  static const routeName = 'empty';

  const CustomLoadingIndicatorScreen({super.key});

  @override
  _CustomLoadingIndicatorScreenState createState() => _CustomLoadingIndicatorScreenState();
}

class _CustomLoadingIndicatorScreenState extends State<CustomLoadingIndicatorScreen> {
  late List<PlutoColumn> columns;

  late List<PlutoRow> rows;

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: 'column1',
        field: 'column1',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'column2',
        field: 'column2',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'column3',
        field: 'column3',
        type: PlutoColumnType.text(),
      ),
    ];

    rows = DummyData.rowsByColumns(length: 10, columns: columns);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onChanged: (PlutoGridOnChangedEvent event) {
              print(event);
            },
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
            },
            configuration: const PlutoGridConfiguration(),
          ),
        ),
      ),
    );
  }
}
