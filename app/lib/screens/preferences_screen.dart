import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';

// ── Language metadata ──────────────────────────────────────────────────────

/// Supported display languages.  Each entry shows the language's native name
/// followed by its English name in parentheses so users can identify it
/// regardless of the current locale.
const List<(String code, String label)> _kLanguages = [
  ('en', 'English'),
  ('hi', 'हिन्दी (Hindi)'),
  ('es', 'Español (Spanish)'),
  ('fr', 'Français (French)'),
  ('de', 'Deutsch (German)'),
  ('ta', 'தமிழ் (Tamil)'),
  ('te', 'తెలుగు (Telugu)'),
  ('ml', 'മലയാളം (Malayalam)'),
  ('kn', 'ಕನ್ನಡ (Kannada)'),
];

// ── PreferencesScreen ──────────────────────────────────────────────────────

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key}); // coverage:ignore-line

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _prefs = PreferencesService();

  // Rebuild the screen whenever any preference changes so subtitles reflect
  // the updated values immediately.
  @override
  void initState() {
    super.initState();
    _prefs.addListener(_rebuild);
  }

  @override
  void dispose() {
    _prefs.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  // ── Theme dialog ─────────────────────────────────────────────────────────

  Future<void> _showThemeDialog() async {
    final l10n = AppLocalizations.of(context);
    ThemeMode? selected = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) {
        ThemeMode current = _prefs.themeMode;
        return StatefulBuilder(
          builder: (ctx2, setInner) => AlertDialog(
            title: Text(l10n.prefTheme),
            content: RadioGroup<ThemeMode>(
              groupValue: current,
              onChanged: (v) {
                if (v != null) setInner(() => current = v);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.prefThemeDefault),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.prefThemeDark),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, current),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      await _prefs.setThemeMode(selected);
    }
  }

  // ── Decimal places dialog ─────────────────────────────────────────────────

  Future<void> _showDecimalDialog() async {
    final l10n = AppLocalizations.of(context);
    int? selected = await showDialog<int>(
      context: context,
      builder: (ctx) {
        int current = _prefs.decimalPlaces;
        return StatefulBuilder(
          builder: (ctx2, setInner) => AlertDialog(
            title: Text(l10n.prefDecimalPlaces),
            content: RadioGroup<int>(
              groupValue: current,
              onChanged: (v) {
                if (v != null) setInner(() => current = v);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final example = _decimalExample(i);
                  return RadioListTile<int>(
                    title: Text('$i'),
                    subtitle: Text(example),
                    value: i,
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, current),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      await _prefs.setDecimalPlaces(selected);
    }
  }

  static String _decimalExample(int places) {
    const value = 1234.56789;
    return value.toStringAsFixed(places);
  }

  // ── Currency picker ───────────────────────────────────────────────────────

  Future<void> _showCurrencyPicker() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showDialog<CurrencyOption>(
      context: context,
      builder: (ctx) => _CurrencyPickerDialog(
        searchHint: l10n.searchCurrencies,
        cancelLabel: l10n.cancel,
        currentCode: _prefs.currencyCode,
      ),
    );
    if (selected != null) {
      await _prefs.setCurrencyCode(selected.code);
    }
  }

  // ── Language picker ───────────────────────────────────────────────────────

  Future<void> _showLanguagePicker() async {
    final l10n = AppLocalizations.of(context);
    String? selected = await showDialog<String>(
      context: context,
      builder: (ctx) {
        String current = _prefs.languageCode;
        return StatefulBuilder(
          builder: (ctx2, setInner) => AlertDialog(
            title: Text(l10n.prefLanguage),
            content: SizedBox(
              width: double.maxFinite,
              child: RadioGroup<String>(
                groupValue: current,
                onChanged: (v) {
                  if (v != null) setInner(() => current = v);
                },
                child: ListView(
                  shrinkWrap: true,
                  children: _kLanguages.map((entry) {
                    final (code, label) = entry;
                    return RadioListTile<String>(
                      title: Text(label),
                      value: code,
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, current),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != _prefs.languageCode) {
      await _prefs.setLanguageCode(selected);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _themeLabel(ThemeMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case ThemeMode.light:
      case ThemeMode.system: // coverage:ignore-line
        return l10n.prefThemeDefault;
      case ThemeMode.dark:
        return l10n.prefThemeDark;
    }
  }

  String _languageLabel(String code) {
    for (final (c, label) in _kLanguages) {
      if (c == code) return label;
    }
    return code;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = _prefs.currentCurrency;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferences)),
      body: ListView(
        children: [
          // ── Display ────────────────────────────────────────────────────
          _SectionHeader(l10n.prefSectionDisplay),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.prefTheme),
            subtitle: Text(_themeLabel(_prefs.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemeDialog,
          ),
          const Divider(indent: 56, endIndent: 0, height: 1),
          ListTile(
            leading: const Icon(Icons.format_list_numbered_outlined),
            title: Text(l10n.prefDecimalPlaces),
            subtitle: Text(
              '${_prefs.decimalPlaces}  —  e.g. ${_decimalExample(_prefs.decimalPlaces)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showDecimalDialog,
          ),

          // ── Regional ──────────────────────────────────────────────────
          _SectionHeader(l10n.prefSectionRegional),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: Text(l10n.prefCurrency),
            subtitle: Text(currency.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showCurrencyPicker,
          ),
          const Divider(indent: 56, endIndent: 0, height: 1),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.prefLanguage),
            subtitle: Text(_languageLabel(_prefs.languageCode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLanguagePicker,
          ),

          // ── Data Entry ────────────────────────────────────────────────
          _SectionHeader(l10n.prefSectionDataEntry),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              l10n.prefDataEntryEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── _SectionHeader ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.neutral,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── _CurrencyPickerDialog ──────────────────────────────────────────────────

class _CurrencyPickerDialog extends StatefulWidget {
  const _CurrencyPickerDialog({
    required this.searchHint,
    required this.cancelLabel,
    required this.currentCode,
  });

  final String searchHint;
  final String cancelLabel;
  final String currentCode;

  @override
  State<_CurrencyPickerDialog> createState() => _CurrencyPickerDialogState();
}

class _CurrencyPickerDialogState extends State<_CurrencyPickerDialog> {
  final _searchController = TextEditingController();
  List<CurrencyOption> _filtered = CurrencyOption.kAll;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? CurrencyOption.kAll
          : CurrencyOption.kAll
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(q) ||
                      c.symbol.toLowerCase().contains(q) ||
                      c.code.toLowerCase().contains(q),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 320,
        child: ListView.builder(
          itemCount: _filtered.length,
          itemBuilder: (ctx, i) {
            final c = _filtered[i];
            final isSelected = c.code == widget.currentCode;
            return ListTile(
              dense: true,
              leading: Text(
                c.symbol,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              title: Text(c.name),
              subtitle: Text(c.code),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => Navigator.pop(context, c),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancelLabel),
        ),
      ],
    );
  }
}
