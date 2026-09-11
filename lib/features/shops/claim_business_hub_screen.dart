import 'package:flutter/material.dart';

import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';

const _methodValues = ['otp', 'document', 'union_president'];

/// Claim & verify a Google-imported business listing — matches
/// design/screens/42_claim_business_hub.png, now submitting a real
/// shop_claim_requests row for review instead of granting instant
/// access to the store manager panel.
class ClaimBusinessHubScreen extends StatefulWidget {
  const ClaimBusinessHubScreen({super.key, required this.shop});
  final Map<String, dynamic> shop;

  @override
  State<ClaimBusinessHubScreen> createState() => _ClaimBusinessHubScreenState();
}

class _ClaimBusinessHubScreenState extends State<ClaimBusinessHubScreen> {
  int _method = 0;
  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await PlacesService.submitClaimRequest(
        shopId: widget.shop['id'] as String,
        verificationMethod: _methodValues[_method],
      );
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (_) {
      setState(() => _error = 'تعذر إرسال الطلب، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('مطالبة وتملك النشاط التجاري')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.hourglass_top_rounded, color: AppColors.gold, size: 32),
                ),
                const SizedBox(height: 18),
                const Text('طلبك قيد المراجعة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('تم إرسال طلب مطالبتك بالنشاط التجاري بنجاح، وسيتم إشعارك فور مراجعته والتأكد من ملكيتك للمحل.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted, height: 1.7)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final shop = widget.shop;
    final name = shop['name'] as String? ?? '';
    final address = shop['address'] as String?;
    final category = shop['category'] as String?;
    final rating = (shop['rating'] as num?)?.toDouble();
    final ratingCount = shop['rating_count'] as int?;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('مطالبة وتملك النشاط التجاري')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text(
            'فعّل محلك التجاري المستورد تلقائياً من خرائط جوجل وابدأ تقديم خدماتك وتوصيل لسكان العمارات المجاورة.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: AppColors.categoryShops.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.storefront_rounded, color: AppColors.categoryShops),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    if (address != null)
                      Row(children: [
                        const Icon(Icons.location_on_outlined, size: 11, color: AppColors.inkMuted),
                        const SizedBox(width: 3),
                        Expanded(child: Text(address, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                      ]),
                    if (rating != null)
                      Row(children: [
                        const Icon(Icons.star_rounded, size: 12, color: AppColors.gold),
                        const SizedBox(width: 2),
                        Text('$rating${ratingCount != null ? ' ($ratingCount مراجعة على جوجل)' : ''}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                      ]),
                  ],
                ),
              ),
            ]),
          ),
          if (category != null) ...[
            const SizedBox(height: 6),
            Text('تصنيف: $category', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.help_outline_rounded, color: AppColors.teal),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تنبيه التحقق من الملكية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.teal)),
                    Text('هذا النشاط التجاري مدرج تلقائياً من خرائط جوجل لخدمة سكان الحي. هل أنت المالك أو المدير الفعلي؟',
                        style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('طريقة إثبات الملكية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('3 خيارات', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          _ProofOption(
            selected: _method == 0,
            onTap: () => setState(() => _method = 0),
            badge: 'أسرع طريقة',
            badgeColor: AppColors.teal,
            title: 'إرسال كود OTP عبر هاتف المحل المسجل في جوجل',
            body: 'إرسال رمز تحقق آني (OTP) إلى هاتف المتجر الثابت/المسجل في جوجل للتأكيد المباشر.',
          ),
          const SizedBox(height: 10),
          _ProofOption(
            selected: _method == 1,
            onTap: () => setState(() => _method = 1),
            badge: 'مراجعة يدوية',
            badgeColor: AppColors.gold,
            title: 'رفع صورة السجل التجاري أو البطاقة الضريبية للمنشأة',
            body: 'رفع مستند رسمي بإدارة أو ملكية المحل لتوثيق الحساب التجاري رسمياً.',
          ),
          const SizedBox(height: 10),
          _ProofOption(
            selected: _method == 2,
            onTap: () => setState(() => _method = 2),
            badge: 'ضمان الجيرة',
            badgeColor: AppColors.categoryUnion,
            title: 'تزكية وتأكيد رئيس اتحاد ملاك العمارة الكائن بها المحل',
            body: 'تزكية وتأكيد رقمي مباشر من رئيس اتحاد الملاك عبر حسابه بتطبيق مُجتمعي.',
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                  : const Icon(Icons.verified_rounded, size: 18),
              label: const Text('إرسال طلب توثيق الملكية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('طلبك يُراجع يدوياً قبل تفعيل صلاحيات إدارة المحل', textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _ProofOption extends StatelessWidget {
  const _ProofOption({required this.selected, required this.onTap, required this.badge, required this.badgeColor, required this.title, required this.body});
  final bool selected;
  final VoidCallback onTap;
  final String badge, title, body;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 18, color: selected ? AppColors.teal : AppColors.inkMuted),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, height: 1.5))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                  child: Text(badge, style: TextStyle(fontSize: 8, color: badgeColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(padding: const EdgeInsets.only(right: 26), child: Text(body, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.6))),
          ],
        ),
      ),
    );
  }
}
