import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/data/weather_repository.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgets/current_weather_widget.dart';
import 'package:weather_app/widgets/detail_info_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherRepository _wRepo = WeatherRepository();
  late Future<Weather> _wFuture;
  @override
  void initState() {
    super.initState();
    _wFuture = _wRepo.fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2E335A), Color(0xff1C1B33)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Hava Durumu"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _wFuture = _wRepo.fetchWeather();
                  });
                },
              ),
            ],
          ),
          body: FutureBuilder<Weather>(
            future: _wFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    "assets/lottie/weather-loading.json",
                    width: 150.0,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Bir hata oluştu : ${snapshot.error}"),
                );
              }
              if (snapshot.hasData) {
                final weather = snapshot.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CurrentWeatherWidget(weather: weather),
                      const SizedBox(height: 40),
                      _buildDetailGrid(weather),
                      const SizedBox(height: 30),
                      _buildHourlyForecast(weather.hourlyForecasts),
                      const SizedBox(height: 30),
                      _buildDailyForecast(weather.dailyForecasts),
                    ],
                  ).animate().fadeIn(duration: 800.ms),
                );
              }
              return const Center(child: Text("Veri bekleniyor..."));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGrid(Weather weather) {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      children: [
        DetailInfoCard(
          title: "Nem",
          value: weather.humidity,
          icon: Icons.water_drop_outlined,
        ),
        DetailInfoCard(
          title: "Rüzgar",
          value: weather.windSpeed,
          icon: Icons.air,
        ),
        DetailInfoCard(
          title: "Basınç",
          value: weather.pressure,
          icon: Icons.arrow_downward,
        ),
      ],
    );
  }
}

Widget _buildDailyForecast(List<DailyForecast> dailyForecasts) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionHeader("Haftalık Tahmin"),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: dailyForecasts.length,
        itemBuilder: (context, index) {
          final forecast = dailyForecasts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Lottie.asset(
                forecast.lottieAsset,
                width: 45,
                height: 45,
              ),
              title: Text(
                forecast.day,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                "${forecast.highTemp}/ ${forecast.lowTemp}",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: -0.5);
        },
      ),
    ],
  );
}

Widget _buildHourlyForecast(List<HourlyForecast> hourlyForecasts) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionHeader("Saatlik Tahmin"),
      SizedBox(
        height: 140.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hourlyForecasts.length,
          itemBuilder: (context, index) {
            final forecast = hourlyForecasts[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      forecast.time,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Lottie.asset(forecast.lottieAsset, width: 50, height: 50),
                    Text(
                      forecast.temperature,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.5);
          },
        ),
      ),
    ],
  );
}

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: EdgeInsetsGeometry.only(bottom: 12.0, left: 4.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
