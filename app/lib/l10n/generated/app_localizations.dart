import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mapa Money'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your offline expense tracker'**
  String get appTagline;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get saving;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @prefSectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get prefSectionDisplay;

  /// No description provided for @prefSectionRegional.
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get prefSectionRegional;

  /// No description provided for @prefSectionDataEntry.
  ///
  /// In en, this message translates to:
  /// **'Data Entry'**
  String get prefSectionDataEntry;

  /// No description provided for @prefTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get prefTheme;

  /// No description provided for @prefThemeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get prefThemeDefault;

  /// No description provided for @prefThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get prefThemeDark;

  /// No description provided for @prefDecimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Decimal Places'**
  String get prefDecimalPlaces;

  /// No description provided for @prefCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get prefCurrency;

  /// No description provided for @prefLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get prefLanguage;

  /// No description provided for @prefDataEntryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data entry preferences yet.'**
  String get prefDataEntryEmpty;

  /// No description provided for @searchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Search currencies…'**
  String get searchCurrencies;

  /// No description provided for @homeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get homeTotal;

  /// No description provided for @homeAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get homeAddExpense;

  /// No description provided for @homeNoExpensesForMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses for {month}'**
  String homeNoExpensesForMonth(String month);

  /// No description provided for @homeTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first expense'**
  String get homeTapToAdd;

  /// No description provided for @homeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load expenses'**
  String get homeLoadError;

  /// No description provided for @homeLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please restart the app.'**
  String get homeLoadErrorBody;

  /// No description provided for @homePreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get homePreviousMonth;

  /// No description provided for @homeNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get homeNextMonth;

  /// No description provided for @homeDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get homeDeleteTitle;

  /// No description provided for @homeDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String homeDeleteBody(String title);

  /// No description provided for @homeDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted successfully'**
  String get homeDeleteSuccess;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseTitle;

  /// No description provided for @editExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpenseTitle;

  /// No description provided for @fieldExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Title'**
  String get fieldExpenseTitle;

  /// No description provided for @fieldExpenseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Lunch at restaurant'**
  String get fieldExpenseTitleHint;

  /// No description provided for @fieldAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmountLabel;

  /// No description provided for @fieldAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get fieldAmountHint;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get fieldDescription;

  /// No description provided for @fieldDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add any additional notes…'**
  String get fieldDescriptionHint;

  /// No description provided for @validTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an expense title'**
  String get validTitleRequired;

  /// No description provided for @validTitleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 2 characters'**
  String get validTitleTooShort;

  /// No description provided for @validTitleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Title must be less than 50 characters'**
  String get validTitleTooLong;

  /// No description provided for @validAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get validAmountRequired;

  /// No description provided for @validAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get validAmountInvalid;

  /// No description provided for @validAmountNegative.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get validAmountNegative;

  /// No description provided for @validAmountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Amount must be less than 1,000,000'**
  String get validAmountTooLarge;

  /// No description provided for @validCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get validCategoryRequired;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save expense. Please try again.'**
  String get saveFailed;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully!'**
  String get expenseSaved;

  /// No description provided for @expenseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Expense updated successfully!'**
  String get expenseUpdated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'kn',
    'ml',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
