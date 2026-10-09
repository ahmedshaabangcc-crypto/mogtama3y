/// Pure helpers for «مسجدي» members, the mosque chat and invitations
/// (migration 0081). No Flutter / Supabase imports, so they're unit-tested.
library;

/// Max length of one mosque-chat message (the server enforces the same).
const mosqueChatMaxLength = 1000;

/// The «انضم لمسجدك» radius.
const joinRadiusMeters = 500;

/// «120 متر» / «1.4 كم».
String formatMeters(num? meters) {
  if (meters == null) return '';
  final m = meters.round();
  if (m < 1000) return '$m متر';
  final km = m / 1000;
  return '${km.toStringAsFixed(km < 10 ? 1 : 0)} كم';
}

/// Why [text] can't be sent (null when it's fine). Mirrors the server's
/// length rule so the user gets the message before the round trip.
String? mosqueChatBodyError(String text) {
  final t = text.trim();
  if (t.isEmpty) return 'اكتب رسالة الأول';
  if (t.length > mosqueChatMaxLength) return 'الرسالة طويلة، الحد $mosqueChatMaxLength حرف';
  return null;
}

/// The unread badge: '' (none), '1'…'99', '99+'.
String unreadBadge(num? n) {
  final v = (n ?? 0).toInt();
  if (v <= 0) return '';
  return v >= 99 ? '99+' : '$v';
}

/// «عضو واحد» / «عضوين» / «5 أعضاء» / «12 عضو».
String membersLabel(num? n) {
  final v = (n ?? 0).toInt();
  if (v <= 0) return 'لسه مفيش أعضاء';
  if (v == 1) return 'عضو واحد';
  if (v == 2) return 'عضوين';
  if (v <= 10) return '$v أعضاء';
  return '$v عضو';
}

/// Join candidates as returned by masjid_join_candidates: the ones within
/// the radius (nearest first) and, when there are none, the nearest beyond.
({List<Map<String, dynamic>> within, List<Map<String, dynamic>> beyond}) splitJoinCandidates(List<Map<String, dynamic>> rows) {
  final within = <Map<String, dynamic>>[];
  final beyond = <Map<String, dynamic>>[];
  for (final r in rows) {
    final isWithin = r['within'] == true || ((r['distance_m'] as num?) ?? double.infinity) <= joinRadiusMeters;
    (isWithin ? within : beyond).add(r);
  }
  int byDistance(Map<String, dynamic> a, Map<String, dynamic> b) =>
      ((a['distance_m'] as num?) ?? 1e9).compareTo((b['distance_m'] as num?) ?? 1e9);
  within.sort(byDistance);
  beyond.sort(byDistance);
  return (within: within, beyond: beyond);
}

/// WhatsApp text inviting the mosque's imam to claim its page.
String imamInviteText(String mosqueName, String url) => 'السلام عليكم يا شيخنا 🌙\n'
    'مسجد «$mosqueName» بقى له صفحة على تطبيق «مسجدي» وأهل الحي بدأوا ينضموا ويتكلموا في شات المسجد.\n'
    'لو حضرتك إمام المسجد أو خطيبه أو أمينه، افتح اللينك واضغط «أنا مسؤول عن المسجد ده» — بعد التوثيق تقدر تنشر مواعيد الإقامة والدروس والإعلانات والاحتياجات وتدير الشات.\n'
    '$url';

/// WhatsApp text inviting neighbours to join the mosque.
String neighboursInviteText(String mosqueName, String url) => 'السلام عليكم يا جيران 👋\n'
    'انضموا لمسجد «$mosqueName» على تطبيق «مسجدي»: مواقيت الصلاة والإقامة، الدروس وحلقات القرآن، صلاة الجنازة، احتياجات المسجد، وشات لأهل المسجد.\n'
    '$url';

/// «wa.me» share link for [text].
Uri whatsappShareUri(String text) => Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
