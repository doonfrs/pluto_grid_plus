import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

void main() {
  testWidgets(
    'Child should be rendered',
    (WidgetTester tester) async {
      // given
      const child = Text('child widget');

      // when
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: PlutoShadowContainer(width: 100, height: 50, child: child),
          ),
        ),
      );

      // then
      expect(find.text('child widget'), findsOneWidget);
    },
  );
}
