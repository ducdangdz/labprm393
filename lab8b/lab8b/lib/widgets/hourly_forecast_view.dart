import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class HourlyForecastView extends StatelessWidget {
  final List<HourlyForecast> hourlyList;

  const HourlyForecastView({super.key, required this.hourlyList});

  @override
  Widget build(BuildContext context) {
    if (hourlyList.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                'Dự báo theo giờ (24 giờ tới)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 125,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hourlyList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = hourlyList[index];
              final timeStr = DateFormat('HH:mm').format(item.time);
              final isNow = index == 0;

              return Container(
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isNow
                      ? Colors.blue.shade600
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isNow ? Colors.blue.shade700 : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isNow ? 'Bây giờ' : timeStr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isNow ? FontWeight.bold : FontWeight.w500,
                        color: isNow ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    Icon(
                      WeatherModel.getWeatherIcon(item.weatherCode),
                      color: isNow
                          ? Colors.white
                          : WeatherModel.getWeatherColor(item.weatherCode),
                      size: 28,
                    ),
                    Text(
                      '${item.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isNow ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
