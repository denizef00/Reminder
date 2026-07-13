import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/app/router.dart';
import 'package:reminder/app/theme.dart';
import 'package:reminder/providers/theme_provider.dart';
import 'package:reminder/services/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await NotificationServices().initNotification();
  await NotificationServices().requestPermissions();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('overflowed')) {
      return const SizedBox.shrink();
    }
    return ErrorWidget(details.exception);
  };
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeProvider);
    final currentThemeMode = themeAsync.value ?? ThemeMode.light;
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('en', 'GB')],
      routerConfig: router,
      debugShowCheckedModeBanner: false,

      themeMode: currentThemeMode,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
