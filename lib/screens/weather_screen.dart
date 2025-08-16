import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../data/weather_repository.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/detail_info_card.dart';
import '../widgets/city_search_button.dart';
import '../theme/app_theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherRepository _wRepo = WeatherRepository();
  final LocationService _locService = LocationService();
  Future<Weather>? _wFuture;

  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadWeatherByLocation();
  }

  Future<void> _loadWeatherByLocation() async {
    final pos = await _locService.getCurrentLocation();
    setState(() {
      _wFuture = _wRepo.fetchWeatherByLocation(pos.latitude, pos.longitude);
    });
  }

  void _searchCity(String city) {
    setState(() {
      _wFuture = _wRepo.fetchWeatherByCity(city);
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: _themeMode,
      home: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: _themeMode == ThemeMode.dark
                ? const LinearGradient(
                    colors: [Color(0xff2E335A), Color(0xff1C1B33)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [Colors.grey[100]!, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Hava Durumu"),
              leading: IconButton(
                icon: Icon(
                  _themeMode == ThemeMode.dark
                      ? Icons.wb_sunny
                      : Icons.nightlight_round,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: _toggleTheme,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: _loadWeatherByLocation,
                ),
                CitySearchButton(onCitySelected: _searchCity),
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
                        _buildHourlyForecast(context, weather.hourlyForecasts),
                        const SizedBox(height: 30),
                        _buildDailyForecast(context, weather.dailyForecasts),
                      ],
                    ).animate().fadeIn(duration: 800.ms),
                  );
                }
                return const Center(child: Text("Veri bekleniyor..."));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGrid(Weather weather) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
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

  Widget _buildDailyForecast(
    BuildContext context,
    List<DailyForecast> dailyForecasts,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, "Haftalık Tahmin"),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: dailyForecasts.length,
          itemBuilder: (context, index) {
            final forecast = dailyForecasts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: isDark ? null : Colors.blueGrey[50],
              child: ListTile(
                leading: Lottie.asset(
                  forecast.lottieAsset,
                  width: 45,
                  height: 45,
                ),
                title: Text(
                  forecast.day,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Text(
                  "${forecast.highTemp}/ ${forecast.lowTemp}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: -0.5);
          },
        ),
      ],
    );
  }

  Widget _buildHourlyForecast(
    BuildContext context,
    List<HourlyForecast> hourlyForecasts,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, "Saatlik Tahmin"),
        SizedBox(
          height: 140.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecasts.length,
            itemBuilder: (context, index) {
              final forecast = hourlyForecasts[index];
              return Card(
                color: isDark ? null : Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        forecast.time,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Lottie.asset(forecast.lottieAsset, width: 50, height: 50),
                      Text(
                        forecast.temperature,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
