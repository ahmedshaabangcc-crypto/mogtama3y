import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/masjid/masjid_live.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'masjid_widgets.dart';

/// «دروس أونلاين» (0085) in the app: cards, the full list, and the
/// mosque admins' tab. The room itself is the standalone page /live/
/// (web/live/), opened in the same tab so it shares the session.

/// Opens the live page for lesson [id] (same tab on the web).
Future<void> openLiveLesson(BuildContext context, String id) async {
  if (!AuthService.isSignedIn) {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (!AuthService.isSignedIn) return;
  }
  final uri = liveLessonUri(id, kIsWeb ? Uri.base : Uri.parse(masjidUrl));
  await launchUrl(uri, webOnlyWindowName: '_self', mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication);
}

/// One lesson: live badge / when, mosque, sheikh, mode, who can attend,
/// and «ادخل الدرس» while it's live.
class LiveLessonCard extends StatelessWidget {
  const LiveLessonCard({super.key, required this.session, this.showMosque = true});
  final Map<String, dynamic> session;
  final bool showMosque;

  @override
  Widget build(BuildContext context) {
    final s = session;
    final now = DateTime.now();
    final live = liveIsLive(s, now);
    final canJoin = s['can_join'] == true || !AuthService.isSignedIn;
    final km = (s['distance_km'] as num?)?.toDouble();
    final meta = [
      if (s['sheikh'] != null) 'مع ${s['sheikh']}',
      liveModeLabels[s['mode']] ?? '',
      MasjidService.audienceLabels[s['audience']] ?? '',
      if (s['visibility'] == 'members') 'لأعضاء المسجد',
    ].where((e) => e.isNotEmpty).join(' • ');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: showMosque && s['mosque_id'] != null ? () => context.push(AppRoutes.mosque(s['mosque_id'] as String)) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              if (live)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(6)),
                  child: const Text('● مباشر', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                )
              else
                Text(liveWhenLabel(s, now), style: const TextStyle(fontSize: 11.5, color: AppColors.crystal, fontWeight: FontWeight.w800)),
              const Spacer(),
              if (showMosque)
                Flexible(
                  child: Text([s['mosque_name'], if (km != null) '${km.toStringAsFixed(km < 10 ? 1 : 0)} كم'].whereType<String>().join(' • '),
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                ),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Icon(s['mode'] == 'video' ? Icons.videocam_rounded : Icons.headphones_rounded, size: 18, color: AppColors.crystal),
              const SizedBox(width: 6),
              Expanded(child: Text(s['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
            ]),
            if (meta.isNotEmpty) Text(meta, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
            if ((s['description'] as String?)?.isNotEmpty == true)
              Text(s['description'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
            const SizedBox(height: 6),
            Row(children: [
              const Expanded(child: Text(liveNotRecordedNote, style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
              if (live && canJoin)
                FilledButton.icon(
                  onPressed: () => openLiveLesson(context, s['id'] as String),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: Text(s['is_host'] == true ? 'ادخل وقدّم الدرس' : 'ادخل الدرس'),
                )
              else if (live)
                const Text('انضم للمسجد عشان تحضر', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary))
              else if (s['is_host'] == true && s['status'] == 'scheduled')
                OutlinedButton(onPressed: () => openLiveLesson(context, s['id'] as String), child: const Text('افتح صفحة الدرس')),
            ]),
          ]),
        ),
      ),
    );
  }
}

/// «دروس أونلاين» — every live / upcoming lesson the user can join.
class LiveLessonsScreen extends StatefulWidget {
  const LiveLessonsScreen({super.key, this.lat, this.lng});
  final double? lat;
  final double? lng;

  @override
  State<LiveLessonsScreen> createState() => _LiveLessonsScreenState();
}

class _LiveLessonsScreenState extends State<LiveLessonsScreen> {
  List<Map<String, dynamic>>? _rows;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final rows = await MasjidService.liveFeed(lat: widget.lat, lng: widget.lng, km: 15);
      if (mounted) setState(() => _rows = rows..sort(compareLive));
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('دروس أونلاين')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          const Text('اسمع دروس مساجدك مباشرة من موبايلك — صوت بس أو صوت وصورة. ارفع إيدك لو عندك سؤال.',
              style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
          const SizedBox(height: 10),
          if (_error)
            TextButton(onPressed: _load, child: const Text('تعذر التحميل — جرّب تاني'))
          else if (rows == null)
            const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
          else if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('مفيش دروس أونلاين في مساجدك أو حواليك الأسبوع ده. انضم لمسجدك وتابعه عشان يوصلك إشعار أول ما الدرس يبدأ.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.7)),
            )
          else
            for (final s in rows) LiveLessonCard(session: s),
        ]),
      ),
    );
  }
}

