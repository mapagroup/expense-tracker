import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/screens/preferences_screen.dart';
import 'package:mapa_money/theme/app_theme.dart';
import 'package:mapa_money/widgets/app_drawer.dart';

/// Harness that wraps the real [AppDrawer] production widget in a minimal
/// Scaffold so tests exercise the same widget tree as the app.
Widget buildHarness() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: const SizedBox.shrink(),
    ),
  );
}

void main() {
  group('AppDrawer', () {
    testWidgets('hamburger icon is shown in the AppBar', (tester) async {
      await tester.pumpWidget(buildHarness());
      // Scaffold automatically adds a DrawerButton when a drawer is present.
      // Asserting on the widget type is more robust than a specific icon glyph.
      expect(find.byType(DrawerButton), findsOneWidget);
    });

    testWidgets('tapping hamburger opens the drawer', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();

      expect(find.text('Mapa Money'), findsWidgets);
      expect(find.text('Preferences'), findsOneWidget);
    });

    testWidgets('drawer contains Preferences list tile', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithIcon(ListTile, Icons.settings_outlined),
        findsOneWidget,
      );
      expect(find.widgetWithText(ListTile, 'Preferences'), findsOneWidget);
    });

    testWidgets('tapping Preferences navigates to PreferencesScreen', (
      tester,
    ) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, 'Preferences'));
      await tester.pumpAndSettle();

      expect(find.byType(PreferencesScreen), findsOneWidget);
    });

    testWidgets('tapping outside the drawer closes it', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();

      // Tap the scrim to simulate the user tapping outside the open drawer.
      // Flutter's test viewport is 800 × 600 logical pixels; the Material
      // drawer panel is at most 304 px wide on the left, so (600, 300)
      // reliably lands on the scrim GestureDetector, which calls closeDrawer.
      await tester.tapAt(const Offset(600, 300));
      await tester.pumpAndSettle();

      final ScaffoldState scaffold = tester.state(find.byType(Scaffold));
      expect(scaffold.isDrawerOpen, isFalse);
    });
  });
}
