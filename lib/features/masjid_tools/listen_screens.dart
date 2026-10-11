import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/masjid_tools/hijri.dart' show toArabicDigits;
import '../../core/masjid_tools/listen_queue.dart';
import '../../core/masjid_tools/platform/audio_player.dart';
import '../../core/masjid_tools/platform/gunzip.dart';
import '../../core/masjid_tools/platform/kv_store.dart';
import '../../core/masjid_tools/quran_meta.dart';
import '../../core/masjid_tools/recitations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'tools_ui.dart';

// «استماع القرآن»: the whole Quran by 240+ reciters in many riwayat, from
// mp3quran.net. Deferred library — loaded on first open.

String _surahName(int s) => 'سورة ${surahData[s - 1].$1}';
String _ar(Object v) => toArabicDigits(v);
String _clock(double s) => _ar(formatClock(s));

final _chipColor = WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected) ? AppColors.gold : const Color(0xFF22325A));

// ------------------------------------------------------------------ storage
/// Reciters list (API, cached on the device), favourites, resume positions,
/// «آخر استماع» and player prefs — all local.
class ListenStore {
  static const _cacheKey = 'listen.cache.v1';
  static const _favKey = 'listen.favs';
  static const _posKey = 'listen.pos';
  static const _lastKey = 'listen.last';
  static const _prefsKey = 'listen.prefs';
  static const _maxPositions = 150;
  static const _fresh = Duration(days: 2);

  static List<Reciter>? reciters;
  static DateTime? fetchedAt;

  /// The list shown is a saved copy (the API couldn't be reached).
  static bool stale = false;

  static final favorites = <int>{};
  static final _positions = <String, double>{};
  static Map<String, dynamic>? last;
  static double speed = 1;
  static PlayMode mode = PlayMode.continuous;

  static Future<void>? _init;

  /// Loads the small local state (favourites, positions, last, prefs).
  static Future<void> init() => _init ??= () async {
        try {
          final f = await kvGet(_favKey);
          if (f != null) favorites.addAll((jsonDecode(f) as List).map((e) => (e as num).toInt()));
        } catch (_) {}
        try {
          final p = await kvGet(_posKey);
          if (p != null) {
            (jsonDecode(p) as Map).forEach((k, v) => _positions['$k'] = (v as num).toDouble());
          }
        } catch (_) {}
        try {
          final l = await kvGet(_lastKey);
          if (l != null) last = Map<String, dynamic>.from(jsonDecode(l) as Map);
        } catch (_) {}
        try {
          final p = await kvGet(_prefsKey);
          if (p != null) {
            final m = jsonDecode(p) as Map;
            final s = (m['speed'] as num?)?.toDouble();
            if (s != null && playbackSpeeds.contains(s)) speed = s;
            mode = PlayMode.values.firstWhere((e) => e.name == m['mode'], orElse: () => PlayMode.continuous);
          }
        } catch (_) {}
      }();

  static Future<List<Reciter>>? _loading;

  /// The list shown is the snapshot bundled with the app (no cache, API
  /// unreachable) — a background refresh keeps trying.
  static bool fromSnapshot = false;

  /// What went wrong reaching the API (for the «تفاصيل» support line).
  static String? lastError;

  /// Bumped when a background refresh replaces the list.
  static final changes = ValueNotifier<int>(0);

  /// Test hook: replaces the network fetch.
  @visibleForTesting
  static Future<http.Response> Function(Uri url, Duration timeout)? httpGetOverride;

  /// Fetches the API (www host, then the bare host once); throws with both
  /// errors when neither answers.
  static Future<List<Reciter>> _fetch() async {
    final errors = <String>[];
    for (final (url, timeout) in [(recitationsApi, const Duration(seconds: 20)), (recitationsApiAlt, const Duration(seconds: 15))]) {
      try {
        final uri = Uri.parse(url);
        final get = httpGetOverride;
        final res = await (get != null ? get(uri, timeout) : http.get(uri).timeout(timeout));
        if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
        final list = parseReciters(jsonDecode(utf8.decode(res.bodyBytes)));
        if (list.isEmpty) throw Exception('empty list');
        lastError = null;
        return list;
      } catch (e) {
        errors.add('${Uri.parse(url).host}: ${_short(e)}');
      }
    }
    lastError = errors.join(' • ');
    throw Exception(lastError);
  }

  static String _short(Object e) {
    final s = '$e'.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s.length > 140 ? '${s.substring(0, 140)}…' : s;
  }

  static Future<void> _save(List<Reciter> list, DateTime at) =>
      kvSet(_cacheKey, jsonEncode({'t': at.toIso8601String(), 'reciters': [for (final r in list) r.toJson()]}));

