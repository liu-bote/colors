import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';

/// Asks whether to watch an ad for the one-per-run revive.
/// Returns true if the player wants to watch the ad.
Future<bool> showReviveDialog(BuildContext context, AppStrings s) async {
  final watch = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(s.reviveTitle),
      content: Text(s.reviveBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(s.giveUp),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.play_circle_outline),
          label: Text(s.watchAd),
        ),
      ],
    ),
  );
  return watch ?? false;
}

/// Run-over dialog. Returns true to start a new (free) game, false to go home.
Future<bool> showGameOverDialog(
    BuildContext context, AppStrings s, int level) async {
  final retry = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(s.gameOverTitle),
      content: Text(s.gameOverBody(level)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(s.goHome),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.refresh),
          label: Text(s.playAgain),
        ),
      ],
    ),
  );
  return retry ?? false;
}
