import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b/models/city_model.dart';
import 'package:lab8b/models/weather_model.dart';

void main() {
  group('CityModel Tests', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1581130,
        'name': 'Hà Nội',
        'latitude': 21.0285,
        'longitude': 105.8542,
        'country': 'Việt Nam',
        'admin1': 'Hà Nội',
      };
      final city = CityModel.fromJson(json);
      expect(city.name, 'Hà Nội');
      expect(city.country, 'Việt Nam');
      expect(city.latitude, 21.0285);
      expect(city.displayName, contains('Hà Nội'));
    });
  });

  group('WeatherModel Tests', () {
    test('fromJson and purpose-driven recommendations work as expected', () {
      final sampleJson = {
        'latitude': 21.0285,
        'longitude': 105.8542,
        'timezone': 'Asia/Bangkok',
        'current': {
          'time': '2026-11-09T14:00',
          'temperature_2m': 18.5,
          'apparent_temperature': 17.0,
          'relative_humidity_2m': 75,
          'precipitation': 1.2, // Rain detected
          'wind_speed_10m': 15.0,
          'weather_code': 61, // Rain
          'is_day': 1,
        },
        'daily': {
          'time': ['2026-11-09', '2026-11-10'],
          'weather_code': [61, 3],
          'temperature_2m_max': [22.0, 24.0],
          'temperature_2m_min': [16.0, 17.0],
          'precipitation_probability_max': [85, 20],
        },
        'hourly': {
          'time': ['2026-11-09T14:00', '2026-11-09T15:00'],
          'temperature_2m': [18.5, 18.0],
          'weather_code': [61, 61],
        },
      };

      final weather = WeatherModel.fromJson(sampleJson);

      expect(weather.current.temperature, 18.5);
      expect(weather.current.relativeHumidity, 75);
      expect(weather.daily.length, 2);
      expect(weather.hourly.length, 2);

      // Purpose-driven recommendation assertions:
      expect(weather.needsUmbrella, isTrue);
      expect(weather.umbrellaAdvice, contains('Cần mang dù'));
      expect(weather.outfitAdvice, contains('Trời trở lạnh'));
      expect(weather.activityAdvice, contains('Hạn chế thể thao ngoài trời'));
    });
  });
}
