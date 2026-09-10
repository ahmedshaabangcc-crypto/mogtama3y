import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A 1:1 escrow-protected service chat (e.g. with a technician) —
/// matches design/screens/00_service_chat.png.
class ServiceChatScreen extends StatelessWidget {
  const ServiceChatScreen({super.key, this.contactName = 'م/ خالد البحيري', this.contactRole = 'سباكة وصيانة متخصصة'});
  final String contactName, contactRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          const CircleAvatar(radius: 17, backgroundColor: Colors.white24, child: Icon(Icons.person_rounded, color: Colors.white, size: 18)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(contactName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                const Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
              ]),
              Text('متصل الآن • $contactRole', style: const TextStyle(fontSize: 10, color: Colors.white70)),
            ],
          ),
        ]),
        actions: const [
          Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.call_outlined)),
          Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.navy,
            child: Row(children: [
              const Icon(Icons.lock_outline_rounded, color: AppColors.gold, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('حماية الضمان الذكي مُفعّلة (150 ج.م محجوزة)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    Text('لا يُحرر المبلغ إلا بعد التأكيد برمز OTP بعد فحص العمل.', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                  ],
                ),
              ),
              const Text('التفاصيل', style: TextStyle(color: AppColors.tealLight, fontSize: 10.5, fontWeight: FontWeight.w600)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: Text('اليوم • 14 مايو', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ),
                ),
                _IncomingBubble(
                  time: '03:15 م',
                  child: const Text(
                    'أهلاً بك يا فندم في برج الياسمين (شقة 4B). أنا تحت أمرك، تفضل بتوضيح المشكلة بصورة أو فيديو للعطل لو تكرمت لتحديد القطع المطلوبة فوراً.',
                    style: TextStyle(fontSize: 12, height: 1.7),
                  ),
                ),
                const SizedBox(height: 10),
                _OutgoingImageBubble(time: '03:18 م'),
                const SizedBox(height: 10),
                _OutgoingBubble(
                  time: '03:18 م',
                  child: const Text(
                    'السلام عليكم م/ خالد، في تسريب مياه مستمر من محبس السخان الرئيسي والتوصيلة السفلية تحت الحوض بالحمام، يرجى التكرم بالمعاينة اليوم لو أمكن.',
                    style: TextStyle(fontSize: 12, height: 1.7, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                _IncomingVoiceBubble(time: '03:20 م'),
                const SizedBox(height: 14),
                const _AppointmentCard(),
              ],
            ),
          ),
          const _QuickChipsRow(),
          const _Composer(),
        ],
      ),
    );
  }
}

class _IncomingBubble extends StatelessWidget {
  const _IncomingBubble({required this.time, required this.child});
  final String time;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 14, color: AppColors.inkMuted)),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: child,
              ),
              Padding(padding: const EdgeInsets.only(top: 3, right: 4), child: Text(time, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted))),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutgoingBubble extends StatelessWidget {
  const _OutgoingBubble({required this.time, required this.child});
  final String time;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
                child: child,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 4),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(time, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  const SizedBox(width: 3),
                  const Icon(Icons.done_all_rounded, size: 12, color: AppColors.teal),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutgoingImageBubble extends StatelessWidget {
  const _OutgoingImageBubble({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 150,
                  width: 220,
                  color: AppColors.surfaceAlt,
                  child: Stack(
                    children: [
                      const Center(child: Icon(Icons.plumbing_rounded, size: 36, color: AppColors.inkMuted)),
                      Positioned(
                        bottom: 6,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                          child: const Text('معاينة العطل', style: TextStyle(color: Colors.white, fontSize: 9)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 4),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(time, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  const SizedBox(width: 3),
                  const Icon(Icons.done_all_rounded, size: 12, color: AppColors.teal),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IncomingVoiceBubble extends StatelessWidget {
  const _IncomingVoiceBubble({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 14, color: AppColors.inkMuted)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.graphic_eq_rounded, color: AppColors.inkMuted, size: 60),
                const SizedBox(width: 6),
                const Text('0:24', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
              ]),
            ),
            Padding(padding: const EdgeInsets.only(top: 3, right: 4), child: Row(children: [
              const Icon(Icons.mic_none_rounded, size: 11, color: AppColors.inkMuted),
              const SizedBox(width: 3),
              Text('تسجيل صوتي • $time', style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
            ])),
          ],
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.teal, width: 1.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('بانتظار موافقتك', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            const Icon(Icons.event_available_rounded, size: 16, color: AppColors.teal),
          ]),
          const SizedBox(height: 8),
          const Text('اقتراح موعد فحص وزيارة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 10),
          Row(children: const [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الموعد المقترح للزيارة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                  Text('اليوم، 05:30 مساءً', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text('برج الياسمين - الدور 4 - شقة 4B', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('المعاينة الأولية', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                Text('150 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.teal)),
                Text('شامل الانتقال', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
              ],
            ),
          ]),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, size: 12, color: AppColors.inkMuted),
              SizedBox(width: 5),
              Expanded(child: Text('لا يتم خصم أو تسليم المبلغ إلا بعد حضورك وتأكيدك بكود الإنجاز.', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted))),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('تعديل', style: TextStyle(fontSize: 11.5)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 15),
                  label: const Text('تأكيد وحجز بالضمان', style: TextStyle(fontSize: 11.5)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _QuickChipsRow extends StatelessWidget {
  const _QuickChipsRow();

  @override
  Widget build(BuildContext context) {
    const chips = ['سياسة الضمان', 'عرض قائمة التنويه الموثق', 'إرسال تفاصيل الشكوى'];
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 30,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, i) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.border)),
            child: Text(chips[i], style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary)),
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 42,
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Row(children: [
                Expanded(child: Text('اكتب رسالتك للمهندس خالد...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12))),
                Icon(Icons.attach_file_rounded, size: 18, color: AppColors.inkMuted),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.mic_none_rounded, color: AppColors.inkSecondary),
        ]),
      ),
    );
  }
}
