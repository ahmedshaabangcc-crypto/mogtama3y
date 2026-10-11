import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Night-blue page in the masjid app's look, content centred on wide screens.
class ToolScaffold extends StatelessWidget {
  const ToolScaffold({super.key, required this.title, required this.children, this.actions, this.bottom, this.padding});
  final String title;
  final List<Widget> children;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final EdgeInsets? padding;

  static double side(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width > 760 ? (width - 720) / 2 : 16.0;
  }

  @override
  Widget build(BuildContext context) {
    final s = side(context);
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
          backgroundColor: AppColors.night,
          foregroundColor: Colors.white,
          iconTheme: AppTheme.nightBarIcons,
          actionsIconTheme: AppTheme.nightBarIcons,
          titleTextStyle: nightTitleStyle(context), title: Text(title), actions: actions, bottom: bottom),
      body: ListView(padding: padding ?? EdgeInsets.fromLTRB(s, 8, s, 60), children: children),
    );
  }
}

/// A frosted card on the night background.
class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.margin = const EdgeInsets.only(bottom: 10), this.onTap, this.highlight = false});
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: highlight ? AppColors.gold.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.07),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: highlight ? AppColors.gold.withValues(alpha: 0.6) : AppColors.glassBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      ),
    );
  }
}

const toolTitleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15);
const toolMutedStyle = TextStyle(color: Colors.white60, fontSize: 12, height: 1.6);

/// The theme's app-bar title (dark ink) in white, for the night pages.
TextStyle? nightTitleStyle(BuildContext context) => Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Colors.white);

void toolToast(BuildContext context, String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
