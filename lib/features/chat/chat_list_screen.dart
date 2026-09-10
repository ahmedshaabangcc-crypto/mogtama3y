import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'service_chat_screen.dart';

class _Thread {
  const _Thread({
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.unread = 0,
    this.escrow = false,
  });
  final String name, role, lastMessage, time;
  final IconData icon;
  final Color iconColor;
  final int unread;
  final bool escrow;
}

const _threads = [
  _Thread(
    name: 'م/ خالد البحيري',
    role: 'سباكة وصيانة متخصصة',
    lastMessage: 'تسجيل صوتي • 0:24',
    time: '03:20 م',
    icon: Icons.plumbing_rounded,
    iconColor: AppColors.teal,
    unread: 1,
    escrow: true,
  ),
  _Thread(
    name: 'المهندس هاني زهران',
    role: 'بائع موثق • سوق المستعمل',
    lastMessage: 'تمام يا فندم، السعر النهائي 6,200 ج.م وتقدر تعاين بكرة.',
    time: 'أمس',
    icon: Icons.shopping_bag_outlined,
    iconColor: AppColors.categoryUsedMarket,
  ),
  _Thread(
    name: 'مجلس إدارة اتحاد الشاغلين',
    role: 'رئيس الاتحاد - م. حازم عبد الرحمن',
    lastMessage: 'تم رفع التقرير المالي للربع الثالث، يرجى المراجعة.',
    time: 'أمس',
    icon: Icons.account_balance_rounded,
    iconColor: AppColors.categoryUnion,
  ),
  _Thread(
    name: 'سوبر ماركت الأمانة',
    role: 'محل معتمد • دجلة المعادي',
    lastMessage: 'وصل طلبك رقم #1084 وفي الطريق إليك الآن.',
    time: 'الثلاثاء',
    icon: Icons.storefront_rounded,
    iconColor: AppColors.categoryShops,
  ),
];

/// Conversations list — the bottom-nav "المحادثات" tab.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المحادثات')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: _threads.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = _threads[i];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ServiceChatScreen(contactName: t.name, contactRole: t.role))),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: t.iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(t.icon, color: t.iconColor, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(child: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis)),
                          if (t.escrow) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.gold)),
                        ]),
                        Text(t.role, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(t.lastMessage, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(t.time, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      const SizedBox(height: 6),
                      if (t.unread > 0)
                        Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                          child: Text('${t.unread}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
