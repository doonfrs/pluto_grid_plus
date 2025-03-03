import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

/// Strategy interface for pagination implementations
abstract class PlutoLazyPaginationStrategy {
  Widget build(
    BuildContext context,
    PlutoLazyPaginationState state,
  );

  /// Optional method to provide a default page size
  int? getInitialPageSize() => null;
}

/// Default strategy (original implementation)
class DefaultPlutoLazyPaginationStrategy
    implements PlutoLazyPaginationStrategy {
  const DefaultPlutoLazyPaginationStrategy({
    this.pageSizeToMove,
  });

  /// Set the number of moves to the previous or next page button.
  final int? pageSizeToMove;

  @override
  Widget build(
    BuildContext context,
    PlutoLazyPaginationState state,
  ) {
    return _PaginationWidget(
      iconColor: state.stateManager.style.iconColor,
      disabledIconColor: state.stateManager.style.disabledIconColor,
      activatedColor: state.stateManager.style.activatedBorderColor,
      iconSize: state.stateManager.style.iconSize,
      height: state.stateManager.footerHeight,
      page: state.page,
      totalPage: state.totalPage,
      pageSizeToMove: pageSizeToMove,
      setPage: state.setPage,
    );
  }

  @override
  int? getInitialPageSize() => null;
}

/// Strategy with page size dropdown
class PageSizeDropdownPlutoLazyPaginationStrategy
    implements PlutoLazyPaginationStrategy {
  PageSizeDropdownPlutoLazyPaginationStrategy({
    this.pageSizeToMove,
    this.pageSizes = const [10, 20, 30, 50, 100],
    this.initialPageSize,
    this.onPageSizeChanged,
    this.dropdownDecoration,
    this.dropdownItemDecoration,
    this.pageSizeDropdownIcon,
  }) : assert(initialPageSize == null || pageSizes.contains(initialPageSize),
            'initialPageSize must be included in pageSizes list');

  /// Set the number of moves to the previous or next page button.
  final int? pageSizeToMove;

  /// Available page sizes in dropdown
  final List<int> pageSizes;

  /// Default page size to use if initialPageSize is not set in PlutoLazyPagination
  final int? initialPageSize;

  /// Callback when page size changes
  final void Function(int pageSize)? onPageSizeChanged;

  /// Decoration for the dropdown button
  final BoxDecoration? dropdownDecoration;

  /// Decoration for dropdown items
  final BoxDecoration? dropdownItemDecoration;

  /// Icon for the dropdown
  final Icon? pageSizeDropdownIcon;

  @override
  Widget build(
    BuildContext context,
    PlutoLazyPaginationState state,
  ) {
    return _PageSizeDropdownPaginationWidget(
      iconColor: state.stateManager.style.iconColor,
      disabledIconColor: state.stateManager.style.disabledIconColor,
      activatedColor: state.stateManager.style.activatedBorderColor,
      iconSize: state.stateManager.style.iconSize,
      height: state.stateManager.footerHeight,
      page: state.page,
      totalPage: state.totalPage,
      pageSizeToMove: pageSizeToMove,
      setPage: state.setPage,
      pageSizes: pageSizes,
      currentPageSize: state.pageSize,
      onPageSizeChanged: (size) {
        state.setPageSize(size);
        if (onPageSizeChanged != null) {
          onPageSizeChanged!(size);
        }
      },
      dropdownDecoration: dropdownDecoration,
      dropdownItemDecoration: dropdownItemDecoration,
      pageSizeDropdownIcon: pageSizeDropdownIcon,
    );
  }

  @override
  int? getInitialPageSize() => initialPageSize;
}

/// Callback function to implement to add lazy pagination data.
typedef PlutoLazyPaginationFetch = Future<PlutoLazyPaginationResponse> Function(
    PlutoLazyPaginationRequest);

/// Request data for lazy pagination processing.
class PlutoLazyPaginationRequest {
  PlutoLazyPaginationRequest({
    required this.page,
    this.pageSize = 10,
    this.sortColumn,
    this.filterRows = const <PlutoRow>[],
  });

  /// Request page.
  final int page;

  /// Page size (items per page)
  final int pageSize;

  /// If the sort condition is set, the column for which the sort is set.
  /// The value of [PlutoColumn.sort] is the sort status of the column.
  final PlutoColumn? sortColumn;

