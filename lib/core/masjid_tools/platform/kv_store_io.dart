import 'package:shared_preferences/shared_preferences.dart';

Future<String?> kvGet(String key) async {
  try {
    return (await SharedPreferences.getInstance()).getString(key);
  } catch (_) {
    return null;
  }
}

Future<void> kvSet(String key, String value) async {
  try {
    await (await SharedPreferences.getInstance()).setString(key, value);
  } catch (_) {}
}
