import 'package:flutter/material.dart';

/// A dialog that lets the user pick a month and year.
/// Returns a [DateTime] set to the first day of the chosen month,
/// or null if the user cancels.
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _MonthYearPickerDialog(
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now(),
    ),
  );
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _MonthYearPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  bool _isPreviousYearAllowed() => _selectedYear > widget.firstDate.year;

  bool _isNextYearAllowed() => _selectedYear < widget.lastDate.year;

  bool _isMonthAllowed(int month) {
    final date = DateTime(_selectedYear, month);
    final first = DateTime(widget.firstDate.year, widget.firstDate.month);
    final last = DateTime(widget.lastDate.year, widget.lastDate.month);
    return !date.isBefore(first) && !date.isAfter(last);
  }

  void _confirm() {
    Navigator.of(context).pop(DateTime(_selectedYear, _selectedMonth));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Select month and year to filter expenses'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Year navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _isPreviousYearAllowed()
                    ? () => setState(() {
                        _selectedYear--;
                        if (!_isMonthAllowed(_selectedMonth)) {
                          _selectedMonth = 12;
                        }
                      })
                    : null,
                tooltip: 'Previous year',
              ),
              Text(
                '$_selectedYear',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _isNextYearAllowed()
                    ? () => setState(() {
                        _selectedYear++;
                        if (!_isMonthAllowed(_selectedMonth)) {
                          _selectedMonth = 1;
                        }
                      })
                    : null,
                tooltip: 'Next year',
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Month grid using Wrap to avoid nested scroll issues
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(12, (index) {
              final month = index + 1;
              final isSelected = month == _selectedMonth;
              final isAllowed = _isMonthAllowed(month);
              return SizedBox(
                width: 72,
                height: 36,
                child: TextButton(
                  onPressed: isAllowed
                      ? () => setState(() => _selectedMonth = month)
                      : null,
                  style: TextButton.styleFrom(
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                    foregroundColor: isSelected
                        ? colorScheme.onPrimary
                        : isAllowed
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    _monthNames[index].substring(0, 3),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isMonthAllowed(_selectedMonth) ? _confirm : null,
          child: const Text('Select'),
        ),
      ],
    );
  }
}