  /// Filtering status when filtering conditions are set.
  ///
  /// If this list is empty, filtering is not set.
  /// Filtering column, type, and filtering value are set in [PlutoRow.cells].
  ///
  /// [filterRows] can be converted to Map type as shown below.
  /// ```dart
  /// FilterHelper.convertRowsToMap(filterRows);
  ///
  /// // Assuming that filtering is set in column2, the following values are returned.
  /// // {column2: [{Contains: 123}]}
  /// ```
  ///
  /// The filter type in FilterHelper.defaultFilters is the default,
  /// If there is user-defined filtering,
  /// the title set by the user is returned as the filtering type.
  /// All filtering can change the value returned as a filtering type by changing the name property.
  /// In case of PlutoFilterTypeContains filter, if you change the static type name to include
  /// PlutoFilterTypeContains.name = 'include';
  /// {column2: [{include: abc}, {include: 123}]} will be returned.
  final List<PlutoRow> filterRows;
}

/// Response data for lazy pagination.
class PlutoLazyPaginationResponse {
  PlutoLazyPaginationResponse({
    required this.totalPage,
    required this.rows,
  });

  /// Total number of pages to create pagination buttons.
  final int totalPage;

  /// Rows to be added.
  final List<PlutoRow> rows;
}

/// Widget for processing lazy pagination.
///
/// ```dart
/// createFooter: (stateManager) {
///   return PlutoLazyPagination(
///     fetch: fetch,
///     stateManager: stateManager,
///   );
/// },
/// ```
class PlutoLazyPagination extends StatefulWidget {
  const PlutoLazyPagination({
    this.initialPage = 1,
    this.initialPageSize,
    this.initialFetch = true,
    this.fetchWithSorting = true,
    this.fetchWithFiltering = true,
    this.pageSizeToMove,
    this.strategy,
    required this.fetch,
    required this.stateManager,
    super.key,
  });

  /// Set the first page.
  final int initialPage;

  /// Set the initial page size (optional, will use strategy's default if not provided)
  final int? initialPageSize;

  /// Decide whether to call the fetch function first.
  final bool initialFetch;

  /// Decide whether to handle sorting in the fetch function.
  /// Default is true.
  /// If this value is false, the list is sorted with the current grid loaded.
  final bool fetchWithSorting;

  /// Decide whether to handle filtering in the fetch function.
  /// Default is true.
  /// If this value is false,
  /// the list is filtered while it is currently loaded in the grid.
  final bool fetchWithFiltering;

  /// Set the number of moves to the previous or next page button.
  ///
  /// Default is null.
  /// Moves the page as many as the number of page buttons currently displayed.
  ///
  /// If this value is set to 1, the next previous page is moved by one page.
  final int? pageSizeToMove;

  /// Strategy to use for pagination widget UI
  final PlutoLazyPaginationStrategy? strategy;

  /// A callback function that returns the data to be added.
  final PlutoLazyPaginationFetch fetch;

  final PlutoGridStateManager stateManager;

  @override
  State<PlutoLazyPagination> createState() => PlutoLazyPaginationState();
}

class PlutoLazyPaginationState extends State<PlutoLazyPagination> {
  late final StreamSubscription<PlutoGridEvent> _events;

  int _page = 1;
  late int _pageSize;
  int _totalPage = 0;
  bool _isFetching = false;

  PlutoGridStateManager get stateManager => widget.stateManager;

  // Expose state for strategy pattern
  int get page => _page;
  int get pageSize => _pageSize;
  int get totalPage => _totalPage;

