import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Weather weather;
  const CurrentWeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weather.cityName, style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox(height: 8.0,),
        Lottie.asset(
          weather.currentLottieAsset,
          width: 150.0,
          height: 150.0,
        ),
        const SizedBox(height: 8.0,),
        Text(weather.temperature, style: Theme.of(context).textTheme.displayLarge,),
        Text(weather.description, style: Theme.of(context).textTheme.displayMedium,),
      ],
    );
  }
}
