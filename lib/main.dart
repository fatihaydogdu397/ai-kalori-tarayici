import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';
import 'services/app_provider.dart';
import 'services/purchase_service.dart';
import 'screens/getting_started_screen.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';
import 'widgets/keyboard_dismisser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Root navigator — AppProvider.authLogout uses this to kick the user back
/// to AuthScreen when the refresh-token flow also fails.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env optional — compile-time --dart-define still works as fallback.
  }

  // iOS keychain app silinince temizlenmez; reinstall sonrası eski token
  // hayalet oturum açar. SharedPreferences ise app silinince gider — ilk
  // açılışta marker yoksa fresh install say, secure storage'ı temizle.
  final prefs = await SharedPreferences.getInstance();
  if (!(prefs.getBool('install_marker') ?? false)) {
    try {
      await const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      ).deleteAll();
    } catch (_) {}
    await prefs.setBool('install_marker', true);
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));

  final provider = AppProvider();
  await Future.wait([provider.loadTheme(), provider.loadLocale(), provider.loadAuthStatus(), PurchaseService.init(), NotificationService.init()]);
  await provider.refreshPremiumStatus();

  await provider.loadProfile();
  await provider.loadHistory();
  await provider.loadTodayStats();

  runApp(EatiqApp(provider: provider));
}

class EatiqApp extends StatelessWidget {
  final AppProvider provider;
  const EatiqApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          bool isDark = provider.themeMode == ThemeMode.dark;
          if (provider.themeMode == ThemeMode.system) {
            isDark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
          }

          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark),
          );
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'eatiq',
                navigatorKey: rootNavigatorKey,
                debugShowCheckedModeBanner: false,
                themeMode: provider.themeMode,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                locale: provider.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('tr'),
                  Locale('en'),
                  Locale('fr'),
                  Locale('es'),
                  Locale('de'),
                  Locale('ar'),
                  Locale('pt'),
                  Locale('it'),
                  Locale('ru'),
                  Locale('ka'),
                ],
                builder: (context, child) => KeyboardDismisser(child: child ?? const SizedBox.shrink()),
                home: const GettingStartedScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
