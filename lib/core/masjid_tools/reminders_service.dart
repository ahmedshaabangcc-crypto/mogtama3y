import 'package:supabase_flutter/supabase_flutter.dart';

import '../masjid/prayer_prefs.dart';
import 'reminder_settings.dart';

/// Server copy of «تنبيه الصلاة» (backend/migrations/0082_masjid_tools.sql):
/// with it, a pg_cron job sends the reminder as a phone notification
/// (Web Push) even while the app is closed. Signed-in users only.
class RemindersService {
  RemindersService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Future<void> sync(ReminderSettings s) async {
    if (!s.push || !s.anyOn) {
      await _db.rpc('clear_prayer_reminders');
      return;
    }
    await _db.rpc('set_prayer_reminders', params: {
      'p_lat': s.lat,
      'p_lng': s.lng,
      'p_offsets': s.offsetsJson,
      'p_label': s.label,
      // 0087: anywhere — the place's zone and the method the app uses there.
      'p_tz': s.zone,
      ...PrayerPrefs.current.value.serverParams(s.country),
    });
  }

  /// The saved server settings, or null.
  static Future<Map<String, dynamic>?> mine() async {
    final r = await _db.rpc('my_prayer_reminders');
    if (r is List && r.isNotEmpty) return Map<String, dynamic>.from(r.first as Map);
    if (r is Map) return Map<String, dynamic>.from(r);
    return null;
  }
}
