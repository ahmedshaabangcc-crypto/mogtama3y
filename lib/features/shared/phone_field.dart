import 'package:flutter/material.dart';

import '../../core/geo/arab_countries.dart';
import '../../core/geo/phones.dart';
import '../../core/geo/user_country.dart';
import 'country_picker.dart';

/// A text controller for a phone field that also remembers the picked
/// country (default: the user's country). `text` is what the user typed;
/// [stored] / [e164] are the normalised values (null when invalid).
class PhoneController extends TextEditingController {
  PhoneController({String? phone, String? country}) : country = ValueNotifier(country ?? UserCountry.iso.value) {
    if (phone != null) setPhone(phone);
  }

  final ValueNotifier<String> country;

  /// Pre-fills from a stored value («01…» or «+9665…»): picks its country
  /// and shows the national form. Unparseable values are shown as-is.
  void setPhone(String? phone) {
    final s = splitPhone(phone);
    if (s == null) {
      text = phone ?? '';
      return;
    }
    if (s.country.isNotEmpty) country.value = s.country;
    text = s.national;
  }

  String? get e164 => normalizePhone(text, country: country.value);

  /// The form the backend stores (01… for Egypt, else E.164).
  String? get stored => storePhone(text, country: country.value);

  bool get isEmpty => text.trim().isEmpty;

  @override
  void dispose() {
    country.dispose();
    super.dispose();
  }
}

/// Validator for a [PhoneController] field.
FormFieldValidator<String> phoneValidator(PhoneController c, {bool required = true, String message = invalidPhoneMessage}) {
  return (v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return required ? message : null;
    return isValidPhone(t, country: c.country.value) ? null : message;
  };
}

/// Phone field with a «🇪🇬 +20 ▾» dial-code prefix; the hint follows the
/// picked country. Use with a [PhoneController].
class PhoneFormField extends StatelessWidget {
  const PhoneFormField({
    super.key,
    required this.controller,
    this.decoration,
    this.labelText,
    this.helperText,
    this.required = true,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  final PhoneController controller;
  final InputDecoration? decoration;
  final String? labelText;
  final String? helperText;
  final bool required;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.country,
      builder: (context, iso, _) {
        final c = arabCountry(iso) ?? egypt;
        final prefix = InkWell(
          onTap: !enabled
              ? null
              : () async {
                  final picked = await showCountryPicker(context, selected: iso, showDial: true);
                  if (picked != null) controller.country.value = picked;
                },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(c.flag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text(c.dialPlus, textDirection: TextDirection.ltr, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Icon(Icons.arrow_drop_down_rounded, size: 18),
            ]),
          ),
        );
        final base = decoration ?? InputDecoration(labelText: labelText, helperText: helperText);
        return TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          onChanged: onChanged,
          decoration: base.copyWith(
            hintText: phoneHint(iso), // follows the picked country
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 40),
          ),
          validator: validator ?? phoneValidator(controller, required: required),
        );
      },
    );
  }
}
