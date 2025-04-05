class UserProfile {
  final String name;
  final String surname;
  final String email;
  final String userType;
  final String phone;

  UserProfile({
    required this.name,
    required this.surname,
    required this.email,
    required this.userType,
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
    userType: 'Sailor',
    phone: '+48 123 456 789',
  );
}