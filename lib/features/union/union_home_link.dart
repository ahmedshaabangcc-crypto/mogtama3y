import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the union site's home page (the landing with the explainers and
/// tutorial videos) in this tab, without signing out. `?home=1` makes the
/// page show itself even to a signed-in user; other query params (the
/// demo's role) are kept so the way back lands in the same state.
void openUnionHome() {
  final base = Uri.base;
  final params = {...base.queryParameters, 'home': '1'};
  final url = Uri(scheme: base.scheme, host: base.host, port: base.hasPort ? base.port : null, path: '/', queryParameters: params);
  launchUrl(url, webOnlyWindowName: '_self');
}

/// «اتحاد الملاك» with the app icon — tap to open the union home page.
class UnionHomeTitle extends StatelessWidget {
  const UnionHomeTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: openUnionHome,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // The site's own icon (served next to index.html in every build).
            child: Image.network(Uri.base.resolve('/icons/Icon-192.png').toString(), width: 28, height: 28, errorBuilder: (_, _, _) => const Icon(Icons.home_work_rounded, size: 24)),
          ),
          const SizedBox(width: 8),
          Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}
