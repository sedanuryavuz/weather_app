import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  Future<Weather> fetchWeather() async {
    return Future.delayed(const Duration(seconds: 1), () {
      const String sunny = 'assets/lottie/sunny.json';
      const String cloudy = 'assets/lottie/cloudy.json';
      const String storm = 'assets/lottie/storm.json';
      const String rain = 'assets/lottie/rain.json';

      final daily = [
        DailyForecast(
          day: "Pazartesi",
          lottieAsset: sunny,
          highTemp: "30°",
          lowTemp: "22°",
        ),
        DailyForecast(
          day: "Salı",
          lottieAsset: cloudy,
          highTemp: "30°",
          lowTemp: "22°",
        ),
        DailyForecast(
          day: "Çarşamba",
          lottieAsset: sunny,
          highTemp: "30°",
          lowTemp: "22°",
        ),
        DailyForecast(
          day: "Perşembe",
          lottieAsset: sunny,
          highTemp: "30°",
          lowTemp: "22°",
        ),
        DailyForecast(
          day: "Cuma",
          lottieAsset: storm,
          highTemp: "30°",
          lowTemp: "22°",
        ),
        DailyForecast(
          day: "Cumartesi",
          lottieAsset: rain,
          highTemp: "30°",
          lowTemp: "22°",
        ),
        DailyForecast(
          day: "Pazar",
          lottieAsset: rain,
          highTemp: "30°",
          lowTemp: "22°",
        ),
      ];

      final hourly = [
        HourlyForecast(time: "12:00", lottieAsset: sunny, temperature: "25°"),
        HourlyForecast(time: "13:00", lottieAsset: cloudy, temperature: "20°"),
        HourlyForecast(time: "14:00", lottieAsset: sunny, temperature: "25°"),
        HourlyForecast(time: "15:00", lottieAsset: storm, temperature: "22°"),
        HourlyForecast(time: "16:00", lottieAsset: rain, temperature: "25°"),
      ];

      return Weather(
        cityName: "İstanbul",
        temperature: "25°",
        description: "Parçalı Bulutlu",
        currentLottieAsset: cloudy,
        humidity: "65%",
        windSpeed: "15 km/s",
        pressure: "1012 hPa",
        hourlyForecasts: hourly,
        dailyForecasts: daily,
      );
    });
  }
}