  /// The snapshot bundled with the app — fetched only when needed.
  static Future<List<Reciter>> loadSnapshot() async {
    final data = await rootBundle.load(recitationsSnapshotAsset);
    final text = await gunzipUtf8(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return parseReciters(jsonDecode(text));
  }

  static bool _refreshing = false;

  /// After falling back to a saved/bundled list: keep trying the API quietly.
  static Future<void> _refreshInBackground() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      for (final wait in const [Duration(seconds: 5), Duration(seconds: 30), Duration(minutes: 2)]) {
        await Future<void>.delayed(wait);
        if (!stale) return;
        try {
          final list = await _fetch();
          final now = DateTime.now();
          unawaited(_save(list, now));
          fromSnapshot = false;
          _set(list, now, false);
          changes.value++;
          return;
        } catch (_) {}
      }
    } finally {
      _refreshing = false;
    }
  }

  /// The reciters: a fresh device copy, else the API (then saved), else an
  /// old copy, else the snapshot bundled with the app (then a background
  /// refresh). Throws only when even the snapshot can't be read.
  static Future<List<Reciter>> load({bool force = false}) {
    if (!force && reciters != null && !stale) return Future.value(reciters);
    return _loading ??= () async {
      try {
        List<Reciter>? cached;
        DateTime? cachedAt;
        try {
          final raw = await kvGet(_cacheKey);
          if (raw != null) {
            final m = jsonDecode(raw) as Map;
            cachedAt = DateTime.tryParse('${m['t']}');
            cached = parseReciters(m);
          }
        } catch (_) {}
        if (!force && cached != null && cached.isNotEmpty && cachedAt != null && DateTime.now().difference(cachedAt) < _fresh) {
          return _set(cached, cachedAt, false);
        }
        try {
          final list = await _fetch();
          final now = DateTime.now();
          unawaited(_save(list, now));
          fromSnapshot = false;
          return _set(list, now, false);
        } catch (e) {
          if (cached != null && cached.isNotEmpty) {
            fromSnapshot = false;
            final r = _set(cached, cachedAt, true);
            unawaited(_refreshInBackground());
            return r;
          }
          try {
            final snap = await loadSnapshot();
            if (snap.isEmpty) throw Exception('empty snapshot');
            fromSnapshot = true;
            final r = _set(snap, null, true);
            unawaited(_refreshInBackground());
            return r;
          } catch (s) {
            lastError = '${lastError ?? _short(e)} • snapshot: ${_short(s)}';
            rethrow;
          }
        }
      } finally {
        _loading = null;
      }
    }();
  }

  static List<Reciter> _set(List<Reciter> list, DateTime? at, bool isStale) {
    reciters = sortReciters(list);
    fetchedAt = at;
    stale = isStale;
    return reciters!;
  }

  static Reciter? reciter(int id) {
    for (final r in reciters ?? const <Reciter>[]) {
      if (r.id == id) return r;
    }
    return null;
  }

  static Future<void> toggleFavorite(int id) async {
    if (!favorites.remove(id)) favorites.add(id);
    await kvSet(_favKey, jsonEncode(favorites.toList()));
  }

  static String _pk(int r, int m, int s) => '$r/$m/$s';

  /// Saved position (seconds) for this reciter/mushaf/surah, if any.
  static double? resumeFor(int r, int m, int s) => _positions[_pk(r, m, s)];

  static void savePosition(int r, int m, int s, double? seconds) {
    final k = _pk(r, m, s);
    _positions.remove(k);
    if (seconds != null) _positions[k] = (seconds * 10).roundToDouble() / 10;
    while (_positions.length > _maxPositions) {
      _positions.remove(_positions.keys.first);
    }
    unawaited(kvSet(_posKey, jsonEncode(_positions)));
  }

  static void saveLast(Reciter r, Moshaf m, int s, double position) {
    last = {
      'r': r.id,
      'rn': r.name,
      'm': m.id,
      'mn': m.name,
      'sv': m.server,
      'sl': compactSurahList(m.surahs),
      's': s,
      'p': (position * 10).roundToDouble() / 10,
      't': DateTime.now().toIso8601String(),
    };
    unawaited(kvSet(_lastKey, jsonEncode(last)));
  }

  /// «آخر استماع» rebuilt from the device copy (works even if the API is down).
  static (Reciter, Moshaf, int, double)? lastListen() {
    final l = last;
    if (l == null) return null;
    try {
      final rid = (l['r'] as num).toInt(), mid = (l['m'] as num).toInt();
      final known = reciter(rid);
      final m = known?.moshaf(mid) ??
          Moshaf.fromJson({'id': mid, 'name': l['mn'], 'server': l['sv'], 'surah_list': l['sl']});
      final r = known ?? Reciter(id: rid, name: '${l['rn']}', moshafs: [m]);
      final s = (l['s'] as num).toInt();
      if (!m.has(s) || m.server.isEmpty) return null;
      return (r, m, s, (l['p'] as num?)?.toDouble() ?? 0);
    } catch (_) {
      return null;
    }
  }

  static void savePrefs() => unawaited(kvSet(_prefsKey, jsonEncode({'speed': speed, 'mode': mode.name})));
}

// ------------------------------------------------------------------ player
/// The one player for all the listening screens (keeps playing while the
/// user moves around the app).
class ListenPlayer extends ChangeNotifier {
  ListenPlayer._() {
    _audio = WebAudio(_onEvent);
  }

  static final instance = ListenPlayer._();

  late final WebAudio _audio;

  Reciter? reciter;
  Moshaf? moshaf;
  ListenQueue? queue;
  int? get surah => queue?.current;
  bool get active => reciter != null && queue != null;

  bool playing = false;
  bool loading = false;
  String? error;
  double position = 0;
  double duration = 0;
  double buffered = 0;

  /// Where a remembered position was resumed from (shown with «ابدأ من الأول»).
  double? resumedFrom;
  double? _pendingSeek;

  /// Size of the current surah's file (from a HEAD request), when known.
  int? fileBytes;

  SleepTimer sleep = SleepTimer.off;
  DateTime? sleepAt;
  Timer? _sleepTimer;

  DateTime _lastSave = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastPositionState = DateTime.fromMillisecondsSinceEpoch(0);

  double get speed => ListenStore.speed;
  PlayMode get mode => ListenStore.mode;
  bool get supported => _audio.supported;

  /// Plays [s] of [m] by [r] — call straight from a tap (iOS needs the
  /// gesture). [resume] picks up a remembered position.
  Future<void> start(Reciter r, Moshaf m, int s, {bool resume = true}) {
    _saveNow();
    reciter = r;
    moshaf = m;
    queue = ListenQueue(m.surahs, s);
    _registerSession();
    return _load(s, resume: resume);
  }

