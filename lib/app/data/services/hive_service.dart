import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../config/app_constants.dart';

class HiveService extends GetxService {
  late Box _userBox;
  late Box _settingsBox;

  Future<HiveService> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox(AppConstants.userBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
    return this;
  }

  // User Local Cache
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _userBox.put('current_user', userData);
  }

  Map<String, dynamic>? getUserData() {
    final data = _userBox.get('current_user');
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<void> clearUserData() async {
    await _userBox.delete('current_user');
  }

  // Settings Cache
  Future<void> saveThemeMode(bool isDarkMode) async {
    await _settingsBox.put('is_dark_mode', isDarkMode);
  }

  bool getThemeMode() {
    return _settingsBox.get('is_dark_mode', defaultValue: false);
  }
}
