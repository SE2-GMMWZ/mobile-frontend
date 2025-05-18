class UserProfile {
  final String name;
  final String surname;
  final String email;
  final String role;
  final String phone;

  UserProfile({
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.phone,
  });
}

late UserProfile tempUser;

@override
void initState() {
  tempUser = UserProfile(
    name: 'Kasia',
    surname: 'Kowalska',
    email: 'kkowalska@gmail.com',
    role: 'Sailor',
    phone: '+48 123 456 789',
  );
}
