import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

void main() {
  testWidgets(
    'When the dark constructor is called, the configuration should be created.',
    (WidgetTester tester) async {
      const PlutoGridConfiguration configuration = PlutoGridConfiguration.dark(
        style: PlutoGridStyleConfig(
          enableColumnBorderVertical: false,
        ),
      );

      expect(configuration.style.enableColumnBorderVertical, false);
    },
  );

  group('PlutoGridStyleConfig.copyWith', () {
    test('When oddRowColor is set to null, the value should be changed.', () {
      const style = PlutoGridStyleConfig(
        oddRowColor: Colors.cyan,
      );

      final copiedStyle = style.copyWith(
        oddRowColor: const PlutoOptional<Color?>(null),
      );

      expect(copiedStyle.oddRowColor, null);
    });

    test('When evenRowColor is set to null, the value should be changed.', () {
      const style = PlutoGridStyleConfig(
        evenRowColor: Colors.cyan,
      );

      final copiedStyle = style.copyWith(
        evenRowColor: const PlutoOptional<Color?>(null),
      );

      expect(copiedStyle.evenRowColor, null);
    });
  });

  group('PlutoGridColumnSizeConfig.copyWith', () {
    test('When autoSizeMode is set to scale, the value should be changed.', () {
      const size = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.none,
      );

      final copiedSize = size.copyWith(autoSizeMode: PlutoAutoSizeMode.scale);

      expect(copiedSize.autoSizeMode, PlutoAutoSizeMode.scale);
    });

    test('When resizeMode is set to pushAndPull, the value should be changed.',
        () {
      const size = PlutoGridColumnSizeConfig(
        resizeMode: PlutoResizeMode.normal,
      );

      final copiedSize = size.copyWith(resizeMode: PlutoResizeMode.pushAndPull);

      expect(copiedSize.resizeMode, PlutoResizeMode.pushAndPull);
    });
  });

  group('configuration', () {
    test(
        'When the values of configuration A and B are the same, the comparison should be true.',
        () {
      const configurationA = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      const configurationB = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      expect(configurationA == configurationB, true);
    });

    test(
        'When the values of configuration A and B are the same, the comparison should be true.',
        () {
      const configurationA = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      const configurationB = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      expect(configurationA.hashCode == configurationB.hashCode, true);
    });

    test(
        'When the enableMoveDownAfterSelecting value is different, the comparison should be false.',
        () {
      const configurationA = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      const configurationB = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: false,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      expect(configurationA == configurationB, false);
    });

    test(
        'When the isAlwaysShown value is different, the comparison should be false.',
        () {
      const configurationA = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      const configurationB = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: false,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'test',
        ),
      );

      expect(configurationA == configurationB, false);
    });

    test(
        'When the localeText value is different, the comparison should be false.',
        () {
      const configurationA = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: 'setColumnsTitle',
        ),
      );

      const configurationB = PlutoGridConfiguration(
        enableMoveDownAfterSelecting: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        style: PlutoGridStyleConfig(
          columnResizeIcon: IconData(0),
        ),
        scrollbar: PlutoGridScrollbarConfig(
          isAlwaysShown: true,
        ),
        localeText: PlutoGridLocaleText(
          setColumnsTitle: '컬럼제목설정',
        ),
      );

      expect(configurationA == configurationB, false);
    });
  });

  group('style', () {
    test(
        'When the values of style A and B are the same, the comparison should be true.',
        () {
      const styleA = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      const styleB = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      expect(styleA == styleB, true);
    });

    test(
        'When the values of style A and B are the same, the comparison should be true.',
        () {
      const styleA = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      const styleB = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      expect(styleA.hashCode == styleB.hashCode, true);
    });

    test(
        'When the enableGridBorderShadow value is different, the comparison should be false.',
        () {
      const styleA = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      const styleB = PlutoGridStyleConfig(
        enableGridBorderShadow: false,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      expect(styleA == styleB, false);
    });

    test(
        'When the oddRowColor value is different, the comparison should be false.',
        () {
      const styleA = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      const styleB = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.red,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      expect(styleA == styleB, false);
    });

    test(
        'When the gridBorderRadius value is different, the comparison should be false.',
        () {
      const styleA = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
      );

      const styleB = PlutoGridStyleConfig(
        enableGridBorderShadow: true,
        oddRowColor: Colors.lightGreen,
        columnTextStyle: TextStyle(fontSize: 20),
        rowGroupExpandedIcon: IconData(0),
        gridBorderRadius: BorderRadius.all(Radius.circular(15)),
      );

      expect(styleA == styleB, false);
    });
  });

  group('scrollbar', () {
    test(
        'When the values of scrollbar A and B are the same, the comparison should be true.',
        () {
      const scrollA = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarThicknessWhileDragging: 10,
      );

      const scrollB = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarThicknessWhileDragging: 10,
      );

      expect(scrollA == scrollB, true);
    });

    test(
        'When the values of scrollbar A and B are the same, the comparison should be true.',
        () {
      const scrollA = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarThicknessWhileDragging: 10,
      );

      const scrollB = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarThicknessWhileDragging: 10,
      );

      expect(scrollA.hashCode == scrollB.hashCode, true);
    });

    test(
        'When the isAlwaysShown value is different, the comparison should be false.',
        () {
      const scrollA = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarThicknessWhileDragging: 10,
      );

      const scrollB = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: false,
        scrollbarThicknessWhileDragging: 10,
      );

      expect(scrollA == scrollB, false);
    });

    test(
        'When the scrollbarRadiusWhileDragging value is different, the comparison should be false.',
        () {
      const scrollA = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarRadiusWhileDragging: Radius.circular(10),
      );

      const scrollB = PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        scrollbarRadiusWhileDragging: Radius.circular(11),
      );

      expect(scrollA == scrollB, false);
    });
  });

  group('columnFilter', () {
    test(
        'When the values of columnFilter A and B are the same, the comparison should be true.',
        () {
      const columnFilterA = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 300,
      );

      const columnFilterB = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 300,
      );

      expect(columnFilterA == columnFilterB, true);
    });

    test(
        'When the values of columnFilter A and B are the same, the comparison should be true.',
        () {
      const columnFilterA = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 300,
      );

      const columnFilterB = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 300,
      );

      expect(columnFilterA.hashCode == columnFilterB.hashCode, true);
    });

    test('When the filters value is different, the comparison should be false.',
        () {
      final columnFilterA = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ].reversed.toList(),
        debounceMilliseconds: 300,
      );

      const columnFilterB = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 300,
      );

      expect(columnFilterA == columnFilterB, false);
    });

    test(
        'When the debounceMilliseconds value is different, the comparison should be false.',
        () {
      const columnFilterA = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 300,
      );

      const columnFilterB = PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
        ],
        debounceMilliseconds: 301,
      );

      expect(columnFilterA == columnFilterB, false);
    });
  });

  group('columnSize', () {
    test(
        'When the properties of PlutoGridColumnSizeConfig are the same, the comparison should be true.',
        () {
      const sizeA = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode: PlutoResizeMode.none,
        restoreAutoSizeAfterHideColumn: true,
        restoreAutoSizeAfterFrozenColumn: false,
        restoreAutoSizeAfterMoveColumn: true,
        restoreAutoSizeAfterInsertColumn: false,
        restoreAutoSizeAfterRemoveColumn: false,
      );

      const sizeB = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode: PlutoResizeMode.none,
        restoreAutoSizeAfterHideColumn: true,
        restoreAutoSizeAfterFrozenColumn: false,
        restoreAutoSizeAfterMoveColumn: true,
        restoreAutoSizeAfterInsertColumn: false,
        restoreAutoSizeAfterRemoveColumn: false,
      );

      expect(sizeA == sizeB, true);
    });

    test(
        'When the properties of PlutoGridColumnSizeConfig are the same, the comparison should be true.',
        () {
      const sizeA = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode: PlutoResizeMode.none,
        restoreAutoSizeAfterHideColumn: true,
        restoreAutoSizeAfterFrozenColumn: false,
        restoreAutoSizeAfterMoveColumn: true,
        restoreAutoSizeAfterInsertColumn: false,
        restoreAutoSizeAfterRemoveColumn: false,
      );

      const sizeB = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode: PlutoResizeMode.none,
        restoreAutoSizeAfterHideColumn: true,
        restoreAutoSizeAfterFrozenColumn: false,
        restoreAutoSizeAfterMoveColumn: true,
        restoreAutoSizeAfterInsertColumn: false,
        restoreAutoSizeAfterRemoveColumn: false,
      );

      expect(sizeA.hashCode == sizeB.hashCode, true);
    });

    test(
        'When the properties of PlutoGridColumnSizeConfig are different, the comparison should be false.',
        () {
      const sizeA = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode: PlutoResizeMode.none,
        restoreAutoSizeAfterHideColumn: true,
        restoreAutoSizeAfterFrozenColumn: false,
        restoreAutoSizeAfterMoveColumn: true,
        restoreAutoSizeAfterInsertColumn: false,
        restoreAutoSizeAfterRemoveColumn: false,
      );

      const sizeB = PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode: PlutoResizeMode.none,
        restoreAutoSizeAfterHideColumn: true,
        restoreAutoSizeAfterFrozenColumn: false,
        restoreAutoSizeAfterMoveColumn: true,
        restoreAutoSizeAfterInsertColumn: false,
        restoreAutoSizeAfterRemoveColumn: true,
      );

      expect(sizeA == sizeB, false);
    });
  });

  group('locale', () {
    test(
        'When the values of locale A and B are the same, the comparison should be true.',
        () {
      const localeA = PlutoGridLocaleText(
        unfreezeColumn: 'Unfreeze',
        filterContains: 'Contains',
        loadingText: 'Loading',
      );

      const localeB = PlutoGridLocaleText(
        unfreezeColumn: 'Unfreeze',
        filterContains: 'Contains',
        loadingText: 'Loading',
      );

      expect(localeA == localeB, true);
    });

    test(
        'When the values of locale A and B are the same, the comparison should be true.',
        () {
      const localeA = PlutoGridLocaleText(
        unfreezeColumn: 'Unfreeze',
        filterContains: 'Contains',
        loadingText: 'Loading',
      );

      const localeB = PlutoGridLocaleText(
        unfreezeColumn: 'Unfreeze',
        filterContains: 'Contains',
        loadingText: 'Loading',
      );

      expect(localeA.hashCode == localeB.hashCode, true);
    });

    test(
        'When the values of locale A and B are different, the comparison should be false.',
        () {
      const localeA = PlutoGridLocaleText(
        unfreezeColumn: 'Unfreeze',
        filterContains: 'Contains',
        loadingText: 'Loading',
      );

      const localeB = PlutoGridLocaleText(
        unfreezeColumn: 'Unfreeze',
        filterContains: 'Contains',
        loadingText: 'Loading',
      );

      expect(localeA == localeB, false);
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.china();

      expect(locale.loadingText, '加载中');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.korean();

      expect(locale.loadingText, '로딩중');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.russian();

      expect(locale.loadingText, 'Загрузка');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.czech();

      expect(locale.loadingText, 'Načítání');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.brazilianPortuguese();

      expect(locale.loadingText, 'Carregando');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.spanish();

      expect(locale.loadingText, 'Cargando');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.persian();

      expect(locale.loadingText, 'در حال بارگیری');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.arabic();

      expect(locale.loadingText, 'جاري التحميل');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.norway();

      expect(locale.loadingText, 'Laster');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.german();

      expect(locale.loadingText, 'Lädt');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.turkish();

      expect(locale.loadingText, 'Yükleniyor');
    });

    test('When the locale is called, the value should be correct.', () {
      const locale = PlutoGridLocaleText.japanese();

      expect(locale.loadingText, 'にゃ〜');
    });
  });
}
