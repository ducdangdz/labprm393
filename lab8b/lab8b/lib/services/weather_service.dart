import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';
import '../models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  final int? statusCode;

  const WeatherException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class WeatherService {
  final http.Client _client;
  static const Duration _timeoutDuration = Duration(seconds: 10);

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Lấy thông tin thời tiết theo tọa độ vĩ độ / kinh độ
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m'
      '&hourly=temperature_2m,weather_code'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
      '&timezone=auto'
      '&forecast_days=7',
    );

    try {
      final response = await _client.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return WeatherModel.fromJson(data);
      } else {
        throw WeatherException(
          'Máy chủ trả về mã lỗi: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const WeatherException(
        'Không thể kết nối Internet. Vui lòng kiểm tra lại kết nối mạng Wifi/4G của bạn.',
      );
    } on TimeoutException {
      throw const WeatherException(
        'Yêu cầu lấy dữ liệu thời tiết đã quá hạn (Timeout). Vui lòng thử lại sau giây lát.',
      );
    } on http.ClientException catch (e) {
      throw WeatherException('Lỗi mạng truyền thông: ${e.message}');
    } on FormatException {
      throw const WeatherException('Lỗi cấu trúc dữ liệu phản hồi từ máy chủ.');
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Đã xảy ra lỗi không xác định: $e');
    }
  }

  /// Tìm kiếm thành phố theo tên bằng Geocoding API
  Future<List<CityModel>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search'
      '?name=${Uri.encodeComponent(trimmed)}'
      '&count=8'
      '&language=vi'
      '&format=json',
    );

    try {
      final response = await _client.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        if (data.containsKey('results') && data['results'] is List) {
          final results = data['results'] as List<dynamic>;
          return results
              .map((item) => CityModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw WeatherException(
          'Không thể tìm kiếm thành phố (Mã lỗi: ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const WeatherException('Mất kết nối mạng khi tìm kiếm thành phố.');
    } on TimeoutException {
      throw const WeatherException('Hết thời gian chờ phản hồi tìm kiếm.');
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Lỗi tìm kiếm: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
