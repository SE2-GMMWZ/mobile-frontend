class UserProfile {
  final String name;
  final String surname;
  final String email;
  final String role;
  final String phone;
  final String? id;

  UserProfile({
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.phone,
    this.id
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      id: json['id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
      'id': id,
    };
  }
}


