import 'package:url_launcher/url_launcher.dart';

/// Opens the device's Google Maps (app if installed, else web) with
/// turn-by-turn directions to [lat]/[lng] — deliberately never an
/// embedded in-app map, per Ahmed's explicit call: no visual map inside
/// مُجتمعي itself, directions always hand off to Google Maps.
Future<void> openDirections({required double lat, required double lng}) {
  return launchUrl(
    Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
    mode: LaunchMode.externalApplication,
  );
}
