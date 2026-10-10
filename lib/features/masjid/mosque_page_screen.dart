import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maps/maps_launcher.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import '../tutorials/tutorial_widgets.dart';
import '../../core/masjid/masjid_community.dart';
import 'claim_mosque_screen.dart';
import 'masjid_community_widgets.dart';
import 'masjid_live_widgets.dart';
import 'masjid_widgets.dart';
import 'mosque_chat_nickname.dart';
import 'mosque_manage_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// صفحة المسجد (`/masjid/<id>`): prayer times with the mosque's iqama,
/// Friday khutba, announcements, lessons & Quran circles, needs (pledges,
/// confirmed progress), orphan sponsorship programs, Quran competitions,
/// «انضم للمسجد» (members + «شات المسجد», 0081), «تابع المسجد», sharing
/// and inviting the imam / neighbours. Admins get «إدارة المسجد».
class MosquePageScreen extends StatefulWidget {
  const MosquePageScreen({super.key, required this.mosqueId});
  final String mosqueId;

  @override
  State<MosquePageScreen> createState() => _MosquePageScreenState();
}

class _MosquePageScreenState extends State<MosquePageScreen> {
  Map<String, dynamic>? _m;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _lessons = [];
  List<Map<String, dynamic>> _needs = [];
  List<Map<String, dynamic>> _orphans = [];
  List<Map<String, dynamic>> _comps = [];
  List<Map<String, dynamic>> _live = [];
  Map<String, Map<String, dynamic>> _compCounts = {};
  bool _loading = true;
  bool _error = false;
  bool _followBusy = false;
  bool _joinBusy = false;

