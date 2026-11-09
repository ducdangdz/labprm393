import 'package:flutter/material.dart';

class CurrentWeather {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double precipitation;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      isDay: (json['is_day'] as num?)?.toInt() == 1,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final int precipitationProbability;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationProbability,
  });
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });
}

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final List<HourlyForecast> hourly;

  const WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(
      (json['current'] as Map<String, dynamic>?) ?? {},
    );

    // Parse Daily
    final dailyList = <DailyForecast>[];
    if (json['daily'] != null && json['daily'] is Map<String, dynamic>) {
      final dailyMap = json['daily'] as Map<String, dynamic>;
      final times = (dailyMap['time'] as List<dynamic>?) ?? [];
      final codes = (dailyMap['weather_code'] as List<dynamic>?) ?? [];
      final maxTemps = (dailyMap['temperature_2m_max'] as List<dynamic>?) ?? [];
      final minTemps = (dailyMap['temperature_2m_min'] as List<dynamic>?) ?? [];
      final precipProbs =
          (dailyMap['precipitation_probability_max'] as List<dynamic>?) ?? [];

      for (int i = 0; i < times.length; i++) {
        dailyList.add(
          DailyForecast(
            date: DateTime.tryParse(times[i].toString()) ??
                DateTime.now().add(Duration(days: i)),
            weatherCode: (i < codes.length) ? (codes[i] as num).toInt() : 0,
            maxTemp:
                (i < maxTemps.length) ? (maxTemps[i] as num).toDouble() : 0.0,
            minTemp:
                (i < minTemps.length) ? (minTemps[i] as num).toDouble() : 0.0,
            precipitationProbability: (i < precipProbs.length)
                ? (precipProbs[i] as num).toInt()
                : 0,
          ),
        );
      }
    }

    // Parse Hourly (take next 24 hours around current time)
    final hourlyList = <HourlyForecast>[];
    if (json['hourly'] != null && json['hourly'] is Map<String, dynamic>) {
      final hourlyMap = json['hourly'] as Map<String, dynamic>;
      final times = (hourlyMap['time'] as List<dynamic>?) ?? [];
      final temps = (hourlyMap['temperature_2m'] as List<dynamic>?) ?? [];
      final codes = (hourlyMap['weather_code'] as List<dynamic>?) ?? [];

      final now = DateTime.now();
      int startIndex = 0;
      for (int i = 0; i < times.length; i++) {
        final t = DateTime.tryParse(times[i].toString());
        if (t != null &&
            t.isAfter(now.subtract(const Duration(minutes: 59)))) {
          startIndex = i;
          break;
        }
      }

      final count = (startIndex + 24 <= times.length)
          ? 24
          : (times.length - startIndex);
      for (int i = startIndex; i < startIndex + count; i++) {
        hourlyList.add(
          HourlyForecast(
            time: DateTime.tryParse(times[i].toString()) ?? DateTime.now(),
            temperature:
                (i < temps.length) ? (temps[i] as num).toDouble() : 0.0,
            weatherCode: (i < codes.length) ? (codes[i] as num).toInt() : 0,
          ),
        );
      }
    }

    return WeatherModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'UTC',
      current: current,
      daily: dailyList,
      hourly: hourlyList,
    );
  }

  // --- Helper Getters for Purpose-Driven UX ---

  static String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Trời quang đãng, có nắng';
      case 1:
        return 'Phần lớn quang đãng';
      case 2:
        return 'Mây rải rác';
      case 3:
        return 'Trời nhiều mây, âm u';
      case 45:
      case 48:
        return 'Sương mù dày đặc';
      case 51:
      case 53:
      case 55:
        return 'Mưa phùn hạt nhỏ';
      case 56:
      case 57:
        return 'Mưa phùn giá buốt';
      case 61:
      case 63:
      case 65:
        return 'Mưa rào thường lệ';
      case 66:
      case 67:
        return 'Mưa đá lạnh buốt';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Tuyết rơi';
      case 80:
      case 81:
      case 82:
        return 'Mưa rào ngắt quãng';
      case 85:
      case 86:
        return 'Mưa rào tuyết';
      case 95:
      case 96:
      case 99:
        return 'Dông bão, sấm chớp nguy hiểm';
      default:
        return 'Thời tiết biến động';
    }
  }

  static IconData getWeatherIcon(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
      case 1:
      case 2:
        return isDay ? Icons.wb_cloudy_rounded : Icons.nights_stay_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.blur_on_rounded;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain_rounded;
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop_rounded;
      case 66:
      case 67:
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.cloud_queue_rounded;
    }
  }

  static Color getWeatherColor(int code) {
    if (code == 0) return Colors.amber;
    if (code <= 3) return Colors.lightBlue;
    if (code >= 51 && code <= 82) return Colors.indigo;
    if (code >= 95) return Colors.deepPurple;
    return Colors.teal;
  }

  /// Khuyến nghị: Có cần mang dù hay không?
  bool get needsUmbrella {
    final rainCodes = [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82, 95, 96, 99];
    if (rainCodes.contains(current.weatherCode) || current.precipitation > 0.05) {
      return true;
    }
    // Check if daily rain prob > 40%
    if (daily.isNotEmpty && daily.first.precipitationProbability >= 40) {
      return true;
    }
    return false;
  }

  String get umbrellaAdvice {
    if (needsUmbrella) {
      return 'Cần mang dù / áo mưa! Có mưa hoặc khả năng mưa cao trong ngày, nhớ mang theo kẻo ướt.';
    }
    return 'Không cần dù! Trời khô ráo, tạnh ráo, bạn hoàn toàn yên tâm ra đường mà không lo ướt.';
  }

  /// Khuyến nghị: Nên mặc trang phục gì?
  String get outfitAdvice {
    final t = current.apparentTemperature;
    if (t >= 33) {
      return 'Trời cực nóng bức (${current.temperature.toStringAsFixed(1)}°C)! Ưu tiên quần áo mỏng, cộc tay thấm mồ hôi, đội nón và thoa kem chống nắng.';
    } else if (t >= 25) {
      return 'Thời tiết ấm áp thoải mái. Mặc áo thun, sơ mi mỏng hoặc quần áo thường nhật năng động.';
    } else if (t >= 19) {
      return 'Thời tiết se se lạnh (${current.temperature.toStringAsFixed(1)}°C). Bạn nên khoác thêm áo khoác nhẹ, cardigan hoặc áo dài tay.';
    } else if (t >= 14) {
      return 'Trời trở lạnh. Hãy mặc áo len mỏng, áo khoác gió ấm áp để giữ ấm cổ và cơ thể.';
    } else {
      return 'Trời rất rét! Hãy mặc áo ấm dày, quàng khăn cổ và găng tay để tránh cảm lạnh.';
    }
  }

  /// Khuyến nghị: Hoạt động ngoài trời (Chạy bộ, dã ngoại, đạp xe)
  String get activityAdvice {
    final rainCodes = [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82, 95, 96, 99];
    if (rainCodes.contains(current.weatherCode) || current.precipitation > 0.2) {
      return 'Hạn chế thể thao ngoài trời vì đường trơn và có mưa. Bạn nên tập gym trong nhà hoặc nghỉ ngơi thư giãn.';
    }
    if (current.windSpeed > 35) {
      return 'Gió giật mạnh (${current.windSpeed.toStringAsFixed(1)} km/h). Tránh chạy bộ dưới hàng cây lớn hoặc di chuyển tốc độ cao.';
    }
    if (current.temperature > 34) {
      return 'Nắng gắt gay gắt. Tránh vận động ngoài trời vào buổi trưa và đầu giờ chiều để không bị sốc nhiệt.';
    }
    return 'Thời tiết rất lý tưởng! Rất thích hợp để đi dạo, chạy bộ, đạp xe cà phê cùng bạn bè.';
  }
}
