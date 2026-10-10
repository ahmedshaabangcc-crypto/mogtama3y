import 'package:flutter/material.dart';

import '../../core/masjid_tools/world_cities.dart';

/// «اختار مدينتك» — Egypt and the world's main cities, with a search box.
Future<PickCity?> pickCity(BuildContext context) => showModalBottomSheet<PickCity>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _CitySheet(),
    );

class _CitySheet extends StatefulWidget {
  const _CitySheet();

  @override
  State<_CitySheet> createState() => _CitySheetState();
}

class _CitySheetState extends State<_CitySheet> {
  final _all = pickerCities();
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final list = searchCities(_all, _q);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(children: [
          const ListTile(title: Text('اختار مدينتك', style: TextStyle(fontWeight: FontWeight.w800))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: false,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'دوّر على مدينة أو بلد…'),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) => ListTile(title: Text(list[i].label), onTap: () => Navigator.pop(ctx, list[i])),
            ),
          ),
        ]),
      ),
    );
  }
}
