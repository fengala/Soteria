class User {
  final String uid;

  final String name;

  final String password;

  final String phone_number;

  final List<String> emergency_contacts;

  final String username;

  User(
      {required this.uid,
        required this.emergency_contacts,
        required this.name,
        required this.password,
        required this.phone_number,
        required this.username});
}