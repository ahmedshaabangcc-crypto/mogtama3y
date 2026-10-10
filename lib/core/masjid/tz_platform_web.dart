import 'dart:js_interop';
import 'dart:js_interop_unsafe';

final _formatters = <String, JSObject?>{};

JSObject? _formatter(String tz) => _formatters.putIfAbsent(tz, () {
      try {
        final ctor = (globalContext['Intl'] as JSObject)['DateTimeFormat'] as JSFunction;
        final opts = JSObject()
          ..['timeZone'] = tz.toJS
          ..['hourCycle'] = 'h23'.toJS
          ..['year'] = 'numeric'.toJS
          ..['month'] = 'numeric'.toJS
          ..['day'] = 'numeric'.toJS
          ..['hour'] = 'numeric'.toJS
          ..['minute'] = 'numeric'.toJS
          ..['second'] = 'numeric'.toJS;
        return ctor.callAsConstructor<JSObject>('en-US'.toJS, opts);
      } catch (_) {
        return null; // RangeError: unknown zone
      }
    });

/// The browser's IANA zone, e.g. "Asia/Dubai".
String? platformDeviceTimeZone() {
  try {
    final ctor = (globalContext['Intl'] as JSObject)['DateTimeFormat'] as JSFunction;
    final f = ctor.callAsConstructor<JSObject>();
    final opts = f.callMethod<JSObject>('resolvedOptions'.toJS);
    final tz = (opts['timeZone'] as JSString?)?.toDart;
    return (tz == null || tz.isEmpty) ? null : tz;
  } catch (_) {
    return null;
  }
}

/// Exact offset (minutes) of [tz] at the instant [utc], from Intl.
int? platformOffsetMinutes(String tz, DateTime utc) {
  final f = _formatter(tz);
  if (f == null) return null;
  try {
    final ms = utc.millisecondsSinceEpoch;
    final date = (globalContext['Date'] as JSFunction).callAsConstructor<JSObject>(ms.toJS);
    final parts = f.callMethod<JSArray<JSObject>>('formatToParts'.toJS, date).toDart;
    final v = <String, int>{};
    for (final p in parts) {
      final type = (p['type'] as JSString).toDart;
      final n = int.tryParse((p['value'] as JSString).toDart);
      if (n != null) v[type] = n;
    }
    final wall = DateTime.utc(v['year']!, v['month']!, v['day']!, v['hour']! % 24, v['minute']!, v['second'] ?? 0);
    final whole = DateTime.utc(utc.year, utc.month, utc.day, utc.hour, utc.minute, utc.second);
    return wall.difference(whole).inMinutes;
  } catch (_) {
    return null;
  }
}

bool? platformKnowsZone(String tz) => _formatter(tz) != null;
