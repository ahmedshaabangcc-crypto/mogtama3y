/// No Intl off the web: the caller uses its rule table.
String? platformDeviceTimeZone() => null;

/// Offset in minutes of [tz] at [utc], or null when unknown here.
int? platformOffsetMinutes(String tz, DateTime utc) => null;

/// Whether [tz] is a zone this platform knows (null = can't tell).
bool? platformKnowsZone(String tz) => null;
