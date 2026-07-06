import 'package:flutter/material.dart';

import '../logic/game_controller.dart';
import '../logic/level_generator.dart';

class ColorGrid extends StatelessWidget {
  final LevelBoard board;
  final GamePhase phase;
  final int? wrongIndex;
  final ValueChanged<int> onTapTile;

  const ColorGrid({
    super.key,
    required this.board,
    required this.phase,
    required this.wrongIndex,
    required this.onTapTile,
  });

  @override
  Widget build(BuildContext context) {
    final n = board.config.gridSize;
    final spacing = n >= 8 ? 4.0 : 6.0;
    final radius = n >= 8 ? 6.0 : 10.0;
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: n,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        itemCount: board.tileCount,
        itemBuilder: (context, index) {
          final isOdd = index == board.oddIndex;
          final revealCorrect = phase == GamePhase.levelCleared && isOdd;
          final revealWrong =
              phase == GamePhase.failFeedback && index == wrongIndex;
          return GestureDetector(
            onTap: () => onTapTile(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isOdd ? board.oddColor : board.baseColor,
                borderRadius: BorderRadius.circular(radius),
                border: revealCorrect
                    ? Border.all(color: Colors.white, width: 3)
                    : revealWrong
                        ? Border.all(color: Colors.redAccent, width: 3)
                        : null,
              ),
              child: revealCorrect
                  ? const Icon(Icons.check, color: Colors.white)
                  : revealWrong
                      ? const Icon(Icons.close, color: Colors.redAccent)
                      : null,
            ),
          );
        },
      ),
    );
  }
}
