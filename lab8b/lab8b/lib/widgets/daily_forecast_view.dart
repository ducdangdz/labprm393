import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../screens/weather_detail_screen.dart';

class DailyForecastView extends StatelessWidget {
  final List<DailyForecast> dailyList;
  final CityModel city;

  const DailyForecastView({
    super.key,
    required this.dailyList,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyList.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      size: 20, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Text(
                    'Dự báo 7 ngày tới',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ],
              ),
              Text(
                'Nhấn xem chi tiết ❯',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dailyList.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final day = dailyList[index];
                String title;

                if (index == 0) {
                  title = 'Hôm nay';
                } else if (index == 1) {
                  title = 'Ngày mai';
                } else {
                  final dayName = DateFormat('EEEE', 'vi').format(day.date);
                  title = dayName.isNotEmpty
                      ? '${dayName[0].toUpperCase()}${dayName.substring(1)}'
                      : dayName;
                }

                final dateStr = DateFormat('dd/MM').format(day.date);

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeatherDetailScreen(
                          city: city,
                          forecast: day,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        // Day and Date
                        SizedBox(
                          width: 95,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dateStr,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Rain probability
                        SizedBox(
                          width: 65,
                          child: Row(
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 14,
                                color: day.precipitationProbability > 20
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${day.precipitationProbability}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: day.precipitationProbability > 40
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Weather Icon & Status
                        Icon(
                          WeatherModel.getWeatherIcon(day.weatherCode),
                          color: WeatherModel.getWeatherColor(day.weatherCode),
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            WeatherModel.getWeatherDescription(day.weatherCode),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Min - Max Temp
                        Row(
                          children: [
                            Text(
                              '${day.minTemp.round()}°',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 38,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.orange.shade400,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${day.maxTemp.round()}°',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
