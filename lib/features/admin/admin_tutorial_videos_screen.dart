import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/tutorials/tutorial_service.dart';
import '../tutorials/tutorial_widgets.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// «فيديوهات الشرح» — the platform admin manages the YouTube Shorts shown
/// in each app (backend/migrations/0079; writes are RLS-gated on
/// is_super_admin()).
class AdminTutorialVideosScreen extends StatefulWidget {
  const AdminTutorialVideosScreen({super.key});

  @override
  State<AdminTutorialVideosScreen> createState() => _AdminTutorialVideosScreenState();
}

class _AdminTutorialVideosScreenState extends State<AdminTutorialVideosScreen> {
  String _app = currentTutorialApp;
  List<TutorialVideo> _videos = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final v = await TutorialService.adminList(_app);
      if (mounted) setState(() => _videos = v);
    } catch (e) {
      if (mounted) setState(() => _error = 'تعذّر تحميل الفيديوهات: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _run(Future<void> Function() action, {String? done}) async {
    try {
      await action();
      if (done != null && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حصلت مشكلة: $e')));
    }
    await _load();
  }

  Future<void> _edit([TutorialVideo? video]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _VideoEditorDialog(video: video, app: _app, nextSort: _videos.isEmpty ? 10 : _videos.last.sort + 10),
    );
    if (saved == true) await _load();
  }

  /// Moves a video one step and renumbers the list 10, 20, 30…
  Future<void> _move(int index, int delta) async {
    final target = index + delta;
    if (target < 0 || target >= _videos.length) return;
    final list = [..._videos];
    final v = list.removeAt(index);
    list.insert(target, v);
    await _run(() async {
      for (var i = 0; i < list.length; i++) {
        final sort = (i + 1) * 10;
        if (list[i].sort != sort) await TutorialService.setSort(list[i].id, sort);
      }
    });
  }

  Future<void> _delete(TutorialVideo v) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الفيديو؟'),
        content: Text('«${v.title}» هيختفي من التطبيق. لو عايز تخفيه مؤقتاً اقفل «ظاهر» بدل الحذف.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('احذف')),
        ],
      ),
    );
    if (ok == true) await _run(() => TutorialService.delete(v.id), done: 'اتحذف');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('فيديوهات الشرح')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('فيديو جديد'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            SegmentedButton<String>(
              segments: [for (final e in tutorialApps.entries) ButtonSegment(value: e.key, label: Text(e.value))],
              selected: {_app},
              showSelectedIcon: false,
              onSelectionChanged: (s) {
                setState(() => _app = s.first);
                _load();
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'الصق لينك يوتيوب (Shorts أو عادي) أو الـID بتاع الفيديو. الترتيب بالأسهم، و«ظاهر» بيخفي أو يظهر الفيديو من غير ما يتمسح. '
              'الفيديو اللي ليه «شاشة» بيظهر كزرار «شوف الشرح» في الشاشة دي.',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              Padding(padding: const EdgeInsets.all(24), child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted)))
            else if (_videos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text('مفيش فيديوهات للتطبيق ده لسه. دوس «فيديو جديد».', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
              )
            else
              for (var i = 0; i < _videos.length; i++) _tile(i, _videos[i]),
          ],
        ),
      ),
    );
  }

  Widget _tile(int i, TutorialVideo v) {
    final screen = v.screenKey == null ? null : (tutorialScreenKeys[v.screenKey] ?? v.screenKey);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          SizedBox(
            width: 92,
            height: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(onTap: () => showTutorialPlayer(context, v), child: TutorialThumbnail(youtubeId: v.youtubeId)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: v.isActive ? AppColors.ink : AppColors.inkMuted)),
              const SizedBox(height: 2),
              Text(
                [ 'ترتيب ${v.sort}', if (screen != null) 'شاشة: $screen', v.youtubeId].join(' · '),
                style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
              ),
              Row(children: [
                const Text('ظاهر', style: TextStyle(fontSize: 11.5)),
                Switch(value: v.isActive, onChanged: (a) => _run(() => TutorialService.setActive(v.id, a))),
              ]),
            ]),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            IconButton(tooltip: 'لفوق', visualDensity: VisualDensity.compact, icon: const Icon(Icons.arrow_upward_rounded), onPressed: i == 0 ? null : () => _move(i, -1)),
            IconButton(tooltip: 'لتحت', visualDensity: VisualDensity.compact, icon: const Icon(Icons.arrow_downward_rounded), onPressed: i == _videos.length - 1 ? null : () => _move(i, 1)),
          ]),
          PopupMenuButton<String>(
            onSelected: (a) => a == 'edit' ? _edit(v) : _delete(v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('تعديل')),
              PopupMenuItem(value: 'delete', child: Text('حذف')),
            ],
          ),
        ]),
      ),
    );
  }
}

