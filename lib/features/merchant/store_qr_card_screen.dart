import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/shops/print_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_logo.dart';

/// «تحميل / طباعة الـ QR»: the shop's printable A5 card — shop name, the
/// store QR (`mogtama3y.com/#/s/<slug>`), «امسح واطلب من محلنا» and a small
/// مُجتمعي mark. Drawn once as a ~300 dpi PNG, then saved or printed on an
/// A5 page (web/print-card.js).
class StoreQrCardScreen extends StatefulWidget {
  const StoreQrCardScreen({super.key, required this.shopName, required this.slug, required this.url});
  final String shopName;
  final String slug;
  final String url;

  @override
  State<StoreQrCardScreen> createState() => _StoreQrCardScreenState();
}

class _StoreQrCardScreenState extends State<StoreQrCardScreen> {
  /// Card size in logical pixels — A5 proportions (148 × 210 mm).
  static const _cardWidth = 420.0;
  static const _cardHeight = _cardWidth * 210 / 148;
  /// A5 at 300 dpi is 1748 px wide.
  static const _targetWidthPx = 1748.0;

  final _boundaryKey = GlobalKey();
  String? _dataUrl;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    // Drawn ahead of time so «اطبع» opens the print window straight from
    // the tap (browsers block pop-ups opened after an async wait).
    WidgetsBinding.instance.addPostFrameCallback((_) => _render());
  }

  Future<void> _render() async {
    try {
      // Let the fonts settle for one more frame before capturing.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw StateError('no boundary');
      final image = await boundary.toImage(pixelRatio: _targetWidthPx / _cardWidth);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) throw StateError('no bytes');
      if (!mounted) return;
      setState(() => _dataUrl = 'data:image/png;base64,${base64Encode(bytes.buffer.asUint8List())}');
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _download() {
    final url = _dataUrl;
    if (url == null) return;
    if (!downloadImage(url, 'qr-${widget.slug}.png')) _notOnThisDevice();
  }

  void _print() {
    final url = _dataUrl;
    if (url == null) return;
    if (!printA5Image(url, 'QR — ${widget.shopName}')) _notOnThisDevice();
  }

  void _notOnThisDevice() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('التحميل والطباعة شغالين من المتصفح — افتح متجري من الكمبيوتر أو الموبايل')));
  }

  @override
  Widget build(BuildContext context) {
    final ready = _dataUrl != null;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('كارت الـ QR للطباعة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('اطبعه A5 وعلّقه على واجهة المحل أو الكاشير — الزبون يمسح ويطلب على طول.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary, fontSize: 12.5, height: 1.6)),
          const SizedBox(height: 14),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardWidth),
              child: Container(
                decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 18, offset: const Offset(0, 6))]),
                child: FittedBox(
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: SizedBox(
                      width: _cardWidth,
                      height: _cardHeight,
                      child: _A5Card(shopName: widget.shopName, url: widget.url),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (_failed)
            const Text('تعذر تجهيز الصورة — جرّب تفتح الصفحة تاني', textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent))
          else if (!ready)
            const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator())),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: ready ? _print : null,
                  icon: const Icon(Icons.print_rounded),
                  label: const Text('اطبع (A5)', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: ready ? _download : null,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('تحميل صورة PNG'),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          const Text('في نافذة الطباعة اختار مقاس الورق A5 (أو A4 وهيتطبع في نص الصفحة).',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _A5Card extends StatelessWidget {
  const _A5Card({required this.shopName, required this.url});
  final String shopName;
  final String url;

  @override
  Widget build(BuildContext context) {
    final shortUrl = url.replaceFirst(RegExp(r'^https?://'), '');
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: const BoxDecoration(gradient: AppColors.nightGradient),
            child: Column(children: [
              const Icon(Icons.storefront_rounded, color: AppColors.gold, size: 28),
              const SizedBox(height: 8),
              Text(
                shopName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, height: 1.3),
              ),
            ]),
          ),
          const SizedBox(height: 22),
          const Text('امسح واطلب من محلنا', style: TextStyle(color: AppColors.night, fontSize: 27, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('اطلب أونلاين والدفع عند الاستلام', style: TextStyle(color: AppColors.inkSecondary, fontSize: 14)),
          const SizedBox(height: 16),
          Container(
            width: 230,
            height: 230,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold, width: 4),
            ),
            child: QrImageView(
              data: url,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.night),
              dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.night),
            ),
          ),
          const SizedBox(height: 12),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(shortUrl, style: const TextStyle(color: AppColors.crystal, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MogtamayLogo(size: 26),
                SizedBox(width: 8),
                Text('مُجتمعي', style: TextStyle(color: AppColors.night, fontSize: 15, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