  Future<void> _load(int s, {required bool resume}) async {
    final r = reciter!, m = moshaf!;
    queue!.current = s;
    error = null;
    position = 0;
    duration = 0;
    buffered = 0;
    fileBytes = null;
    final saved = resume ? ListenStore.resumeFor(r.id, m.id, s) : null;
    _pendingSeek = saved;
    resumedFrom = saved;
    loading = true;
    final url = m.url(s);
    _audio.setSource(url);
    _audio.setRate(speed);
    // play() before any await: keeps the user-gesture (iOS / autoplay rules).
    final playing = _audio.play();
    _updateMetadata();
    ListenStore.saveLast(r, m, s, saved ?? 0);
    notifyListeners();
    unawaited(_fetchSize(url, s));
    _handlePlayResult(await playing);
  }

  void _handlePlayResult(String? err) {
    if (err == null || err == 'AbortError') return;
    loading = false;
    playing = false;
    error = switch (err) {
      'NotAllowedError' => 'دوس ▶ عشان يبدأ التشغيل',
      'NotSupportedError' => 'معرفناش نشغّل الملف ده — جرّب تاني أو قارئ تاني',
      'unsupported' => 'المتصفح ده مش بيشغّل الصوت',
      _ => 'حصلت مشكلة في التشغيل — جرّب تاني',
    };
    notifyListeners();
  }

