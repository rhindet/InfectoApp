import 'package:shared_preferences/shared_preferences.dart';

class TermsService {
  static const _kKey = 'termsAccepted_v1'; // súbele a v2 si cambias T&C en el futuro

  static Future<bool> isAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kKey) ?? false;
  }

  static Future<void> accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kKey, true);
  }

  static Future<void> revoke() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kKey);
  }
}