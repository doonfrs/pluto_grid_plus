import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../widget/pluto_example_button.dart';
import '../../widget/pluto_example_screen.dart';

class CellRendererScreen extends StatefulWidget {
  static const routeName = 'feature/cell-renderer';

  const CellRendererScreen({super.key});

  @override
  _CellRendererScreenState createState() => _CellRendererScreenState();
}

class _CellRendererScreenState extends State<CellRendererScreen> {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableRowChecked: true,
        width: 100,
        minWidth: 80,
        renderer: (rendererContext) {
          // Column-level renderer for all cells in this column
          return Text(
            rendererContext.cell.value.toString(),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'status',
        type: PlutoColumnType.select(
            <String>['Pending', 'In Progress', 'Completed', 'Cancelled']),
        width: 150,
      ),
      PlutoColumn(
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.select(
            <String>['Low', 'Medium', 'High', 'Critical']),
        width: 150,
      ),
      PlutoColumn(
        title: 'Notes',
        field: 'notes',
        type: PlutoColumnType.text(),
        width: 200,
      ),
    ]);

    // Create rows with custom cell renderers
    for (var i = 1; i <= 20; i++) {
      final statusValue = i % 4 == 0
          ? 'Completed'
          : (i % 4 == 1
              ? 'In Progress'
              : (i % 4 == 2 ? 'Pending' : 'Cancelled'));

      final priorityValue = i % 4 == 0
          ? 'Low'
          : (i % 4 == 1 ? 'Medium' : (i % 4 == 2 ? 'High' : 'Critical'));

      final cells = {
        'id': PlutoCell(value: i),
        'name': PlutoCell(value: 'Task $i'),
        'status': PlutoCell(
          value: statusValue,
          // Cell-level renderer that overrides any column renderer
          renderer: (rendererContext) {
            Color backgroundColor;
            Color textColor = Colors.white;

            switch (rendererContext.cell.value) {
              case 'Completed':
                backgroundColor = Colors.green;
                break;
              case 'In Progress':
                backgroundColor = Colors.orange;
                break;
              case 'Pending':
                backgroundColor = Colors.blue;
                break;
              case 'Cancelled':
                backgroundColor = Colors.red;
                break;
              default:
                backgroundColor = Colors.grey;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rendererContext.cell.value.toString(),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        'priority': PlutoCell(
          value: priorityValue,
          // Another cell-level renderer example
          renderer: (rendererContext) {
            IconData iconData;
            Color iconColor;

            switch (rendererContext.cell.value) {
              case 'Low':
                iconData = Icons.arrow_downward;
                iconColor = Colors.green;
                break;
              case 'Medium':
                iconData = Icons.arrow_forward;
                iconColor = Colors.blue;
                break;
              case 'High':
                iconData = Icons.arrow_upward;
                iconColor = Colors.orange;
                break;
              case 'Critical':
                iconData = Icons.priority_high;
                iconColor = Colors.red;
                break;
              default:
                iconData = Icons.help_outline;
                iconColor = Colors.grey;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  color: iconColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  rendererContext.cell.value.toString(),
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
        'notes': PlutoCell(value: 'This is a note for task $i'),
      };

      // Add a special renderer for specific cells
      if (i % 5 == 0) {
        cells['notes'] = PlutoCell(
          value: 'Important note for task $i!',
          renderer: (rendererContext) {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4),
                color: Colors.red[50],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      rendererContext.cell.value.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      rows.add(PlutoRow(cells: cells));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlutoExampleScreen(
      title: 'Cell-level renderer',
      topTitle: 'Cell-level renderer',
      topContents: const [
        Text('You can customize individual cells with cell-level renderers.'),
        Text(
            'Cell renderers take precedence over column renderers when both are defined.'),
      ],
      topButtons: [
        PlutoExampleButton(
          url:
              'https://github.com/doonfrs/pluto_grid_plus/blob/master/demo/lib/screen/feature/cell_renderer_screen.dart',
        ),
      ],
      body: PlutoGrid(
        columns: columns,
        rows: rows,
        onChanged: (PlutoGridOnChangedEvent event) {
          print(event);
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
          stateManager = event.stateManager;
        },
      ),
    );
  }
}
