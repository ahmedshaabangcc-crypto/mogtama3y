import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/auth/auth_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../promote/token_wallet_screen.dart';
import '../wallet/wallet_screen.dart';

/// Real profile page — there was previously no profile screen anywhere
/// in the app at all; tapping the profile icon on the home screen did
/// nothing. Shows/edits the real `profiles` row and lets the user
/// upload a real avatar (see backend/migrations/0027_storage_and_verification.sql).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  Map<String, dynamic>? _profile;
  bool _editing = false;
  bool _saving = false;
  bool _uploadingAvatar = false;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final profile = await AuthService.fetchCurrentProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _nameCtrl.text = profile?['full_name'] as String? ?? '';
      _phoneCtrl.text = profile?['phone'] as String? ?? '';
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await AuthService.updateProfile(fullName: _nameCtrl.text.trim(), phone: _phoneCtrl.text.trim());
      if (!mounted) return;
      setState(() => _editing = false);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر حفظ التعديلات، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changeAvatar() async {
    final file = await UploadService.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => _uploadingAvatar = true);
    try {
      final url = await UploadService.uploadPublicPhoto(purpose: 'avatar', file: file);
      await AuthService.updateProfile(avatarUrl: url);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع الصورة، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('تسجيل الخروج')),
        ],
      ),
    );
    if (confirmed == true) {
      await AuthService.signOut();
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final avatarUrl = _profile?['avatar_url'] as String?;
    final isVerified = _profile?['is_verified'] == true;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('حسابي'),
        actions: [
          if (!_editing)
            IconButton(onPressed: () => setState(() => _editing = true), icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.surfaceAlt,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null ? const Icon(Icons.person_rounded, size: 44, color: AppColors.inkMuted) : null,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: _uploadingAvatar ? null : _changeAvatar,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                      child: _uploadingAvatar
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_editing) ...[
            const _FieldLabel('الاسم بالكامل'),
            const SizedBox(height: 6),
            _EditableField(controller: _nameCtrl),
            const SizedBox(height: 14),
            const _FieldLabel('رقم الهاتف'),
            const SizedBox(height: 6),
            _EditableField(controller: _phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ التعديلات'),
              ),
            ),
          ] else ...[
            Center(
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_profile?['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  if (isVerified) const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.verified_rounded, color: AppColors.teal, size: 18)),
                ]),
                const SizedBox(height: 4),
                Text(_profile?['phone'] as String? ?? 'لا يوجد رقم هاتف مسجّل', style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
              ]),
            ),
            const SizedBox(height: 28),
            _MenuTile(icon: Icons.account_balance_wallet_outlined, label: 'المحفظة', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalletScreen()))),
            const SizedBox(height: 10),
            _MenuTile(icon: Icons.toll_outlined, label: 'رصيد توكن الإعلانات المميزة', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TokenWalletScreen()))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _signOut,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: AppColors.border)),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('تسجيل الخروج'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary));
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({required this.controller, this.keyboardType});
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 12)),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Icon(icon, color: AppColors.inkSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
        ]),
      ),
    );
  }
}
