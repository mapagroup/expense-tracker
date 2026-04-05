import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/screens/preferences_screen.dart';
import 'package:mapa_money/theme/app_theme.dart';

/// Minimal harness that embeds a Scaffold with a drawer matching the real
/// _AppDrawer implementation so we can test its UI without hitting the DB.
Widget buildHarness() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      appBar: AppBar(title: const Text('Mapa Money')),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon substitute for asset (not available in tests)
                  const Icon(Icons.account_balance_wallet,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (ctx) => Text(
                      'Mapa Money',
                      style:
                          Theme.of(ctx).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (ctx) => ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Preferences'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => const PreferencesScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: const SizedBox.shrink(),
    ),
  );
}

void main() {
  group('HomeScreen drawer', () {
    testWidgets('hamburger icon is shown in the AppBar', (tester) async {
      await tester.pumpWidget(buildHarness());
      // Scaffold automatically adds a DrawerButton (hamburger) when a drawer
      // is present.
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('tapping hamburger opens the drawer', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Mapa Money'), findsWidgets);
      expect(find.text('Preferences'), findsOneWidget);
    });

    testWidgets('drawer contains Preferences list tile', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.widgetWithIcon(ListTile, Icons.settings_outlined),
          findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Preferences'), findsOneWidget);
    });

    testWidgets('tapping Preferences navigates to PreferencesScreen',
        (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, 'Preferences'));
      await tester.pumpAndSettle();

      expect(find.byType(PreferencesScreen), findsOneWidget);
    });

    testWidgets('drawer can be dismissed by tapping outside', (tester) async {
      await tester.pumpWidget(buildHarness());
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap the scrim (barrier) to dismiss the drawer
      await tester.tapAt(const Offset(600, 300));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsNothing);
    });
  });
}
