import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/masjid/masjid_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../tutorials/tutorial_widgets.dart';
import 'masjid_widgets.dart';

/// «أنا مسؤول عن المسجد ده»: role, phone and an optional proof (a letter
/// from the أوقاف, an ID with the mosque's stamp…) to the private bucket —
/// only the claimant and the platform admin can open it. The platform admin
/// reviews it from the admin panel.
class ClaimMosqueScreen extends StatefulWidget {
  const ClaimMosqueScreen({super.key, required this.mosqueId, required this.mosqueName});
  final String mosqueId;
  final String mosqueName;

  @override
  State<ClaimMosqueScreen> createState() => _ClaimMosqueScreenState();
}

class _ClaimMosqueScreenState extends State<ClaimMosqueScreen> {
  String _role = 'imam';
  final _phone = TextEditingController();
  final _note = TextEditingController();
  XFile? _doc;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _note.dispose();
    super.dispose();
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _pick() async {
    final f = await UploadService.pickImage(source: ImageSource.gallery);
    if (f != null && mounted) setState(() => _doc = f);
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      String? path;
      if (_doc != null) path = await UploadService.uploadPrivateDocument(purpose: 'mosque_claim', file: _doc!);
      await MasjidService.claim(widget.mosqueId,
          role: _role, phone: _phone.text.trim(), docPath: path, note: _note.text.trim().isEmpty ? null : _note.text.trim());
      if (!mounted) return;
      _toast('طلبك وصل — هيتراجع وهيوصلك إشعار');
      Navigator.of(context).pop(true);
    } catch (e) {
      _toast(masjidError(e, e.toString().contains('مدعوم') ? 'نوع الملف ده مش مدعوم، جرّب صورة JPG أو PNG' : 'حصلت مشكلة، جرّب تاني'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب إدارة المسجد'), actions: const [TutorialButton(screenKey: 'mosque_claim')]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.mosqueName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 6),
          const Text(
            'بعد ما فريق مُجتمعي يراجع طلبك ويتأكد، هتقدر تنشر مواعيد الإقامة وخطبة الجمعة والإعلانات والدروس واحتياجات المسجد، وتضيف مساعدين.',
            style: TextStyle(color: AppColors.inkSecondary, fontSize: 12.5, height: 1.7),
          ),
          const SizedBox(height: 14),
          const Text('صفتك في المسجد', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final e in MasjidService.roleTitles.entries)
              ChoiceChip(label: Text(e.value), selected: _role == e.key, onSelected: (_) => setState(() => _role = e.key)),
          ]),
          const SizedBox(height: 14),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'رقم موبايلك', hintText: '01xxxxxxxxx', helperText: 'للتواصل معاك في المراجعة — مش هيظهر للناس'),
          ),
          const SizedBox(height: 10),
          TextField(controller: _note, maxLines: 3, decoration: const InputDecoration(labelText: 'معلومة تساعدنا نتأكد (اختياري)', hintText: 'مثلاً: إمام المسجد من 2015 بتعيين من الأوقاف')),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pick,
            icon: Icon(_doc == null ? Icons.upload_file_rounded : Icons.check_circle_rounded, color: _doc == null ? null : AppColors.success),
            label: Text(_doc == null ? 'ارفع صورة إثبات (اختياري): خطاب الأوقاف أو كارنيه' : 'تم اختيار الصورة — اضغط للتغيير'),
          ),
          const SizedBox(height: 4),
          const Text('الإثبات بيتحفظ بشكل خاص — محدش يشوفه غيرك وغير فريق المراجعة.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _busy ? null : _submit, child: Text(_busy ? 'جارٍ الإرسال…' : 'ابعت الطلب')),
        ],
      ),
    );
  }
}
