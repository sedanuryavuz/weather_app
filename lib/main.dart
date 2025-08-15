import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/features/splash/splash_screen.dart';
import 'package:weather_app/theme/app_theme.dart';

void main() {
  // App bar'ın sistem ikonlarıyla uyumlu olması için
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu App',
      theme: appTheme(), 
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