  Future<void> _fetchSize(String url, int s) async {
    try {
      final res = await http.head(Uri.parse(url)).timeout(const Duration(seconds: 15));
      final n = int.tryParse(res.headers['content-length'] ?? '');
      if (n != null && n > 0 && surah == s && moshaf?.url(s) == url) {
        fileBytes = n;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> toggle() async {
    if (!active) return;
    if (playing) {
      _audio.pause();
      return;
    }
    if (error != null) return retry();
    error = null;
    loading = true;
    notifyListeners();
    _handlePlayResult(await _audio.play());
  }

  Future<void> retry() => active ? _load(surah!, resume: true) : Future.value();

  void pause() => _audio.pause();

  void seekTo(double seconds) {
    if (!active) return;
    final d = duration;
    final v = seconds.clamp(0, d > 0 ? d : seconds.abs()).toDouble();
    _audio.seek(v);
    position = v;
    _positionState(force: true);
    notifyListeners();
  }

  void seekBy(double delta) => seekTo(_audio.position + delta);

  void restartSurah() {
    resumedFrom = null;
    seekTo(0);
  }

  Future<void> next() async {
    final n = queue?.next();
    if (n != null) await _load(n, resume: false);
  }

  Future<void> previous() async {
    final q = queue;
    if (q == null) return;
    final p = q.previousOrRestart(_audio.position);
    if (p == null) return;
    if (p == q.current) {
      restartSurah();
    } else {
      await _load(p, resume: false);
    }
  }

  void setSpeed(double s) {
    ListenStore.speed = s;
    ListenStore.savePrefs();
    _audio.setRate(s);
    _positionState(force: true);
    notifyListeners();
  }

  void setMode(PlayMode m) {
    ListenStore.mode = m;
    ListenStore.savePrefs();
    notifyListeners();
  }

  void setSleep(SleepTimer t) {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    sleep = t;
    sleepAt = null;
    final min = t.minutes;
    if (min != null) {
      sleepAt = DateTime.now().add(Duration(minutes: min));
      _sleepTimer = Timer(Duration(minutes: min), () {
        _audio.pause();
        sleep = SleepTimer.off;
        sleepAt = null;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  /// Stops and hides the mini player.
  void stop() {
    _saveNow();
    _audio.stop();
    setSleep(SleepTimer.off);
    reciter = null;
    moshaf = null;
    queue = null;
    playing = false;
    loading = false;
    error = null;
    setMediaPlaybackState(false);
    notifyListeners();
  }

  void _saveNow() {
    final r = reciter, m = moshaf, s = surah;
    if (r == null || m == null || s == null) return;
    final pos = _audio.position, d = _audio.duration;
    if (pos <= 0) return;
    ListenStore.savePosition(r.id, m.id, s, resumePoint(pos, d));
    ListenStore.saveLast(r, m, s, pos);
    _lastSave = DateTime.now();
  }

  void _positionState({bool force = false}) {
    final now = DateTime.now();
    if (!force && now.difference(_lastPositionState).inSeconds < 5) return;
    _lastPositionState = now;
    setMediaPositionState(_audio.duration, _audio.position, speed);
  }

  void _onEvent(String type) {
    if (!active) return;
    switch (type) {
      case 'timeupdate':
        position = _audio.position;
        duration = _audio.duration;
        buffered = _audio.buffered;
        if (playing && DateTime.now().difference(_lastSave).inSeconds >= 5) _saveNow();
        _positionState();
      case 'loadedmetadata' || 'durationchange':
        duration = _audio.duration;
        final seek = _pendingSeek;
        if (seek != null && type == 'loadedmetadata') {
          _pendingSeek = null;
          if (duration <= 0 || seek < duration - 5) {
            _audio.seek(seek);
            position = seek;
          }
        }
        _positionState(force: true);
      case 'playing':
        playing = true;
        loading = false;
        error = null;
        setMediaPlaybackState(true);
        _positionState(force: true);
      case 'pause':
        playing = false;
        setMediaPlaybackState(false);
        _saveNow();
      case 'waiting' || 'stalled':
        if (!_audio.paused) loading = true;
      case 'canplay':
        loading = false;
      case 'error':
        loading = false;
        playing = false;
        error = 'معرفناش نحمّل السورة — اتأكد من النت وجرّب تاني';
      case 'ended':
        _onEnded();
        return;
    }
    notifyListeners();
  }

  void _onEnded() {
    final r = reciter!, m = moshaf!, s = surah!;
    ListenStore.savePosition(r.id, m.id, s, null); // finished: start over next time
    playing = false;
    if (sleep == SleepTimer.endOfSurah) {
      setSleep(SleepTimer.off);
      notifyListeners();
      return;
    }
    final n = queue!.afterEnd(mode);
    if (n == null) {
      setMediaPlaybackState(false);
      notifyListeners();
      return;
    }
    if (n == s) {
      position = 0;
      _audio.seek(0);
      unawaited(_audio.play().then(_handlePlayResult));
      notifyListeners();
      return;
    }
    unawaited(_load(n, resume: false));
  }

  void _registerSession() {
    setMediaSession(
      title: '',
      artist: '',
      album: '',
      artwork: _artwork,
      handlers: {
        'play': (_) => toggle(),
        'pause': (_) => pause(),
        'previoustrack': (_) => previous(),
        'nexttrack': (_) => next(),
        'seekbackward': (_) => seekBy(-10),
        'seekforward': (_) => seekBy(10),
        'seekto': (t) {
          if (t != null) seekTo(t);
        },
        'stop': (_) => stop(),
      },
    );
  }

  static String get _artwork => absoluteUrl(isMasjidApp ? 'masjid_icons/Icon-512.png' : 'icons/Icon-512.png');

  void _updateMetadata() {
    final r = reciter, m = moshaf, s = surah;
    if (r == null || m == null || s == null) return;
    setMediaSession(
      title: '${_surahName(s)} — ${r.name}',
      artist: m.title,
      album: isMasjidApp ? 'مسجدي — استماع القرآن' : 'مُجتمعي — استماع القرآن',
      artwork: _artwork,
      handlers: const {},
    );
  }
}

// ------------------------------------------------------------------ home
/// «استماع القرآن»: reciters with search and riwayah / style filters.
/// [surah] (from the Quran reader) highlights that surah down the flow.
class ListenHomeScreen extends StatefulWidget {
  const ListenHomeScreen({super.key, this.surah});
  final int? surah;

  @override
  State<ListenHomeScreen> createState() => _ListenHomeScreenState();
}

class _ListenHomeScreenState extends State<ListenHomeScreen> {
  final _search = TextEditingController();
  List<Reciter>? _all;
  Object? _error;
  bool _loading = true;
  String? _riwayah;
  RecitationKind? _kind;
  bool _favOnly = false;

  int? get _focus => (widget.surah != null && widget.surah! >= 1 && widget.surah! <= 114) ? widget.surah : null;

  @override
  void initState() {
    super.initState();
    ListenStore.changes.addListener(_onRefreshed);
    _load();
  }

  @override
  void dispose() {
    ListenStore.changes.removeListener(_onRefreshed);
    _search.dispose();
    super.dispose();
  }

  /// A background refresh brought the live list.
  void _onRefreshed() {
    if (mounted) setState(() => _all = ListenStore.reciters);
  }

  Future<void> _load({bool force = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await ListenStore.init();
    try {
      final list = await ListenStore.load(force: force);
      if (mounted) setState(() => _all = list);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
    if (mounted) setState(() => _loading = false);
  }

  void _openReciter(Reciter r) {
    final matching = matchingMoshafs(r, riwayah: _riwayah, kind: _kind);
    final withFocus = _focus == null ? matching : matching.where((m) => m.has(_focus!)).toList();
    final Widget page = r.moshafs.length == 1
        ? MoshafScreen(reciter: r, moshaf: r.moshafs.first, focusSurah: _focus)
        : (withFocus.length == 1 && (_riwayah != null || _kind != null))
            ? MoshafScreen(reciter: r, moshaf: withFocus.first, focusSurah: _focus)
            : ReciterScreen(reciter: r, focusSurah: _focus, preferRiwayah: _riwayah, preferKind: _kind);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      if (mounted) setState(() {});
    });
  }

  Widget _chip(String label, bool selected, VoidCallback onTap, {IconData? icon}) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 6),
        child: FilterChip(
          label: Text(label),
          avatar: icon == null ? null : Icon(icon, size: 16, color: selected ? AppColors.night : AppColors.gold),
          selected: selected,
          showCheckmark: false,
          onSelected: (_) => onTap(),
          labelStyle: TextStyle(color: selected ? AppColors.night : Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
          color: _chipColor,
          side: BorderSide(color: selected ? AppColors.gold : AppColors.glassBorder),
          visualDensity: VisualDensity.compact,
        ),
      );

  Widget _lastCard() {
    final last = ListenStore.lastListen();
    if (last == null) return const SizedBox.shrink();
    final (r, m, s, p) = last;
    final player = ListenPlayer.instance;
    final current = player.active && player.reciter?.id == r.id && player.moshaf?.id == m.id && player.surah == s;
    if (current) return const SizedBox.shrink(); // the mini player already shows it
    return GlassCard(
      highlight: true,
      onTap: () => player.start(r, m, s),
      child: Row(children: [
        const Icon(Icons.history_rounded, color: AppColors.gold),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('آخر استماع', style: toolMutedStyle),
            Text('${_surahName(s)} — ${r.name}', style: toolTitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(p > 10 ? '${m.title} • وقفت عند ${_clock(p)}' : m.title, style: toolMutedStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
          onPressed: () => player.start(r, m, s),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('كمّل'),
        ),
      ]),
    );
  }

  /// From the reader: one tap to hear the surah by the last reciter used.
  Widget _focusCard() {
    final s = _focus;
    if (s == null) return const SizedBox.shrink();
    final last = ListenStore.lastListen();
    final quick = last != null && last.$2.has(s) ? last : null;
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('هتسمع ${_surahName(s)}', style: toolTitleStyle),
        const SizedBox(height: 4),
        Text(quick == null ? 'اختار القارئ من تحت' : 'بصوت ${quick.$1.name} ولا اختار قارئ تاني من تحت', style: toolMutedStyle),
        if (quick != null) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
            onPressed: () => ListenPlayer.instance.start(quick.$1, quick.$2, s),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text('شغّل ${_surahName(s)} — ${quick.$1.name}', overflow: TextOverflow.ellipsis),
          ),
        ],
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final side = ToolScaffold.side(context);
    final all = _all;
    var list = all == null
        ? const <Reciter>[]
        : filterReciters(all, query: _search.text, riwayah: _riwayah, kind: _kind, onlyIds: _favOnly ? ListenStore.favorites : null);
    final focus = _focus;
    if (focus != null) list = [for (final r in list) if (r.moshafs.any((m) => m.has(focus))) r];
    final counts = <String, int>{
      for (final f in riwayahFilters) f: all == null ? 0 : all.where((r) => r.riwayat.any((w) => riwayahMatches(w, f))).length,
    };
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        iconTheme: AppTheme.nightBarIcons,
        actionsIconTheme: AppTheme.nightBarIcons,
        titleTextStyle: nightTitleStyle(context),
        title: const Text('استماع القرآن'),
        actions: [
          IconButton(tooltip: 'عن التلاوات', icon: const Icon(Icons.info_outline_rounded), onPressed: () => showListenCredits(context)),
        ],
      ),
      bottomNavigationBar: const ListenMiniPlayer(),
      body: AnimatedBuilder(
        animation: ListenPlayer.instance,
        builder: (context, _) => CustomScrollView(slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(side, 8, side, 0),
            sliver: SliverList.list(children: [
              _focusCard(),
              if (focus == null) _lastCard(),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'دوّر على قارئ… (الحصري، المنشاوي، العفاسي)',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70),
                          onPressed: () => setState(_search.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.07),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  _chip('المفضلين', _favOnly, () => setState(() => _favOnly = !_favOnly), icon: Icons.star_rounded),
                  for (final k in RecitationKind.values) _chip(k.label, _kind == k, () => setState(() => _kind = _kind == k ? null : k)),
                ]),
              ),
              SizedBox(
                height: 40,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  _chip('كل الروايات', _riwayah == null, () => setState(() => _riwayah = null)),
                  for (final f in riwayahFilters)
                    if (counts[f]! > 0) _chip('$f (${_ar(counts[f]!)})', _riwayah == f, () => setState(() => _riwayah = _riwayah == f ? null : f)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  const Icon(Icons.wifi_rounded, size: 15, color: Colors.white54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      all == null
                          ? 'الاستماع بيستهلك نت — السورة الطويلة ممكن توصل لعشرات الميجا'
                          : '${_ar(list.length)} قارئ • الاستماع بيستهلك نت، الأحسن على الواي فاي'
                              '${ListenStore.fromSnapshot ? ' • قايمة مخزّنة مع التطبيق (موقع القرّاء مش بيرد دلوقتي)' : ListenStore.stale ? ' • قايمة محفوظة (مش متحدّثة)' : ''}',
                      style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                  ),
                ]),
              ),
              if (all != null && ListenStore.stale && ListenStore.lastError != null) _ErrorDetails(ListenStore.lastError!),
            ]),
          ),
          if (_loading && all == null)
            const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.gold)))
          else if (all == null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 40),
                    const SizedBox(height: 10),
                    const Text('معرفناش نجيب قايمة القرّاء — اتأكد من النت وجرّب تاني', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),
                    if (_error != null) _ErrorDetails(ListenStore.lastError ?? '$_error'),
                    FilledButton(onPressed: () => _load(force: true), child: const Text('جرّب تاني')),
                  ]),
                ),
              ),
            )
          else if (list.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Text(_favOnly && ListenStore.favorites.isEmpty ? 'لسه مفيش مفضلين — دوس ☆ جنب القارئ' : 'مفيش قارئ بالبحث ده',
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(side, 0, side, 24),
              sliver: SliverList.builder(
                itemCount: list.length + 1,
                itemBuilder: (context, i) => i == list.length
                    ? const _CreditLine()
                    : _ReciterTile(
                        reciter: list[i],
                        onTap: () => _openReciter(list[i]),
                        onFavorite: () async {
                          await ListenStore.toggleFavorite(list[i].id);
                          if (mounted) setState(() {});
                        },
                      ),
              ),
            ),
        ]),
      ),
    );
  }
}