  String get _id => widget.mosqueId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _m == null;
      _error = false;
    });
    try {
      final m = await MasjidService.get(_id);
      final results = await Future.wait([
        MasjidService.posts(_id),
        MasjidService.lessons(_id),
        MasjidService.needs(_id),
        MasjidService.orphanPrograms(_id),
        MasjidService.competitions(_id),
      ]);
      final counts = await MasjidService.competitionCounts(_id);
      // «دروس أونلاين» (0085) — never blocks the page.
      final live = await MasjidService.liveSessions(_id).catchError((_) => <Map<String, dynamic>>[]);
      if (!mounted) return;
      setState(() {
        _m = m;
        _posts = results[0];
        _lessons = results[1];
        _needs = results[2];
        _orphans = results[3];
        _comps = results[4];
        _compCounts = counts;
        _live = live;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  List<String> get _perms => ((_m?['my_permissions'] as List?) ?? const []).cast<String>();
  bool _can(String p) => _perms.contains(p);

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<bool> _ensureSignedIn() async {
    if (AuthService.isSignedIn) return true;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    return AuthService.isSignedIn;
  }

  Future<void> _toggleFollow() async {
    if (!await _ensureSignedIn() || !mounted) return;
    final following = _m?['is_following'] == true;
    setState(() => _followBusy = true);
    try {
      await MasjidService.follow(_id, follow: !following);
      _toast(following ? 'لغيت متابعة المسجد' : 'هيوصلك كل جديد من المسجد 🔔');
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _followBusy = false);
    }
  }

  Future<void> _toggleJoin() async {
    if (!await _ensureSignedIn() || !mounted) return;
    final member = _m?['is_member'] == true;
    if (member) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('تخرج من المسجد؟'),
          content: const Text('مش هتقدر تشوف شات المسجد أو تكتب فيه، ومش هيوصلك جديده.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('لأ')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('اخرج')),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _joinBusy = true);
    try {
      if (member) {
        await MasjidService.leave(_id);
        _toast('خرجت من المسجد');
      } else {
        await MasjidService.join(_id);
        _toast('أهلاً بيك — بقيت عضو في المسجد وهيوصلك كل جديد 🤍');
      }
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _joinBusy = false);
    }
  }

  Future<void> _makePrimary() async {
    try {
      await MasjidService.setPrimary(_id);
      _toast('بقى مسجدك الأساسي');
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    }
  }

  Future<void> _openChat() async {
    await openMosqueChat(context, _id, _m?['name'] as String?);
    _load();
  }

  Future<void> _setNotify(bool on) async {
    try {
      await MasjidService.follow(_id, follow: true, notify: on);
      await _load();
    } catch (e) {
      _toast(masjidError(e));
    }
  }

  Future<void> _share() async {
    final url = MasjidService.shareUrl(_id);
    final text = '${_m?['name']} على مسجدي — مواقيت الصلاة والدروس والإعلانات:\n$url';
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(leading: Icon(Icons.check_circle_rounded, color: AppColors.teal), title: Text('اتنسخ لينك المسجد')),
          ListTile(
            leading: const Icon(Icons.chat_rounded, color: Color(0xFF1FA855)),
            title: const Text('ابعته على واتساب'),
            onTap: () {
              Navigator.pop(ctx);
              launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _claim() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClaimMosqueScreen(mosqueId: _id, mosqueName: _m?['name'] as String? ?? '')));
    _load();
  }

  Future<void> _manage() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => MosqueManageScreen(mosque: _m!)));
    _load();
  }

  // ------------------------------------------------------------- needs
  Future<void> _pledge(Map<String, dynamic> need) async {
    if (!await _ensureSignedIn() || !mounted) return;
    final amount = TextEditingController();
    final note = TextEditingController();
    var anonymous = false;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.viewInsetsOf(ctx).bottom + 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('هساهم في «${need['title']}»', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Text('أي مبلغ يفرق — ${needProgressText(need['confirmed_amount'] as num? ?? 0, need['target_amount'] as num? ?? 0)}',
                style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
            const SizedBox(height: 12),
            TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'هساهم بـ (ج.م)', hintText: '200')),
            const SizedBox(height: 10),
            TextField(controller: note, decoration: const InputDecoration(labelText: 'ملاحظة للمسجد (اختياري)', hintText: 'هسلّمها بعد صلاة الجمعة')),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('من غير اسمي (فاعل خير)'),
              subtitle: const Text('اسمك هيظهر لإدارة المسجد بس', style: TextStyle(fontSize: 11.5)),
              value: anonymous,
              onChanged: (v) => setSheet(() => anonymous = v),
            ),
            const NoMoneyNote(extra: 'سجّل تعهدك هنا، وادفع للمسجد بالطريقة المكتوبة تحت.'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('سجّل مساهمتي')),
          ]),
        ),
      ),
    );
    if (ok != true) return;
    final value = looseDouble(amount.text.trim().replaceAll(',', ''));
    if (value == null || value < 1) return _toast('اكتب مبلغ صحيح');
    try {
      await MasjidService.pledge(need['id'] as String, value, note: note.text.trim().isEmpty ? null : note.text.trim(), anonymous: anonymous);
      _toast('جزاك الله خيراً — مساهمتك اتسجلت، وهتتحسب لما المسجد يأكد استلامها');
      _load();
    } catch (e) {
      _toast(masjidError(e));
    }
  }

  Future<void> _showContributions(Map<String, dynamic> need) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (ctx, controller) => ContributionsList(need: need, canManage: _can('needs'), controller: controller, onChanged: _load),
      ),
    );
  }

  // ----------------------------------------------------------- orphans
  Future<void> _sponsor(Map<String, dynamic> program) async {
    if (!await _ensureSignedIn() || !mounted) return;
    final amount = TextEditingController(text: masjidMoney(program['monthly_amount'] as num?).replaceAll(',', ''));
    final note = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('هكفل — ${program['title']}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ الشهري (ج.م)')),
          TextField(controller: note, decoration: const InputDecoration(labelText: 'ملاحظة (اختياري)')),
          const SizedBox(height: 10),
          const NoMoneyNote(extra: 'إدارة المسجد هتتواصل معاك وتأكد الكفالة.'),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('سجّلني كفيل')),
        ],
      ),
    );
    if (ok != true) return;
    final value = looseDouble(amount.text.trim().replaceAll(',', ''));
    if (value == null || value < 1) return _toast('اكتب مبلغ صحيح');
    try {
      await MasjidService.sponsor(program['id'] as String, value, note: note.text.trim().isEmpty ? null : note.text.trim());
      _toast('جزاك الله خيراً — طلب الكفالة وصل للمسجد');
      _load();
    } catch (e) {
      _toast(masjidError(e));
    }
  }

  // ------------------------------------------------------ competitions
  Future<void> _register(Map<String, dynamic> comp) async {
    if (!await _ensureSignedIn() || !mounted) return;
    final levels = ((comp['mosque_competition_levels'] as List?) ?? const []).map((e) => Map<String, dynamic>.from(e as Map)).toList()
      ..sort((a, b) => ((a['sort'] as num?) ?? 0).compareTo((b['sort'] as num?) ?? 0));
    if (levels.isEmpty) return _toast('المسابقة لسه مالهاش مستويات');
    final name = TextEditingController();
    final age = TextEditingController();
    final phone = TextEditingController();
    String level = levels.first['id'] as String;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.viewInsetsOf(ctx).bottom + 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('سجّل في «${comp['title']}»', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: level,
              decoration: const InputDecoration(labelText: 'المستوى'),
              items: [
                for (final l in levels)
                  DropdownMenuItem(value: l['id'] as String, child: Text([l['name'], if (l['age_group'] != null) l['age_group']].join(' — '))),
              ],
              onChanged: (v) => setSheet(() => level = v ?? level),
            ),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المتسابق')),
            TextField(controller: age, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السن (اختياري)')),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'موبايل للتواصل (اختياري)')),
            const SizedBox(height: 6),
            const Text('الموبايل بيظهر لإدارة المسجد بس. اسم المتسابق ممكن يظهر في النتيجة لما تتعلن.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('سجّل')),
          ]),
        ),
      ),
    );
    if (ok != true) return;
    try {
      await MasjidService.register(comp['id'] as String, level,
          name: name.text.trim(), age: looseInt(age.text.trim()), phone: phone.text.trim().isEmpty ? null : phone.text.trim());
      _toast('اتسجّل — ربنا يوفقه 🤲');
      _load();
    } catch (e) {
      _toast(masjidError(e));
    }
  }

  Future<void> _showResults(Map<String, dynamic> comp) async {
    List<Map<String, dynamic>> rows = [];
    try {
      rows = await MasjidService.results(comp['id'] as String);
    } catch (_) {}
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(16), children: [
          Text('نتيجة «${comp['title']}»', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 8),
          if (rows.isEmpty) const Text('لسه مفيش نتايج.'),
          for (final r in rows)
            ListTile(
              dense: true,
              leading: CircleAvatar(radius: 14, backgroundColor: AppColors.gold, child: Text('${r['rank']}', style: const TextStyle(color: AppColors.night, fontSize: 12))),
              title: Text(r['contestant_name'] as String? ?? ''),
              subtitle: Text([r['level_name'], if (r['score'] != null) 'الدرجة ${r['score']}', if (r['result_note'] != null) r['result_note']].join(' • ')),
            ),
        ]),
      ),
    );
  }

  Future<void> _myEntries(Map<String, dynamic> comp) async {
    List<Map<String, dynamic>> rows = [];
    try {
      rows = await MasjidService.entries(comp['id'] as String);
    } catch (_) {}
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(16), children: [
          const Text('تسجيلاتي', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          for (final r in rows.where((r) => r['is_mine'] == true))
            ListTile(
              title: Text(r['contestant_name'] as String? ?? ''),
              subtitle: Text('${r['level_name']}${r['status'] == 'withdrawn' ? ' — انسحب' : ''}'),
              trailing: r['status'] == 'registered' && comp['status'] == 'open'
                  ? TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        try {
                          await MasjidService.withdraw(r['id'] as String);
                          _load();
                        } catch (e) {
                          _toast(masjidError(e));
                        }
                      },
                      child: const Text('إلغاء'))
                  : null,
            ),
        ]),
      ),
    );
  }

  // --------------------------------------------------------------- UI
  Widget _section(String title, IconData icon, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(icon, color: AppColors.crystal, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ]),
        const SizedBox(height: 8),
        ...children,
      ]),
    );
  }

  Widget _card({required Widget child, Color? color}) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color ?? AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final m = _m;
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(m?['name'] as String? ?? 'المسجد'),
        actions: [
          if (m != null) IconButton(onPressed: _share, icon: const Icon(Icons.share_rounded), tooltip: 'شارك'),
          if (_perms.isNotEmpty) IconButton(onPressed: _manage, icon: const Icon(Icons.admin_panel_settings_rounded), tooltip: 'إدارة المسجد'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل صفحة المسجد')
              : m == null
                  ? const Center(child: Text('المسجد ده مش موجود'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(padding: EdgeInsets.fromLTRB(side, 12, side, 40), children: _body(m)),
                    ),
    );
  }

  List<Widget> _body(Map<String, dynamic> m) {
    final lat = (m['lat'] as num).toDouble();
    final lng = (m['lng'] as num).toDouble();
    final following = m['is_following'] == true;
    final member = m['is_member'] == true;
    final verified = m['verified'] == true;
    final wa = m['contact_whatsapp'] as String?;
    final phone = m['contact_phone'] as String?;
    final payNote = m['payment_note'] as String?;
    final openNeeds = _needs.where((n) => n['status'] == 'open').toList();
    final closedNeeds = _needs.where((n) => n['status'] != 'open').toList();

    return [
      // ---- header
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19))),
            if (verified)
              const Chip(
                avatar: Icon(Icons.verified_rounded, color: AppColors.teal, size: 16),
                label: Text('صفحة موثّقة', style: TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
              ),
          ]),
          if (m['area'] != null || m['address'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text([m['address'], m['area'], m['governorate']].whereType<String>().join(' — '),
                  style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12.5)),
            ),
          const SizedBox(height: 4),
          Text('${membersLabel(m['members'] as num?)} • ${m['followers'] ?? 0} متابع${m['is_primary'] == true ? ' • مسجدك الأساسي' : ''}',
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 11.5)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton.icon(
              onPressed: _joinBusy ? null : _toggleJoin,
              style: member
                  ? ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceAlt, foregroundColor: AppColors.success)
                  : ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
              icon: Icon(member ? Icons.check_circle_rounded : Icons.group_add_rounded, size: 18),
              label: Text(member ? 'عضو ✓' : 'انضم'),
            ),
            if (!member)
            ElevatedButton.icon(
              onPressed: _followBusy ? null : _toggleFollow,
              style: following ? ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceAlt, foregroundColor: AppColors.ink) : null,
              icon: Icon(following ? Icons.check_rounded : Icons.add_alert_rounded, size: 18),
              label: Text(following ? 'متابع' : 'تابع المسجد'),
            ),
            OutlinedButton.icon(
              onPressed: () => openDirections(lat: lat, lng: lng),
              icon: const Icon(Icons.directions_rounded, size: 18),
              label: const Text('الاتجاهات'),
            ),
          ]),
          if (member)
            Wrap(spacing: 4, children: [
              if (m['is_primary'] != true)
                TextButton(onPressed: _makePrimary, child: const Text('اجعله مسجدي الأساسي', style: TextStyle(fontSize: 12))),
              TextButton.icon(
                onPressed: () => editMosqueChatNickname(context, _id),
                icon: const Icon(Icons.badge_outlined, size: 16),
                label: const Text('اسمك في الشات', style: TextStyle(fontSize: 12)),
              ),
            ]),
          if (following)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('إشعارات المسجد (إعلانات، دروس، جنازات)', style: TextStyle(fontSize: 12.5)),
              value: m['notify'] == true,
              onChanged: _setNotify,
            ),
        ]),
      ),

      // ---- the mosque chat
      _card(
        color: AppColors.surfaceAlt,
        child: Row(children: [
          const Icon(Icons.forum_rounded, color: AppColors.crystal),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('شات المسجد', style: TextStyle(fontWeight: FontWeight.w800)),
              Text(
                member || m['can_moderate_chat'] == true
                    ? ((m['chat_today'] as num? ?? 0) > 0 ? '${m['chat_today']} رسالة النهارده' : 'اتكلم مع أهل المسجد')
                    : ((m['chat_messages'] as num? ?? 0) > 0 ? '${m['chat_messages']} رسالة — انضم عشان تشارك' : 'انضم عشان تشارك أهل المسجد'),
                style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
              ),
            ]),
          ),
          member || m['can_moderate_chat'] == true
              ? FilledButton(onPressed: _openChat, child: const Text('افتح الشات'))
              : FilledButton(onPressed: _joinBusy ? null : _toggleJoin, child: const Text('انضم عشان تشارك')),
        ]),
      ),

      // ---- invitations
      Wrap(spacing: 4, children: [
        TextButton.icon(
          onPressed: () => inviteNeighbours(_id, m['name'] as String? ?? ''),
          icon: const Icon(Icons.group_add_rounded, size: 18),
          label: const Text('ادعو جيرانك ينضموا'),
        ),
        if (!verified)
          TextButton.icon(
            onPressed: () => inviteImam(_id, m['name'] as String? ?? ''),
            icon: const Icon(Icons.record_voice_over_rounded, size: 18),
            label: const Text('ادعو إمام مسجدك'),
          ),
      ]),
      const SizedBox(height: 6),

      // ---- prayer times
      PrayerTimesCard(
        lat: lat,
        lng: lng,
        title: 'مواقيت الصلاة في المسجد النهارده',
        iqama: Map<String, dynamic>.from((m['iqama'] as Map?) ?? const {}),
        khutba: m['friday_khutba_time'] as String?,
        khatib: m['khatib'] as String?,
      ),
      if (m['khatib'] != null || m['friday_khutba_time'] != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _card(
            child: Row(children: [
              const Icon(Icons.record_voice_over_rounded, color: AppColors.crystal),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  ['خطبة الجمعة', if (timeOfDayText(m['friday_khutba_time'] as String?) != null) timeOfDayText(m['friday_khutba_time'] as String?)!, if (m['khatib'] != null) 'الخطيب: ${m['khatib']}']
                      .join(' — '),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ]),
          ),
        ),

      // ---- claim
      if (_perms.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: m['my_pending_claim'] == true
              ? _card(color: AppColors.surfaceAlt, child: const Text('طلبك لإدارة المسجد قيد المراجعة — هيوصلك إشعار أول ما يتراجع.', style: TextStyle(fontSize: 12.5)))
              : OutlinedButton.icon(
                  onPressed: _claim,
                  icon: const Icon(Icons.badge_outlined),
                  label: Text(verified ? 'أنا من إدارة المسجد ده' : 'أنا مسؤول عن المسجد ده (إمام / خطيب / أمين)'),
                ),
        )
      else
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: ElevatedButton.icon(onPressed: _manage, icon: const Icon(Icons.admin_panel_settings_rounded), label: const Text('إدارة المسجد')),
        ),

      // ---- live lessons (0085)
      _section('دروس أونلاين', Icons.live_tv_rounded, [
        for (final s in _live) LiveLessonCard(session: s, showMosque: false),
      ]),

      // ---- announcements
      _section('إعلانات المسجد', Icons.campaign_rounded, [
        for (final p in _posts)
          _card(
            color: p['kind'] == 'janaza' || p['kind'] == 'urgent' ? const Color(0xFFFFF4E5) : null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (p['pinned'] == true) const Padding(padding: EdgeInsetsDirectional.only(end: 4), child: Icon(Icons.push_pin_rounded, size: 16, color: AppColors.gold)),
                if (p['kind'] != 'announcement')
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6),
                    child: Text(MasjidService.postKinds[p['kind']] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFFB45309), fontWeight: FontWeight.w800)),
                  ),
                Expanded(child: Text(p['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800))),
              ]),
              if ((p['body'] as String?)?.isNotEmpty == true) Padding(padding: const EdgeInsets.only(top: 4), child: Text(p['body'] as String, style: const TextStyle(fontSize: 13, height: 1.6))),
              Text(_date(p['created_at']), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            ]),
          ),
      ]),

      // ---- lessons
      _section('الدروس وحلقات القرآن', Icons.menu_book_rounded, [
        for (final l in _lessons)
          _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(l['kind'] == 'quran_circle' ? Icons.auto_stories_rounded : Icons.school_rounded, size: 18, color: AppColors.crystal),
                const SizedBox(width: 6),
                Expanded(child: Text(l['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800))),
                Text(MasjidService.audienceLabels[l['audience']] ?? '', style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary)),
              ]),
              const SizedBox(height: 3),
              Text(
                [if (l['sheikh'] != null) l['sheikh'], lessonWhen(l), if (l['location'] != null) l['location']].where((s) => '$s'.isNotEmpty).join(' • '),
                style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
              ),
              if (l['notes'] != null) Text(l['notes'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
            ]),
          ),
      ]),

      // ---- needs
      _section('احتياجات المسجد', Icons.volunteer_activism_rounded, [
        for (final n in [...openNeeds, ...closedNeeds.take(3)])
          _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Expanded(child: Text(n['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5))),
                if (n['status'] != 'open') const Text('اكتمل ✓', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 12)),
              ]),
              if (n['photo_url'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(n['photo_url'] as String, height: 140, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox.shrink()),
                  ),
                ),
              if (n['description'] != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(n['description'] as String, style: const TextStyle(fontSize: 12.5, height: 1.6))),
              const SizedBox(height: 8),
              NeedProgress(need: n),
              const SizedBox(height: 8),
              Row(children: [
                if (n['status'] == 'open')
                  ElevatedButton.icon(onPressed: () => _pledge(n), icon: const Icon(Icons.favorite_rounded, size: 16), label: const Text('هساهم')),
                const SizedBox(width: 8),
                TextButton(onPressed: () => _showContributions(n), child: Text('المساهمين (${n['contributors'] ?? 0})')),
              ]),
            ]),
          ),
        if (_needs.isNotEmpty) ...[
          _card(
            color: AppColors.surfaceAlt,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('إزاي تدفع؟', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(payNote ?? 'تواصل مع إدارة المسجد.', style: const TextStyle(fontSize: 12.5, height: 1.6)),
              Wrap(spacing: 8, children: [
                if (wa != null)
                  TextButton.icon(
                    onPressed: () => launchUrl(
                        Uri.parse('https://wa.me/2$wa?text=${Uri.encodeComponent('السلام عليكم، بخصوص المساهمة في احتياجات ${m['name']}')}'),
                        mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.chat_rounded, color: Color(0xFF1FA855)),
                    label: const Text('واتساب المسجد'),
                  ),
                if (phone != null)
                  TextButton.icon(onPressed: () => launchUrl(Uri.parse('tel:$phone')), icon: const Icon(Icons.call_rounded), label: Text(phone)),
              ]),
              const SizedBox(height: 6),
              const NoMoneyNote(),
            ]),
          ),
          const Align(alignment: AlignmentDirectional.centerStart, child: TutorialButton(screenKey: 'mosque_need')),
        ],
      ]),

      // ---- orphans
      _section('كفالة الأيتام', Icons.child_care_rounded, [
        for (final o in _orphans)
          _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(o['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
              Text('${masjidMoney(o['monthly_amount'] as num?)} ج.م شهرياً', style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w700)),
              if (o['description'] != null) Text(o['description'] as String, style: const TextStyle(fontSize: 12.5, height: 1.6)),
              const SizedBox(height: 4),
              Text(
                [
                  '${o['active_sponsors'] ?? 0} كفيل مؤكد',
                  if (o['slots'] != null) 'المطلوب ${o['slots']}',
                ].join(' • '),
                style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary),
              ),
              const SizedBox(height: 6),
              if (o['my_status'] != null)
                Text(o['my_status'] == 'active' ? 'إنت كفيل في البرنامج ده — جزاك الله خيراً' : 'طلب كفالتك وصل — المسجد هيتواصل معاك',
                    style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700))
              else if (o['status'] == 'open')
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ElevatedButton.icon(onPressed: () => _sponsor(o), icon: const Icon(Icons.favorite_rounded, size: 16), label: const Text('هكفل')),
                ),
            ]),
          ),
        if (_orphans.isNotEmpty)
          const Text('حفاظاً على خصوصية الأطفال، مفيش أي أسماء أو صور أو بيانات للأطفال على التطبيق. التطبيق بينظم التعهدات بس ومابيستلمش فلوس.',
              style: TextStyle(fontSize: 11, color: AppColors.inkMuted, height: 1.6)),
      ]),

      // ---- competitions
      _section('مسابقات القرآن', Icons.emoji_events_rounded, [
        for (final c in _comps) _competitionCard(c),
      ]),
    ];
  }

  Widget _competitionCard(Map<String, dynamic> c) {
    final levels = ((c['mosque_competition_levels'] as List?) ?? const []).map((e) => Map<String, dynamic>.from(e as Map)).toList()
      ..sort((a, b) => ((a['sort'] as num?) ?? 0).compareTo((b['sort'] as num?) ?? 0));
    final counts = _compCounts[c['id']];
    final deadline = c['registration_deadline'] as String?;
    final mine = (counts?['my_entries'] as num?)?.toInt() ?? 0;
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(c['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
        if (c['description'] != null) Text(c['description'] as String, style: const TextStyle(fontSize: 12.5, height: 1.6)),
        if (levels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(spacing: 6, runSpacing: 6, children: [
              for (final l in levels) Chip(label: Text([l['name'], if (l['age_group'] != null) l['age_group']].join(' — '), style: const TextStyle(fontSize: 11))),
            ]),
          ),
        if (c['schedule'] != null) Text('المواعيد: ${c['schedule']}', style: const TextStyle(fontSize: 12)),
        if (deadline != null) Text('آخر ميعاد للتسجيل: $deadline', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
        Text('${counts?['registered'] ?? 0} متسابق مسجّل', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, children: [
          if (c['status'] == 'open') ElevatedButton(onPressed: () => _register(c), child: const Text('سجّل في المسابقة')),
          if (c['results_published'] == true) OutlinedButton(onPressed: () => _showResults(c), child: const Text('النتيجة')),
          if (mine > 0) TextButton(onPressed: () => _myEntries(c), child: Text('تسجيلاتي ($mine)')),
        ]),
      ]),
    );
  }

  static String _date(Object? iso) {
    final d = DateTime.tryParse(iso as String? ?? '')?.toLocal();
    return d == null ? '' : DateFormat('yyyy/MM/dd HH:mm').format(d);
  }
}

