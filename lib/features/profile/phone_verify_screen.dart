import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/geo/phones.dart';
import '../../core/geo/user_country.dart';
import '../../core/phone/phone_verify.dart';
import '../../core/theme/app_colors.dart';

/// "أكّد رقمك": send an SMS code to the number, type it back, and the number
/// is saved on the profile as verified. Pops `true` on success.
class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({super.key, this.initialPhone});

  final String? initialPhone;

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  late final _phone = TextEditingController(text: widget.initialPhone ?? '');
  final _code = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  /// SMS codes go to Egyptian numbers only (Firebase cost — 0089): 01…
  /// in any form (+20…, 0020…, Arabic-Indic digits); null otherwise.
  String? get _normalisedPhone {
    final p = storePhone(_phone.text, country: 'EG');
    return p != null && isEgyptianPhone(p) ? p : null;
  }

  Future<void> _send() async {
    final phone = _normalisedPhone;
    if (phone == null) {
      setState(() => _error = isValidPhone(_phone.text, country: UserCountry.iso.value)
          ? 'التأكيد برسالة متاح لأرقام مصر بس حالياً — في باقي الدول مش محتاج تأكّد رقمك'
          : invalidPhoneMessage);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final problem = await PhoneVerify.sendCode(phone);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = problem;
      if (problem == null) _codeSent = true;
    });
  }

  Future<void> _confirm() async {
    if (_code.text.trim().length != 6) {
      setState(() => _error = 'الكود 6 أرقام');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final problem = await PhoneVerify.confirm(_code.text.trim());
    if (!mounted) return;
    if (problem == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تأكيد رقمك ✓')));
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _busy = false;
      _error = problem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('أكّد رقم موبايلك')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.verified_user_rounded, size: 56, color: AppColors.teal),
          const SizedBox(height: 12),
          const Text(
            'هنبعتلك رسالة فيها كود من 6 أرقام. الرقم المتأكد بيبان لجيرانك وللمحلات إنه موثّق، '
            'ومحدش غيرك يقدر يستخدمه.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.inkSecondary, height: 1.6),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _phone,
            enabled: !_codeSent && !_busy,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(labelText: 'رقم الموبايل', hintText: '01012345678', prefixIcon: Icon(Icons.phone_outlined)),
          ),
          if (_codeSent) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              enabled: !_busy,
              autofocus: true,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(labelText: 'الكود اللي وصلك', counterText: ''),
              onSubmitted: (_) => _confirm(),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
            ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _busy ? null : (_codeSent ? _confirm : _send),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              child: _busy
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(_codeSent ? 'تأكيد' : 'ابعت الكود'),
            ),
          ),
          if (_codeSent)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                        _codeSent = false;
                        _code.clear();
                        _error = null;
                      }),
              child: const Text('غيّر الرقم أو ابعت كود تاني'),
            ),
        ],
      ),
    );
  }
}
