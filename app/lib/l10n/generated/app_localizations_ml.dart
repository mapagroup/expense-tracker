// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'മാപ മണി';

  @override
  String get appTagline => 'നിങ്ങളുടെ ഓഫ്‌ലൈൻ ചെലവു ട്രാക്കർ';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get edit => 'തിരുത്തുക';

  @override
  String get ok => 'ശരി';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get saving => 'സേവ് ചെയ്യുന്നു';

  @override
  String get select => 'തിരഞ്ഞെടുക്കുക';

  @override
  String get preferences => 'മുൻഗണനകള്‍';

  @override
  String get prefSectionDisplay => 'ഡിസ്‌പ്ലേ';

  @override
  String get prefSectionRegional => 'പ്രാദേശിക';

  @override
  String get prefSectionDataEntry => 'ഡേറ്റ എൻട്രി';

  @override
  String get prefTheme => 'തീം';

  @override
  String get prefThemeDefault => 'ഡിഫോള്ട്ട്';

  @override
  String get prefThemeDark => 'ഇരുണ്ണടായ';

  @override
  String get prefDecimalPlaces => 'ദശാംശ സ്ഥാനങ്ങള്‍';

  @override
  String get prefCurrency => 'കറൻസി';

  @override
  String get prefLanguage => 'ഭാഷ';

  @override
  String get prefDataEntryEmpty => 'ഇനിയും ഡേറ്റ എൻട്രി മുൻഗണനകള്‍ ഇല്ല.';

  @override
  String get searchCurrencies => 'കറൻസികള്‍ തിരയുക…';

  @override
  String get homeTotal => 'ആകെ ചെലവുകള്‍';

  @override
  String get homeAddExpense => 'ചെലവ് ചേർക്കുക';

  @override
  String homeNoExpensesForMonth(String month) {
    return '$month -ലേക്ക് ചെലവുകള്‍ ഇല്ല';
  }

  @override
  String get homeTapToAdd =>
      'നിങ്ങളുടെ ആദ്യ ചെലവ് ചേർക്കാൻ + ബട്ടൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get homeLoadError => 'ചെലവുകള്‍ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല';

  @override
  String get homeLoadErrorBody =>
      'എന്തോ പ്രശ്‌നം ഉണ്ടായി. ആപ്പ് പുനരാരംഭിക്കുക.';

  @override
  String get homePreviousMonth => 'മുൻ മാസം';

  @override
  String get homeNextMonth => 'അടുത്ത മാസം';

  @override
  String get homeDeleteTitle => 'ചെലവ് ഇല്ലാതാക്കുക';

  @override
  String homeDeleteBody(String title) {
    return '\"$title\" ഇല്ലാതാക്കണോ?';
  }

  @override
  String get homeDeleteSuccess => 'ചെലവ് വിജയകരമായി ഇല്ലാതാക്കി';

  @override
  String get addExpenseTitle => 'ചെലവ് ചേർക്കുക';

  @override
  String get editExpenseTitle => 'ചെലവ് തിരുത്തുക';

  @override
  String get fieldExpenseTitle => 'ചെലവ് തലക്കെട്ട്';

  @override
  String get fieldExpenseTitleHint => 'ഉദാ., റസ്‌ററൻറില്‍ ഉച്ചഭക്ഷണം';

  @override
  String get fieldAmountLabel => 'തുക';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'വിഭാഗം';

  @override
  String get fieldDescription => 'വിവരണം (ഓപ്ഷണൽ)';

  @override
  String get fieldDescriptionHint => 'അധിക കുറിപ്പുകള്‍ ചേർക്കുക…';

  @override
  String get validTitleRequired => 'ചെലവ് തലക്കെട്ട് നൽകുക';

  @override
  String get validTitleTooShort =>
      'തലക്കെട്ടിൽ കുറഞ്ഞത് 2 അക്ഷരങ്ങള്‍ ഉണ്ടായിരിക്കണം';

  @override
  String get validTitleTooLong => 'തലക്കെട്ട് 50 അക്ഷരങ്ങളിൽ കുറവായിരിക്കണം';

  @override
  String get validAmountRequired => 'തുക നൽകുക';

  @override
  String get validAmountInvalid => 'സാധുവായ ഒരു നംബർ നൽകുക';

  @override
  String get validAmountNegative => 'തുക 0-ല്‍ കൂടുതല്‍ ആയിരിക്കണം';

  @override
  String get validAmountTooLarge => 'തുക 10,00,000-ല്‍ കുറവായിരിക്കണം';

  @override
  String get validCategoryRequired => 'ഒരു വിഭാഗം തിരഞ്ഞെടുക്കുക';

  @override
  String get saveFailed => 'ചെലവ് സേവ് ചെയ്യാൻ കഴിഞ്ഞില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get expenseSaved => 'ചെലവ് വിജയകരമായി സേവ് ചെയ്തു!';

  @override
  String get expenseUpdated => 'ചെലവ് വിജയകരമായി അപ്‌ഡേറ്റ് ചെയ്തു!';
}
