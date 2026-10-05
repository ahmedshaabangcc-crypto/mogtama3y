import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/maps/maps_launcher.dart';
import '../../core/places/directory_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// A business from the Egypt directory (not on مُجتمعي yet) as a store page:
/// details, call, directions, and "اطلب دلوقتي" — the customer writes the
/// order and sends it from their own WhatsApp, with an invitation for the
/// shop to open its free store. Once the owner claims it, this opens the
/// real store instead.
class DirectoryPlaceScreen extends StatefulWidget {
  const DirectoryPlaceScreen({super.key, required this.placeId, this.place});
  final String placeId;

  /// Row from a list, when we already have it (skips the fetch).
  final Map<String, dynamic>? place;

  @override
  State<DirectoryPlaceScreen> createState() => _DirectoryPlaceScreenState();
}

class _DirectoryPlaceScreenState extends State<DirectoryPlaceScreen> {
  Map<String, dynamic>? _place;
  bool _loading = true;
  bool _error = false;
  final _request = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _request.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final p = widget.place ??
          await Supabase.instance.client.from('directory_places').select().eq('id', widget.placeId).maybeSingle();
      final shopId = p?['claimed_shop_id'] as String?;
      if (shopId != null) {
        final shop = await Supabase.instance.client.from('shops').select('slug').eq('id', shopId).maybeSingle();
        final slug = shop?['slug'] as String?;
        if (slug != null && mounted) {
          context.go('/s/$slug');
          return;
        }
      }
      if (!mounted) return;
      setState(() {
        _place = p;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  Future<void> _send() async {
    final p = _place!;
    final req = _request.text.trim();
    if (req.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب طلبك الأول')));
      return;
    }
    final addr = _address.text.trim();
    await launchUrl(
      DirectoryService.whatsappToShop(
        p['whatsapp'] as String,
        shopName: p['name'] as String? ?? '',
        request: addr.isEmpty ? req : '$req\nالعنوان: $addr',
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _place;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(p?['name'] as String? ?? 'المحل')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : p == null
                  ? const Center(child: Text('المحل ده مش موجود', style: TextStyle(color: AppColors.inkMuted)))
                  : _content(p),
    );
  }

  Widget _content(Map<String, dynamic> p) {
    final wa = p['whatsapp'] as String?;
    final phone = p['phone'] as String?;
    final lat = (p['lat'] as num?)?.toDouble();
    final lng = (p['lng'] as num?)?.toDouble();
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 680 ? (width - 640) / 2 : 16.0;
    return ListView(
      padding: EdgeInsets.fromLTRB(side, 16, side, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(gradient: AppColors.nightGradient, borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            const CircleAvatar(radius: 28, backgroundColor: AppColors.nightMid, child: Icon(Icons.storefront_rounded, color: AppColors.gold, size: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['name'] as String? ?? '', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(p['category'] as String? ?? '', style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
                if ((p['address'] as String?)?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(p['address'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.5)),
                  ),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          if (phone != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}')),
                icon: const Icon(Icons.call_rounded),
                label: const Text('اتصل'),
              ),
            ),
          if (phone != null && lat != null) const SizedBox(width: 10),
          if (lat != null && lng != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => openDirections(lat: lat, lng: lng),
                icon: const Icon(Icons.directions_rounded),
                label: const Text('الاتجاهات'),
              ),
            ),
        ]),
        const SizedBox(height: 20),
        if (wa != null) ...[
          const Text('اطلب دلوقتي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('اكتب اللي محتاجه، وطلبك هيتبعت للمحل على واتساب من موبايلك.',
              style: TextStyle(color: AppColors.inkSecondary, fontSize: 13, height: 1.6)),
          const SizedBox(height: 12),
          TextField(
            controller: _request,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(labelText: 'طلبك', hintText: 'مثلاً: 2 كيلو جبنة بيضا وعلبة زبادي'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _address,
            decoration: const InputDecoration(labelText: 'عنوان التوصيل (اختياري)', hintText: 'الشارع، العمارة، الدور'),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _send,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1FA855), foregroundColor: Colors.white),
              icon: const Icon(Icons.send_rounded),
              label: const Text('ابعت الطلب على واتساب', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
            ),
          ),
        ] else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: const Text('المحل ده مالوش رقم واتساب عندنا — كلّمه على التليفون أو روحله بالاتجاهات.',
                style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: const Text(
            'المحل ده لسه مش مشترك في مُجتمعي، فطلبك بيروحله على واتساب وهو اللي بيرد عليك ويحدد السعر والتوصيل.',
            style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: () => context.go('/merchant'),
            icon: const Icon(Icons.verified_rounded, size: 18),
            label: const Text('ده محلك؟ افتح متجرك واستقبل الطلبات ببلاش'),
          ),
        ),
        const SizedBox(height: 6),
        const Center(child: Text(DirectoryService.attribution, style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
      ],
    );
  }
}
