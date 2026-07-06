import 'dart:math';
import 'dart:ui' show Color;

import 'package:flutter/painting.dart' show HSLColor;

import '../data/crayola_colors.dart';

/// Difficulty parameters for one level.
class LevelConfig {
  final int level;
  final int gridSize;

  /// Lightness offset between the odd tile and the rest, in HSL space.
  final double colorDelta;

  /// Seconds the player has to find the odd tile.
  final double timeLimit;

  const LevelConfig({
    required this.level,
    required this.gridSize,
    required this.colorDelta,
    required this.timeLimit,
  });
}

/// A concrete playable board: a Crayola base color plus one odd tile.
class LevelBoard {
  final LevelConfig config;
  final CrayolaColor crayola;
  final Color oddColor;
  final int oddIndex;

  const LevelBoard({
    required this.config,
    required this.crayola,
    required this.oddColor,
    required this.oddIndex,
  });

  Color get baseColor => crayola.color;
  int get tileCount => config.gridSize * config.gridSize;
}

class LevelGenerator {
  static const int maxLevel = 100;

  final Random _random;
  final List<CrayolaColor> _deck = List.of(crayolaColors);
  int _deckPos = 0;

  LevelGenerator({Random? random}) : _random = random ?? Random() {
    _deck.shuffle(_random);
  }

  /// Difficulty curve: small grids and big color differences early on to
  /// teach the mechanic, ramping to 9x9 grids with subtle differences.
  static LevelConfig configFor(int level) {
    assert(level >= 1 && level <= maxLevel);
    final t = (level - 1) / (maxLevel - 1);
    return LevelConfig(
      level: level,
      gridSize: _gridSizeFor(level),
      colorDelta: 0.30 - 0.265 * t,
      timeLimit: 10 - 5 * t,
    );
  }

  static int _gridSizeFor(int level) {
    if (level <= 3) return 2;
    if (level <= 8) return 3;
    if (level <= 18) return 4;
    if (level <= 32) return 5;
    if (level <= 50) return 6;
    if (level <= 70) return 7;
    if (level <= 90) return 8;
    return 9;
  }

  /// Draws Crayola colors from a shuffled deck so kids see the whole palette
  /// before any color repeats.
  CrayolaColor _nextCrayola() {
    if (_deckPos >= _deck.length) {
      _deck.shuffle(_random);
      _deckPos = 0;
    }
    return _deck[_deckPos++];
  }

  LevelBoard generate(int level) {
    final config = configFor(level);
    final crayola = _nextCrayola();
    final hsl = HSLColor.fromColor(crayola.color);
    final l = hsl.lightness;
    // Shift lightness in a direction that keeps the odd tile distinguishable
    // even for near-white or near-black crayons.
    final canUp = l + config.colorDelta <= 0.92;
    final canDown = l - config.colorDelta >= 0.08;
    final shiftUp = (canUp && canDown) ? _random.nextBool() : canUp;
    final oddLightness =
        (l + (shiftUp ? config.colorDelta : -config.colorDelta))
            .clamp(0.03, 0.97);
    return LevelBoard(
      config: config,
      crayola: crayola,
      oddColor: hsl.withLightness(oddLightness).toColor(),
      oddIndex: _random.nextInt(config.gridSize * config.gridSize),
    );
  }
}
