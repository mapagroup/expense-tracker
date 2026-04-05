import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/expense.dart';
import 'services/database_service.dart';
import 'services/preferences_service.dart';
import 'screens/add_expense_screen.dart';
import 'theme/app_theme.dart';
import 'utils/currency.dart';
import 'utils/db_init_stub.dart'
    if (dart.library.io) 'utils/db_init_desktop.dart';
import 'widgets/app_drawer.dart';
import 'widgets/month_year_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable runtime font fetching: all fonts are already bundled inside the
  // google_fonts package. This enforces fully-offline operation and ensures
  // no network requests are made by the font layer.
  GoogleFonts.config.allowRuntimeFetching = false;

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    initDatabaseFactory();
  }

  await PreferencesService().init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    _prefs.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    _prefs.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa Money',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _prefs.themeMode,
      locale: Locale(_prefs.languageCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const _NoStretchScrollBehavior(),
      home: const HomeScreen(),
    );
  }
}

/// Disables all overscroll indicators (both the Material 3
/// [StretchingOverscrollIndicator] and the legacy [GlowingOverscrollIndicator])
/// on all scrollable widgets by returning [child] unchanged from
/// [buildOverscrollIndicator].
class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _allExpenses = [];
  bool _isLoading = true;
  bool _hasError = false;
  DateTime _selectedMonth = DateTime.now();
  final _prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    _prefs.addListener(_onPrefsChanged);
    _loadExpenses();
    // Pre-cache the drawer logo so it is ready before the drawer first opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/icons/app_icon.png'), context);
    });
  }

  @override
  void dispose() {
    _prefs.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() => setState(() {});

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final expenses = await DatabaseService().getAllExpenses();
      if (mounted) {
        setState(() {
          _allExpenses = expenses;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  List<Expense> _filterExpensesByMonth(List<Expense> expenses) {
    return expenses.where((expense) {
      return expense.date.year == _selectedMonth.year &&
          expense.date.month == _selectedMonth.month;
    }).toList();
  }

  Map<String, double> _calculateCategoryTotals(List<Expense> expenses) {
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  bool _canGoPreviousMonth() {
    return !(_selectedMonth.year == 1970 && _selectedMonth.month == 1);
  }

  bool _canGoNextMonth() {
    final now = DateTime.now();
    return !(_selectedMonth.year == now.year &&
        _selectedMonth.month == now.month);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedMonth = picked);
    }
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.homeDeleteTitle),
          content: Text(l10n.homeDeleteBody(expense.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseService().deleteExpense(expense.id!);
      await _loadExpenses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).homeDeleteSuccess),
          ),
        );
      }
    }
  }

  Future<void> _editExpense(Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(expense: expense),
      ),
    );
    if (result == true) {
      await _loadExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      drawer: const AppDrawer(),

      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.homeLoadError,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.homeLoadErrorBody,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final filteredExpenses = _filterExpensesByMonth(_allExpenses);
          final total = filteredExpenses.fold<double>(
            0,
            (sum, expense) => sum + expense.amount,
          );
          final categoryTotals = _calculateCategoryTotals(filteredExpenses);

          return Column(
            children: [
              // Month Filter and Total Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Month Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: colorScheme.primary,
                          ),
                          onPressed: _canGoPreviousMonth()
                              ? _previousMonth
                              : null,
                          tooltip: l10n.homePreviousMonth,
                        ),
                        GestureDetector(
                          onTap: () => _selectMonth(context),
                          child: Text(
                            DateFormat('MMMM y', locale).format(_selectedMonth),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: colorScheme.primary,
                          ),
                          onPressed: _canGoNextMonth() ? _nextMonth : null,
                          tooltip: l10n.homeNextMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Total Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.homeTotal,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(total),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Category Summary
              if (categoryTotals.isNotEmpty)
                Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categoryTotals.length,
                    itemBuilder: (context, index) {
                      final category = categoryTotals.keys.elementAt(index);
                      final amount = categoryTotals[category]!;
                      final percentage = total > 0
                          ? (amount / total * 100).round()
                          : 0;

                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(amount),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '$percentage%',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // Expenses List
              Expanded(
                child: filteredExpenses.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 80,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.homeNoExpensesForMonth(
                              DateFormat('MMMM', locale).format(_selectedMonth),
                            ),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeTapToAdd,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    expense.category,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: _getCategoryColor(expense.category),
                                ),
                              ),
                              title: Text(
                                expense.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense.category,
                                    style: TextStyle(
                                      color: _getCategoryColor(
                                        expense.category,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(expense.amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.expense,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editExpense(expense);
                                      } else if (value == 'delete') {
                                        _deleteExpense(expense);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.edit,
                                              color: AppColors.primary,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(l10n.edit),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(l10n.delete),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (result == true) {
            await _loadExpenses();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.homeAddExpense),
      ),
    );
  }

  Color _getCategoryColor(String category) => AppColors.categoryColor(category);

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      case 'Bills':
        return Icons.receipt;
      case 'Other':
        return Icons.category;
      default:
        return Icons.currency_rupee;
    }
  }
}
