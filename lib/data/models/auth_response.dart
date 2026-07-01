class AuthResponse {
  final String accessToken;
  final String tokenType;
  final Map<String, dynamic> user;
  final List<dynamic> institutions;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.institutions,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken:  json['access_token'],
      tokenType:    json['token_type'],
      user:         json['user'] as Map<String, dynamic>,
      institutions: json['institutions'] as List<dynamic>? ?? [],
    );
  }
}
