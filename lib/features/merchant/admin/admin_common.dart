import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/geo/money.dart';
import '../../../core/shops/store_service.dart';
import '../../../core/theme/app_colors.dart';

/// Widths of the merchant admin (متجري): a bottom bar below [rail], a
/// NavigationRail up to [sidebar], then the Shopify-like sidebar.
abstract final class AdminBreakpoints {
  static const rail = 600.0;
  static const sidebar = 1024.0;

  /// Content never grows wider than this.
  static const maxContent = 1280.0;
}

/// An amount in the shown shop's currency (0092).
String shopMoney(num v) => money(v, StoreService.merchantCurrency);

String adminErrorText(Object e, String fallback) => e is PostgrestException ? e.message : fallback;

const orderStatusLabels = {
  'placed': 'طلب جديد',
  'preparing': 'بيتجهّز',
  'delivering': 'في الطريق',
  'delivered': 'اتسلّم',
  'cancelled': 'ملغي',
};

/// The status filter chips: (status or null for all, label).
const orderStatusFilters = <(String?, String)>[
  (null, 'الكل'),
  ('placed', 'جديدة'),
  ('preparing', 'بتتجهّز'),
  ('delivering', 'في الطريق'),
  ('delivered', 'اتسلّمت'),
  ('cancelled', 'ملغية'),
];

(Color, Color) orderStatusColors(String status) => switch (status) {
      'placed' => (AppColors.gold.withValues(alpha: 0.22), const Color(0xFF8A5A12)),
      'preparing' => (AppColors.tealLight, AppColors.crystal),
      'delivering' => (const Color(0xFFDDEBFF), const Color(0xFF1D4ED8)),
      'delivered' => (AppColors.success.withValues(alpha: 0.15), const Color(0xFF047857)),
      'cancelled' => (AppColors.categorySos.withValues(alpha: 0.12), const Color(0xFFB91C1C)),
      _ => (AppColors.surfaceAlt, AppColors.inkSecondary),
    };

/// What the merchant can move an order to next, with the button label.
List<(String, String)> nextOrderActions(String status) => switch (status) {
      'placed' => [('preparing', 'ابدأ التجهيز'), ('cancelled', 'إلغاء')],
      'preparing' => [('delivering', 'خرج للتوصيل'), ('delivered', 'اتسلّم'), ('cancelled', 'إلغاء')],
      'delivering' => [('delivered', 'اتسلّم'), ('cancelled', 'إلغاء')],
      _ => const [],
    };

/// Filter chips: the theme's selected chip is crystal, so its label goes
/// white (the font family still comes from the theme).
TextStyle chipLabelStyle(bool selected) =>
    TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: selected ? FontWeight.w700 : FontWeight.w500);

const productStatusLabels = {'active': 'نشط', 'draft': 'مسودة', 'archived': 'مؤرشف'};

String productStatusOf(Map<String, dynamic> p) =>
    (p['status'] as String?) ?? (p['is_available'] == false ? 'draft' : 'active');

class Pill extends StatelessWidget {
  const Pill(this.text, this.color, this.ink, {super.key, this.icon});
  final String text;
  final Color color;
  final Color ink;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        // Text (not a Row): ellipsizes when squeezed, works unbounded too.
        child: Text.rich(
          TextSpan(children: [
            if (icon != null) ...[
              WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(icon, size: 12, color: ink)),
              const TextSpan(text: ' '),
            ],
            TextSpan(text: text),
          ]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w800),
        ),
      );
}

class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill(this.status, {super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, ink) = orderStatusColors(status);
    return Pill(orderStatusLabels[status] ?? status, bg, ink);
  }
}

/// «كاش عند الاستلام» — the only payment متجري has today.
class CashPill extends StatelessWidget {
  const CashPill({super.key, this.long = false});
  final bool long;

  @override
  Widget build(BuildContext context) =>
      Pill(long ? 'كاش عند الاستلام' : 'كاش', AppColors.surfaceAlt, AppColors.inkSecondary, icon: Icons.payments_outlined);
}

/// A white rounded card with an optional title row.
class AdminCard extends StatelessWidget {
  const AdminCard({super.key, this.title, this.trailing, required this.child, this.padding = const EdgeInsets.all(14)});
  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // A Material (not a DecoratedBox): ListTiles inside paint their ink here.
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
      child: Padding(
      padding: padding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        if (title != null) ...[
          Row(children: [
            Expanded(child: Text(title!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
            ?trailing,
          ]),
          const SizedBox(height: 10),
        ],
        child,
      ]),
      ),
    );
  }
}

/// A page of the admin: a header (back, title, search, actions) above
/// [body], centred at [AdminBreakpoints.maxContent].
///
/// [scrollable]: the body is a plain widget put in a ListView; otherwise
/// [body] fills the rest of the page itself (lists, master–detail).
class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actions = const [],
    this.search,
    this.backTo,
    this.scrollable = false,
    this.maxWidth = AdminBreakpoints.maxContent,
    this.floatingActionButton,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget> actions;
  final Widget? search;

  /// Route the back arrow goes to (detail / editor pages).
  final String? backTo;
  final bool scrollable;
  final double maxWidth;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < AdminBreakpoints.rail;
    final pad = narrow ? 12.0 : 24.0;
    final header = Padding(
      padding: EdgeInsets.fromLTRB(pad, narrow ? 10 : 18, pad, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          if (backTo != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 4),
              child: IconButton(
                tooltip: 'رجوع',
                onPressed: () => context.go(backTo!),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800, fontSize: narrow ? 18 : 22)),
              if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            ]),
          ),
          if (search != null && !narrow) ...[
            const SizedBox(width: 12),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 360), child: search!),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(width: 8),
            Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: actions),
          ],
        ]),
        if (search != null && narrow) ...[const SizedBox(height: 8), search!],
      ]),
    );
    final content = scrollable
        ? ListView(padding: EdgeInsets.fromLTRB(pad, 4, pad, 96), children: [body])
        : Padding(padding: EdgeInsets.symmetric(horizontal: pad), child: body);
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: floatingActionButton,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [header, Expanded(child: content)]),
        ),
      ),
    );
  }
}

/// A search box for [AdminPage.search].
class AdminSearchField extends StatelessWidget {
  const AdminSearchField({super.key, required this.controller, required this.hint, required this.onChanged});
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, v, _) => v.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'مسح',
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}

/// «قريباً» pages of the roadmap (customers, discounts).
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title, required this.icon, required this.text});
  final String title;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: title,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircleAvatar(radius: 34, backgroundColor: AppColors.tealLight, child: Icon(icon, size: 34, color: AppColors.crystal)),
            const SizedBox(height: 14),
            const Pill('قريباً', AppColors.gold, AppColors.night),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSecondary, height: 1.7)),
          ]),
        ),
      ),
    );
  }
}
