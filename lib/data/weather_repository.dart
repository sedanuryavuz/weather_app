import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  final String apiKey = dotenv.env["API_KEY"] ?? "";

  static const List<String> weekdays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  Future<Weather> fetchWeatherByCity(String cityName) async {
    final urlCurrent =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=7&aqi=no&alerts=no&lang=tr";
    final currentWeather = await _fetchCurrentWeather(urlCurrent);
    return _parseWeather(currentWeather);
  }

  Future<Weather> fetchWeatherByLocation(double lat, double lon) async {
    final urlCurrent =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=7&aqi=no&alerts=no&lang=tr";
    final currentWeather = await _fetchCurrentWeather(urlCurrent);
    return _parseWeather(currentWeather);
  }

  Future<Map<String, dynamic>> _fetchCurrentWeather(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Hava durumu alınamadı: ${response.body}");
    }
    return json.decode(response.body);
  }

  Weather _parseWeather(Map<String, dynamic> data) {
    final current = data['current'];
    final location = data['location'];

    final dailyForecasts = (data['forecast']['forecastday'] as List).map((day) {
      final date = DateTime.parse(day['date']);
      return DailyForecast(
        day: weekdays[date.weekday - 1],
        lottieAsset: _mapIconToLottie(day['day']['condition']['icon']),
        highTemp: "${day['day']['maxtemp_c'].toStringAsFixed(0)}°",
        lowTemp: "${day['day']['mintemp_c'].toStringAsFixed(0)}°",
      );
    }).toList();

    final hourlyForecasts = (data['forecast']['forecastday'][0]['hour'] as List)
        .map((hour) {
          final dt = DateTime.parse(hour['time']);
          final time =
              "${dt.hour.toString().padLeft(2, '0')}:00"; //24 saat formatı
          return HourlyForecast(
            time: time,
            lottieAsset: _mapIconToLottie(hour['condition']['icon']),
            temperature: "${hour['temp_c'].toStringAsFixed(0)}°",
          );
        })
        .toList();

    return Weather(
      cityName: location['name'],
      temperature: "${current['temp_c'].toStringAsFixed(0)}°",
      description: current['condition']['text'],
      iconCode: current['condition']['icon'],
      humidity: "${current['humidity']}%",
      windSpeed: "${current['wind_kph'].toStringAsFixed(1)} km/s",
      pressure: "${current['pressure_mb']} hPa",
      currentLottieAsset: _mapIconToLottie(current['condition']['icon']),
      dailyForecasts: dailyForecasts,
      hourlyForecasts: hourlyForecasts,
    );
  }

  String _mapIconToLottie(String iconUrl) {
    final fileName = iconUrl.split('/').last;
    switch (fileName) {
      case '113.png':
        return "assets/lottie/sunny.json";
      case '116.png':
      case '119.png':
      case '122.png':
        return "assets/lottie/cloudy.json";
      case '176.png':
      case '293.png':
      case '296.png':
      case '299.png':
      case '302.png':
      case '305.png':
        return "assets/lottie/rain.json";
      case '386.png':
      case '389.png':
        return "assets/lottie/storm.json";
      default:
        return "assets/lottie/cloudy.json";
    }
  }

  Future<List<String>> searchCities(String query) async {
    if (query.isEmpty) return [];
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/search.json?key=$apiKey&q=$query',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<String>((city) => city['name'] as String).toList();
    } else {
      throw Exception("Şehirler yüklenirken bir hata oluştu.");
    }
  }
}
