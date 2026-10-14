import 'package:flutter/material.dart';

import '../../core/geo/arab_countries.dart';

/// Bottom sheet listing the 22 Arab states (flag + Arabic name, and the
/// dial code when [showDial]); returns the picked ISO code or null.
Future<String?> showCountryPicker(BuildContext context, {String? selected, bool showDial = false}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _CountrySheet(selected: selected, showDial: showDial),
  );
}

class _CountrySheet extends StatefulWidget {
  const _CountrySheet({required this.selected, required this.showDial});
  final String? selected;
  final bool showDial;

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim();
    final list = arabCountries
        .where((c) => q.isEmpty || c.nameAr.contains(q) || c.dial.startsWith(q.replaceAll('+', '')) || c.iso.toLowerCase() == q.toLowerCase())
        .toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'ابحث عن دولة', isDense: true),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final c = list[i];
                  return ListTile(
                    leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                    title: Text(c.nameAr),
                    trailing: widget.showDial
                        ? Text(c.dialPlus, textDirection: TextDirection.ltr, style: const TextStyle(fontWeight: FontWeight.w600))
                        : (c.iso == widget.selected ? const Icon(Icons.check_rounded) : null),
                    selected: c.iso == widget.selected,
                    onTap: () => Navigator.of(context).pop(c.iso),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tappable «🇪🇬 مصر ▾» tile that opens [showCountryPicker].
class CountryPickerTile extends StatelessWidget {
  const CountryPickerTile({super.key, required this.value, required this.onChanged, this.label = 'الدولة'});
  final String value;
  final ValueChanged<String> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = arabCountry(value) ?? egypt;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      subtitle: Text(c.nameAr, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: const Icon(Icons.expand_more_rounded),
      onTap: () async {
        final iso = await showCountryPicker(context, selected: value);
        if (iso != null && iso != value) onChanged(iso);
      },
    );
  }
}
