class Weather {
  final String cityName;
  final String temperature;
  final String description;
  final String iconCode;
  final String humidity;
  final String windSpeed;
  final String pressure;
  final String currentLottieAsset;
  final List<DailyForecast> dailyForecasts;
  final List<HourlyForecast> hourlyForecasts;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.currentLottieAsset,
    required this.dailyForecasts,
    required this.hourlyForecasts,
  });
}

class DailyForecast {
  final String day;
  final String lottieAsset;
  final String highTemp;
  final String lowTemp;

  DailyForecast({
    required this.day,
    required this.lottieAsset,
    required this.highTemp,
    required this.lowTemp,
  });
}

class HourlyForecast {
  final String time;
  final String lottieAsset;
  final String temperature;

  HourlyForecast({
    required this.time,
    required this.lottieAsset,
    required this.temperature,
  });
}
