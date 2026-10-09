// Tiny key/value storage for the mosque tools' local settings (Quran
// bookmark, font size, tasbeeh, adhkar progress, reminders). On the web it
// is window.localStorage directly — no plugin code in the first load;
// elsewhere SharedPreferences.
export 'kv_store_io.dart' if (dart.library.js_interop) 'kv_store_web.dart';
