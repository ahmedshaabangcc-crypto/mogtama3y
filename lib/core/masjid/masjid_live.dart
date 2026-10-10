/// Pure helpers for «دروس أونلاين» (migration 0085: live audio / video
/// lessons on LiveKit). No Flutter / Supabase imports, so they're
/// unit-tested. The room itself is the standalone page `web/live/`.
library;

/// Shown wherever a live lesson is offered.
const liveNotRecordedNote = 'الدرس مباشر ومش بيتسجّل';

const liveModeLabels = {'audio': 'صوت بس', 'video': 'صوت وصورة'};

const liveVisibilityLabels = {'members': 'لأعضاء المسجد', 'public': 'لأي حد مسجّل'};

/// Durations offered when scheduling (minutes).
const liveDurations = [30, 45, 60, 90, 120, 180];

/// The live page for lesson [id], resolved against the app's own origin
/// ([base], e.g. `Uri.base` on the web) so the session in localStorage is
/// shared with it.
Uri liveLessonUri(String id, Uri base) => base.resolve('/live/?s=${Uri.encodeQueryComponent(id)}');

DateTime? _date(Object? v) => v is DateTime ? v : DateTime.tryParse('${v ?? ''}');

/// Live now (and not forgotten for hours, like the server's stale rule).
bool liveIsLive(Map<String, dynamic> s, DateTime now) {
  if (s['status'] != 'live') return false;
  final from = _date(s['started_at']) ?? _date(s['scheduled_at']);
  if (from == null) return true;
  final minutes = (s['duration_minutes'] as num?)?.toInt() ?? 60;
  return now.isBefore(from.add(Duration(minutes: minutes, hours: 3)));
}

/// The lesson can be entered from the app now: live and joinable.
bool liveCanEnter(Map<String, dynamic> s, DateTime now) => liveIsLive(s, now) && s['can_join'] == true;

/// «مباشر دلوقتي» / «كمان 20 دقيقة» / «النهارده 8:30 م» / «بكرة 7:00 ص» /
/// «السبت 12/10 — 9:15 م» / «خلص» / «اتلغى».
String liveWhenLabel(Map<String, dynamic> s, DateTime now) {
  switch (s['status']) {
    case 'ended':
      return 'خلص';
    case 'cancelled':
      return 'اتلغى';
    case 'live':
      return liveIsLive(s, now) ? 'مباشر دلوقتي' : 'خلص';
  }
  final at = _date(s['scheduled_at'])?.toLocal();
  if (at == null) return '';
  final local = now.toLocal();
  final diff = at.difference(local);
  if (diff.inMinutes <= 0) return 'هيبدأ دلوقتي';
  if (diff.inMinutes < 60) return 'كمان ${diff.inMinutes} دقيقة';
  final day = DateTime(at.year, at.month, at.day);
  final today = DateTime(local.year, local.month, local.day);
  final days = day.difference(today).inDays;
  final time = clock12(at);
  if (days == 0) return 'النهارده $time';
  if (days == 1) return 'بكرة $time';
  return '${_weekdays[at.weekday]} ${at.day}/${at.month} — $time';
}

/// «النهارده» / «بكرة» / «الخميس 15/10» for the schedule form's day list.
String liveDayLabel(DateTime day, DateTime today) {
  final d = DateTime(day.year, day.month, day.day).difference(DateTime(today.year, today.month, today.day)).inDays;
  if (d == 0) return 'النهارده';
  if (d == 1) return 'بكرة';
  return '${_weekdays[day.weekday]} ${day.day}/${day.month}';
}

const _weekdays = {1: 'الاتنين', 2: 'التلات', 3: 'الأربع', 4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الحد'};

/// «8:30 م» / «7:05 ص».
String clock12(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  return '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'ص' : 'م'}';
}

/// Live first, then the soonest.
int compareLive(Map<String, dynamic> a, Map<String, dynamic> b) {
  final now = DateTime.now();
  final la = liveIsLive(a, now) ? 0 : 1;
  final lb = liveIsLive(b, now) ? 0 : 1;
  if (la != lb) return la - lb;
  final ta = _date(a['scheduled_at']) ?? DateTime(9999);
  final tb = _date(b['scheduled_at']) ?? DateTime(9999);
  return ta.compareTo(tb);
}

/// Why the schedule form can't be sent (null when fine). The server checks
/// the same.
String? liveFormError({required String title, required DateTime? at, required DateTime now}) {
  if (title.trim().length < 2) return 'اكتب عنوان الدرس';
  if (title.trim().length > 120) return 'العنوان طويل';
  if (at == null) return 'اختار الميعاد';
  if (at.isBefore(now.subtract(const Duration(minutes: 10)))) return 'الميعاد فات — اختار ميعاد جاي';
  if (at.isAfter(now.add(const Duration(days: 60)))) return 'تقدر تحدد ميعاد لحد شهرين قدام بس';
  return null;
}
