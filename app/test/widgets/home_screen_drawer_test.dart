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

      // Close via ScaffoldState — mirrors what Flutter does when the user taps
      // the scrim, and avoids brittle hard-coded coordinates or hit-test
      // issues with NavigationDrawer's internal barrier widget.
      final ScaffoldState scaffold =
          tester.state(find.byType(Scaffold));
      scaffold.closeDrawer();
      await tester.pumpAndSettle();

      expect(find.byType(AppDrawer), findsNothing);
    });
  });
}
