import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoBaseColumn extends StatelessWidget {
  final PlutoGridStateManager stateManager;

  final PlutoColumn column;

  final double? columnTitleHeight;

  PlutoBaseColumn({
    required this.stateManager,
    required this.column,
    this.columnTitleHeight,
  }) : super(key: column.key);

  @override
  Widget build(BuildContext context) {
    return PlutoIgnoreParentNeedsLayout(
      child: PlutoVisibilityColumn(
        key: ValueKey('${column.key}_visibility'),
        stateManager: stateManager,
        child: PlutoBaseColumnWidget(
          stateManager: stateManager,
          column: column,
          columnTitleHeight: columnTitleHeight,
        ),
      ),
    );
  }
}

class PlutoBaseColumnWidget extends PlutoStatefulWidget
    with VisibilityColumnWidget {
  @override
  final PlutoGridStateManager stateManager;

  @override
  final PlutoColumn column;

  final double? columnTitleHeight;

  PlutoBaseColumnWidget({
    required this.stateManager,
    required this.column,
    this.columnTitleHeight,
  }) : super(key: column.key);

  @override
  PlutoBaseColumnWidgetState createState() => PlutoBaseColumnWidgetState();
}

class PlutoBaseColumnWidgetState
    extends PlutoStateWithChange<PlutoBaseColumnWidget> {
  bool? _showColumnFilter;

  @override
  void initState() {
    super.initState();

    _showColumnFilter = widget.stateManager.showColumnFilter;
  }

  @override
  void onChange(event) {
    resetState((update) {
      _showColumnFilter = update<bool?>(
        _showColumnFilter,
        widget.stateManager.showColumnFilter,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom:
              _showColumnFilter! ? widget.stateManager.columnFilterHeight : 0,
          child: PlutoColumnTitle(
            stateManager: widget.stateManager,
            column: widget.column,
            height:
                widget.columnTitleHeight ?? widget.stateManager.columnHeight,
          ),
        ),
        if (_showColumnFilter!)
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: PlutoColumnFilter(
              stateManager: widget.stateManager,
              column: widget.column,
            ),
          ),
      ],
    );
  }
}
