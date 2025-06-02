class UserProfile {
  final String name;
  final String surname;
  final String email;
  final String role;
  final String phone;
  final String id;

  UserProfile({
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.phone,
    required this.id
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
    };
  }

}
