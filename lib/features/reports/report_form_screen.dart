import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/places/places_service.dart';
import '../../core/reports/report_service.dart';
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../../core/storage/video_upload.dart';

/// "📢 بلّغ عن مشكلة": category, up to 4 photos, the spot (GPS), a short
/// description and "hide my name". Signed-in users only (5 a day).
class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  String? _category;
  List<String> _photos = const [];
  final _description = TextEditingController();
  bool _hideIdentity = false;
  Position? _position;
  String? _district;
  bool _locating = false;
  String? _locationError;
  bool _sending = false;
  String? _videoUrl;
  bool _videoUploading = false;
  final _videoLink = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locate();
  }

  @override
  void dispose() {
    _description.dispose();
    _videoLink.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() {
      _locating = true;
      _locationError = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw 'شغّل الـ GPS عشان نحدد مكان المشكلة';
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw 'محتاجين إذن الموقع عشان نحدد مكان المشكلة';
      }
      final p = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      if (!mounted) return;
      setState(() => _position = p);
      final area = await PlacesService.resolveAreaLabel(lat: p.latitude, lng: p.longitude).catchError((_) => null);
      if (mounted) setState(() => _district = area);
    } catch (e) {
      if (mounted) setState(() => _locationError = e is String ? e : 'تعذر تحديد المكان');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickVideo() async {
    final file = await VideoUpload.pick();
    if (file == null) return;
    setState(() => _videoUploading = true);
    try {
      final url = await VideoUpload.upload(file);
      if (mounted) setState(() => _videoUrl = url);
    } catch (e) {
      _snack(e is String ? e : 'تعذر رفع الفيديو، جرّب تاني');
    } finally {
      if (mounted) setState(() => _videoUploading = false);
    }
  }

  Future<void> _send() async {
    final p = _position;
    final link = _videoLink.text.trim();
    if (link.isNotEmpty && !ReportService.videoLinkPattern.hasMatch(link)) {
      return _snack('لينك الفيديو لازم يكون من تيك توك أو يوتيوب أو فيسبوك أو إنستجرام');
    }
    if (_videoUploading) return _snack('استنى الفيديو يخلص رفع');
    if (_category == null) return _snack('اختار نوع المشكلة');
    if (_description.text.trim().length < 5) return _snack('اكتب وصف قصير للمشكلة');
    if (p == null) return _snack('حدد مكان المشكلة الأول');
    setState(() => _sending = true);
    try {
      final id = await ReportService.submit(
        category: _category!,
        description: _description.text,
        photos: _photos,
        lat: p.latitude,
        lng: p.longitude,
        governorate: governorateOf(p.latitude, p.longitude),
        district: _district,
        hideIdentity: _hideIdentity,
        videoUrl: _videoUrl,
        videoLink: link.isEmpty ? null : link,
      );
      if (!mounted) return;
      _snack('اتسجّل بلاغك، وهنبلغك بكل تحديث');
      context.pushReplacement('/r/$id');
    } catch (e) {
      final msg = e.toString();
      _snack(msg.contains('5 بلاغات') ? 'وصلت لحد 5 بلاغات في اليوم، كمّل بكرة' : 'تعذر إرسال البلاغ، جرّب تاني');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('بلّغ عن مشكلة')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.campaign_rounded, size: 48, color: AppColors.gold),
              const SizedBox(height: 10),
              const Text('سجّل دخول عشان تبلّغ عن مشكلة وتتابعها', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, height: 1.6)),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())).then((_) => setState(() {})),
                child: const Text('سجّل دخول أو اعمل حساب'),
              ),
            ]),
          ),
        ),
      );
    }
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 680 ? (width - 640) / 2 : 16.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('بلّغ عن مشكلة')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(side, 12, side, 32),
        children: [
          const Text('نوع المشكلة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final (name, icon, color) in reportCategories)
              ChoiceChip(
                selected: _category == name,
                avatar: Icon(icon, size: 17, color: _category == name ? Colors.white : color),
                label: Text(name),
                labelStyle: TextStyle(color: _category == name ? Colors.white : AppColors.ink, fontSize: 12.5),
                selectedColor: color,
                showCheckmark: false,
                onSelected: (_) => setState(() => _category = name),
              ),
          ]),
          const SizedBox(height: 18),
          const Text('صور المشكلة (اختار كذا صورة مرة واحدة)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          MultiPhotoPicker(purpose: 'reports', maxPhotos: 30, onChanged: (urls) => setState(() => _photos = List.of(urls))),
          const SizedBox(height: 18),
          const Text('فيديو (اختياري)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          Row(children: [
            OutlinedButton.icon(
              onPressed: _videoUploading ? null : _pickVideo,
              icon: _videoUploading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_videoUrl == null ? Icons.video_call_outlined : Icons.check_circle_rounded, color: _videoUrl == null ? null : AppColors.teal),
              label: Text(_videoUploading ? 'بيترفع…' : (_videoUrl == null ? 'ارفع فيديو قصير' : 'اترفع الفيديو — غيّره')),
            ),
            if (_videoUrl != null)
              IconButton(onPressed: () => setState(() => _videoUrl = null), icon: const Icon(Icons.close_rounded), tooltip: 'شيل الفيديو'),
          ]),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('لحد دقيقة و25 ميجا. الفيديو الأطول انشره على تيك توك وحط لينكه تحت.', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _videoLink,
            keyboardType: TextInputType.url,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(labelText: 'أو لينك فيديو (تيك توك / يوتيوب / فيسبوك / إنستجرام)', hintText: 'https://www.tiktok.com/@…'),
          ),
          const SizedBox(height: 18),
          const Text('المكان', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Icon(_position != null ? Icons.location_on_rounded : Icons.location_off_rounded,
                  color: _position != null ? AppColors.teal : AppColors.inkMuted),
              const SizedBox(width: 8),
              Expanded(
                child: _locating
                    ? const Text('بنحدد مكانك…')
                    : Text(
                        _position != null
                            ? 'مكانك الحالي${_district != null ? ' — $_district' : ''}، ${governorateOf(_position!.latitude, _position!.longitude)}'
                            : (_locationError ?? 'مش محدد'),
                        style: const TextStyle(height: 1.5),
                      ),
              ),
              TextButton(onPressed: _locating ? null : _locate, child: const Text('حدّث')),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('بلّغ وانت واقف عند المشكلة عشان المكان يبقى مظبوط.', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _description,
            minLines: 3,
            maxLines: 6,
            maxLength: 1000,
            decoration: const InputDecoration(labelText: 'وصف المشكلة', hintText: 'مثلاً: زبالة متكومة قدام المدرسة من أسبوع'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _hideIdentity,
            onChanged: (v) => setState(() => _hideIdentity = v),
            title: const Text('إخفاء اسمي عن العامة'),
            subtitle: const Text('اسمك هيفضل عند إدارة مُجتمعي بس', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: const Text(ReportService.disclaimer, style: TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.inkSecondary)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _sending ? null : _send,
              icon: _sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.campaign_rounded),
              label: const Text('ابعت البلاغ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
