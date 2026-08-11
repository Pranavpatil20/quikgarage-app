import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/locale_provider.dart';
import 'firebase_options.dart';
import 'l10n/app_strings.dart';
import 'router/app_router.dart';
import 'services/fcm_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (DefaultFirebaseOptions.isConfigured) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } else {
    debugPrint(
      'Firebase not configured — using dev login. Run: flutterfire configure',
    );
  }

  runApp(const ProviderScope(child: QuikGarageApp()));
}

class QuikGarageApp extends ConsumerStatefulWidget {
  const QuikGarageApp({super.key});

  @override
  ConsumerState<QuikGarageApp> createState() => _QuikGarageAppState();
}

class _QuikGarageAppState extends ConsumerState<QuikGarageApp> {
  @override
  void initState() {
    super.initState();
    if (DefaultFirebaseOptions.isConfigured) {
      Future.microtask(() => ref.read(fcmServiceProvider).initialize());
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final appThemeMode = ref.watch(themeModeProvider);
    final appLanguage = ref.watch(localeProvider);
    final strings = AppStrings(appLanguage);

    return AppStringsScope(
      strings: strings,
      child: MaterialApp.router(
        title: 'QuikGarage',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeAnimationDuration: Duration.zero,
        themeMode: switch (appThemeMode) {
          AppThemeMode.dark => ThemeMode.dark,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.system => ThemeMode.system,
        },
        locale: appLanguage.locale,
        supportedLocales: AppLanguage.values.map((e) => e.locale).toList(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
