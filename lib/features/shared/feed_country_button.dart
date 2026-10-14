import 'package:flutter/material.dart';

import '../../core/geo/arab_countries.dart';
import '../../core/geo/user_country.dart';
import 'country_picker.dart';

/// The small flag chip of the feeds (marketplace, real estate, cars, jobs,
/// tutors, halls, pets, kids, recycling, reports, shops): shows the
/// country being browsed and lets the user browse another Arab country
/// (UserCountry.feedOverride, remembered on the device). The default is
/// the profile's country. [onChanged] reloads the feed.
class FeedCountryButton extends StatelessWidget {
  const FeedCountryButton({super.key, required this.onChanged});
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: UserCountry.feedOverrideNotifier,
      builder: (context, override, _) {
        final c = arabCountry(UserCountry.feedCountry) ?? egypt;
        final other = override != null;
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: Tooltip(
            message: 'تصفّح بلد تاني',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => pickFeedCountry(context, onChanged),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: other ? Theme.of(context).colorScheme.primary : const Color(0x22000000)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c.flag, style: const TextStyle(fontSize: 16)),
                    if (other) ...[
                      const SizedBox(width: 4),
                      Text(c.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                    const Icon(Icons.arrow_drop_down_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Opens the country sheet; the user's own country clears the override.
Future<void> pickFeedCountry(BuildContext context, VoidCallback onChanged) async {
  final iso = await showCountryPicker(context, selected: UserCountry.feedCountry);
  if (iso == null || iso == UserCountry.feedCountry) return;
  UserCountry.feedOverride = iso;
  onChanged();
}
