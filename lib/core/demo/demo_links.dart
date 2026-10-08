import 'package:flutter/material.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../routing/app_router.dart';

/// The demo build's url_launcher: nothing ever leaves the app. A WhatsApp
/// link shows the exact message that would have been sent, a call shows
/// the number, Google Maps shows a drawn placeholder map, and links to the
/// app's own pages (e.g. «شوف متجرك زي الزبون») open here, locally.
///
/// Installed only from `initDemoBackend` (behind `kDemo`).
class DemoUrlLauncher extends UrlLauncherPlatform {
  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) => _handle(url);

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) => _handle(url);

  @override
  Future<void> closeWebView() async {}

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async => true;

  @override
  Future<bool> supportsCloseForMode(PreferredLaunchMode mode) async => false;

  Future<bool> _handle(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    // The app's own pages (store, product, order, address links): open them here.
    final local = demoLocalPath(uri);
    if (local != null) {
      appRouter.push(local);
      return true;
    }
    final context = appRouter.routerDelegate.navigatorKey.currentContext;
    if (context == null || !context.mounted) return false;
    await showDialog<void>(context: context, builder: (_) => DemoLinkDialog(uri: uri));
    return true;
  }
}

/// `https://mogtama3y.com/#/s/<slug>` → `/s/<slug>` when this app can show it.
String? demoLocalPath(Uri uri) {
  const hosts = {'mogtama3y.com', 'www.mogtama3y.com', 'tajer.mogtama3y.com', 'ittihad.mogtama3y.com'};
  if (!hosts.contains(uri.host)) return null;
  final path = uri.fragment;
  if (!path.startsWith('/') || path == '/') return null;
  return isInAppPath(Uri.parse(path).path) ? path : null;
}

/// What would have opened, shown instead of leaving the app.
class DemoLinkDialog extends StatelessWidget {
  const DemoLinkDialog({super.key, required this.uri});
  final Uri uri;

  static String _localPhone(String raw) {
    final d = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return d.startsWith('20') && d.length == 12 ? '0${d.substring(2)}' : d;
  }

  @override
  Widget build(BuildContext context) {
    final host = uri.host.replaceFirst('www.', '');
    late final String title;
    final children = <Widget>[];
    Widget ltr(String s, {TextStyle? style}) => Directionality(
      textDirection: TextDirection.ltr,
      child: SelectableText(s, style: style ?? const TextStyle(fontWeight: FontWeight.w800)),
    );

    if (host == 'wa.me' || host == 'api.whatsapp.com') {
      title = 'واتساب';
      final phone = _localPhone(uri.pathSegments.isEmpty ? (uri.queryParameters['phone'] ?? '') : uri.pathSegments.first);
      final text = uri.queryParameters['text'];
      children.add(
        Text(
          phone.isEmpty ? 'كان هيفتح واتساب تختار تبعت لمين' : 'كان هيفتح محادثة واتساب مع:',
          style: const TextStyle(color: Colors.black54),
        ),
      );
      if (phone.isNotEmpty) children.add(ltr(phone));
      if (text != null && text.isNotEmpty) {
        children.addAll([
          const SizedBox(height: 10),
          const Text('والرسالة دي جاهزة للإرسال:', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFDCF8C6), borderRadius: BorderRadius.circular(12)),
            child: SelectableText(text, style: const TextStyle(height: 1.6, fontSize: 13.5)),
          ),
        ]);
      }
    } else if (uri.scheme == 'tel') {
      title = 'مكالمة';
      children
        ..add(const Text('كان هيتصل بالرقم:', style: TextStyle(color: Colors.black54)))
        ..add(ltr(uri.path));
    } else if (host.startsWith('google.') && uri.path.startsWith('/maps')) {
      title = 'العنوان على الخريطة';
      final dest = (uri.queryParameters['destination'] ?? uri.queryParameters['query'] ?? '').split(',');
      children.addAll([
        DemoMapCard(lat: double.tryParse(dest.first), lng: dest.length > 1 ? double.tryParse(dest[1]) : null),
        const SizedBox(height: 8),
        const Text(
          'في التطبيق الحقيقي الزرار ده بيفتح خرائط Google بالاتجاهات لحد باب الزبون.',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ]);
    } else {
      title = 'رابط خارجي';
      children
        ..add(const Text('الرابط ده بيفتح برّه التطبيق:', style: TextStyle(color: Colors.black54)))
        ..add(ltr(uri.toString(), style: const TextStyle(fontSize: 12)));
    }

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(title)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)),
            child: const Text('نسخة تجريبية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('تمام'))],
    );
  }
}

/// A drawn placeholder map (no maps API, no tiles): streets, the Nile, a
/// park and a pin — for showing a customer's address in recordings.
class DemoMapCard extends StatelessWidget {
  const DemoMapCard({super.key, this.lat, this.lng, this.height = 220});
  final double? lat;
  final double? lng;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _MapPainter()),
            const Align(
              alignment: Alignment(0, -0.12),
              child: Icon(Icons.location_on_rounded, size: 46, color: Color(0xFFD93025)),
            ),
            if (lat != null && lng != null)
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    '${lat!.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}',
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),
              ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                child: const Text('خريطة توضيحية', style: TextStyle(fontSize: 11, color: Colors.black54)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF1EEE8));
    // Blocks of buildings.
    final block = Paint()..color = const Color(0xFFE4DFD6);
    for (var x = 0.0; x < w; x += 70) {
      for (var y = 0.0; y < h; y += 56) {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 8, y + 8, 52, 38), const Radius.circular(4)), block);
      }
    }
    // A park.
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.62, h * 0.08, w * 0.22, h * 0.3), const Radius.circular(10)), Paint()..color = const Color(0xFFCDE8C5));
    // The Nile.
    final river = Path()
      ..moveTo(w * 0.08, 0)
      ..cubicTo(w * 0.18, h * 0.35, w * 0.02, h * 0.65, w * 0.14, h)
      ..lineTo(w * 0.24, h)
      ..cubicTo(w * 0.12, h * 0.65, w * 0.28, h * 0.35, w * 0.18, 0)
      ..close();
    canvas.drawPath(river, Paint()..color = const Color(0xFFAADAFF));
    // Streets.
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final main = Paint()
      ..color = const Color(0xFFFFE08A)
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    for (var x = 4.0; x < w; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), road);
    }
    for (var y = 4.0; y < h; y += 56) {
      canvas.drawLine(Offset(0, y), Offset(w, y), road);
    }
    canvas.drawLine(Offset(w * 0.3, h), Offset(w, h * 0.42), main);
    // Route to the pin.
    final route = Paint()
      ..color = const Color(0xFF1A73E8)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.3, h)
        ..lineTo(w * 0.55, h * 0.78)
        ..lineTo(w * 0.5, h * 0.48),
      route,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
