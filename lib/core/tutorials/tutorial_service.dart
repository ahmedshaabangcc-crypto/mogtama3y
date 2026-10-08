import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_flavor.dart';
import '../demo/demo_mode.dart';

/// فيديوهات الشرح — YouTube Shorts per app (backend/migrations/0079).
/// Everyone reads the active rows; only the platform admin writes.

/// The `app` value of the running flavor.
const String currentTutorialApp = isUnionApp ? 'ittihad' : (isTajerApp ? 'tajer' : 'mogtama3y');

const tutorialApps = {'ittihad': 'اتحاد الملاك', 'mogtama3y': 'مُجتمعي', 'tajer': 'متجري'};

/// Screens that already carry a «شوف الشرح» button (ittihad). Any other
/// lowercase key works too — the column is free text.
const tutorialScreenKeys = {
  'found': 'تأسيس عمارة',
  'join': 'الانضمام بكود',
  'tenants': 'حسابات المستأجرين',
  'elections': 'انتخابات الرئاسة',
  'visitor_pass': 'تصريح زائر',
  'sos': 'الطوارئ SOS',
};

final _rawId = RegExp(r'^[A-Za-z0-9_-]{11}$');
final _screenKey = RegExp(r'^[a-z][a-z0-9_]{0,39}$');

bool isValidScreenKey(String key) => _screenKey.hasMatch(key);

/// The 11-char YouTube video ID from a raw ID or any common URL shape
/// (`youtube.com/shorts/ID`, `youtu.be/ID`, `watch?v=ID`, `embed/ID`,
/// `live/ID`, m./music./www., youtube-nocookie.com). Null when none.
String? extractYoutubeId(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  if (_rawId.hasMatch(s)) return s;
  var uri = Uri.tryParse(s);
  if (uri == null) return null;
  if (!uri.hasScheme) uri = Uri.tryParse('https://$s');
  if (uri == null) return null;
  final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^(www|m|music)\.'), '');
  String? candidate;
  if (host == 'youtu.be') {
    candidate = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  } else if (host == 'youtube.com' || host == 'youtube-nocookie.com') {
    final segs = uri.pathSegments;
    if (segs.isNotEmpty && segs.first == 'watch') {
      candidate = uri.queryParameters['v'];
    } else if (segs.length >= 2 && const {'shorts', 'embed', 'live', 'v'}.contains(segs.first)) {
      candidate = segs[1];
    }
  }
  return candidate != null && _rawId.hasMatch(candidate) ? candidate : null;
}

String youtubeThumbnail(String id) => 'https://i.ytimg.com/vi/$id/hqdefault.jpg';

String youtubeEmbedUrl(String id) => 'https://www.youtube-nocookie.com/embed/$id?rel=0&playsinline=1&modestbranding=1';

String youtubeWatchUrl(String id) => 'https://www.youtube.com/shorts/$id';

class TutorialVideo {
  const TutorialVideo({
    required this.id,
    required this.app,
    required this.youtubeId,
    required this.title,
    required this.sort,
    required this.screenKey,
    required this.isActive,
  });

  final String id;
  final String app;
  final String youtubeId;
  final String title;
  final int sort;
  final String? screenKey;
  final bool isActive;

  factory TutorialVideo.fromRow(Map<String, dynamic> r) => TutorialVideo(
        id: r['id'] as String,
        app: r['app'] as String? ?? 'mogtama3y',
        youtubeId: r['youtube_id'] as String? ?? '',
        title: r['title'] as String? ?? '',
        sort: (r['sort'] as num?)?.toInt() ?? 0,
        screenKey: r['screen_key'] as String?,
        isActive: r['is_active'] as bool? ?? true,
      );
}

class TutorialService {
  TutorialService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<TutorialVideo>>? _active;

  /// This app's active videos, ordered by sort — fetched once per
  /// session (a failed fetch is retried next time).
  static Future<List<TutorialVideo>> activeForApp() {
    // The local demo build has no backend: it shows the published union
    // tutorials from this fixed list (YouTube loads only when one is played).
    if (kDemo) return Future.value(_loaded = currentTutorialApp == 'ittihad' ? _demoUnionVideos : const <TutorialVideo>[]);
    return _active ??= _fetchActive().catchError((Object e) {
      _active = null;
      return <TutorialVideo>[];
    });
  }

