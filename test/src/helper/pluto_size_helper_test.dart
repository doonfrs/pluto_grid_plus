import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class _ResizeItem {
  _ResizeItem({
    required this.index,
    required this.size,
    required this.minSize,
    this.suppressed = false,
  });

  final int index;

  double size;

  final double minSize;

  final bool suppressed;
}

void main() {
  group('PlutoAutoSizeHelper', () {
    group('PlutoAutoSizeMode.none.', () {
      const mode = PlutoAutoSizeMode.none;

      test('mode to none should throw an exception.', () {
        expect(() {
          PlutoAutoSizeHelper.items<_ResizeItem>(
            maxSize: 100,
            items: [],
            isSuppressed: (i) => false,
            getItemSize: (i) => i.size,
            getItemMinSize: (i) => i.minSize,
            setItemSize: (i, size) => i.size = size,
            mode: mode,
          );
        }, throwsException);
      });
    });

    group('PlutoAutoSizeMode.equal.', () {
      const mode = PlutoAutoSizeMode.equal;

      test('The size of each item should be the same.', () {
        final items = [
          _ResizeItem(index: 0, size: 100, minSize: 50),
          _ResizeItem(index: 1, size: 120, minSize: 50),
          _ResizeItem(index: 2, size: 130, minSize: 50),
          _ResizeItem(index: 3, size: 140, minSize: 50),
          _ResizeItem(index: 4, size: 150, minSize: 50),
        ];

        PlutoAutoSizeHelper.items<_ResizeItem>(
          maxSize: 500,
          items: items,
          isSuppressed: (i) => i.suppressed,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        ).update();

        expect(items[0].size, 100);
        expect(items[1].size, 100);
        expect(items[2].size, 100);
        expect(items[3].size, 100);
        expect(items[4].size, 100);
      });

      test(
          'The sum of the minimum sizes of each item is less than maxSize, '
          'each item should be set to minSize.', () {
        final items = [
          _ResizeItem(index: 0, size: 100, minSize: 50),
          _ResizeItem(index: 1, size: 120, minSize: 50),
          _ResizeItem(index: 2, size: 130, minSize: 50),
          _ResizeItem(index: 3, size: 140, minSize: 50),
          _ResizeItem(index: 4, size: 150, minSize: 50),
        ];

        PlutoAutoSizeHelper.items<_ResizeItem>(
          maxSize: 200,
          items: items,
          isSuppressed: (i) => i.suppressed,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        ).update();

        expect(items[0].size, 50);
        expect(items[1].size, 50);
        expect(items[2].size, 50);
        expect(items[3].size, 50);
        expect(items[4].size, 50);
      });

      test('suppressed items do not change size.', () {
        final items = [
          _ResizeItem(index: 0, size: 100, minSize: 50),
          _ResizeItem(index: 1, size: 120, minSize: 50, suppressed: true),
          _ResizeItem(index: 2, size: 130, minSize: 50),
          _ResizeItem(index: 3, size: 140, minSize: 50, suppressed: true),
          _ResizeItem(index: 4, size: 150, minSize: 50, suppressed: true),
        ];

        PlutoAutoSizeHelper.items<_ResizeItem>(
          maxSize: 200,
          items: items,
          isSuppressed: (i) => i.suppressed,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        ).update();

        expect(items[0].size, 50);
        expect(items[1].size, 120);
        expect(items[2].size, 50);
        expect(items[3].size, 140);
        expect(items[4].size, 150);
      });
    });

    group('PlutoAutoSizeMode.scale.', () {
      const mode = PlutoAutoSizeMode.scale;

      test('The size of each item should be set according to the ratio.', () {
        final items = [
          _ResizeItem(index: 0, size: 100, minSize: 50),
          _ResizeItem(index: 1, size: 200, minSize: 50),
          _ResizeItem(index: 2, size: 200, minSize: 50),
          _ResizeItem(index: 3, size: 100, minSize: 50),
          _ResizeItem(index: 4, size: 100, minSize: 50),
        ];

        final double scale = 500 / items.fold(0, (p, e) => p + e.size);

        PlutoAutoSizeHelper.items<_ResizeItem>(
          maxSize: 500,
          items: items,
          isSuppressed: (i) => i.suppressed,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        ).update();

        expect(items[0].size, 100 * scale);
        expect(items[1].size, 200 * scale);
        expect(items[2].size, 200 * scale);
        expect(items[3].size, 100 * scale);
        expect(items[4].size, 100 * scale);
      });

      test(
          'The sum of the minimum sizes of each item is less than maxSize, '
          'each item should be set to minSize.', () {
        final items = [
          _ResizeItem(index: 0, size: 100, minSize: 50),
          _ResizeItem(index: 1, size: 200, minSize: 50),
          _ResizeItem(index: 2, size: 200, minSize: 50),
          _ResizeItem(index: 3, size: 100, minSize: 50),
          _ResizeItem(index: 4, size: 100, minSize: 50),
        ];

        PlutoAutoSizeHelper.items<_ResizeItem>(
          maxSize: 200,
          items: items,
          isSuppressed: (i) => i.suppressed,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        ).update();

        expect(items[0].size, 50);
        expect(items[1].size, 50);
        expect(items[2].size, 50);
        expect(items[3].size, 50);
        expect(items[4].size, 50);
      });

      test('suppressed  items do not change size.', () {
        final items = [
          _ResizeItem(index: 0, size: 100, minSize: 50),
          _ResizeItem(index: 1, size: 120, minSize: 50, suppressed: true),
          _ResizeItem(index: 2, size: 130, minSize: 50),
          _ResizeItem(index: 3, size: 140, minSize: 50, suppressed: true),
          _ResizeItem(index: 4, size: 150, minSize: 50, suppressed: true),
        ];

        // (전체 - suppressed 사이즈) / suppressed 가 아닌 아이템 사이즈
        const scale = (1000 - 410) / 230;

        PlutoAutoSizeHelper.items<_ResizeItem>(
          maxSize: 1000,
          items: items,
          isSuppressed: (i) => i.suppressed,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        ).update();

        expect(items[0].size, 100 * scale);
        expect(items[1].size, 120);
        expect(items[2].size, 130 * scale);
        expect(items[3].size, 140);
        expect(items[4].size, 150);
      });
    });
  });

  group('PlutoResizeHelper', () {
    group('PlutoResizeMode.none', () {
      const mode = PlutoResizeMode.none;

      test('When the mode is none, an exception should be thrown.', () {
        final items = <_ResizeItem>[];
        expect(() {
          PlutoResizeHelper.items<_ResizeItem>(
            offset: 0,
            items: items,
            isMainItem: (i) => i.index == 0,
            getItemSize: (i) => i.size,
            getItemMinSize: (i) => i.minSize,
            setItemSize: (i, size) => i.size = size,
            mode: mode,
          );
        }, throwsException);
      });
    });

    group('PlutoResizeMode.normal', () {
      const mode = PlutoResizeMode.normal;

      test('When the mode is normal, an exception should be thrown.', () {
        final items = <_ResizeItem>[];
        expect(() {
          PlutoResizeHelper.items<_ResizeItem>(
            offset: 0,
            items: items,
            isMainItem: (i) => i.index == 0,
            getItemSize: (i) => i.size,
            getItemMinSize: (i) => i.minSize,
            setItemSize: (i, size) => i.size = size,
            mode: mode,
          );
        }, throwsException);
      });
    });

    group('PlutoResizeMode.pushAndPull', () {
      const mode = PlutoResizeMode.pushAndPull;

      test(
          'When the mode is pushAndPull, '
          'the size of the 0th item increases by 10 and the size of the 1st item decreases by 10.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 10,
          items: items,
          isMainItem: (i) => i.index == 0,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 210);
        expect(items[1].size, 190);
        expect(items[2].size, 200);
        expect(items[3].size, 200);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 1st item increases by 10 and the size of the 2nd item decreases by 10.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 10,
          items: items,
          isMainItem: (i) => i.index == 1,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 210);
        expect(items[2].size, 190);
        expect(items[3].size, 200);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 3rd item increases by 10 and the size of the 4th item decreases by 10.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 10,
          items: items,
          isMainItem: (i) => i.index == 3,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 200);
        expect(items[2].size, 200);
        expect(items[3].size, 210);
        expect(items[4].size, 190);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 4th item increases by 10 and the size of the 3rd item decreases by 10.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 10,
          items: items,
          isMainItem: (i) => i.index == 4,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 200);
        expect(items[2].size, 200);
        expect(items[3].size, 190);
        expect(items[4].size, 210);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 4th item decreases by 10 and the size of the 3rd item increases by 10.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -10,
          items: items,
          isMainItem: (i) => i.index == 4,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 200);
        expect(items[2].size, 200);
        expect(items[3].size, 210);
        expect(items[4].size, 190);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 1st item decreases by 10 and the size of the 2nd item increases by 10.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -10,
          items: items,
          isMainItem: (i) => i.index == 1,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 190);
        expect(items[2].size, 210);
        expect(items[3].size, 200);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 1st item decreases to the minimum size, '
          'and the size of the 0th item decreases and the size of the 2nd item increases.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 80, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -10,
          items: items,
          isMainItem: (i) => i.index == 1,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 190);
        expect(items[1].size, 80);
        expect(items[2].size, 210);
        expect(items[3].size, 200);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 1st item decreases to the minimum size, '
          'and the size of the 0th item decreases and the size of the 2nd item increases.',
          () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 80, minSize: 80),
          _ResizeItem(index: 1, size: 80, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -10,
          items: items,
          isMainItem: (i) => i.index == 1,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), false);
        expect(items[0].size, 80);
        expect(items[1].size, 80);
        expect(items[2].size, 200);
        expect(items[3].size, 200);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 2nd item increases to the maximum size, '
          'and the left and right sizes are reduced to the minimum size.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 1000 - 320 - 200,
          items: items,
          isMainItem: (i) => i.index == 2,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 80);
        expect(items[1].size, 80);
        expect(items[2].size, 680);
        expect(items[3].size, 80);
        expect(items[4].size, 80);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 2nd item decreases to 40, '
          'and the size of the 3rd item decreases to 360, '
          'and the size of the 1st item decreases to 160.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -160,
          items: items,
          isMainItem: (i) => i.index == 2,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 160);
        expect(items[2].size, 80);
        expect(items[3].size, 360);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 0th item decreases to 40, '
          'and the size of the 1st item decreases to 320.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -160,
          items: items,
          isMainItem: (i) => i.index == 0,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 80);
        expect(items[1].size, 320);
        expect(items[2].size, 200);
        expect(items[3].size, 200);
        expect(items[4].size, 200);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 4th item decreases to 40, '
          'and the size of the 3rd item decreases to 320.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: -160,
          items: items,
          isMainItem: (i) => i.index == 4,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 200);
        expect(items[1].size, 200);
        expect(items[2].size, 200);
        expect(items[3].size, 320);
        expect(items[4].size, 80);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 0th item increases to the maximum size, '
          'and the remaining sizes are reduced to the minimum size.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 1000,
          items: items,
          isMainItem: (i) => i.index == 0,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 680);
        expect(items[1].size, 80);
        expect(items[2].size, 80);
        expect(items[3].size, 80);
        expect(items[4].size, 80);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 2nd item increases to the maximum size, '
          'and the remaining sizes are reduced to the minimum size.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 1000,
          items: items,
          isMainItem: (i) => i.index == 2,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 80);
        expect(items[1].size, 80);
        expect(items[2].size, 680);
        expect(items[3].size, 80);
        expect(items[4].size, 80);
      });

      test(
          'When the mode is pushAndPull, '
          'the size of the 4th item increases to the maximum size, '
          'and the remaining sizes are reduced to the minimum size.', () {
        final items = <_ResizeItem>[
          _ResizeItem(index: 0, size: 200, minSize: 80),
          _ResizeItem(index: 1, size: 200, minSize: 80),
          _ResizeItem(index: 2, size: 200, minSize: 80),
          _ResizeItem(index: 3, size: 200, minSize: 80),
          _ResizeItem(index: 4, size: 200, minSize: 80),
        ];

        final helper = PlutoResizeHelper.items<_ResizeItem>(
          offset: 1000,
          items: items,
          isMainItem: (i) => i.index == 4,
          getItemSize: (i) => i.size,
          getItemMinSize: (i) => i.minSize,
          setItemSize: (i, size) => i.size = size,
          mode: mode,
        );

        expect(helper.update(), true);
        expect(items[0].size, 80);
        expect(items[1].size, 80);
        expect(items[2].size, 80);
        expect(items[3].size, 80);
        expect(items[4].size, 680);
      });
    });
  });
}
