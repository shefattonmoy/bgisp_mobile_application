import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:bgisp/api/Language/language_api.dart';
import 'package:bgisp/views/Homepage/homepage_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return MaterialApp(
          title: 'Bangladesh GIS Platform',
          locale: languageService.currentLocale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('bn', 'BD'),
          ],
          localizationsDelegates: const [// Your custom delegate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}