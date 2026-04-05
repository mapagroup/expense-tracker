// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mapa Money';

  @override
  String get appTagline => 'Tu rastreador de gastos sin conexión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get ok => 'Aceptar';

  @override
  String get save => 'Guardar';

  @override
  String get saving => 'Guardando';

  @override
  String get select => 'Seleccionar';

  @override
  String get preferences => 'Preferencias';

  @override
  String get prefSectionDisplay => 'Pantalla';

  @override
  String get prefSectionRegional => 'Regional';

  @override
  String get prefSectionDataEntry => 'Entrada de datos';

  @override
  String get prefTheme => 'Tema';

  @override
  String get prefThemeDefault => 'Predeterminado';

  @override
  String get prefThemeDark => 'Oscuro';

  @override
  String get prefDecimalPlaces => 'Decimales';

  @override
  String get prefCurrency => 'Moneda';

  @override
  String get prefLanguage => 'Idioma';

  @override
  String get prefDataEntryEmpty =>
      'Aún no hay preferencias de entrada de datos.';

  @override
  String get searchCurrencies => 'Buscar monedas…';

  @override
  String get homeTotal => 'Gastos totales';

  @override
  String get homeAddExpense => 'Agregar gasto';

  @override
  String homeNoExpensesForMonth(String month) {
    return 'Sin gastos para $month';
  }

  @override
  String get homeTapToAdd => 'Toca el botón + para agregar tu primer gasto';

  @override
  String get homeLoadError => 'No se pudieron cargar los gastos';

  @override
  String get homeLoadErrorBody => 'Algo salió mal. Por favor, reinicia la app.';

  @override
  String get homePreviousMonth => 'Mes anterior';

  @override
  String get homeNextMonth => 'Mes siguiente';

  @override
  String get homeDeleteTitle => 'Eliminar gasto';

  @override
  String homeDeleteBody(String title) {
    return '¿Seguro que deseas eliminar \"$title\"?';
  }

  @override
  String get homeDeleteSuccess => 'Gasto eliminado con éxito';

  @override
  String get addExpenseTitle => 'Agregar gasto';

  @override
  String get editExpenseTitle => 'Editar gasto';

  @override
  String get fieldExpenseTitle => 'Título del gasto';

  @override
  String get fieldExpenseTitleHint => 'p. ej., Almuerzo en restaurante';

  @override
  String get fieldAmountLabel => 'Monto';

  @override
  String get fieldAmountHint => '0.00';

  @override
  String get fieldCategory => 'Categoría';

  @override
  String get fieldDescription => 'Descripción (Opcional)';

  @override
  String get fieldDescriptionHint => 'Agrega notas adicionales…';

  @override
  String get validTitleRequired => 'Por favor ingresa un título de gasto';

  @override
  String get validTitleTooShort => 'El título debe tener al menos 2 caracteres';

  @override
  String get validTitleTooLong => 'El título debe tener menos de 50 caracteres';

  @override
  String get validAmountRequired => 'Por favor ingresa un monto';

  @override
  String get validAmountInvalid => 'Por favor ingresa un número válido';

  @override
  String get validAmountNegative => 'El monto debe ser mayor a 0';

  @override
  String get validAmountTooLarge => 'El monto debe ser menor a 1.000.000';

  @override
  String get validCategoryRequired => 'Por favor selecciona una categoría';

  @override
  String get saveFailed =>
      'No se pudo guardar el gasto. Por favor, intenta de nuevo.';

  @override
  String get expenseSaved => '¡Gasto guardado con éxito!';

  @override
  String get expenseUpdated => '¡Gasto actualizado con éxito!';
}
