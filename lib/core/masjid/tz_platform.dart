// The device's IANA time zone and exact UTC offsets for any zone: on the
// web from the browser's Intl API (the full tz database); elsewhere null,
// and world_time.dart falls back to its compact rule table.
export 'tz_platform_io.dart' if (dart.library.js_interop) 'tz_platform_web.dart';
