import 'package:flutter/material.dart';

import '../data/crayola_colors.dart';
import '../services/settings_service.dart';

class VictoryScreen extends StatelessWidget {
  final SettingsService settings;

  const VictoryScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final s = settings.strings;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 96)),
                const SizedBox(height: 24),
                Text(
                  s.victoryTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  s.victoryBody(crayolaColors.length),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(s.goHome),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
