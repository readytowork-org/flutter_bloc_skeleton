import 'package:shared_preferences/shared_preferences.dart';

class OptimizationService {
  final SharedPreferences _prefs;

  static const _kAutoDownloadOnWifi = 'opt_auto_download_on_wifi';
  static const _kDataSaverMode = 'opt_data_saver_mode';

  OptimizationService(this._prefs);

  bool get autoDownloadOnWifi => _prefs.getBool(_kAutoDownloadOnWifi) ?? true;
  bool get dataSaverMode => _prefs.getBool(_kDataSaverMode) ?? false;

  Future<void> setAutoDownloadOnWifi(bool value) async {
    await _prefs.setBool(_kAutoDownloadOnWifi, value);
  }

  Future<void> setDataSaverMode(bool value) async {
    await _prefs.setBool(_kDataSaverMode, value);
  }
}