/// «تفاصيل: …» — the actual network error, small, selectable and copyable
/// on long-press, for support.
class _ErrorDetails extends StatelessWidget {
  const _ErrorDetails(this.details);
  final String details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: details));
          toolToast(context, 'اتنسخت التفاصيل — ابعتها للدعم');
        },
        child: SelectableText(
          'تفاصيل: $details',
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white38, fontSize: 10.5, height: 1.5),
        ),
      ),
    );
  }
}

class _ReciterTile extends StatelessWidget {
  const _ReciterTile({required this.reciter, required this.onTap, required this.onFavorite});
  final Reciter reciter;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final r = reciter;
    final fav = ListenStore.favorites.contains(r.id);
    final playing = ListenPlayer.instance.active && ListenPlayer.instance.reciter?.id == r.id;
    final riwayat = r.riwayat.map((w) => w.split(' ').first).toSet().join('، ');
    final kinds = r.kinds.length > 1 ? ' • ${r.kinds.map((k) => k.label).join('، ')}' : '';
    return GlassCard(
      highlight: playing,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      onTap: onTap,
      child: Row(children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: AppColors.gold.withValues(alpha: 0.18),
          child: playing
              ? const Icon(Icons.graphic_eq_rounded, color: AppColors.gold, size: 20)
              : Text(r.name.characters.first, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.name, style: toolTitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('$riwayat$kinds${r.moshafs.length > 1 ? ' • ${_ar(r.moshafs.length)} مصاحف' : ''}',
                style: toolMutedStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
        IconButton(
          tooltip: fav ? 'شيله من المفضلين' : 'ضيفه للمفضلين',
          icon: Icon(fav ? Icons.star_rounded : Icons.star_outline_rounded, color: fav ? AppColors.gold : Colors.white38),
          onPressed: onFavorite,
        ),
      ]),
    );
  }
}

