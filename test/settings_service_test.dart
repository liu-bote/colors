import 'package:color_spot/services/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sound defaults to on', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService();
    await settings.load();
    expect(settings.soundEnabled, isTrue);
  });

  test('sound setting loads from prefs', () async {
    SharedPreferences.setMockInitialValues({'sound_enabled': false});
    final settings = SettingsService();
    await settings.load();
    expect(settings.soundEnabled, isFalse);
  });

  test('toggleSound flips and persists', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService();
    await settings.load();

    await settings.toggleSound();
    expect(settings.soundEnabled, isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('sound_enabled'), isFalse);

    await settings.toggleSound();
    expect(settings.soundEnabled, isTrue);
    expect(prefs.getBool('sound_enabled'), isTrue);
  });
}