/// «إدارة المسجد → أونلاين»: schedule, edit, cancel, start, end.
class MosqueLiveManageTab extends StatefulWidget {
  const MosqueLiveManageTab({super.key, required this.mosqueId});
  final String mosqueId;

  @override
  State<MosqueLiveManageTab> createState() => _MosqueLiveManageTabState();
}

class _MosqueLiveManageTabState extends State<MosqueLiveManageTab> {
  List<Map<String, dynamic>>? _rows;
  bool _error = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final rows = await MasjidService.liveSessions(widget.mosqueId, includePast: true);
      if (mounted) setState(() => _rows = rows);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _run(Future<void> Function() f, String done) async {
    setState(() => _busy = true);
    try {
      await f();
      _toast(done);
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(text),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('تمام')),
          ],
        ),
      ) ==
      true;

  Future<void> _edit([Map<String, dynamic>? s]) async {
    final title = TextEditingController(text: s?['title'] as String?);
    final sheikh = TextEditingController(text: s?['sheikh'] as String?);
    final description = TextEditingController(text: s?['description'] as String?);
    final at0 = DateTime.tryParse('${s?['scheduled_at'] ?? ''}')?.toLocal();
    final n0 = DateTime.now();
    final today = DateTime(n0.year, n0.month, n0.day);
    var day = at0 == null ? 0 : DateTime(at0.year, at0.month, at0.day).difference(today).inDays.clamp(0, 59);
    var minute = at0 == null ? 20 * 60 : ((at0.hour * 60 + at0.minute) ~/ 15) * 15;
    var now = s == null;
    var duration = (s?['duration_minutes'] as num?)?.toInt() ?? 60;
    if (!liveDurations.contains(duration)) duration = 60;
    var mode = (s?['mode'] as String?) ?? 'audio';
    var visibility = (s?['visibility'] as String?) ?? 'public';
    var audience = (s?['audience'] as String?) ?? 'all';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: Text(s == null ? 'درس أونلاين جديد' : 'تعديل الدرس'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              TextField(controller: title, maxLength: 120, decoration: const InputDecoration(labelText: 'العنوان', hintText: 'تفسير سورة الكهف')),
              TextField(controller: sheikh, maxLength: 80, decoration: const InputDecoration(labelText: 'الشيخ (اختياري)')),
              TextField(controller: description, maxLength: 500, maxLines: 2, decoration: const InputDecoration(labelText: 'نبذة (اختياري)')),
              if (s == null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('هبدأ دلوقتي'),
                  value: now,
                  onChanged: (v) => set(() => now = v),
                ),
              if (!now) ...[
                // Plain dropdowns: the Material date / time pickers would add ~250 KB to main.dart.js.
                DropdownButtonFormField<int>(
                  initialValue: day,
                  decoration: const InputDecoration(labelText: 'اليوم'),
                  items: [for (var i = 0; i < 60; i++) DropdownMenuItem(value: i, child: Text(liveDayLabel(DateTime(today.year, today.month, today.day + i), today)))],
                  onChanged: (v) => set(() => day = v ?? day),
                ),
                DropdownButtonFormField<int>(
                  initialValue: minute,
                  decoration: const InputDecoration(labelText: 'الساعة'),
                  items: [for (var m = 0; m < 24 * 60; m += 15) DropdownMenuItem(value: m, child: Text(clock12(DateTime(2000, 1, 1, m ~/ 60, m % 60))))],
                  onChanged: (v) => set(() => minute = v ?? minute),
                ),
              ],
              DropdownButtonFormField<int>(
                initialValue: duration,
                decoration: const InputDecoration(labelText: 'المدة'),
                items: [for (final m in liveDurations) DropdownMenuItem(value: m, child: Text(m < 60 ? '$m دقيقة' : (m % 60 == 0 ? '${m ~/ 60} ساعة' : '${m ~/ 60} ساعة و${m % 60} دقيقة')))],
                onChanged: (v) => set(() => duration = v ?? duration),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'audio', label: Text('صوت بس'), icon: Icon(Icons.headphones_rounded)),
                  ButtonSegment(value: 'video', label: Text('صوت وصورة'), icon: Icon(Icons.videocam_rounded)),
                ],
                selected: {mode},
                onSelectionChanged: (v) => set(() => mode = v.first),
              ),
              const Text('«صوت بس» بيشتغل على أي نت ضعيف.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              DropdownButtonFormField<String>(
                initialValue: visibility,
                decoration: const InputDecoration(labelText: 'مين يقدر يحضر'),
                items: [for (final e in liveVisibilityLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                onChanged: (v) => set(() => visibility = v ?? visibility),
              ),
              DropdownButtonFormField<String>(
                initialValue: audience,
                decoration: const InputDecoration(labelText: 'الدرس لمين'),
                items: [for (final e in MasjidService.audienceLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                onChanged: (v) => set(() => audience = v ?? audience),
              ),
              const SizedBox(height: 8),
              const Text('$liveNotRecordedNote. المستمعين يقدروا يرفعوا إيدهم وإنت تسمحلهم يتكلموا.',
                  style: TextStyle(fontSize: 11, color: AppColors.inkMuted, height: 1.6)),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s == null && now ? 'ابدأ' : 'حفظ')),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final d = DateTime(today.year, today.month, today.day + day);
    final when = now ? DateTime.now() : DateTime(d.year, d.month, d.day, minute ~/ 60, minute % 60);
    final err = liveFormError(title: title.text, at: when, now: DateTime.now());
    if (err != null) return _toast(err);
    final values = {
      'title': title.text.trim(),
      'sheikh': sheikh.text.trim(),
      'description': description.text.trim(),
      'scheduled_at': when.toUtc().toIso8601String(),
      'duration_minutes': duration,
      'mode': mode,
      'visibility': visibility,
      'audience': audience,
    };
    if (s != null) return _run(() => MasjidService.liveUpdate(s['id'] as String, values), 'اتحفظ');
    setState(() => _busy = true);
    try {
      final id = await MasjidService.liveCreate(widget.mosqueId, values);
      if (now) {
        await MasjidService.liveStart(id);
        if (mounted) await openLiveLesson(context, id);
      } else {
        _toast('اتحدد الميعاد — المتابعين هيوصلهم إشعار');
      }
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _start(Map<String, dynamic> s) async {
    setState(() => _busy = true);
    try {
      await MasjidService.liveStart(s['id'] as String);
      if (mounted) await openLiveLesson(context, s['id'] as String);
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    if (_error) return Center(child: TextButton(onPressed: _load, child: const Text('تعذر التحميل — جرّب تاني')));
    if (rows == null) return const Center(child: CircularProgressIndicator());
    final now = DateTime.now();
    final open = rows.where((s) => (s['status'] == 'live' || s['status'] == 'scheduled') && s['stale'] != true).toList();
    final past = rows.where((s) => !open.contains(s)).toList();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 40), children: [
        ElevatedButton.icon(onPressed: _busy ? null : () => _edit(), icon: const Icon(Icons.add_rounded), label: const Text('درس أونلاين جديد')),
        const SizedBox(height: 6),
        const Text('درس مباشر بالصوت (أو صوت وصورة) من موبايلك لأهل المسجد. $liveNotRecordedNote.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted, height: 1.6)),
        const SizedBox(height: 10),
        if (open.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('مفيش دروس جاية', style: TextStyle(color: AppColors.inkMuted)))),
        for (final s in open)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(s['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800)),
                Text([liveWhenLabel(s, now), liveModeLabels[s['mode']] ?? '', liveVisibilityLabels[s['visibility']] ?? ''].join(' • '),
                    style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  if (s['status'] == 'live') ...[
                    FilledButton(onPressed: _busy ? null : () => openLiveLesson(context, s['id'] as String), child: const Text('ادخل الدرس')),
                    OutlinedButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              if (await _confirm('تنهي «${s['title']}» للكل؟')) _run(() => MasjidService.liveEnd(s['id'] as String), 'الدرس خلص');
                            },
                      child: const Text('إنهاء الدرس'),
                    ),
                  ] else ...[
                    FilledButton(onPressed: _busy ? null : () => _start(s), child: const Text('ابدأ دلوقتي')),
                    OutlinedButton(onPressed: _busy ? null : () => _edit(s), child: const Text('تعديل')),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              if (await _confirm('تلغي «${s['title']}»؟')) _run(() => MasjidService.liveCancel(s['id'] as String), 'اتلغى');
                            },
                      child: const Text('إلغاء'),
                    ),
                  ],
                ]),
              ]),
            ),
          ),
        if (past.isNotEmpty) ...[
          const Padding(padding: EdgeInsets.only(top: 14, bottom: 6), child: Text('آخر 30 يوم', style: TextStyle(fontWeight: FontWeight.w800))),
          for (final s in past)
            ListTile(
              dense: true,
              title: Text(s['title'] as String? ?? ''),
              subtitle: Text(s['status'] == 'cancelled' ? 'اتلغى' : 'خلص'),
            ),
        ],
      ]),
    );
  }
}
