import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/visitor/visitor_pass_service.dart';
import '../auth/auth_landing_screen.dart';

const _visitTypes = ['ضيف عائلي', 'توصيل وشحن', 'صيانة وخدمات', 'أخرى'];
const _visitTypeValues = ['guest', 'delivery', 'maintenance', 'other'];
const _durations = ['ساعتان', '4 ساعات', 'اليوم بالكامل'];
const _durationValues = [Duration(hours: 2), Duration(hours: 4), Duration(hours: 24)];

String _visitTypeLabel(String value) {
  final i = _visitTypeValues.indexOf(value);
  return i == -1 ? value : _visitTypes[i];
}

/// Visitor QR access pass — matches design/screens/10_visitor_qr_pass.png,
/// now issuing/revoking real visitor_passes rows with a real scannable QR.
class VisitorQrPassScreen extends StatefulWidget {
  const VisitorQrPassScreen({super.key});

  @override
  State<VisitorQrPassScreen> createState() => _VisitorQrPassScreenState();
}

class _VisitorQrPassScreenState extends State<VisitorQrPassScreen> {
  int _visitType = 0;
  int _duration = 1;
  bool _loading = true;
  bool _issuing = false;
  String? _error;
  Map<String, dynamic>? _activePass;
  int _passCount = 0;
  Duration _remaining = Duration.zero;
  Timer? _timer;

  final _visitorNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _visitorNameCtrl.dispose();
    super.dispose();
  }

  void _tick() {
    if (_activePass == null) return;
    final validUntil = DateTime.tryParse(_activePass!['valid_until'] as String? ?? '');
    if (validUntil == null) return;
    final remaining = validUntil.difference(DateTime.now().toUtc());
    if (remaining.isNegative) {
      setState(() {
        _activePass = null;
        _remaining = Duration.zero;
      });
    } else {
      setState(() => _remaining = remaining);
    }
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    final pass = await VisitorPassService.fetchActivePass();
    final count = await VisitorPassService.fetchPassCount();
    if (!mounted) return;
    setState(() {
      _activePass = pass;
      _passCount = count;
      _loading = false;
    });
    _tick();
  }

  Future<void> _issue() async {
    if (_visitorNameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'أدخل اسم الزائر أو الجهة أولاً.');
      return;
    }
    setState(() {
      _issuing = true;
      _error = null;
    });
    try {
      final pass = await VisitorPassService.issuePass(
        visitorName: _visitorNameCtrl.text.trim(),
        passType: _visitTypeValues[_visitType],
        validFor: _durationValues[_duration],
      );
      if (!mounted) return;
      setState(() {
        _activePass = pass;
        _passCount += 1;
      });
      _tick();
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _issuing = false);
    }
  }

  Future<void> _revoke() async {
    final pass = _activePass;
    if (pass == null) return;
    await VisitorPassService.revokePass(pass['id'] as String);
    if (!mounted) return;
    setState(() => _activePass = null);
  }

  String get _formattedRemaining {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('تصريح دخول زائر موقوت (QR Pass)')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, color: AppColors.inkMuted, size: 36),
                const SizedBox(height: 12),
                const Text('سجّل دخولك لإصدار تصاريح دخول للزوار', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تصريح دخول زائر موقوت (QR Pass)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                      child: Text('سجل تصاريح الزوار ($_passCount)', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  if (_activePass != null) _ActivePassCard(
                    pass: _activePass!,
                    remaining: _formattedRemaining,
                    onRevoke: _revoke,
                  ) else const _NoPassCard(),
                  const SizedBox(height: 22),
                  const Text('إصدار تصريح زائر جديد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 10),
                  const Text('اسم الزائر أو شركة الشحن / التوصيل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                    child: TextField(
                      controller: _visitorNameCtrl,
                      style: const TextStyle(fontSize: 12.5),
                      decoration: const InputDecoration(
                        hintText: 'مثال: م/ حسام علام (مهندس ديكور)',
                        hintStyle: TextStyle(fontSize: 12.5, color: AppColors.inkMuted),
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 16, color: AppColors.inkMuted),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('نوع الزيارة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _visitTypes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.6),
                    itemBuilder: (context, i) {
                      final selected = _visitType == i;
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => setState(() => _visitType = i),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.navy : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: selected ? AppColors.navy : AppColors.border),
                          ),
                          child: Text(_visitTypes[i], style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSecondary)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('مدة الصلاحية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 0; i < _durations.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _duration = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _duration == i ? AppColors.navy : AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _duration == i ? AppColors.navy : AppColors.border),
                              ),
                              child: Text(_durations[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _duration == i ? Colors.white : AppColors.inkSecondary)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
                      ]),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _issuing ? null : _issue,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      icon: _issuing
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                          : const Icon(Icons.qr_code_rounded, size: 18),
                      label: const Text('إصدار تصريح QR جديد فوري', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: const [
                      Icon(Icons.shield_outlined, size: 16, color: AppColors.inkSecondary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('بروتوكول الأمان الموحّد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            SizedBox(height: 4),
                            Text('يقوم حارس العقار بمسح هذا الرمز للتحقق من هوية الزائر، وتسجيل وقت الدخول والخروج تلقائياً لحفظ أمن المبنى وخصوصية الجيران.',
                                style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.7)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }
}

class _NoPassCard extends StatelessWidget {
  const _NoPassCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      child: const Column(
        children: [
          Icon(Icons.qr_code_2_rounded, color: AppColors.inkMuted, size: 40),
          SizedBox(height: 8),
          Text('لا يوجد تصريح نشط حالياً', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
        ],
      ),
    );
  }
}

class _ActivePassCard extends StatelessWidget {
  const _ActivePassCard({required this.pass, required this.remaining, required this.onRevoke});
  final Map<String, dynamic> pass;
  final String remaining;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final qrCode = pass['qr_code'] as String? ?? '';
    final visitorName = pass['visitor_name'] as String? ?? '';
    final passType = pass['pass_type'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.circle, size: 7, color: AppColors.teal),
            const SizedBox(width: 6),
            const Text('تصريح نشط ومعتمد للدخول الفوري', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.teal)),
            const Spacer(),
            Text(qrCode, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 16),
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: QrImageView(data: qrCode, backgroundColor: Colors.white, eyeStyle: const QrEyeStyle(color: AppColors.navy), dataModuleStyle: const QrDataModuleStyle(color: AppColors.navy)),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.timer_outlined, size: 13, color: AppColors.teal),
              const SizedBox(width: 6),
              Text('صالح لمدة: $remaining', style: const TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const CircleAvatar(radius: 16, backgroundColor: AppColors.surface, child: Icon(Icons.person_rounded, size: 16, color: AppColors.inkMuted)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('اسم الزائر والجهة', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                    Text(visitorName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    Text('نوع الزيارة: ${_visitTypeLabel(passType)}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: 'كود تصريح الدخول لمُجتمعي: $qrCode'));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ كود التصريح، شاركه عبر واتساب')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: const Text('نسخ كود التصريح للمشاركة', style: TextStyle(fontSize: 12.5)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: onRevoke,
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              icon: const Icon(Icons.cancel_outlined, size: 15),
              label: const Text('إلغاء التصريح الحالي', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
