import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/location/where.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/masjid/prayer_prefs.dart';
import '../../core/masjid/prayer_times.dart';
import '../../core/masjid/world_time.dart';
import '../../core/masjid_tools/hijri.dart' show toArabicDigits;
import '../../core/masjid_tools/platform/feedback.dart';
import '../../core/masjid_tools/reminder_settings.dart';
import '../../core/masjid_tools/reminders_service.dart';
import '../../core/pwa/push.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../masjid/masjid_widgets.dart' show showPrayerSettingsSheet;
import 'city_picker.dart';
import 'tools_ui.dart';

class PrayerRemindersScreen extends StatefulWidget {
  const PrayerRemindersScreen({super.key});

  @override
  State<PrayerRemindersScreen> createState() => _PrayerRemindersScreenState();
}

class _PrayerRemindersScreenState extends State<PrayerRemindersScreen> {
  ReminderSettings? _s;
  bool _busy = false;
  Timer? _syncDebounce;

  @override
  void initState() {
    super.initState();
    PrayerPrefs.load();
    ReminderSettings.load().then((s) {
      if (mounted) setState(() => _s = s);
    });
  }

  Future<void> _method() async {
    final s = _s!;
    await showPrayerSettingsSheet(context, country: s.country, lat: s.lat);
    if (!mounted) return;
    await _update(s); // re-sync with the (maybe) new method
  }

  @override
  void dispose() {
    _syncDebounce?.cancel();
    super.dispose();
  }

  Future<void> _update(ReminderSettings s, {bool sync = true}) async {
    setState(() => _s = s);
    await ReminderSettings.save(s);
    if (sync && s.push && AuthService.isSignedIn) {
      _syncDebounce?.cancel();
      _syncDebounce = Timer(const Duration(milliseconds: 800), () => _sync(s));
    }
  }

  Future<void> _sync(ReminderSettings s) async {
    try {
      await RemindersService.sync(s);
    } catch (e) {
      if (mounted) toolToast(context, e is PostgrestException ? e.message : 'معرفناش نحفظ التنبيه على السيرفر — جرّب تاني');
    }
  }

