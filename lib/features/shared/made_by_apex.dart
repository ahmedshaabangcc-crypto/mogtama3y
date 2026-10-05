import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// "تصميم وتنفيذ Get Apex" credit with a link to the studio's site.
class MadeByApex extends StatelessWidget {
  const MadeByApex({super.key, this.dark = true});

  /// On the night background (white text) or on a light page.
  final bool dark;

  static final _url = Uri.parse('https://getapex.tech');

  @override
  Widget build(BuildContext context) {
    final muted = dark ? Colors.white54 : Colors.black45;
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => launchUrl(_url, webOnlyWindowName: '_blank'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: 'تصميم وتنفيذ ', style: TextStyle(color: muted)),
              TextSpan(
                text: 'Get Apex',
                style: TextStyle(color: dark ? const Color(0xFFF2B661) : const Color(0xFF1E3366), fontWeight: FontWeight.w800),
              ),
              TextSpan(text: '  •  getapex.tech', style: TextStyle(color: muted)),
            ]),
            style: const TextStyle(fontSize: 12),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