  /// The session list once it has arrived (null before / in the demo).
  static List<TutorialVideo>? get loaded => _loaded;
  static List<TutorialVideo>? _loaded;

  static Future<List<TutorialVideo>> _fetchActive() async {
    final rows = await _client
        .from('tutorial_videos')
        .select('id, app, youtube_id, title, sort, screen_key, is_active')
        .eq('app', currentTutorialApp)
        .eq('is_active', true)
        .order('sort')
        .order('created_at');
    return _loaded = [for (final r in rows as List) TutorialVideo.fromRow(Map<String, dynamic>.from(r as Map))];
  }

  /// The first active video for a screen of this app, if any.
  static Future<TutorialVideo?> forScreen(String screenKey) async {
    for (final v in await activeForApp()) {
      if (v.screenKey == screenKey) return v;
    }
    return null;
  }

  /// Drop the session cache (after the admin edits).
  static void invalidate() {
    _active = null;
    _loaded = null;
  }

  // ---- admin (RLS: is_super_admin) ----

  static Future<List<TutorialVideo>> adminList(String app) async {
    final rows = await _client
        .from('tutorial_videos')
        .select('id, app, youtube_id, title, sort, screen_key, is_active')
        .eq('app', app)
        .order('sort')
        .order('created_at');
    return [for (final r in rows as List) TutorialVideo.fromRow(Map<String, dynamic>.from(r as Map))];
  }

  static Future<void> save({
    String? id,
    required String app,
    required String youtubeId,
    required String title,
    required int sort,
    String? screenKey,
    required bool isActive,
  }) async {
    final values = {
      'app': app,
      'youtube_id': youtubeId,
      'title': title.trim(),
      'sort': sort,
      'screen_key': (screenKey == null || screenKey.trim().isEmpty) ? null : screenKey.trim(),
      'is_active': isActive,
    };
    if (id == null) {
      await _client.from('tutorial_videos').insert(values);
    } else {
      await _client.from('tutorial_videos').update(values).eq('id', id);
    }
    invalidate();
  }

  static Future<void> setActive(String id, bool active) async {
    await _client.from('tutorial_videos').update({'is_active': active}).eq('id', id);
    invalidate();
  }

  static Future<void> setSort(String id, int sort) async {
    await _client.from('tutorial_videos').update({'sort': sort}).eq('id', id);
    invalidate();
  }

  static Future<void> delete(String id) async {
    await _client.from('tutorial_videos').delete().eq('id', id);
    invalidate();
  }
}

/// The six published union tutorials (YouTube Shorts on the مُجتمعي
/// channel), used only by the local demo build.
const _demoUnionVideos = <TutorialVideo>[
  TutorialVideo(id: 'demo-0', app: 'ittihad', youtubeId: 'TGZwLWd4bOQ', title: 'أسّس اتحاد عمارتك', sort: 0, screenKey: 'found', isActive: true),
  TutorialVideo(id: 'demo-1', app: 'ittihad', youtubeId: 'mo00sgy4QhQ', title: 'انضم لعمارتك بكود الدعوة', sort: 1, screenKey: 'join', isActive: true),
  TutorialVideo(id: 'demo-2', app: 'ittihad', youtubeId: 'Xr52M5jteLo', title: 'ضيف المستأجر بتاعك', sort: 2, screenKey: 'tenants', isActive: true),
  TutorialVideo(id: 'demo-3', app: 'ittihad', youtubeId: '6u4XvP3PVnc', title: 'انتخبوا رئيس الاتحاد', sort: 3, screenKey: 'elections', isActive: true),
  TutorialVideo(id: 'demo-4', app: 'ittihad', youtubeId: 'X4dmxRNUb2M', title: 'تصريح دخول للزائر', sort: 4, screenKey: 'visitor_pass', isActive: true),
  TutorialVideo(id: 'demo-5', app: 'ittihad', youtubeId: '-SAabWeeJuo', title: 'زرار الطوارئ SOS', sort: 5, screenKey: 'sos', isActive: true),
];
