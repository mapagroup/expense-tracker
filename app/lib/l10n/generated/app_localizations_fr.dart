// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mapa Money';

  @override
  String get appTagline => 'Votre suivi de dépenses hors ligne';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Enregistrer';

  @override
  String get saving => 'Enregistrement';

  @override
  String get select => 'Sélectionner';

  @override
  String get preferences => 'Préférences';

  @override
  String get prefSectionDisplay => 'Affichage';

  @override
  String get prefSectionRegional => 'Régional';

  @override
  String get prefSectionDataEntry => 'Saisie de données';

  @override
  String get prefTheme => 'Thème';

  @override
  String get prefThemeDefault => 'Par défaut';

  @override
  String get prefThemeDark => 'Sombre';

  @override
  String get prefDecimalPlaces => 'Décimales';

  @override
  String get prefCurrency => 'Devise';

  @override
  String get prefLanguage => 'Langue';

  @override
  String get prefDataEntryEmpty =>
      'Aucune préférence de saisie pour l\'instant.';

  @override
  String get searchCurrencies => 'Rechercher des devises…';

  @override
  String get homeTotal => 'Dépenses totales';

  @override
  String get homeAddExpense => 'Ajouter une dépense';

  @override
  String homeNoExpensesForMonth(String month) {
    return 'Aucune dépense pour $month';
  }

  @override
  String get homeTapToAdd =>
      'Appuyez sur le bouton + pour ajouter votre première dépense';

  @override
  String get homeLoadError => 'Impossible de charger les dépenses';

  @override
  String get homeLoadErrorBody =>
      'Quelque chose a mal tourné. Veuillez redémarrer l\'application.';

  @override
  String get homePreviousMonth => 'Mois précédent';

  @override
  String get homeNextMonth => 'Mois suivant';

  @override
  String get homeDeleteTitle => 'Supprimer la dépense';

  @override
  String homeDeleteBody(String title) {
    return 'Voulez-vous vraiment supprimer \"$title\" ?';
  }

  @override
  String get homeDeleteSuccess => 'Dépense supprimée avec succès';

  @override
  String get addExpenseTitle => 'Ajouter une dépense';

  @override
  String get editExpenseTitle => 'Modifier la dépense';

  @override
  String get fieldExpenseTitle => 'Titre de la dépense';

  @override
  String get fieldExpenseTitleHint => 'ex., Déjeuner au restaurant';

  @override
  String get fieldAmountLabel => 'Montant';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'Catégorie';

  @override
  String get fieldDescription => 'Description (Facultatif)';

  @override
  String get fieldDescriptionHint => 'Ajoutez des notes supplémentaires…';

  @override
  String get validTitleRequired => 'Veuillez saisir un titre de dépense';

  @override
  String get validTitleTooShort =>
      'Le titre doit comporter au moins 2 caractères';

  @override
  String get validTitleTooLong =>
      'Le titre doit comporter moins de 50 caractères';

  @override
  String get validAmountRequired => 'Veuillez saisir un montant';

  @override
  String get validAmountInvalid => 'Veuillez saisir un nombre valide';

  @override
  String get validAmountNegative => 'Le montant doit être supérieur à 0';

  @override
  String get validAmountTooLarge =>
      'Le montant doit être inférieur à 1 000 000';

  @override
  String get validCategoryRequired => 'Veuillez sélectionner une catégorie';

  @override
  String get saveFailed =>
      'Impossible d\'enregistrer la dépense. Veuillez réessayer.';

  @override
  String get expenseSaved => 'Dépense enregistrée avec succès !';

  @override
  String get expenseUpdated => 'Dépense mise à jour avec succès !';
}
