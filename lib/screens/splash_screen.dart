import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/screens/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WeatherScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors:  [Color(0xff2E335A), Color(0xff1C1B33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Lottie.asset(
            "assets/lottie/weather-loading.json",
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
