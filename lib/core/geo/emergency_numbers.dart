/// Emergency numbers of the 22 Arab states (police / ambulance / fire, plus
/// a few useful extras). Sources: the national lists collected on
/// Wikipedia's «List of emergency telephone numbers» (checked Oct 2026)
/// and the countries' official announcements we know of. A null number
/// means we could not confirm it — the screen then says so honestly and
/// points to the general number instead of guessing.
///
/// The SQL twin (the SOS notification text) is private.emergency_text()
/// in backend/migrations/0093.
library;

class EmergencyNumbers {
  const EmergencyNumbers({this.police, this.ambulance, this.fire, this.unified, this.extras = const [], this.uncertain = false});

  final String? police;
  final String? ambulance;
  final String? fire;

  /// One number for everything (112 / 911 / 999 / 9999), when the country has it.
  final String? unified;

  /// (label, number) — gas emergency, civil defence…
  final List<(String, String)> extras;

  /// Some numbers could not be confirmed from a reliable source.
  final bool uncertain;
}

const emergencyByCountry = <String, EmergencyNumbers>{
  'EG': EmergencyNumbers(police: '122', ambulance: '123', fire: '180', extras: [('طوارئ الغاز', '129')]),
  'SA': EmergencyNumbers(police: '999', ambulance: '997', fire: '998', unified: '911', extras: [('المرور', '993')]),
  'AE': EmergencyNumbers(police: '999', ambulance: '998', fire: '997', extras: [('خفر السواحل', '996')]),
  'KW': EmergencyNumbers(unified: '112'),
  'QA': EmergencyNumbers(unified: '999'),
  'BH': EmergencyNumbers(unified: '999'),
  'OM': EmergencyNumbers(unified: '9999'),
  'YE': EmergencyNumbers(police: '194', ambulance: '191', uncertain: true),
  'JO': EmergencyNumbers(unified: '911'),
  'PS': EmergencyNumbers(police: '100', ambulance: '101', fire: '102'),
  'LB': EmergencyNumbers(police: '112', ambulance: '140', fire: '175', extras: [('الدفاع المدني', '125')]),
  'SY': EmergencyNumbers(police: '112', ambulance: '110', fire: '113'),
  'IQ': EmergencyNumbers(police: '104', ambulance: '122', fire: '115', unified: '911'),
  'SD': EmergencyNumbers(police: '999', uncertain: true),
  'LY': EmergencyNumbers(police: '1515', ambulance: '193', uncertain: true),
  'TN': EmergencyNumbers(police: '197', ambulance: '190', fire: '198', extras: [('الحرس الوطني', '193')]),
  'DZ': EmergencyNumbers(police: '1548', ambulance: '14', fire: '14', extras: [('الدرك الوطني', '1055')]),
  'MA': EmergencyNumbers(police: '19', ambulance: '15', fire: '15', extras: [('الدرك الملكي', '177')]),
  'MR': EmergencyNumbers(police: '117', ambulance: '101', fire: '118', extras: [('الدرك', '116')]),
  'SO': EmergencyNumbers(police: '888', ambulance: '999', fire: '555', uncertain: true),
  'DJ': EmergencyNumbers(police: '17', ambulance: '19', fire: '18'),
  'KM': EmergencyNumbers(police: '17', fire: '18', uncertain: true),
};

/// Numbers of [iso] (Egypt's for null / unknown).
EmergencyNumbers emergencyNumbersOf(String? iso) => emergencyByCountry[iso?.toUpperCase()] ?? emergencyByCountry['EG']!;

/// The (label, number) lines to show, most urgent first.
List<(String, String)> emergencyLines(String? iso) {
  final e = emergencyNumbersOf(iso);
  return [
    if (e.unified != null) ('الطوارئ الموحّد', e.unified!),
    if (e.ambulance != null) ('الإسعاف', e.ambulance!),
    if (e.police != null) ('الشرطة', e.police!),
    if (e.fire != null) ('المطافئ والدفاع المدني', e.fire!),
    ...e.extras,
  ];
}

/// «الإسعاف 123، النجدة 122، المطافئ 180، طوارئ الغاز 129» for Egypt (the
/// old wording, kept), the same idea for the others.
String emergencySentence(String? iso) {
  final c = iso?.toUpperCase() ?? 'EG';
  if (c == 'EG' || !emergencyByCountry.containsKey(c)) return 'الإسعاف 123، النجدة 122، المطافئ 180، طوارئ الغاز 129';
  final lines = emergencyLines(c).map((l) => '${l.$1} ${l.$2}').join('، ');
  return emergencyNumbersOf(c).uncertain ? '$lines (واتأكد من الأرقام المحلية؛ من الموبايل جرّب 112)' : lines;
}
