import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/masjid/masjid_community.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import 'masjid_widgets.dart';
import 'mosque_chat_screen.dart';

/// «ادعو إمام مسجدك» — WhatsApp with a ready message + the mosque link.
Future<void> inviteImam(String mosqueId, String mosqueName) =>
    launchUrl(whatsappShareUri(imamInviteText(mosqueName, MasjidService.shareUrl(mosqueId))), mode: LaunchMode.externalApplication);

/// «ادعو جيرانك ينضموا».
Future<void> inviteNeighbours(String mosqueId, String mosqueName) =>
    launchUrl(whatsappShareUri(neighboursInviteText(mosqueName, MasjidService.shareUrl(mosqueId))), mode: LaunchMode.externalApplication);

Future<void> openMosqueChat(BuildContext context, String mosqueId, String? name) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MosqueChatScreen(mosqueId: mosqueId, mosqueName: name)));

/// The big «انضم لمسجدك» call to action — the first thing on the masjid
/// home until the user belongs to a mosque.
class JoinMosqueCta extends StatelessWidget {
  const JoinMosqueCta({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFE9C46A)], begin: Alignment.topRight, end: Alignment.bottomLeft),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            const CircleAvatar(radius: 28, backgroundColor: AppColors.night, child: Icon(Icons.mosque_rounded, color: AppColors.gold, size: 30)),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('انضم لمسجدك', style: TextStyle(color: AppColors.night, fontWeight: FontWeight.w900, fontSize: 20)),
                SizedBox(height: 4),
                Text('لاقي مسجد حيّك في حدود 500 متر، انضم لأهله، وتابع الإقامة والدروس والجنازات واتكلم في شات المسجد.',
                    style: TextStyle(color: AppColors.night, fontSize: 12.5, height: 1.55)),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.night, borderRadius: BorderRadius.circular(14)),
              child: const Text('يلا', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900)),
            ),
          ]),
        ),
      ),
    );
  }
}

/// One of «مساجدي»: chat shortcut with the unread badge, members, and
/// invitations (the imam, while the mosque has no verified admin).
class MyMosqueCard extends StatelessWidget {
  const MyMosqueCard({super.key, required this.mosque, required this.onChanged});
  final Map<String, dynamic> mosque;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final id = mosque['id'] as String;
    final name = mosque['name'] as String? ?? '';
    final badge = unreadBadge(mosque['unread'] as num?);
    final verified = mosque['verified'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mosque['is_primary'] == true ? AppColors.gold : AppColors.glassBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InkWell(
          onTap: () async {
            await context.push(AppRoutes.mosque(id));
            onChanged();
          },
          child: Row(children: [
            const Icon(Icons.mosque_rounded, color: AppColors.gold),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(
                    child: Text(name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.5)),
                  ),
                  if (verified) const Padding(padding: EdgeInsetsDirectional.only(start: 4), child: Icon(Icons.verified_rounded, color: AppColors.teal, size: 16)),
                ]),
                Text(
                  [if (mosque['is_primary'] == true) 'مسجدي الأساسي', membersLabel(mosque['member_count'] as num?)].join(' • '),
                  style: const TextStyle(color: Colors.white60, fontSize: 11.5),
                ),
              ]),
            ),
            const Icon(Icons.chevron_left_rounded, color: Colors.white54),
          ]),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
              onPressed: () async {
                await openMosqueChat(context, id, name);
                onChanged();
              },
              icon: Badge(isLabelVisible: badge.isNotEmpty, label: Text(badge), child: const Icon(Icons.forum_rounded)),
              label: Text(badge.isEmpty ? 'شات المسجد' : 'شات المسجد — $badge جديد'),
            ),
          ),
        ]),
        const SizedBox(height: 6),
        Wrap(spacing: 4, children: [
          TextButton.icon(
            onPressed: () => inviteNeighbours(id, name),
            icon: const Icon(Icons.group_add_rounded, size: 18, color: Colors.white70),
            label: const Text('ادعو جيرانك ينضموا', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
          if (!verified)
            TextButton.icon(
              onPressed: () => inviteImam(id, name),
              icon: const Icon(Icons.record_voice_over_rounded, size: 18, color: AppColors.gold),
              label: const Text('ادعو إمام مسجدك', style: TextStyle(color: AppColors.gold, fontSize: 12)),
            ),
        ]),
      ]),
    );
  }
}

