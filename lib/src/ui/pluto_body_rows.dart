import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import 'ui.dart';

class PlutoBodyRows extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  const PlutoBodyRows(
    this.stateManager, {
    super.key,
  });

  @override
  PlutoBodyRowsState createState() => PlutoBodyRowsState();
}

class PlutoBodyRowsState extends PlutoStateWithChange<PlutoBodyRows> {
  List<PlutoColumn> _columns = [];

  List<PlutoRow> _rows = [];
  List<PlutoRow> _frozenTopRows = [];
  List<PlutoRow> _frozenBottomRows = [];
  List<PlutoRow> _scrollableRows = [];

  late final ScrollController _verticalScroll;

  late final ScrollController _horizontalScroll;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    _horizontalScroll = stateManager.scroll.horizontal!.addAndGet();

    stateManager.scroll.setBodyRowsHorizontal(_horizontalScroll);

    _verticalScroll = stateManager.scroll.vertical!.addAndGet();

    stateManager.scroll.setBodyRowsVertical(_verticalScroll);

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void dispose() {
    _verticalScroll.dispose();

    _horizontalScroll.dispose();

    super.dispose();
  }

  @override
  void updateState(PlutoNotifierEvent event) {
    forceUpdate();

    _columns = _getColumns();

    // Get frozen rows from the original list to keep them across pagination
    _frozenTopRows = stateManager.refRows.originalList
        .where((row) => row.frozen == PlutoRowFrozen.start)
        .toList();
    _frozenBottomRows = stateManager.refRows.originalList
        .where((row) => row.frozen == PlutoRowFrozen.end)
        .toList();

    // Get non-frozen rows from the current page
    _rows = stateManager.refRows;
    _scrollableRows =
        _rows.where((row) => row.frozen == PlutoRowFrozen.none).toList();
  }

  List<PlutoColumn> _getColumns() {
    return stateManager.showFrozenColumn == true
        ? stateManager.bodyColumns
        : stateManager.columns;
  }

  Widget _buildRow(BuildContext context, PlutoRow row, int index) {
    Widget rowWidget = PlutoBaseRow(
      key: ValueKey('body_row_${row.key}'),
      rowIdx: index,
      row: row,
      columns: _columns,
      stateManager: stateManager,
      visibilityLayout: true,
    );

    return stateManager.rowWrapper?.call(context, rowWidget, stateManager) ??
        rowWidget;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: stateManager.style.rowColor,
        borderRadius: stateManager.configuration.style.gridBorderRadius,
      ),
      child: SingleChildScrollView(
        controller: _horizontalScroll,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: CustomSingleChildLayout(
          delegate: ListResizeDelegate(stateManager, _columns),
          child: Column(
            children: [
              // Frozen top rows
              if (_frozenTopRows.isNotEmpty)
                Column(
                  children: _frozenTopRows
                      .asMap()
                      .entries
                      .map((e) => _buildRow(context, e.value, e.key))
                      .toList(),
                ),
              // Scrollable rows
              Expanded(
                child: ListView.builder(
                  controller: _verticalScroll,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _scrollableRows.length,
                  itemExtent: stateManager.rowWrapper != null
                      ? null
                      : stateManager.rowTotalHeight,
                  addRepaintBoundaries: false,
                  itemBuilder: (ctx, i) => _buildRow(
                      context, _scrollableRows[i], i + _frozenTopRows.length),
                ),
              ),
              // Frozen bottom rows
              if (_frozenBottomRows.isNotEmpty)
                Column(
                  children: _frozenBottomRows
                      .asMap()
                      .entries
                      .map((e) => _buildRow(
                          context,
                          e.value,
                          e.key +
                              _frozenTopRows.length +
                              _scrollableRows.length))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListResizeDelegate extends SingleChildLayoutDelegate {
  PlutoGridStateManager stateManager;

  List<PlutoColumn> columns;

  ListResizeDelegate(this.stateManager, this.columns)
      : super(relayout: stateManager.resizingChangeNotifier);

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  double _getWidth() {
    return columns.fold(
      0,
      (previousValue, element) => previousValue + element.width,
    );
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return constraints.tighten(width: _getWidth()).biggest;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return const Offset(0, 0);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(width: _getWidth());
  }
}
