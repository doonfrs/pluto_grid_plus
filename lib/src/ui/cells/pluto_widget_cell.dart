import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import 'text_cell.dart';
import 'widget_cell.dart';

class PlutoWidgetCell extends StatefulWidget implements WidgetCell {
  @override
  final PlutoGridStateManager stateManager;

  @override
  final PlutoCell cell;

  @override
  final PlutoColumn column;

  @override
  final PlutoRow row;

  const PlutoWidgetCell({
    required this.stateManager,
    required this.cell,
    required this.column,
    required this.row,
    super.key,
  });

  @override
  PlutoWidgetCellState createState() => PlutoWidgetCellState();
}

class PlutoWidgetCellState extends State<PlutoWidgetCell>
    with WidgetCellState<PlutoWidgetCell> {}
