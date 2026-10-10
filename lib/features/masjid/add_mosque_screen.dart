import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/location/where.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import 'masjid_widgets.dart';

/// «ضيف مسجد مش موجود» — the mosque is placed where the user stands
/// (they should add it from the mosque or right next to it).
class AddMosqueScreen extends StatefulWidget {
  const AddMosqueScreen({super.key, this.lat, this.lng});
  final double? lat;
  final double? lng;

  @override
  State<AddMosqueScreen> createState() => _AddMosqueScreenState();
}

class _AddMosqueScreenState extends State<AddMosqueScreen> {
  final _name = TextEditingController();
  final _area = TextEditingController();
  final _gov = TextEditingController();
  final _address = TextEditingController();
  double? _lat;
  double? _lng;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _lat = widget.lat;
    _lng = widget.lng;
  }

  @override
  void dispose() {
    for (final c in [_name, _area, _gov, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _locate() async {
    try {
      final p = await Where.current();
      if (mounted) {
        setState(() {
          _lat = p.latitude;
          _lng = p.longitude;
        });
      }
    } catch (_) {
      _toast('معرفناش نحدد مكانك — اسمح للموقع وجرّب تاني');
    }
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _save() async {
    if (_name.text.trim().length < 3) return _toast('اكتب اسم المسجد');
    if (_lat == null || _lng == null) return _toast('حدّد مكان المسجد الأول');
    setState(() => _busy = true);
    try {
      final id = await MasjidService.addMosque(
        name: _name.text.trim(),
        lat: _lat!,
        lng: _lng!,
        address: _address.text.trim(),
        area: _area.text.trim(),
        governorate: _gov.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      context.push(AppRoutes.mosque(id));
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ضيف مسجد')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('ضيف المسجد وانت جوّه أو جنبه، عشان مكانه يتسجّل صح.', style: TextStyle(color: AppColors.inkSecondary, fontSize: 12.5)),
          const SizedBox(height: 12),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المسجد', hintText: 'مسجد النور')),
          const SizedBox(height: 10),
          TextField(controller: _area, decoration: const InputDecoration(labelText: 'المنطقة / الحي', hintText: 'مدينة نصر')),
          const SizedBox(height: 10),
          TextField(controller: _gov, decoration: const InputDecoration(labelText: 'المدينة / المحافظة', hintText: 'القاهرة')),
          const SizedBox(height: 10),
          TextField(controller: _address, decoration: const InputDecoration(labelText: 'العنوان (اختياري)')),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _locate,
            icon: Icon(_lat == null ? Icons.my_location_rounded : Icons.check_circle_rounded, color: _lat == null ? null : AppColors.success),
            label: Text(_lat == null ? 'حدّد مكان المسجد (مكاني دلوقتي)' : 'المكان اتحدد — اضغط لتحديثه'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _busy ? null : _save, child: Text(_busy ? 'جارٍ الحفظ…' : 'ضيف المسجد')),
        ],
      ),
    );
  }
}
