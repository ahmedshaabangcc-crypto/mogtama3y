import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/masjid/masjid_service.dart';
import '../../core/masjid/prayer_times.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import '../tutorials/tutorial_widgets.dart';
import 'masjid_live_widgets.dart';
import 'masjid_widgets.dart';
import 'mosque_page_screen.dart' show ContributionsList;
import 'package:mogtama3y/core/utils/numbers.dart';

/// «إدارة المسجد» for the mosque's verified owner and helpers. Each tab
/// appears only with its permission; the database enforces the same rules
/// (RLS + masjid_can), this screen just hides what would be refused.
class MosqueManageScreen extends StatelessWidget {
  const MosqueManageScreen({super.key, required this.mosque});
  final Map<String, dynamic> mosque;

  @override
  Widget build(BuildContext context) {
    final perms = ((mosque['my_permissions'] as List?) ?? const []).cast<String>();
    final id = mosque['id'] as String;
    final tabs = <(String, IconData, Widget)>[
      if (perms.contains('posts')) ('الإعلانات', Icons.campaign_rounded, _PostsTab(mosqueId: id)),
      if (perms.contains('lessons')) ('الدروس', Icons.menu_book_rounded, _LessonsTab(mosqueId: id)),
      if (perms.contains('lessons')) ('أونلاين', Icons.live_tv_rounded, MosqueLiveManageTab(mosqueId: id)),
      if (perms.contains('needs')) ('الاحتياجات', Icons.volunteer_activism_rounded, _NeedsTab(mosqueId: id)),
      if (perms.contains('orphans')) ('الأيتام', Icons.child_care_rounded, _OrphansTab(mosqueId: id)),
      if (perms.contains('competitions')) ('المسابقات', Icons.emoji_events_rounded, _CompetitionsTab(mosqueId: id)),
      if (perms.contains('settings')) ('البيانات', Icons.tune_rounded, _SettingsTab(mosque: mosque)),
      if (perms.contains('team')) ('الفريق', Icons.groups_rounded, _TeamTab(mosqueId: id)),
    ];
    if (tabs.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('إدارة المسجد')), body: const Center(child: Text('مالكش صلاحيات على المسجد ده')));
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Text('إدارة ${mosque['name']}'),
          actions: const [TutorialButton(screenKey: 'mosque_manage')],
          bottom: TabBar(isScrollable: true, tabAlignment: TabAlignment.start, tabs: [for (final t in tabs) Tab(icon: Icon(t.$2, size: 18), text: t.$1)]),
        ),
        body: TabBarView(children: [for (final t in tabs) t.$3]),
      ),
    );
  }
}

void _toast(BuildContext context, String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

Future<bool> _confirm(BuildContext context, String text) async =>
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

/// Shared list scaffolding: load, error, empty, add button.
class _ListTab extends StatelessWidget {
  const _ListTab({required this.loading, required this.error, required this.onRetry, required this.onAdd, required this.addLabel, required this.children});
  final bool loading;
  final bool error;
  final VoidCallback onRetry;
  final VoidCallback onAdd;
  final String addLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error) return LoadErrorView(onRetry: onRetry);
    return ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 40), children: [
      ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add_rounded), label: Text(addLabel)),
      const SizedBox(height: 12),
      if (children.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('لسه مفيش حاجة هنا', style: TextStyle(color: AppColors.inkMuted)))),
      ...children,
    ]);
  }
}

mixin _Loader<T extends StatefulWidget> on State<T> {
  bool loading = true;
  bool error = false;
  List<Map<String, dynamic>> rows = [];

  Future<List<Map<String, dynamic>>> fetch();

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() {
      loading = rows.isEmpty;
      error = false;
    });
    try {
      final r = await fetch();
      if (mounted) {
        setState(() {
          rows = r;
          loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          loading = false;
          error = true;
        });
      }
    }
  }

  Future<void> run(Future<void> Function() f, {String? done}) async {
    try {
      await f();
      if (done != null && mounted) _toast(context, done);
      await reload();
    } catch (e) {
      if (mounted) _toast(context, masjidError(e));
    }
  }
}

