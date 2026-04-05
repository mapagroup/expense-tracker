// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'மப மணி';

  @override
  String get appTagline => 'உங்கள் ஆஃப்லைன் செலவு கண்காணிப்பி';

  @override
  String get cancel => 'ரத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String get edit => 'திருத்து';

  @override
  String get ok => 'சரி';

  @override
  String get save => 'சேமி';

  @override
  String get saving => 'சேமிக்கிறது';

  @override
  String get select => 'தேர்ந்தெடு';

  @override
  String get preferences => 'விருப்பங்கள்';

  @override
  String get prefSectionDisplay => 'காட்சி';

  @override
  String get prefSectionRegional => 'பிராந்திய';

  @override
  String get prefSectionDataEntry => 'தரவு உள்ளீடு';

  @override
  String get prefTheme => 'தீம்';

  @override
  String get prefThemeDefault => 'இயல்புநிலை';

  @override
  String get prefThemeDark => 'இருண்ட';

  @override
  String get prefDecimalPlaces => 'தசம இடங்கள்';

  @override
  String get prefCurrency => 'நாணயம்';

  @override
  String get prefLanguage => 'மொழி';

  @override
  String get prefDataEntryEmpty => 'இன்னும் தரவு உள்ளீடு விருப்பங்கள் இல்லை.';

  @override
  String get searchCurrencies => 'நாணயங்களை தேடுங்கள்…';

  @override
  String get homeTotal => 'மொத்த செலவுகள்';

  @override
  String get homeAddExpense => 'செலவு சேர்';

  @override
  String homeNoExpensesForMonth(String month) {
    return '$month மாதத்திற்கு செலவுகள் இல்லை';
  }

  @override
  String get homeTapToAdd => 'முதல் செலவை சேர்க்க + பட்டனை தட்டுங்கள்';

  @override
  String get homeLoadError => 'செலவுகளை ஏற்ற முடியவில்லை';

  @override
  String get homeLoadErrorBody =>
      'ஏதோ தவறு நடந்தது. பயன்பாட்டை மறுதொடக்கம் செய்யுங்கள்.';

  @override
  String get homePreviousMonth => 'முந்தைய மாதம்';

  @override
  String get homeNextMonth => 'அடுத்த மாதம்';

  @override
  String get homeDeleteTitle => 'செலவை நீக்கு';

  @override
  String homeDeleteBody(String title) {
    return '\"$title\" ஐ நீக்க விரும்புகிறீர்களா?';
  }

  @override
  String get homeDeleteSuccess => 'செலவு வெற்றிகரமாக நீக்கப்பட்டது';

  @override
  String get addExpenseTitle => 'செலவு சேர்';

  @override
  String get editExpenseTitle => 'செலவை திருத்து';

  @override
  String get fieldExpenseTitle => 'செலவு தலைப்பு';

  @override
  String get fieldExpenseTitleHint => 'எ.கா., உணவகத்தில் மதிய உணவு';

  @override
  String get fieldAmountLabel => 'தொகை';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'வகை';

  @override
  String get fieldDescription => 'விளக்கம் (விருப்பமான)';

  @override
  String get fieldDescriptionHint => 'கூடுதல் குறிப்புகள் சேர்க்கவும்…';

  @override
  String get validTitleRequired => 'செலவு தலைப்பை உள்ளிடவும்';

  @override
  String get validTitleTooShort =>
      'தலைப்பு குறைந்தது 2 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get validTitleTooLong =>
      'தலைப்பு 50 எழுத்துகளுக்கும் குறைவாக இருக்க வேண்டும்';

  @override
  String get validAmountRequired => 'தொகையை உள்ளிடவும்';

  @override
  String get validAmountInvalid => 'சரியான எண்ணை உள்ளிடவும்';

  @override
  String get validAmountNegative => 'தொகை 0 ஐ விட அதிகமாக இருக்க வேண்டும்';

  @override
  String get validAmountTooLarge =>
      'தொகை 10,00,000 ஐ விட குறைவாக இருக்க வேண்டும்';

  @override
  String get validCategoryRequired => 'வகையை தேர்வு செய்யுங்கள்';

  @override
  String get saveFailed =>
      'செலவை சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get expenseSaved => 'செலவு வெற்றிகரமாக சேமிக்கப்பட்டது!';

  @override
  String get expenseUpdated => 'செலவு வெற்றிகரமாக புதுப்பிக்கப்பட்டது!';
}
