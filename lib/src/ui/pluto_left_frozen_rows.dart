import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import 'ui.dart';

class PlutoLeftFrozenRows extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  const PlutoLeftFrozenRows(
    this.stateManager, {
    super.key,
  });

  @override
  PlutoLeftFrozenRowsState createState() => PlutoLeftFrozenRowsState();
}

class PlutoLeftFrozenRowsState
    extends PlutoStateWithChange<PlutoLeftFrozenRows> {
  List<PlutoColumn> _columns = [];

  List<PlutoRow> _rows = [];
  List<PlutoRow> _frozenTopRows = [];
  List<PlutoRow> _frozenBottomRows = [];
  List<PlutoRow> _scrollableRows = [];

  late final ScrollController _scroll;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    _scroll = stateManager.scroll.vertical!.addAndGet();

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void dispose() {
    _scroll.dispose();

    super.dispose();
  }

  @override
  void updateState(PlutoNotifierEvent event) {
    forceUpdate();

    _columns = stateManager.leftFrozenColumns;

    // Get all rows
    _rows = stateManager.refRows;

    // Separate frozen rows from scrollable rows
    _frozenTopRows = stateManager.refRows.originalList
        .where((row) => row.frozen == PlutoRowFrozen.start)
        .toList();
    _frozenBottomRows = stateManager.refRows.originalList
        .where((row) => row.frozen == PlutoRowFrozen.end)
        .toList();
    _scrollableRows =
        _rows.where((row) => row.frozen == PlutoRowFrozen.none).toList();
  }

  Widget _buildRow(PlutoRow row, int index) {
    return PlutoBaseRow(
      key: ValueKey('left_frozen_row_${row.key}'),
      rowIdx: index,
      row: row,
      columns: _columns,
      stateManager: stateManager,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Frozen top rows
        if (_frozenTopRows.isNotEmpty)
          Column(
            children: _frozenTopRows
                .asMap()
                .entries
                .map((e) => _buildRow(e.value, e.key))
                .toList(),
          ),
        // Scrollable rows
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            itemCount: _scrollableRows.length,
            itemExtent: stateManager.rowTotalHeight,
            itemBuilder: (ctx, i) =>
                _buildRow(_scrollableRows[i], i + _frozenTopRows.length),
          ),
        ),
        // Frozen bottom rows
        if (_frozenBottomRows.isNotEmpty)
          Column(
            children: _frozenBottomRows
                .asMap()
                .entries
                .map((e) => _buildRow(e.value,
                    e.key + _frozenTopRows.length + _scrollableRows.length))
                .toList(),
          ),
      ],
    );
  }
}
