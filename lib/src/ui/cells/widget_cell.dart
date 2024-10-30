import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/helper/platform_helper.dart';

abstract class WidgetCell extends StatefulWidget {
  final PlutoGridStateManager stateManager;

  final PlutoCell cell;

  final PlutoColumn column;

  final PlutoRow row;

  const WidgetCell({
    required this.stateManager,
    required this.cell,
    required this.column,
    required this.row,
    super.key,
  });
}

mixin WidgetCellState<T extends WidgetCell> on State<T> {
  dynamic _initialCellValue;

  // final _textController = TextEditingController();

  final PlutoDebounceByHashCode _debounce = PlutoDebounceByHashCode();

  late final FocusNode cellFocus;

  late _CellEditingStatus _cellEditingStatus;

  @override
  TextInputType get keyboardType => TextInputType.none;

  @override
  List<TextInputFormatter>? get inputFormatters => [];

  String get formattedValue =>
      widget.column.formattedValueForDisplayInEditing(widget.cell.value);

  @override
  void initState() {
    super.initState();

    cellFocus = FocusNode(onKeyEvent: _handleOnKey);
    cellFocus.addListener(_onFocusChanged);

    widget.stateManager.setTextEditingController(null);

    _initialCellValue = null;

    _cellEditingStatus = _CellEditingStatus.init;
  }

  void _onFocusChanged() {
    if (cellFocus.hasFocus) {
      widget.stateManager
          .setCurrentCell(widget.cell, widget.row.sortIdx, notify: true);
      widget.stateManager.setKeepFocus(true);
    }
  }

  @override
  void dispose() {
    if (!widget.stateManager.isEditing ||
        widget.stateManager.currentColumn?.enableEditingMode != true) {
      widget.stateManager.setTextEditingController(null);
    }

    _debounce.dispose();

    // _textController.dispose();
    cellFocus.removeListener(_onFocusChanged);
    cellFocus.dispose();

    super.dispose();
  }

  void _restoreText() {}

  bool _moveHorizontal(PlutoKeyManagerEvent keyManager) {
    if (!keyManager.isHorizontal) {
      return false;
    }

    if (widget.column.readOnly == true) {
      return true;
    }

    return false;
  }

  KeyEventResult _handleOnKey(FocusNode node, KeyEvent event) {
    return widget.stateManager.keyManager!.eventResult.skip(
      KeyEventResult.ignored,
    );
  }

  void _handleOnTap() {
    widget.stateManager.setKeepFocus(true);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: cellFocus,
      child: widget.column.renderer!(PlutoColumnRendererContext(
        column: widget.column,
        rowIdx: widget.row.sortIdx,
        row: widget.row,
        cell: widget.cell,
        stateManager: widget.stateManager,
      )),
    );
  }
}

enum _CellEditingStatus {
  init,
  changed,
  updated;

  bool get isNotChanged {
    return _CellEditingStatus.changed != this;
  }

  bool get isChanged {
    return _CellEditingStatus.changed == this;
  }

  bool get isUpdated {
    return _CellEditingStatus.updated == this;
  }
}
