import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class RecommendationCard extends StatelessWidget {
  final WeatherModel weather;

  const RecommendationCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUmbrellaNeeded = weather.needsUmbrella;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade50,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tips_and_updates_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Gợi ý & Lời khuyên thông minh',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Item 1: Dù / Áo mưa
            _buildRecommendationItem(
              icon: isUmbrellaNeeded
                  ? Icons.umbrella_rounded
                  : Icons.wb_sunny_outlined,
              iconColor: isUmbrellaNeeded ? Colors.blue.shade800 : Colors.orange.shade800,
              iconBgColor: isUmbrellaNeeded
                  ? Colors.blue.shade100
                  : Colors.orange.shade100,
              title: isUmbrellaNeeded
                  ? 'Cần mang dù / áo mưa ☔'
                  : 'Không cần mang dù ☀️',
              description: weather.umbrellaAdvice,
              badgeText: isUmbrellaNeeded ? 'Chú ý có mưa' : 'Thời tiết khô ráo',
              badgeColor: isUmbrellaNeeded ? Colors.blue : Colors.green,
            ),

            const Divider(height: 24, thickness: 1),

            // Item 2: Trang phục
            _buildRecommendationItem(
              icon: Icons.checkroom_rounded,
              iconColor: Colors.deepPurple.shade700,
              iconBgColor: Colors.deepPurple.shade50,
              title: 'Gợi ý trang phục mặc hôm nay 👕',
              description: weather.outfitAdvice,
              badgeText: 'Cảm giác: ${weather.current.apparentTemperature.toStringAsFixed(1)}°C',
              badgeColor: Colors.deepPurple,
            ),

            const Divider(height: 24, thickness: 1),

            // Item 3: Thể thao / Hoạt động ngoài trời
            _buildRecommendationItem(
              icon: Icons.directions_run_rounded,
              iconColor: Colors.teal.shade800,
              iconBgColor: Colors.teal.shade100,
              title: 'Hoạt động & Thể thao ngoài trời 🏃',
              description: weather.activityAdvice,
              badgeText: 'Gió: ${weather.current.windSpeed.toStringAsFixed(1)} km/h',
              badgeColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String badgeText,
    required MaterialColor badgeColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeColor.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