class _CreditLine extends StatelessWidget {
  const _CreditLine();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextButton(
          onPressed: () => showListenCredits(context),
          child: const Text('التلاوات من mp3quran.net', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      );
}

void showListenCredits(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('عن التلاوات'),
      content: const Text(
        'التلاوات من موقع mp3quran.net (أكتر من ٢٠٠ قارئ بروايات مختلفة) — الموقع بيتيح استخدام مواده وروابطه للجميع. '
        'الصوت بيتشغّل مباشرة من سيرفراتهم، ومش بنحمّل حاجة على جهازك.\n\n'
        'الاستماع بيستهلك نت: السورة القصيرة شوية كيلوبايتات والطويلة (زي البقرة) ممكن توصل لـ ٥٠ ميجا أو أكتر.',
      ),
      actions: [
        TextButton(
          onPressed: () => launchUrl(Uri.parse('https://www.mp3quran.net/ar'), mode: LaunchMode.externalApplication),
          child: const Text('mp3quran.net'),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('تمام')),
      ],
    ),
  );
}

// ------------------------------------------------------------------ reciter
/// A reciter's recorded mushafs (riwayah × style).
class ReciterScreen extends StatefulWidget {
  const ReciterScreen({super.key, required this.reciter, this.focusSurah, this.preferRiwayah, this.preferKind});
  final Reciter reciter;
  final int? focusSurah;
  final String? preferRiwayah;
  final RecitationKind? preferKind;

  @override
  State<ReciterScreen> createState() => _ReciterScreenState();
}

class _ReciterScreenState extends State<ReciterScreen> {
  @override
  Widget build(BuildContext context) {
    final r = widget.reciter;
    final preferred = matchingMoshafs(r, riwayah: widget.preferRiwayah, kind: widget.preferKind).toSet();
    final moshafs = [...r.moshafs]..sort((a, b) => (preferred.contains(a) ? 0 : 1).compareTo(preferred.contains(b) ? 0 : 1));
    final fav = ListenStore.favorites.contains(r.id);
    final side = ToolScaffold.side(context);
    final f = widget.focusSurah;
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        iconTheme: AppTheme.nightBarIcons,
        actionsIconTheme: AppTheme.nightBarIcons,
        titleTextStyle: nightTitleStyle(context),
        title: Text(r.name),
        actions: [
          IconButton(
            tooltip: fav ? 'شيله من المفضلين' : 'ضيفه للمفضلين',
            icon: Icon(fav ? Icons.star_rounded : Icons.star_outline_rounded, color: fav ? AppColors.gold : null),
            onPressed: () async {
              await ListenStore.toggleFavorite(r.id);
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      bottomNavigationBar: const ListenMiniPlayer(),
      body: ListView(padding: EdgeInsets.fromLTRB(side, 8, side, 24), children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('اختار الرواية وطريقة القراءة (${_ar(moshafs.length)})', style: toolMutedStyle),
        ),
        for (final m in moshafs)
          GlassCard(
            highlight: ListenPlayer.instance.moshaf?.id == m.id && ListenPlayer.instance.reciter?.id == r.id,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MoshafScreen(reciter: r, moshaf: m, focusSurah: f))),
            child: Row(children: [
              Icon(m.kind == RecitationKind.muallim ? Icons.school_rounded : (m.kind == RecitationKind.mujawwad ? Icons.auto_awesome_rounded : Icons.menu_book_rounded),
                  color: AppColors.gold),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.riwayah, style: toolTitleStyle),
                  Text(
                    '${m.kind.label}${m.note == null ? '' : ' • ${m.note}'} • ${m.complete ? 'المصحف كامل' : '${_ar(m.surahs.length)} سورة'}'
                    '${f != null && !m.has(f) ? ' • ${_surahName(f)} مش موجودة فيه' : ''}',
                    style: toolMutedStyle,
                  ),
                ]),
              ),
              const Icon(Icons.chevron_left_rounded, color: Colors.white54),
            ]),
          ),
        const _CreditLine(),
      ]),
    );
  }
}

// ------------------------------------------------------------------ surahs
/// The surahs of one mushaf with play buttons.
class MoshafScreen extends StatefulWidget {
  const MoshafScreen({super.key, required this.reciter, required this.moshaf, this.focusSurah});
  final Reciter reciter;
  final Moshaf moshaf;
  final int? focusSurah;

  @override
  State<MoshafScreen> createState() => _MoshafScreenState();
}

