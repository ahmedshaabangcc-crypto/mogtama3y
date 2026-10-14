import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/masjid/prayer_times.dart';
import '../../core/masjid/world_time.dart';
import '../../core/masjid_tools/adhan_player.dart';
import '../../core/masjid_tools/platform/feedback.dart';
import '../../core/masjid_tools/reminder_settings.dart';
import '../../core/theme/app_colors.dart';

/// Shows «تنبيه الصلاة» as a banner on top of every screen while the app is
/// open — with the chosen adhan (or a soft chime) at prayer time. Idle — one
/// cheap check every 20 s — unless the user turned a reminder on.
///
/// Closed-app reminders are Web Push from the server (migrations 0082 /
/// 0090). The phone plays its own notification sound for those (Web Push
/// can't play ours); tapping the adhan notification opens
/// `/#/masjid/tools/reminders?adhan=<prayer>&style=…&voice=…`, and this host
/// plays it — the tap lets the browser start sound, and if it still
/// refuses, the banner shows a big «▶︎ شغّل الأذان» button.
class PrayerReminderHost extends StatefulWidget {
  const PrayerReminderHost({super.key, required this.child, this.router});
  final Widget child;
  final GoRouter? router;

  @override
  State<PrayerReminderHost> createState() => _PrayerReminderHostState();
}

/// The adhan a notification link asks for, or null. Only within 30 minutes
/// after that prayer's time (an old notification tapped later just opens
/// the screen). Pure — unit tested.
({Prayer prayer, AdhanStyle style, String voice})? adhanFromLink(Uri uri, ReminderSettings s, DateTime now) {
  final q = uri.queryParameters;
  final name = q['adhan'];
  if (name == null) return null;
  final prayer = fivePrayers.where((p) => p.name == name).firstOrNull;
  if (prayer == null) return null;
  final style = AdhanStyle.tryParse(q['style']) ?? s.styleFor(prayer);
  if (!style.playsAdhan) return null;
  final voice = adhanVoices.any((v) => v.id == q['voice']) ? q['voice']! : s.voice;
  final zone = s.zone;
  final instant = now.toUtc();
  final today = todayIn(zone, instant);
  for (final d in [today, today.subtract(const Duration(days: 1))]) {
    final at = s.calculator.compute(d.year, d.month, d.day, s.lat, s.lng, tz: zone)[prayer];
    final since = instant.difference(at);
    if (since > const Duration(minutes: -5) && since < const Duration(minutes: 30)) return (prayer: prayer, style: style, voice: voice);
  }
  return null;
}

class _PrayerReminderHostState extends State<PrayerReminderHost> {
  Timer? _timer;
  final _shown = <String>{};
  PrayerAlert? _alert;
  Timer? _hide;
  bool _primed = false;
  String? _handledLink;

  @override
  void initState() {
    super.initState();
    ReminderSettings.load().then((_) {
      // Alerts already due when the app opens aren't replayed.
      _check(silent: true);
      _primed = true;
      _checkLink();
    });
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _check());
    widget.router?.routerDelegate.addListener(_checkLink);
    AdhanPlayer.instance.now.addListener(_onAdhan);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hide?.cancel();
    widget.router?.routerDelegate.removeListener(_checkLink);
    AdhanPlayer.instance.now.removeListener(_onAdhan);
    super.dispose();
  }

  void _onAdhan() {
    if (mounted) setState(() {});
  }

  /// A tapped adhan notification (?adhan=asr): play it once, then drop the
  /// query so a reload doesn't replay it.
  void _checkLink() {
    final r = widget.router;
    final s = ReminderSettings.current.value;
    if (r == null || s == null) return;
    final uri = r.routerDelegate.currentConfiguration.uri;
    if (!uri.queryParameters.containsKey('adhan')) return;
    final key = uri.toString();
    if (key == _handledLink) return;
    _handledLink = key;
    final want = adhanFromLink(uri, s, DateTime.now());
    if (want != null) _shown.addAll(dueAlerts(s, DateTime.now(), const {}, window: const Duration(minutes: 30)).map((a) => a.key));
    // Not while the router is notifying / building.
    scheduleMicrotask(() {
      r.go(uri.path);
      if (want != null) AdhanPlayer.instance.start(want.prayer, want.style, want.voice);
    });
  }

  void _check({bool silent = false}) {
    final s = ReminderSettings.current.value;
    if (s == null || !s.anyOn) return;
    final due = dueAlerts(s, DateTime.now(), _shown);
    if (due.isEmpty) return;
    for (final a in due) {
      _shown.add(a.key);
    }
    while (_shown.length > 50) {
      _shown.remove(_shown.first);
    }
    if (silent || !_primed || !mounted) return;
    final a = due.last;
    setState(() => _alert = a);
    final style = s.styleFor(a.prayer);
    if (a.minutesBefore == 0 && style.playsAdhan) {
      AdhanPlayer.instance.start(a.prayer, style, s.voice);
    } else if (s.sound) {
      playChime();
    }
    vibrate(200);
    _hide?.cancel();
    _hide = Timer(const Duration(minutes: 2), () {
      if (mounted && AdhanPlayer.instance.now.value == null) setState(() => _alert = null);
    });
  }

  void _close() {
    AdhanPlayer.instance.stop();
    setState(() => _alert = null);
  }

  @override
  Widget build(BuildContext context) {
    final a = _alert;
    final adhan = AdhanPlayer.instance.now.value;
    final show = a != null || adhan != null;
    final title = adhan != null ? 'أذان ${prayerNames[adhan.prayer]}' : a?.title ?? '';
    final sub = adhan == null
        ? a?.body ?? ''
        : adhan.failed
            ? 'معرفناش نشغّل الصوت — اتأكد من النت'
            : adhan.blocked
                ? 'المتصفح محتاج لمسة منك عشان يشغّل الصوت'
                : adhanVoice(adhan.voice).nameAr;
    return Listener(
      // Browsers allow sound only after a user gesture.
      onPointerDown: (_) {
        if (ReminderSettings.current.value?.sound ?? false) unlockAudio();
      },
      child: Stack(children: [
        widget.child,
        if (show)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Material(
                      elevation: 8,
                      color: AppColors.night,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Row(children: [
                            const Icon(Icons.mosque_rounded, color: AppColors.gold),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                                Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              ]),
                            ),
                            if (adhan != null && adhan.playing)
                              TextButton.icon(
                                onPressed: AdhanPlayer.instance.stop,
                                icon: const Icon(Icons.stop_rounded, color: AppColors.gold),
                                label: const Text('إيقاف', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
                              ),
                            // No tooltip: this sits above the Navigator's Overlay.
                            IconButton(onPressed: _close, icon: const Icon(Icons.close_rounded, color: Colors.white70)),
                          ]),
                          if (adhan != null && (adhan.blocked || adhan.failed))
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 2),
                              child: FilledButton.icon(
                                onPressed: AdhanPlayer.instance.play,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.night,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded, size: 28),
                                label: const Text('شغّل الأذان'),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
