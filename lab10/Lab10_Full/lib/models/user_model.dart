/// Unified user model for Lab 10 Full project
class UserModel {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String image;
  final String token;
  final String authProvider; // 'DummyJSON REST API' or 'Firebase Google Sign-In'

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.image,
    required this.token,
    required this.authProvider,
  });

  factory UserModel.fromDummyJson(Map<String, dynamic> json) {
    final first = json['firstName'] as String? ?? '';
    final last = json['lastName'] as String? ?? '';
    return UserModel(
      id: (json['id'] ?? '').toString(),
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: ('$first $last').trim().isEmpty ? (json['username'] ?? 'User') : '$first $last',
      image: json['image'] as String? ?? '',
      token: (json['accessToken'] ?? json['token']) as String? ?? '',
      authProvider: 'DummyJSON REST API',
    );
  }

  factory UserModel.fromGoogle({
    required String uid,
    required String displayName,
    required String email,
    String? photoUrl,
    String? token,
  }) {
    return UserModel(
      id: uid,
      username: email.split('@').first,
      email: email,
      fullName: displayName.isNotEmpty ? displayName : 'Google User',
      image: photoUrl ?? '',
      token: token ?? 'google_oauth_token_$uid',
      authProvider: 'Firebase Google Sign-In',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      image: json['image'] as String? ?? '',
      token: json['token'] as String? ?? '',
      authProvider: json['authProvider'] as String? ?? 'Custom Auth',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'fullName': fullName,
        'image': image,
        'token': token,
        'authProvider': authProvider,
      };
}