class _VideoEditorDialog extends StatefulWidget {
  const _VideoEditorDialog({required this.video, required this.app, required this.nextSort});
  final TutorialVideo? video;
  final String app;
  final int nextSort;

  @override
  State<_VideoEditorDialog> createState() => _VideoEditorDialogState();
}

class _VideoEditorDialogState extends State<_VideoEditorDialog> {
  static const _none = '';
  static const _other = '__other__';

  late final _link = TextEditingController(text: widget.video?.youtubeId ?? '');
  late final _title = TextEditingController(text: widget.video?.title ?? '');
  late final _sort = TextEditingController(text: '${widget.video?.sort ?? widget.nextSort}');
  late final _customKey = TextEditingController();
  late String _app = widget.video?.app ?? widget.app;
  late String _screen;
  late bool _active = widget.video?.isActive ?? true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final key = widget.video?.screenKey;
    if (key == null) {
      _screen = _none;
    } else if (tutorialScreenKeys.containsKey(key)) {
      _screen = key;
    } else {
      _screen = _other;
      _customKey.text = key;
    }
  }

  @override
  void dispose() {
    _link.dispose();
    _title.dispose();
    _sort.dispose();
    _customKey.dispose();
    super.dispose();
  }

  String? get _youtubeId => extractYoutubeId(_link.text);

  Future<void> _save() async {
    final id = _youtubeId;
    final title = _title.text.trim();
    final key = _screen == _other ? _customKey.text.trim() : (_screen == _none ? null : _screen);
    String? err;
    if (id == null) {
      err = 'اللينك أو الـID مش صحيح';
    } else if (title.isEmpty || title.length > 80) {
      err = 'العنوان لازم يكون من 1 لـ 80 حرف';
    } else if (key != null && key.isNotEmpty && !isValidScreenKey(key)) {
      err = 'مفتاح الشاشة: حروف إنجليزي صغيرة وأرقام و _ بس، ويبدأ بحرف';
    }
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await TutorialService.save(
        id: widget.video?.id,
        app: _app,
        youtubeId: id!,
        title: title,
        sort: looseInt(_sort.text.trim()) ?? 0,
        screenKey: key,
        isActive: _active,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = 'تعذّر الحفظ: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = _youtubeId;
    return AlertDialog(
      title: Text(widget.video == null ? 'فيديو شرح جديد' : 'تعديل الفيديو'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextField(
              controller: _link,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(labelText: 'لينك يوتيوب أو الـID', hintText: 'https://youtube.com/shorts/…'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            if (id != null)
              Row(children: [
                SizedBox(width: 120, height: 80, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: TutorialThumbnail(youtubeId: id))),
                const SizedBox(width: 10),
                Expanded(child: Text('ID: $id', textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary))),
              ])
            else if (_link.text.trim().isNotEmpty)
              const Text('مش لاقي ID فيديو في اللينك ده', style: TextStyle(fontSize: 12, color: AppColors.categorySos)),
            const SizedBox(height: 10),
            TextField(controller: _title, maxLength: 80, decoration: const InputDecoration(labelText: 'العنوان')),
            DropdownButtonFormField<String>(
              initialValue: _app,
              decoration: const InputDecoration(labelText: 'التطبيق'),
              items: [for (final e in tutorialApps.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
              onChanged: (v) => setState(() => _app = v ?? _app),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _screen,
              decoration: const InputDecoration(labelText: 'زرار «شوف الشرح» في شاشة'),
              items: [
                const DropdownMenuItem(value: _none, child: Text('ولا شاشة (في القائمة بس)')),
                for (final e in tutorialScreenKeys.entries) DropdownMenuItem(value: e.key, child: Text('${e.value} (${e.key})')),
                const DropdownMenuItem(value: _other, child: Text('مفتاح تاني (اكتبه)')),
              ],
              onChanged: (v) => setState(() => _screen = v ?? _none),
            ),
            if (_screen == _other)
              TextField(
                controller: _customKey,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'مفتاح الشاشة', hintText: 'add_product'),
              ),
            const SizedBox(height: 8),
            TextField(controller: _sort, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الترتيب (الأصغر الأول)')),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _active,
              onChanged: (v) => setState(() => _active = v),
              title: const Text('ظاهر للناس'),
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: AppColors.categorySos, fontSize: 12)),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(false), child: const Text('تراجع')),
        ElevatedButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'بيتحفظ…' : 'حفظ')),
      ],
    );
  }
}
