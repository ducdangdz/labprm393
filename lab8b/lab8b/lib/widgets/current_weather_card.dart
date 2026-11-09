import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final CityModel city;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    final cur = weather.current;
    final dateStr = DateFormat('EEEE, dd/MM/yyyy', 'vi').format(cur.time);

    // Capitalize first letter of dateStr
    final formattedDate = dateStr.isNotEmpty
        ? '${dateStr[0].toUpperCase()}${dateStr.substring(1)}'
        : dateStr;

    final todayDaily = weather.daily.isNotEmpty ? weather.daily.first : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: cur.isDay
              ? [const Color(0xFF2193b0), const Color(0xFF6dd5ed)]
              : [const Color(0xFF141E30), const Color(0xFF243B55)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (cur.isDay ? Colors.cyan : Colors.blueGrey).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City Name & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            city.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (city.country != null && city.country!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 2),
                        child: Text(
                          city.country!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cur.isDay ? 'Ban ngày ☀️' : 'Ban đêm 🌙',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              formattedDate,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Main Temperature & Weather Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cur.temperature.round().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    WeatherModel.getWeatherDescription(cur.weatherCode),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (todayDaily != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Cao nhất ${todayDaily.maxTemp.round()}° • Thấp nhất ${todayDaily.minTemp.round()}°',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Icon(
                  WeatherModel.getWeatherIcon(cur.weatherCode, isDay: cur.isDay),
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  icon: Icons.thermostat_rounded,
                  label: 'Cảm giác',
                  value: '${cur.apparentTemperature.round()}°C',
                ),
                _buildMetric(
                  icon: Icons.water_drop_outlined,
                  label: 'Độ ẩm',
                  value: '${cur.relativeHumidity}%',
                ),
                _buildMetric(
                  icon: Icons.air_rounded,
                  label: 'Tốc độ gió',
                  value: '${cur.windSpeed.round()} km/h',
                ),
                _buildMetric(
                  icon: Icons.grain_rounded,
                  label: 'Lượng mưa',
                  value: '${cur.precipitation.toStringAsFixed(1)} mm',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
