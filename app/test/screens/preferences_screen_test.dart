import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/l10n/generated/app_localizations.dart';
import 'package:mapa_money/screens/preferences_screen.dart';
import 'package:mapa_money/services/preferences_service.dart';
import 'package:mapa_money/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  group('PreferencesScreen', () {
    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PreferencesScreen(),
      );
    }

    testWidgets('renders AppBar with Preferences title', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Preferences'), findsOneWidget);
    });

    testWidgets('shows Display section header', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('DISPLAY'), findsOneWidget);
    });

    testWidgets('shows Regional section header', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('REGIONAL'), findsOneWidget);
    });

    testWidgets('shows Data Entry section header', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('DATA ENTRY'), findsOneWidget);
    });

    testWidgets('shows Theme tile', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Theme'), findsOneWidget);
    });

    testWidgets('shows Decimal Places tile', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Decimal Places'), findsOneWidget);
    });

    testWidgets('shows Currency tile', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Currency'), findsOneWidget);
    });

    testWidgets('shows Language tile', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('tapping Theme tile opens dialog with theme options',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();
      // 'Dark' only appears inside the dialog (the tile subtitle shows 'Default')
      expect(find.text('Dark'), findsOneWidget);
      // Both radio options exist
      expect(find.byType(RadioListTile<ThemeMode>), findsNWidgets(2));
    });

    testWidgets('tapping Decimal Places tile opens dialog', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Decimal Places'));
      await tester.pumpAndSettle();
      // Dialog shows 0, 1, 2 decimal place options
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('tapping Currency tile opens currency picker dialog',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Currency'));
      await tester.pumpAndSettle();
      // Dialog should show search field hint text
      expect(find.text('Search currencies…'), findsOneWidget);
    });

    testWidgets('tapping Language tile opens dialog with language options',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      // Hindi only appears in the dialog, not as a tile subtitle
      expect(find.text('हिन्दी (Hindi)'), findsOneWidget);
    });
  });

  // ── Interaction tests (dialog OK/Cancel, listener, dispose) ──────────────

  group('PreferencesScreen interactions', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PreferencesService().init();
    });

    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PreferencesScreen(),
      );
    }

    testWidgets('theme dialog OK commits selected theme', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(RadioListTile<ThemeMode>, 'Dark'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(PreferencesService().themeMode, ThemeMode.dark);
    });

    testWidgets('theme dialog Cancel leaves theme unchanged', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(PreferencesService().themeMode, ThemeMode.light);
    });

    testWidgets('decimal dialog OK commits selected decimal places',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Decimal Places'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(RadioListTile<int>, '0'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(PreferencesService().decimalPlaces, 0);
    });

    testWidgets('decimal dialog Cancel leaves decimal places unchanged',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Decimal Places'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(PreferencesService().decimalPlaces, 2);
    });

    testWidgets('currency picker search filters results', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Currency'));
      await tester.pumpAndSettle();

      // Type to trigger _onSearch filtered path
      await tester.enterText(find.byType(TextField), 'US Dollar');
      await tester.pumpAndSettle();

      // The ListTile for US Dollar appears in the filtered list
      expect(find.widgetWithText(ListTile, 'US Dollar'), findsOneWidget);
    });

    testWidgets('currency picker tapping a currency saves the code',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Currency'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'US Dollar');
      await tester.pumpAndSettle();

      // Tap the ListTile (not the search field which also contains the text)
      await tester.tap(find.widgetWithText(ListTile, 'US Dollar'));
      await tester.pumpAndSettle();

      expect(PreferencesService().currencyCode, 'USD');
    });

    testWidgets('currency picker shows check icon for current currency',
        (tester) async {
      // Default currency is INR; search for it so the row is visible
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Currency'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'INR');
      await tester.pumpAndSettle();

      // The check icon renders for the selected currency row
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('currency picker Cancel closes dialog without saving',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Currency'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(PreferencesService().currencyCode, 'INR');
    });

    testWidgets('language dialog OK commits selected language', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('हिन्दी (Hindi)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(PreferencesService().languageCode, 'hi');
    });

    testWidgets('language dialog Cancel leaves language unchanged',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('हिन्दी (Hindi)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(PreferencesService().languageCode, 'en');
    });

    testWidgets('language dialog OK with same language does not change pref',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // English is already selected; tap OK without changing
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(PreferencesService().languageCode, 'en');
    });

    testWidgets('external preference change rebuilds widget via listener',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Default'), findsOneWidget);

      // Change preference externally — triggers _rebuild via addListener
      await PreferencesService().setThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();

      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('widget dispose removes preference listener', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Replace widget tree to trigger dispose()
      await tester.pumpWidget(
        const MaterialApp(home: SizedBox.shrink()),
      );
      await tester.pumpAndSettle();

      // Changing prefs after dispose must not throw
      await PreferencesService().setThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();
    });

    testWidgets('theme tile subtitle shows Dark when themeMode is dark',
        (tester) async {
      await PreferencesService().setThemeMode(ThemeMode.dark);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Dark'), findsOneWidget);
    });
  });
}
