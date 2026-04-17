import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'generated/app_localizations.dart';
import 'services/app_provider.dart';
import 'services/purchase_service.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

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
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