// ================================================================= posts
class _PostsTab extends StatefulWidget {
  const _PostsTab({required this.mosqueId});
  final String mosqueId;

  @override
  State<_PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<_PostsTab> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.posts(widget.mosqueId);

  Future<void> _edit([Map<String, dynamic>? p]) async {
    final title = TextEditingController(text: p?['title'] as String?);
    final body = TextEditingController(text: p?['body'] as String?);
    var kind = (p?['kind'] as String?) ?? 'announcement';
    var pinned = p?['pinned'] == true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: Text(p == null ? 'إعلان جديد' : 'تعديل الإعلان'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                initialValue: kind,
                decoration: const InputDecoration(labelText: 'النوع'),
                items: [for (final e in MasjidService.postKinds.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                onChanged: (v) => set(() => kind = v ?? kind),
              ),
              TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان', hintText: 'صلاة الجنازة على … بعد الظهر')),
              TextField(controller: body, maxLines: 4, decoration: const InputDecoration(labelText: 'التفاصيل (اختياري)')),
              SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('تثبيت فوق'), value: pinned, onChanged: (v) => set(() => pinned = v)),
              if (p == null)
                const Text('المتابعين بيوصلهم إشعار (الجنازة والتنبيه العاجل بيوصلوا فوراً، والإعلانات العادية مرة كل ساعتين بالكتير).',
                    style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('انشر')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await run(() => MasjidService.savePost(widget.mosqueId, id: p?['id'] as String?, kind: kind, title: title.text.trim(), body: body.text.trim().isEmpty ? null : body.text.trim(), pinned: pinned),
        done: 'اتنشر');
  }

  @override
  Widget build(BuildContext context) => _ListTab(
        loading: loading,
        error: error,
        onRetry: reload,
        onAdd: _edit,
        addLabel: 'إعلان جديد',
        children: [
          for (final p in rows)
            Card(
              child: ListTile(
                leading: Icon(p['pinned'] == true ? Icons.push_pin_rounded : Icons.campaign_outlined, color: AppColors.crystal),
                title: Text(p['title'] as String? ?? ''),
                subtitle: Text(MasjidService.postKinds[p['kind']] ?? ''),
                onTap: () => _edit(p),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () async {
                    if (await _confirm(context, 'تمسح الإعلان ده؟')) run(() => MasjidService.deleteRow('mosque_posts', p['id'] as String));
                  },
                ),
              ),
            ),
        ],
      );
}

// =============================================================== lessons
class _LessonsTab extends StatefulWidget {
  const _LessonsTab({required this.mosqueId});
  final String mosqueId;

  @override
  State<_LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<_LessonsTab> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.lessons(widget.mosqueId);