  @override
  void initState() {
    super.initState();

    _page = widget.initialPage;

    // Determine page size from initialPageSize or strategy
    _initializePageSize();

    if (widget.fetchWithSorting) {
      stateManager.setSortOnlyEvent(true);
    }

    if (widget.fetchWithFiltering) {
      stateManager.setFilterOnlyEvent(true);
    }

    _events = stateManager.eventManager!.listener(_eventListener);

    if (widget.initialFetch) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setPage(widget.initialPage);
      });
    }
  }

  void _initializePageSize() {
    int? widgetInitialPageSize = widget.initialPageSize;
    int? strategyInitialPageSize = widget.strategy?.getInitialPageSize();

    int? pageSize = strategyInitialPageSize ?? widgetInitialPageSize;

    if (pageSize != null) {
      if (widget.strategy is PageSizeDropdownPlutoLazyPaginationStrategy) {
        final dropdownStrategy =
            widget.strategy as PageSizeDropdownPlutoLazyPaginationStrategy;

        if (!dropdownStrategy.pageSizes.contains(pageSize)) {
          throw AssertionError(
            'initialPageSize (${widget.initialPageSize}) must be included in the pageSizes list of PageSizeDropdownPlutoLazyPaginationStrategy (${dropdownStrategy.pageSizes})',
          );
        }
      }
    }

    _pageSize = pageSize ?? 10;
  }

  @override
  void dispose() {
    _events.cancel();

    super.dispose();
  }

  void _eventListener(PlutoGridEvent event) {
    if (event is PlutoGridChangeColumnSortEvent ||
        event is PlutoGridSetColumnFilterEvent) {
      setPage(1);
    }
  }

  void setPage(int page) async {
    if (_isFetching) return;

    _isFetching = true;

    stateManager.setShowLoading(true, level: PlutoGridLoadingLevel.rows);

    widget
        .fetch(
      PlutoLazyPaginationRequest(
        page: page,
        pageSize: _pageSize,
        sortColumn: stateManager.getSortedColumn,
        filterRows: stateManager.filterRows,
      ),
    )
        .then((data) {
      if (!mounted) return;
      stateManager.scroll.bodyRowsVertical!.jumpTo(0);

      stateManager.refRows.clearFromOriginal();
      stateManager.insertRows(0, data.rows);

      setState(() {
        _page = page;
        _totalPage = data.totalPage;
        _isFetching = false;
      });

      stateManager.setShowLoading(false);
    });
  }

  void setPageSize(int size) {
    if (_pageSize == size) return;

    setState(() {
      _pageSize = size;
    });

    // Reset to first page with new page size
    setPage(1);
  }

  @override
  Widget build(BuildContext context) {
    // Use provided strategy or default to original implementation
    final strategy = widget.strategy ??
        DefaultPlutoLazyPaginationStrategy(
          pageSizeToMove: widget.pageSizeToMove,
        );

    return strategy.build(context, this);
  }
}

class _PaginationWidget extends StatefulWidget {
  const _PaginationWidget({
    required this.iconColor,
    required this.disabledIconColor,
    required this.activatedColor,
    required this.iconSize,
    required this.height,
    this.page = 1,
    required this.totalPage,
    this.pageSizeToMove,
    required this.setPage,
  });

  final Color iconColor;
  final Color disabledIconColor;
  final Color activatedColor;
  final double iconSize;
  final double height;
  final int page;
  final int totalPage;
  final int? pageSizeToMove;
  final void Function(int page) setPage;

