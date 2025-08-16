import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:weather_app/theme/app_theme.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
  ));
   WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu App',
      theme: lightTheme(),
      darkTheme: darkTheme(),
       themeMode: ThemeMode.system, 
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