  Future<void> _edit([Map<String, dynamic>? l]) async {
    final title = TextEditingController(text: l?['title'] as String?);
    final sheikh = TextEditingController(text: l?['sheikh'] as String?);
    final location = TextEditingController(text: l?['location'] as String?);
    final time = TextEditingController(text: (l?['start_time'] as String?)?.substring(0, 5));
    var kind = (l?['kind'] as String?) ?? 'lesson';
    var audience = (l?['audience'] as String?) ?? 'all';
    String? after = l?['after_prayer'] as String? ?? 'asr';
    final days = <int>{...((l?['weekdays'] as List?) ?? const []).map((e) => (e as num).toInt())};
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: Text(l == null ? 'درس أو حلقة جديدة' : 'تعديل'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SegmentedButton<String>(
                segments: const [ButtonSegment(value: 'lesson', label: Text('درس')), ButtonSegment(value: 'quran_circle', label: Text('حلقة قرآن'))],
                selected: {kind},
                onSelectionChanged: (s) => set(() => kind = s.first),
              ),
              TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان', hintText: 'درس الفقه الأسبوعي')),
              TextField(controller: sheikh, decoration: const InputDecoration(labelText: 'الشيخ / المحفّظ (اختياري)')),
              const SizedBox(height: 8),
              const Text('الأيام', style: TextStyle(fontSize: 12)),
              Wrap(spacing: 4, runSpacing: 4, children: [
                for (final d in [6, 7, 1, 2, 3, 4, 5])
                  FilterChip(
                    label: Text(weekdayNames[d]!, style: const TextStyle(fontSize: 11)),
                    selected: days.contains(d),
                    onSelected: (v) => set(() => v ? days.add(d) : days.remove(d)),
                  ),
              ]),
              DropdownButtonFormField<String?>(
                initialValue: after,
                decoration: const InputDecoration(labelText: 'الميعاد'),
                items: [
                  for (final p in fivePrayers) DropdownMenuItem(value: p.name, child: Text('بعد ${prayerNames[p]}')),
                  const DropdownMenuItem(value: null, child: Text('ساعة محددة')),
                ],
                onChanged: (v) => set(() => after = v),
              ),
              if (after == null) TextField(controller: time, decoration: const InputDecoration(labelText: 'الساعة (24 ساعة)', hintText: '19:30')),
              DropdownButtonFormField<String>(
                initialValue: audience,
                decoration: const InputDecoration(labelText: 'لمين'),
                items: [for (final e in MasjidService.audienceLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                onChanged: (v) => set(() => audience = v ?? audience),
              ),
              TextField(controller: location, decoration: const InputDecoration(labelText: 'المكان في المسجد (اختياري)', hintText: 'مصلى السيدات')),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final t = time.text.trim();
    if (after == null && !RegExp(r'^\d{1,2}:\d{2}$').hasMatch(t)) {
      if (mounted) _toast(context, 'اكتب الساعة زي 19:30');
      return;
    }
    await run(
      () => MasjidService.saveLesson(widget.mosqueId, {
        'kind': kind,
        'title': title.text.trim(),
        'sheikh': sheikh.text.trim().isEmpty ? null : sheikh.text.trim(),
        'weekdays': days.toList()..sort(),
        'after_prayer': after,
        'start_time': after == null ? t : null,
        'audience': audience,
        'location': location.text.trim().isEmpty ? null : location.text.trim(),
      }, id: l?['id'] as String?),
      done: 'اتحفظ',
    );
  }

  @override
  Widget build(BuildContext context) => _ListTab(
        loading: loading,
        error: error,
        onRetry: reload,
        onAdd: _edit,
        addLabel: 'درس أو حلقة جديدة',
        children: [
          for (final l in rows)
            Card(
              child: ListTile(
                title: Text(l['title'] as String? ?? ''),
                subtitle: Text([lessonWhen(l), MasjidService.audienceLabels[l['audience']] ?? ''].join(' • ')),
                onTap: () => _edit(l),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () async {
                    if (await _confirm(context, 'تمسح «${l['title']}»؟')) run(() => MasjidService.deleteRow('mosque_lessons', l['id'] as String));
                  },
                ),
              ),
            ),
        ],
      );
}

// ================================================================= needs
class _NeedsTab extends StatefulWidget {
  const _NeedsTab({required this.mosqueId});
  final String mosqueId;

  @override
  State<_NeedsTab> createState() => _NeedsTabState();
}

class _NeedsTabState extends State<_NeedsTab> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.needs(widget.mosqueId);

  Future<void> _add() async {
    final title = TextEditingController();
    final desc = TextEditingController();
    final target = TextEditingController();
    XFile? photo;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('احتياج جديد'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: title, decoration: const InputDecoration(labelText: 'الاحتياج', hintText: 'مروحة سقف للمصلى')),
              TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'التفاصيل (اختياري)')),
              TextField(controller: target, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ المطلوب (ج.م)', hintText: '1000')),
              TextButton.icon(
                onPressed: () async {
                  final f = await UploadService.pickImage(source: ImageSource.gallery);
                  if (f != null) set(() => photo = f);
                },
                icon: Icon(photo == null ? Icons.add_photo_alternate_outlined : Icons.check_circle_rounded),
                label: Text(photo == null ? 'صورة (اختياري)' : 'تم اختيار الصورة'),
              ),
              const NoMoneyNote(extra: 'اكتب في «البيانات» إزاي الناس تدفع (واتساب، أمين المسجد…).'),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('انشر')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final amount = looseDouble(target.text.trim().replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      if (mounted) _toast(context, 'اكتب المبلغ المطلوب');
      return;
    }
    await run(() async {
      final url = photo == null ? null : await UploadService.uploadPublicPhoto(purpose: 'mosque_need', file: photo!);
      await MasjidService.saveNeed(widget.mosqueId, {
        'title': title.text.trim(),
        'description': desc.text.trim().isEmpty ? null : desc.text.trim(),
        'target_amount': amount,
        'photo_url': url,
      });
    }, done: 'اتنشر الاحتياج');
  }

