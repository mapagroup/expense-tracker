import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../screens/preferences_screen.dart';
import '../theme/app_theme.dart';

/// The application-level navigation drawer shown from the [HomeScreen] AppBar.
///
/// Provides access to app-level destinations (e.g. Preferences) without
/// navigating away from the current screen.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key}); // coverage:ignore-line

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: AppColors.primary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/app_icon.png',
                width: 48,
                height: 48,
                cacheWidth: (48 * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                cacheHeight: (48 * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                excludeFromSemantics: true,
              ),
              const SizedBox(height: 12),
              Text(
                'Mapa Money',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context).appTagline,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: Text(AppLocalizations.of(context).preferences),
          onTap: () {
            final navigator = Navigator.of(context);
            navigator.pop();
            Future.microtask(
              () => navigator.push(
                MaterialPageRoute(
                  builder: (context) => const PreferencesScreen(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
