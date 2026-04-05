import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/theme/app_theme.dart';

void main() {
  group('AppColors.categoryColor', () {
    test('returns categoryFood for Food', () {
      expect(AppColors.categoryColor('Food'), AppColors.categoryFood);
    });

    test('returns categoryTransport for Transport', () {
      expect(AppColors.categoryColor('Transport'), AppColors.categoryTransport);
    });

    test('returns categoryEntertainment for Entertainment', () {
      expect(
        AppColors.categoryColor('Entertainment'),
        AppColors.categoryEntertainment,
      );
    });

    test('returns categoryBills for Bills', () {
      expect(AppColors.categoryColor('Bills'), AppColors.categoryBills);
    });

    test('returns categoryOther for unknown category', () {
      expect(AppColors.categoryColor('Other'), AppColors.categoryOther);
      expect(AppColors.categoryColor('Shopping'), AppColors.categoryOther);
    });
  });

  group('AppTheme.light', () {
    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    test('returns a ThemeData with Material 3 enabled', () {
      final theme = AppTheme.light();
      expect(theme.useMaterial3, isTrue);
    });

    test('has correct primary colour', () {
      final theme = AppTheme.light();
      expect(theme.colorScheme.primary, AppColors.primary);
    });

    test('scaffold background is AppColors.background', () {
      final theme = AppTheme.light();
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });
  });
}
