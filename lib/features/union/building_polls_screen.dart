import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/polls_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';

String _errorText(Object e, String fallback) => e is PostgrestException ? e.message : fallback;

String _endsLabel(DateTime endsAt, bool open) {
  final local = endsAt.toLocal();
  final date = '${local.year}/${local.month}/${local.day} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  if (!open) return 'انتهى التصويت';
  final left = endsAt.difference(DateTime.now().toUtc());
  if (left.inDays >= 1) return 'باقي ${left.inDays} يوم • يقفل $date';
  if (left.inHours >= 1) return 'باقي ${left.inHours} ساعة • يقفل $date';
  return 'باقي ${left.inMinutes.clamp(1, 59)} دقيقة • يقفل $date';
}

/// «تصويت السكان»: the president/board ask the building a question; every
/// apartment gets one vote (the first household member to vote casts it).
/// Results — counts per option and turnout — are shown to all members.
class BuildingPollsScreen extends StatefulWidget {
  const BuildingPollsScreen({super.key});

  @override
  State<BuildingPollsScreen> createState() => _BuildingPollsScreenState();
}

class _BuildingPollsScreenState extends State<BuildingPollsScreen> {
  bool _loading = true;
  bool _loadError = false;
  String? _buildingId;
  bool _isBoard = false;
  bool _hasUnit = false;
  List<Map<String, dynamic>> _polls = [];
  String? _busyPollId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final membership = await UnionService.fetchMyMembership();
      final verified = membership?['status'] == 'verified';
      final buildingId = verified ? membership!['building_id'] as String? : null;
      final polls = buildingId == null ? <Map<String, dynamic>>[] : await PollsService.fetchPolls(buildingId);
      if (!mounted) return;
      setState(() {
        _buildingId = buildingId;
        _isBoard = verified && const ['president', 'board_member'].contains(membership!['role']);
        _hasUnit = membership?['unit_id'] != null;
        _polls = polls;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  Future<void> _vote(Map<String, dynamic> poll, int option) async {
    final options = List<String>.from(poll['options'] as List);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد صوت الشقة'),
        content: Text('هتصوّت بـ «${options[option]}».\n\nده صوت شقتكم كلها: لو حد تاني من البيت فاتح التطبيق مش هيقدر يصوّت تاني، ومينفعش تغيّر الصوت بعد كده.',
            style: const TextStyle(height: 1.7)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('رجوع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('صوّت')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busyPollId = poll['id'] as String);
    try {
      await PollsService.vote(pollId: poll['id'] as String, option: option);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل صوت شقتك ✓')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText(e, 'تعذر تسجيل الصوت، حاول تاني'))));
    } finally {
      if (mounted) setState(() => _busyPollId = null);
      _load();
    }
  }

  Future<void> _close(Map<String, dynamic> poll) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قفل التصويت دلوقتي؟'),
        content: const Text('محدش هيقدر يصوّت بعد كده، والنتيجة الحالية هتبقى النهائية.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('رجوع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('اقفل التصويت')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await PollsService.closePoll(poll['id'] as String);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText(e, 'تعذر قفل التصويت'))));
    }
    _load();
  }