  Future<void> _cash(Map<String, dynamic> n) async {
    final amount = TextEditingController();
    final name = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('سجّل مبلغ وصل كاش'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ (ج.م)')),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المتبرع (فاضي = فاعل خير)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('سجّل')),
        ],
      ),
    );
    if (ok != true) return;
    final v = looseDouble(amount.text.trim().replaceAll(',', ''));
    if (v == null || v <= 0) return;
    await run(() => MasjidService.addCash(n['id'] as String, v, donorName: name.text.trim().isEmpty ? null : name.text.trim()), done: 'اتسجّل');
  }

  Future<void> _contributions(Map<String, dynamic> n) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (ctx, c) => ContributionsList(need: n, canManage: true, controller: c, onChanged: reload),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _ListTab(
        loading: loading,
        error: error,
        onRetry: reload,
        onAdd: _add,
        addLabel: 'احتياج جديد',
        children: [
          for (final n in rows)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(n['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  NeedProgress(need: n),
                  Wrap(spacing: 6, children: [
                    TextButton(onPressed: () => _contributions(n), child: Text('المساهمات وتأكيدها (${n['contributors'] ?? 0})')),
                    TextButton(onPressed: () => _cash(n), child: const Text('وصل كاش')),
                    TextButton(
                      onPressed: () => run(() => MasjidService.setNeedStatus(n['id'] as String, n['status'] == 'open' ? 'closed' : 'open')),
                      child: Text(n['status'] == 'open' ? 'اقفله (اكتمل)' : 'افتحه تاني'),
                    ),
                  ]),
                ]),
              ),
            ),
        ],
      );
}

// =============================================================== orphans
class _OrphansTab extends StatefulWidget {
  const _OrphansTab({required this.mosqueId});
  final String mosqueId;

  @override
  State<_OrphansTab> createState() => _OrphansTabState();
}

