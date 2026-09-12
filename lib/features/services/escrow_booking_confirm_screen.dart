import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';
import 'my_maintenance_requests_screen.dart';

/// Escrow payment confirmation for a booked service visit — now a real
/// booking against the caller's real wallet balance, see
/// backend/migrations/0022_technicians_maintenance.sql. The fee is
/// moved from available_balance into held_balance immediately; it only
/// reaches the technician once the resident confirms completion with
/// the one-time code (see my_maintenance_requests_screen.dart).
class EscrowBookingConfirmScreen extends StatefulWidget {
  const EscrowBookingConfirmScreen({
    super.key,
    required this.technicianId,
    required this.providerName,
    required this.category,
    required this.rating,
    required this.ratingCount,
    this.inspectionFee = 80,
  });

  final String technicianId, providerName, category;
  final double rating;
  final int ratingCount;
  final double inspectionFee;

  @override
  State<EscrowBookingConfirmScreen> createState() => _EscrowBookingConfirmScreenState();
}

class _EscrowBookingConfirmScreenState extends State<EscrowBookingConfirmScreen> {
  bool _loadingWallet = true;
  double _availableBalance = 0;
  final _descriptionCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadWallet() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return;
    final wallet = await Supabase.instance.client.from('wallets').select().eq('user_id', userId).maybeSingle();
    if (!mounted) return;
    setState(() {
      _availableBalance = (wallet?['available_balance'] as num?)?.toDouble() ?? 0;
      _loadingWallet = false;
    });
  }

  Future<void> _confirm() async {
    if (_availableBalance < widget.inspectionFee) {
      setState(() => _error = 'رصيد محفظتك غير كافٍ لحجز الضمان. اشحن محفظتك أولاً.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await TechnicianService.bookService(
        technicianId: widget.technicianId,
        category: widget.category,
        description: _descriptionCtrl.text.trim(),
        inspectionFee: widget.inspectionFee,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MyMaintenanceRequestsScreen()));
    } catch (e) {
      setState(() => _error = e.toString().contains('عمارتك') ? e.toString().replaceFirst('Exception: ', '') : 'تعذر إتمام الحجز، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.inspectionFee;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تأكيد الحجز وإتمام الدفع بالضمان')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('دفع من محفظتك ومضمون 100%', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.shield_rounded, color: AppColors.teal, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('أموالك في أمان تام بنظام الضمان (Escrow)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.5))),
                ]),
                const SizedBox(height: 10),
                const Text(
                  'يتم تجميد مبلغ الحجز في محفظتك، ولن يُحوَّل أي مليم للفني إلا بعد حضوره وإتمام المعاينة وإدخالك لكود التأكيد برضاك التام.',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.8),
                ),
                const SizedBox(height: 12),
                Row(children: const [
                  Expanded(child: _EscrowStep(icon: Icons.lock_outline_rounded, label: '1. حجز من محفظتك')),
                  Expanded(child: _EscrowStep(icon: Icons.home_work_outlined, label: '2. زيارة ومعاينة الفني')),
                  Expanded(child: _EscrowStep(icon: Icons.password_rounded, label: '3. الإفراج بكود التأكيد')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('تفاصيل حجز الخدمة والفني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.category, style: const TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(widget.providerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        Row(children: [
                          const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                          const SizedBox(width: 2),
                          Text('${widget.rating.toStringAsFixed(1)} (${widget.ratingCount} تقييم)', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                        ]),
                      ],
                    ),
                  ),
                ]),
                const Divider(height: 24, color: AppColors.border),
                TextField(
                  controller: _descriptionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'وصف مختصر للمشكلة (اختياري)',
                    hintStyle: TextStyle(color: AppColors.inkMuted, fontSize: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('جدول الرسوم المجمّدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                _FeeRow(label: 'رسم المعاينة والتشخيص الأولي', value: '${widget.inspectionFee.toStringAsFixed(2)} ج.م'),
                const Divider(height: 24, color: AppColors.border),
                _FeeRow(label: 'إجمالي الحجز المطلوب', value: '${total.toStringAsFixed(2)} ج.م', emphasize: true),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _loadingWallet ? 'جارِ تحميل رصيدك...' : 'رصيدك المتاح: ${_availableBalance.toStringAsFixed(2)} ج.م',
                    style: TextStyle(fontSize: 10, color: _availableBalance >= total ? AppColors.inkMuted : Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
          ],
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submitting || _loadingWallet ? null : _confirm,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: _submitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.lock_outline_rounded, size: 17),
                  label: const Text('تأكيد الحجز وحجز مبلغ الضمان', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 6),
              const Text('يُرد المبلغ تلقائياً بالكامل إذا ألغيت الطلب قبل بدء الزيارة.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EscrowStep extends StatelessWidget {
  const _EscrowStep({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({required this.label, required this.value, this.emphasize = false});
  final String label, value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: emphasize ? 13 : 11.5, fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500, color: emphasize ? AppColors.ink : AppColors.inkSecondary))),
        Text(value, style: TextStyle(fontSize: emphasize ? 17 : 12.5, fontWeight: FontWeight.w800, color: emphasize ? AppColors.teal : AppColors.ink)),
      ],
    );
  }
}