/// «أدوات يومية» — a slot for the daily tools (المصحف، المحفّظ، الأذكار،
/// القبلة، التقويم الهجري، تنبيه الصلاة). The screens and their `/masjid/tools/…`
/// routes are built separately (lib/features/masjid_tools/); this row only
/// pushes the route strings.
class DailyToolsRow extends StatelessWidget {
  const DailyToolsRow({super.key});

  static const tools = [
    (Icons.menu_book_rounded, 'المصحف', '/masjid/tools/quran'),
    (Icons.headphones_rounded, 'استماع', '/masjid/tools/listen'),
    (Icons.record_voice_over_rounded, 'المحفّظ', '/masjid/tools/tutor'),
    (Icons.wb_twilight_rounded, 'الأذكار', '/masjid/tools/adhkar'),
    (Icons.explore_rounded, 'القبلة', '/masjid/tools/qibla'),
    (Icons.calendar_month_rounded, 'الهجري', '/masjid/tools/hijri'),
    (Icons.alarm_rounded, 'تنبيه الصلاة', '/masjid/tools/reminders'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (final t in tools)
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.push(t.$3),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Column(children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.glassBorder)),
                  child: Icon(t.$1, color: AppColors.gold),
                ),
                const SizedBox(height: 5),
                Text(t.$2, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
    ]);
  }
}

/// One «قريب منك» item (masjid_nearby_feed) → its mosque page.
class NearbyFeedCard extends StatelessWidget {
  const NearbyFeedCard({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final kind = item['kind'] as String? ?? '';
    final extra = Map<String, dynamic>.from((item['extra'] as Map?) ?? const {});
    final km = (item['distance_km'] as num?)?.toDouble();
    final where = [item['mosque_name'], if (km != null) formatMeters(km * 1000)].whereType<String>().join(' • ');
    final (IconData icon, String label, Color color) = switch (kind) {
      'urgent' => (Icons.campaign_rounded, MasjidService.postKinds[extra['post_kind']] ?? 'تنبيه', const Color(0xFFB45309)),
      'lesson' => (
          extra['lesson_kind'] == 'quran_circle' ? Icons.auto_stories_rounded : Icons.school_rounded,
          extra['today'] == true ? (extra['lesson_kind'] == 'quran_circle' ? 'حلقة قرآن النهارده' : 'درس النهارده') : (extra['lesson_kind'] == 'quran_circle' ? 'حلقة قرآن' : 'درس'),
          AppColors.crystal
        ),
      'need' => (Icons.volunteer_activism_rounded, 'احتياج للمسجد', AppColors.success),
      'competition' => (Icons.emoji_events_rounded, 'مسابقة — التسجيل مفتوح', AppColors.gold),
      _ => (Icons.mosque_rounded, '', AppColors.crystal),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: kind == 'urgent' ? const Color(0xFFFFF4E5) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.mosque(item['mosque_id'] as String)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w800)),
              const Spacer(),
              Flexible(child: Text(where, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted))),
            ]),
            const SizedBox(height: 4),
            Text(item['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            if (kind == 'lesson')
              Text([if (item['subtitle'] != null) item['subtitle'], lessonWhen(extra)].where((s) => '$s'.isNotEmpty).join(' • '),
                  style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary))
            else if (kind == 'need') ...[
              const SizedBox(height: 6),
              NeedProgress(need: extra),
            ] else if (kind == 'competition' && extra['registration_deadline'] != null)
              Text('آخر ميعاد للتسجيل: ${extra['registration_deadline']}', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary))
            else if ((item['subtitle'] as String?)?.isNotEmpty == true)
              Text(item['subtitle'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
          ]),
        ),
      ),
    );
  }
}
