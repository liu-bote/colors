import 'package:flutter/material.dart';

import '../data/crayola_colors.dart';
import '../services/ad_service.dart';
import '../services/settings_service.dart';
import '../services/storage_service.dart';
import '../widgets/language_settings_dialog.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  final AdService adService;
  final StorageService storage;
  final SettingsService settings;

  const HomeScreen({
    super.key,
    required this.adService,
    required this.storage,
    required this.settings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bestLevel = 0;

  @override
  void initState() {
    super.initState();
    _loadBest();
  }

  Future<void> _loadBest() async {
    final best = await widget.storage.loadBestLevel();
    if (mounted) setState(() => _bestLevel = best);
  }

  Future<void> _startGame() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(
          adService: widget.adService,
          settings: widget.settings,
        ),
      ),
    );
    _loadBest();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) {
        final s = widget.settings.strings;
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: const Icon(Icons.language),
                      iconSize: 28,
                      tooltip: s.settingsTitle,
                      onPressed: () =>
                          showLanguageSettingsDialog(context, widget.settings),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _PaletteBanner(),
                      const SizedBox(height: 32),
                      Text(
                        s.appTitle,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.tagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 48),
                      FilledButton(
                        onPressed: _startGame,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          child: Text(s.start,
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _bestLevel > 0 ? s.bestLevel(_bestLevel) : s.challenge,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A playful strip of Crayola swatches as the home page hero.
class _PaletteBanner extends StatelessWidget {
  const _PaletteBanner();

  static const _swatchNames = [
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Cerulean',
    'Blue',
    'Violet',
  ];

  @override
  Widget build(BuildContext context) {
    final swatches = [
      for (final name in _swatchNames)
        crayolaColors.firstWhere((c) => c.name == name),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final s in swatches)
          Container(
            width: 32,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: s.color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}
