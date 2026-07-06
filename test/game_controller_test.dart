import 'dart:math';

import 'package:color_spot/logic/game_controller.dart';
import 'package:color_spot/logic/level_generator.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryStore implements BestLevelStore {
  int best = 0;

  @override
  Future<int> loadBestLevel() async => best;

  @override
  Future<void> saveBestLevel(int level) async => best = level;
}

GameController _newController({BestLevelStore? store}) => GameController(
      generator: LevelGenerator(random: Random(1)),
      store: store,
    );

void _tapWrong(GameController c) =>
    c.tapTile((c.board.oddIndex + 1) % c.board.tileCount);

void _settleFailPause(FakeAsync async) =>
    async.elapse(GameController.failPause + const Duration(milliseconds: 10));

void main() {
  test('new game starts at level 1 with 2 lives', () {
    fakeAsync((async) {
      final c = _newController();
      expect(c.level, 1);
      expect(c.lives, GameController.startingLives);
      expect(c.reviveUsed, isFalse);
      expect(c.phase, GamePhase.playing);
      c.dispose();
    });
  });

  test('correct tap advances to the next level and saves best', () {
    fakeAsync((async) {
      final store = _MemoryStore();
      final c = _newController(store: store);
      c.tapTile(c.board.oddIndex);
      expect(c.phase, GamePhase.levelCleared);
      async.elapse(GameController.clearedPause + const Duration(milliseconds: 10));
      expect(c.level, 2);
      expect(c.phase, GamePhase.playing);
      expect(store.best, 1);
      c.dispose();
    });
  });

  test('wrong tap costs a life then retries the same level', () {
    fakeAsync((async) {
      final c = _newController();
      _tapWrong(c);
      expect(c.lives, 1);
      expect(c.phase, GamePhase.failFeedback);
      expect(c.lastFail, FailReason.wrongTap);
      _settleFailPause(async);
      expect(c.level, 1);
      expect(c.phase, GamePhase.playing);
      c.dispose();
    });
  });

  test('timeout costs a life', () {
    fakeAsync((async) {
      final c = _newController();
      // Level 1 allows 10 seconds; stop just past the timeout, inside the
      // fail-feedback pause.
      async.elapse(const Duration(seconds: 10, milliseconds: 100));
      expect(c.lives, 1);
      expect(c.lastFail, FailReason.timeout);
      expect(c.phase, GamePhase.failFeedback);
      // After the pause the same level restarts with a fresh timer.
      _settleFailPause(async);
      expect(c.level, 1);
      expect(c.phase, GamePhase.playing);
      c.dispose();
    });
  });

  test('losing all lives offers the one-time ad revive', () {
    fakeAsync((async) {
      final c = _newController();
      _tapWrong(c);
      _settleFailPause(async);
      _tapWrong(c);
      _settleFailPause(async);
      expect(c.lives, 0);
      expect(c.phase, GamePhase.reviveOffer);

      c.reviveWithAd();
      expect(c.reviveUsed, isTrue);
      expect(c.lives, GameController.startingLives);
      expect(c.phase, GamePhase.playing);

      // Second wipe-out: no more revive, straight to game over.
      _tapWrong(c);
      _settleFailPause(async);
      _tapWrong(c);
      _settleFailPause(async);
      expect(c.phase, GamePhase.gameOver);
      c.dispose();
    });
  });

  test('declining the revive ends the run', () {
    fakeAsync((async) {
      final c = _newController();
      _tapWrong(c);
      _settleFailPause(async);
      _tapWrong(c);
      _settleFailPause(async);
      c.declineRevive();
      expect(c.phase, GamePhase.gameOver);

      // A new game after a lost run is free and fully reset.
      c.startNewGame();
      expect(c.level, 1);
      expect(c.lives, GameController.startingLives);
      expect(c.reviveUsed, isFalse);
      expect(c.phase, GamePhase.playing);
      c.dispose();
    });
  });

  test('clearing level 100 wins the game', () {
    fakeAsync((async) {
      final c = _newController();
      c.debugJumpToLevel(LevelGenerator.maxLevel);
      c.tapTile(c.board.oddIndex);
      expect(c.phase, GamePhase.victory);
      c.dispose();
    });
  });

  test('taps are ignored outside the playing phase', () {
    fakeAsync((async) {
      final c = _newController();
      c.tapTile(c.board.oddIndex);
      expect(c.phase, GamePhase.levelCleared);
      final levelBefore = c.level;
      c.tapTile(c.board.oddIndex);
      expect(c.level, levelBefore);
      c.dispose();
    });
  });
}
