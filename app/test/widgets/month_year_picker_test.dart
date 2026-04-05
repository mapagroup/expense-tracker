import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/l10n/generated/app_localizations.dart';
import 'package:mapa_money/services/preferences_service.dart';
import 'package:mapa_money/widgets/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  group('MonthYearPicker dialog', () {
    Future<void> openPicker(
      WidgetTester tester, {
      DateTime? initialDate,
    }) async {
      final date = initialDate ?? DateTime(2025, 6);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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

    testWidgets('shows dialog with month grid and year', (tester) async {
      await openPicker(tester);
      expect(find.text('2025'), findsOneWidget);
      expect(find.text('Jun'), findsOneWidget);
    });

    testWidgets('displays the initial year', (tester) async {
      await openPicker(tester, initialDate: DateTime(2025, 3));
      expect(find.text('2025'), findsOneWidget);
    });

    testWidgets('displays abbreviated month names', (tester) async {
      await openPicker(tester);
      for (final month in [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ]) {
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

    testWidgets('Cancel closes dialog without returning value', (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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

    testWidgets('Select returns DateTime on the first day of chosen month', (
      tester,
    ) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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

    testWidgets('previous year button disabled at firstDate year', (
      tester,
    ) async {
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

    testWidgets('uses default firstDate and lastDate when not provided', (
      tester,
    ) async {
      // Covers the ?? DateTime(2020) and ?? DateTime.now() default branches
      // (lines 16–17 in month_year_picker.dart).
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showMonthYearPicker(
                context: context,
                initialDate: DateTime(2025, 4),
                // firstDate and lastDate intentionally omitted
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets(
      'navigating to previous year clamps month to December when needed',
      (tester) async {
        // Covers the `_selectedMonth = 12` branch (line 97).
        // Setup: firstDate = 2024-Aug, so Jan is not allowed in 2024.
        // Start at 2025-Jan, navigate left → 2024, Jan < Aug → clamp to Dec.
        DateTime? result;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showMonthYearPicker(
                    context: context,
                    initialDate: DateTime(2025, 1),
                    firstDate: DateTime(2024, 8),
                    lastDate: DateTime(2025, 12),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();
        expect(find.text('2024'), findsOneWidget);
        await tester.tap(find.text('Select'));
        await tester.pumpAndSettle();
        expect(result!.month, equals(12));
        expect(result!.year, equals(2024));
      },
    );

    testWidgets('navigating to next year clamps month to January when needed', (
      tester,
    ) async {
      // Covers the `_selectedMonth = 1` branch (line 115).
      // Setup: lastDate = 2025-Mar, so Dec is not allowed in 2025.
      // Start at 2024-Dec, navigate right → 2025, Dec > Mar → clamp to Jan.
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showMonthYearPicker(
                  context: context,
                  initialDate: DateTime(2024, 12),
                  firstDate: DateTime(2024, 1),
                  lastDate: DateTime(2025, 3),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('2025'), findsOneWidget);
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(result!.month, equals(1));
      expect(result!.year, equals(2025));
    });

    testWidgets('tapping a month button changes the selection', (tester) async {
      // Covers the onPressed lambda (line 137) — setState that updates _selectedMonth.
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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
      // Tap 'Nov' to change the selected month from June to November
      await tester.tap(find.text('Nov'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(result!.month, equals(11));
      expect(result!.year, equals(2025));
    });

    testWidgets('disabled months are shown and Select is disabled for them', (
      tester,
    ) async {
      // Covers the disabled-foreground-color branch (line 137) and the
      // null onPressed branch of the Select button (line 147).
      // Setup: initialDate = 2025-Jan, firstDate = 2025-Apr.
      // Jan / Feb / Mar are disabled; the initially selected month (Jan) is
      // not allowed → Select button onPressed must be null.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showMonthYearPicker(
                context: context,
                initialDate: DateTime(2025, 1),
                firstDate: DateTime(2025, 4),
                lastDate: DateTime(2025, 12),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Select button should be disabled because Jan is not allowed
      final selectBtn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Select'),
      );
      expect(selectBtn.onPressed, isNull);

      // Jan, Feb, Mar buttons should be disabled (onPressed == null)
      final janBtn = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Jan'),
      );
      expect(janBtn.onPressed, isNull);
    });

    // ── Year-picker tests ────────────────────────────────────────────────────

    testWidgets('tapping year text opens the year grid', (tester) async {
      await openPicker(tester, initialDate: DateTime(2025, 6));
      // Tap the year label to open the year picker
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      // Month buttons should be gone; Select button should be hidden
      expect(find.text('Jun'), findsNothing);
      expect(find.text('Select'), findsNothing);
      // The year grid shows years including the selected one
      expect(find.text('2025'), findsWidgets);
    });

    testWidgets('year grid shows firstDate and lastDate years', (tester) async {
      await openPicker(tester, initialDate: DateTime(2025, 6));
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      expect(find.text('2020'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
    });

    testWidgets('selecting a year from grid returns to month picker', (
      tester,
    ) async {
      await openPicker(tester, initialDate: DateTime(2025, 6));
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      // Tap year 2022 in the grid
      await tester.tap(find.text('2022'));
      await tester.pumpAndSettle();
      // Should be back on month picker showing 2022
      expect(find.text('2022'), findsOneWidget);
      expect(find.text('Jun'), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('selecting year returns correct DateTime', (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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
      // Open year picker, pick 2023
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2023'));
      await tester.pumpAndSettle();
      // Now select — June is still selected and allowed
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(result?.year, equals(2023));
      expect(result?.month, equals(6));
    });

    testWidgets(
      'selecting firstDate year clamps month to firstDate.month when needed',
      (tester) async {
        // firstDate = 2020-Aug. Start at 2025-Jan. Open year picker, pick 2020.
        // Jan < Aug → month should clamp to Aug (firstDate.month).
        DateTime? result;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showMonthYearPicker(
                    context: context,
                    initialDate: DateTime(2025, 1),
                    firstDate: DateTime(2020, 8),
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
        await tester.tap(find.text('2025'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('2020'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Select'));
        await tester.pumpAndSettle();
        expect(result?.year, equals(2020));
        expect(result?.month, equals(8));
      },
    );

    testWidgets('selecting non-firstDate year clamps month to 1 when needed', (
      tester,
    ) async {
      // lastDate = 2025-Mar. Start at 2026-Dec. Open year picker, pick 2025.
      // Dec > Mar → month should clamp to 1. 2025 != firstDate.year.
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showMonthYearPicker(
                  context: context,
                  initialDate: DateTime(2026, 12),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025, 3),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(result?.year, equals(2025));
      expect(result?.month, equals(1));
    });

    testWidgets('Cancel closes dialog from year picker view', (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isNull);
    });
  });
}
