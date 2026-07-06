import 'dart:math';

import 'package:color_spot/data/crayola_colors.dart';
import 'package:color_spot/logic/level_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('difficulty curve', () {
    test('starts tiny and easy for onboarding', () {
      final first = LevelGenerator.configFor(1);
      expect(first.gridSize, 2);
      expect(first.colorDelta, closeTo(0.30, 0.001));
      expect(first.timeLimit, closeTo(10, 0.001));
    });

    test('ends at 9x9 with a subtle difference', () {
      final last = LevelGenerator.configFor(100);
      expect(last.gridSize, 9);
      expect(last.colorDelta, closeTo(0.035, 0.001));
      expect(last.timeLimit, closeTo(5, 0.001));
    });

    test('grid grows, delta shrinks, time shrinks monotonically', () {
      for (var level = 2; level <= 100; level++) {
        final prev = LevelGenerator.configFor(level - 1);
        final cur = LevelGenerator.configFor(level);
        expect(cur.gridSize, greaterThanOrEqualTo(prev.gridSize));
        expect(cur.colorDelta, lessThan(prev.colorDelta));
        expect(cur.timeLimit, lessThan(prev.timeLimit));
        expect(cur.colorDelta, greaterThanOrEqualTo(0.03));
        expect(cur.timeLimit, greaterThanOrEqualTo(5));
      }
    });
  });

  group('board generation', () {
    test('every level produces a findable odd tile', () {
      final generator = LevelGenerator(random: Random(42));
      for (var level = 1; level <= 100; level++) {
        final board = generator.generate(level);
        expect(board.oddIndex, inInclusiveRange(0, board.tileCount - 1));
        expect(board.oddColor, isNot(equals(board.baseColor)),
            reason: 'level $level odd tile must differ from base');
        expect(board.crayola.name, isNotEmpty);
      }
    });

    test('crayola deck reshuffles without repeating within a cycle', () {
      final generator = LevelGenerator(random: Random(7));
      final seen = <String>{};
      // A full deck cycle must contain no repeats.
      for (var i = 0; i < crayolaColors.length; i++) {
        final board = generator.generate(50);
        expect(seen.add(board.crayola.name), isTrue,
            reason: '${board.crayola.name} repeated within one deck cycle');
      }
      // Deck exhausted — further draws must still work.
      expect(() => generator.generate(50), returnsNormally);
    });
  });
}
