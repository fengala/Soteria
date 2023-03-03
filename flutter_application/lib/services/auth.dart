import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'database.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class UserAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  User user;
  UserModel user1;

  Future createUser(String email, String password, String name,
      String phone_number, emergency_contacts) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential res = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    this.user = res.user;

    print(user.uid);

    await DatabaseService(uid: user.uid).register(
        email, password, name, emergency_contacts, phone_number, false);
    this.user.sendEmailVerification();

    return user;
  }

  Future signIn(String email, String password) async {
    UserCredential res =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    User user = res.user;

    print(res);
    return user;
  }

  static String errors(String code) {
    switch (code) {
      case 'EMAIL_ALREADY_IN_USE':
        return "This email is already in use";
      default:
        return "Authentication Failed";
    }
  }

  Future resetPassword(String password) async {
    // await auth.signInWithEmailAndPassword(
    //   email: this.user1.username, password: this.user1.password);
    this.user.reauthenticateWithCredential(EmailAuthProvider.credential(
        email: this.user.email, password: this.user1.password));
    this.user.updatePassword(password);

    this.user1.password = password;

    var res = await DatabaseService(uid: user.uid).resetPassword(password);

    final email = "appsoteria307@gmail.com";
    final token = "";

    final smtp = gmail(email, "okhvqhdvaltmynjw");

    final message = Message()
      ..from = Address(email, "Soteria")
      ..subject = "Password Reset"
      ..recipients = [this.user.email]
      ..text = "Your password for your Soteria account has been updated";

    await send(message, smtp);

    return res;
  }

  static Future staySignedIn() async {
    var res = await auth.setPersistence(Persistence.LOCAL);

    return res;
  }

  Future SignOut() async {
    var res = await auth.signOut();
    return res;
  }
}
