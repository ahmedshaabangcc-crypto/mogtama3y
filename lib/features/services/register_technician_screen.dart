import 'package:flutter/material.dart';

import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';

const _categories = ['سباكة', 'كهرباء', 'تكييف وتبريد', 'نجارة', 'دهانات', 'أخرى'];

/// Self-registration for a technician — see
/// backend/migrations/0022_technicians_maintenance.sql. Any resident
/// can list their own service; there's no verification pipeline yet,
/// so is_verified simply defaults to false rather than pretending to
/// vet anyone.
class RegisterTechnicianScreen extends StatefulWidget {
  const RegisterTechnicianScreen({super.key});

  @override
  State<RegisterTechnicianScreen> createState() => _RegisterTechnicianScreenState();
}

class _RegisterTechnicianScreenState extends State<RegisterTechnicianScreen> {
  String _category = _categories.first;
  final _bioCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;
  bool _done = false;

  @override
  void dispose() {
    _bioCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_areaCtrl.text.trim().isEmpty) {
      setState(() => _error = 'أدخل منطقة عملك أولاً');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await TechnicianService.registerAsTechnician(category: _category, bio: _bioCtrl.text.trim(), serviceArea: _areaCtrl.text.trim());
      if (!mounted) return;
      setState(() => _done = true);
    } catch (_) {
      setState(() => _error = 'تعذر التسجيل، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('تم التسجيل')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 40),
              const SizedBox(height: 14),
              const Text('ظهرت خدماتك في سوق الفنيين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              const Text('هيبدأ الجيران يشوفوك ويحجزوا زيارات، وهتلاقي طلباتهم في قسم "طلباتي" بمجرد ما تحجزلك.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                child: const Text('حسناً'),
              ),
            ]),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سجّل كفني في مُجتمعي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const Text('التخصص', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((c) {
              final selected = c == _category;
              return InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => setState(() => _category = c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: selected ? AppColors.navy : AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: selected ? AppColors.navy : AppColors.border)),
                  child: Text(c, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('نبذة عنك وخبراتك', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
          const SizedBox(height: 8),
          TextField(controller: _bioCtrl, maxLines: 3, decoration: _decoration('مثال: 10 سنوات خبرة في تأسيس السباكة وصيانة السخانات')),
          const SizedBox(height: 16),
          const Text('منطقة العمل', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
          const SizedBox(height: 8),
          TextField(controller: _areaCtrl, decoration: _decoration('مثال: المعادي - دجلة')),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _submitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white)) : const Text('تسجيل خدماتي'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
      );
}
