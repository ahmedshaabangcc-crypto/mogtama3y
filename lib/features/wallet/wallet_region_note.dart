import 'package:flutter/material.dart';

import '../../core/geo/country_copy.dart';
import '../../core/geo/user_country.dart';
import '../../core/theme/app_colors.dart';

/// Whether the signed-in user (or the device guess) can use the wallet,
/// top-ups, withdrawals and bill payment — Egypt only for now.
bool get walletAvailableHere => walletAvailableIn(UserCountry.iso.value);

/// The «Egypt only for now» banner shown in place of payment actions.
class WalletRegionNote extends StatelessWidget {
  const WalletRegionNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.gold, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(walletEgyptOnlyNote, style: TextStyle(fontSize: 12.5, height: 1.7, color: AppColors.ink, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// A whole screen with just the note — for payment screens reached from
/// outside Egypt (old links, the union shell…).
class WalletRegionScreen extends StatelessWidget {
  const WalletRegionScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(title)),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Align(alignment: Alignment.topCenter, child: WalletRegionNote()),
      ),
    );
  }
}
