// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'మాపా మనీ';

  @override
  String get appTagline => 'మీ ఆఫ్‌లైన్ ఖర్చు ట్రాకర్';

  @override
  String get cancel => 'రద్దు';

  @override
  String get delete => 'తొలగించు';

  @override
  String get edit => 'మార్చు';

  @override
  String get ok => 'సరే';

  @override
  String get save => 'నిల్వ';

  @override
  String get saving => 'నిల్వపరుస్తున్నారు';

  @override
  String get select => 'ఎంచుకో';

  @override
  String get preferences => 'ప్రాధాన్యతలు';

  @override
  String get prefSectionDisplay => 'ప్రదర్శన';

  @override
  String get prefSectionRegional => 'ప్రాంతీయ';

  @override
  String get prefSectionDataEntry => 'డేటా నమోదు';

  @override
  String get prefTheme => 'థీమ్';

  @override
  String get prefThemeDefault => 'డిఫాల్ట్';

  @override
  String get prefThemeDark => 'చీకటి';

  @override
  String get prefDecimalPlaces => 'దశాంశ స్థానాలు';

  @override
  String get prefCurrency => 'కరెన్సీ';

  @override
  String get prefLanguage => 'భాష';

  @override
  String get prefDataEntryEmpty => 'ఇంకా డేటా నమోదు ప్రాధాన్యతలు లేవు.';

  @override
  String get searchCurrencies => 'కరెన్సీలను వెతుకుండి…';

  @override
  String get homeTotal => 'మొత్తం ఖర్చులు';

  @override
  String get homeAddExpense => 'ఖర్చు జోడించు';

  @override
  String homeNoExpensesForMonth(String month) {
    return '$month కి ఖర్చులు లేవు';
  }

  @override
  String get homeTapToAdd => 'మీ మొదటి ఖర్చు జోడించడానికి + బటన్ నొక్కండి';

  @override
  String get homeLoadError => 'ఖర్చులు లోడ్ చేయడం సాధ్యపడలేదు';

  @override
  String get homeLoadErrorBody =>
      'ఏదో తప్పు జరిగింది. యాప్‌ని పునఃప్రారంభించండి.';

  @override
  String get homePreviousMonth => 'మునుపటి నెల';

  @override
  String get homeNextMonth => 'తదుపరి నెల';

  @override
  String get homeDeleteTitle => 'ఖర్చు తొలగించు';

  @override
  String homeDeleteBody(String title) {
    return '\"$title\" తొలగించాలా?';
  }

  @override
  String get homeDeleteSuccess => 'ఖర్చు విజయవంతంగా తొలగించబడింది';

  @override
  String get addExpenseTitle => 'ఖర్చు జోడించు';

  @override
  String get editExpenseTitle => 'ఖర్చు మార్చు';

  @override
  String get fieldExpenseTitle => 'ఖర్చు శీర్షిక';

  @override
  String get fieldExpenseTitleHint => 'ఉదా., రెస్టారెంట్‌లో భోజనం';

  @override
  String get fieldAmountLabel => 'మొత్తం';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'విభాగం';

  @override
  String get fieldDescription => 'వివరణ (ఐచ్ఛికం)';

  @override
  String get fieldDescriptionHint => 'అదనపు గమనికలు జోడించండి…';

  @override
  String get validTitleRequired => 'ఖర్చు శీర్షికను నమోదు చేయండి';

  @override
  String get validTitleTooShort => 'శీర్షిక కనీసం 2 అక్షరాలు ఉండాలి';

  @override
  String get validTitleTooLong => 'శీర్షిక 50 అక్షరాల కంటె తక్కువగా ఉండాలి';

  @override
  String get validAmountRequired => 'మొత్తాన్ని నమోదు చేయండి';

  @override
  String get validAmountInvalid => 'చెల్లుబాటు అయ్యే సంఖ్యను నమోదు చేయండి';

  @override
  String get validAmountNegative => 'మొత్తం 0 కంటె ఎక్కువగా ఉండాలి';

  @override
  String get validAmountTooLarge => 'మొత్తం 10,00,000 కంటె తక్కువగా ఉండాలి';

  @override
  String get validCategoryRequired => 'వర్గాన్ని ఎంచుకోండి';

  @override
  String get saveFailed =>
      'ఖర్చు నిల్వ చేయడం సాధ్యపడలేదు. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get expenseSaved => 'ఖర్చు విజయవంతంగా నిల్వ చేయబడింది!';

  @override
  String get expenseUpdated => 'ఖర్చు విజయవంతంగా నవీకరించబడింది!';
}
