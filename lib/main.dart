import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_flavor.dart';
import 'core/auth/auth_service.dart';
import 'core/supabase/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Start loading the bundled Arabic fonts right away, alongside Supabase;
  // the HTML splash stays up until they're ready so the first frame never
  // paints text as empty boxes. Every bundled weight is listed: the Material
  // text styles use Medium (w500), so leaving one out shows boxes briefly.
  final fonts = GoogleFonts.pendingFonts([
    for (final w in [FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700])
      GoogleFonts.ibmPlexSansArabic(fontWeight: w),
    for (final w in [FontWeight.w400, FontWeight.w700, FontWeight.w800]) GoogleFonts.almarai(fontWeight: w),
  ]).timeout(const Duration(seconds: 15)).catchError((_) => const <void>[]);
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  } catch (e) {
    // A stale/duplicate OAuth callback in the URL (e.g. reopening a tab
    // that still carries an already-consumed code, or a leftover
    // ?error=... from a previous failed redirect) can make session
    // recovery throw here. Failing to boot the whole app over that is
    // worse than just starting signed-out — the user can always sign
    // in again from a clean state.
    debugPrint('Supabase.initialize failed: $e');
  }
  AuthService.listenAndSyncProfile();
  await fonts;
  runApp(const MogtamayApp());
}

class MogtamayApp extends StatelessWidget {
  const MogtamayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appBrandName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.12)),
          child: child!,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
