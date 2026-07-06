import 'package:shared_preferences/shared_preferences.dart';

import '../logic/game_controller.dart' show BestLevelStore;

class StorageService implements BestLevelStore {
  static const _bestLevelKey = 'best_level';

  @override
  Future<int> loadBestLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestLevelKey) ?? 0;
  }

  @override
  Future<void> saveBestLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bestLevelKey, level);
  }
}
