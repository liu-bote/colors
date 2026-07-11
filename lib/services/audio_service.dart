import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import 'settings_service.dart';

/// No-op by default so widget tests and the const app constructor need no
/// audio plugins; [GameAudioService] is the real implementation.
class AudioService {
  const AudioService();

  Future<void> syncBackgroundMusic() async {}
  Future<void> playCorrectTap() async {}
  Future<void> playWrongTap() async {}
  Future<void> playFailure() async {}
  Future<void> playVictory() async {}
  Future<void> dispose() async {}
}

class GameAudioService extends AudioService with WidgetsBindingObserver {
  static const _musicAsset = 'audio/color_spot_theme.wav';
  static const _correctAsset = 'audio/correct_tap.wav';
  static const _wrongAsset = 'audio/wrong_tap.wav';
  static const _failureAsset = 'audio/failure.wav';
  static const _victoryAsset = 'audio/victory.wav';

  final SettingsService settings;
  final AudioPlayer _musicPlayer = AudioPlayer(playerId: 'color_spot_music');
  final AudioPlayer _sfxPlayer = AudioPlayer(playerId: 'color_spot_sfx');

  bool _disposed = false;
  bool _musicReady = false;

  GameAudioService({required this.settings}) {
    settings.addListener(_onSettingsChanged);
    WidgetsBinding.instance.addObserver(this);
    unawaited(_configure());
  }

  Future<void> _configure() async {
    try {
      // Ambient category on iOS so the game respects the ring/silent switch.
      await AudioPlayer.global.setAudioContext(
        AudioContextConfig(respectSilence: true).build(),
      );
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.36);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await syncBackgroundMusic();
    } on Object catch (error, stackTrace) {
      debugPrint('Audio setup failed: $error\n$stackTrace');
    }
  }

  void _onSettingsChanged() {
    unawaited(syncBackgroundMusic());
    if (!settings.soundEnabled) {
      unawaited(_sfxPlayer.stop());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Parents don't want a kids' game playing on after the home button.
    if (state == AppLifecycleState.resumed) {
      unawaited(syncBackgroundMusic());
    } else {
      unawaited(_musicPlayer.pause());
    }
  }

  @override
  Future<void> syncBackgroundMusic() async {
    if (_disposed) return;
    try {
      if (settings.soundEnabled) {
        if (!_musicReady) {
          await _musicPlayer.setSource(AssetSource(_musicAsset));
          _musicReady = true;
        }
        if (_musicPlayer.state != PlayerState.playing) {
          await _musicPlayer.resume();
        }
      } else {
        await _musicPlayer.pause();
      }
    } on Object catch (error, stackTrace) {
      debugPrint('Background music failed: $error\n$stackTrace');
    }
  }

  @override
  Future<void> playCorrectTap() => _playSfx(_correctAsset, volume: 0.8);

  @override
  Future<void> playWrongTap() => _playSfx(_wrongAsset, volume: 0.5);

  @override
  Future<void> playFailure() => _playSfx(_failureAsset, volume: 0.8);

  @override
  Future<void> playVictory() => _playSfx(_victoryAsset, volume: 0.9);

  Future<void> _playSfx(String asset, {required double volume}) async {
    if (_disposed || !settings.soundEnabled) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(
        AssetSource(asset),
        volume: volume,
        mode: PlayerMode.lowLatency,
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Sound effect failed: $error\n$stackTrace');
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    settings.removeListener(_onSettingsChanged);
    await _musicPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
