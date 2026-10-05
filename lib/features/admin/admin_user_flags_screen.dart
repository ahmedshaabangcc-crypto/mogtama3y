import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/people/people_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// Super-admin list of reports about people ("إبلاغ" on a person in
/// "ناس حواليك" or in a chat), newest first, with how many times the
/// reported person has been flagged in total.
class AdminUserFlagsScreen extends StatefulWidget {
  const AdminUserFlagsScreen({super.key});

  @override
  State<AdminUserFlagsScreen> createState() => _AdminUserFlagsScreenState();
}

class _AdminUserFlagsScreenState extends State<AdminUserFlagsScreen> {
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _flags = [];

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
      final flags = await PeopleService.adminFlags();
      if (!mounted) return;
      setState(() {
        _flags = flags;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  static String _date(String? iso) {
    final t = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
    return t == null ? '' : DateFormat('yyyy/MM/dd HH:mm').format(t);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('بلاغات عن أشخاص')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل البلاغات')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _flags.isEmpty
                      ? ListView(children: const [
                          Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: Text('مفيش بلاغات عن أشخاص', style: TextStyle(color: AppColors.inkMuted))),
                          ),
                        ])
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(side, 12, side, 24),
                          itemCount: _flags.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, i) => _card(_flags[i]),
                        ),
                ),
    );
  }

  Widget _card(Map<String, dynamic> f) {
    final count = (f['reported_count'] as num?)?.toInt() ?? 1;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.person_off_rounded, size: 18, color: AppColors.crystal),
          const SizedBox(width: 6),
          Expanded(
            child: Text(f['reported'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: count >= 3 ? Colors.red.withValues(alpha: 0.1) : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text('$count بلاغ', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: count >= 3 ? Colors.red : AppColors.inkSecondary)),
          ),
        ]),
        const SizedBox(height: 6),
        Text(f['reason'] as String? ?? '', style: const TextStyle(fontSize: 12.5, height: 1.5)),
        const SizedBox(height: 6),
        Text('من: ${f['reporter'] ?? '—'}  ·  ${_date(f['created_at'] as String?)}',
            style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        if (f['reported_id'] != null)
          SelectableText('ID: ${f['reported_id']}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
      ]),
    );
  }
}
