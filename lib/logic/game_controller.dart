import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'level_generator.dart';

enum GamePhase {
  /// Timer running, waiting for a tap.
  playing,

  /// Correct tile found; brief celebration before the next level.
  levelCleared,

  /// Wrong tap or timeout; brief feedback before retrying or ending.
  failFeedback,

  /// Out of lives, ad revive still available — waiting for the player's choice.
  reviveOffer,

  /// Run over. A new game is free (no ad).
  gameOver,

  /// All 100 levels cleared.
  victory,
}

enum FailReason { wrongTap, timeout }

/// Persistence boundary so the controller stays testable without plugins.
abstract class BestLevelStore {
  Future<int> loadBestLevel();
  Future<void> saveBestLevel(int level);
}

class GameController extends ChangeNotifier {
  static const int startingLives = 2;
  static const Duration clearedPause = Duration(milliseconds: 700);
  static const Duration failPause = Duration(milliseconds: 700);
  static const Duration tickInterval = Duration(milliseconds: 100);

  final LevelGenerator _generator;
  final BestLevelStore? store;

  GameController({LevelGenerator? generator, this.store})
      : _generator = generator ?? LevelGenerator() {
    startNewGame();
  }

  late LevelBoard board;
  GamePhase phase = GamePhase.playing;
  int level = 1;
  int lives = startingLives;
  bool reviveUsed = false;
  double remainingSeconds = 0;
  FailReason? lastFail;

  /// Index the player tapped by mistake, for shake/flash feedback.
  int? wrongIndex;

  int _bestLevel = 0;
  Timer? _ticker;
  Timer? _phaseTimer;

  double get timeFraction =>
      board.config.timeLimit == 0 ? 0 : remainingSeconds / board.config.timeLimit;

  void startNewGame() {
    _phaseTimer?.cancel();
    level = 1;
    lives = startingLives;
    reviveUsed = false;
    _startLevel();
  }

  /// Grants the one-per-run ad revive: fresh lives, retry the current level.
  void reviveWithAd() {
    assert(phase == GamePhase.reviveOffer && !reviveUsed);
    reviveUsed = true;
    lives = startingLives;
    _startLevel();
  }

  void declineRevive() {
    if (phase != GamePhase.reviveOffer) return;
    phase = GamePhase.gameOver;
    notifyListeners();
  }

  void tapTile(int index) {
    if (phase != GamePhase.playing) return;
    if (index == board.oddIndex) {
      _onCorrect();
    } else {
      _fail(FailReason.wrongTap, tappedIndex: index);
    }
  }

  @visibleForTesting
  void debugJumpToLevel(int target) {
    level = target;
    _startLevel();
  }

  void _startLevel() {
    board = _generator.generate(level);
    remainingSeconds = board.config.timeLimit;
    lastFail = null;
    wrongIndex = null;
    phase = GamePhase.playing;
    _startTicker();
    notifyListeners();
  }

  void _onCorrect() {
    _stopTicker();
    _bestLevel = max(_bestLevel, level);
    store?.saveBestLevel(_bestLevel);
    if (level >= LevelGenerator.maxLevel) {
      phase = GamePhase.victory;
    } else {
      phase = GamePhase.levelCleared;
      _phaseTimer = Timer(clearedPause, () {
        level++;
        _startLevel();
      });
    }
    notifyListeners();
  }

  void _fail(FailReason reason, {int? tappedIndex}) {
    _stopTicker();
    lives--;
    lastFail = reason;
    wrongIndex = tappedIndex;
    phase = GamePhase.failFeedback;
    _phaseTimer = Timer(failPause, () {
      if (lives > 0) {
        _startLevel();
      } else {
        phase = reviveUsed ? GamePhase.gameOver : GamePhase.reviveOffer;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void _startTicker() {
    _stopTicker();
    _ticker = Timer.periodic(tickInterval, (_) {
      remainingSeconds =
          max(0, remainingSeconds - tickInterval.inMilliseconds / 1000);
      if (remainingSeconds <= 0) {
        _fail(FailReason.timeout);
      } else {
        notifyListeners();
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    _phaseTimer?.cancel();
    super.dispose();
  }
}
