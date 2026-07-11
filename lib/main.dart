import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/audio_service.dart';
import 'services/settings_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsService();
  await settings.load();
  final audio = GameAudioService(settings: settings);
  runApp(ColorSpotApp(settings: settings, audio: audio));
}

class ColorSpotApp extends StatelessWidget {
  final SettingsService settings;
  final AudioService audio;

  const ColorSpotApp({
    super.key,
    required this.settings,
    this.audio = const AudioService(),
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        title: settings.strings.appTitle,
        debugShowCheckedModeBanner: false,
        // Wraps the Navigator, so every route and dialog inherits the
        // direction of the primary language.
        builder: (context, child) => Directionality(
          textDirection: settings.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF14181F),
          colorSchemeSeed: const Color(0xFF1DACD6),
        ),
        home: HomeScreen(
          adService: MockAdService(),
          audio: audio,
          storage: StorageService(),
          settings: settings,
        ),
      ),
    );
  }
}
