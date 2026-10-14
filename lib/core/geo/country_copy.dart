/// Country-aware bits of user-facing copy (Arab-world phase 5): what used to
/// say «في مصر» now names the user's country, and the Egypt-only features
/// (wallet, top-ups, bill payment) say so to everyone else.
library;

import 'arab_countries.dart';

/// «مصر», «السعودية»… — Egypt for an unknown code.
String countryNameAr(String? iso) => (arabCountry(iso) ?? egypt).nameAr;

/// «في مصر», «في السعودية»…
String inCountryAr(String? iso) => 'في ${countryNameAr(iso)}';

/// The wallet, top-ups, withdrawals and bill payment run on Egyptian
/// payment rails (manual Vodafone Cash / InstaPay transfers, Fawry later),
/// so they're offered in Egypt only for now.
bool walletAvailableIn(String? iso) => (iso ?? 'EG').toUpperCase() == 'EG';

/// Shown instead of the wallet's payment actions outside Egypt.
const walletEgyptOnlyNote = 'المحفظة والدفع الإلكتروني متاحين في مصر بس حالياً — في بلدك الدفع كاش أو بالاتفاق';