/// Who pledged / gave; the mosque's needs managers confirm or reject here.
class ContributionsList extends StatefulWidget {
  const ContributionsList({super.key, required this.need, required this.canManage, this.controller, this.onChanged});
  final Map<String, dynamic> need;
  final bool canManage;
  final ScrollController? controller;
  final VoidCallback? onChanged;

  @override
  State<ContributionsList> createState() => _ContributionsListState();
}

class _ContributionsListState extends State<ContributionsList> {
  List<Map<String, dynamic>>? _rows;
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await MasjidService.contributions(widget.need['id'] as String);
      if (mounted) setState(() => _rows = rows);
    } catch (_) {
      if (mounted) setState(() => _rows = const []);
    }
  }

  Future<void> _act(String id, Future<void> Function() f) async {
    setState(() => _busy.add(id));
    try {
      await f();
      await _load();
      widget.onChanged?.call();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(masjidError(e))));
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return ListView(controller: widget.controller, padding: const EdgeInsets.all(16), children: [
      Text('المساهمين في «${widget.need['title']}»', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 4),
      const Text('المبالغ المؤكدة بس هي اللي بتتحسب في التقدم.', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
      const SizedBox(height: 8),
      if (rows == null) const Center(child: CircularProgressIndicator()),
      if (rows != null && rows.isEmpty) const Text('لسه محدش سجّل مساهمة — كن أول المساهمين.'),
      for (final r in rows ?? const <Map<String, dynamic>>[])
        Card(
          child: ListTile(
            title: Text('${r['donor_label']}${r['anonymous'] == true && widget.canManage ? ' (مخفي للناس)' : ''}'),
            subtitle: Text([
              '${masjidMoney(r['amount'] as num?)} ج.م',
              switch (r['status']) { 'confirmed' => r['kind'] == 'cash' ? 'كاش مؤكد ✓' : 'وصل ✓', 'cancelled' => 'اتلغى', _ => 'تعهد — لسه ماوصلش' },
              if (r['note'] != null) r['note'],
            ].join(' • ')),
            trailing: r['status'] != 'pledged'
                ? null
                : _busy.contains(r['id'])
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : widget.canManage
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              tooltip: 'وصل — أكّد',
                              icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
                              onPressed: () => _act(r['id'] as String, () => MasjidService.confirmContribution(r['id'] as String)),
                            ),
                            IconButton(
                              tooltip: 'ماوصلش — الغيه',
                              icon: const Icon(Icons.cancel_outlined, color: Color(0xFFC62828)),
                              onPressed: () => _act(r['id'] as String, () => MasjidService.cancelContribution(r['id'] as String)),
                            ),
                          ])
                        : r['is_mine'] == true
                            ? TextButton(
                                onPressed: () => _act(r['id'] as String, () => MasjidService.cancelContribution(r['id'] as String)),
                                child: const Text('إلغاء'))
                            : null,
          ),
        ),
    ]);
  }
}
