import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../shared/load_error_view.dart';
import '../admin/admin_common.dart';
import '../admin/merchant_session.dart';
import 'integrations_service.dart';

/// Badge colours: ok / waiting / problem / off.
enum IntegrationTone { ok, waiting, problem, off }

class IntegrationBadge extends StatelessWidget {
  const IntegrationBadge(this.text, this.tone, {super.key});
  final String text;
  final IntegrationTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, ink) = switch (tone) {
      IntegrationTone.ok => (AppColors.success.withValues(alpha: 0.15), const Color(0xFF047857)),
      IntegrationTone.waiting => (AppColors.gold.withValues(alpha: 0.22), const Color(0xFF8A5A12)),
      IntegrationTone.problem => (AppColors.categorySos.withValues(alpha: 0.12), const Color(0xFFB91C1C)),
      IntegrationTone.off => (AppColors.surfaceAlt, AppColors.inkSecondary),
    };
    return Pill(text, bg, ink);
  }
}

/// A selectable LTR value with a copy button (DNS records, webhook URLs).
class CopyValue extends StatelessWidget {
  const CopyValue({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 10),
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(
              child: SelectableText(value, textDirection: TextDirection.ltr, style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5)),
            ),
            IconButton(
              tooltip: 'انسخ',
              icon: const Icon(Icons.copy_rounded, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتنسخ'), duration: Duration(seconds: 1)));
              },
            ),
          ]),
        ),
      ]),
    );
  }
}

/// Loads get_shop_integrations() of the shown shop for a settings page.
mixin IntegrationsLoader<T extends StatefulWidget> on State<T> {
  ShopIntegrations? data;
  bool loadFailed = false;
  String? _shopId;

  String get shopId => _shopId ?? '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = MerchantScope.of(context).shopId;
    if (id != null && id != _shopId) {
      _shopId = id;
      reload();
    }
  }

  Future<void> reload() async {
    final id = _shopId;
    if (id == null) return;
    if (loadFailed) setState(() => loadFailed = false);
    try {
      final d = await IntegrationsService.load(id);
      if (!mounted || id != _shopId) return;
      setState(() => data = d);
      onLoaded(d);
    } catch (_) {
      if (mounted) setState(() => loadFailed = true);
    }
  }

  /// Fill form fields from a fresh load / save.
  void onLoaded(ShopIntegrations d) {}

  void applied(ShopIntegrations d) {
    setState(() => data = d);
    onLoaded(d);
  }

  /// The page body while loading / after a failure, else null.
  Widget? loadingBody() {
    if (loadFailed) return LoadErrorView(onRetry: reload);
    if (data == null) return const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()));
    return null;
  }

  void toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

/// Two columns on wide screens, one on phones.
class ResponsivePair extends StatelessWidget {
  const ResponsivePair({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 720) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (final w in children) Padding(padding: const EdgeInsets.only(bottom: 12), child: w),
        ]);
      }
      final half = (c.maxWidth - 12) / 2;
      return Wrap(spacing: 12, runSpacing: 12, children: [for (final w in children) SizedBox(width: half, child: w)]);
    });
  }
}
