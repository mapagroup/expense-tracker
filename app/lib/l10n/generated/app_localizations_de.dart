// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mapa Money';

  @override
  String get appTagline => 'Ihr Offline-Ausgaben-Tracker';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Speichern';

  @override
  String get saving => 'Speichern';

  @override
  String get select => 'Auswählen';

  @override
  String get preferences => 'Einstellungen';

  @override
  String get prefSectionDisplay => 'Anzeige';

  @override
  String get prefSectionRegional => 'Regional';

  @override
  String get prefSectionDataEntry => 'Dateneingabe';

  @override
  String get prefTheme => 'Design';

  @override
  String get prefThemeDefault => 'Standard';

  @override
  String get prefThemeDark => 'Dunkel';

  @override
  String get prefDecimalPlaces => 'Dezimalstellen';

  @override
  String get prefCurrency => 'Währung';

  @override
  String get prefLanguage => 'Sprache';

  @override
  String get prefDataEntryEmpty =>
      'Noch keine Dateneingabe-Einstellungen vorhanden.';

  @override
  String get searchCurrencies => 'Währungen suchen…';

  @override
  String get homeTotal => 'Gesamtausgaben';

  @override
  String get homeAddExpense => 'Ausgabe hinzufügen';

  @override
  String homeNoExpensesForMonth(String month) {
    return 'Keine Ausgaben für $month';
  }

  @override
  String get homeTapToAdd =>
      'Tippen Sie auf +, um Ihre erste Ausgabe hinzuzufügen';

  @override
  String get homeLoadError => 'Ausgaben konnten nicht geladen werden';

  @override
  String get homeLoadErrorBody =>
      'Etwas ist schiefgelaufen. Bitte starten Sie die App neu.';

  @override
  String get homePreviousMonth => 'Vorheriger Monat';

  @override
  String get homeNextMonth => 'Nächster Monat';

  @override
  String get homeDeleteTitle => 'Ausgabe löschen';

  @override
  String homeDeleteBody(String title) {
    return 'Möchten Sie \"$title\" wirklich löschen?';
  }

  @override
  String get homeDeleteSuccess => 'Ausgabe erfolgreich gelöscht';

  @override
  String get addExpenseTitle => 'Ausgabe hinzufügen';

  @override
  String get editExpenseTitle => 'Ausgabe bearbeiten';

  @override
  String get fieldExpenseTitle => 'Ausgabentitel';

  @override
  String get fieldExpenseTitleHint => 'z. B. Mittagessen im Restaurant';

  @override
  String get fieldAmountLabel => 'Betrag';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'Kategorie';

  @override
  String get fieldDescription => 'Beschreibung (Optional)';

  @override
  String get fieldDescriptionHint => 'Zusätzliche Notizen hinzufügen…';

  @override
  String get validTitleRequired => 'Bitte geben Sie einen Ausgabentitel ein';

  @override
  String get validTitleTooShort => 'Der Titel muss mindestens 2 Zeichen haben';

  @override
  String get validTitleTooLong => 'Der Titel muss weniger als 50 Zeichen haben';

  @override
  String get validAmountRequired => 'Bitte geben Sie einen Betrag ein';

  @override
  String get validAmountInvalid => 'Bitte geben Sie eine gültige Zahl ein';

  @override
  String get validAmountNegative => 'Der Betrag muss größer als 0 sein';

  @override
  String get validAmountTooLarge =>
      'Der Betrag muss kleiner als 1.000.000 sein';

  @override
  String get validCategoryRequired => 'Bitte wählen Sie eine Kategorie aus';

  @override
  String get saveFailed =>
      'Ausgabe konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get expenseSaved => 'Ausgabe erfolgreich gespeichert!';

  @override
  String get expenseUpdated => 'Ausgabe erfolgreich aktualisiert!';
}
