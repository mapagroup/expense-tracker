// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mapa Money';

  @override
  String get appTagline => 'Your offline expense tracker';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving';

  @override
  String get select => 'Select';

  @override
  String get preferences => 'Preferences';

  @override
  String get prefSectionDisplay => 'Display';

  @override
  String get prefSectionRegional => 'Regional';

  @override
  String get prefSectionDataEntry => 'Data Entry';

  @override
  String get prefTheme => 'Theme';

  @override
  String get prefThemeDefault => 'Default';

  @override
  String get prefThemeDark => 'Dark';

  @override
  String get prefDecimalPlaces => 'Decimal Places';

  @override
  String get prefCurrency => 'Currency';

  @override
  String get prefLanguage => 'Language';

  @override
  String get prefDataEntryEmpty => 'No data entry preferences yet.';

  @override
  String get searchCurrencies => 'Search currencies…';

  @override
  String get homeTotal => 'Total Expenses';

  @override
  String get homeAddExpense => 'Add Expense';

  @override
  String homeNoExpensesForMonth(String month) {
    return 'No expenses for $month';
  }

  @override
  String get homeTapToAdd => 'Tap the + button to add your first expense';

  @override
  String get homeLoadError => 'Could not load expenses';

  @override
  String get homeLoadErrorBody =>
      'Something went wrong. Please restart the app.';

  @override
  String get homePreviousMonth => 'Previous month';

  @override
  String get homeNextMonth => 'Next month';

  @override
  String get homeDeleteTitle => 'Delete Expense';

  @override
  String homeDeleteBody(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get homeDeleteSuccess => 'Expense deleted successfully';

  @override
  String get addExpenseTitle => 'Add Expense';

  @override
  String get editExpenseTitle => 'Edit Expense';

  @override
  String get fieldExpenseTitle => 'Expense Title';

  @override
  String get fieldExpenseTitleHint => 'e.g., Lunch at restaurant';

  @override
  String get fieldAmountLabel => 'Amount';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldDescription => 'Description (Optional)';

  @override
  String get fieldDescriptionHint => 'Add any additional notes…';

  @override
  String get validTitleRequired => 'Please enter an expense title';

  @override
  String get validTitleTooShort => 'Title must be at least 2 characters';

  @override
  String get validTitleTooLong => 'Title must be less than 50 characters';

  @override
  String get validAmountRequired => 'Please enter an amount';

  @override
  String get validAmountInvalid => 'Please enter a valid number';

  @override
  String get validAmountNegative => 'Amount must be greater than 0';

  @override
  String get validAmountTooLarge => 'Amount must be less than 1,000,000';

  @override
  String get validCategoryRequired => 'Please select a category';

  @override
  String get saveFailed => 'Could not save expense. Please try again.';

  @override
  String get expenseSaved => 'Expense saved successfully!';

  @override
  String get expenseUpdated => 'Expense updated successfully!';
}
