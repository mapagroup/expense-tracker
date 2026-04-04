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
      firstDate: firstDate ?? DateTime(1970),
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
  bool _showingYearPicker = false;
  ScrollController? _yearScrollController;

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

  @override
  void dispose() {
    _yearScrollController?.dispose();
    super.dispose();
  }

  void _openYearPicker() {
    // Each row is ~42px tall (36px item + 6px spacing).
    // Scroll so the selected year's row is near the top of the visible area.
    const double rowHeight = 42.0;
    final int firstYear = widget.firstDate.year;
    final int rowIndex = (_selectedYear - firstYear) ~/ 3;
    final double offset = (rowIndex * rowHeight).clamp(0.0, double.infinity);
    _yearScrollController = ScrollController(initialScrollOffset: offset);
    setState(() => _showingYearPicker = true);
  }

  void _confirm() {
    Navigator.of(context).pop(DateTime(_selectedYear, _selectedMonth));
  }

  Widget _buildYearPicker(ColorScheme colorScheme) {
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (i) => widget.firstDate.year + i,
    );
    return SizedBox(
      height: 220,
      width: double.maxFinite,
      child: GridView.count(
        controller: _yearScrollController,
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        shrinkWrap: true,
        children: years.map((year) {
          final isSelected = year == _selectedYear;
          return Padding(
            padding: const EdgeInsets.all(3),
            child: TextButton(
              onPressed: () {
                _yearScrollController?.dispose();
                _yearScrollController = null;
                setState(() {
                  _selectedYear = year;
                  if (!_isMonthAllowed(_selectedMonth)) {
                    _selectedMonth = year == widget.firstDate.year
                        ? widget.firstDate.month
                        : 1;
                  }
                  _showingYearPicker = false;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isSelected
                    ? colorScheme.primary
                    : Colors.transparent,
                foregroundColor: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text('$year', style: const TextStyle(fontSize: 14)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthPicker(ColorScheme colorScheme) {
    return Column(
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
            GestureDetector(
              onTap: _openYearPicker,
              child: Text(
                '$_selectedYear',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      content: _showingYearPicker
          ? _buildYearPicker(colorScheme)
          : _buildMonthPicker(colorScheme),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (!_showingYearPicker)
          ElevatedButton(
            onPressed: _isMonthAllowed(_selectedMonth) ? _confirm : null,
            child: const Text('Select'),
          ),
      ],
    );
  }
}
