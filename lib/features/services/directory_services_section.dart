import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/places/directory_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/location/where.dart';
import '../../core/places/place_images.dart';

/// Maintenance businesses near the user from the Egypt directory (migration
/// 0064), under the registered technicians. They are not verified: contact
/// only (call / WhatsApp); booking with escrow and the "موثّق" badge come
/// once they register with مُجتمعي.
class DirectoryServicesSection extends StatefulWidget {
  const DirectoryServicesSection({super.key, this.trade});

  /// Market category ('سباكة', 'كهرباء', …) or null for all.
  final String? trade;

  @override
  State<DirectoryServicesSection> createState() => _DirectoryServicesSectionState();
}

class _DirectoryServicesSectionState extends State<DirectoryServicesSection> {
  List<Map<String, dynamic>> _items = const [];
  bool _loading = false;
  bool _needsLocation = false;

  @override
  void initState() {
    super.initState();
    _load(ask: false);
  }

  Future<void> _load({required bool ask}) async {
    try {
      if (!ask) {
        final perm = await Geolocator.checkPermission();
        if (perm != LocationPermission.always && perm != LocationPermission.whileInUse) {
          if (mounted) setState(() => _needsLocation = true);
          return;
        }
      }
      if (mounted) setState(() => _loading = true);
      final p = await Where.current();
      final rows = await Supabase.instance.client.rpc('nearby_services', params: {
        'p_lat': p.latitude,
        'p_lng': p.longitude,
        'p_trade': widget.trade,
        'p_km': 10,
        'p_limit': 40,
      });
      if (mounted) {
        setState(() {
          _items = List<Map<String, dynamic>>.from(rows as List);
          _needsLocation = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _needsLocation = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 6),
      Row(children: [
        const Icon(Icons.handyman_outlined, size: 18, color: AppColors.inkSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text('فنيين وشركات في منطقتك${widget.trade != null ? ' — ${widget.trade}' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ),
      ]),
      const Padding(
        padding: EdgeInsets.only(top: 2, bottom: 10),
        child: Text('من دليل مُجتمعي — لسه مش موثّقين ومن غير ضمان مالي. اتواصل معاهم مباشرة.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
      ),
      if (_loading)
        const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))
      else if (_needsLocation)
        OutlinedButton.icon(
          onPressed: () => _load(ask: true),
          icon: const Icon(Icons.my_location_rounded),
          label: const Text('شوف الفنيين اللي حواليك'),
        )
      else if (_items.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('مفيش أماكن من النوع ده قريبة منك في الدليل', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
        )
      else
        for (final s in _items) ...[_card(s), const SizedBox(height: 10)],
      const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(DirectoryService.attribution, style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
      ),
      const SizedBox(height: 14),
    ]);
  }

  Widget _card(Map<String, dynamic> s) {
    final km = (s['distance_km'] as num?)?.toDouble();
    final dist = km == null ? '' : (km < 1 ? '${(km * 1000).round()} م' : '${km.toStringAsFixed(1)} كم');
    final phone = s['phone'] as String?;
    final wa = s['whatsapp'] as String?;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/d/${s['id']}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, backgroundImage: placeImage(s['trade'] as String?)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              const SizedBox(height: 2),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                  child: const Text('غير موثّق', style: TextStyle(fontSize: 10, color: AppColors.inkMuted, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text([s['trade'], dist].where((x) => x != null && '$x'.isNotEmpty).join(' · '),
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                ),
              ]),
            ]),
          ),
          if (wa != null)
            IconButton(
              tooltip: 'واتساب',
              onPressed: () => launchUrl(Uri.parse('https://wa.me/2$wa'), mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.chat_rounded, color: Color(0xFF1FA855)),
            ),
          if (phone != null)
            IconButton(
              tooltip: 'اتصل',
              onPressed: () => launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}')),
              icon: const Icon(Icons.call_rounded, color: AppColors.teal),
            ),
        ]),
      ),
    );
  }
}