  Future<void> _create() async {
    final buildingId = _buildingId;
    if (buildingId == null) return;
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _NewPollSheet(buildingId: buildingId),
    );
    if (created == true) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('التصويت اتفتح وجيرانك وصلهم إشعار')));
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) return const AuthLandingScreen();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تصويت السكان')),
      floatingActionButton: _isBoard && _buildingId != null
          ? FloatingActionButton.extended(
              onPressed: _create,
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('تصويت جديد'),
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError
              ? LoadErrorView(onRetry: _load)
              : _buildingId == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('التصويت لسكان العمارة الموثّقين بس — انضم لعمارتك الأول',
                            textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                            child: const Row(children: [
                              Icon(Icons.how_to_vote_outlined, size: 18, color: AppColors.inkSecondary),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text('كل شقة ليها صوت واحد: أول حد من البيت يصوّت بيصوّت باسم الشقة كلها.',
                                    style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.6)),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 14),
                          if (_polls.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                _isBoard ? 'مفيش تصويتات لسه — اعمل أول تصويت لجيرانك من الزرار تحت' : 'مفيش تصويتات لسه، أول ما المجلس يفتح تصويت هيوصلك إشعار',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
                              ),
                            )
                          else
                            for (final p in _polls) ...[
                              _PollCard(
                                poll: p,
                                canVote: _hasUnit,
                                busy: _busyPollId == p['id'],
                                isBoard: _isBoard,
                                onVote: (i) => _vote(p, i),
                                onClose: () => _close(p),
                              ),
                              const SizedBox(height: 14),
                            ],
                        ],
                      ),
                    ),
    );
  }
}

