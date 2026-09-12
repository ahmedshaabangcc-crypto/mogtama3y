import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/maintenance/technician_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';

/// Submits real identity verification for a technician profile — an ID
/// card photo plus a short face video, reviewed manually by Ahmed
/// before the technician shows the verified badge. See
/// backend/migrations/0027_storage_and_verification.sql. Both files go
/// to the private-documents bucket — nobody but the technician and a
/// super_admin can ever read them.
class TechnicianVerificationScreen extends StatefulWidget {
  const TechnicianVerificationScreen({super.key, required this.technicianId});
  final String technicianId;

  @override
  State<TechnicianVerificationScreen> createState() => _TechnicianVerificationScreenState();
}

class _TechnicianVerificationScreenState extends State<TechnicianVerificationScreen> {
  bool _loading = true;
  String _status = 'unsubmitted';
  String? _idCardPath;
  String? _videoPath;
  bool _uploadingCard = false;
  bool _uploadingVideo = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await TechnicianService.fetchVerification(widget.technicianId);
    if (!mounted) return;
    setState(() {
      _status = result['verification_status'] as String? ?? 'unsubmitted';
      _idCardPath = result['id_card_url'] as String?;
      _videoPath = result['verification_video_url'] as String?;
      _loading = false;
    });
  }

  Future<void> _pickIdCard() async {
    final file = await UploadService.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => _uploadingCard = true);
    try {
      final path = await UploadService.uploadPrivateDocument(purpose: 'technician-verification', file: file);
      if (!mounted) return;
      setState(() => _idCardPath = path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع صورة البطاقة، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _uploadingCard = false);
    }
  }

  Future<void> _pickVideo() async {
    final file = await UploadService.pickVideo(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => _uploadingVideo = true);
    try {
      final path = await UploadService.uploadPrivateDocument(purpose: 'technician-verification', file: file);
      if (!mounted) return;
      setState(() => _videoPath = path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع الفيديو، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _uploadingVideo = false);
    }
  }

  Future<void> _submit() async {
    if (_idCardPath == null || _videoPath == null) return;
    setState(() => _submitting = true);
    try {
      await TechnicianService.submitVerification(technicianId: widget.technicianId, idCardStoragePath: _idCardPath!, videoStoragePath: _videoPath!);
      if (!mounted) return;
      setState(() => _status = 'pending');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال طلب التوثيق، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('توثيق حساب الفني')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          if (_status == 'pending')
            _StatusBanner(icon: Icons.hourglass_top_rounded, color: AppColors.gold, text: 'طلب التوثيق قيد المراجعة، هيوصلك إشعار فور الاعتماد.')
          else if (_status == 'approved')
            _StatusBanner(icon: Icons.verified_rounded, color: AppColors.teal, text: 'حسابك موثّق بالفعل ✓')
          else if (_status == 'rejected')
            _StatusBanner(icon: Icons.error_outline_rounded, color: AppColors.categorySos, text: 'تم رفض طلب التوثيق السابق، تقدر ترفع المستندات وتحاول تاني.'),
          const SizedBox(height: 16),
          const Text(
            'رفع بطاقة الرقم القومي وفيديو قصير لوجهك بيديك شارة "موثّق" في سوق الفنيين، وبيزوّد ثقة الجيران في حجز خدمتك.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 20),
          const Text('صورة بطاقة الرقم القومي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 8),
          _UploadTile(uploading: _uploadingCard, done: _idCardPath != null, label: 'اضغط لرفع صورة البطاقة', doneLabel: 'تم رفع صورة البطاقة', icon: Icons.badge_outlined, onTap: _pickIdCard),
          const SizedBox(height: 20),
          const Text('فيديو قصير لوجهك (تحقق هوية)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 4),
          const Text('صوّر نفسك لمدة ثوانٍ في مكان مضيء، بحيث يظهر وجهك بوضوح', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 8),
          _UploadTile(uploading: _uploadingVideo, done: _videoPath != null, label: 'اضغط لرفع فيديو وجهك', doneLabel: 'تم رفع الفيديو', icon: Icons.videocam_outlined, onTap: _pickVideo),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: (_idCardPath != null && _videoPath != null && !_submitting) ? _submit : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded, size: 17),
              label: const Text('إرسال طلب التوثيق', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('المستندات دي خاصة وما يشوفها غير إدارة مُجتمعي فقط', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.uploading, required this.done, required this.label, required this.doneLabel, required this.icon, required this.onTap});
  final bool uploading, done;
  final String label, doneLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: uploading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: done ? AppColors.teal : AppColors.border, width: done ? 1.5 : 1)),
        child: Column(
          children: [
            if (uploading)
              const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Icon(done ? Icons.check_circle_rounded : icon, color: done ? AppColors.teal : AppColors.inkMuted, size: 28),
            const SizedBox(height: 8),
            Text(done ? doneLabel : label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: done ? AppColors.teal : AppColors.inkSecondary)),
          ],
        ),
      ),
    );
  }
}
