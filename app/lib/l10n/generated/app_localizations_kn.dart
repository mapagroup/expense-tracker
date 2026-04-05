// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಮಾಪ ಮನಿ';

  @override
  String get appTagline => 'ನಿಮ್ಮ ಆಫ್‌ಲೈನ್ ಖರ್ಚು ಟ್ರ್ಯಾಕರ್';

  @override
  String get cancel => 'ರದ್ದು';

  @override
  String get delete => 'ಅಳಿಸು';

  @override
  String get edit => 'ಬದಲಾಯಿಸು';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get save => 'ಉಳಿಸು';

  @override
  String get saving => 'ಉಳಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get select => 'ಆಯ್ಕೆ';

  @override
  String get preferences => 'ಆದ್ಯತೆಗಳು';

  @override
  String get prefSectionDisplay => 'ಡಿಸ್‌ಪ್ಲೇ';

  @override
  String get prefSectionRegional => 'ಪ್ರಾದೇಶಿಕ';

  @override
  String get prefSectionDataEntry => 'ಡೇಟಾ ನಮೂದು';

  @override
  String get prefTheme => 'ಥೀಮ್';

  @override
  String get prefThemeDefault => 'ಡೀಫಾಲ್ಟ್';

  @override
  String get prefThemeDark => 'ಡಾರ್ಕ್';

  @override
  String get prefDecimalPlaces => 'ದಶಮಾಂಶ ಸ್ಥಾನಗಳು';

  @override
  String get prefCurrency => 'ಕರೆನ್ಸಿ';

  @override
  String get prefLanguage => 'ಭಾಷೆ';

  @override
  String get prefDataEntryEmpty => 'ಇನ್ನೂ ಡೇಟಾ ನಮೂದು ಆದ್ಯತೆಗಳಿಲ್ಲ.';

  @override
  String get searchCurrencies => 'ಕರೆನ್ಸಿಗಳನ್ನು ಹುಡುಕಿ…';

  @override
  String get homeTotal => 'ಒಟ್ಟು ಖರ್ಚುಗಳು';

  @override
  String get homeAddExpense => 'ಖರ್ಚು ಸೇರಿಸಿ';

  @override
  String homeNoExpensesForMonth(String month) {
    return '$month ಗೆ ಖರ್ಚುಗಳಿಲ್ಲ';
  }

  @override
  String get homeTapToAdd =>
      'ನಿಮ್ಮ ಮೊದಲ ಖರ್ಚು ಸೇರಿಸಲು + ಬಟನ್ ಅನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get homeLoadError => 'ಖರ್ಚುಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get homeLoadErrorBody => 'ಏನೋ ತಪ್ಪಾಯಿತು. ದಯವಿಟ್ಟು ಆಪ್ ಮರುಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get homePreviousMonth => 'ಹಿಂದಿನ ತಿಂಗಳು';

  @override
  String get homeNextMonth => 'ಮುಂದಿನ ತಿಂಗಳು';

  @override
  String get homeDeleteTitle => 'ಖರ್ಚು ಅಳಿಸಿ';

  @override
  String homeDeleteBody(String title) {
    return '\"$title\" ಅಳಿಸಬೇಕೆ?';
  }

  @override
  String get homeDeleteSuccess => 'ಖರ್ಚು ಯಶಸ್ವಿಯಾಗಿ ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get addExpenseTitle => 'ಖರ್ಚು ಸೇರಿಸಿ';

  @override
  String get editExpenseTitle => 'ಖರ್ಚು ಬದಲಾಯಿಸಿ';

  @override
  String get fieldExpenseTitle => 'ಖರ್ಚು ಶೀರ್ಷಿಕೆ';

  @override
  String get fieldExpenseTitleHint => 'ಉದಾ., ರೆಸ್ಟೋರೆಂಟ್‌ನಲ್ಲಿ ಭೋಜನ';

  @override
  String get fieldAmountLabel => 'ಮೊತ್ತ';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'ವರ್ಗ';

  @override
  String get fieldDescription => 'ವಿವರಣೆ (ಐಚ್ಛಿಕ)';

  @override
  String get fieldDescriptionHint => 'ಹೆಚ್ಚುವರಿ ಟಿಪ್ಪಣಿಗಳನ್ನು ಸೇರಿಸಿ…';

  @override
  String get validTitleRequired => 'ಖರ್ಚು ಶೀರ್ಷಿಕೆ ನಮೂದಿಸಿ';

  @override
  String get validTitleTooShort => 'ಶೀರ್ಷಿಕೆ ಕನಿಷ್ಠ 2 ಅಕ್ಷರಗಳು ಇರಬೇಕು';

  @override
  String get validTitleTooLong => 'ಶೀರ್ಷಿಕೆ 50 ಅಕ್ಷರಗಳಿಗಿಂತ ಕಡಿಮೆ ಇರಬೇಕು';

  @override
  String get validAmountRequired => 'ಮೊತ್ತ ನಮೂದಿಸಿ';

  @override
  String get validAmountInvalid => 'ಮಾನ್ಯ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get validAmountNegative => 'ಮೊತ್ತ 0 ಕ್ಕಿಂತ ಹೆಚ್ಚು ಇರಬೇಕು';

  @override
  String get validAmountTooLarge => 'ಮೊತ್ತ 10,00,000 ಕ್ಕಿಂತ ಕಡಿಮೆ ಇರಬೇಕು';

  @override
  String get validCategoryRequired => 'ವರ್ಗ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get saveFailed => 'ಖರ್ಚು ಉಳಿಸಲಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get expenseSaved => 'ಖರ್ಚು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ!';

  @override
  String get expenseUpdated => 'ಖರ್ಚು ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ!';
}