class _OrphansTabState extends State<_OrphansTab> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.orphanPrograms(widget.mosqueId);

  Future<void> _edit([Map<String, dynamic>? o]) async {
    final title = TextEditingController(text: (o?['title'] as String?) ?? 'كفالة طفل');
    final desc = TextEditingController(text: o?['description'] as String?);
    final monthly = TextEditingController(text: o == null ? '' : masjidMoney(o['monthly_amount'] as num?).replaceAll(',', ''));
    final slots = TextEditingController(text: o?['slots']?.toString());
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(o == null ? 'برنامج كفالة جديد' : 'تعديل البرنامج'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFFF4E5), borderRadius: BorderRadius.circular(10)),
              child: const Text('ممنوع تكتب أسماء أو صور أو عناوين أو أي بيانات تعرّف الأطفال. اكتب البرنامج بشكل عام بس (مثلاً: كفالة طفل — 500 ج.م شهرياً).',
                  style: TextStyle(fontSize: 11.5, height: 1.6)),
            ),
            TextField(controller: title, decoration: const InputDecoration(labelText: 'اسم البرنامج')),
            TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'وصف عام (اختياري)')),
            TextField(controller: monthly, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ الشهري (ج.م)')),
            TextField(controller: slots, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'عدد الكفالات المطلوبة (اختياري)')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (ok != true) return;
    final m = looseDouble(monthly.text.trim().replaceAll(',', ''));
    if (m == null || m <= 0) {
      if (mounted) _toast(context, 'اكتب المبلغ الشهري');
      return;
    }
    await run(
      () => MasjidService.saveOrphanProgram(widget.mosqueId, {
        'title': title.text.trim(),
        'description': desc.text.trim().isEmpty ? null : desc.text.trim(),
        'monthly_amount': m,
        'slots': looseInt(slots.text.trim()),
      }, id: o?['id'] as String?),
      done: 'اتحفظ',
    );
  }

  Future<void> _sponsors(Map<String, dynamic> o) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (ctx, c) => _SponsorsList(program: o, controller: c, onChanged: reload),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _ListTab(
        loading: loading,
        error: error,
        onRetry: reload,
        onAdd: _edit,
        addLabel: 'برنامج كفالة جديد',
        children: [
          for (final o in rows)
            Card(
              child: ListTile(
                title: Text('${o['title']} — ${masjidMoney(o['monthly_amount'] as num?)} ج.م شهرياً'),
                subtitle: Text('${o['active_sponsors']} كفيل مؤكد • ${o['pledged_sponsors']} مستني تأكيد${o['status'] == 'closed' ? ' • مقفول' : ''}'),
                onTap: () => _sponsors(o),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') _edit(o);
                    if (v == 'toggle') {
                      run(() => MasjidService.saveOrphanProgram(widget.mosqueId, {'status': o['status'] == 'open' ? 'closed' : 'open'}, id: o['id'] as String));
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    PopupMenuItem(value: 'toggle', child: Text(o['status'] == 'open' ? 'اقفل البرنامج' : 'افتحه تاني')),
                  ],
                ),
              ),
            ),
        ],
      );
}

class _SponsorsList extends StatefulWidget {
  const _SponsorsList({required this.program, this.controller, this.onChanged});
  final Map<String, dynamic> program;
  final ScrollController? controller;
  final VoidCallback? onChanged;

  @override
  State<_SponsorsList> createState() => _SponsorsListState();
}

class _SponsorsListState extends State<_SponsorsList> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.orphanSponsors(widget.program['id'] as String);

  @override
  Widget build(BuildContext context) {
    const labels = {'pledged': 'مستني تأكيد', 'active': 'كفيل مؤكد ✓', 'ended': 'انتهت', 'cancelled': 'اتلغت'};
    return ListView(controller: widget.controller, padding: const EdgeInsets.all(16), children: [
      Text('كفلاء «${widget.program['title']}»', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const Text('بيانات الكفلاء للمتابعة معاهم بس — ماتنشرهاش.', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
      if (loading) const Center(child: CircularProgressIndicator()),
      for (final s in rows)
        Card(
          child: ListTile(
            title: Text('${s['full_name']} — ${masjidMoney(s['monthly_amount'] as num?)} ج.م'),
            subtitle: Text([labels[s['status']] ?? '', if (s['phone'] != null) s['phone'], if (s['note'] != null) s['note']].join(' • ')),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (s['status'] == 'pledged')
                IconButton(
                  tooltip: 'أكّد الكفالة',
                  icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
                  onPressed: () => run(() async {
                    await MasjidService.setSponsorshipStatus(s['id'] as String, 'active');
                    widget.onChanged?.call();
                  }),
                ),
              if (s['status'] == 'pledged' || s['status'] == 'active')
                IconButton(
                  tooltip: 'إنهاء',
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () => run(() async {
                    await MasjidService.setSponsorshipStatus(s['id'] as String, 'ended');
                    widget.onChanged?.call();
                  }),
                ),
            ]),
          ),
        ),
    ]);
  }
}

// ========================================================== competitions
class _CompetitionsTab extends StatefulWidget {
  const _CompetitionsTab({required this.mosqueId});
  final String mosqueId;

