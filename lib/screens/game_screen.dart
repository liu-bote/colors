import 'package:flutter/material.dart';

import '../logic/game_controller.dart';
import '../logic/level_generator.dart';
import '../services/ad_service.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';
import '../services/storage_service.dart';
import '../widgets/color_grid.dart';
import '../widgets/game_over_dialog.dart';
import 'victory_screen.dart';

class GameScreen extends StatefulWidget {
  final AdService adService;
  final AudioService audio;
  final SettingsService settings;

  const GameScreen({
    super.key,
    required this.adService,
    required this.audio,
    required this.settings,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  bool _handlingPhase = false;
  GamePhase? _lastSoundPhase;

  @override
  void initState() {
    super.initState();
    _controller = GameController(store: StorageService());
    _controller.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onGameStateChanged() async {
    final phase = _controller.phase;
    _playPhaseSound(phase);
    final needsHandling =
        phase == GamePhase.reviveOffer ||
        phase == GamePhase.gameOver ||
        phase == GamePhase.victory;
    if (!needsHandling || _handlingPhase || !mounted) return;
    _handlingPhase = true;
    try {
      switch (phase) {
        case GamePhase.reviveOffer:
          await _handleReviveOffer();
        case GamePhase.gameOver:
          await _handleGameOver();
        case GamePhase.victory:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => VictoryScreen(settings: widget.settings),
            ),
          );
        default:
          break;
      }
    } finally {
      _handlingPhase = false;
    }
  }

  /// Sounds follow the controller's phase so audio can never disagree with
  /// the actual game outcome. gameOver and reviveOffer stay silent: the
  /// failure sound already played during the failFeedback that led there.
  void _playPhaseSound(GamePhase phase) {
    if (_lastSoundPhase == phase) return;
    _lastSoundPhase = phase;
    switch (phase) {
      case GamePhase.levelCleared:
        widget.audio.playCorrectTap();
      case GamePhase.failFeedback:
        if (_controller.lastFail == FailReason.timeout) {
          widget.audio.playFailure();
        } else {
          widget.audio.playWrongTap();
        }
      case GamePhase.victory:
        widget.audio.playVictory();
      case GamePhase.playing:
      case GamePhase.reviveOffer:
      case GamePhase.gameOver:
        break;
    }
  }

  Future<void> _handleReviveOffer() async {
    final wantsAd = await showReviveDialog(context, widget.settings.strings);
    if (!mounted) return;
    if (!wantsAd) {
      _controller.declineRevive();
      return;
    }
    final rewarded = await widget.adService.showRewardedAd(context);
    if (!mounted) return;
    if (rewarded) {
      _controller.reviveWithAd();
    } else {
      _controller.declineRevive();
    }
  }

  Future<void> _handleGameOver() async {
    final retry = await showGameOverDialog(
      context,
      widget.settings.strings,
      _controller.level,
    );
    if (!mounted) return;
    if (retry) {
      _controller.startNewGame();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([_controller, widget.settings]),
          builder: (context, _) {
            final c = _controller;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _TopBar(controller: c, settings: widget.settings),
                  const SizedBox(height: 12),
                  _TimerBar(fraction: c.timeFraction),
                  const SizedBox(height: 20),
                  _ColorNameCard(controller: c, settings: widget.settings),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ColorGrid(
                          board: c.board,
                          phase: c.phase,
                          wrongIndex: c.wrongIndex,
                          onTapTile: c.tapTile,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 48, child: Center(child: _statusText(c))),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget? _statusText(GameController c) {
    final s = widget.settings.strings;
    final style = Theme.of(context).textTheme.titleMedium;
    if (c.phase == GamePhase.failFeedback) {
      return Text(
        c.lastFail == FailReason.timeout ? s.timeUp : s.wrongTap,
        style: style?.copyWith(color: Colors.redAccent),
      );
    }
    if (c.phase == GamePhase.levelCleared) {
      return Text(s.found, style: style?.copyWith(color: Colors.greenAccent));
    }
    if (c.level <= 3) {
      return Text(s.hint, textAlign: TextAlign.center, style: style);
    }
    return null;
  }
}

class _TopBar extends StatelessWidget {
  final GameController controller;
  final SettingsService settings;

  const _TopBar({required this.controller, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: Text(
            settings.strings.levelLabel(
              controller.level,
              LevelGenerator.maxLevel,
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        for (var i = 0; i < GameController.startingLives; i++)
          Icon(
            i < controller.lives ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
            size: 26,
          ),
        const SizedBox(width: 4),
        IconButton(
          icon: Icon(
            settings.soundEnabled ? Icons.volume_up : Icons.volume_off,
          ),
          tooltip: settings.strings.soundEffectsLabel,
          onPressed: settings.toggleSound,
        ),
      ],
    );
  }
}

class _TimerBar extends StatelessWidget {
  final double fraction;

  const _TimerBar({required this.fraction});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: fraction,
        minHeight: 10,
        backgroundColor: Colors.white12,
        color: Color.lerp(Colors.redAccent, Colors.greenAccent, fraction),
      ),
    );
  }
}

/// The learning element: the Crayola color name in the primary language,
/// with the optional second (learning) language right below it.
class _ColorNameCard extends StatelessWidget {
  final GameController controller;
  final SettingsService settings;

  const _ColorNameCard({required this.controller, required this.settings});

  @override
  Widget build(BuildContext context) {
    final crayola = controller.board.crayola;
    final primaryName = crayola.nameIn(settings.primaryLang);
    final secondaryLang = settings.secondaryLang;
    final secondaryName = secondaryLang == null
        ? null
        : crayola.nameIn(secondaryLang);

    // Tablets get comfortably larger text than the theme's phone-sized
    // titleMedium/bodySmall, which reads tiny on a 10" portrait screen.
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final scale = shortestSide >= 600 ? 1.5 : 1.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20 * scale,
        vertical: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28 * scale,
            height: 28 * scale,
            decoration: BoxDecoration(
              color: crayola.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
          ),
          SizedBox(width: 12 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                primaryName,
                style: TextStyle(
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (secondaryName != null && secondaryName != primaryName)
                Text(
                  secondaryName,
                  style: TextStyle(fontSize: 15 * scale, color: Colors.white70),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
