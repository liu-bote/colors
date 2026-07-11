import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../services/settings_service.dart';

/// Picker for the app language and the optional second (learning) language.
/// The second language never equals the primary; choosing a primary that
/// matches the current second language clears the second one.
Future<void> showLanguageSettingsDialog(
  BuildContext context,
  SettingsService settings,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final s = settings.strings;
        return AlertDialog(
          title: Text('🌍 ${s.settingsTitle}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.languageLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final lang in supportedLanguages)
                      ChoiceChip(
                        label: Text(lang.nativeName),
                        selected: settings.primaryLang == lang.code,
                        onSelected: (_) => settings.setPrimaryLang(lang.code),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  s.secondLanguageLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  s.secondLanguageHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(s.none),
                      selected: settings.secondaryLang == null,
                      onSelected: (_) => settings.setSecondaryLang(null),
                    ),
                    for (final lang in supportedLanguages)
                      if (lang.code != settings.primaryLang)
                        ChoiceChip(
                          label: Text(lang.nativeName),
                          selected: settings.secondaryLang == lang.code,
                          onSelected: (_) =>
                              settings.setSecondaryLang(lang.code),
                        ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(s.done),
            ),
          ],
        );
      },
    ),
  );
}
