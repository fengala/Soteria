class User {
  final String uid;

  final String name;

  final String password;

  final String phone_number;

  final List<String> emergency_contacts;

  final String username;

  User(
      {this.uid,
      this.emergency_contacts,
      this.name,
      this.password,
      this.phone_number,
      this.username});
}
