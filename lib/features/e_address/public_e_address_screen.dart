import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/e_address/e_address_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// mogtama3y.com/#/a/<code> — what opens when someone receives a digital
/// address link or scans its QR. No account needed.
class PublicEAddressScreen extends StatefulWidget {
  const PublicEAddressScreen({super.key, required this.code});
  final String code;

  @override
  State<PublicEAddressScreen> createState() => _PublicEAddressScreenState();
}

class _PublicEAddressScreenState extends State<PublicEAddressScreen> {
  Map<String, dynamic>? _a;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final a = await EAddressService.lookup(widget.code);
      if (mounted) setState(() => _a = a);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        shape: const Border(),
        title: const Text('عنوان على مُجتمعي', style: TextStyle(color: Colors.white)),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : _error
                ? LoadErrorView(onRetry: _load)
                : _a == null
                    ? _notFound()
                    : _details(_a!),
      ),
    );
  }

  Widget _notFound() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_off_rounded, color: Colors.white54, size: 44),
            const SizedBox(height: 12),
            const Text('العنوان ده مش موجود أو صاحبه وقّفه',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('اطلب من صاحب العنوان يبعتلك اللينك الجديد.', style: TextStyle(color: Colors.white60, fontSize: 12.5)),
            const SizedBox(height: 20),
            _makeYourOwn(),
          ]),
        ),
      );

  Widget _details(Map<String, dynamic> a) {
    final maps = EAddressService.mapsUri(a);
    final phone = a['owner_phone'] as String?;
    final owner = a['owner_name'] as String?;
    String? v(String k) {
      final s = (a[k] as String?)?.trim();
      return (s == null || s.isEmpty) ? null : s;
    }

    final rows = <(String, String?)>[
      ('المحافظة', v('governorate')),
      ('المدينة / الحي', v('city')),
      ('المنطقة', v('district')),
      ('الشارع', v('street')),
      ('العمارة', v('building')),
      ('الدور', v('floor')),
      ('الشقة', v('apartment')),
    ].where((r) => r.$2 != null).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Row(children: [
          const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: Text(owner != null ? '${a['label']} — $owner' : '${a['label']}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          ),
        ]),
        const SizedBox(height: 4),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(EAddressService.display(a['code'] as String),
              textAlign: TextAlign.right, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.glassBorder)),
          child: Column(children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13))),
                  Expanded(child: Text(value!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                ]),
              ),
          ]),
        ),
        if (v('landmark') != null) ...[
          const SizedBox(height: 12),
          _note(Icons.flag_rounded, 'علامة مميزة', v('landmark')!),
        ],
        if (v('notes') != null) ...[
          const SizedBox(height: 12),
          _note(Icons.info_outline_rounded, 'ملاحظات', v('notes')!),
        ],
        const SizedBox(height: 20),
        if (maps != null)
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
              onPressed: () => launchUrl(maps, mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.directions_rounded),
              label: const Text('وصّلني على خرائط Google'),
            ),
          ),
        if (phone != null) ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _ghost(Icons.call_rounded, 'اتصل', () => launchUrl(Uri.parse('tel:$phone')))),
            const SizedBox(width: 10),
            Expanded(
              child: _ghost(Icons.chat_rounded, 'واتساب',
                  () => launchUrl(Uri.parse('https://wa.me/2$phone'), mode: LaunchMode.externalApplication)),
            ),
          ]),
        ],
        const SizedBox(height: 10),
        _ghost(Icons.copy_rounded, 'انسخ العنوان', () {
          final text = [EAddressService.oneLine(a), if (v('landmark') != null) 'علامة مميزة: ${v('landmark')}', if (maps != null) maps.toString()].join('\n');
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتنسخ العنوان')));
        }),
        const SizedBox(height: 28),
        _makeYourOwn(),
      ],
    );
  }

  Widget _note(IconData icon, String title, String body) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(body, style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.6)),
            ]),
          ),
        ]),
      );

  Widget _ghost(IconData icon, String label, VoidCallback onTap) => OutlinedButton.icon(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: AppColors.glassBorder)),
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );

  Widget _makeYourOwn() => TextButton(
        onPressed: () => context.go(AppRoutes.myAddress),
        child: const Text('اعمل عنوانك الإلكتروني ببلاش على مُجتمعي ←', style: TextStyle(color: AppColors.gold)),
      );
}
