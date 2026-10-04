import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/pwa/push.dart';
import '../../core/theme/app_colors.dart';

/// "فعّل إشعارات الموبايل": subscribes this phone/browser to Web Push so
/// in-app notifications (new orders, approvals…) also arrive with the app
/// closed. Hidden when unsupported, already on, signed out, or dismissed.
class PushOptInCard extends StatefulWidget {
  const PushOptInCard({super.key, this.text = 'فعّل الإشعارات عشان يوصلك كل طلب جديد على موبايلك فوراً، حتى والتطبيق مقفول.'});
  final String text;

  @override
  State<PushOptInCard> createState() => _PushOptInCardState();
}

class _PushOptInCardState extends State<PushOptInCard> {
  bool _busy = false;
  bool _hidden = false;

  Future<void> _enable() async {
    setState(() => _busy = true);
    try {
      final raw = await subscribeDeviceForPush(vapidPublicKey);
      if (raw.isEmpty) {
        _toast(pushState == 'denied'
            ? 'الإشعارات مقفولة من إعدادات المتصفح. افتحها من إعدادات الموقع وجرّب تاني.'
            : 'معرفناش نفعّل الإشعارات على الجهاز ده.');
        return;
      }
      final sub = jsonDecode(raw) as Map<String, dynamic>;
      final keys = Map<String, dynamic>.from(sub['keys'] as Map? ?? const {});
      await Supabase.instance.client.rpc('save_push_subscription', params: {
        'p_endpoint': sub['endpoint'],
        'p_p256dh': keys['p256dh'],
        'p_auth': keys['auth'],
        'p_app': isTajerApp ? 'tajer' : (isUnionApp ? 'ittihad' : 'mogtama3y'),
      });
      _toast('تمام! الإشعارات هتوصلك على الجهاز ده 🔔');
      if (mounted) setState(() => _hidden = true);
    } catch (_) {
      _toast('حصلت مشكلة، جرّب تاني');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String m) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final state = pushState;
    if (_hidden || !AuthService.isSignedIn || state == 'unsupported' || state == 'granted') return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        const Icon(Icons.notifications_active_rounded, color: AppColors.gold),
        const SizedBox(width: 10),
        Expanded(child: Text(widget.text, style: const TextStyle(fontSize: 12.5, height: 1.5))),
        const SizedBox(width: 6),
        ElevatedButton(
          onPressed: _busy ? null : _enable,
          child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('فعّل'),
        ),
        IconButton(onPressed: () => setState(() => _hidden = true), icon: const Icon(Icons.close_rounded, size: 18)),
      ]),
    );
  }
}
