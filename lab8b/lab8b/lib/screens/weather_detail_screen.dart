import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';

class WeatherDetailScreen extends StatelessWidget {
  final CityModel city;
  final DailyForecast forecast;

  const WeatherDetailScreen({
    super.key,
    required this.city,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, dd/MM/yyyy', 'vi').format(forecast.date);
    final formattedDate = dateStr.isNotEmpty
        ? '${dateStr[0].toUpperCase()}${dateStr.substring(1)}'
        : dateStr;

    final isRainy = forecast.precipitationProbability >= 40 ||
        [51, 53, 55, 61, 63, 65, 80, 81, 82, 95].contains(forecast.weatherCode);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          city.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Icon(
                    WeatherModel.getWeatherIcon(forecast.weatherCode),
                    size: 72,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    WeatherModel.getWeatherDescription(forecast.weatherCode),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTempBadge(
                        'Cao nhất',
                        '${forecast.maxTemp.round()}°C',
                        Icons.arrow_upward_rounded,
                        Colors.orange.shade200,
                      ),
                      const SizedBox(width: 20),
                      _buildTempBadge(
                        'Thấp nhất',
                        '${forecast.minTemp.round()}°C',
                        Icons.arrow_downward_rounded,
                        Colors.lightBlue.shade200,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Metrics Section
            Text(
              'Chỉ số chi tiết',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.water_drop_rounded,
                    iconColor: Colors.blue,
                    title: 'Xác suất mưa',
                    value: '${forecast.precipitationProbability}%',
                    subtitle: forecast.precipitationProbability > 50
                        ? 'Khả năng có mưa rất cao'
                        : 'Ít khả năng mưa',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.device_thermostat_rounded,
                    iconColor: Colors.deepOrange,
                    title: 'Chênh lệch nhiệt',
                    value:
                        '${(forecast.maxTemp - forecast.minTemp).toStringAsFixed(1)}°C',
                    subtitle: 'Dao động ngày đêm',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Advice Section
            Text(
              'Lời khuyên kế hoạch cho ngày này',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor:
                            isRainy ? Colors.blue.shade50 : Colors.green.shade50,
                        child: Icon(
                          isRainy ? Icons.umbrella : Icons.beach_access,
                          color: isRainy ? Colors.blue : Colors.green,
                        ),
                      ),
                      title: Text(
                        isRainy ? 'Nên chuẩn bị dù/áo mưa' : 'Không cần dù',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        isRainy
                            ? 'Xác suất mưa ${forecast.precipitationProbability}%, hãy lên phương án dự phòng cho kế hoạch di chuyển.'
                            : 'Thời tiết thuận tiện cho công việc và vui chơi ngoài trời.',
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade50,
                        child: Icon(
                          Icons.travel_explore,
                          color: Colors.purple.shade600,
                        ),
                      ),
                      title: const Text(
                        'Kế hoạch di chuyển & du lịch',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        forecast.maxTemp >= 32
                            ? 'Nhiệt độ khá cao, hạn chế di chuyển vào giữa trưa.'
                            : (forecast.minTemp <= 16
                                ? 'Buổi sáng và đêm trời khá lạnh, nhớ mang theo áo khoác ấm.'
                                : 'Điều kiện thời tiết ổn định, thích hợp cho lịch trình di chuyển.'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempBadge(
    String label,
    String temp,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          temp,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
