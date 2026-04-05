import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/screens/preferences_screen.dart';
import 'package:mapa_money/theme/app_theme.dart';

void main() {
  group('PreferencesScreen', () {
    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.light(),
        home: const PreferencesScreen(),
      );
    }

    testWidgets('renders AppBar with Preferences title', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.widgetWithText(AppBar, 'Preferences'), findsOneWidget);
    });

    testWidgets('shows settings icon and label', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.text('Preferences'), findsWidgets);
    });
  });
}
