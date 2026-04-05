// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मापा मनी';

  @override
  String get appTagline => 'आपका ऑफ़लाइन खर्च ट्रैकर';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get save => 'सहेजें';

  @override
  String get saving => 'सहेजा जा रहा है';

  @override
  String get select => 'चुनें';

  @override
  String get preferences => 'प्राथमिकताएं';

  @override
  String get prefSectionDisplay => 'डिस्प्ले';

  @override
  String get prefSectionRegional => 'क्षेत्रीय';

  @override
  String get prefSectionDataEntry => 'डेटा प्रविष्टि';

  @override
  String get prefTheme => 'थीम';

  @override
  String get prefThemeDefault => 'डिफ़ॉल्ट';

  @override
  String get prefThemeDark => 'डार्क';

  @override
  String get prefDecimalPlaces => 'दशमलव स्थान';

  @override
  String get prefCurrency => 'मुद्रा';

  @override
  String get prefLanguage => 'भाषा';

  @override
  String get prefDataEntryEmpty => 'अभी तक कोई डेटा प्रविष्टि प्राथमिकता नहीं।';

  @override
  String get searchCurrencies => 'मुद्राएं खोजें…';

  @override
  String get homeTotal => 'कुल खर्च';

  @override
  String get homeAddExpense => 'खर्च जोड़ें';

  @override
  String homeNoExpensesForMonth(String month) {
    return '$month के लिए कोई खर्च नहीं';
  }

  @override
  String get homeTapToAdd => 'पहला खर्च जोड़ने के लिए + बटन दबाएं';

  @override
  String get homeLoadError => 'खर्च लोड नहीं हो सके';

  @override
  String get homeLoadErrorBody => 'कुछ गड़बड़ हो गई। कृपया ऐप पुनः आरंभ करें।';

  @override
  String get homePreviousMonth => 'पिछला महीना';

  @override
  String get homeNextMonth => 'अगला महीना';

  @override
  String get homeDeleteTitle => 'खर्च हटाएं';

  @override
  String homeDeleteBody(String title) {
    return 'क्या आप \"$title\" हटाना चाहते हैं?';
  }

  @override
  String get homeDeleteSuccess => 'खर्च सफलतापूर्वक हटाया गया';

  @override
  String get addExpenseTitle => 'खर्च जोड़ें';

  @override
  String get editExpenseTitle => 'खर्च संपादित करें';

  @override
  String get fieldExpenseTitle => 'खर्च का शीर्षक';

  @override
  String get fieldExpenseTitleHint => 'जैसे, रेस्टोरेंट में दोपहर का खाना';

  @override
  String get fieldAmountLabel => 'राशि';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'श्रेणी';

  @override
  String get fieldDescription => 'विवरण (वैकल्पिक)';

  @override
  String get fieldDescriptionHint => 'कोई अतिरिक्त नोट जोड़ें…';

  @override
  String get validTitleRequired => 'कृपया खर्च का शीर्षक दर्ज करें';

  @override
  String get validTitleTooShort => 'शीर्षक कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String get validTitleTooLong => 'शीर्षक 50 अक्षरों से कम होना चाहिए';

  @override
  String get validAmountRequired => 'कृपया राशि दर्ज करें';

  @override
  String get validAmountInvalid => 'कृपया एक वैध संख्या दर्ज करें';

  @override
  String get validAmountNegative => 'राशि 0 से अधिक होनी चाहिए';

  @override
  String get validAmountTooLarge => 'राशि 10,00,000 से कम होनी चाहिए';

  @override
  String get validCategoryRequired => 'कृपया एक श्रेणी चुनें';

  @override
  String get saveFailed => 'खर्च सहेजा नहीं जा सका। कृपया पुनः प्रयास करें।';

  @override
  String get expenseSaved => 'खर्च सफलतापूर्वक सहेजा गया!';

  @override
  String get expenseUpdated => 'खर्च सफलतापूर्वक अपडेट किया गया!';
}