  @override
  State<_PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<_PaginationWidget> {
  double _maxWidth = 0;

  final _iconSplashRadius = PlutoGridSettings.rowHeight / 2;

  bool get _isFirstPage => widget.page < 2;

  bool get _isLastPage => widget.page > widget.totalPage - 1;

  /// maxWidth < 450 : 1
  /// maxWidth >= 450 : 3
  /// maxWidth >= 550 : 5
  /// maxWidth >= 650 : 7
  int get _itemSize {
    final countItemSize = ((_maxWidth - 350) / 100).floor();

    return countItemSize < 0 ? 0 : min(countItemSize, 3);
  }

  int get _startPage {
    final itemSizeGap = _itemSize + 1;

    var start = widget.page - itemSizeGap;

    if (widget.page + _itemSize > widget.totalPage) {
      start -= _itemSize + widget.page - widget.totalPage;
    }

    return start < 0 ? 0 : start;
  }

  int get _endPage {
    final itemSizeGap = _itemSize + 1;

    var end = widget.page + _itemSize;

    if (widget.page - itemSizeGap < 0) {
      end += itemSizeGap - widget.page;
    }

    return end > widget.totalPage ? widget.totalPage : end;
  }

  List<int> get _pageNumbers {
    return List.generate(
      _endPage - _startPage,
      (index) => _startPage + index,
      growable: false,
    );
  }

  int get _pageSizeToMove {
    if (widget.pageSizeToMove == null) {
      return 1 + (_itemSize * 2);
    }

    return widget.pageSizeToMove!;
  }

  void _firstPage() {
    _movePage(1);
  }

  void _beforePage() {
    int beforePage = widget.page - _pageSizeToMove;

    if (beforePage < 1) {
      beforePage = 1;
    }

    _movePage(beforePage);
  }

  void _nextPage() {
    int nextPage = widget.page + _pageSizeToMove;

    if (nextPage > widget.totalPage) {
      nextPage = widget.totalPage;
    }

    _movePage(nextPage);
  }

  void _lastPage() {
    _movePage(widget.totalPage);
  }

  void _movePage(int page) {
    widget.setPage(page);
  }

  ButtonStyle _getNumberButtonStyle(bool isCurrentIndex) {
    return TextButton.styleFrom(
      disabledForegroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
      backgroundColor: Colors.transparent,
    );
  }

  TextStyle _getNumberTextStyle(bool isCurrentIndex) {
    return TextStyle(
      fontSize: isCurrentIndex ? widget.iconSize : null,
      color: isCurrentIndex ? widget.activatedColor : widget.iconColor,
    );
  }

  Widget _makeNumberButton(int index) {
    var pageFromIndex = index + 1;

    var isCurrentIndex = widget.page == pageFromIndex;

    return TextButton(
      onPressed: () {
        _movePage(pageFromIndex);
      },
      style: _getNumberButtonStyle(isCurrentIndex),
      child: Text(
        pageFromIndex.toString(),
        style: _getNumberTextStyle(isCurrentIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, size) {
        _maxWidth = size.maxWidth;

        return SizedBox(
          width: size.maxWidth,
          height: widget.height,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    onPressed: _isFirstPage ? null : _firstPage,
                    icon: const Icon(Icons.first_page),
                    color: widget.iconColor,
                    disabledColor: widget.disabledIconColor,
                    splashRadius: _iconSplashRadius,
                    mouseCursor: _isFirstPage
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                  ),
                  IconButton(
                    onPressed: _isFirstPage ? null : _beforePage,
                    icon: const Icon(Icons.navigate_before),
                    color: widget.iconColor,
                    disabledColor: widget.disabledIconColor,
                    splashRadius: _iconSplashRadius,
                    mouseCursor: _isFirstPage
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                  ),
                  ..._pageNumbers.map(_makeNumberButton),
                  IconButton(
                    onPressed: _isLastPage ? null : _nextPage,
                    icon: const Icon(Icons.navigate_next),
                    color: widget.iconColor,
                    disabledColor: widget.disabledIconColor,
                    splashRadius: _iconSplashRadius,
                    mouseCursor: _isLastPage
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                  ),
                  IconButton(
                    onPressed: _isLastPage ? null : _lastPage,
                    icon: const Icon(Icons.last_page),
                    color: widget.iconColor,
                    disabledColor: widget.disabledIconColor,
                    splashRadius: _iconSplashRadius,
                    mouseCursor: _isLastPage
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget with page size dropdown
class _PageSizeDropdownPaginationWidget extends StatefulWidget {
  const _PageSizeDropdownPaginationWidget({
    required this.iconColor,
    required this.disabledIconColor,
    required this.activatedColor,
    required this.iconSize,
    required this.height,
    required this.page,
    required this.totalPage,
    this.pageSizeToMove,
    required this.setPage,
    required this.pageSizes,
    required this.currentPageSize,
    required this.onPageSizeChanged,
    this.dropdownDecoration,
    this.dropdownItemDecoration,
    this.pageSizeDropdownIcon,
  });

  final Color iconColor;
  final Color disabledIconColor;
  final Color activatedColor;
  final double iconSize;
  final double height;
  final int page;
  final int totalPage;
  final int? pageSizeToMove;
  final void Function(int page) setPage;
  final List<int> pageSizes;
  final int currentPageSize;
  final void Function(int) onPageSizeChanged;
  final BoxDecoration? dropdownDecoration;
  final BoxDecoration? dropdownItemDecoration;
  final Icon? pageSizeDropdownIcon;

  @override
  State<_PageSizeDropdownPaginationWidget> createState() =>
      _PageSizeDropdownPaginationWidgetState();
}

class _PageSizeDropdownPaginationWidgetState
    extends State<_PageSizeDropdownPaginationWidget> {
  double _maxWidth = 0;

  final _iconSplashRadius = PlutoGridSettings.rowHeight / 2;

  bool get _isFirstPage => widget.page < 2;

  bool get _isLastPage => widget.page > widget.totalPage - 1;

  int get _itemSize {
    final countItemSize = ((_maxWidth - 350) / 100).floor();
    return countItemSize < 0 ? 0 : min(countItemSize, 3);
  }

  int get _startPage {
    final itemSizeGap = _itemSize + 1;
    var start = widget.page - itemSizeGap;
    if (widget.page + _itemSize > widget.totalPage) {
      start -= _itemSize + widget.page - widget.totalPage;
    }
    return start < 0 ? 0 : start;
  }

  int get _endPage {
    final itemSizeGap = _itemSize + 1;
    var end = widget.page + _itemSize;
    if (widget.page - itemSizeGap < 0) {
      end += itemSizeGap - widget.page;
    }
    return end > widget.totalPage ? widget.totalPage : end;
  }

  List<int> get _pageNumbers {
    return List.generate(
      _endPage - _startPage,
      (index) => _startPage + index,
      growable: false,
    );
  }

  int get _pageSizeToMove {
    return widget.pageSizeToMove ?? 1;
  }

  void _firstPage() {
    _movePage(1);
  }

  void _beforePage() {
    int beforePage = widget.page - _pageSizeToMove;
    if (beforePage < 1) {
      beforePage = 1;
    }
    _movePage(beforePage);
  }

  void _nextPage() {
    int nextPage = widget.page + _pageSizeToMove;
    if (nextPage > widget.totalPage) {
      nextPage = widget.totalPage;
    }
    _movePage(nextPage);
  }

  void _lastPage() {
    _movePage(widget.totalPage);
  }

  void _movePage(int page) {
    widget.setPage(page);
  }

  ButtonStyle _getNumberButtonStyle(bool isCurrentIndex) {
    return TextButton.styleFrom(
      disabledForegroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
      backgroundColor: Colors.transparent,
    );
  }

  TextStyle _getNumberTextStyle(bool isCurrentIndex) {
    return TextStyle(
      fontSize: isCurrentIndex ? widget.iconSize : null,
      color: isCurrentIndex ? widget.activatedColor : widget.iconColor,
    );
  }

  Widget _makeNumberButton(int index) {
    var pageFromIndex = index + 1;
    var isCurrentIndex = widget.page == pageFromIndex;
    return TextButton(
      onPressed: () {
        _movePage(pageFromIndex);
      },
      style: _getNumberButtonStyle(isCurrentIndex),
      child: Text(
        pageFromIndex.toString(),
        style: _getNumberTextStyle(isCurrentIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, size) {
        _maxWidth = size.maxWidth;

        return SizedBox(
          width: size.maxWidth,
          height: widget.height,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _firstPageIconButton(),
                    _beforePageIconButton(),
                    ..._pageNumbers.map(_makeNumberButton),
                    _nextPageIconButton(),
                    _lastPageIconButton(),
                  ]),
                ),
                const Spacer(),
                _pagesDropdownButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  IconButton _lastPageIconButton() {
    return IconButton(
      onPressed: _isLastPage ? null : _lastPage,
      icon: const Icon(Icons.last_page),
      color: widget.iconColor,
      disabledColor: widget.disabledIconColor,
      splashRadius: _iconSplashRadius,
      mouseCursor:
          _isLastPage ? SystemMouseCursors.basic : SystemMouseCursors.click,
    );
  }

  IconButton _nextPageIconButton() {
    return IconButton(
      onPressed: _isLastPage ? null : _nextPage,
      icon: const Icon(Icons.navigate_next),
      color: widget.iconColor,
      disabledColor: widget.disabledIconColor,
      splashRadius: _iconSplashRadius,
      mouseCursor:
          _isLastPage ? SystemMouseCursors.basic : SystemMouseCursors.click,
    );
  }

  IconButton _beforePageIconButton() {
    return IconButton(
      onPressed: _isFirstPage ? null : _beforePage,
      icon: const Icon(Icons.navigate_before),
      color: widget.iconColor,
      disabledColor: widget.disabledIconColor,
      splashRadius: _iconSplashRadius,
      mouseCursor:
          _isFirstPage ? SystemMouseCursors.basic : SystemMouseCursors.click,
    );
  }

  IconButton _firstPageIconButton() {
    return IconButton(
      onPressed: _isFirstPage ? null : _firstPage,
      icon: const Icon(Icons.first_page),
      color: widget.iconColor,
      disabledColor: widget.disabledIconColor,
      splashRadius: _iconSplashRadius,
      mouseCursor:
          _isFirstPage ? SystemMouseCursors.basic : SystemMouseCursors.click,
    );
  }

  Container _pagesDropdownButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: widget.dropdownDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<int>(
        value: widget.currentPageSize,
        icon: widget.pageSizeDropdownIcon ?? const Icon(Icons.arrow_drop_down),
        iconSize: widget.iconSize,
        elevation: 16,
        style: TextStyle(color: widget.iconColor),
        underline: Container(height: 0),
        onChanged: (int? newValue) {
          if (newValue != null) {
            widget.onPageSizeChanged(newValue);
          }
        },
        items: widget.pageSizes.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Container(
              decoration: widget.dropdownItemDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("$value / page"),
            ),
          );
        }).toList(),
      ),
    );
  }
}
