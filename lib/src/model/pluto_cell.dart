import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

typedef PlutoCellRenderer = Widget Function(
    PlutoCellRendererContext rendererContext);

class PlutoCellRendererContext {
  final PlutoColumn column;

  final int rowIdx;

  final PlutoRow row;

  final PlutoCell cell;

  final PlutoGridStateManager stateManager;

  PlutoCellRendererContext({
    required this.column,
    required this.rowIdx,
    required this.row,
    required this.cell,
    required this.stateManager,
  });
}

class PlutoCell {
  PlutoCell({
    dynamic value,
    Key? key,
    this.renderer,
  })  : _key = key ?? UniqueKey(),
        _value = value,
        _originalValue = value;

  final Key _key;

  dynamic _value;

  final dynamic _originalValue;

  dynamic _valueForSorting;

  /// Custom renderer for this specific cell.
  /// If provided, this will be used instead of the column renderer.
  final PlutoCellRenderer? renderer;

  /// Returns true if this cell has a custom renderer.
  bool get hasRenderer => renderer != null;

  /// Set initial value according to [PlutoColumn] setting.
  ///
  /// [setColumn] is called when [PlutoGridStateManager.initializeRows] is called.
  /// When [setColumn] is called, this value is changed to `true` according to the column setting.
  /// If this value is `true` when the getter of [PlutoCell.value] is called,
  /// it calls [_applyFormatOnInit] to update the value according to the format.
  /// [_applyFormatOnInit] is called once, and if [setColumn] is not called again,
  /// it is not called anymore.
  bool _needToApplyFormatOnInit = false;

  PlutoColumn? _column;

  PlutoRow? _row;

  Key get key => _key;

  bool get initialized => _column != null && _row != null;

  PlutoColumn get column {
    _assertUnInitializedCell(_column != null);

    return _column!;
  }

  PlutoRow get row {
    _assertUnInitializedCell(_row != null);

    return _row!;
  }

  dynamic get value {
    if (_needToApplyFormatOnInit) {
      _applyFormatOnInit();
    }

    return _value;
  }

  dynamic get originalValue {
    return _originalValue;
  }

  set value(dynamic changed) {
    if (_value == changed) {
      return;
    }

    _value = changed;

    _valueForSorting = null;
  }

  dynamic get valueForSorting {
    _valueForSorting ??= _getValueForSorting();

    return _valueForSorting;
  }

  void setColumn(PlutoColumn column) {
    _column = column;
    _valueForSorting = _getValueForSorting();
    _needToApplyFormatOnInit = _column?.type.applyFormatOnInit == true;
  }

  void setRow(PlutoRow row) {
    _row = row;
  }

  dynamic _getValueForSorting() {
    if (_column == null) {
      return _value;
    }

    if (_needToApplyFormatOnInit) {
      _applyFormatOnInit();
    }

    return _column!.type.makeCompareValue(_value);
  }

  void _applyFormatOnInit() {
    _value = _column!.type.applyFormat(_value);

    if (_column!.type is PlutoColumnTypeWithNumberFormat) {
      _value =
          (_column!.type as PlutoColumnTypeWithNumberFormat).toNumber(_value);
    }

    _needToApplyFormatOnInit = false;
  }
}

_assertUnInitializedCell(bool flag) {
  assert(
    flag,
    'PlutoCell is not initialized.'
    'When adding a column or row, if it is not added through PlutoGridStateManager, '
    'PlutoCell does not set the necessary information at runtime.'
    'If you add a column or row through PlutoGridStateManager and this error occurs, '
    'please contact Github issue.',
  );
}