  @override
  State<_CompetitionsTab> createState() => _CompetitionsTabState();
}

class _CompetitionsTabState extends State<_CompetitionsTab> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.competitions(widget.mosqueId);

  Future<void> _add() async {
    final title = TextEditingController(text: 'مسابقة حفظ القرآن');
    final desc = TextEditingController();
    final schedule = TextEditingController();
    final deadline = TextEditingController();
    final levels = TextEditingController(text: 'جزء عمّ\nجزء تبارك\n5 أجزاء\nالقرآن كامل');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسابقة جديدة'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'اسم المسابقة')),
            TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'التفاصيل والجوائز (اختياري)')),
            TextField(controller: schedule, maxLines: 2, decoration: const InputDecoration(labelText: 'المواعيد', hintText: 'الاختبارات كل سبت بعد العصر')),
            TextField(controller: deadline, decoration: const InputDecoration(labelText: 'آخر ميعاد للتسجيل (اختياري)', hintText: '2026-11-30')),
            TextField(controller: levels, maxLines: 5, decoration: const InputDecoration(labelText: 'المستويات (كل مستوى في سطر)')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('انشر')),
        ],
      ),
    );
    if (ok != true) return;
    final d = deadline.text.trim();
    if (d.isNotEmpty && DateTime.tryParse(d) == null) {
      if (mounted) _toast(context, 'اكتب التاريخ زي 2026-11-30');
      return;
    }
    await run(() async {
      final id = await MasjidService.saveCompetition(widget.mosqueId, {
        'title': title.text.trim(),
        'description': desc.text.trim().isEmpty ? null : desc.text.trim(),
        'schedule': schedule.text.trim().isEmpty ? null : schedule.text.trim(),
        'registration_deadline': d.isEmpty ? null : d,
      });
      var i = 0;
      for (final l in levels.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty)) {
        await MasjidService.addLevel(id, widget.mosqueId, name: l, sort: i++);
      }
    }, done: 'اتنشرت المسابقة');
  }

  Future<void> _entries(Map<String, dynamic> c) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => _EntriesScreen(competition: c)));
    reload();
  }

  @override
  Widget build(BuildContext context) => _ListTab(
        loading: loading,
        error: error,
        onRetry: reload,
        onAdd: _add,
        addLabel: 'مسابقة جديدة',
        children: [
          for (final c in rows)
            Card(
              child: ListTile(
                title: Text(c['title'] as String? ?? ''),
                subtitle: Text(switch (c['status']) { 'open' => 'التسجيل مفتوح', 'closed' => 'التسجيل مقفول', _ => 'انتهت' } +
                    (c['results_published'] == true ? ' • النتيجة منشورة' : '')),
                onTap: () => _entries(c),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'close') run(() => MasjidService.saveCompetition(widget.mosqueId, {'status': c['status'] == 'open' ? 'closed' : 'open'}, id: c['id'] as String));
                    if (v == 'publish') run(() => MasjidService.publishResults(c['id'] as String, c['results_published'] != true), done: 'تم');
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'close', child: Text(c['status'] == 'open' ? 'اقفل التسجيل' : 'افتح التسجيل')),
                    PopupMenuItem(value: 'publish', child: Text(c['results_published'] == true ? 'اخفي النتيجة' : 'انشر النتيجة')),
                  ],
                ),
              ),
            ),
        ],
      );
}

class _EntriesScreen extends StatefulWidget {
  const _EntriesScreen({required this.competition});
  final Map<String, dynamic> competition;

  @override
  State<_EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<_EntriesScreen> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.entries(widget.competition['id'] as String);

