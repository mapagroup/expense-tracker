import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/expense.dart';
import '../services/database_service.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';
  bool _isLoading = false;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Bills',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      // Pre-populate form for editing
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _selectedDate = widget.expense!.date;
      _selectedCategory = widget.expense!.category;
      _descriptionController.text = widget.expense!.description ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final expense = Expense(
        id: widget.expense?.id, // Include ID for updates
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      if (widget.expense != null) {
        // Update existing expense
        await DatabaseService().updateExpense(expense);
      } else {
        // Insert new expense
        await DatabaseService().insertExpense(expense);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.expense != null
                  ? AppLocalizations.of(context).expenseUpdated
                  : AppLocalizations.of(context).expenseSaved,
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Log full error in debug builds only; never surface internal details
      // (file paths, stack traces) to the end user.
      assert(() {
        // ignore: avoid_print
        print('[AddExpenseScreen] Save error: $e');
        return true;
      }());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).saveFailed),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final symbol = PreferencesService().currentCurrency.symbol;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense != null ? l10n.editExpenseTitle : l10n.addExpenseTitle,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.fieldExpenseTitle,
                  hintText: l10n.fieldExpenseTitleHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.validTitleRequired;
                  }
                  if (value.trim().length < 2) {
                    return l10n.validTitleTooShort;
                  }
                  if (value.trim().length > 50) {
                    return l10n.validTitleTooLong;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.fieldAmountLabel,
                  hintText: l10n.fieldAmountHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: '$symbol ',
                  prefixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.validAmountRequired;
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return l10n.validAmountInvalid;
                  }
                  if (amount <= 0) {
                    return l10n.validAmountNegative;
                  }
                  if (amount > 1000000) {
                    return l10n.validAmountTooLarge;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: l10n.fieldCategory,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          color: _getCategoryColor(category),
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.validCategoryRequired;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 'Food';
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.fieldDescription,
                  hintText: l10n.fieldDescriptionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                maxLength: 200,
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveExpense,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.expense != null
                              ? l10n.editExpenseTitle
                              : l10n.addExpenseTitle,
                        ),
                ),
              ),
            ],
          ),
        ),
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
