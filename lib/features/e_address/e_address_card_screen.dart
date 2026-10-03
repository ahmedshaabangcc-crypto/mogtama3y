import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/e_address/e_address_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import 'e_address_form_screen.dart';
import 'e_address_widgets.dart';

/// The owner's view of one address: QR card + share / manage actions.
class EAddressCardScreen extends StatefulWidget {
  const EAddressCardScreen({super.key, required this.address});
  final Map<String, dynamic> address;

  @override
  State<EAddressCardScreen> createState() => _EAddressCardScreenState();
}

class _EAddressCardScreenState extends State<EAddressCardScreen> {
  late Map<String, dynamic> _a = widget.address;

  String get _code => _a['code'] as String;
  String get _link => EAddressService.shareLinkFor(_a);

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _copy(String text, String what) {
    Clipboard.setData(ClipboardData(text: text));
    _toast('اتنسخ $what');
  }

  void _shareWhatsApp() {
    final text = 'ده عنواني (${_a['label']}) على مُجتمعي — افتح اللينك وهيوصلك على طول:\n$_link\n'
        'الكود: ${EAddressService.display(_code)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  Future<void> _edit() async {
    final saved = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => EAddressFormScreen(existing: _a)),
    );
    if (saved != null) setState(() => _a = saved);
  }

  Future<bool> _confirm(String title, String body, String action) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('رجوع')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(action)),
          ],
        ),
      ) ??
      false;

  Future<void> _regenerate() async {
    if (!await _confirm('كود جديد؟', 'اللينك والـ QR القديمين هيبطلوا يشتغلوا، ولازم تبعت الجديد للناس.', 'اعمل كود جديد')) return;
    try {
      final code = await EAddressService.regenerateCode(_a['id'] as String);
      setState(() => _a = {..._a, 'code': code});
      _toast('اتعمل كود جديد');
    } catch (_) {
      _toast('حصلت مشكلة، جرّب تاني');
    }
  }

  Future<void> _toggleActive() async {
    final active = _a['is_active'] as bool? ?? true;
    try {
      await EAddressService.save(id: _a['id'] as String, fields: {..._a, 'is_active': !active});
      setState(() => _a = {..._a, 'is_active': !active});
      _toast(active ? 'اللينك اتوقف مؤقتاً' : 'اللينك اشتغل تاني');
    } catch (_) {
      _toast('حصلت مشكلة، جرّب تاني');
    }
  }

  Future<void> _delete() async {
    if (!await _confirm('تمسح العنوان؟', 'هيتمسح نهائياً واللينك هيبطل يشتغل.', 'امسح')) return;
    try {
      await EAddressService.delete(_a['id'] as String);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      _toast('حصلت مشكلة، جرّب تاني');
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _a['is_active'] as bool? ?? true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('عنوانك الإلكتروني'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => switch (v) {
              'edit' => _edit(),
              'regen' => _regenerate(),
              'toggle' => _toggleActive(),
              'delete' => _delete(),
              _ => null,
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('تعديل العنوان')),
              const PopupMenuItem(value: 'regen', child: Text('اعمل كود جديد')),
              PopupMenuItem(value: 'toggle', child: Text(active ? 'وقّف اللينك مؤقتاً' : 'شغّل اللينك')),
              const PopupMenuItem(value: 'delete', child: Text('امسح العنوان')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          EAddressCard(address: _a),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: active ? _shareWhatsApp : null,
            icon: const Icon(Icons.share_rounded),
            label: const Text('ابعته على واتساب'),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copy(_link, 'اللينك'),
                icon: const Icon(Icons.link_rounded, size: 18),
                label: const Text('انسخ اللينك'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copy(EAddressService.display(_code), 'الكود'),
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('انسخ الكود'),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.eAddress(_code)),
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('شوف الصفحة زي ما الناس هتشوفها'),
          ),
          const SizedBox(height: 8),
          Text(
            'اتفتح ${_a['scan_count'] ?? 0} مرة. ممكن تطبع الـ QR وتلزقه على باب الشقة أو تبعته للدليفري.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 11.5, height: 1.6),
          ),
          const SizedBox(height: 18),
          _ViewsLog(addressId: _a['id'] as String),
        ],
      ),
    );
  }
}

/// "مين فتح عنوانك" — every opening of the address, newest first.
class _ViewsLog extends StatefulWidget {
  const _ViewsLog({required this.addressId});
  final String addressId;

  @override
  State<_ViewsLog> createState() => _ViewsLogState();
}

class _ViewsLogState extends State<_ViewsLog> {
  List<Map<String, dynamic>>? _views;

  @override
  void initState() {
    super.initState();
    EAddressService.views(widget.addressId).then((v) {
      if (mounted) setState(() => _views = v);
    }).catchError((_) {
      if (mounted) setState(() => _views = const []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final views = _views;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('مين فتح عنوانك', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        if (views == null)
          const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(strokeWidth: 2)))
        else if (views.isEmpty)
          const Text('محدش فتحه لسه.', style: TextStyle(color: AppColors.inkMuted, fontSize: 12))
        else
          for (final v in views.take(15))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Icon(v['shop_name'] != null ? Icons.storefront_rounded : Icons.person_outline_rounded, size: 16, color: AppColors.inkMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    v['shop_name'] != null ? '${v['shop_name']} (${v['viewer_name'] ?? ''})' : (v['viewer_name'] as String? ?? 'زائر من غير حساب'),
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ),
                Text(_ago(DateTime.tryParse(v['viewed_at'] as String? ?? '')), style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
              ]),
            ),
      ]),
    );
  }

  static String _ago(DateTime? t) {
    if (t == null) return '';
    final d = DateTime.now().difference(t.toLocal());
    if (d.inMinutes < 1) return 'دلوقتي';
    if (d.inHours < 1) return 'من ${d.inMinutes} دقيقة';
    if (d.inDays < 1) return 'من ${d.inHours} ساعة';
    return 'من ${d.inDays} يوم';
  }
}
