class CityModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;

  const CityModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] is int ? json['id'] as int : 0,
      name: json['name'] as String? ?? 'Chưa rõ',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
    };
  }

  String get displayName {
    final parts = <String>[name];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  static List<CityModel> get defaultCities => const [
        CityModel(
          id: 1581130,
          name: 'Hà Nội',
          latitude: 21.0285,
          longitude: 105.8542,
          country: 'Việt Nam',
          admin1: 'Hà Nội',
        ),
        CityModel(
          id: 1566083,
          name: 'TP. Hồ Chí Minh',
          latitude: 10.8231,
          longitude: 106.6297,
          country: 'Việt Nam',
          admin1: 'Hồ Chí Minh',
        ),
        CityModel(
          id: 1583992,
          name: 'Đà Nẵng',
          latitude: 16.0544,
          longitude: 108.2022,
          country: 'Việt Nam',
          admin1: 'Đà Nẵng',
        ),
        CityModel(
          id: 1850147,
          name: 'Tokyo',
          latitude: 35.6762,
          longitude: 139.6503,
          country: 'Nhật Bản',
          admin1: 'Tokyo',
        ),
        CityModel(
          id: 2643743,
          name: 'London',
          latitude: 51.5074,
          longitude: -0.1278,
          country: 'Vương Quốc Anh',
          admin1: 'England',
        ),
        CityModel(
          id: 5128581,
          name: 'New York',
          latitude: 40.7128,
          longitude: -74.0060,
          country: 'Hoa Kỳ',
          admin1: 'New York',
        ),
      ];
}
