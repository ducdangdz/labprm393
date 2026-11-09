import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/city_search_dialog.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_view.dart';
import '../widgets/error_view.dart';
import '../widgets/hourly_forecast_view.dart';
import '../widgets/recommendation_card.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final WeatherService _weatherService = WeatherService();
  late CityModel _selectedCity;
  late Future<WeatherModel> _weatherFuture;

  @override
  void initState() {
    super.initState();
    // Default city: Hà Nội
    _selectedCity = CityModel.defaultCities.first;
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(
        latitude: _selectedCity.latitude,
        longitude: _selectedCity.longitude,
      );
    });
  }

  Future<void> _handleRefresh() async {
    _loadWeather();
    await _weatherFuture;
  }

  void _onSelectCity(CityModel city) {
    if (city.latitude != _selectedCity.latitude ||
        city.longitude != _selectedCity.longitude) {
      setState(() {
        _selectedCity = city;
      });
      _loadWeather();
    }
  }

  Future<void> _openSearchDialog() async {
    final CityModel? result = await showDialog<CityModel>(
      context: context,
      builder: (_) => CitySearchDialog(weatherService: _weatherService),
    );

    if (result != null) {
      _onSelectCity(result);
    }
  }

  @override
  void dispose() {
    _weatherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.wb_sunny_rounded,
                color: Colors.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather Companion',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Trợ lý thời tiết & gợi ý đời sống',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tìm kiếm thành phố',
            icon: const Icon(Icons.search_rounded, color: Colors.black87),
            onPressed: _openSearchDialog,
          ),
          IconButton(
            tooltip: 'Làm mới dữ liệu',
            icon: const Icon(Icons.refresh_rounded, color: Colors.black87),
            onPressed: _loadWeather,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Quick City Selector Chips Bar
          _buildQuickCityBar(),

          // Main Body with FutureBuilder
          Expanded(
            child: FutureBuilder<WeatherModel>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Đang tải dữ liệu thời tiết...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 2. Error State with Retry action
                if (snapshot.hasError) {
                  return ErrorView(
                    errorMessage: snapshot.error.toString(),
                    onRetry: _loadWeather,
                  );
                }

                // 3. Success State
                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Current Weather Card
                          CurrentWeatherCard(
                            weather: weather,
                            city: _selectedCity,
                          ),

                          const SizedBox(height: 18),

                          // Purpose-driven Recommendation Card (Lab 8B Highlight)
                          RecommendationCard(weather: weather),

                          const SizedBox(height: 20),

                          // 24h Hourly Forecast
                          HourlyForecastView(hourlyList: weather.hourly),

                          const SizedBox(height: 20),

                          // 7-day Daily Forecast
                          DailyForecastView(
                            dailyList: weather.daily,
                            city: _selectedCity,
                          ),

                          const SizedBox(height: 24),

                          // Footer Info
                          Center(
                            child: Text(
                              'Dữ liệu cung cấp bởi Open-Meteo REST API • Tự động cập nhật',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                }

                // Fallback / Empty
                return const Center(
                  child: Text('Không có dữ liệu thời tiết.'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCityBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: CityModel.defaultCities.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Search / More button
            return ActionChip(
              avatar: const Icon(Icons.add_location_alt_outlined, size: 16),
              label: const Text('Tìm khác...'),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
              onPressed: _openSearchDialog,
            );
          }

          final city = CityModel.defaultCities[index - 1];
          final isSelected = city.id == _selectedCity.id ||
              (city.latitude == _selectedCity.latitude &&
                  city.longitude == _selectedCity.longitude);

          return ChoiceChip(
            label: Text(city.name),
            selected: isSelected,
            selectedColor: Colors.blue.shade600,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            ),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
            onSelected: (_) => _onSelectCity(city),
          );
        },
      ),
    );
  }
}
