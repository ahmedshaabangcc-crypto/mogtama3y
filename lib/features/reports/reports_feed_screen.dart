import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/reports/report_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/location/where.dart';
import '../shared/load_error_view.dart';
import 'report_widgets.dart';

/// "بلاغات حيّك": reports around the user (or all of Egypt without a
/// location), newest first, filterable by category and status, plus
/// "بلاغاتي". A list only — directions open in Google Maps.
class ReportsFeedScreen extends StatefulWidget {
  const ReportsFeedScreen({super.key});

  @override
  State<ReportsFeedScreen> createState() => _ReportsFeedScreenState();
}

class _ReportsFeedScreenState extends State<ReportsFeedScreen> {
  Position? _position;
  String? _category;
  String? _status;
  bool _mine = false;
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
        _position = await Where.current();
      }
    } catch (_) {}
    await _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final p = _position;
      final list = await ReportService.list(lat: p?.latitude, lng: p?.longitude, km: 5, category: _category, status: _status, mine: _mine);
      if (mounted) {
        setState(() {
          _reports = list;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(_mine ? 'بلاغاتي' : (_position != null ? 'بلاغات حيّك' : 'بلاغات الناس'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/report').then((_) => _load()),
        icon: const Icon(Icons.campaign_rounded),
        label: const Text('بلّغ عن مشكلة', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(children: [
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: side, vertical: 8),
            children: [
              if (AuthService.isSignedIn) ...[
                FilterChip(
                  selected: _mine,
                  label: const Text('بلاغاتي'),
                  onSelected: (v) {
                    setState(() => _mine = v);
                    _load();
                  },
                ),
                const SizedBox(width: 6),
              ],
              for (final s in const [null, 'new', 'routed', 'resolved']) ...[
                ChoiceChip(
                  selected: _status == s,
                  label: Text(s == null ? 'كل الحالات' : reportStatuses[s]!.$1),
                  showCheckmark: false,
                  onSelected: (_) {
                    setState(() => _status = s);
                    _load();
                  },
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: side),
            children: [
              ChoiceChip(
                selected: _category == null,
                label: const Text('كل الأنواع'),
                showCheckmark: false,
                onSelected: (_) {
                  setState(() => _category = null);
                  _load();
                },
              ),
              for (final (name, icon, color) in reportCategories) ...[
                const SizedBox(width: 6),
                ChoiceChip(
                  selected: _category == name,
                  avatar: Icon(icon, size: 15, color: _category == name ? Colors.white : color),
                  label: Text(name),
                  selectedColor: color,
                  labelStyle: TextStyle(color: _category == name ? Colors.white : AppColors.ink, fontSize: 12),
                  showCheckmark: false,
                  onSelected: (_) {
                    setState(() => _category = name);
                    _load();
                  },
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error
                  ? LoadErrorView(onRetry: _load)
                  : _reports.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('مفيش بلاغات هنا لسه — كن أول واحد يبلّغ عن مشكلة في حيّك',
                                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6)),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(side, 8, side, 96),
                            itemCount: _reports.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, i) => ReportCard(_reports[i]),
                          ),
                        ),
        ),
      ]),
    );
  }
}