class _MoshafScreenState extends State<MoshafScreen> {
  static const _rowHeight = 64.0;
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    final m = widget.moshaf;
    final p = ListenPlayer.instance;
    final target = widget.focusSurah ?? ((p.moshaf?.id == m.id && p.reciter?.id == widget.reciter.id) ? p.surah : null);
    final idx = target == null ? -1 : m.surahs.indexOf(target);
    _scroll = ScrollController(initialScrollOffset: idx > 2 ? (idx - 2) * _rowHeight + 120 : 0);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reciter, m = widget.moshaf;
    final side = ToolScaffold.side(context);
    final player = ListenPlayer.instance;
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        iconTheme: AppTheme.nightBarIcons,
        actionsIconTheme: AppTheme.nightBarIcons,
        titleTextStyle: nightTitleStyle(context),
        title: Text(r.name),
      ),
      bottomNavigationBar: const ListenMiniPlayer(),
      body: AnimatedBuilder(
        animation: player,
        builder: (context, _) {
          final mine = player.active && player.reciter?.id == r.id && player.moshaf?.id == m.id;
          return CustomScrollView(controller: _scroll, slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(side, 8, side, 6),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 112,
                  child: GlassCard(
                    margin: EdgeInsets.zero,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(m.title, style: toolTitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(m.complete ? 'المصحف كامل (١١٤ سورة)' : 'متاح ${_ar(m.surahs.length)} سورة من ١١٤', style: toolMutedStyle),
                      const SizedBox(height: 6),
                      Row(children: [
                        FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, visualDensity: VisualDensity.compact),
                          onPressed: () {
                            if (player.mode == PlayMode.once || player.mode == PlayMode.repeatOne) player.setMode(PlayMode.continuous);
                            player.start(r, m, m.surahs.first, resume: false);
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('شغّل من الأول'),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(side, 0, side, 24),
              sliver: SliverFixedExtentList(
                itemExtent: _rowHeight,
                delegate: SliverChildBuilderDelegate(childCount: m.surahs.length, (context, i) {
                  final s = m.surahs[i];
                  final current = mine && player.surah == s;
                  final saved = ListenStore.resumeFor(r.id, m.id, s);
                  final focus = widget.focusSurah == s;
                  final d = surahData[s - 1];
                  return GlassCard(
                    highlight: current || focus,
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                    onTap: () => current ? openListenPlayer(context) : player.start(r, m, s),
                    child: Row(children: [
                      SizedBox(
                        width: 34,
                        child: Text(_ar(s), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_surahName(s), style: toolTitleStyle),
                          Text(
                            current
                                ? (player.loading ? 'بيحمّل…' : '${_clock(player.position)} / ${_clock(player.duration)}')
                                : '${d.$3 ? 'مكية' : 'مدنية'} • ${_ar(d.$2)} آية${saved != null ? ' • وقفت عند ${_clock(saved)}' : ''}',
                            style: toolMutedStyle,
                          ),
                        ]),
                      ),
                      IconButton(
                        tooltip: current && player.playing ? 'إيقاف مؤقت' : 'تشغيل',
                        icon: Icon(
                          current && player.playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                          color: AppColors.gold,
                          size: 34,
                        ),
                        onPressed: () => current ? player.toggle() : player.start(r, m, s),
                      ),
                    ]),
                  );
                }),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

// ------------------------------------------------------------------ mini player
/// The bar under every listening screen while something is loaded.
class ListenMiniPlayer extends StatelessWidget {
  const ListenMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final p = ListenPlayer.instance;
    return AnimatedBuilder(
      animation: p,
      builder: (context, _) {
        if (!p.active) return const SizedBox.shrink();
        final progress = p.duration > 0 ? (p.position / p.duration).clamp(0.0, 1.0) : 0.0;
        return Material(
          color: AppColors.nightMid,
          child: SafeArea(
            top: false,
            child: InkWell(
              onTap: () => openListenPlayer(context),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: LinearProgressIndicator(
                    value: p.loading && p.duration == 0 ? null : progress,
                    minHeight: 2.5,
                    color: AppColors.gold,
                    backgroundColor: Colors.white12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
                  child: Row(children: [
                    const Icon(Icons.graphic_eq_rounded, color: AppColors.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_surahName(p.surah!), style: toolTitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(p.error ?? p.reciter!.name,
                            style: TextStyle(color: p.error != null ? const Color(0xFFFFB4A8) : Colors.white60, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    if (p.loading && !p.playing)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.gold)),
                      )
                    else
                      IconButton(
                        tooltip: p.playing ? 'إيقاف مؤقت' : 'تشغيل',
                        icon: Icon(p.error != null ? Icons.refresh_rounded : (p.playing ? Icons.pause_rounded : Icons.play_arrow_rounded), color: Colors.white, size: 30),
                        onPressed: p.toggle,
                      ),
                    IconButton(
                      tooltip: 'السورة اللي بعدها',
                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white70),
                      onPressed: (p.queue?.hasNext ?? false) ? p.next : null,
                    ),
                    IconButton(tooltip: 'قفل', icon: const Icon(Icons.close_rounded, color: Colors.white54), onPressed: p.stop),
                  ]),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------------------ full player
void openListenPlayer(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.nightMid,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (_) => const ListenPlayerSheet(),
  );
}

class ListenPlayerSheet extends StatefulWidget {
  const ListenPlayerSheet({super.key});

  @override
  State<ListenPlayerSheet> createState() => _ListenPlayerSheetState();
}

class _ListenPlayerSheetState extends State<ListenPlayerSheet> {
  double? _drag;

  Widget _choice(String label, bool selected, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(color: selected ? AppColors.night : Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
        color: _chipColor,
        side: BorderSide(color: selected ? AppColors.gold : AppColors.glassBorder),
        visualDensity: VisualDensity.compact,
      );

  Widget _section(String title, List<Widget> chips) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: chips),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final p = ListenPlayer.instance;
    return AnimatedBuilder(
      animation: p,
      builder: (context, _) {
        if (!p.active) {
          return const SizedBox(height: 160, child: Center(child: Text('مفيش حاجة شغّالة', style: TextStyle(color: Colors.white70))));
        }
        final r = p.reciter!, m = p.moshaf!, s = p.surah!;
        final dur = p.duration;
        final pos = _drag ?? p.position;
        final sleepLeft = p.sleepAt?.difference(DateTime.now());
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                Center(
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), shape: BoxShape.circle, border: Border.all(color: AppColors.gold.withValues(alpha: 0.5))),
                    child: Icon(p.playing ? Icons.graphic_eq_rounded : Icons.menu_book_rounded, color: AppColors.gold, size: 40),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_surahName(s), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                Text(r.name, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700)),
                Text(m.title, textAlign: TextAlign.center, style: toolMutedStyle),
                if (p.error != null)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0x33EF4444), borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      const Icon(Icons.error_outline_rounded, color: Color(0xFFFFB4A8)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(p.error!, style: const TextStyle(color: Colors.white))),
                      TextButton(onPressed: p.retry, child: const Text('جرّب تاني', style: TextStyle(color: AppColors.gold))),
                    ]),
                  ),
                if (p.resumedFrom != null && p.error == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('كمّلنا من ${_clock(p.resumedFrom!)}', style: toolMutedStyle),
                      TextButton(onPressed: p.restartSurah, child: const Text('ابدأ من الأول', style: TextStyle(color: AppColors.gold, fontSize: 12))),
                    ]),
                  ),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                        activeTrackColor: AppColors.gold,
                        inactiveTrackColor: Colors.white12,
                        secondaryActiveTrackColor: Colors.white30,
                        thumbColor: AppColors.gold,
                      ),
                      child: Slider(
                        value: dur > 0 ? pos.clamp(0, dur).toDouble() : 0,
                        secondaryTrackValue: dur > 0 ? p.buffered.clamp(0, dur).toDouble() : null,
                        max: dur > 0 ? dur : 1,
                        onChanged: dur > 0 ? (v) => setState(() => _drag = v) : null,
                        onChangeEnd: dur > 0
                            ? (v) {
                                p.seekTo(v);
                                setState(() => _drag = null);
                              }
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Text(_clock(pos), style: const TextStyle(color: Colors.white60, fontSize: 12)),
                        const Spacer(),
                        Text(dur > 0 ? _clock(dur) : '--:--', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      ]),
                    ),
                    const SizedBox(height: 4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      IconButton(
                        tooltip: 'السورة اللي قبلها',
                        iconSize: 32,
                        color: Colors.white,
                        icon: const Icon(Icons.skip_previous_rounded),
                        onPressed: p.previous,
                      ),
                      IconButton(tooltip: 'رجوع ١٠ ثواني', iconSize: 30, color: Colors.white, icon: const Icon(Icons.replay_10_rounded), onPressed: () => p.seekBy(-10)),
                      SizedBox(
                        width: 68,
                        height: 68,
                        child: p.loading && !p.playing && p.error == null
                            ? const Padding(padding: EdgeInsets.all(18), child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 3))
                            : IconButton.filled(
                                tooltip: p.playing ? 'إيقاف مؤقت' : 'تشغيل',
                                style: IconButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
                                iconSize: 40,
                                icon: Icon(p.error != null ? Icons.refresh_rounded : (p.playing ? Icons.pause_rounded : Icons.play_arrow_rounded)),
                                onPressed: p.toggle,
                              ),
                      ),
                      IconButton(tooltip: 'قدّام ١٠ ثواني', iconSize: 30, color: Colors.white, icon: const Icon(Icons.forward_10_rounded), onPressed: () => p.seekBy(10)),
                      IconButton(
                        tooltip: 'السورة اللي بعدها',
                        iconSize: 32,
                        color: Colors.white,
                        disabledColor: Colors.white24,
                        icon: const Icon(Icons.skip_next_rounded),
                        onPressed: (p.queue?.hasNext ?? false) ? p.next : null,
                      ),
                    ]),
                  ]),
                ),
                _section('بعد ما السورة تخلص', [for (final mode in PlayMode.values) _choice(mode.label, p.mode == mode, () => p.setMode(mode))]),
                _section('السرعة', [
                  for (final sp in playbackSpeeds) _choice('${_ar(sp == sp.roundToDouble() ? sp.toInt() : sp)}×', p.speed == sp, () => p.setSpeed(sp)),
                ]),
                _section(
                  sleepLeft != null && !sleepLeft.isNegative
                      ? 'مؤقت النوم — هيقف بعد ${_ar(sleepLeft.inMinutes + 1)} دقيقة'
                      : (p.sleep == SleepTimer.endOfSurah ? 'مؤقت النوم — هيقف آخر السورة' : 'مؤقت النوم'),
                  [for (final t in SleepTimer.values) _choice(t.label, p.sleep == t, () => p.setSleep(t))],
                ),
                const SizedBox(height: 14),
                Row(children: [
                  const Icon(Icons.wifi_rounded, size: 15, color: Colors.white54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      p.fileBytes != null ? 'حجم السورة دي ${_ar(formatBytes(p.fileBytes!))} — الاستماع بيستهلك نت' : 'الاستماع بيستهلك نت — الأحسن على الواي فاي',
                      style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MoshafScreen(reciter: r, moshaf: m)));
                    },
                    icon: const Icon(Icons.format_list_numbered_rtl_rounded, color: AppColors.gold, size: 18),
                    label: const Text('سور المصحف ده', style: TextStyle(color: AppColors.gold)),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => showListenCredits(context),
                    child: const Text('التلاوات من mp3quran.net', style: TextStyle(color: Colors.white54, fontSize: 11.5)),
                  ),
                ]),
              ]),
            ),
          ),
        );
      },
    );
  }
}
