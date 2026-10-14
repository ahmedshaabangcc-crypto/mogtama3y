import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/places/directory_service.dart';
import '../../core/places/osm_places.dart';
import '../../core/theme/app_colors.dart';

/// Opens a place from a list: ours by id; one from OpenStreetMap
/// (`osm: true`) is first added to our directory (directory_import_osm,
/// 0094) when the user is signed in, so it becomes a normal place others
/// find too. Guests (or a failed import) see it from the row itself.
Future<void> openDirectoryRow(BuildContext context, Map<String, dynamic> row) async {
  if (row['osm'] != true) {
    context.push('/d/${row['id']}', extra: row);
    return;
  }
  if (AuthService.isSignedIn) {
    try {
      final id = await DirectoryService.importOsm(row);
      if (context.mounted) context.push('/d/$id');
      return;
    } catch (e) {
      if (context.mounted && e is PostgrestException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
  if (context.mounted) context.push('/d/${row['id']}', extra: row);
}

/// «من OpenStreetMap» marker on a list tile.
class OsmBadge extends StatelessWidget {
  const OsmBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
        child: const Text('من OpenStreetMap', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
      );
}

/// «© OpenStreetMap contributors (ODbL)» under lists that show OSM places.
class OsmPlacesAttribution extends StatelessWidget {
  const OsmPlacesAttribution({super.key, this.color = AppColors.inkMuted});
  final Color color;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => launchUrl(Uri.parse(OsmPlaces.copyrightUrl), mode: LaunchMode.externalApplication),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text('بعض الأماكن من خريطة ${OsmPlaces.attribution}',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: color, decoration: TextDecoration.underline)),
        ),
      );
}