  Future<void> _result(Map<String, dynamic> e) async {
    final score = TextEditingController(text: e['score']?.toString());
    final rank = TextEditingController(text: e['rank']?.toString());
    final note = TextEditingController(text: e['result_note'] as String?);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('نتيجة ${e['contestant_name']}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: score, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الدرجة من 100')),
          TextField(controller: rank, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الترتيب في المستوى')),
          TextField(controller: note, decoration: const InputDecoration(labelText: 'ملاحظة (اختياري)', hintText: 'ممتاز')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (ok != true) return;
    await run(() => MasjidService.setResult(e['id'] as String,
        score: looseDouble(score.text.trim()), rank: looseInt(rank.text.trim()), note: note.text.trim().isEmpty ? null : note.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المتسابقين — ${widget.competition['title']}')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error
              ? LoadErrorView(onRetry: reload)
              : ListView(padding: const EdgeInsets.all(16), children: [
                  Text('${rows.where((r) => r['status'] == 'registered').length} متسابق — اضغط على أي متسابق لتسجيل نتيجته، وبعدين «انشر النتيجة».',
                      style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                  for (final e in rows)
                    Card(
                      child: ListTile(
                        title: Text('${e['contestant_name']}${e['contestant_age'] != null ? ' (${e['contestant_age']} سنة)' : ''}'),
                        subtitle: Text([
                          e['level_name'],
                          if (e['phone'] != null) e['phone'],
                          if (e['registered_by'] != null) 'سجّله ${e['registered_by']}',
                          if (e['status'] == 'withdrawn') 'انسحب',
                        ].join(' • ')),
                        trailing: e['rank'] != null ? CircleAvatar(radius: 14, child: Text('${e['rank']}', style: const TextStyle(fontSize: 12))) : null,
                        onTap: () => _result(e),
                      ),
                    ),
                ]),
    );
  }
}

// ============================================================== settings
class _SettingsTab extends StatefulWidget {
  const _SettingsTab({required this.mosque});
  final Map<String, dynamic> mosque;

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  late final Map<String, TextEditingController> _c;
  bool _busy = false;

  static const _iqama = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  @override
  void initState() {
    super.initState();
    final m = widget.mosque;
    final iq = Map<String, dynamic>.from((m['iqama'] as Map?) ?? const {});
    String? t(Object? v) => v?.toString();
    _c = {
      'address': TextEditingController(text: t(m['address'])),
      'area': TextEditingController(text: t(m['area'])),
      'governorate': TextEditingController(text: t(m['governorate'])),
      'contact_whatsapp': TextEditingController(text: t(m['contact_whatsapp'])),
      'contact_phone': TextEditingController(text: t(m['contact_phone'])),
      'payment_note': TextEditingController(text: t(m['payment_note'])),
      'khatib': TextEditingController(text: t(m['khatib'])),
      'friday_khutba_time': TextEditingController(text: (m['friday_khutba_time'] as String?)?.substring(0, 5)),
      for (final p in _iqama) 'iqama_$p': TextEditingController(text: t(iq[p])),
    };
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final khutba = _c['friday_khutba_time']!.text.trim();
    if (khutba.isNotEmpty && !RegExp(r'^\d{1,2}:\d{2}$').hasMatch(khutba)) {
      _toast(context, 'اكتب ميعاد الخطبة زي 12:30');
      return;
    }
    setState(() => _busy = true);
    try {
      await MasjidService.updateSettings(widget.mosque['id'] as String, {for (final e in _c.entries) e.key: e.value.text.trim()});
      if (mounted) _toast(context, 'اتحفظ');
    } catch (e) {
      if (mounted) _toast(context, masjidError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _f(String key, String label, {String? hint, TextInputType? type}) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextField(controller: _c[key], keyboardType: type, decoration: InputDecoration(labelText: label, hintText: hint)),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('الإقامة بعد الأذان بكام دقيقة', style: TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Row(children: [
        for (final p in _iqama)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: TextField(
                controller: _c['iqama_$p'],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(labelText: prayerNames[Prayer.values.byName(p)], hintText: '15'),
              ),
            ),
          ),
      ]),
      const SizedBox(height: 14),
      const Text('خطبة الجمعة', style: TextStyle(fontWeight: FontWeight.w800)),
      _f('friday_khutba_time', 'ميعاد الخطبة (24 ساعة)', hint: '12:30'),
      _f('khatib', 'الخطيب', hint: 'الشيخ محمود'),
      const SizedBox(height: 6),
      const Text('التواصل والدفع', style: TextStyle(fontWeight: FontWeight.w800)),
      _f('contact_whatsapp', 'واتساب المسجد', hint: '01xxxxxxxxx', type: TextInputType.phone),
      _f('contact_phone', 'تليفون المسجد (اختياري)', type: TextInputType.phone),
      _f('payment_note', 'إزاي الناس تساهم؟', hint: 'سلّم لأمين المسجد بعد العشاء، أو فودافون كاش على رقم الواتساب'),
      const NoMoneyNote(extra: 'الرقم والطريقة دول بيظهروا للناس في صفحة المسجد.'),
      const SizedBox(height: 10),
      const Text('العنوان', style: TextStyle(fontWeight: FontWeight.w800)),
      _f('address', 'العنوان'),
      _f('area', 'المنطقة / الحي'),
      _f('governorate', 'المحافظة'),
      const SizedBox(height: 10),
      ElevatedButton(onPressed: _busy ? null : _save, child: Text(_busy ? 'جارٍ الحفظ…' : 'حفظ')),
    ]);
  }
}

// ================================================================== team
class _TeamTab extends StatefulWidget {
  const _TeamTab({required this.mosqueId});
  final String mosqueId;

  @override
  State<_TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<_TeamTab> with _Loader {
  @override
  Future<List<Map<String, dynamic>>> fetch() => MasjidService.team(widget.mosqueId);

  Future<void> _add() async {
    final phone = TextEditingController();
    final title = TextEditingController();
    final perms = <String>{'posts', 'lessons'};
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('ضيف مساعد'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'موبايله المسجّل على مُجتمعي', hintText: '01xxxxxxxxx')),
              TextField(controller: title, decoration: const InputDecoration(labelText: 'صفته (اختياري)', hintText: 'مؤذن، محفّظ، عضو مجلس')),
              const SizedBox(height: 8),
              const Text('الصلاحيات', style: TextStyle(fontSize: 12)),
              Wrap(spacing: 4, runSpacing: 4, children: [
                for (final e in MasjidService.permissionLabels.entries)
                  FilterChip(
                    label: Text(e.value, style: const TextStyle(fontSize: 11)),
                    selected: perms.contains(e.key),
                    onSelected: (v) => set(() => v ? perms.add(e.key) : perms.remove(e.key)),
                  ),
              ]),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('ضيف')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await run(() async {
      final name = await MasjidService.addHelper(widget.mosqueId, phone: phone.text.trim(), permissions: perms.toList(), title: title.text.trim());
      if (mounted) _toast(context, 'اتضاف $name للفريق');
    });
  }

  @override
  Widget build(BuildContext context) => _ListTab(
        loading: loading,
        error: error,
        onRetry: reload,
        onAdd: _add,
        addLabel: 'ضيف مساعد',
        children: [
          for (final a in rows)
            Card(
              child: ListTile(
                leading: Icon(a['role'] == 'owner' ? Icons.verified_user_rounded : Icons.person_outline_rounded, color: AppColors.crystal),
                title: Text('${a['full_name']}${a['title'] != null ? ' — ${a['title']}' : ''}'),
                subtitle: Text(a['role'] == 'owner'
                    ? 'مسؤول أساسي (كل الصلاحيات)'
                    : ((a['permissions'] as List?) ?? const []).map((p) => MasjidService.permissionLabels[p] ?? p).join('، ')),
                trailing: a['role'] == 'owner'
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.person_remove_outlined),
                        onPressed: () async {
                          if (await _confirm(context, 'تشيل ${a['full_name']} من الفريق؟')) {
                            run(() => MasjidService.removeHelper(widget.mosqueId, a['user_id'] as String));
                          }
                        },
                      ),
              ),
            ),
        ],
      );
}
