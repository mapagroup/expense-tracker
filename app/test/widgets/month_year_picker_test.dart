import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_vault/widgets/month_year_picker.dart';

void main() {
  group('MonthYearPicker dialog', () {
    Future<void> openPicker(
      WidgetTester tester, {
      DateTime? initialDate,
    }) async {
      final date = initialDate ?? DateTime(2025, 6);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showMonthYearPicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2026, 12),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows dialog with title text', (tester) async {
      await openPicker(tester);
      expect(
        find.text('Select month and year to filter expenses'),
        findsOneWidget,
      );
    });

    testWidgets('displays the initial year', (tester) async {
      await openPicker(tester, initialDate: DateTime(2025, 3));
      expect(find.text('2025'), findsOneWidget);
    });

    testWidgets('displays abbreviated month names', (tester) async {
      await openPicker(tester);
      for (final month in ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']) {
        expect(find.text(month), findsOneWidget);
      }
    });

    testWidgets('can navigate to next year', (tester) async {
      await openPicker(tester, initialDate: DateTime(2024, 1));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('2025'), findsOneWidget);
    });

    testWidgets('can navigate to previous year', (tester) async {
      await openPicker(tester, initialDate: DateTime(2025, 1));
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('2024'), findsOneWidget);
    });

    testWidgets('Cancel closes dialog without returning value',
        (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showMonthYearPicker(
                  context: context,
                  initialDate: DateTime(2025, 6),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2026, 12),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isNull);
    });

    testWidgets('Select returns DateTime on the first day of chosen month',
        (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showMonthYearPicker(
                  context: context,
                  initialDate: DateTime(2025, 6),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2026, 12),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(result!.month, equals(6));
      expect(result!.year, equals(2025));
      expect(result!.day, equals(1));
    });

    testWidgets('previous year button disabled at firstDate year',
        (tester) async {
      await openPicker(tester, initialDate: DateTime(2020, 5));
      final chevronLeft = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left),
      );
      expect(chevronLeft.onPressed, isNull);
    });

    testWidgets('next year button disabled at lastDate year', (tester) async {
      await openPicker(tester, initialDate: DateTime(2026, 5));
      final chevronRight = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(chevronRight.onPressed, isNull);
    });
  });
}
