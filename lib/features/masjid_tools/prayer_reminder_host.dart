import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/masjid_tools/platform/feedback.dart';
import '../../core/masjid_tools/reminder_settings.dart';
import '../../core/theme/app_colors.dart';

/// Shows «تنبيه الصلاة» as a banner on top of every screen while the app is
/// open (with a soft chime when enabled). Idle — one cheap check every 20 s —
/// unless the user turned a reminder on. Closed-app reminders are Web Push
/// from the server (migration 0082).
class PrayerReminderHost extends StatefulWidget {
  const PrayerReminderHost({super.key, required this.child});
  final Widget child;

  @override
  State<PrayerReminderHost> createState() => _PrayerReminderHostState();
}

class _PrayerReminderHostState extends State<PrayerReminderHost> {
  Timer? _timer;
  final _shown = <String>{};
  PrayerAlert? _alert;
  Timer? _hide;
  bool _primed = false;

  @override
  void initState() {
    super.initState();
    ReminderSettings.load().then((_) {
      // Alerts already due when the app opens aren't replayed.
      _check(silent: true);
      _primed = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hide?.cancel();
    super.dispose();
  }

  void _check({bool silent = false}) {
    final s = ReminderSettings.current.value;
    if (s == null || !s.anyOn) return;
    final due = dueAlerts(s, DateTime.now(), _shown);
    if (due.isEmpty) return;
    for (final a in due) {
      _shown.add(a.key);
    }
    if (_shown.length > 50) _shown.remove(_shown.first);
    if (silent || !_primed || !mounted) return;
    setState(() => _alert = due.last);
    if (s.sound) playChime();
    vibrate(200);
    _hide?.cancel();
    _hide = Timer(const Duration(minutes: 2), () {
      if (mounted) setState(() => _alert = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = _alert;
    return Listener(
      // Browsers allow sound only after a user gesture.
      onPointerDown: (_) {
        if (ReminderSettings.current.value?.sound ?? false) unlockAudio();
      },
      child: Stack(children: [
        widget.child,
        if (a != null)
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
                        child: Row(children: [
                          const Icon(Icons.mosque_rounded, color: AppColors.gold),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                              Text(a.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                              Text(a.body, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ]),
                          ),
                          // No tooltip: this sits above the Navigator's Overlay.
                          IconButton(
                            onPressed: () => setState(() => _alert = null),
                            icon: const Icon(Icons.close_rounded, color: Colors.white70),
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
