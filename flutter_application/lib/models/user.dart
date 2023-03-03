class UserModel {
  String uid;

  String name;

  String password;

  String phone_number;

  List emergency_contacts;

  String username;

  List upvotedPetitions;
  List upvotedEvents;
  List RSVPEvents;
  bool loggedIn;
  bool verified;

  UserModel(uid, name, username, password, emergency_contacts, phone_number,
      loggedIn, verified) {
    this.uid = uid;
    this.name = name;
    this.username = username;
    this.password = password;
    this.emergency_contacts = emergency_contacts;
    this.phone_number = phone_number;
    this.upvotedPetitions = [];
    this.upvotedEvents = [];
    this.RSVPEvents = [];
    this.loggedIn = false;
    this.verified = false;
  }
  void setVerified(bool value) {
    this.verified = value;
  }
}