class _PollCard extends StatelessWidget {
  const _PollCard({required this.poll, required this.canVote, required this.busy, required this.isBoard, required this.onVote, required this.onClose});
  final Map<String, dynamic> poll;
  final bool canVote, busy, isBoard;
  final ValueChanged<int> onVote;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(poll['options'] as List? ?? const []);
    final counts = List<int>.from((poll['counts'] as List? ?? const []).map((c) => (c as num).toInt()));
    final open = poll['is_open'] == true;
    final unitChoice = (poll['my_unit_choice'] as num?)?.toInt();
    final votedByMe = poll['voted_by_me'] == true;
    final unitsVoted = (poll['units_voted'] as num?)?.toInt() ?? 0;
    final totalUnits = (poll['total_units'] as num?)?.toInt() ?? 0;
    final totalVotes = counts.fold<int>(0, (a, b) => a + b);
    final endsAt = DateTime.tryParse(poll['ends_at'] as String? ?? '') ?? DateTime.now();
    final canTap = open && unitChoice == null && canVote && !busy;
    final maxVotes = counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: open ? AppColors.teal.withValues(alpha: 0.35) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: open ? AppColors.success.withValues(alpha: 0.12) : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(open ? 'مفتوح' : 'مقفول',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: open ? AppColors.success : AppColors.inkMuted)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(_endsLabel(endsAt, open), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
          ]),
          const SizedBox(height: 10),
          Text(poll['question'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, height: 1.5)),
          if ((poll['created_by_name'] as String?)?.isNotEmpty == true)
            Text('من: ${poll['created_by_name']}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 12),
          for (var i = 0; i < options.length; i++) ...[
            _OptionRow(
              label: options[i],
              votes: i < counts.length ? counts[i] : 0,
              total: totalVotes,
              chosen: unitChoice == i,
              leading: !open && totalVotes > 0 && i < counts.length && counts[i] == maxVotes,
              onTap: canTap ? () => onVote(i) : null,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 2),
          Text(
            'المشاركة: $unitsVoted من $totalUnits شقة${totalUnits > 0 ? ' (${(unitsVoted * 100 / totalUnits).round()}%)' : ''}',
            style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          if (busy)
            const LinearProgressIndicator(minHeight: 2)
          else if (unitChoice != null)
            Row(children: [
              const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Expanded(
                child: Text(votedByMe ? 'صوّتّ باسم شقتك ✓' : 'شقتكم صوّتت ✓ (حد تاني من البيت صوّت قبلك)',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.success, fontWeight: FontWeight.w700)),
              ),
            ])
          else if (open && !canVote)
            const Text('حسابك مش مربوط بشقة، فمينفعش تصوّت', style: TextStyle(fontSize: 11, color: AppColors.inkMuted))
          else if (open)
            const Text('اضغط على اختيار عشان تصوّت باسم شقتك', style: TextStyle(fontSize: 11, color: AppColors.teal)),
          if (isBoard && open) ...[
            const SizedBox(height: 6),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onClose,
                icon: const Icon(Icons.lock_outline_rounded, size: 16),
                label: const Text('اقفل التصويت', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.label, required this.votes, required this.total, required this.chosen, required this.leading, this.onTap});
  final String label;
  final int votes, total;
  final bool chosen, leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final share = total > 0 ? votes / total : 0.0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: chosen ? AppColors.teal.withValues(alpha: 0.08) : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: chosen ? AppColors.teal : (onTap != null ? AppColors.teal.withValues(alpha: 0.25) : Colors.transparent)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              if (onTap != null) ...[
                const Icon(Icons.radio_button_unchecked_rounded, size: 16, color: AppColors.teal),
                const SizedBox(width: 6),
              ] else if (chosen) ...[
                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.teal),
                const SizedBox(width: 6),
              ],
              Expanded(child: Text(label, style: TextStyle(fontSize: 12.5, fontWeight: chosen || leading ? FontWeight.w800 : FontWeight.w600))),
              if (leading) const Padding(padding: EdgeInsetsDirectional.only(end: 6), child: Icon(Icons.emoji_events_rounded, size: 15, color: AppColors.gold)),
              Text('$votes صوت • ${(share * 100).round()}%', style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: share,
                minHeight: 6,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(chosen ? AppColors.teal : AppColors.sky),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewPollSheet extends StatefulWidget {
  const _NewPollSheet({required this.buildingId});
  final String buildingId;

  @override
  State<_NewPollSheet> createState() => _NewPollSheetState();
}

class _NewPollSheetState extends State<_NewPollSheet> {
  static const _durations = [('يوم', Duration(days: 1)), ('3 أيام', Duration(days: 3)), ('أسبوع', Duration(days: 7)), ('أسبوعين', Duration(days: 14))];

  final _question = TextEditingController();
  final List<TextEditingController> _options = [TextEditingController(), TextEditingController()];
  int _duration = 1;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _question.dispose();
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final question = _question.text.trim();
    final options = [for (final c in _options) if (c.text.trim().isNotEmpty) c.text.trim()];
    if (question.length < 3) {
      setState(() => _error = 'اكتب سؤال التصويت');
      return;
    }
    if (options.length < 2) {
      setState(() => _error = 'محتاج اختيارين على الأقل');
      return;
    }
    if (options.toSet().length != options.length) {
      setState(() => _error = 'فيه اختيارين متكررين');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await PollsService.createPoll(
        buildingId: widget.buildingId,
        question: question,
        options: options,
        endsAt: DateTime.now().add(_durations[_duration].$2),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = _errorText(e, 'تعذر فتح التصويت، حاول تاني'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('تصويت جديد للسكان', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('كل شقة ليها صوت واحد، وكل الأعضاء هيوصلهم إشعار.', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
            const SizedBox(height: 12),
            TextField(controller: _question, maxLength: 300, decoration: const InputDecoration(labelText: 'السؤال', hintText: 'مثلاً: نطلي السلم بأي لون؟')),
            const SizedBox(height: 4),
            for (var i = 0; i < _options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _options[i],
                      maxLength: 100,
                      decoration: InputDecoration(labelText: 'اختيار ${i + 1}', counterText: ''),
                    ),
                  ),
                  if (_options.length > 2)
                    IconButton(
                      tooltip: 'شيل الاختيار',
                      onPressed: () => setState(() => _options.removeAt(i).dispose()),
                      icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.inkMuted),
                    ),
                ]),
              ),
            if (_options.length < 6)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => setState(() => _options.add(TextEditingController())),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('ضيف اختيار'),
                ),
              ),
            const SizedBox(height: 6),
            const Text('التصويت يفضل مفتوح', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: [
              for (var i = 0; i < _durations.length; i++)
                ChoiceChip(label: Text(_durations[i].$1), selected: _duration == i, onSelected: (_) => setState(() => _duration = i)),
            ]),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ],
            const SizedBox(height: 14),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('افتح التصويت وابعت إشعار', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
