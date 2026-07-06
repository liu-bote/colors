import 'dart:async';

import 'package:flutter/material.dart';

/// Rewarded-ad boundary. Swap [MockAdService] for a google_mobile_ads
/// implementation later without touching game logic.
abstract class AdService {
  /// Returns true only if the player watched the ad to completion.
  Future<bool> showRewardedAd(BuildContext context);
}

/// Placeholder: a full-screen fake ad with a 3-second countdown. Closing it
/// early forfeits the reward, matching real rewarded-ad behavior.
class MockAdService implements AdService {
  @override
  Future<bool> showRewardedAd(BuildContext context) async {
    final rewarded = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const _MockAdPage(),
      ),
    );
    return rewarded ?? false;
  }
}

class _MockAdPage extends StatefulWidget {
  const _MockAdPage();

  @override
  State<_MockAdPage> createState() => _MockAdPageState();
}

class _MockAdPageState extends State<_MockAdPage> {
  static const int _adSeconds = 3;
  int _remaining = _adSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remaining--);
      if (_remaining <= 0) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _remaining <= 0;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📺', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    const Text(
                      '模拟广告',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      done ? '广告播放完毕' : '广告播放中… $_remaining 秒',
                      style: const TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    if (done)
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.favorite),
                        label: const Text('领取奖励，复活！'),
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