  Future<void> _useCurrent() async {
    setState(() => _busy = true);
    try {
      final p = await Where.current();
      await _update(_s!.copyWith(source: 'current', lat: p.latitude, lng: p.longitude, label: 'مكاني الحالي', tz: ''));
    } catch (_) {
      if (mounted) toolToast(context, 'مقدرناش نحدد مكانك — اختار مدينة أو مسجد');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickCity() async {
    final c = await pickCity(context);
    if (c != null) await _update(_s!.copyWith(source: 'city', lat: c.lat, lng: c.lng, label: c.label, tz: c.tz));
  }

  Future<void> _pickMosque() async {
    setState(() => _busy = true);
    var rows = <Map<String, dynamic>>[];
    try {
      if (AuthService.isSignedIn) rows = await MasjidService.followed();
      if (rows.isEmpty) {
        final p = await Where.current();
        rows = await MasjidService.nearby(p.latitude, p.longitude, km: 5, limit: 20);
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() => _busy = false);
    if (rows.isEmpty) {
      toolToast(context, 'مفيش مساجد بتتابعها أو قريبة منك — اختار مدينة');
      return;
    }
    final m = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(children: [
          ListTile(title: Text(AuthService.isSignedIn ? 'مسجدك' : 'مساجد قريبة منك', style: const TextStyle(fontWeight: FontWeight.w800))),
          for (final m in rows)
            if (m['lat'] != null && m['lng'] != null)
              ListTile(leading: const Icon(Icons.mosque_rounded), title: Text('${m['name']}'), subtitle: Text('${m['area'] ?? m['address'] ?? ''}'), onTap: () => Navigator.pop(ctx, m)),
        ]),
      ),
    );
    if (m == null) return;
    await _update(_s!.copyWith(source: 'mosque', lat: (m['lat'] as num).toDouble(), lng: (m['lng'] as num).toDouble(), label: '${m['name']}', tz: (m['tz'] as String?) ?? ''));
  }

  Future<void> _togglePush(bool on) async {
    final s = _s!;
    if (!on) {
      await _update(s.copyWith(push: false), sync: false);
      try {
        await RemindersService.sync(s.copyWith(push: false));
      } catch (_) {}
      return;
    }
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!AuthService.isSignedIn || !mounted) return;
    }
    setState(() => _busy = true);
    try {
      final raw = await subscribeDeviceForPush(vapidPublicKey);
      if (raw.isEmpty) {
        if (mounted) {
          toolToast(context, pushState == 'denied'
              ? 'الإشعارات مقفولة من إعدادات المتصفح. افتحها من إعدادات الموقع وجرّب تاني.'
              : 'الجهاز ده مش بيدعم الإشعارات. على الآيفون: ضيف التطبيق للشاشة الرئيسية الأول.');
        }
        return;
      }
      final sub = jsonDecode(raw) as Map<String, dynamic>;
      final keys = Map<String, dynamic>.from(sub['keys'] as Map? ?? const {});
      await Supabase.instance.client.rpc('save_push_subscription', params: {
        'p_endpoint': sub['endpoint'],
        'p_p256dh': keys['p256dh'],
        'p_auth': keys['auth'],
        'p_app': appFlavorId,
      });
      final next = s.copyWith(push: true);
      await _update(next, sync: false);
      await RemindersService.sync(next);
      if (mounted) toolToast(context, 'تمام! التنبيه هيوصلك على الموبايل حتى والتطبيق مقفول 🔔');
    } catch (e) {
      if (mounted) toolToast(context, e is PostgrestException ? e.message : 'حصلت مشكلة، جرّب تاني');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _prayerRow(Prayer p) {
    final s = _s!;
    final on = s.offsets.containsKey(p);
    final today = todayIn(s.zone);
    final time = s.calculator.compute(today.year, today.month, today.day, s.lat, s.lng, tz: s.zone).wall(p);
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text(prayerNames[p]!, style: toolTitleStyle)),
          Text(format12(time), style: const TextStyle(color: Colors.white70)),
          Switch(
            value: on,
            activeThumbColor: AppColors.gold,
            onChanged: (v) {
              final o = Map.of(s.offsets);
              if (v) {
                o[p] = 0;
                unlockAudio();
              } else {
                o.remove(p);
              }
              _update(s.copyWith(offsets: o));
            },
          ),
        ]),
        if (on)
          Wrap(spacing: 6, children: [
            for (final m in ReminderSettings.allowedOffsets)
              ChoiceChip(
                label: Text(m == 0 ? 'وقت الأذان' : 'قبلها ${toArabicDigits(m)} د'),
                selected: s.offsets[p] == m,
                onSelected: (_) => _update(s.copyWith(offsets: {...s.offsets, p: m})),
                labelStyle: TextStyle(color: s.offsets[p] == m ? AppColors.night : Colors.white, fontSize: 12),
                color: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected) ? AppColors.gold : const Color(0xFF2A3A63)),
                side: BorderSide.none,
                showCheckmark: false,
              ),
          ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    if (s == null) return const ToolScaffold(title: 'تنبيه الصلاة', children: [Center(child: CircularProgressIndicator(color: AppColors.gold))]);
    final next = nextAlert(s, DateTime.now());
    return ToolScaffold(title: 'تنبيه الصلاة', children: [
      if (next != null)
        GlassCard(
          highlight: true,
          child: Row(children: [
            const Icon(Icons.alarm_rounded, color: AppColors.gold),
            const SizedBox(width: 10),
            Expanded(
              child: Text('التنبيه الجاي: ${next.title} — ${format12(wallClockIn(next.alertAt, s.zone))}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const Icon(Icons.place_rounded, color: AppColors.gold, size: 20),
            const SizedBox(width: 6),
            Expanded(child: Text('المواقيت حسب: ${s.label}', style: toolTitleStyle)),
            if (_busy) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            _sourceChip('مكاني الحالي', Icons.my_location_rounded, s.source == 'current', _useCurrent),
            _sourceChip('مسجدي', Icons.mosque_rounded, s.source == 'mosque', _pickMosque),
            _sourceChip('مدينة', Icons.location_city_rounded, s.source == 'city', _pickCity),
          ]),
        ]),
      ),
      for (final p in fivePrayers) _prayerRow(p),
      GlassCard(
        child: Column(children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: s.sound,
            activeThumbColor: AppColors.gold,
            title: const Text('صوت تنبيه هادي', style: toolTitleStyle),
            subtitle: const Text('بيشتغل وإنت فاتح التطبيق', style: toolMutedStyle),
            onChanged: (v) {
              if (v) unlockAudio();
              _update(s.copyWith(sound: v), sync: false);
            },
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: playChime,
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.gold),
              label: const Text('جرّب الصوت', style: TextStyle(color: AppColors.gold)),
            ),
          ),
          const Divider(color: Colors.white24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: s.push && AuthService.isSignedIn,
            activeThumbColor: AppColors.gold,
            title: const Text('إشعار على الموبايل والتطبيق مقفول', style: toolTitleStyle),
            subtitle: Text(
              AuthService.isSignedIn
                  ? 'بنبعتلك إشعار في الميعاد حتى لو التطبيق مقفول (لازم تسمح بالإشعارات).'
                  : 'محتاج تسجّل دخول عشان نقدر نبعتلك الإشعار.',
              style: toolMutedStyle,
            ),
            onChanged: _busy || !s.anyOn ? null : _togglePush,
          ),
        ]),
      ),
      Text(
        'التنبيه جوه التطبيق بيظهر طول ما التطبيق مفتوح. المواقيت بطريقة ${s.calculator.method.nameAr}، ${tzLabelAr(s.zone)}.',
        style: toolMutedStyle,
        textAlign: TextAlign.center,
      ),
      Center(
        child: TextButton.icon(
          onPressed: _method,
          icon: const Icon(Icons.tune_rounded, color: AppColors.gold, size: 18),
          label: const Text('طريقة الحساب', style: TextStyle(color: AppColors.gold)),
        ),
      ),
    ]);
  }

  Widget _sourceChip(String label, IconData icon, bool selected, VoidCallback onTap) => ChoiceChip(
        avatar: Icon(icon, size: 16, color: selected ? AppColors.night : Colors.white70),
        label: Text(label),
        selected: selected,
        onSelected: _busy ? null : (_) => onTap(),
        labelStyle: TextStyle(color: selected ? AppColors.night : Colors.white),
        color: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected) ? AppColors.gold : const Color(0xFF2A3A63)),
        side: BorderSide.none,
        showCheckmark: false,
      );
}
