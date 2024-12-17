import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../dummy_data/development.dart';

class CustomLoadingIndicatorScreen extends StatefulWidget {
  static const routeName = 'feature/custom-loading-indicator';

  const CustomLoadingIndicatorScreen({super.key});

  @override
  _CustomLoadingIndicatorScreenState createState() => _CustomLoadingIndicatorScreenState();
}

class _CustomLoadingIndicatorScreenState extends State<CustomLoadingIndicatorScreen> {
  late List<PlutoColumn> columns;

  late List<PlutoRow> rows;

  PlutoGridStateManager? stateManager;

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
    return ListenableBuilder(
      listenable: Listenable.merge([stateManager]),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Custom Loading Indicator'),
            actions: PlutoGridLoadingLevel.values.map((level) {
              if (stateManager == null) return SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => stateManager?.setLoadingLevel(level),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: stateManager?.loadingLevel == level
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(level.name),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          persistentFooterButtons: [
            TextButton(
              onPressed: () {
                stateManager?.setShowLoading(stateManager?.showLoading == false,
                    level: stateManager!.loadingLevel);
              },
              child: const Text('Toggle Loading'),
            )
          ],
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: PlutoGrid(
                columns: columns,
                rows: rows,
                mode: PlutoGridMode.readOnly,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  setState(() => stateManager = event.stateManager);

                  stateManager?.setCustomLoadingIndicator(
                      (context) => CustomLoadingIndicator());
                },
                configuration: const PlutoGridConfiguration(
                    columnSize: PlutoGridColumnSizeConfig(
                        autoSizeMode: PlutoAutoSizeMode.scale)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(
            color:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: .6),
          ),
        ),
        Center(child: CircularProgressIndicator.adaptive()),
      ],
    );
  }
}
