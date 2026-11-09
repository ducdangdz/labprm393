class Student {
  final int id;
  final String name;
  final String email;
  final String major;
  final double gpa;
  final String phone;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.gpa,
    required this.phone,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      major: json['major'] as String? ?? '',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'major': major,
      'gpa': gpa,
      'phone': phone,
    };
  }
}
