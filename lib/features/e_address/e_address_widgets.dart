import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/e_address/e_address_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';

/// The night-glass "address card": label, MG code, QR and the address line.
/// Used on the owner's card screen (with QR) and in their list (compact).
class EAddressCard extends StatelessWidget {
  const EAddressCard({super.key, required this.address, this.showQr = true, this.onTap});
  final Map<String, dynamic> address;
  final bool showQr;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final code = address['code'] as String;
    final active = address['is_active'] as bool? ?? true;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [BoxShadow(color: AppColors.night.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(address['label'] as String? ?? 'عنواني',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                  if (!active)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(100)),
                      child: const Text('متوقف', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                ]),
                const SizedBox(height: 12),
                if (showQr) ...[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                      child: QrImageView(
                        data: EAddressService.linkFor(code),
                        size: 190,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: AppColors.night),
                        dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: AppColors.night),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    EAddressService.display(code),
                    textAlign: showQr ? TextAlign.center : TextAlign.right,
                    style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 2),
                  ),
                ),
                if (address['handle'] != null) ...[
                  const SizedBox(height: 4),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      'mogtama3y.com/#/a/${address['handle']}',
                      textAlign: showQr ? TextAlign.center : TextAlign.right,
                      style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
                if (address['phone_lookup'] == true) ...[
                  const SizedBox(height: 4),
                  Text('بيتفتح كمان برقم موبايلك',
                      textAlign: showQr ? TextAlign.center : TextAlign.start,
                      style: const TextStyle(color: Colors.white60, fontSize: 11.5)),
                ],
                const SizedBox(height: 8),
                Text(
                  EAddressService.oneLine(address),
                  textAlign: showQr ? TextAlign.center : TextAlign.start,
                  maxLines: showQr ? 4 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Night banner explaining the idea — top of the owner's list.
class EAddressIntro extends StatelessWidget {
  const EAddressIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: AppColors.nightGradient, borderRadius: BorderRadius.circular(24)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.qr_code_2_rounded, color: AppColors.gold, size: 26),
            SizedBox(width: 8),
            Text('عنوانك الإلكتروني', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
          ]),
          SizedBox(height: 8),
          Text(
            'سجّل عنوانك مرة واحدة بالتفصيل وبالموقع على الخريطة، وخد كود وQR تبعتهم لأي حد: '
            'الدليفري، الضيوف، الفني أو الدكتور. يفتح اللينك ويوصلك على طول من غير ما توصف الطريق.',
            style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.7),
          ),
        ],
      ),
    );
  }
}

/// "عندك عنوان حد؟" — open an address by its easy name, mobile number or code.
class EAddressLookupBox extends StatefulWidget {
  const EAddressLookupBox({super.key, this.dark = false});

  /// Night-glass single-line bar for the home header.
  final bool dark;

  @override
  State<EAddressLookupBox> createState() => _EAddressLookupBoxState();
}

class _EAddressLookupBoxState extends State<EAddressLookupBox> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _go() {
    var q = _c.text.trim().replaceAll(RegExp(r'[\s+]'), '');
    if (q.startsWith('mogtama3y.com/#/a/')) q = q.substring('mogtama3y.com/#/a/'.length);
    q = q.replaceAll(RegExp(r'^https?://mogtama3y\.com/#/a/'), '');
    if (!RegExp(r'^[A-Za-z0-9-]{4,30}$').hasMatch(q)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب اسم العنوان أو رقم الموبايل أو الكود')));
      return;
    }
    context.push(AppRoutes.eAddress(q));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dark) return _darkBar();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('عندك عنوان حد؟', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _c,
              textDirection: TextDirection.ltr,
              autocorrect: false,
              onSubmitted: (_) => _go(),
              decoration: const InputDecoration(hintText: 'ahmed-maadi أو 010… أو MG-…', isDense: true),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(onPressed: _go, icon: const Icon(Icons.search_rounded)),
        ]),
      ]),
    );
  }

  Widget _darkBar() {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 4, 4),
      decoration: BoxDecoration(
        color: AppColors.night.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(children: [
        const Icon(Icons.travel_explore_rounded, color: AppColors.gold, size: 19),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _c,
            autocorrect: false,
            onSubmitted: (_) => _go(),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            cursorColor: AppColors.gold,
            decoration: const InputDecoration(
              filled: false,
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'دوّر على عنوان: الاسم أو الموبايل أو الكود',
              hintStyle: TextStyle(color: Colors.white54, fontSize: 12.5),
            ),
          ),
        ),
        IconButton(
          onPressed: _go,
          style: IconButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
          icon: const Icon(Icons.search_rounded, size: 20),
        ),
      ]),
    );
  }
}

/// Home-header search: "دوّر على عنوان".
class EAddressSearchBar extends StatelessWidget {
  const EAddressSearchBar({super.key});

  @override
  Widget build(BuildContext context) => const EAddressLookupBox(dark: true);
}
